//
//  FeedViewerViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FeedViewerViewController.h"
#import "IssueInfoComServerProxy.h"
#import "IssueInfoCom.h"
#import "ShareFeedViewController.h"
#import "MyAccount.h"
#import "ProfileViewController.h"
#import "VideoPlayViewController.h"
#import "DataCache.h"
#import "FloggerCameraControl.h"
#import "GlobalData.h"
#import "CommentPostViewController.h"
#import "MyIssueInfo.h"
#import "UIViewController+iconImage.h"
#import "UIViewController+iconImage.h"
#import "EntityEnumHeader.h"
#define kCurrentAction @"viewer"
#define COMMENTPAGESIZE 1000
@implementation FeedViewerViewController
@synthesize feedView, issueInfo;
@synthesize viewerMode,showHeader;
@synthesize issueListArray;

- (void)decorateDesc:(ClPageTableView *)tableView
{
    for (int i=1; i < [tableView.dataArr count]; i++) {
        Issueinfo* currentRec  = [tableView.dataArr objectAtIndex:i];
        NSString * deco;
        if (currentRec.hypertext) {
            deco = [NSString stringWithFormat:@"<span class='userFormat'>%@:</span> %@",currentRec.username,currentRec.hypertext];
        } else {
            deco = [NSString stringWithFormat:@"<span class='userFormat'>%@:</span>",currentRec.username];
        }
        
        [currentRec.dataDict setObject:deco forKey:@"decoratedHypertext"];
        
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showHeader = YES;
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

-(void)doRequest:(BOOL)isMore
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[IssueInfoComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    
    if (isMore)
    {
        issueInfoCom.searchEndID = self.feedView.endId;
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
    }
    else
    {
        issueInfoCom.searchEndID = [NSNumber numberWithInt:-1];
        
//        if (self.feedView.dataArr.count > 1) 
//        {
//            issueInfoCom.searchStartID = ((Issueinfo *)[self.feedView.dataArr objectAtIndex:1]).id;
//        }
//        else {
//            issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
//        }
        
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
    }
        
//    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:self.feedView.pageSize];
    issueInfoCom.issueId = self.issueInfo.id;
//    NSLog(@"issueid: %lld", [self.issueInfo.id longLongValue]);
    [(IssueInfoComServerProxy *)self.serverProxy getThread:issueInfoCom];
    
}

-(void)updateView:(ClPageTableView *)tableView withResponse:(IssueInfoCom *)response
{
    if (response.myIssueInfoList && response.myIssueInfoList.count > 0)
    {
        NSMutableArray *tmpArr = nil;
        if ([response.searchStartID longLongValue] != -1) {                      
            tmpArr = [NSArray arrayWithArray:tableView.dataArr];
        }
        [tableView.dataArr removeAllObjects];
        [tableView.dataArr addObject:self.issueInfo];
        // show the desciption of the header as comment
        if(self.issueInfo.hypertext && self.issueInfo.hypertext.length > 0)
        {
            MyIssueInfo *newIssue = [[[MyIssueInfo alloc] init] autorelease];
            newIssue.dataDict = [NSMutableDictionary dictionaryWithDictionary:self.issueInfo.dataDict];
            newIssue.issuecategory = [NSNumber numberWithInt:3];
            newIssue.bmiddleurl = nil;
            [tableView.dataArr addObject:newIssue]; 
        }
        [tableView.dataArr addObjectsFromArray:response.myIssueInfoList];
        if (tmpArr && response.myIssueInfoList.count < tableView.pageSize) {
            [tableView.dataArr addObjectsFromArray:tmpArr];
        }
//        [tableView.dataArr removeAllObjects];
//        [tableView.dataArr addObjectsFromArray:response.myIssueInfoList];
    } else {
        //refresh
        if ([response.searchEndID longLongValue] == -1) {                      
//            tmpArr = [NSArray arrayWithArray:tableView.dataArr];
            [tableView.dataArr removeAllObjects];
            [tableView.dataArr addObject:self.issueInfo];
            // show the desciption of the header as comment
            if(self.issueInfo.hypertext && self.issueInfo.hypertext.length > 0)
            {
                MyIssueInfo *newIssue = [[[MyIssueInfo alloc] init] autorelease];
                newIssue.dataDict = [NSMutableDictionary dictionaryWithDictionary:self.issueInfo.dataDict];
                newIssue.issuecategory = [NSNumber numberWithInt:3];
                newIssue.bmiddleurl = nil;
                [tableView.dataArr addObject:newIssue]; 
            }

        }
    }
    [self decorateDesc:tableView];
    
    if ([response.searchStartID longLongValue] == -1) 
    {
        [tableView checkMore:response.myIssueInfoList];
    }
    
//    [self saveDataToFile];
    [tableView.tableView reloadData];
}


-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
//    NSLog(@"=== comment finish is ===");
    [super transactionFinished:serverproxy];
    
    self.issueInfo = [(IssueInfoCom *)serverproxy.response threadHead];

    
    if (self.feedView.dataArr.count > 0) {
        [self.feedView.dataArr removeObjectAtIndex:0];
    }
    [self.feedView.dataArr insertObject:self.issueInfo atIndex:0];
    
    [self updateView:self.feedView withResponse:(IssueInfoCom *)serverproxy.response];
    [self.feedView.tableView reloadData];
}

#pragma mark - View lifecycle
-(void) adjustFeedViewerLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
    self.view = view;
    
    
    UIImage *writeCommentImage = [[FloggerUIFactory uiFactory] createImage:SNS_COMMENT_BAR];
//    UIImage *commentCameraBackground = [[FloggerUIFactory uiFactory] createImage:SNS_COMMENT_CAMERA_BACKGROUND];
//    UIImage *commentCameraButtonImage = [[FloggerUIFactory uiFactory] createImage:SNS_COMMENT_CAMERA_BUTTON];
    
    UIButton *writeCommentBtn = [[FloggerUIFactory uiFactory] createButton:nil];
//    [writeCommentBtn setBackgroundImage:writeCommentImage forState:UIControlStateNormal];
    [writeCommentBtn setImage:writeCommentImage forState:UIControlStateNormal];
    
    writeCommentBtn.frame = CGRectMake(0, self.view.frame.size.height - writeCommentImage.size.height, writeCommentImage.size.width, writeCommentImage.size.height);
    [writeCommentBtn addTarget:self action:@selector(comBtnClicked:) forControlEvents:UIControlEventTouchUpInside];  
//    [writeCommentBtn setTitle:NSLocalizedString(@"Add Comment...", @"Add Comment...") forState:UIControlStateNormal];

    UILabel *lable = [[FloggerUIFactory uiFactory] createLable];
    lable.frame = CGRectMake(12, 0, writeCommentBtn.frame.size.width, writeCommentBtn.frame.size.height);
    lable.textAlignment = UITextAlignmentLeft;
    lable.userInteractionEnabled = NO;
    lable.textColor = [[[UIColor alloc] initWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0] autorelease]; //RGBA(151, 151, 151, 1);//[UIColor blackColor];
    lable.font = [UIFont boldSystemFontOfSize:15];
    lable.text = NSLocalizedString(@"Add Comment...", @"Add Comment...");    
    [writeCommentBtn addSubview:lable];
    
//    [self.view addSubview:lable];
    CGRect frame;
    if (!self.bcTabBarController) {
        frame = CGRectMake(0, 0, 320, 416);
    } else if ([GlobalData sharedInstance].myAccount && !self.showHeader) {
        [self.view addSubview:writeCommentBtn];
        frame = CGRectMake(0, 0, 320, self.view.frame.size.height - writeCommentImage.size.height);
    } else {
//        frame = CGRectMake(0, 0, 320, 363);
        frame = CGRectMake(0, 0, 320, 367);
    }
//    CGRect frame = CGRectMake(0, 0, 320, 367);
    
    ViewerFeedTableView *feedTableView = [[[ViewerFeedTableView alloc] initWithFrame:frame]autorelease];
    feedTableView.action =kCurrentAction;


    [self.view addSubview:feedTableView];
    
    [self setFeedView:feedTableView];   
    
//    if (![GlobalUtils checkIsLogin]) {
//        UITabBar *tabBar = [[[UITabBar alloc] init] autorelease];
//        tabBar.frame = CGRectMake(0, 367, 320, 49);
//        [self.view addSubview:tabBar];
//    }

    // add swipeGesture
    UISwipeGestureRecognizer *swipeLeftGesture = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftViewController)]autorelease];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRightGesture = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightViewController)]autorelease];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeftGesture];
    [self.view addGestureRecognizer:swipeRightGesture];
    
}

-(void) go2AnotherViewControl : (Issueinfo *) newIssueInfo
{
    FeedViewerViewController *feedViewControl = [[[FeedViewerViewController alloc] init]autorelease];
    feedViewControl.issueInfo = [[[MyIssueInfo alloc] init] autorelease];
    feedViewControl.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:newIssueInfo.dataDict];
    feedViewControl.issueListArray = self.issueListArray;
    [self.navigationController pushViewController:feedViewControl animated:NO];

}

-(void)backAction:(id)sender
{ 
    if (self.issueListArray) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//-(void)leftAction:(id)sender
//{
//    [super leftAction:sender];
//    [self.navigationController popToRootViewControllerAnimated:NO];
//}

-(void) swipeRightViewController
{
    if (!self.issueListArray) {
        return;
    }
    int currentIndex = 0;
    for (int i = 0; i < self.issueListArray.count; i++) {
        Issueinfo *issueMember = [self.issueListArray objectAtIndex:i];
        if ([issueMember.id isEqualToNumber:self.issueInfo.id]) {
            currentIndex = i;
            break;
        }
    }
    //currentIndex  = currentIndex - 1;
    currentIndex--;
    if (currentIndex < self.issueListArray.count) {
        Issueinfo *newIssue = [self.issueListArray objectAtIndex:currentIndex];
        [self performSelector:@selector(go2AnotherViewControl:) withObject:newIssue afterDelay:0.01];
    }
}

-(void) swipeLeftViewController
{
    if (!self.issueListArray) {
        return;
    }
    int currentIndex = 0;
    for (int i = 0; i < self.issueListArray.count; i++) {
        Issueinfo *issueMember = [self.issueListArray objectAtIndex:i];
        if ([issueMember.id isEqualToNumber:self.issueInfo.id]) {
            currentIndex = i;
            break;
        }
    }
    //currentIndex  = currentIndex +1;
    currentIndex++;
    if (currentIndex < self.issueListArray.count) {
        Issueinfo *newIssue = [self.issueListArray objectAtIndex:currentIndex];
        [self performSelector:@selector(go2AnotherViewControl:) withObject:newIssue afterDelay:0.01];
    }
}


-(void) loadView
{
    [self adjustFeedViewerLayout];
}
- (void) handleAction:(NSNotification *)notification
{
    if(!notification.object)
    {
        [feedView.tableView reloadData];
    }
}
-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:kShapeWeb object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:kCurrentAction object:nil];
}
-(void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShapeWeb object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCurrentAction object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotification];
    
//    [self saveDataToFile];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];   
    [self registerNotification];
    
    if(_isDataChange)
    {
        _isDataChange = NO;
        [self.feedView.tableView reloadData];
    }

    //title view
    if ([issueInfo.issuecategory intValue]==ISSUE_CATEGORY_PICTURE) {
        [self setNavigationTitleView:NSLocalizedString(@"Photo", @"Photo")];
    } else if([issueInfo.issuecategory intValue]==ISSUE_CATEGORY_VIDEO) {
        [self setNavigationTitleView:NSLocalizedString(@"Video", @"Video")];
    } else if([issueInfo.issuecategory intValue]==ISSUE_CATEGORY_TWEET) {
        [self setNavigationTitleView:NSLocalizedString(@"Shout", @"Shout")];
    }
        
}

-(void) commentScrollToEnd
{
//    NSLog(@"==== test 2 feedview count is %d",feedView.dataArr.count);
    if (!self.showHeader && feedView.dataArr.count > 1) {
        [feedView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:feedView.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        [self setNavigationTitleView:NSLocalizedString(@"Comments", @"Comments")];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
    
    //scroll to end
    [self commentScrollToEnd];
    
    if (!self.showHeader && feedView.dataArr.count > 1) {
//        [feedView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:feedView.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
      [self setNavigationTitleView:NSLocalizedString(@"Comments", @"Comments")];
    }
}

-(BOOL) checkIsFullScreen
{
    if ([GlobalUtils checkIsLogin] && self.showHeader) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    //NSLog(@"====comment view did load");
    [super viewDidLoad];   
    // Do any additional setup after loading the view from its nib.
    [feedView.dataArr addObject:issueInfo];
    
    if([issueInfo isKindOfClass:[MyIssueInfo class]] && !self.showHeader)
    {
        MyIssueInfo *myissue = (MyIssueInfo *)issueInfo;
        if (myissue.hypertext && myissue.hypertext.length > 0)
        {
            MyIssueInfo *newIssue = [[[MyIssueInfo alloc] init] autorelease];
            newIssue.dataDict = [NSMutableDictionary dictionaryWithDictionary:myissue.dataDict];
            newIssue.issuecategory = [NSNumber numberWithInt:3];
            newIssue.bmiddleurl = nil;
            [feedView.dataArr addObject:newIssue];
        }
        [feedView.dataArr addObjectsFromArray:myissue.commentList];
        [self decorateDesc:feedView];

    }
//    feedView.pageDelegate = self;
    feedView.feedTableDelegate = self;
    feedView.refreshableTableDelegate = self;
    feedView.pageSize = COMMENTPAGESIZE;
    feedView.showHeader = self.showHeader;
    [feedView.tableView reloadData];
    
//    if (!self.showHeader) {
        [self doRequest:NO];
//    }
    

//    if(![self restoreData])
//    {
//        [self doRequest:NO];
//    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    RELEASE_SAFELY(feedView);
//    RELEASE_SAFELY(issueInfo);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)comBtnClicked:(id)sender
{
    CommentPostViewController *vc = [[[CommentPostViewController alloc] init] autorelease];
    vc.issueinfo = self.issueInfo;
    vc.composeMode = COMMENTMODE;
    [self.navigationController pushViewController:vc animated:NO];
}


-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    [self doRequest:NO];
}

-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    self.feedView.isLoading = NO;
    self.feedView.isLoadingMore = NO;
    self.feedView.lastUpdateDate = [NSDate date];
    [super networkFinished:serverproxy];
}

-(void) dataChangeAction : (NSNotification *) notification
{
    if(!self.feedView || [self.feedView.dataArr count] == 0)
    {
        NSString *dataKey = [NSString stringWithFormat:@"%@%d",kDataCacheCommentData,self.issueInfo.useruid];
        [[DataCache sharedInstance]removeDataForKey:dataKey]; 
        return;
    }
    NSMutableDictionary *data = (NSMutableDictionary *) notification.object;
    if ([kNotificationCommentAction isEqualToString:[data objectForKey:kNotificationAction]]) 
    {
        Issueinfo *notificationIssueInfo = [data objectForKey:kNotificationInfoIssueThread];
        Issueinfo *tranIssueInfo = [[[MyIssueInfo alloc] init] autorelease];
        tranIssueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:notificationIssueInfo.dataDict];
        
        if (self.showHeader) {
            if ([self.issueInfo.id isEqualToNumber:tranIssueInfo.parentid]) {
                //if ([tranIssueInfo.issuecategory intValue] != 3)
                {
                    [self.feedView.dataArr addObject:tranIssueInfo];            
                }
                //            Issueinfo *parentIssueInfo = [self.feedView.dataArr objectAtIndex:0];
                //            NSMutableArray *cmtList = ((MyIssueInfo *)parentIssueInfo).commentList;
                //            [cmtList addObject:tranIssueInfo];
                //            if(cmtList.count>3)
                //            {
                //                [cmtList removeObjectAtIndex:0];
                //            }
                //            ((MyIssueInfo *)parentIssueInfo).commentList = cmtList;
                //            parentIssueInfo.commentcnt =  [NSNumber numberWithInt:([parentIssueInfo.commentcnt intValue] + 1)];
                
                Issueinfo *parentIssueInfo = [self.feedView.dataArr objectAtIndex:0];
                if (!tranIssueInfo.id) {
                    
                    NSMutableArray *cmtList = ((MyIssueInfo *)parentIssueInfo).commentList;
                    [cmtList addObject:tranIssueInfo];
                    if(cmtList.count>3)
                    {
                        [cmtList removeObjectAtIndex:0];
                    }
                    ((MyIssueInfo *)parentIssueInfo).commentList = cmtList;
                    parentIssueInfo.commentcnt =  [NSNumber numberWithInt:([parentIssueInfo.commentcnt intValue] + 1)];
                } else
                {
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
        } else
        {
            if (!tranIssueInfo.id) {
                [self.feedView.dataArr addObject:tranIssueInfo];
            } else
            {
                BOOL isExist = NO;
                NSString *transLocalID =  [tranIssueInfo.dataDict objectForKey:kLocalIssueID];
                for (int i = 1; i < [self.feedView.dataArr count]; i++) {
                    Issueinfo *currentIssueInfo = [self.feedView.dataArr objectAtIndex:i];
                    NSString * currentLocalID = [currentIssueInfo objectForKey:kLocalIssueID];
                    if ([transLocalID isEqualToString:currentLocalID]) {
                        currentIssueInfo.dataDict = tranIssueInfo.dataDict;
                        isExist = YES;
                        //                        NSString *transLocalID =  [tranIssueInfo.dataDict objectForKey:kLocalIssueID];
                        //                        NSString * currentLocalID = [currentIssueInfo.dataDict objectForKey:kLocalIssueID];
                        //                        if ([currentLocalID isEqualToString:transLocalID]) {
                        //                            currentIssueInfo.dataDict = tranIssueInfo.dataDict;
                        //                            isExist = YES;
                        //                        }
                        break;
                    }
                } 
                if (!isExist) {
                    [self.feedView.dataArr addObject:tranIssueInfo];
                }
            }
            
             
        }
        //comment list replace end
        
        if (self.isViewLoaded && self.view.window) {
            [self.feedView.tableView reloadData];
            [self commentScrollToEnd];
        } else {
            _isDataChange = TRUE;
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self saveDataToFile];
//        });  
        return;
    } else if ([kNotificationLikeAction isEqualToString:[data objectForKey:kNotificationAction]])
    {
        NSNumber *issueId = [data objectForKey:kNotificationInfoIssueId];
        Issueinfo *headIssue = [self.feedView.dataArr objectAtIndex:0];
         MyIssueInfo * myIssueInfor = (MyIssueInfo *)headIssue;
        if ([headIssue.id isEqualToNumber:issueId]) {
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
            
            headIssue.likecnt = [NSNumber numberWithInt:issueInfo.likecnt.intValue + 1];
            ((MyIssueInfo *)headIssue).liked = [NSNumber numberWithBool:YES];
            if (self.isViewLoaded && self.view.window) {
                [self.feedView.tableView reloadData];
            } else {
                _isDataChange = TRUE;
            }   
        }
        
    } else if ([kNotificationUnLikeAction isEqualToString:[data objectForKey:kNotificationAction]])
    {        
        NSNumber *issueId = [data objectForKey:kNotificationInfoIssueId];
        Issueinfo *headIssue = [self.feedView.dataArr objectAtIndex:0];  
         MyIssueInfo * myIssueInfor = (MyIssueInfo *)headIssue;
        if ([headIssue.id isEqualToNumber:issueId]) {
            
            AccountCom *com =[GlobalData sharedInstance].myAccount;
            //NSLog(@"jiesu %@", [NSString stringWithFormat:NSLocalizedString(@"%d people",@"%d people"),[ myIssueInfor.id longLongValue ],[myIssueInfor.likecnt intValue]-1]);
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
            headIssue.likecnt = [NSNumber numberWithInt:issueInfo.likecnt.intValue - 1];
            ((MyIssueInfo *)headIssue).liked = [NSNumber numberWithBool:NO];
            
            if (self.isViewLoaded && self.view.window) {
                [self.feedView.tableView reloadData];
            } else {
                _isDataChange = TRUE;
            }
        }
    }   
    
} 
-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    self.feedView.isLoadingMore = NO;
}


-(void) dealloc
{
    self.issueListArray = nil;
    self.feedView.delegate = nil;
    self.feedView = nil;
    self.issueInfo = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataChangeIssueInfo object:nil];
    [super dealloc];
}

@end
