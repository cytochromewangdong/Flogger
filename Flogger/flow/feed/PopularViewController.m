//
//  PopularViewController.m
//  Flogger
//
//  Created by wyf on 12-4-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "PopularViewController.h"
#import "IssueInfoComServerProxy.h"
#import "IssueInfoCom.h"
#import "FeedViewerViewController.h"
#import "SearchViewController.h"
#import "SuggestionUserViewController.h"
#import "SBJson.h"
#import "DataCache.h"
#import "FloggerNavButtonsHelper.h"

#define kPopular 30001
#define kFeature 30002
#define kShout 30003

#define kPopularPhoto 31001
#define kPopularVideo 31002
//#define kPopular

#define kFeaturePhoto 32001
#define kFeatureVideo 32002

#define kPopularBtn 30004
#define kFeatureBtn 30005
#define kShoutBtn 30006

@interface PopularViewController ()

@end

@implementation PopularViewController

@synthesize contentView,issueinfoCategory,popularBtn,featurebtn;
@synthesize isLoadingPopular = _isLoadingPopular, isLoadingFeaturePhoto = _isLoadingFeaturePhoto, isLoadingFeatureVideo = _isLoadingFeatureVideo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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

#pragma mark - View lifecycle
-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    //view.backgroundColor=[UIColor clearColor];
    view.frame = CGRectMake(0, 0, 320, 416);
    self.view = view;
    
    
    popularBtn = [[[FloggerUIFactory uiFactory] createHeadButton] retain] ; 
featurebtn = [[[FloggerUIFactory uiFactory] createHeadButton] retain];
     [popularBtn setTitle:NSLocalizedString(@"Photos", @"Photos") forState:UIControlStateNormal];
    //UIButton *featurebtn = [[FloggerUIFactory uiFactory] createHeadButton];
     [featurebtn setTitle:NSLocalizedString(@"Videos", @"Photos") forState:UIControlStateNormal];
    popularBtn.tag=kPopularBtn;
    featurebtn.tag=kFeatureBtn;
    [popularBtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [featurebtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *contentV = [[FloggerUIFactory uiFactory] createView];
    int contentHeight = 0;
    contentV.frame = CGRectMake(0, contentHeight, 320, 367-contentHeight);
    contentV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentV];
//    [self.view addSubview:popularBtn];
//    [self.view addSubview:featurebtn];
//    [self.view addSubview:shoutBtn];

    [self setContentView:contentV];
    
    //initial
    popularBtn.selected = YES;
    
    [self setRightNavigationBarWithTitleAndImage:nil image:SNS_SEARCH_BUTTON pressimage:nil];
    [self setLeftNavigationBarWithTitle:@"" image:SNS_SUGGESTED_CONTACT_BUTTON];
    
}

-(void) viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    //[self setNavigationTitleView:NSLocalizedString(@"What's Hot", @"What's Hot")];

    [FloggerNavButtonsHelper addNavTwoButton:self.navigationController.navigationBar leftBtton:popularBtn  rightButton:featurebtn ];

    //willappear
//    UIButton *popularBtn =  (UIButton *)([self.view viewWithTag:kPopularBtn]);
//    UIButton *featureBtn = (UIButton *)([self.view viewWithTag:kPopularBtn]);
    if ([popularBtn isSelected]) {
        if ([_popularView.leftPageView.dataArr count] == 0) {
//            [self doRequestPopularPhoto];
            [self doRequestPopular];
            [self showActivity];
        }
    } else {
        if ([_featureView.leftPageView.dataArr count] == 0) {
            [self doRequestPopular];
            [self showActivity];
        }
    }
    
}

//-(void) viewWillappear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


-(void)go2ViewerWithIssueinfo:(Issueinfo *)issueinfo
{
    FeedViewerViewController *viewerController = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewerController.issueInfo = [[[MyIssueInfo alloc]init]autorelease];//issueinfo;
    viewerController.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:issueinfo.dataDict];
    
   // UIButton *popularBtn =  (UIButton *)([self.view viewWithTag:kPopularBtn]);
    if ([popularBtn isSelected])
    {
        viewerController.issueListArray = _popularView.leftPageView.dataArr;
    } else {
        viewerController.issueListArray = _featureView.leftPageView.dataArr;
    }
    
    

//    viewerController.issueListArray = 
    [self.navigationController pushViewController:viewerController animated:YES];
}

-(void) showActivity
{
    if (_popularView.leftPageView.dataArr.count > 0 || _featureView.leftPageView.dataArr.count > 0) {
        return;
    }
    if (!self.firstActivityIndicatorView) {
        UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        activityView.center = self.contentView.center;//CGRectMake(20, self.firstActivityOriginalY + 20, 20, 20);
        [self.view addSubview:activityView];
        self.firstActivityIndicatorView = activityView;
    }
    [self.firstActivityIndicatorView startAnimating];
}

-(void) closeActivity
{
    if (self.firstActivityIndicatorView) {
        [self.firstActivityIndicatorView stopAnimating];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self showView:kPopular];
    self.issueinfoCategory = -1;
    
    self.loadingThread = NO;
    
    if (![self restoreData]) {
        [self doRequestPopular];
        [self showActivity];
    }    
//    [self doRequestPopularPhoto];
//    [self dore]
//    [self doRequestFeatureByMediaType:NO];
    
    
    
    
}

-(void)selectFeedGridPageView:(FeedGridPageView *)feedGridPageView atPage:(NSInteger)page index:(NSInteger)index
{
    
    NSInteger pageIndex = 0;
    if (feedGridPageView.tag == kPopular) {
        pageIndex = page - kPopularPhoto;
    }
    else {
        pageIndex = page - kFeaturePhoto;
    }
    
    Issueinfo *issueinfo = [self getIssueInfoByType:feedGridPageView.tag withPageIndex:pageIndex index:index];
    [self go2ViewerWithIssueinfo:issueinfo];
}

-(Issueinfo *)getIssueInfoByType:(NSInteger)tag withPageIndex:(NSInteger)pageIndex index:(NSInteger)index
{
    NSArray *dataArr = nil;
    FeedGridPageView *tmpView = nil;
    if (tag == kPopular) {
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


-(void)btnTapped:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        return;
    }
    [self cancelNetworkRequests];
//    ((UIButton *)([self.view viewWithTag:kTagFollowBtn])).selected = NO;
    popularBtn.selected=NO;// ((UIButton *)([self.view viewWithTag:kFeatureBtn])).selected = NO;
    featurebtn.selected=NO;// ((UIButton *)([self.view viewWithTag:kPopularBtn])).selected = NO;
    ((UIButton *)([self.view viewWithTag:kShoutBtn])).selected = NO;
    
    NSInteger tag = [btn tag];
    btn.selected = YES;
    NSInteger showTag = 0;
    switch (tag) {
        case kPopularBtn:
            showTag = kPopular;
//            if ([_popularView.leftPageView.dataArr count] == 0) {
//                [self doRequestPopularPhoto];
//            }
            break;
        case kFeatureBtn:
//            if ([_featureView.leftPageView.dataArr count] == 0) {
//                [self doRequestPopularVideo];
//            }
            showTag = kFeature;
            break;
        case kShoutBtn:
            showTag = kShout;
        default:
            break;
    }
    [self showView:showTag];
}


-(void)showView:(NSInteger)viewTag
{
    
    UIView *view = [self.contentView viewWithTag:viewTag];
    view.backgroundColor =[UIColor clearColor];//[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    NSInteger offset = -view.frame.origin.x;
//    [UIView beginAnimations:nil context:nil];
    CGRect frame;
    
    frame = CGRectMake(_popularView.frame.origin.x + offset, _popularView.frame.origin.y, _popularView.frame.size.width, _popularView.frame.size.height);
    _popularView.frame = frame;
    
    frame = CGRectMake(_featureView.frame.origin.x + offset, _featureView.frame.origin.y, _featureView.frame.size.width, _featureView.frame.size.height);
    _featureView.frame = frame;
    
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:500];
//    [UIView commitAnimations];
}



-(void)setupViews
{
    NSInteger x = 0;
    
    x += contentView.frame.size.width;
    _popularView = [[FeedGridPageView alloc] initWithFrame:CGRectMake(x, 0, contentView.frame.size.width, contentView.frame.size.height)];
    
    _popularView.backgroundColor =[UIColor clearColor];//[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    _popularView.leftPageView.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];    
    _popularView.tag = kPopular;
    _popularView.leftPageView.tag = kPopularPhoto;
//    _popularView.rightPageView.tag = kPopularVideo;
    _popularView.delegate = self;
    _popularView.leftPageView.refreshableTableDelegate = self;
//    _popularView.rightPageView.refreshableTableDelegate = self;
    [contentView addSubview:_popularView];
    
    x += contentView.frame.size.width;
    _featureView = [[FeedGridPageView alloc] initWithFrame:CGRectMake(x, 0, contentView.frame.size.width, contentView.frame.size.height)];
    _featureView.backgroundColor =[UIColor clearColor];//[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    _featureView.leftPageView.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]]; 
    _featureView.delegate = self;
    _featureView.leftPageView.refreshableTableDelegate = self;
//    _featureView.leftPageView.pageDelegate = self;
//    _featureView.rightPageView.refreshableTableDelegate = self;
//    _featureView.rightPageView.pageDelegate = self;
    _featureView.tag = kFeature;
    _featureView.leftPageView.tag = kFeaturePhoto;
//    _featureView.rightPageView.tag = kFeatureVideo;
    [self.contentView addSubview:_featureView];
    
    x += contentView.frame.size.width;
    _shoutView = [[FeedTableView alloc] initWithFrame:CGRectMake(x, 0, contentView.frame.size.width, contentView.frame.size.height)];
    _shoutView.backgroundColor = [UIColor clearColor];
//    _shoutView.delegate = self;
    _shoutView.refreshableTableDelegate = self;
    _shoutView.tag = kShout;
    [self.contentView addSubview:_shoutView];
}

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    
    if(tableView == _popularView.leftPageView)
    {
        [self doRequestPopular];
    }
    else if(tableView == _featureView.leftPageView) {
        [self doRequestFeatureByMediaType:YES];
//        [self doRequestFeatureByMediaType:ISSUE_CATEGORY_PICTURE isMore:YES];
    }    
}

-(void)doRequestFeatureByMediaType:(BOOL)isMore
{
//    if ((self.isLoadingFeaturePhoto && mediaType == ISSUE_CATEGORY_PICTURE) || (self.isLoadingFeatureVideo && mediaType == ISSUE_CATEGORY_VIDEO)) {
//        return;
//    }
//    if (self.isload) {
//        <#statements#>
//    }
    
//    if (self.loading && self.loadingThread) {
//        return;
//    }
////    self.isLoadingFeaturePhoto = YES;
//    self.loading = YES;
//    self.loadingThread = YES;
    
    IssueInfoComServerProxy *sp = nil;
    
    //    NSInteger currentPage = 0;
    NSInteger pageSize = 0;
    
    NSNumber *startId = [NSNumber numberWithInt:-1];
    NSNumber *endId = [NSNumber numberWithInt:-1];
    
//    if(mediaType == ISSUE_CATEGORY_PICTURE)
//    {
//        self.isLoadingFeaturePhoto = YES;
//        
//        if(!_featurePhotoSp)
//        {
//            _featurePhotoSp = [[IssueInfoComServerProxy alloc] init];
//            _featurePhotoSp.delegate = self;
//        }
//        sp = _featurePhotoSp;
//        
//        if (isMore) {
//            endId = _featureView.leftPageView.endId;
//        }
//        else
//        {
//            startId = _featureView.leftPageView.startId;
//        }
//        
//        pageSize = _featureView.leftPageView.pageSize;
//    }
//    else
//    {
//        self.isLoadingFeatureVideo = YES;
//        
//        if(!_featureVideoSp)
//        {
//            _featureVideoSp = [[IssueInfoComServerProxy alloc] init];
//            _featureVideoSp.delegate = self;
//        }
//        sp = _featureVideoSp;
//        
//        //        currentPage = _featureView.rightPageView.currentPage;
//        pageSize = _featureView.rightPageView.pageSize;
//        
//        if (isMore) {
//            endId = _featureView.rightPageView.endId;
//        }
//        else
//        {
//            startId = _featureView.rightPageView.startId;
//        }
//        
//    }
    
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
        startId = [NSNumber numberWithInt:-1];//_featureView.leftPageView.startId;
    }
    pageSize = _featureView.leftPageView.pageSize;
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    issueInfoCom.searchStartID = startId;
    issueInfoCom.searchEndID = endId;
    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:pageSize];
    issueInfoCom.type = [NSNumber numberWithInt:ISSUE_INFO_FEATURED];
    
//    if (mediaType != -1) {
        issueInfoCom.mediaType = [NSNumber numberWithInt:3];
//    }
    
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
//    issueInfoCom.count = [NSNumber numberWithInt:0];
    [_popularSp getPopularMedia:issueInfoCom];
}

-(void) viewScrollToTop
{
   // UIButton *popularBtn =  (UIButton *)([self.view viewWithTag:kPopularBtn]);
    if (![popularBtn isSelected]) {
        if (_featureView && [_featureView.leftPageView.dataArr count] > 0) {
            [_featureView.leftPageView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    } else {
        if (_popularView && [_popularView.leftPageView.dataArr count] > 0) {
            [_popularView.leftPageView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}
//-(void)doRequestPopularPhoto
//{
//    if (self.isLoadingPopular) {
//        return;
//    }
//    
//    self.isLoadingPopular = YES;
//    
//    if (!_popularSp) {
//        _popularSp = [[IssueInfoComServerProxy alloc] init];
//        _popularSp.delegate = self;
//    }
//    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
//    issueInfoCom.currentPage = [NSNumber numberWithInt:_popularView.leftPageView.currentPage];
//    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:_popularView.leftPageView.pageSize];
////    issueInfoCom.
////    issueInfoCom.count = [NSNumber numberWithInt:1];
//    [_popularSp getPopularMedia:issueInfoCom];
//}
//
//-(void)doRequestPopularVideo
//{
//    if (self.isLoadingFeatureVideo) {
//        return;
//    }
//    
//    self.isLoadingFeatureVideo = YES;
//    
//    if (!_featureVideoSp) {
//        _featureVideoSp = [[IssueInfoComServerProxy alloc] init];
//        _featureVideoSp.delegate = self;
//    }
//    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
//    issueInfoCom.currentPage = [NSNumber numberWithInt:_popularView.leftPageView.currentPage];
//    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:_popularView.leftPageView.pageSize];
//    issueInfoCom.count = [NSNumber numberWithInt:2];
//    [_featureVideoSp getPopularMedia:issueInfoCom];
//}

-(void)setIsLoadingFeaturePhoto:(BOOL)isLoadingFeaturePhoto
{
    _isLoadingFeaturePhoto = isLoadingFeaturePhoto;
    _featureView.leftPageView.isLoading = isLoadingFeaturePhoto;
    _featureView.leftPageView.isLoadingMore = isLoadingFeaturePhoto;
}

-(void)setIsLoadingFeatureVideo:(BOOL)isLoadingFeatureVideo
{
    _isLoadingFeatureVideo = isLoadingFeatureVideo;
    _featureView.leftPageView.isLoading = isLoadingFeatureVideo;
}

-(void)setIsLoadingPopular:(BOOL)isLoadingPopular
{
   // UIButton *popularPhoto = (UIButton *) [self.view viewWithTag:kPopularBtn];
    _isLoadingPopular = isLoadingPopular;
    if ([popularBtn isSelected]) {
        _popularView.leftPageView.isLoading = isLoadingPopular;
    } else {
        _featureView.leftPageView.isLoading = isLoadingPopular;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    RELEASE_SAFELY(gridPageView);
    [self myReleaseSource];
}

-(void) dealloc
{
    [self myReleaseSource];
    [super dealloc];
}

-(void) myReleaseSource
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"feed" object:nil];
    RELEASE_SAFELY(popularBtn); 
    RELEASE_SAFELY(featurebtn); 
    RELEASE_SAFELY(contentView);
    RELEASE_SAFELY(_popularView);
    RELEASE_SAFELY(_featureView);
    RELEASE_SAFELY(_shoutView);
    
    _popularSp.delegate = nil;
    RELEASE_SAFELY(_popularSp);
    _featurePhotoSp.delegate = nil;
    RELEASE_SAFELY(_featurePhotoSp);
    _featureVideoSp.delegate = nil;
    RELEASE_SAFELY(_featureVideoSp); 
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)splitDataByIssueCategory:(NSArray *)data photoData:(NSMutableArray *)photoArray videoData:(NSMutableArray *)videoArray shoutData: (NSMutableArray *) shoutArray
{
    for (Issueinfo *issueinfo in data) {
        if ([issueinfo.issuecategory intValue] == ISSUE_CATEGORY_PICTURE) {
            [photoArray addObject:issueinfo];
        }
        else if ([issueinfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO)
        {
            [videoArray addObject:issueinfo];
        } else if ([issueinfo.issuecategory intValue] == ISSUE_CATEGORY_TWEET){
            [shoutArray addObject:issueinfo];
        }
    }
}
-(void)updateView:(ClPageTableView *)tableView withResponse:(IssueInfoCom *)response
{
    if (response.myIssueInfoList && response.myIssueInfoList.count > 0)
    {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
        [tableView.dataArr addObjectsFromArray:response.myIssueInfoList];
    }
    
    if ([response.searchStartID longLongValue] == -1) {
        [tableView checkMore:response.myIssueInfoList];
    }
    
    [tableView.tableView reloadData];
}

//- (void)networkFinished:(BaseServerProxy *)serverproxy
//{
//    
//}

-(void) saveDataToFile
{
    NSMutableDictionary *data = [[[NSMutableDictionary alloc]init]autorelease];
    IssueInfoCom *com = [[[IssueInfoCom alloc]init]autorelease];
    NSMutableArray *issueInfoList = [[[NSMutableArray alloc] init] autorelease];
    [issueInfoList addObjectsFromArray:_popularView.leftPageView.dataArr];
    [issueInfoList addObjectsFromArray:_featureView.leftPageView.dataArr];
    com.myIssueInfoList = issueInfoList;
    
    [data setObject:com.dataDict forKey:kSavedDataMainData];
    //lastupdateTime
    double currentSec = [_popularView.leftPageView.lastUpdateDate timeIntervalSince1970];
    [data setObject:[NSNumber numberWithDouble:currentSec] forKey:kSavedDataLastUpdateTime];
    NSIndexPath* indexPath = [_popularView.leftPageView.tableView indexPathForRowAtPoint:[_popularView.leftPageView.tableView contentOffset]];
    [data setObject:[NSNumber numberWithDouble:indexPath.row] forKey:kSavedDataCurrentRow];
    NSString *sData = [data JSONRepresentation];
    NSData* pureData = [sData dataUsingEncoding:NSUTF8StringEncoding];
    [[DataCache sharedInstance]storeData:pureData forKey:kDataCachePopular Category:kDataCacheTempDataCategory];
}
-(BOOL) restoreData
{
    NSData* pureData = [[DataCache sharedInstance]dataFromKey:kDataCachePopular Category:kDataCacheTempDataCategory];
    if(pureData)
    {
        NSString *sData = [[[NSString alloc]initWithData:pureData encoding:NSUTF8StringEncoding] autorelease];
        IssueInfoCom *com = [[[IssueInfoCom alloc]init]autorelease];
        NSMutableDictionary *data = [sData JSONValue];
        com.dataDict = [data objectForKey:kSavedDataMainData];
        
        _popularView.leftPageView.lastUpdateDate =  [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:kSavedDataLastUpdateTime]doubleValue]];
        
        _featureView.leftPageView.lastUpdateDate =  [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:kSavedDataLastUpdateTime]doubleValue]];
        
        NSMutableArray *photoArray = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *videoArray = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *shoutArray = [[[NSMutableArray alloc] init] autorelease];
        [self splitDataByIssueCategory:com.myIssueInfoList photoData:photoArray videoData:videoArray shoutData:shoutArray];
        _popularView.leftPageView.dataArr = photoArray;
        _featureView.leftPageView.dataArr = videoArray;
        
        [_popularView.leftPageView.tableView reloadData];
        [_featureView.leftPageView.tableView reloadData];
        
        if ([[data objectForKey:kSavedDataCurrentRow]intValue] < [_popularView.leftPageView.dataArr count]) {
            [_popularView.leftPageView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[data objectForKey:kSavedDataCurrentRow]intValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
        if (![GlobalUtils checkExpiredTime:kTempPopular]) {
            return YES;
        }
        
    }
    return NO;
}


-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    [self closeActivity];
    
    if (![serverproxy isKindOfClass:[IssueInfoComServerProxy class]]) {
        return;
    }
    IssueInfoCom *response = (IssueInfoCom *)serverproxy.response;
//    UIButton *popularBtn =  (UIButton *)([self.view viewWithTag:kPopularBtn]);
    
    NSMutableArray *photoArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *videoArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *shoutArray = [[[NSMutableArray alloc] init] autorelease];
    [self splitDataByIssueCategory:response.myIssueInfoList photoData:photoArray videoData:videoArray shoutData:shoutArray];
    [FeedGridPageTableView reorderForFreeLayout:photoArray];
    [FeedGridPageTableView reorderForFreeLayout:videoArray];
//    if ([popularBtn isSelected]) 
    {
        [_popularView.leftPageView.dataArr removeAllObjects];
        if ([photoArray count] > 0) {
            [_popularView.leftPageView.dataArr addObjectsFromArray:photoArray];
        }
        [_popularView.leftPageView.tableView reloadData];
    } 
//     /else 
    {
        [_featureView.leftPageView.dataArr removeAllObjects];
        if ([videoArray count] > 0) {
            [_featureView.leftPageView.dataArr addObjectsFromArray:videoArray];
        }
        [_featureView.leftPageView.tableView reloadData];
    }
    //shoutView
    [_shoutView.dataArr removeAllObjects];
    if (shoutArray.count > 0) {
        [_shoutView.dataArr addObjectsFromArray:shoutArray];
    }
    [_shoutView.tableView reloadData];
    
    /*IssueInfoCom *response = (IssueInfoCom *)serverproxy.response;
    if([response.type intValue] == ISSUE_INFO_FEATURED) {        
        [self updateView:_featureView.leftPageView withResponse:response];
    }
    else
    {
        [_popularView.leftPageView.dataArr removeAllObjects];
        NSMutableArray *mediaArray = [[[NSMutableArray alloc] init] autorelease];
        for (Issueinfo *issueinfo in response.myIssueInfoList) {
            [mediaArray addObject:issueinfo];
        }
        [_popularView.leftPageView.dataArr addObjectsFromArray:mediaArray];
        [_popularView.leftPageView.tableView reloadData];
    }*/
    
    //save temp time
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:currentTime] forKey:kTempPopular];
    [self saveDataToFile];
}


-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
//    NSInteger tag = refreshTableView.tag;
    [self doRequestPopular];
////    kFeaturePhoto
//    switch (tag) {
////        case kPopularVideo:
//        case kPopularPhoto:
//            [self doRequestPopularPhoto];
//            break;
//        default:
////            [self doRequestFeatureByMediaType:NO];
//            [self doRequestPopularVideo];
//            break;
//    }
}
-(void)cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [_popularSp cancelAll];
    [_featurePhotoSp cancelAll];
    [_featureVideoSp cancelAll];
    self.isLoadingFeaturePhoto = NO;
    self.isLoadingFeatureVideo = NO;
    self.isLoadingPopular = NO;
    
    [self closeActivity];

//    IssueInfoComServerProxy *_popularSp;
//    IssueInfoComServerProxy *_featurePhotoSp;
//    IssueInfoComServerProxy *_featureVideoSp;
    
}

-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    [super networkFinished:serverproxy];
//    self.loadingThread = YES;
    
    NSDate *date = [NSDate date];
    if(serverproxy == _featurePhotoSp)
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
//        _popularView.rightPageView.lastUpdateDate = date;
        _featureView.leftPageView.lastUpdateDate =date;
    }
    [self closeActivity];
}

@end
