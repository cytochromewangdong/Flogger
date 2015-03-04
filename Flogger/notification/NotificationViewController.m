//
//  NotificationViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationServerProxy.h"
#import "NotificationCom.h"
#import "ClPageTableView.h"
#import "NotificationArrayTableViewCell.h"
#import "EntityEnumHeader.h"
#import "FeedViewerViewController.h"
#import "ProfileViewController.h"
#import "SuggestionUserViewController.h"
#import "SearchViewController.h"
#import "FloggerAppDelegate.h"
#import "UIViewController+iconImage.h"
#import "TagFeedViewController.h"
#import "NewFriendListViewController.h"
#import "SBJson.h"
#import "DataCache.h"
#import "FloggerNavButtonsHelper.h"

#define PAGENUMBER 60
#define LOADINGTEXTVIEWTAG 555


extern NSString * const kFollowingChangedNotification;
@implementation NotificationViewController
@synthesize youBtn, followingBtn, notificationType, usp, startId, endId;
@synthesize notifyLoading,activityLoading,cellLayout,heightview=_heightview;
@synthesize isFollowedChanged;
@synthesize currentNotificationCom,currentUtilityCom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.startId = [NSNumber numberWithInt:-1];
        self.endId = [NSNumber numberWithInt:-1];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
////    [self unregisterNotification];
//    //    if ([GlobalUtils checkIsOwner:self.account]) {
//    //        [self saveDataToFile];
//    //    }
//    
//}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self setNavigationTitleView:NSLocalizedString(@"Announcements", @"Announcements")];
      [FloggerNavButtonsHelper addNavTwoButton:self.navigationController.navigationBar leftBtton:youBtn  rightButton:followingBtn ];
     _isFirst = NO;
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0 &&!_isFirst) {
        self.notificationType = NOTIFICATION_YOU;
        self.youBtn.selected = YES;
        self.followingBtn.selected = NO;
        [self doRequest:NO];
        return;
    }
    if (self.isFollowedChanged)
    {
        //        [self doRequestGetAccountProfile];
        [self doRequest:NO];
        self.isFollowedChanged = NO;
    }
}

-(void)doRequestNotification:(BOOL)isMore
{
//    if (self.notifyLoading)
//    {
//        return;
//    }
//    
//    self.notifyLoading = YES;
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    
    if (!self.serverProxy) 
    {
        self.serverProxy = [[[NotificationServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    NotificationCom *ncom = [[[NotificationCom alloc] init] autorelease];
    
    if (isMore) {
        ncom.searchEndID = self.endId;
        ncom.searchStartID = [NSNumber numberWithInt:-1];
    }
    else
    {
        //ncom.searchStartID = self.startId;
        ncom.searchStartID = [NSNumber numberWithInt:-1];
        ncom.searchEndID = [NSNumber numberWithInt:-1];
    }
    
    ncom.itemNumberOfPage = [NSNumber numberWithInt:PAGENUMBER];
    [((NotificationServerProxy *)self.serverProxy) getNotification:ncom];
}

-(void)doRequestActivities:(BOOL)isMore
{
//    if (self.activityLoading)
//    {
//        return;
//    }
//    
//    self.activityLoading = YES;
    
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.usp) 
    {
        self.usp = [[[UtilityServerProxy alloc] init] autorelease];
        self.usp.delegate = self;
    }
    
    UtilityCom *com = [[[UtilityCom alloc] init] autorelease];
    if (isMore)
    {
        com.searchEndID = self.endId;
        com.searchStartID = [NSNumber numberWithInt:-1];
    }
    else
    {
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
    }
    com.itemNumberOfPage = [NSNumber numberWithInt: PAGENUMBER];
    [self.usp getLatestActivities:com];
}
-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    [super networkFinished:serverproxy];
    if(serverproxy == self.usp)
    {
        self.activityLoading = NO;
    }
    if(serverproxy == self.serverProxy)
    {
        self.notifyLoading = NO;
    }
}
-(void)doRequest:(BOOL)isMore
{
    if (notificationType == NOTIFICATION_YOU)
    {
        [self doRequestNotification:isMore];
    }
    else
    {
        [self doRequestActivities:isMore];
    }
}


-(void) adjustNotificationViewLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
//    view.backgroundColor = [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    self.view = view;    
}
#pragma mark - View lifecycle
-(void) loadView
{
    [self adjustNotificationViewLayout];
}

-(FloggerLayout*) getMainlayout
{
    if(!self.cellLayout)
    {
        NSString *xmlLayoutPath = [[NSBundle mainBundle]pathForResource:@"notification" ofType:@"xml"];
        NSString *xmlCSSLayoutPath = [[NSBundle mainBundle]pathForResource:@"notification.css" ofType:@"xml"];
        cellLayout = [[FloggerLayoutAdapter sharedInstance]createLayout:xmlLayoutPath StylePath:xmlCSSLayoutPath];
    }
    return self.cellLayout;
}

-(BOOL) showFirstActivityView
{
    if (self.tableView.dataArr.count > 0 || self.firstActivityOriginalY < 0) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNotification];
    //todo ttsytleLabel to display the number    
  
    
    
    UIButton *youButton = [[FloggerUIFactory uiFactory] createHeadButton];
    youButton.tag = NOTIFICATION_YOU;
    [youButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [youButton setTitle:NSLocalizedString(@"You", @"You") forState:UIControlStateNormal];
    
    UIButton *followButton = [[FloggerUIFactory uiFactory] createHeadButton];
    followButton.tag = NOTIFICATION_FOLLOWING;
    [followButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];    
    [followButton setTitle:NSLocalizedString(@"Follow", @"Follow") forState:UIControlStateNormal];
    
    int clTableHeight = 0;
    ClPageTableView *clTableView = [[ClPageTableView alloc] initWithFrame:CGRectMake(0, clTableHeight, 320, 367 - clTableHeight)];
    clTableView.dataSource = self;
    clTableView.delegate = self;
    clTableView.pageDelegate = self;
    clTableView.refreshableTableDelegate = self;
    clTableView.pageSize = PAGENUMBER;
    //self.tableView.frame = CGRectMake(0, clTableHeight, 320, 367 - clTableHeight);

    [self.view addSubview:clTableView];
    
    [self setRightNavigationBarWithTitleAndImage:nil image:SNS_SEARCH_BUTTON pressimage:nil];
    [self setLeftNavigationBarWithTitle:@"" image:SNS_SUGGESTED_CONTACT_BUTTON];
    [self setYouBtn:youButton];
    [self setFollowingBtn:followButton];
    [self setTableView:clTableView];
    
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.notificationType = NOTIFICATION_YOU;
    self.youBtn.selected = YES;
    self.followingBtn.selected = NO;
    if (![self restoreData])
    {
        //loading
        ClPageTableView *pageTableView = (ClPageTableView *) self.tableView;
        if (pageTableView.dataArr.count == 0) {
            self.firstActivityOriginalY = self.tableView.frame.origin.y;
        }        
        [self doRequest:NO];
    }
    
    _isFirst = YES;

}

-(void) rightAction:(id)sender
{
    SearchViewController *svc = [[[SearchViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [self.navigationController pushViewController:svc animated:YES];
//    [self.navigationController pushViewController:svc animated:NO];
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
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.youBtn = nil;
    self.followingBtn = nil;
    self.tableView = nil;
    [self unregisterNotification];
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
    self.currentUtilityCom = nil;
    self.currentNotificationCom = nil;
    
    self.youBtn = nil;
    self.cellLayout = nil;
    self.followingBtn = nil;
    self.usp.delegate = nil;
    self.usp = nil;
    self.startId = nil;
    self.endId = nil;
    self.tableView = nil;
    RELEASE_SAFELY(_heightview);
    [super dealloc];
}
//-(void) test
//{
//    if (![self restoreData]) 
//    {
//        [self doRequest:NO];
//    }
//}
-(void)btnClicked:(id)sender
{
    
    NSInteger tag = [(UIButton *)sender tag];
    if (notificationType == tag)
    {
        return;
    }
    [self cancelNetworkRequests];
    
    ((ClPageTableView *)self.tableView).hasMore = NO;
    self.startId = [NSNumber numberWithInt: -1];
    self.endId = [NSNumber numberWithInt:-1];
    
    notificationType = tag;
    
    if (notificationType == NOTIFICATION_YOU) {
        [youBtn setSelected:YES];
        [followingBtn setSelected:NO];
    }
    else
    {
        [youBtn setSelected:NO];
        [followingBtn setSelected:YES];
    }
    [self.tableView.dataArr removeAllObjects];
    [self.tableView.tableView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self restoreData]) 
        {
            [self doRequest:NO];
            self.firstActivityOriginalY = self.tableView.frame.origin.y;
            [self showFirstActivity];
        }
    });
    
}


-(UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger index = [indexPath row];
    NSMutableArray *array = [self.tableView.dataArr objectAtIndex:index];

    //if (index == 0 && [[array objectAtIndex:0] isKindOfClass:[ExternalFriendGroup class]])
    //{
        
    //    return ;
    //}
    static NSString *CellIdentifier = @"NotificationTableViewCell";
    NotificationArrayTableViewCell *cell = [tableView.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) 
    {
        cell = [[[NotificationArrayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        
        cell.celldelegate = self;
    }
      
    [cell fillData:array];
    
    return cell;
}


-(FloggerViewAdpater*)heightview
{
    if(!_heightview)
    {
        _heightview = [[FloggerLayoutAdapter sharedInstance] createViewSet:[self getMainlayout] ParentAapter:nil ActionHandler:nil];   
    }
    return _heightview;
}

#define HEIGHT_KEY @"XXYYY_HEIGHT"
- (GLfloat)caculateHeight:(NSInteger)index
{
    NSMutableArray *row = [self.tableView.dataArr objectAtIndex:index];
    if([[row objectAtIndex:0] isKindOfClass:[ExternalFriendGroup class]])
    {
        ExternalFriendGroup* mainEntry = [row objectAtIndex:0];
        NSNumber *heightOfTheRow = [mainEntry.dataDict objectForKey:HEIGHT_KEY];
        if(heightOfTheRow)
        {
            heightOfTheRow = [mainEntry.dataDict objectForKey:HEIGHT_KEY];
            return heightOfTheRow.floatValue;
        } else {
            // evaluate the height of the cell, it is not necessary to get the number
            if(![mainEntry.dataDict objectForKey:@"topHypertext"])
            {
                NSString * topMsg =  [NSString stringWithFormat:NSLocalizedString(@"You have %d new friends that use <span class='importantBold'>Folo</span>", @""), 100];
                [mainEntry.dataDict setObject:topMsg forKey:@"topHypertext"];
            }
            CGRect rect = [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.heightview ViewDisplayParameters:[NotificationArrayTableViewCell createParamFromEntries:row] DataFillParameters:mainEntry.dataDict InvisibleViews:[NotificationArrayTableViewCell createInvisibleList:row]];
            [mainEntry.dataDict setObject:[NSNumber numberWithFloat:rect.size.height] forKey:HEIGHT_KEY];
            return rect.size.height;//[FeedViewCell tableView:tableView heightForItem:issueinfo];
        }
    }
    else {            
        ActivityResultEntity* mainEntry = [row objectAtIndex:0];
        NSNumber *heightOfTheRow = [mainEntry.dataDict objectForKey:HEIGHT_KEY];
        if(heightOfTheRow)
        {
            heightOfTheRow = [mainEntry.dataDict objectForKey:HEIGHT_KEY];
            return heightOfTheRow.floatValue;
        } else {
            NSString * topMsg =  row.count == 1 ? [NotificationArrayTableViewCell getNotificationStr:mainEntry]:[NotificationArrayTableViewCell getArrayNotificationStr:mainEntry count:row.count];
            [mainEntry.dataDict setObject:topMsg forKey:@"topHypertext"];
            CGRect rect = [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.heightview ViewDisplayParameters:[NotificationArrayTableViewCell createParamFromEntries:row] DataFillParameters:mainEntry.dataDict InvisibleViews:[NotificationArrayTableViewCell createInvisibleList:row]];
            [mainEntry.dataDict setObject:[NSNumber numberWithFloat:rect.size.height] forKey:HEIGHT_KEY];
            return rect.size.height;//[FeedViewCell tableView:tableView heightForItem:issueinfo];
        }
        
    }
    return 200;
}

-(CGFloat)tableView:(ClTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];

    return [self caculateHeight:index];
}

-(void) saveDataToFile
{
    NSMutableDictionary *data = [[[NSMutableDictionary alloc]init]autorelease];
    
    NotificationCom *com = [[[NotificationCom alloc]init]autorelease];
    int startIndex = 0;
    if ([[[self.tableView.dataArr objectAtIndex:0] objectAtIndex:0] isKindOfClass:[ExternalFriendGroup class]]) {
        //friendList
        com.externalFriendList = [self.tableView.dataArr objectAtIndex:0];
        //notificationList
        startIndex = 1;
    }
    NSMutableArray *notificationArray = [[[NSMutableArray alloc] init] autorelease];
    //[notificationArray addObjectsFromArray:];
    for (int i=startIndex; i< [self.tableView.dataArr count]; i++) {
        NSArray *subArrary = [self.tableView.dataArr objectAtIndex:i];
        [notificationArray addObjectsFromArray:subArrary];
    }
    com.notificationList = notificationArray;
    [data setObject:com.dataDict forKey:kSavedDataMainData];

    
    ClPageTableView *pageTable = (ClPageTableView *)self.tableView;
    [data setObject:[NSNumber numberWithBool:pageTable.hasMore] forKey:kSavedDataHasMore];
    //lastupdateTime
    double currentSec = [pageTable.lastUpdateDate timeIntervalSince1970];
    [data setObject:[NSNumber numberWithDouble:currentSec] forKey:kSavedDataLastUpdateTime];
        
    NSIndexPath* indexPath = [self.tableView.tableView indexPathForRowAtPoint:[self.tableView.tableView contentOffset]];
    [data setObject:[NSNumber numberWithDouble:indexPath.row] forKey:kSavedDataCurrentRow];
    NSString *sData = [data JSONRepresentation];
    NSData* pureData = [sData dataUsingEncoding:NSUTF8StringEncoding];
    if (self.notificationType == NOTIFICATION_YOU) {
        self.currentNotificationCom = data;
        [[DataCache sharedInstance]storeData:pureData forKey:kDataCacheNotificationYou Category:kDataCacheTempDataCategory];
        //current time
        CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:currentTime] forKey:kTempNotificationYou];
    } else if (self.notificationType == NOTIFICATION_FOLLOWING) {
        self.currentUtilityCom = data;
        [[DataCache sharedInstance]storeData:pureData forKey:kDataCacheNotificationFollow Category:kDataCacheTempDataCategory];
        //current time
        CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:currentTime] forKey:kTempNotificationFollowing];
    }
}



-(BOOL) restoreData
{
    NSMutableDictionary *data = (self.notificationType == NOTIFICATION_YOU?self.currentNotificationCom:self.currentUtilityCom);
    if(!data)
    {
        NSData* pureData = nil;
        if (self.notificationType == NOTIFICATION_YOU) {
            pureData = [[DataCache sharedInstance]dataFromKey:kDataCacheNotificationYou Category:kDataCacheTempDataCategory];
        } else if (self.notificationType == NOTIFICATION_FOLLOWING) {
            pureData = [[DataCache sharedInstance]dataFromKey:kDataCacheNotificationFollow Category:kDataCacheTempDataCategory];
        }
        if(pureData)
        {
            NSString *sData = [[[NSString alloc]initWithData:pureData encoding:NSUTF8StringEncoding] autorelease];
            
            data = [sData JSONValue];
        }
    }
        
    if(data)
    {   
        ClPageTableView *pageTableView = (ClPageTableView *) self.tableView; 
        NSMutableArray *dataList = [[[NSMutableArray alloc]init]autorelease];
        NotificationCom *com = [[[NotificationCom alloc]init]autorelease];
        if (self.notificationType == NOTIFICATION_YOU)
        {
            com.dataDict = [data objectForKey:kSavedDataMainData];
            [self groupYouActivities:com data:dataList notifications:com.notificationList]; 
            self.currentNotificationCom = data;
        }
        else
        {
            com.dataDict = [data objectForKey:kSavedDataMainData];
            [self groupActivitiesOfFollowing:dataList activities:com.notificationList];
            self.currentUtilityCom = data;
        }

        pageTableView.dataArr = dataList;
        
        pageTableView.hasMore = [[data objectForKey:kSavedDataHasMore] boolValue];
        pageTableView.lastUpdateDate =  [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:kSavedDataLastUpdateTime]doubleValue]];
        
        self.startId = ((ActivityResultEntity *)[com.notificationList objectAtIndex:0]).id;
        self.endId = ((ActivityResultEntity *)[com.notificationList objectAtIndex:com.notificationList.count - 1]).id;
        
        [pageTableView.tableView reloadData];
//        [NSObject cancelPreviousPerformRequestsWithTarget:pageTableView.tableView];
//        [pageTableView.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.0001];
        
        if ([[data objectForKey:kSavedDataCurrentRow]intValue] < [pageTableView.dataArr count]) {
            [pageTableView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[data objectForKey:kSavedDataCurrentRow]intValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        if (self.notificationType == NOTIFICATION_YOU) {
            if (![GlobalUtils checkExpiredTime:kDataCacheNotificationYou]) {
                return YES;
            }
        } else {
            if (![GlobalUtils checkExpiredTime:kDataCacheNotificationFollow]) {
                return YES;
            }
        }
//        return YES;
    }
    return NO;
}



- (void)groupActivitiesOfFollowing:(NSMutableArray *)data activities:(NSMutableArray *)activities
{
    for(ActivityResultEntity* entity in activities)
    {
        if(entity.actiontype.intValue == ACTION_LIKE && entity.parenttype.intValue == PARENT_WEIBO)
        {
            //entity.actiontype.intValue == ACTION_RESPONE_WEIBO || 
            //[data addObject:[self createArrayByActivityEntity:entity]];
            NSMutableArray *rowRecords = [[[NSMutableArray alloc]init]autorelease];
            [rowRecords addObject:entity];
            [data addObject:rowRecords];
            continue;
        }
        
        if(entity.actiontype.intValue == ACTION_RESPONE_WEIBO || ((entity.actiontype.intValue == ACTION_RESPONE_PHOTO || entity.actiontype.intValue == ACTION_RESPONE_VIDEO) && entity.parenttype.intValue == PARENT_WEIBO))
        {
            NSMutableArray *rowRecords = [[[NSMutableArray alloc]init]autorelease];
            [rowRecords addObject:entity];
            [data addObject:rowRecords];
            continue;  
        }
        {
            BOOL hasMatched = NO;
            //NSLog(@"============== %ld====================",entity.useruid.longValue);
            for(NSMutableArray* rowRecords in data)
            {
                ActivityResultEntity* entityExist = [rowRecords objectAtIndex:0];
                if(entityExist.actiontype.intValue == ACTION_LIKE && entityExist.parenttype.intValue == PARENT_WEIBO)
                {
                    // not merge
                    continue;
                }
                if(entityExist.actiontype.intValue == ACTION_RESPONE_WEIBO || ((entityExist.actiontype.intValue == ACTION_RESPONE_PHOTO || entityExist.actiontype.intValue == ACTION_RESPONE_VIDEO) && entityExist.parenttype.intValue == PARENT_WEIBO))
                {
                    // not merge
                    continue;
                }
                //      
                if(entity.useruid.longLongValue == entityExist.useruid.longLongValue 
                   && entity.actiontype.intValue == entityExist.actiontype.intValue
                   && entity.actiontype.intValue == ACTION_FOLLOW)
                {
                    [rowRecords addObject:entity];
                    hasMatched = YES;
                    break;
                }
                if(entity.useruid.longLongValue == entityExist.useruid.longLongValue 
                   && entity.actiontype.intValue == entityExist.actiontype.intValue
                   && entity.parenttype.intValue == entityExist.parenttype.intValue
                   && entity.actiontype.intValue == ACTION_LIKE)
                {
                    [rowRecords addObject:entity];
                    hasMatched = YES;
                    break;
                }
                
                if(entity.useruid.longLongValue == entityExist.useruid.longLongValue 
                   && (entityExist.actiontype.intValue == ACTION_RESPONE_PHOTO || entityExist.actiontype.intValue == ACTION_RESPONE_VIDEO)
                   && (entity.actiontype.intValue == ACTION_RESPONE_PHOTO || entity.actiontype.intValue == ACTION_RESPONE_VIDEO))
                {
                    [rowRecords addObject:entity];
                    hasMatched = YES;
                    break;
                }
            }
            if(!hasMatched)
            {
                NSMutableArray *rowNewRecords = [[[NSMutableArray alloc]init]autorelease];
                [rowNewRecords addObject:entity];
                [data addObject:rowNewRecords];
            }
            //[data addObject:[self createArrayByActivityEntity:entity]];        
        }
    }
}

- (void)groupYouActivities:(NotificationCom *)responseCom data:(NSMutableArray *)data notifications:(NSMutableArray *)notifications
{
    if(responseCom.externalFriendList && [responseCom.externalFriendList count]>0)
    {
        [data addObject:responseCom.externalFriendList];
    }
    for(ActivityResultEntity* entity in notifications)
    {
        NSMutableArray *rowRecords = [[[NSMutableArray alloc]init]autorelease];
        [rowRecords addObject:entity];
        [data addObject:rowRecords];
    }
    if ([responseCom.searchEndID longLongValue] == -1) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        if ([GlobalUtils checkIsLogin]) {
            [self.bcTabBarController.tabBar showBadge];            
        }
    }
}

-(void) clearStoreData
{
    if (self.notificationType == NOTIFICATION_YOU) {
        self.currentNotificationCom = nil;
        [[DataCache sharedInstance] removeDataForKey:kDataCacheNotificationYou 
                                            Category:kDataCacheTempDataCategory];
    } else if (self.notificationType == NOTIFICATION_FOLLOWING) {
        self.currentUtilityCom = nil;
        [[DataCache sharedInstance] removeDataForKey:kDataCacheNotificationFollow Category:kDataCacheTempDataCategory];
    }
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    //
    if (self.firstActivityIndicatorView) {
        [self.firstActivityIndicatorView stopAnimating];
        [[self.view viewWithTag:LOADINGTEXTVIEWTAG] removeFromSuperview];
    }
    
    id response = serverproxy.response;
    
    NSArray *oriArray = nil;
    
    NSMutableArray *data = [[[NSMutableArray alloc]init]autorelease];
    
    if (self.serverProxy == serverproxy && self.notificationType == NOTIFICATION_YOU)
    {
        NotificationCom *responseCom = response;
        NSMutableArray* notifications = [responseCom notificationList];
        oriArray = notifications;
        [self groupYouActivities:responseCom data:data notifications:notifications];
        
    }
    
    if(self.usp == serverproxy && self.notificationType == NOTIFICATION_FOLLOWING)
    {
        NSMutableArray* activities = [(UtilityCom *)response latestActivities];
        oriArray = activities;
        [self groupActivitiesOfFollowing:data activities:activities];
    }
    BasePageParameter *resposeParameter = response; 
    if (data && data.count > 0) {
//        if (!self.startId || [self.startId longLongValue] == -1 || [resposeParameter.searchStartID longLongValue] != -1) {
//            self.startId = ((ActivityResultEntity *)[oriArray objectAtIndex:0]).id;
//        }
//        
//        if (!self.endId || [self.endId longLongValue] == -1 || [resposeParameter.searchEndID longLongValue] != -1) {
//            self.endId = ((ActivityResultEntity *)[oriArray objectAtIndex:oriArray.count - 1]).id;
//        }
        
        //refresh
        if ([resposeParameter.searchEndID longLongValue] == -1 && oriArray.count > 0) {
            self.startId = ((ActivityResultEntity *)[oriArray objectAtIndex:0]).id;
            //self.endId = ((ActivityResultEntity *)[oriArray objectAtIndex:oriArray.count - 1]).id;
        } 
        
        
       // next page
        {
            //self.startId = [NSNumber numberWithInt:-1];
            if (oriArray.count > 0) {
                self.endId = ((ActivityResultEntity *)[oriArray objectAtIndex:oriArray.count - 1]).id;
            }
            
        }
        
        if ([resposeParameter.searchEndID longLongValue] == -1) 
        {
            [self.tableView.dataArr removeAllObjects];
        }
        
        [self.tableView.dataArr addObjectsFromArray:data];
        
        if ([resposeParameter.searchStartID longLongValue] == -1) 
        {
            [(ClPageTableView *)self.tableView checkMore:oriArray];
        }
        
        [self.tableView.tableView reloadData];
        //save
        [self saveDataToFile];
    } else {
        if ([resposeParameter.searchEndID longLongValue] == -1) {
            self.startId = [NSNumber numberWithInt:-1];
            self.endId = [NSNumber numberWithInt:-1];
            [self.tableView.dataArr removeAllObjects];

            [self clearStoreData];
            
            [self.tableView.tableView reloadData];
        }
    }
}

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    [self doRequest:YES];
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    [self doRequest:NO];
}

-(void) viewScrollToTop
{
//    if ([popularBtn isSelected]) {
//        if (_featureView && [_featureView.leftPageView.dataArr count] > 0) {
//            [_featureView.leftPageView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }
//    } else {
//        if (_popularView && [_popularView.leftPageView.dataArr count] > 0) {
//            [_popularView.leftPageView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }
//    }
    
    if (self.tableView && [self.tableView.dataArr count] > 0) {
        [self.tableView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)goCurrentProfile:(ActivityResultEntity *)entity
{
    ProfileViewController *pvc = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    MyAccount *account = [[[MyAccount alloc] init] autorelease];
    account.useruid = entity.useruid;
    account.username = entity.username;
    account.imageurl = entity.imageurl;
    pvc.account = account;
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void)go2UserSelectedProfile:(NSString*)usrID
{
    ProfileViewController *pvc = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    MyAccount *account = [[[MyAccount alloc] init] autorelease];
    account.useruid =[NSNumber numberWithLongLong:[usrID longLongValue]];
    pvc.account = account;
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void)go2Profile:(ActivityResultEntity *)entity
{
    ProfileViewController *pvc = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    MyAccount *account = [[[MyAccount alloc] init] autorelease];
    if (notificationType == NOTIFICATION_YOU) {
        account.useruid = entity.useruid;
        account.username = entity.username;
        account.imageurl = entity.imageurl;
    }
    else {
        account.useruid = entity.targetuseruid;
        account.username = entity.targetusername;
        account.imageurl = entity.targetimageurl;
    }
    pvc.account = account;
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void)NotificatinPhotoCellButtonParentMediaOnClick:(ActivityResultEntity *)entity
{
    if (entity.actiontype.intValue == ACTION_FOLLOW) {
        [self go2Profile:entity];
        return;
    }
    
    FeedViewerViewController *viewerController = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    //viewerController.issueInfo = [[[MyIssueInfo alloc] init] autorelease];
    //viewerController.issueInfo.id = entity.parentid;
    //viewerController.issueInfo.hypertext = @"";
    viewerController.issueInfo = entity.parentThread;
    [self.navigationController pushViewController:viewerController animated:YES];
}
-(void)NotificatinPhotoCellTagOnClick:(ActivityResultEntity*)entity
{
    FeedViewerViewController *viewerController = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    //viewerController.issueInfo = [[[MyIssueInfo alloc] init] autorelease];
    //viewerController.issueInfo.id =  entity.parentid&&[entity.parentid longLongValue]>0? entity.parentid:entity.actionid;
    viewerController.issueInfo = entity.parentThread;
    //viewerController.issueInfo.hypertext = @""; 
    [self.navigationController pushViewController:viewerController animated:YES];  
}
-(void)NotificatinProfileClick:(MyAccount*)entity
{
    ProfileViewController *pvc = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    pvc.account = entity;
    [self.navigationController pushViewController:pvc animated:YES];
}
-(void)openTag:(NSString *)tag
{
    Taglist *taglist = [[[Taglist alloc] init] autorelease];
    taglist.content = tag;
    TagFeedViewController *vc = [[[TagFeedViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.taginfo = taglist;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)NotificatinPhotoCellButtonMediaOnClick:(ActivityResultEntity *)entity
{
    if (entity.actiontype.intValue == ACTION_FOLLOW) {
        [self go2Profile:entity];
        return;
    }
    
    FeedViewerViewController *viewerController = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewerController.issueInfo = entity.currentThread;
    //viewerController.issueInfo = [[[MyIssueInfo alloc] init] autorelease];
    //viewerController.issueInfo.id = entity.actionid;
    //viewerController.issueInfo.hypertext = @""; 
    [self.navigationController pushViewController:viewerController animated:YES];
}
-(void)RecommandClick:(NSArray*)groupFriends
{
    NewFriendListViewController *newFriendListViewController = [[[NewFriendListViewController alloc] init] autorelease];
    newFriendListViewController.data = groupFriends;
    [self.navigationController pushViewController:newFriendListViewController animated:YES];
}
-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];

    [self.usp cancelAll];
}

-(void)followChanged
{
    self.isFollowedChanged = YES;
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(followChanged) 
                                                 name:kFollowingChangedNotification object:nil];
}

-(void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFollowingChangedNotification object:nil];
}





@end
