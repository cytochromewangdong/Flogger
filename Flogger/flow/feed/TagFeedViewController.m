//
//  TagFeedViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-26.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "TagFeedViewController.h"
#import "EntityEnumHeader.h"
#import "FeedViewerViewController.h"

#import "FeedViewerViewController.h"
#import "ShareFeedViewController.h"
#import "MyAccount.h"
#import "ProfileViewController.h"
#import "VideoPlayViewController.h"
#import "GlobalData.h"

#define kPhotoTag 10000
#define kVideoTag 10001
#define kTweetTag 10002

#define kTagPhotoBtn 10003
#define kTagVideoBtn 10004
#define kTagTweetBtn 10005
#define kTagMediaBtn 10006

@implementation TagFeedViewController
@synthesize contentView, photoView, videoView, tweetView, photoSp, videoSp, tweetSp, taginfo;
NSInteger tableViewTag = 0;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChangeAction:) name:kDataChangeIssueInfo object:nil];
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView: [NSString stringWithFormat: @"#%@#", self.taginfo.content]];
    
    if(_isDataChange)
    {
        _isDataChange = NO;
        [self.tweetView.tableView reloadData];
    }
}

-(void) setupView
{
    NSInteger x = 0;
    self.photoView = [[[FeedGridPageTableView alloc] initWithFrame:CGRectMake(x, 0, contentView.frame.size.width, contentView.frame.size.height)] autorelease];
    self.photoView.tag = kPhotoTag;
    self.photoView.refreshableTableDelegate = self;
    self.photoView.pageDelegate = self;
    self.photoView.feedGridTableViewDelegate = self;
    [self.contentView addSubview:self.photoView];
    photoView.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    x += contentView.frame.size.width;
    self.videoView = [[[FeedGridPageTableView alloc] initWithFrame:CGRectMake(x, 0, contentView.frame.size.width, contentView.frame.size.height)] autorelease];
    self.videoView.tag = kVideoTag;
    self.videoView.refreshableTableDelegate = self;
    self.videoView.pageDelegate = self;
    self.videoView.feedGridTableViewDelegate = self;
    [self.contentView addSubview:self.videoView];
    videoView.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    x += contentView.frame.size.width;
    self.tweetView = [[[FeedTableView alloc] initWithFrame:CGRectMake(x, 0, contentView.frame.size.width, contentView.frame.size.height)] autorelease];
    self.tweetView.feedTableDelegate = self;
    self.tweetView.refreshableTableDelegate = self;
    self.tweetView.pageDelegate = self;
    self.tweetView.tag = kTweetTag;
    [self.contentView addSubview:self.tweetView];
    tweetView.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

-(void)showView:(NSInteger)viewTag
{
    
    UIView *view = [self.contentView viewWithTag:viewTag];
    NSInteger offset = -view.frame.origin.x;
    //        [UIView beginAnimations:nil context:nil];
    
    CGRect frame = CGRectMake(self.photoView.frame.origin.x + offset, self.photoView.frame.origin.y, self.photoView.frame.size.width, self.photoView.frame.size.height);
    self.photoView.frame = frame;
    
    frame = CGRectMake(self.videoView.frame.origin.x + offset, self.videoView.frame.origin.y, self.videoView.frame.size.width, self.videoView.frame.size.height);
    self.videoView.frame = frame;
    
    frame = CGRectMake(self.tweetView.frame.origin.x + offset, self.tweetView.frame.origin.y, self.tweetView.frame.size.width, self.tweetView.frame.size.height);
    self.tweetView.frame = frame;
    //        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //        [UIView setAnimationDuration:500];
    //        [UIView commitAnimations];
}

-(void)btnTapped:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        return;
    }
    
    ((UIButton *)([self.view viewWithTag:kTagPhotoBtn])).selected = NO;
    ((UIButton *)([self.view viewWithTag:kTagVideoBtn])).selected = NO;
    ((UIButton *)([self.view viewWithTag:kTagTweetBtn])).selected = NO;
    //    ((UIButton *)([self.view viewWithTag:kTagMediaBtn])).selected = NO;
    NSInteger tag = [btn tag];
    btn.selected = YES;
    NSInteger showTag = 0;
    switch (tag) {
        case kTagPhotoBtn:
            showTag = kPhotoTag;
            tableViewTag= kPhotoTag;
            break;
        case kTagVideoBtn:
            showTag = kVideoTag;
            tableViewTag= kVideoTag;
            break;
        case kTagTweetBtn:
            showTag = kTweetTag;
            tableViewTag= kTweetTag;
            break;
        default:
            break;
    }
    [self showView:showTag];
}

-(void)doRequestTweet:(BOOL)isMore
{
    //    if (self.loading && self.loadingThread) {
    //        return;
    //    }
    //    //    if (self.loading) {
    //    //        return;
    //    //    }
    //    self.loading = YES;
    
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.tweetSp) {
        self.tweetSp = [[[TagInfoComServerProxy alloc] init] autorelease];
        self.tweetSp.delegate = self;
    }
    
    TagInfoCom *com = [[[TagInfoCom alloc] init] autorelease];
    //    com.currentPage = [NSNumber numberWithInt:self.tweetView.currentPage];
    if (isMore) {
        com.searchEndID = self.tweetView.endId;
        com.searchStartID = [NSNumber numberWithInt:-1];
    }
    else {
        //        com.searchStartID = self.tweetView.startId;
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
    }
    com.itemNumberOfPage = [NSNumber numberWithInt:self.tweetView.pageSize];
    com.mediaType = [NSNumber numberWithInt:ISSUE_CATEGORY_TWEET];
    com.content = self.taginfo.content;
    [self.tweetSp getIssueListByTag:com];
}

-(void)doRequestMedia:(BOOL)isMore
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.photoSp) {
        self.photoSp = [[[TagInfoComServerProxy alloc] init] autorelease];
        self.photoSp.delegate = self;
    }
    
    TagInfoCom *com = [[[TagInfoCom alloc] init] autorelease];
    //    com.currentPage = [NSNumber numberWithInt:self.photoView.currentPage];
    if (isMore) {
        com.searchEndID = self.photoView.endId;
        com.searchStartID = [NSNumber numberWithInt:-1];
    }
    else {
        //        com.searchStartID = self.photoView.startId;
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
    }
    com.itemNumberOfPage = [NSNumber numberWithInt:self.photoView.pageSize];
    com.mediaType = [NSNumber numberWithInt:3];
    com.content = self.taginfo.content;
    [self.photoSp getIssueListByTag:com];
}


-(void)doRequestPhoto:(BOOL)isMore
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.photoSp) {
        self.photoSp = [[[TagInfoComServerProxy alloc] init] autorelease];
        self.photoSp.delegate = self;
    }
    
    TagInfoCom *com = [[[TagInfoCom alloc] init] autorelease];
    //    com.currentPage = [NSNumber numberWithInt:self.photoView.currentPage];
    if (isMore) {
        com.searchEndID = self.photoView.endId;
        com.searchStartID = [NSNumber numberWithInt:-1];
    }
    else {
        //        com.searchStartID = self.photoView.startId;
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
    }
    com.itemNumberOfPage = [NSNumber numberWithInt:self.photoView.pageSize];
    com.mediaType = [NSNumber numberWithInt:ISSUE_CATEGORY_PICTURE];
    com.content = self.taginfo.content;
    [self.photoSp getIssueListByTag:com];
}

-(void)doRequestVideo:(BOOL)isMore
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.videoSp) {
        self.videoSp = [[[TagInfoComServerProxy alloc] init] autorelease];
        self.videoSp.delegate = self;
    }
    
    TagInfoCom *com = [[[TagInfoCom alloc] init] autorelease];
    //    com.currentPage = [NSNumber numberWithInt:self.photoView.currentPage];
    if (isMore) {
        com.searchEndID = self.videoView.endId;
        com.searchStartID = [NSNumber numberWithInt:-1];
    }
    else {
        //        com.searchStartID = self.videoView.startId;
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
    }
    com.itemNumberOfPage = [NSNumber numberWithInt:self.videoView.pageSize];
    com.mediaType = [NSNumber numberWithInt:ISSUE_CATEGORY_VIDEO];
    com.content = self.taginfo.content;
    [self.videoSp getIssueListByTag:com];
}

//-(void)doRequestFeedByType:(IssueInfoCategory)mediaType isMore:(BOOL)isMore
//{
//    switch (mediaType) {
//        case ISSUE_CATEGORY_TWEET:
//            [self doRequestTweet];
//            break;
//            
//        default:
//            break;
//    }
//}

-(void) adjustTagFeedLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 411);
    self.view = view;
    
    /*
     //button
     UIImage *popularImage = [[FloggerUIFactory uiFactory] createImage:SNS_TOPIC];
     UIImage *popularImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_TOPIC_PRESSED];
     UIImage *featureImage = [[FloggerUIFactory uiFactory] createImage:SNS_USERS];
     UIImage *featureImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_USERS_PRESSED];
     */
    UIImage *followImage = [[FloggerUIFactory uiFactory] createImage:SNS_FOLLOW_FEED_BUTTON_BLANK];
    UIImage *followImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_HIGHLIGHTED_FOLLOW_FEED_BUTTON_BLANK];
    UIImage *popularImage = [[FloggerUIFactory uiFactory] createImage:SNS_POPULAR_FEED_BUTTON_BLANK];
    UIImage *popularImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_HIGHLIGHTED_POPULAR_FEED_BLANK];
    UIImage *featureImage = [[FloggerUIFactory uiFactory] createImage:SNS_FEATURED_FEED_BUTTON_BLANK];
    UIImage *featureImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_HIGHLIGHT_FEATURED_FEED_BLANK];
    
    UIButton *followBtn = [[FloggerUIFactory uiFactory] createHeadButton:followImage withSelImage:followImageSelected];
    [followBtn setBackgroundImage:followImageSelected forState:UIControlStateHighlighted];
    followBtn.frame = CGRectMake(10, 5, followImage.size.width, followImage.size.height);
    [followBtn setTitle:NSLocalizedString(@"Photos", @"Photos") forState:UIControlStateNormal];
    followBtn.tag = kTagPhotoBtn;
//    [followBtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *popularBtn = [[FloggerUIFactory uiFactory] createHeadButton:popularImage withSelImage:popularImageSelected];
     [popularBtn setBackgroundImage:popularImageSelected forState:UIControlStateHighlighted];
    popularBtn.frame = CGRectMake(followBtn.frame.origin.x + followBtn.frame.size.width,  5, popularImage.size.width, popularImage.size.height);
    [popularBtn setTitle:NSLocalizedString(@"Videos", @"Videos") forState:UIControlStateNormal];
    popularBtn.tag = kTagVideoBtn;
//    [popularBtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *featurebtn = [[FloggerUIFactory uiFactory] createHeadButton:featureImage withSelImage:featureImageSelected];
     [featurebtn setBackgroundImage:featureImageSelected forState:UIControlStateHighlighted];
    featurebtn.frame = CGRectMake(popularBtn.frame.origin.x + popularBtn.frame.size.width, 5, featureImage.size.width, featureImage.size.height);
    [featurebtn setTitle:NSLocalizedString(@"Shout", @"Shout") forState:UIControlStateNormal];
    featurebtn.tag = kTagTweetBtn;
//    [featurebtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIView *viewBtns = [[FloggerUIFactory uiFactory] createButtonsBackgroundView];
    viewBtns.frame = CGRectMake(0, 0, 320, 40);
    

    [self.view addSubview:viewBtns];
    [self.view addSubview:followBtn];
    [self.view addSubview:popularBtn];
    [self.view addSubview:featurebtn];
    
    UIView *contentV = [[FloggerUIFactory uiFactory] createView];
    contentV.frame = CGRectMake(0, 40, 320, 371-45);
    
    [self.view addSubview:contentV];
    
    [self setContentView:contentV];
    

}

#pragma mark - View lifecycle
-(void) loadView
{
    [self adjustTagFeedLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
    
    
    //    [self doRequestMedia:NO];
    //
    [self doRequestPhoto:NO];
    //    [self doRequestVideo:NO];
    //    [self doRequestTweet:NO];
    //        [self.view viewWithTag:kTagPhotoBtn];
    self.loadingThread = NO;
    //        ((UIButton *)([self.view viewWithTag:kTagPhotoBtn])).enabled = NO;
    //        ((UIButton *)([self.view viewWithTag:kTagVideoBtn])).enabled = NO;
    //         ((UIButton *)([self.view viewWithTag:kTagTweetBtn])).enabled = NO;
    tableViewTag=kTagPhotoBtn;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    self.contentView = nil;
    self.photoView = nil;
    self.videoView = nil;
    self.tweetView = nil;
    
    self.photoSp.delegate = nil;
    self.photoSp = nil;
    
    self.videoSp.delegate = nil;
    self.videoSp = nil;
    
    self.tweetSp.delegate = nil;
    self.tweetSp = nil;
    
    self.taginfo = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataChangeIssueInfo object:nil];

    [super dealloc];
}

-(void) dataChangeAction : (NSNotification *) notification
{
    //    NSNumber *issueId = (NSNumber *) notification.object;
    //    NSMutableDictionary *dataNotifiaction = [NSMutableDictionary *] notification.
    
    if(!self.tweetView || !self.tweetView)
    {
//        [[DataCache sharedInstance]removeDataForKey:kDataCacheFeedData Category:kDataCacheTempDataCategory]; 
        return;
    }
    NSMutableDictionary *data = (NSMutableDictionary *) notification.object;
    
    if ([kNotificationLikeAction isEqualToString:[data objectForKey:kNotificationAction]])
    {
        NSNumber *issueId = [data objectForKey:kNotificationInfoIssueId];
        for (int i = 0; i < [self.tweetView.dataArr count]; i++) {
            Issueinfo *issueInfo = [self.tweetView.dataArr objectAtIndex:i];
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
                    [self.tweetView.tableView reloadData];
                } else {
//                    _isDataChange = TRUE;
                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self saveDataToFile];
//                });            
                break;
            }
        }      
        
    } else if ([kNotificationUnLikeAction isEqualToString:[data objectForKey:kNotificationAction]])
    {
        
        NSNumber *issueId = [data objectForKey:kNotificationInfoIssueId];
        for (int i = 0; i < [self.tweetView.dataArr count]; i++) {
            Issueinfo *issueInfo = [self.tweetView.dataArr objectAtIndex:i];
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
                    [self.tweetView.tableView reloadData];
                } else {
//                    _isDataChange = TRUE;
                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self saveDataToFile];
//                });            
                break;
            }
        } 
    } else if ([kNotificationCommentAction isEqualToString:[data objectForKey:kNotificationAction]])
    {
        //        Issueinfo *issueInfo = [data objectForKey:kNotificationInfoIssueThread];
        //from notificaton to tranIssueInfo
        MyIssueInfo *notificationIssueInfo = [data objectForKey:kNotificationInfoIssueThread];
        MyIssueInfo *tranIssueInfo = [[[MyIssueInfo alloc] init] autorelease];
        tranIssueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:notificationIssueInfo.dataDict]; 
        
//        if ([tranIssueInfo.issuecategory intValue] != 3) {
//            [self.tweetView.dataArr insertObject:tranIssueInfo atIndex:0];            
//        }
        for (int i = 0; i < [self.tweetView.dataArr count]; i++) {
            Issueinfo *parentIssueInfo = [self.tweetView.dataArr objectAtIndex:i];
            if ([parentIssueInfo.id isEqualToNumber:tranIssueInfo.parentid]) {
                if (!tranIssueInfo.id) {
                    NSMutableArray *cmtList = ((MyIssueInfo *)parentIssueInfo).commentList;
                    [cmtList addObject:tranIssueInfo];
                    if(cmtList.count>3)
                    {
                        [cmtList removeObjectAtIndex:0];
                    }
                    ((MyIssueInfo *)parentIssueInfo).commentList = cmtList;
                    parentIssueInfo.commentcnt =  [NSNumber numberWithInt:([parentIssueInfo.commentcnt intValue] + 1)];
                    break;
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
                }
            }            
        }    
        if (self.isViewLoaded && self.view.window) {
            [self.tweetView.tableView reloadData];
//            if ([tranIssueInfo.issuecategory intValue] != 3) {
//                [self viewScrollToTop];
//            }
        } else {
            _isDataChange = YES;   
//            if ([tranIssueInfo.issuecategory intValue] != 3) {
//                _isScrollTop = TRUE;
//            };
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self saveDataToFile];
//        });  
        return;
        
    }
    
    
}

-(void)updateView:(ClPageTableView *)tableView withResponse:(TagInfoCom *)response
{
    //    if (response.issueInfoList && response.issueInfoList.count > 0)
    //    {
    //        NSArray *tmpArr = nil;
    //        
    //        if ([response.searchStartID intValue] != -1) {
    //            tmpArr = [NSArray arrayWithArray:tableView.dataArr];
    //            [tableView.dataArr removeAllObjects];
    //        }
    //        
    //        [tableView.dataArr addObjectsFromArray:response.issueInfoList];
    //        if (tmpArr && response.issueInfoList.count < tableView.pageSize) {
    //            [tableView.dataArr addObjectsFromArray:tmpArr];
    //        }
    //    }
    //    
    //    if ([response.searchStartID intValue] == -1) {
    //        [tableView checkMore:response.issueInfoList];
    //    }
    
    if (response.issueInfoList && response.issueInfoList.count > 0)
    {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
        [tableView.dataArr addObjectsFromArray:response.issueInfoList];
    } else {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
    }
    
    if ([response.searchStartID longLongValue] == -1) {
        [tableView checkMore:response.issueInfoList];
    }
    tableView.tableView.tag=tableViewTag;
    //    NSLog(@"tableView tag====%d",tableViewTag);
    [tableView.tableView reloadData];
}

-(void)addResultlableToTableView:(UITableView *) tableView{
    UILabel *label = [[FloggerUIFactory uiFactory] createLable];
    label.frame = CGRectMake(20, 0, 300, tableView.rowHeight);
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [[[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:0.7] autorelease];
    label.text = NSLocalizedString(@"No result.", @"No result.");
    label.textAlignment = UITextAlignmentCenter;
    label.tag = 300;
    [tableView addSubview:label];
}
-(void) setResultTOTableView{
    //com.issueInfoList && com.issueInfoList.count > 0 &&
    if ( [self.photoView.dataArr count] >0){
        ((UIButton *)([self.view viewWithTag:kTagTweetBtn])).selected = NO;
        ((UIButton *)([self.view viewWithTag:kTagVideoBtn])).selected = NO;
        ((UIButton *)([self.view viewWithTag:kTagPhotoBtn])).selected = YES;
        [self showView:kPhotoTag];
        if ([self.videoView.dataArr count] <=0) {
            [self addResultlableToTableView:self.videoView.tableView ];
        }
        if ([self.tweetView.dataArr count] <=0) {
            [self addResultlableToTableView:self.tweetView.tableView ];
        }
    }else if ([self.videoView.dataArr count] >0){
        [self addResultlableToTableView:self.photoView.tableView ];
        ((UIButton *)([self.view viewWithTag:kTagTweetBtn])).selected = NO;
        ((UIButton *)([self.view viewWithTag:kTagVideoBtn])).selected = YES;
        ((UIButton *)([self.view viewWithTag:kTagPhotoBtn])).selected = NO;
        [self showView:kVideoTag];
        if ([self.tweetView.dataArr count] <=0) {
            [self addResultlableToTableView:self.tweetView.tableView ];
        }
    }else if ( [self.tweetView.dataArr count] >0){
        [self addResultlableToTableView:self.photoView.tableView ];
        [self addResultlableToTableView:self.videoView.tableView ];
        ((UIButton *)([self.view viewWithTag:kTagTweetBtn])).selected = YES;
        ((UIButton *)([self.view viewWithTag:kTagVideoBtn])).selected = NO;
        ((UIButton *)([self.view viewWithTag:kTagPhotoBtn])).selected = NO;
        [self showView:kTweetTag];
    }else{
        [self addResultlableToTableView:self.photoView.tableView ];
        [self addResultlableToTableView:self.videoView.tableView ];
        [self addResultlableToTableView:self.tweetView.tableView ];
        ((UIButton *)([self.view viewWithTag:kTagTweetBtn])).selected = NO;
        ((UIButton *)([self.view viewWithTag:kTagVideoBtn])).selected = NO;
        ((UIButton *)([self.view viewWithTag:kTagPhotoBtn])).selected = YES;
        [self showView:kPhotoTag];
    }
    
    [((UIButton *)([self.view viewWithTag:kTagPhotoBtn])) addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [((UIButton *)([self.view viewWithTag:kTagVideoBtn])) addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [((UIButton *)([self.view viewWithTag:kTagTweetBtn])) addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    
    TagInfoCom *com = (TagInfoCom *)serverproxy.response;
    self.loading = NO;
    
    if (serverproxy == self.photoSp) {
        [self updateView:self.photoView withResponse:com];
        
        if (!self.loadingThread) {
            self.loadingThread = NO;
            [self doRequestVideo:NO];
        }
        //        if (com.issueInfoList && com.issueInfoList.count > 0)
        //        {
        //            self.loadingThread = YES;
        //            [self updateView:self.photoView withResponse:com];
        //        } else {
        //            if (!self.loadingThread) {
        //                //                self.loadingThread = YES;
        //                [self doRequestTweet:NO];
        //            }            
        //        }
    }else if(serverproxy == self.videoSp){
        [self updateView:self.videoView withResponse:com];
        
        if (!self.loadingThread) {
            self.loadingThread = NO;
            [self doRequestTweet:NO];
        }
    }else if(serverproxy == self.tweetSp){
        [self updateView:self.tweetView withResponse:com];        
        if (!self.loadingThread) {
            self.loadingThread = YES;
            //            [self doRequestTweet:NO];
            [self setResultTOTableView];
        }
        
    }
    
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    if (refreshTableView == self.photoView) {
        [self doRequestPhoto:NO];
        //        [self doRequestMedia:NO];
    }
    else if (refreshTableView == self.videoView) {
        [self doRequestVideo:NO];
    }
    else {
        [self doRequestTweet:NO];
    }
}

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)refreshTableView
{
    if (refreshTableView == self.photoView) {
        [self doRequestPhoto:YES];
    }
    else if (refreshTableView == self.videoView) {
        [self doRequestVideo:YES];
    }
    else {
        [self doRequestTweet:YES];
    }
}

-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    if (serverproxy == self.photoSp) {
        self.photoView.lastUpdateDate = [NSDate date];
    }
    else if (serverproxy == self.videoSp) {
        self.videoView.lastUpdateDate = [NSDate date];
    }
    else {
        self.tweetView.lastUpdateDate = [NSDate date];
    }
}

-(void)go2Viewer:(Issueinfo *)issueInfo
{
    FeedViewerViewController *vc = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.issueInfo = [[[MyIssueInfo alloc] init] autorelease];//issueInfo;
    vc.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:issueInfo.dataDict];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)feedGridPageTableView:(FeedGridPageTableView *)feedGridPageTableView atRow:(NSInteger)row withIndex:(NSInteger)index
{
    NSArray *datas = nil;
    if (feedGridPageTableView == self.photoView) {
        datas = self.photoView.dataArr;
        //            [self.addResultlableToTableView:self.photoView.tableView ];
        
    }
    else if (feedGridPageTableView == self.videoView) {
        datas = self.videoView.dataArr;
    }else{
        datas = self.tweetView.dataArr; 
    }
    Issueinfo *info = [datas objectAtIndex:index];//(row * 4 + index)];
    [self go2Viewer:info];
}

-(void)go2Share:(Issueinfo *)issueInfo
{
    ShareFeedViewController *vc = [[[ShareFeedViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.issueList = [[[NSMutableArray alloc] initWithObjects:issueInfo, nil] autorelease];
    vc.shareType = SHAREISSUE;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)go2Profile:(MyAccount *)account
{
    ProfileViewController *vc = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.account = account;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)feedTableView:(FeedTableView *)tableView didSelectedCommentWithIssueInfo:(Issueinfo *)issueinfo
{
    [self go2Viewer:issueinfo];
}

-(void)feedTableView:(FeedTableView *)tableView didSelectedShareWithIssueInfo:(Issueinfo *)info
{
    [self go2Share:info];
}

-(void)feedTableView:(FeedTableView *)tableView didSelectedProfileWithIssueInfo:(Issueinfo *)issueinfo;
{
    MyAccount *account = [[[MyAccount alloc] init] autorelease];
    account.useruid = issueinfo.useruid;
    account.username = issueinfo.username;
    [self go2Profile:account];
}

-(void)showVideo:(Issueinfo *)info
{
    VideoPlayViewController *vc = [[[VideoPlayViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.videoUrl = info.videourl;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)feedTableView:(FeedTableView *)tableView didSelectedImageWithIssueInfo:(Issueinfo *)info
{
    if ([info.issuecategory intValue] == ISSUE_CATEGORY_PICTURE) {
        //        [self showFullImageView];
        //        [self.fullImageView.imageView setImageWithURL:[NSURL URLWithString:info.originalurl]];
    }
    else {
        [self showVideo:info];
    }
}

-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [self.photoSp cancelAll];
    [self.videoSp cancelAll];
    [self.tweetSp cancelAll];
    
    //    @property(nonatomic, retain) TagInfoComServerProxy *photoSp, *videoSp, *tweetSp;
}

@end
