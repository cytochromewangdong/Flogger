//
//  PublicFeedViewController.m
//  Flogger
//
//  Created by jwchen on 12-1-20.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "PublicFeedViewController.h"
#import "LoginViewController.h"
#import "IssueInfoComServerProxy.h"
#import "IssueInfoCom.h"
#import "FeedViewerViewController.h"
#import "RegisterViewControl.h"
#import "ThirdPartyLoginViewController.h"

@implementation PublicFeedViewController
@synthesize gridPageView;

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

-(void)doRequest
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[IssueInfoComServerProxy alloc] init]autorelease];
        self.serverProxy.delegate = self;
    }
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    issueInfoCom.currentPage = [NSNumber numberWithInt:self.gridPageView.leftPageView.currentPage];
    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:self.gridPageView.leftPageView.pageSize];
    issueInfoCom.count = [NSNumber numberWithInt:0];
    [(IssueInfoComServerProxy *)self.serverProxy getPopularMedia:issueInfoCom];
}

#pragma mark - View lifecycle
-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
//    view.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    self.view = view;
    
//    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Connect", @"Connect") image:nil];
    self.gridPageView = [[[FeedGridPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.gridPageView.delegate = self;
    self.gridPageView.leftPageView.refreshableTableDelegate = self;
    [self.view addSubview:self.gridPageView];
    
//    UIToolbar *toolBar = [[FloggerUIFactory uiFactory] createToolBar];
//    toolBar.frame = CGRectMake(0, 416, 320, 44);
//    
//    UIBarButtonItem *loginButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Login", @"Login") style:nil target:self action:@selector(go2Login)]autorelease];
//    UIBarButtonItem *registerButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Join", @"Join") style:nil target:self action:@selector(go2Register)] autorelease];
//    toolBar.items = [NSArray arrayWithObjects:loginButton,registerButton, nil];
//    [self.view addSubview:toolBar];
}


-(BOOL) checkIsShowHelpView
{
    self.helpImageURL = SNS_INSTRUCTIONS_GUEST;
    if ([GlobalUtils checkIsFirstShowHelpView:self.helpImageURL]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isFirst = YES;
    [self doRequest];

}

//-(void)go2Login
//{
////    LoginViewController *lvc = [[[LoginViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//    ThirdPartyLoginViewController *thirdControl = [[[ThirdPartyLoginViewController alloc] init] autorelease];
//    if (self.navigationController) {
//        [self.navigationController pushViewController:thirdControl animated:YES];
//    }    
//}

-(void) go2Register
{
    RegisterViewControl *registerViewControl = [[[RegisterViewControl alloc] init] autorelease];
    [self.navigationController pushViewController:registerViewControl animated:YES];
}

//-(void)rightAction:(id)sender
//{
////    [self go2Login];
////    []
//}

-(void)leftAction:(id)sender
{
//    RegisterViewControl *lvc = [[[RegisterViewControl alloc] initWithNibName:nil bundle:nil] autorelease];
//    [self.navigationController pushViewController:lvc animated:YES];
//    self.gridPageView
    self.gridPageView.pagecontrol.currentPage = 1;
    [self.gridPageView changePage:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    RELEASE_SAFELY(gridPageView);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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


-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    
    [self.gridPageView.leftPageView.dataArr removeAllObjects];
//    [self.gridPageView.rightPageView.dataArr removeAllObjects];
    
//    NSMutableArray *photoArray = [[[NSMutableArray alloc] init] autorelease];
//    NSMutableArray *videoArray = [[[NSMutableArray alloc] init] autorelease];
//    [self splitDataByIssueCategory:[(IssueInfoCom *)serverproxy.response myIssueInfoList] photoData:photoArray videoData:videoArray];
    IssueInfoCom *response = (IssueInfoCom *)serverproxy.response;
    NSMutableArray *mediaArray = [[[NSMutableArray alloc] init] autorelease];
    for (Issueinfo *issueinfo in response.myIssueInfoList) {
        [mediaArray addObject:issueinfo];
    }
    [FeedGridPageTableView reorderForFreeLayout:mediaArray];
    [self.gridPageView.leftPageView.dataArr addObjectsFromArray:mediaArray];
    [self.gridPageView.leftPageView.tableView reloadData];
    
//    [self.gridPageView.rightPageView.dataArr addObjectsFromArray:videoArray];
//    [self.gridPageView.rightPageView.tableView reloadData];
}

-(void)addMenuIcon{
    CGRect frame = CGRectMake(150,5,35,30);
    frame.origin.x = (self.navigationController.navigationBar.frame.size.width - 35)/2;
    frame.origin.y = (self.navigationController.navigationBar.frame.size.height - 30)/2;
    UIButton *menubtn = [[[UIButton alloc]initWithFrame:frame] autorelease]; 
    menubtn.tag = 3000;
//    [menubtn addTarget:self action:@selector(menupress:) forControlEvents:UIControlEventTouchUpInside];
    [menubtn setBackgroundImage:[UIImage imageNamed: SNS_MENU] forState:UIControlStateNormal];
    //    [menubtn setBackgroundImage:[UIImage imageNamed: SNS_MENU] forState:UIControlStateHighlighted];
    
    [self.navigationController.navigationBar addSubview:menubtn]; 
    //    self.navigationController.navigationItem.titleView = menubtn;
    
    //[[GlobalData sharedInstance] setUpMenuView:self.navigationController.view.bounds];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self setNavigationTitleView:NSLocalizedString(@"What's Hot", @"What's Hot")];
    [self addMenuIcon];
    if (self.gridPageView.leftPageView.dataArr.count == 0 && !_isFirst) {
        [self doRequest];
    }
    _isFirst = NO;
}

-(void)selectFeedGridPageView:(FeedGridPageView *)feedGridPageView atPage:(NSInteger)page index:(NSInteger)index
{
    NSArray *arr = nil;
    if (page == 0) {
        arr = feedGridPageView.leftPageView.dataArr;
    }
    else
    {
//        arr = feedGridPageView.rightPageView.dataArr;
    }
    
    FeedViewerViewController *viewerController = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewerController.issueInfo = [arr objectAtIndex:index];
    [self.navigationController pushViewController:viewerController animated:YES];
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    [self doRequest];
}

-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    [super networkFinished:serverproxy];
    self.gridPageView.leftPageView.lastUpdateDate = [NSDate date];
//    self.gridPageView.rightPageView.lastUpdateDate = [NSDate date];
}
@end
