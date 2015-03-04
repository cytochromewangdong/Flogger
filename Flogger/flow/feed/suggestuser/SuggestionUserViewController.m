//
//  SuggestionUserViewController.m
//  Flogger
//
//  Created by jwchen on 12-3-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SuggestionUserViewController.h"
#import "IssueInfoCom.h"
#import "FeedTableView.h"
#import "SuggestUserViewCell.h"
#import "FollowCom.h"
#import "ProfileViewController.h"
#import "FeedViewerViewController.h"
#import "FindFriendSelectionViewController.h"
#import "FloggerAppDelegate.h"
#import "SBJson.h"
#import "DataCache.h"
#import "FloggerNavButtonsHelper.h"

#define kPopularTag 1000
#define kFeatureTag kPopularTag + 1

extern NSString * const kFollowingChangedNotification;

@implementation SuggestionUserViewController
@synthesize userType, featuredBtn, popularBtn, followSp, accountSp, issueSp/*, featureView, popularView, contentView*/;

@synthesize loading2,loadingFeature;
@synthesize isFirstScreen;
@synthesize currentIssueInfoCom,currentAccountCom;

-(void)notifyFollowingChanged
{
    NSNotification *note = [NSNotification notificationWithName:kFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL) checkIsFullScreen
{
    if (self.isFirstScreen) {
        return YES;
    } else {
        return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
//-(BOOL) checkIsFullScreen
//{
//    return YES;
//}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self setNavigationTitleView: NSLocalizedString(@"Suggested users",@"Suggested users")];
   [FloggerNavButtonsHelper addNavTwoButton:self.navigationController.navigationBar leftBtton:featuredBtn  rightButton: popularBtn];

    if (isFirstScreen) {
        [self setRightNavigationBarWithTitle:NSLocalizedString(@"Done", @"Done") image:nil];
    } else {
        [self setRightNavigationBarWithTitle:nil image:SNS_SUGGESTED_FIND_FRIENDS];
    }
        
    
}

-(void)doRequestPopular:(BOOL)isMore
{
//    if(self.loading2)
//    {
//        return;
//    }
//    
//    self.loading2 = YES;

    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    
    if (!self.issueSp) {
        self.issueSp = [[[IssueInfoComServerProxy alloc] init] autorelease];
        self.issueSp.delegate = self;
    }
    
    IssueInfoCom *com = [[[IssueInfoCom alloc] init] autorelease];
    
//    NSInteger currentPage = 1;
//    if (isMore) {
////        currentPage = ((ClPageTableView *)self.tableView).currentPage ++;
//    }
    
    if (isMore) {
        //        currentPage = ((ClPageTableView *)self.tableView).currentPage ++;
        com.searchEndID = ((ClPageTableView *)self.tableView).endId;
//        NSLog(@"==== searchendId is %@",com.searchEndID);
        com.searchStartID = [NSNumber numberWithInt:-1];        
    } else {
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
    }
    
    
//    com.currentPage = [NSNumber numberWithInt:currentPage];
    com.itemNumberOfPage = [NSNumber numberWithInt:((ClPageTableView *)(self.tableView)).pageSize];
    
    [self.issueSp getPopularUserMedia:com];
}

-(void)doRequestFeatureUser:(BOOL)isMore
{
//    if(self.loadingFeature)
//    {
//        return;
//    }
//    
//    self.loadingFeature = YES;
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    
    if (!self.accountSp) {
        self.accountSp = [[[AccountServerProxy alloc] init] autorelease];
        self.accountSp.delegate = self;
    }
    
    AccountCom *com = [[[AccountCom alloc] init] autorelease];
    com.type = [NSNumber numberWithInt:ACCOUNTCOM_FEATURED];
    NSInteger currentPage = 1;
    if (isMore) {
//        currentPage = ((ClPageTableView *)self.tableView).currentPage ++;
        com.searchEndID = ((ClPageTableView *)self.tableView).endId;
        com.searchStartID = [NSNumber numberWithInt:-1];        
    } else {
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
    }
//    com.currentPage = [NSNumber numberWithInt:currentPage];
    com.itemNumberOfPage = [NSNumber numberWithInt:((ClPageTableView *)(self.tableView)).pageSize];
    [self.accountSp getUserList:com];
}

-(void)doRequest:(BOOL)isMore
{
//    if(self.loading)
//    {
//        return;
//    }
//    
    if (userType == USER_FEATURED) {
        [self doRequestFeatureUser:isMore];
    }
    else
    {
        [self doRequestPopular:isMore];
    }
}

//-(void)setupViews
//{
//    NSInteger x = 0;
//    self.popularView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(x, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)] autorelease];
//    self.popularView.tag = kPopularTag;
//    self.popularView.delegate = self;
//    self.popularView.pageDelegate = self;
//    self.popularView.refreshableTableDelegate = self;
//    [self.contentView addSubview:self.popularView];
//    
//    x += self.contentView.frame.size.width;
//    
//    self.featureView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(x, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)] autorelease];
//    self.featureView.tag = kFeatureTag;
//    self.featureView.pageDelegate = self;
//    self.featureView.refreshableTableDelegate = self;
//    [self.contentView addSubview:self.featureView];
//    
//}

//-(void)showView:(NSInteger)viewTag
//{
//    UIView *view = [self.contentView viewWithTag:viewTag];
//    NSInteger offset = -view.frame.origin.x;
//    [UIView beginAnimations:nil context:nil];
//    
//    CGRect frame = CGRectMake(self.popularView.frame.origin.x + offset, self.popularView.frame.origin.y, self.popularView.frame.size.width, self.popularView.frame.size.height);
//    self.popularView.frame = frame;
//    
//    frame = CGRectMake(self.featureView.frame.origin.x + offset, self.featureView.frame.origin.y, self.featureView.frame.size.width, self.featureView.frame.size.height);
//    self.featureView.frame = frame;
//    
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:500];
//    [UIView commitAnimations];
//}

-(void) adjustSuggestionUserViewLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
    self.view = view;
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];

    
       
    
    UIButton *popularButton = [[FloggerUIFactory uiFactory] createHeadButton];
    [popularButton setTitle:NSLocalizedString(@"Popular", @"Popular") forState:UIControlStateNormal];
    popularButton.tag = USER_POPULAR;
    [popularButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *featureButton = [[FloggerUIFactory uiFactory] createHeadButton];
    [featureButton setTitle:NSLocalizedString(@"Feature", @"Feature") forState:UIControlStateNormal];
    featureButton.tag = USER_FEATURED;
    [featureButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    int pageTableHeight =0;
    ClPageTableView *pageTableView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(0, pageTableHeight, 320, 367- pageTableHeight)] autorelease];
    if (self.isFirstScreen) {
        pageTableView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(0, pageTableHeight, 320, 416- pageTableHeight)] autorelease];
    }
//    [ClPageTableView alloc]
//    CGRectMake(0, featurebtn.frame.origin.y+featurebtn.frame.size.height+5, 320, 372);
    pageTableView.delegate = self;
    pageTableView.dataSource = self;
    pageTableView.backgroundColor = [UIColor clearColor];
    pageTableView.tableView.backgroundColor = [UIColor clearColor];
    
//    pageTableView.
    
    [self.view addSubview:pageTableView];
    [self setTableView:pageTableView];
    
    [self setPopularBtn:popularButton];
    [self setFeaturedBtn:featureButton];
    
//    [self set]
//    [self setn]
//    UIImage *findImage = [[FloggerUIFactory uiFactory] createImage:SNS_SUGGESTED_FIND_FRIENDS];

//    [self]
    
}
-(void) rightAction:(id)sender
{
    if (self.isFirstScreen) {
        [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showTabViewControl];
    } else {
        FindFriendSelectionViewController *friendControl = [[[FindFriendSelectionViewController alloc] init ]autorelease];
        [self.navigationController pushViewController:friendControl animated:YES];
    }

}
#pragma mark - View lifecycle
-(void) loadView
{
    [self adjustSuggestionUserViewLayout];
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
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    //initial
    [self.popularBtn setSelected:NO];
    [self.featuredBtn setSelected:YES];
    self.userType = USER_FEATURED;
    ((ClPageTableView*)self.tableView).idKey = @"useruid";

//    if (![self restoreData]) 
    {
        //loading
        ClPageTableView *pageTableView = (ClPageTableView *) self.tableView;
        if (pageTableView.dataArr.count == 0) {
            self.firstActivityOriginalY = self.tableView.frame.origin.y;
        }        
        [self doRequest:NO];
    }
    
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
    self.currentIssueInfoCom = nil;
    self.currentAccountCom = nil;
    
    self.featuredBtn = nil;
    self.popularBtn = nil;
    
    self.issueSp.delegate = nil;
    self.issueSp = nil;
    
    self.accountSp.delegate = nil;
    self.accountSp = nil;
    
    self.followSp.delegate = nil;
    self.followSp = nil;
    
//    self.contentView = nil;
    
    [super dealloc];
}

-(void)btnClicked:(id)sender
{
    
    
    NSInteger tag = [(UIButton *)sender tag];
    if (userType == tag) {
        return;
    }
    [self cancelNetworkRequests];
    
    ((ClPageTableView *)self.tableView).hasMore = NO;    
    userType = tag;
//    NSInteger showTag = 0;
    if (userType == USER_FEATURED) {
        [featuredBtn setSelected:YES];
        [popularBtn setSelected:NO];
//        showTag = kFeatureTag;
    }
    else
    {
        [featuredBtn setSelected:NO];
        [popularBtn setSelected:YES];
//        showTag = kPopularTag;
    }
    
//    [self showView:showTag];
    [self.tableView.dataArr removeAllObjects];
    [self.tableView.tableView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self restoreDataFromCurrentData]) {
            [self doRequest:NO];
            self.firstActivityOriginalY = self.tableView.frame.origin.y;
            [self showFirstActivity];
        }
    });
    
}


-(void) saveDataToFile
{
    /*NSMutableDictionary *data = [[[NSMutableDictionary alloc]init]autorelease];
    ClPageTableView *pageTableView = (ClPageTableView *) self.tableView;
    if (self.userType == USER_POPULAR)
    {
        IssueInfoCom *com = [[[IssueInfoCom alloc]init]autorelease];
        com.myAccountList = pageTableView.dataArr;
        
        [data setObject:com.dataDict forKey:kSavedDataMainData];
        [data setObject:[NSNumber numberWithBool:pageTableView.hasMore] forKey:kSavedDataHasMore];
        //lastupdateTime
        double currentSec = [pageTableView.lastUpdateDate timeIntervalSince1970];
        [data setObject:[NSNumber numberWithDouble:currentSec] forKey:kSavedDataLastUpdateTime];
                
        NSIndexPath* indexPath = [pageTableView.tableView indexPathForRowAtPoint:[pageTableView.tableView contentOffset]];
        [data setObject:[NSNumber numberWithDouble:indexPath.row] forKey:kSavedDataCurrentRow];
        NSString *sData = [data JSONRepresentation];
        NSData* pureData = [sData dataUsingEncoding:NSUTF8StringEncoding];
        [[DataCache sharedInstance]storeData:pureData forKey:kDataCacheSuggestusersPopular Category:kDataCacheTempDataCategory];
        //time
        CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:currentTime] forKey:kTempSuggestUserTimePopular];
        
    } else if (self.userType == USER_FEATURED) {
        AccountCom *com = [[[AccountCom alloc]init]autorelease];
        com.accountList = pageTableView.dataArr;
        
        [data setObject:com.dataDict forKey:kSavedDataMainData];
        [data setObject:[NSNumber numberWithBool:pageTableView.hasMore] forKey:kSavedDataHasMore];
        //lastupdateTime
        double currentSec = [pageTableView.lastUpdateDate timeIntervalSince1970];
        [data setObject:[NSNumber numberWithDouble:currentSec] forKey:kSavedDataLastUpdateTime];
        
        NSIndexPath* indexPath = [pageTableView.tableView indexPathForRowAtPoint:[pageTableView.tableView contentOffset]];
        [data setObject:[NSNumber numberWithDouble:indexPath.row] forKey:kSavedDataCurrentRow];
        NSString *sData = [data JSONRepresentation];
        NSData* pureData = [sData dataUsingEncoding:NSUTF8StringEncoding];
        [[DataCache sharedInstance]storeData:pureData forKey:kDataCacheSuggestusersFeature Category:kDataCacheTempDataCategory];
        //time
        CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:currentTime] forKey:kTempSuggestUserTimeFeature];
    }*/
    
}
-(BOOL) restoreDataFromCurrentData
{
    NSArray *dataArr = nil;
    BOOL isRestroFromCurrent;
    if (self.userType == USER_POPULAR) {
        if (self.currentIssueInfoCom) {
            dataArr = self.currentIssueInfoCom.myAccountList;
            [self.tableView.dataArr addObjectsFromArray:dataArr];
            [(ClPageTableView *)self.tableView checkMore:dataArr];
            [self.tableView.tableView reloadData];
            isRestroFromCurrent = YES;
        } else {
            isRestroFromCurrent = NO;
        }
    } else if (self.userType == USER_FEATURED){
        if (self.currentAccountCom) {
            dataArr = self.currentAccountCom.accountList;
            [self.tableView.dataArr addObjectsFromArray:dataArr];
            [(ClPageTableView *)self.tableView checkMore:dataArr];
            [self.tableView.tableView reloadData];
            isRestroFromCurrent = YES;
        } else {
            isRestroFromCurrent = NO;
        }
    }
    if (!isRestroFromCurrent) {
        isRestroFromCurrent = [self restoreData];
    }
    return isRestroFromCurrent;
}
-(BOOL) restoreData
{
    NSData* pureData = nil;
    if (self.userType == USER_POPULAR) {
        pureData = [[DataCache sharedInstance]dataFromKey:kDataCacheSuggestusersPopular Category:kDataCacheTempDataCategory];
    } else if (self.userType == USER_FEATURED) {
        pureData = [[DataCache sharedInstance]dataFromKey:kDataCacheSuggestusersFeature Category:kDataCacheTempDataCategory];
    }
    
    if(pureData)
    {
        NSString *sData = [[[NSString alloc]initWithData:pureData encoding:NSUTF8StringEncoding] autorelease];
        ClPageTableView *pageTableView = (ClPageTableView *) self.tableView;
        NSMutableDictionary *data = [sData JSONValue];
        if (self.userType == USER_POPULAR) {
            IssueInfoCom *com = [[[IssueInfoCom alloc]init]autorelease];            
            com.dataDict = [data objectForKey:kSavedDataMainData];
            pageTableView.dataArr = com.myAccountList;
            pageTableView.hasMore = [[data objectForKey:kSavedDataHasMore] boolValue];
            pageTableView.lastUpdateDate =  [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:kSavedDataLastUpdateTime]doubleValue]];
            self.currentIssueInfoCom = com;
        } else  if (self.userType == USER_FEATURED){
            AccountCom *com = [[[AccountCom alloc]init]autorelease];
            com.dataDict = [data objectForKey:kSavedDataMainData];
            pageTableView.dataArr = com.accountList;
            pageTableView.hasMore = [[data objectForKey:kSavedDataHasMore] boolValue];
            pageTableView.lastUpdateDate =  [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:kSavedDataLastUpdateTime]doubleValue]];
            self.currentAccountCom = com;
        }
        [pageTableView.tableView reloadData];
        
        if ([[data objectForKey:kSavedDataCurrentRow]intValue] < [pageTableView.dataArr count]) {
            [pageTableView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[data objectForKey:kSavedDataCurrentRow]intValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        //expireTime
        if (self.userType == USER_POPULAR) {
            if (![GlobalUtils checkExpiredTime:kTempSuggestUserTimePopular]) {
                return YES;
            }
        } else if (self.userType == USER_FEATURED) {
            if (![GlobalUtils checkExpiredTime:kTempSuggestUserTimeFeature]) {
                return YES;
            }
        }
    }
    return NO;
}



-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    [super networkFinished:serverproxy];
    if (serverproxy == self.issueSp)
    {
        self.loading2 = NO;
    }
    if(serverproxy == self.accountSp)
    {
        self.loadingFeature = NO;
    }
}
-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    
    if (serverproxy == self.followSp) {
        [self notifyFollowingChanged];
        return;
    }
    
//    BasePageParameter *result = (BasePageParameter *)serverproxy.response;
//    NSInteger pageIndex = [result.currentPage intValue];
//    if (pageIndex == 1) {
//        [self.tableView.dataArr removeAllObjects];
//    }
    
    NSArray *dataArr = nil;
    
    
    if (serverproxy == self.issueSp && self.userType == USER_POPULAR) {
        IssueInfoCom *response = (IssueInfoCom *)serverproxy.response;
        if ([response.searchEndID longLongValue] == -1) {
            [self.tableView.dataArr removeAllObjects];
        }        
        dataArr = ((IssueInfoCom *)serverproxy.response).myAccountList;
        self.currentIssueInfoCom = response; 
    }
    else if(serverproxy == self.accountSp && self.userType == USER_FEATURED)
    {
        AccountCom *response = (AccountCom *)serverproxy.response;
        if ([response.searchEndID longLongValue] == -1) {
            [self.tableView.dataArr removeAllObjects];
        }
        dataArr = ((AccountCom *)serverproxy.response).accountList;
        self.currentAccountCom = response;
    }
    
    [self.tableView.dataArr addObjectsFromArray:dataArr];
    [(ClPageTableView *)self.tableView checkMore:dataArr];
    [self.tableView.tableView reloadData];
    //save data
    [self saveDataToFile];
}

-(CGFloat)tableView:(UITableView *)tableView heightForSuggestUserCell:(NSInteger)index
{
    return [SuggestUserViewCell tableView:tableView heightForAccount:(MyAccount *)[self.tableView.dataArr objectAtIndex:index]];
}

-(CGFloat)tableView:(ClTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView.tableView heightForSuggestUserCell:[indexPath row]];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForSuggestUserRowAtIndexPath:(NSInteger)index
{
    static NSString *CellIdentifier = @"SuggestUserViewCell";
    
    SuggestUserViewCell *cell = [self.tableView.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SuggestUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [[cell viewWithTag:150] removeFromSuperview];
    [[cell viewWithTag:151] removeFromSuperview];
    
    MyAccount *account = [self.tableView.dataArr objectAtIndex:index];
    cell.account = account;
    
    return cell;
}

-(UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView.tableView cellForSuggestUserRowAtIndexPath:[indexPath row]];
}

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    [super pageTableViewRequestLoadingMore:tableView];
    [self doRequest:YES];
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    [self doRequest:NO];
}

-(void)suggestUserViewCell:(SuggestUserViewCell *)cell didActionOnAccount:(MyAccount *)account
{
    if (!self.followSp) {
        self.followSp = [[[FollowComServerProxy alloc] init] autorelease];
        self.followSp.delegate = self;
    }
    FollowCom *com = [[[FollowCom alloc] init] autorelease];
    com.requestedUserUID = account.useruid;
    
    if ([account.followed boolValue]) {
        [self.followSp unfollow:com];
    }
    else
    {
        [self.followSp follow:com];
    }
}

-(void)suggestUserViewCell:(SuggestUserViewCell *)cell didSelectedAtIssueInfo:(Issueinfo *)info
{
    FeedViewerViewController *vc = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.issueInfo = [[[MyIssueInfo alloc] init] autorelease];//info;
    vc.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:info.dataDict];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

-(void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAccount *account = [self.tableView.dataArr objectAtIndex:[indexPath row]];
    ProfileViewController *vc = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.account = account;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [self.issueSp cancelAll];
    [self.accountSp cancelAll];
}

@end
