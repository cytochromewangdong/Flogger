//
//  FeedsViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FeedsViewController.h"
#import "IssueInfoCom.h"
#import "FeedViewerViewController.h"
#import "FloggerPopMenuView.h"
#import "SuggestionUserViewController.h"
#import "ShareFeedViewController.h"
#import "MyAccount.h"
#import "ProfileViewController.h"
#import "DataCache.h"
#import "SBJson.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import "SettingViewController.h"
#import "InviteFriendViewController.h"
#import "FloggerInstructionView.h"
#import "UIViewController+iconImage.h"
#import "GlobalData.h"
#define kTagFollow 30000
#define kTagPopular 30001
#define kTagFeature 30002

#define kTagPopularPhoto 31001
#define kTagPopularVideo 31002

#define kTagFeaturePhoto 32001
#define kTagFeatureVideo 32002

#define kTagFollowBtn 30003
#define kTagPopularBtn 30004
#define kTagFeatureBtn 30005

#define kCurrentAction @"feed"
#define kPageSize 60

NSString * const kFollowingChangedNotification    = @"kFollowingChangedNotification";

NSString * const kTweetChangedNotification    = @"kTweetChangedNotification";

@interface FeedsViewController ()
@property(nonatomic, assign) BOOL followChanged, tweetChanged;

@end

@implementation FeedsViewController
@synthesize contentView, issueinfoCategory, isLoadingFollow = _isLoadingFollow, isLoadingPopular = _isLoadingPopular, isLoadingFeaturePhoto = _isLoadingFeaturePhoto, isLoadingFeatureVideo = _isLoadingFeatureVideo, followChanged, tweetChanged;

-(void)refreshTweet
{
    self.followChanged = YES;
}

-(void)refreshLatestTweet
{
    self.tweetChanged = YES;
}

- (void) refreshAction:(NSNotification *)notification
{
    [self doRequestFollowByMediaTypeRefresh];
//    issueinfoCategory = -1;
//    _followView.startId = [NSNumber numberWithInt:-1];
//    [self doRequestFollowByMediaType:issueinfoCategory isMore:NO];
}


-(void) dataChangeAction : (NSNotification *) notification
{
//    NSNumber *issueId = (NSNumber *) notification.object;
//    NSMutableDictionary *dataNotifiaction = [NSMutableDictionary *] notification.
    
    if(!_followView || !_followView.dataArr)
    {
        [[DataCache sharedInstance]removeDataForKey:kDataCacheFeedData Category:kDataCacheTempDataCategory]; 
        return;
    }
    NSMutableDictionary *data = (NSMutableDictionary *) notification.object;

    if ([kNotificationPostAction isEqualToString:[data objectForKey:kNotificationAction]]) 
    {
        //from notificaton to tranIssueInfo
        MyIssueInfo *notificationIssueInfo = [data objectForKey:kNotificationInfoIssueThread];
        MyIssueInfo *tranIssueInfo = [[[MyIssueInfo alloc] init] autorelease];
        tranIssueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:notificationIssueInfo.dataDict];      
        if(!tranIssueInfo.id)
        {
            [_followView.dataArr insertObject:tranIssueInfo atIndex:0];
        } else {
            NSString *transLocalID =  [tranIssueInfo.dataDict objectForKey:kLocalIssueID];
            BOOL found = NO;
            for (int i = 0; i < [_followView.dataArr count]; i++) {
                Issueinfo *currentIssueInfo = [_followView.dataArr objectAtIndex:i];
                NSString * currentLocalID = [currentIssueInfo.dataDict objectForKey:kLocalIssueID];
                if ([currentLocalID isEqualToString:transLocalID]) {
                    currentIssueInfo.dataDict = tranIssueInfo.dataDict;
                    found = YES;
                    break;
                }
            }
            if(!found)
            {
                [_followView.dataArr insertObject:tranIssueInfo atIndex:0];
            }
        }
        if (self.isViewLoaded && self.view.window) {
            [_followView.tableView reloadData];
            [self viewScrollToTop];
        } else {
            _isDataChange = TRUE;
            
            _isScrollTop = TRUE;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveDataToFile];
        });  
        return;
    } else if ([kNotificationDeleteAction isEqualToString:[data objectForKey:kNotificationAction]])
    {
        NSNumber *issueId = [data objectForKey:kNotificationInfoIssueId];
        for (int i = 0; i < [_followView.dataArr count]; i++) {
            Issueinfo *issueInfo = [_followView.dataArr objectAtIndex:i];
            if ([issueInfo.id isEqualToNumber:issueId]) {
                [_followView.dataArr removeObjectAtIndex:i]; 
                _isDataChange = YES;
                break;
            }
        }  
        //delete inspire mark
        for (int i = 0; i < [_followView.dataArr count]; i++) {
            Issueinfo *issueInfo = [_followView.dataArr objectAtIndex:i];
            if ([issueInfo.parentid isEqualToNumber:issueId]) {
                issueInfo.parentid = nil;
                _isDataChange = YES;
            }
        }        
        if (_isDataChange) {
            if (self.isViewLoaded && self.view.window) {
                _isDataChange = NO;
                [_followView.tableView reloadData];
            }
            [self saveDataToFile];
        }
        
    } else if ([kNotificationCommentAction isEqualToString:[data objectForKey:kNotificationAction]])
    {
//        Issueinfo *issueInfo = [data objectForKey:kNotificationInfoIssueThread];
        //from notificaton to tranIssueInfo
        MyIssueInfo *notificationIssueInfo = [data objectForKey:kNotificationInfoIssueThread];
        MyIssueInfo *tranIssueInfo = [[[MyIssueInfo alloc] init] autorelease];
        tranIssueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:notificationIssueInfo.dataDict]; 
        
//        if ([tranIssueInfo.issuecategory intValue] != 3) {
//            [_followView.dataArr insertObject:tranIssueInfo atIndex:0];            
//        }
//        int currentDataIndex = -1;
        for (int i = 0; i < [_followView.dataArr count]; i++) {
            Issueinfo *parentIssueInfo = [_followView.dataArr objectAtIndex:i];
            if ([parentIssueInfo.id isEqualToNumber:tranIssueInfo.parentid]) {
                if(!tranIssueInfo.id){
                    NSMutableArray *cmtList = ((MyIssueInfo *)parentIssueInfo).commentList;
                    [cmtList addObject:tranIssueInfo];
                    if(cmtList.count>3)
                    {
                        [cmtList removeObjectAtIndex:0];
                    }
                    ((MyIssueInfo *)parentIssueInfo).commentList = cmtList;
                    parentIssueInfo.commentcnt =  [NSNumber numberWithInt:([parentIssueInfo.commentcnt intValue] + 1)];
                    currentDataRow = i;
                      
                } else {
                    NSMutableArray *cmtList = ((MyIssueInfo *)parentIssueInfo).commentList;
                    NSString *transLocalID =  [tranIssueInfo.dataDict objectForKey:kLocalIssueID];
                    for (Issueinfo *child in cmtList) {
                        NSString * currentLocalID = [child.dataDict objectForKey:kLocalIssueID];
                        if ([currentLocalID isEqualToString:transLocalID]) {
                            child.dataDict = tranIssueInfo.dataDict;
                            break;
                        }
                    }
                    ((MyIssueInfo *)parentIssueInfo).commentList = cmtList;
                    currentDataRow = i;
                }
                currentDataRow = i;
                break;
            }
        }    
        if (self.isViewLoaded && self.view.window) {
            [_followView.tableView reloadData];
            if ([tranIssueInfo.issuecategory intValue] != 3) {
                [self viewScrollToCellBottom];
            }
        } else {
            _isDataChange = TRUE;   
            if ([tranIssueInfo.issuecategory intValue] != 3) {
                _isScrollTop = TRUE;
            };
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveDataToFile];
        });  
        return;
        
    } else if ([kNotificationLikeAction isEqualToString:[data objectForKey:kNotificationAction]])
    {
        NSNumber *issueId = [data objectForKey:kNotificationInfoIssueId];
        for (int i = 0; i < [_followView.dataArr count]; i++) {
            Issueinfo *issueInfo = [_followView.dataArr objectAtIndex:i];
            MyIssueInfo * myIssueInfor = (MyIssueInfo *)issueInfo;
            if ([issueInfo.id isEqualToNumber:issueId]) {
       

                
                AccountCom *com =[GlobalData sharedInstance].myAccount;
                if(myIssueInfor.likerList.count==0&&[myIssueInfor.likecnt intValue]>1){
                           myIssueInfor.likers=[NSString stringWithFormat:NSLocalizedString(@"%d people",@"%d people"),[ myIssueInfor.id longLongValue ],[myIssueInfor.likecnt intValue]+1];
                }else{
                    NSMutableString * strName=[NSMutableString stringWithFormat:@"<A href='at://doaction?%lli'>%@</A>" ,[com.account.useruid longLongValue],com.account.username];
                    if(myIssueInfor.likers)
                    {
                        [strName appendFormat:@", %@",myIssueInfor.likers];
                    } 
                    myIssueInfor.likers  = strName;
                    
                    Likeinfo* objLikeinfo=[[[Likeinfo alloc]init]autorelease];
                    objLikeinfo.username=com.account.username;
                    objLikeinfo.useruid=com.account.useruid;
                    NSMutableArray *likerList = myIssueInfor.likerList;
                    [likerList  addObject:objLikeinfo];
                    myIssueInfor.likerList = likerList;
                }
                
                
                
                issueInfo.likecnt = [NSNumber numberWithInt:issueInfo.likecnt.intValue + 1];
                ((MyIssueInfo *)issueInfo).liked = [NSNumber numberWithBool:YES];
                
                if (self.isViewLoaded && self.view.window) {
                    [_followView.tableView reloadData];
                } else {
                    _isDataChange = TRUE;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self saveDataToFile];
                });            
                break;
            }
        }      
        
    } else if ([kNotificationUnLikeAction isEqualToString:[data objectForKey:kNotificationAction]])
    {
        
        NSNumber *issueId = [data objectForKey:kNotificationInfoIssueId];
        for (int i = 0; i < [_followView.dataArr count]; i++) {
            Issueinfo *issueInfo = [_followView.dataArr objectAtIndex:i];
            MyIssueInfo * myIssueInfor = (MyIssueInfo *)issueInfo;
            if ([issueInfo.id isEqualToNumber:issueId]) {
                AccountCom *com =[GlobalData sharedInstance].myAccount;
             
                if (myIssueInfor.likerList.count <=0) {
                    myIssueInfor.likers=[NSString stringWithFormat:NSLocalizedString(@"%d people",@"%d people"),[ myIssueInfor.id longLongValue ],[myIssueInfor.likecnt intValue]-1];
                }else{
                    NSMutableArray* objLikeinfoToRemove=[[NSMutableArray alloc] initWithCapacity:1];
                    NSMutableArray *likerList = myIssueInfor.likerList;
                    for (Likeinfo *objLikeinfoTemp in likerList) {
                        if ([com.account.useruid longLongValue] ==[objLikeinfoTemp.useruid longLongValue]) {
                            [objLikeinfoToRemove addObject:objLikeinfoTemp];
                        }
                    }
                    [likerList removeObjectsInArray:objLikeinfoToRemove];
                    [objLikeinfoToRemove release];
                    [myIssueInfor setLikerList:likerList];
                    if(myIssueInfor.likerList.count<1&& [myIssueInfor.likecnt intValue]<=1){
                        myIssueInfor.likers=nil;
                    }else{
                        NSMutableString *temp= [NSMutableString stringWithCapacity:myIssueInfor.likers.length];
                        NSMutableArray *likerList = myIssueInfor.likerList;
                        for (Likeinfo *objLikeinfoTemp in likerList) {
                            [temp appendFormat:@"<A href='at://doaction?%lli'>%@</A>, ",[objLikeinfoTemp.useruid longLongValue],objLikeinfoTemp.username];
                        }
                        temp=[temp substringToIndex:temp.length-2 ];
                        /*
                         NSMutableString * strName=[NSMutableString stringWithFormat:@"<A href='at://doaction?%lli'>%@</A>, "  ,[com.account.useruid longLongValue],com.account.username];
                         NSRange searchResult=[myIssueInfor.likers rangeOfString:strName];
                         NSMutableString *temp=[NSMutableString stringWithString:myIssueInfor.likers];
                         if (searchResult.location!=NSNotFound) {
                         [temp replaceCharactersInRange:searchResult withString:@""];
                         }else{
                         strName =[NSMutableString stringWithFormat:@", <A href='at://doaction?%lli'>%@</A>"  ,[com.account.useruid longLongValue],com.account.username];
                         searchResult=[myIssueInfor.likers rangeOfString:strName];
                         [temp replaceCharactersInRange:searchResult withString:@""];
                         }*/
                        myIssueInfor.likers=temp;  
                    }
                    
                }

                issueInfo.likecnt = [NSNumber numberWithInt:issueInfo.likecnt.intValue - 1];
                ((MyIssueInfo *)issueInfo).liked = [NSNumber numberWithBool:NO];
                
                if (self.isViewLoaded && self.view.window) {
                    [_followView.tableView reloadData];
                } else {
                    _isDataChange = TRUE;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self saveDataToFile];
                });            
                break;
            }
        } 
    }


}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:kShapeWeb object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:kCurrentAction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTweet) 
                                                 name:kFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshLatestTweet) 
                                                 name:kTweetChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction:) name:kUploadServerProxy object:nil];
    

}

-(void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShapeWeb object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCurrentAction object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTweetChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUploadServerProxy object:nil];
 
}

-(void)setIsLoadingFeaturePhoto:(BOOL)isLoadingFeaturePhoto
{
    _isLoadingFeaturePhoto = isLoadingFeaturePhoto;
    _featureView.leftPageView.isLoading = isLoadingFeaturePhoto;
    _featureView.leftPageView.isLoadingMore = isLoadingFeaturePhoto;
}

-(void)setIsLoadingFeatureVideo:(BOOL)isLoadingFeatureVideo
{
    _isLoadingFeatureVideo = isLoadingFeatureVideo;
    _featureView.rightPageView.isLoading = isLoadingFeatureVideo;
    _featureView.rightPageView.isLoadingMore = isLoadingFeatureVideo;
}

-(void)setIsLoadingFollow:(BOOL)isLoadingFollow
{
    _isLoadingFollow = isLoadingFollow;
    _followView.isLoading = isLoadingFollow;
//    _followView.isLoadingMore = isLoadingFollow;
}

-(void)setIsLoadingPopular:(BOOL)isLoadingPopular
{
    _isLoadingPopular = isLoadingPopular;
    _popularView.leftPageView.isLoading = isLoadingPopular;
    _popularView.rightPageView.isLoading = isLoadingPopular;
}

-(void)showView:(NSInteger)viewTag
{
    
    if (viewTag == kTagFollow) {
        [self setRightNavigationBarWithTitle:@"" image:SNS_SORT_BUTTON];
    }
    else
    {
        [self setRightNavigationBarWithTitle:nil image:nil];
    }
    
    UIView *view = [self.contentView viewWithTag:viewTag];
    NSInteger offset = -view.frame.origin.x;
    [UIView beginAnimations:nil context:nil];
    
    CGRect frame = CGRectMake(_followView.frame.origin.x + offset, _followView.frame.origin.y, _followView.frame.size.width, _followView.frame.size.height);
    _followView.frame = frame;
    
    frame = CGRectMake(_popularView.frame.origin.x + offset, _popularView.frame.origin.y, _popularView.frame.size.width, _popularView.frame.size.height);
    _popularView.frame = frame;
    
    frame = CGRectMake(_featureView.frame.origin.x + offset, _featureView.frame.origin.y, _featureView.frame.size.width, _featureView.frame.size.height);
    _featureView.frame = frame;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:500];
    [UIView commitAnimations];
}

-(void)btnTapped:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        return;
    }
    
    ((UIButton *)([self.view viewWithTag:kTagFollowBtn])).selected = NO;
    ((UIButton *)([self.view viewWithTag:kTagFeatureBtn])).selected = NO;
    ((UIButton *)([self.view viewWithTag:kTagPopularBtn])).selected = NO;
    
    NSInteger tag = [btn tag];
    btn.selected = YES;
    NSInteger showTag = 0;
    switch (tag) {
        case kTagFollowBtn:
            showTag = kTagFollow;
            break;
        case kTagPopularBtn:
            showTag = kTagPopular;
            break;
        case kTagFeatureBtn:
            showTag = kTagFeature;
            break;
        default:
            break;
    }
    [self showView:showTag];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChangeAction:) name:kDataChangeIssueInfo object:nil];
        currentDataRow = -1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)setupNavigationBarItem
{    
    [self setRightNavigationBarWithTitle:@"" image:SNS_SORT_BUTTON];
    [self setLeftNavigationBarWithTitle:@"" image:SNS_SUGGESTED_CONTACT_BUTTON];
}


-(void)go2SuggestionUser
{
    SuggestionUserViewController *vc = [[[SuggestionUserViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [self.navigationController pushViewController:vc animated:YES];
//    SettingViewController *vc = [[[SettingViewController alloc] init] autorelease];
//    [self.navigationController pushViewController:vc animated:YES];
//    sett
}

-(void)leftAction:(id)sender
{
    [self go2SuggestionUser];
}

-(void)rightAction:(id)sender
{
    if (_popMenuView) {
        [_popMenuView setHidden:NO];
    }    
    [_popMenuView toggleMenu];
}

-(void) inviteFriendAction : (id) sender
{
    InviteFriendViewController *inviteFriendControl = [[[InviteFriendViewController alloc] init] autorelease];
    [self.navigationController pushViewController:inviteFriendControl animated:YES];    
}

-(void)setupViews
{
    NSInteger x = 0;
    _followView = [[FeedTableView alloc] initWithFrame:CGRectMake(x, 0, contentView.frame.size.width, contentView.frame.size.height)];
    //_followView.tableView.backgroundColor = [[FloggerUIFactory uiFactory] createBackgroundColor];
    //_followView.backgroundColor = [[FloggerUIFactory uiFactory] createBackgroundColor];
    _followView.action = kCurrentAction;
    _followView.tag = kTagFollow;
    _followView.feedTableDelegate = self;
    _followView.pageDelegate = self;
    _followView.refreshableTableDelegate = self;
    //followView headview
    UIImage *inviteFriendImage = [[FloggerUIFactory uiFactory] createImage:SNS_FEED_INVITE_FRIENDS_BAR];
    UIButton *inviteFriendBtn = [[FloggerUIFactory uiFactory] createButton:inviteFriendImage];
    inviteFriendBtn.frame = CGRectMake(0, 0, inviteFriendImage.size.width, inviteFriendImage.size.height);
//    inviteFriendBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 58, 0, 0);
//    inviteFriendBtn.titleLabel.textAlignment = UITextAlignmentLeft;
//    inviteFriendBtn.titleLabel.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
//    inviteFriendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    [inviteFriendBtn setTitle:NSLocalizedString(@"Invite friends", @"Invite Friends") forState:UIControlStateNormal];
    UILabel *titleLab = [[FloggerUIFactory uiFactory] createLable];
    titleLab.frame = CGRectMake(58, 0, 100, inviteFriendImage.size.height);
    titleLab.text = NSLocalizedString(@"Invite friends", @"Invite Friends");
    titleLab.textAlignment = UITextAlignmentLeft;
    titleLab.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
    titleLab.font = [UIFont boldSystemFontOfSize:15];
    titleLab.userInteractionEnabled = NO;
    [inviteFriendBtn addSubview:titleLab];
    
    [inviteFriendBtn addTarget:self action:@selector(inviteFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _followView.tableView.tableHeaderView = inviteFriendBtn;
    
    [contentView addSubview:_followView];
    
    x += contentView.frame.size.width;
    _popularView = [[FeedGridPageView alloc] initWithFrame:CGRectMake(x, 0, contentView.frame.size.width, contentView.frame.size.height)];
    
    _popularView.tag = kTagPopular;
    _popularView.leftPageView.tag = kTagPopularPhoto;
    _popularView.rightPageView.tag = kTagPopularVideo;
    _popularView.delegate = self;
    _popularView.leftPageView.refreshableTableDelegate = self;
    _popularView.rightPageView.refreshableTableDelegate = self;
    [contentView addSubview:_popularView];
    
    x += contentView.frame.size.width;
    _featureView = [[FeedGridPageView alloc] initWithFrame:CGRectMake(x, 0, contentView.frame.size.width, contentView.frame.size.height)];
    _featureView.delegate = self;
    _featureView.leftPageView.refreshableTableDelegate = self;
    _featureView.leftPageView.pageDelegate = self;
    _featureView.rightPageView.refreshableTableDelegate = self;
    _featureView.rightPageView.pageDelegate = self;
    _featureView.tag = kTagFeature;
    _featureView.leftPageView.tag = kTagFeaturePhoto;
    _featureView.rightPageView.tag = kTagFeatureVideo;
    [contentView addSubview:_featureView];
    
    
//    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FloggerPopMenuView" owner:nil options:nil];
//    _popMenuView = [array objectAtIndex:0];
    _popMenuView = [[FloggerPopMenuView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:_popMenuView];
    _popMenuView.selectedIndex = 0;
    _popMenuView.delegate = self;
}

-(void)doRequestFollowByMediaType:(IssueInfoCategory) mediaType isMore:(BOOL)isMore
{
//    if (self.isLoadingFollow) {
//        return;
//    }
//    self.isLoadingFollow = YES;
    
    if (self.isLoadingFollow) {
        return;
    }
    self.isLoadingFollow = YES;
//    if (_followView.isLoading) {
//        return;
//    }
//    _followView.isLoading = YES;
    
    
    if (!_followSp) {
        _followSp = [[IssueInfoComServerProxy alloc] init];
        _followSp.delegate = self;
        //self.serverProxy = _followSp;
    }
    
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    
    if (isMore) {
        issueInfoCom.searchEndID = _followView.endId;
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
    }
    else
    {
//        issueInfoCom.searchStartID = _followView.startId;
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
        issueInfoCom.searchEndID = [NSNumber numberWithInt:-1];
    }
//    issueInfoCom.
    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:kPageSize];//[NSNumber numberWithInt:_followView.pageSize];
    issueInfoCom.type = [NSNumber numberWithInt:ISSUE_INFO_FOLLOWING];
    if (mediaType != -1) {
        issueInfoCom.mediaType = [NSNumber numberWithInt:mediaType];
    }
    
    [_followSp getIssueList:issueInfoCom];
}

-(void)doRequestFollowByMediaTypeRefresh
{
    if (self.isLoadingFollow) {
        return;
    }
    self.isLoadingFollow = YES;
    
    if (!_followSp) {
        _followSp = [[IssueInfoComServerProxy alloc] init];
        _followSp.delegate = self;
    }
    
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    issueInfoCom.searchEndID = [NSNumber numberWithInt:-1];
    issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
    
    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:kPageSize];//[NSNumber numberWithInt:_followView.pageSize];
    issueInfoCom.type = [NSNumber numberWithInt:ISSUE_INFO_FOLLOWING];
    
    [_followSp getIssueList:issueInfoCom];
}

-(void)doRequestFeatureByMediaType:(IssueInfoCategory) mediaType isMore:(BOOL)isMore
{
    if ((self.isLoadingFeaturePhoto && mediaType == ISSUE_CATEGORY_PICTURE) || (self.isLoadingFeatureVideo && mediaType == ISSUE_CATEGORY_VIDEO)) {
        return;
    }
    
    IssueInfoComServerProxy *sp = nil;
    
//    NSInteger currentPage = 0;
    NSInteger pageSize = 0;
    
    NSNumber *startId = [NSNumber numberWithInt:-1];
    NSNumber *endId = [NSNumber numberWithInt:-1];
    
    if(mediaType == ISSUE_CATEGORY_PICTURE)
    {
        self.isLoadingFeaturePhoto = YES;
        
        if(!_featurePhotoSp)
        {
            _featurePhotoSp = [[IssueInfoComServerProxy alloc] init];
            _featurePhotoSp.delegate = self;
        }
        sp = _featurePhotoSp;
        
        if (isMore) {
            endId = _featureView.leftPageView.endId;
        }
        else
        {
            startId = _featureView.leftPageView.startId;
        }
        
        pageSize = _featureView.leftPageView.pageSize;
    }
    else
    {
        self.isLoadingFeatureVideo = YES;
        
        if(!_featureVideoSp)
        {
            _featureVideoSp = [[IssueInfoComServerProxy alloc] init];
            _featureVideoSp.delegate = self;
        }
        sp = _featureVideoSp;
        
//        currentPage = _featureView.rightPageView.currentPage;
        pageSize = _featureView.rightPageView.pageSize;
        
        if (isMore) {
            endId = _featureView.rightPageView.endId;
        }
        else
        {
            startId = _featureView.rightPageView.startId;
        }

    }
    
    
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    issueInfoCom.searchStartID = startId;
    issueInfoCom.searchEndID = endId;
    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:pageSize];
    issueInfoCom.type = [NSNumber numberWithInt:ISSUE_INFO_FEATURED];
    
    if (mediaType != -1) {
        issueInfoCom.mediaType = [NSNumber numberWithInt:mediaType];
    }
    
    [sp getIssueList:issueInfoCom];
}


-(void)doRequestPopular
{
    if (self.isLoadingPopular) {
        return;
    }
    
    self.isLoadingPopular = YES;
    if (!_popularSp) {
        _popularSp = [[IssueInfoComServerProxy alloc] init];
        _popularSp.delegate = self;
    }
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    issueInfoCom.currentPage = [NSNumber numberWithInt:_popularView.leftPageView.currentPage];
    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:_popularView.leftPageView.pageSize];
    issueInfoCom.count = [NSNumber numberWithInt:0];
    [_popularSp getPopularMedia:issueInfoCom];
}

-(void) adjustFeedsViewLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
    self.view = view;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    
    //button
    UIImage *followImage = [[FloggerUIFactory uiFactory] createImage:SNS_FOLLOW_FEED_BUTTON_BLANK];
    UIImage *followImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_HIGHLIGHTED_FOLLOW_FEED_BUTTON_BLANK];
    UIImage *popularImage = [[FloggerUIFactory uiFactory] createImage:SNS_POPULAR_FEED_BUTTON_BLANK];
    UIImage *popularImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_HIGHLIGHTED_POPULAR_FEED_BLANK];
    UIImage *featureImage = [[FloggerUIFactory uiFactory] createImage:SNS_FEATURED_FEED_BUTTON_BLANK];
    UIImage *featureImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_HIGHLIGHT_FEATURED_FEED_BLANK];
    
    int originalX = 5;
    int originalY = 5;
    
    UIButton *followBtn = [[FloggerUIFactory uiFactory] createHeadButton:followImage withSelImage:followImageSelected];
    followBtn.frame = CGRectMake(originalX, originalY, followImage.size.width, followImage.size.height);
    [followBtn setTitle:NSLocalizedString(@"Feed", @"Feed") forState:UIControlStateNormal];
//    followBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
//    followBtn.titleLabel.shadowColor = 
    followBtn.tag = kTagFollowBtn;
    [followBtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *popularBtn = [[FloggerUIFactory uiFactory] createHeadButton:popularImage withSelImage:popularImageSelected];
    popularBtn.frame = CGRectMake(originalX + followImage.size.width, originalY, popularImage.size.width, popularImage.size.height);
    [popularBtn setTitle:NSLocalizedString(@"Popular", @"Popular") forState:UIControlStateNormal];
    popularBtn.tag = kTagPopularBtn;
    [popularBtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    NSLog(@"popularBtn font is %@",popularBtn.titleLabel.font.familyName);
    
    UIButton *featurebtn = [[FloggerUIFactory uiFactory] createHeadButton:featureImage withSelImage:featureImageSelected];
    featurebtn.frame = CGRectMake(originalX + followImage.size.width + popularImage.size.width, originalY, featureImage.size.width, featureImage.size.height);
    [featurebtn setTitle:NSLocalizedString(@"Feature", @"Feature") forState:UIControlStateNormal];
    featurebtn.tag = kTagFeatureBtn;
    [featurebtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:followBtn];
//    [self.view addSubview:popularBtn];
//    [self.view addSubview:featurebtn];
//    
//    //ttbutton
//    [self.view addSubview:followBtn];
    
    
    
    UIView *contentV = [[FloggerUIFactory uiFactory] createView];
    contentV.frame = CGRectMake(0, 0, 320, 367);//367
    //contentV.backgroundColor = [[FloggerUIFactory uiFactory] createBackgroundColor];
    [self.view addSubview:contentV];
    [self setContentView:contentV];
    
    //initial
    followBtn.selected = YES;
    
}

-(void)addMenuIcon{
    CGRect frame = CGRectMake(150,5,35,30);
    frame.origin.x = (self.navigationController.navigationBar.frame.size.width - 35)/2;
    frame.origin.y = (self.navigationController.navigationBar.frame.size.height - 30)/2;
    UIButton *menubtn = [[[UIButton alloc]initWithFrame:frame] autorelease]; 
    menubtn.tag = 3000;
//    [menubtn addTarget:self action:@selector(menupress:) forControlEvents:UIControlEventTouchUpInside];
    [menubtn setBackgroundImage:[UIImage imageNamed: SNS_MENU] forState:UIControlStateNormal];
//    [menubtn]
    [menubtn setHidden:NO];
    [self.navigationController.navigationBar addSubview:menubtn]; 
    
    //[[GlobalData sharedInstance] setUpMenuView:self.navigationController.view.bounds];
}

-(void) loadView
{
    [self adjustFeedsViewLayout];
    //test
//    [_popularView.scrollview scrollsToTop];
//    [self]
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerNotification];
    if (self.followChanged) {
        [_followView.dataArr removeAllObjects];
        [_followView checkMore:nil];
        [_followView.tableView reloadData];
        [self doRequestFollowByMediaType:issueinfoCategory isMore:NO];
    }
    else if(self.tweetChanged){
        [self doRequestFollowByMediaType:issueinfoCategory isMore:NO];
    } else {
        if(_isDataChange)
        {
            _isDataChange = NO;
            [_followView.tableView reloadData];
        }
        if (_isScrollTop) {
            _isScrollTop = NO;
            
//            [_followView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            if (currentDataRow == -1) {
                [self viewScrollToTop];
            } else {
                [self viewScrollToCellBottom];
            }
            
        }
    }
    //popular title;
//    if(![self restoreData])
//    {
//        [self setNavigationTitleView:NSLocalizedString(@"All", @"All")];
//    }
    [self setPopViewButton];
    
//    [self addMenuIcon];
}

-(void) viewScrollToCellBottom 
{
    if (_followView && [_followView.dataArr count] > 0 && currentDataRow > -1) {
        [_followView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentDataRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        currentDataRow = -1;
    }
}

-(void) viewScrollToTop
{
    if (_followView && [_followView.dataArr count] > 0) {
//        [_followView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
//        [_followView.tableView scroll]
        [_followView.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 44) animated:YES];
    }
     
}

-(void) restoreTableView
{
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[_followView.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[_followView.refreshHeaderView setState:EGOOPullRefreshNormal];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if([@"scrollDown" isEqualToString:animationID])
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(restoreTableView) object:nil];
        [self performSelector:@selector(restoreTableView) withObject:nil afterDelay:1.5];
        [self refreshDataSource:_followView]; 
    }
}

-(void) tabBarClickScrollToTopPop
{
    if (self.isLoadingFollow) {
        return;
    }
    
    if (_followView && [_followView.dataArr count] > 0) {
        
        
        [_followView.refreshHeaderView setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        //        [UIView setAnimationDelegate:self];
        _followView.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
        [_followView.tableView setNeedsLayout];
        
        [_followView.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 44) animated:NO];
        
        [_followView.refreshHeaderView.delegate egoRefreshTableHeaderDidTriggerRefresh:_followView.refreshHeaderView];
        
        /*//[_followView.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 44) animated:NO];
         
         
         //[_followView.refreshHeaderView setState:EGOOPullRefreshLoading];
         [UIView beginAnimations:@"scrollDown" context:NULL];
         [UIView setAnimationDuration:0.2];
         [UIView setAnimationDelegate:self];
         _followView.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
         [UIView commitAnimations];
         
         //        [_followView.refreshHeaderView.delegate egoRefreshTableHeaderDidTriggerRefresh:_followView.refreshHeaderView];*/
    }
    
}


-(void) tabBarClickScrollToTop
{
    if (self.isLoadingFollow) {
        return;
    }
   
    if (_followView && [_followView.dataArr count] > 0) {
        
        
        [_followView.refreshHeaderView setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
//        [UIView setAnimationDelegate:self];
        _followView.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
        [_followView.tableView setNeedsLayout];
        
        [_followView.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 44) animated:YES];
        
        [_followView.refreshHeaderView.delegate egoRefreshTableHeaderDidTriggerRefresh:_followView.refreshHeaderView];
        
        /*//[_followView.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 44) animated:NO];
        
        
       //[_followView.refreshHeaderView setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:@"scrollDown" context:NULL];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        _followView.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
        
        //        [_followView.refreshHeaderView.delegate egoRefreshTableHeaderDidTriggerRefresh:_followView.refreshHeaderView];*/
    }
 
}

//static
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //_currentRow = [_followView.tableView indexPathForRowAtPoint:[_followView.tableView contentOffset]].row;
    [self saveDataToFile];
    [self unregisterNotification];
    
    if ([self.navigationController.navigationBar viewWithTag:3000]) {
        UIView *menuView = [self.navigationController.navigationBar viewWithTag:3000];
        [menuView setHidden:YES];
    } 
    //pop view hiden
    if (_popMenuView) {
        [_popMenuView setHidden:YES];
    }
    
//    [BaseServerProxy cancelAllOnEarth:normalLevel];
    
}
-(void)cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [_followSp cancelAll];
    self.isLoadingFollow =NO;
    _followView.isLoadingMore = NO;
}
- (void) handleAction:(NSNotification *)notification
{
    if(!notification.object)
    {
        [_followView.tableView reloadData];
        _followView.firstLoaded =YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    // Do any additional setup after loading the view from its nib.
    self.issueinfoCategory = -1;
    [self setupNavigationBarItem];
    [self setupViews];
    [self showView:kTagFollow];
    self.issueinfoCategory = -1;
    if(![self restoreData])
    {
        [self doRequestFollowByMediaType:issueinfoCategory isMore:NO];
    }
    //pagesize
    _followView.pageSize = kPageSize;
//    [self doRequestPopular];
//    [self doRequestFeatureByMediaType:ISSUE_CATEGORY_PICTURE isMore:NO];
//    [self doRequestFeatureByMediaType:ISSUE_CATEGORY_VIDEO isMore:NO];
    
    //[self registerNotification];
    //add  instrution view
//    FloggerInstructionView *instructionView = [[[FloggerInstructionView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withImageURL:SNS_INSTRUCTIONS_FEED] autorelease];
//    [self.bcTabBarController.view.window addSubview:instructionView];
    
}

-(BOOL) checkIsShowHelpView
{
    self.helpImageURL = SNS_INSTRUCTIONS_FEED;
    if ([GlobalUtils checkIsFirstShowHelpView:self.helpImageURL]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self myReleaseSource];
    //[self unregisterNotification];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:kRotateIndicate]) {
//        return YES;
//    } else {
//        return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    }
    
//    return YES;
}

-(void)splitDataByIssueCategory:(NSArray *)data photoData:(NSMutableArray *)photoArray videoData:(NSMutableArray *)videoArray
{
//    Issueinfo *issueinfo = [[[Issueinfo alloc] init] autorelease];
    for (Issueinfo *issueinfo in data) {
//        [issueinfo.dataDict removeAllObjects];
//        [issueinfo.dataDict addEntriesFromDictionary:dict];
        if ([issueinfo.issuecategory intValue] == ISSUE_CATEGORY_PICTURE) {
            [photoArray addObject:issueinfo];
        }
        else
        {
            [videoArray addObject:issueinfo];
        }
    }
}
-(void) networkError:(BaseServerProxy *)serverproxy
{
    [super networkError:serverproxy];
    self.isLoadingFollow = NO;
}

-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    [super networkFinished:serverproxy];
    NSDate *date = [NSDate date];
    if (serverproxy == _followSp) {
        self.isLoadingFollow = NO;
        _followView.lastUpdateDate = date;
    }
    else if(serverproxy == _featurePhotoSp)
    {
        self.isLoadingFeaturePhoto = NO;
        _featureView.leftPageView.lastUpdateDate = date;
    }
    else if(serverproxy == _featureVideoSp)
    {
        self.isLoadingFeatureVideo = NO;
        _featureView.rightPageView.lastUpdateDate = date;
    }
    else
    {
        self.isLoadingPopular = NO;
        _popularView.leftPageView.lastUpdateDate = date;
        _popularView.rightPageView.lastUpdateDate = date;
    }
}

//-(void) applicationWillResign : (noti)
-(void) applicationWillResign:(NSNotification *)notification
{
    [self saveDataToFile];
}

-(void) setPopViewButton
{
    if (!_popMenuView) {
        return;
    }
    [_popMenuView.allButton setSelected:NO];
    [_popMenuView.photoButton setSelected:NO];
    [_popMenuView.videoButton setSelected:NO];
    [_popMenuView.tweetButton setSelected:NO];
    switch (self.issueinfoCategory) {
        case ISSUE_CATEGORY_PICTURE:
            [_popMenuView.photoButton setSelected:YES];
            [self setNavigationTitleView:NSLocalizedString(@"Photo Feed", @"Photo Feed")];
            break;
        case ISSUE_CATEGORY_VIDEO:
            [_popMenuView.videoButton setSelected:YES];
            [self setNavigationTitleView:NSLocalizedString(@"Video Feed", @"Video Feed")];
            break;
        case ISSUE_CATEGORY_TWEET:
            [_popMenuView.tweetButton setSelected:YES];
            [self setNavigationTitleView:NSLocalizedString(@"Shout", @"Shout")];
            break;            
        default:
            [_popMenuView.allButton setSelected:YES];
            [self setNavigationTitleView:NSLocalizedString(@"All Feed", @"All Feed")];
            break;
    }
}

-(void) saveDataToFile
{
    NSMutableDictionary *data = [[[NSMutableDictionary alloc]init]autorelease];
    IssueInfoCom *com = [[[IssueInfoCom alloc]init]autorelease];
    com.myIssueInfoList = _followView.dataArr;
    
    [data setObject:com.dataDict forKey:kSavedDataMainData];
    [data setObject:[NSNumber numberWithBool:_followView.hasMore] forKey:kSavedDataHasMore];
    //lastupdateTime
    double currentSec = [_followView.lastUpdateDate timeIntervalSince1970];
    [data setObject:[NSNumber numberWithDouble:currentSec] forKey:kSavedDataLastUpdateTime];
    //catalog
    [data setObject:[NSNumber numberWithInt:issueinfoCategory] forKey:kSavedDataIssueCategory];

    
    NSIndexPath* indexPath = [_followView.tableView indexPathForRowAtPoint:[_followView.tableView contentOffset]];
    [data setObject:[NSNumber numberWithDouble:indexPath.row] forKey:kSavedDataCurrentRow];
    NSString *sData = [data JSONRepresentation];
    NSData* pureData = [sData dataUsingEncoding:NSUTF8StringEncoding];
    [[DataCache sharedInstance]storeData:pureData forKey:kDataCacheFeedData Category:kDataCacheTempDataCategory];
}
-(BOOL) restoreData
{
    NSData* pureData = [[DataCache sharedInstance]dataFromKey:kDataCacheFeedData Category:kDataCacheTempDataCategory];
    if(pureData)
    {
        NSString *sData = [[[NSString alloc]initWithData:pureData encoding:NSUTF8StringEncoding] autorelease];
        IssueInfoCom *com = [[[IssueInfoCom alloc]init]autorelease];
        NSMutableDictionary *data = [sData JSONValue];
        com.dataDict = [data objectForKey:kSavedDataMainData];
        _followView.dataArr = com.myIssueInfoList;
        _followView.hasMore = [[data objectForKey:kSavedDataHasMore] boolValue];
        _followView.lastUpdateDate =  [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:kSavedDataLastUpdateTime]doubleValue]];
        self.issueinfoCategory = [[data objectForKey:kSavedDataIssueCategory] intValue];
        [self setPopViewButton];
        
        [_followView.tableView reloadData];

        if ([[data objectForKey:kSavedDataCurrentRow]intValue] < [_followView.dataArr count]) {
            [_followView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[data objectForKey:kSavedDataCurrentRow]intValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        return YES;
    }
    return NO;
}

-(void)updateView:(ClPageTableView *)tableView withResponse:(IssueInfoCom *)response
{
    if (response.myIssueInfoList && response.myIssueInfoList.count > 0)
    {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
        [tableView.dataArr addObjectsFromArray:response.myIssueInfoList];
    } else {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
    }

    if ([response.searchStartID longLongValue] == -1) {
        [tableView checkMore:response.myIssueInfoList];
    }
    [self saveDataToFile];
    [tableView.tableView reloadData];
    
    //not add more
    if ([response.searchEndID longLongValue] == -1) {
//        if ([tableView.dataArr count] > 0) {
//            [tableView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }
        [self viewScrollToTop];
        
    }
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
//    _followView.isLoading = NO;
    self.isLoadingFollow = NO;
    _followView.isLoadingMore = NO;
    if (![serverproxy isKindOfClass:[IssueInfoComServerProxy class]]) {
        return;
    }
    
    IssueInfoCom *response = (IssueInfoCom *)serverproxy.response;
    if ([response.type intValue] == ISSUE_INFO_FOLLOWING) {
        
        [self updateView:_followView withResponse:response];
        
    }
    else if([response.type intValue] == ISSUE_INFO_FEATURED) {
        
        if ([response.mediaType intValue] == ISSUE_CATEGORY_PICTURE) {
            
            [self updateView:_featureView.leftPageView withResponse:response];
        }
        else
        {

            [self updateView:_featureView.rightPageView withResponse:response];
        }
    }
    else
    {
        
        [_popularView.leftPageView.dataArr removeAllObjects];
        [_popularView.rightPageView.dataArr removeAllObjects];
        
        NSMutableArray *photoArray = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *videoArray = [[[NSMutableArray alloc] init] autorelease];
        [self splitDataByIssueCategory:response.myIssueInfoList photoData:photoArray videoData:videoArray];
        
        [_popularView.leftPageView.dataArr addObjectsFromArray:photoArray];
        [_popularView.leftPageView.tableView reloadData];
        
        [_popularView.rightPageView.dataArr addObjectsFromArray:videoArray];
        [_popularView.rightPageView.tableView reloadData];
    }
}


-(Issueinfo *)getIssueInfoByType:(NSInteger)tag withPageIndex:(NSInteger)pageIndex index:(NSInteger)index
{
    NSArray *dataArr = nil;
    FeedGridPageView *tmpView = nil;
    if (tag == kTagPopular) {
        tmpView = _popularView;
    }
    else
    {
        tmpView = _featureView;
    }
    
    if (pageIndex == 0) {
        dataArr = tmpView.leftPageView.dataArr;
    }
    else
    {
        dataArr = tmpView.rightPageView.dataArr;
    }
    
    return [dataArr objectAtIndex:index];
}
-(void)go2ViewerWithIssueinfo:(Issueinfo *)issueinfo
{
    FeedViewerViewController *viewerController = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    viewerController.issueInfo = [[[MyIssueInfo alloc] init] autorelease];//issueinfo;
    viewerController.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:issueinfo.dataDict];
    [self.navigationController pushViewController:viewerController animated:YES];
}
-(void)selectFeedGridPageView:(FeedGridPageView *)feedGridPageView atPage:(NSInteger)page index:(NSInteger)index
{
    
    NSInteger pageIndex = 0;
    if (feedGridPageView.tag == kTagPopular) {
        pageIndex = page - kTagPopularPhoto;
    }
    else {
        pageIndex = page - kTagFeaturePhoto;
    }
    
    Issueinfo *issueinfo = [self getIssueInfoByType:feedGridPageView.tag withPageIndex:pageIndex index:index];
    [self go2ViewerWithIssueinfo:issueinfo];
}

-(void)floggerPopMenuView:(FloggerPopMenuView *)popMenuView clickedAtIndex:(NSInteger)index
{
    if (_popMenuView) {
        [_popMenuView setHidden:NO];
    }    
    IssueInfoCategory cagetory  = -1;
    switch (index) {
        case 0:
            cagetory = -1;
            [self setNavigationTitleView:NSLocalizedString(@"All Feed", @"All Feed")];
            break;
        case 1:
            cagetory = ISSUE_CATEGORY_PICTURE;
            [self setNavigationTitleView:NSLocalizedString(@"Photo Feed", @"Photo Feed")];
            break;
        case 2:
            cagetory = ISSUE_CATEGORY_VIDEO;
            [self setNavigationTitleView:NSLocalizedString(@"Video Feed", @"Video Feed")];
            break;
        case 3:
            cagetory = ISSUE_CATEGORY_TWEET;
            [self setNavigationTitleView:NSLocalizedString(@"Shout", @"Shout")];
            break;
        case 4:
            cagetory = ISSUE_CATEGORY_ACTIVITY;
            break;
        default:
            break;
    }
    
    if (issueinfoCategory != cagetory) {
        [self cancelNetworkRequests];
        
        issueinfoCategory = cagetory;
        
        [_followSp cancelAll];
        _isLoadingFollow = NO;
        [_followView checkMore:nil];
//        [_followView.dataArr removeAllObjects];
//        [_followView.tableView reloadData];
//        _followView.currentPage = 1;
        
//        [self doRequestFollowByMediaType:issueinfoCategory isMore:NO];
        [self tabBarClickScrollToTop];
    }
}

-(void) myReleaseSource
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"feed" object:nil];
    RELEASE_SAFELY(contentView);
    RELEASE_SAFELY(_popMenuView);
    RELEASE_SAFELY(_followView);
    RELEASE_SAFELY(_popularView);
    RELEASE_SAFELY(_featureView);
    _followSp.delegate = nil;
    RELEASE_SAFELY(_followSp);
    _popularSp.delegate = nil;
    RELEASE_SAFELY(_popularSp);
    _featurePhotoSp.delegate = nil;
    RELEASE_SAFELY(_featurePhotoSp);
    _featureVideoSp.delegate = nil;
    RELEASE_SAFELY(_featureVideoSp); 
}

-(void)dealloc
{
    [self myReleaseSource];
    [self unregisterNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataChangeIssueInfo object:nil];
    
    [super dealloc];
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    NSInteger tag = refreshTableView.tag;
    switch (tag) {
        case kTagFollow:
            [self doRequestFollowByMediaType:issueinfoCategory isMore:NO];
             break;
        case kTagPopularVideo:
        case kTagPopularPhoto:
            [self doRequestPopular];
            break;
        default:
            if (refreshTableView == _featureView.leftPageView) {
                [self doRequestFeatureByMediaType:ISSUE_CATEGORY_PICTURE isMore:NO];
            }
            else
            {
                [self doRequestFeatureByMediaType:ISSUE_CATEGORY_VIDEO isMore:NO];
            }
            break;
    }
}

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    
    if (tableView == _followView) {
        [self doRequestFollowByMediaType:issueinfoCategory isMore:YES];
    }
    else if(tableView == _popularView.leftPageView || tableView == _popularView.rightPageView)
    {
        [self doRequestPopular];
    }
    else if(tableView == _featureView.leftPageView) {
        [self doRequestFeatureByMediaType:ISSUE_CATEGORY_PICTURE isMore:YES];
    }
    else
    {
        [self doRequestFeatureByMediaType:ISSUE_CATEGORY_VIDEO isMore:YES];
    }
    
}

@end
