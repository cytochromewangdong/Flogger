//
//  FavortiesViewController.m
//  Flogger
//
//  Created by steveli on 08/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "FavortiesViewController.h"
//#import "FavortiesShareViewController.h"
#import "IssueInfoComServerProxy.h"
#import "IssueInfoCom.h"
#import "GlobalData.h"
#import "FeedViewerViewController.h"
#import "LikeInfoCom.h"
//#import "CheckGridCellButton.h"
#import "ShareFeedViewController.h"

#define kGetLike      1
#define kDeleteLike   2
#define EN_ALPHA 1
#define UN_ALPHA 0.7
#define FAVORTYPAGESIZE 60

@implementation FavortiesViewController

@synthesize gridview,bottombar,poupwindow,dislikeSp;



-(void)dealloc
{

    self.gridview.dataSource = nil;
    self.gridview.delegate = nil;
    self.gridview.refreshableTableDelegate = nil;
    self.gridview.pageDelegate = nil;
    self.gridview.checkGridDelegate = nil;
    self.gridview = nil;
    self.bottombar.bottombardelegate = nil;
    self.bottombar = nil;
    self.poupwindow.delegate = nil;
    self.poupwindow = nil;
    self.serverProxy.delegate = nil;
    self.serverProxy = nil;
    self.dislikeSp.delegate = nil;
    self.dislikeSp = nil;
//    self.myIssueInfoList = nil;
    [super dealloc];
}
-(BOOL) checkIsFullScreen
{
    return YES;
}

-(void)reloadAlbum
{
    [gridview clearSelect];
    [gridview.tableView reloadData];

}
#pragma mark - Http
-(void)getLikeList:(BOOL)isMore
{
    
    if (self.loading) {
        return;
    }
    if([GlobalData sharedInstance].myAccount == nil)
        return;
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[IssueInfoComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }

    IssueInfoComServerProxy *iis = (IssueInfoComServerProxy *)self.serverProxy;
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    issueInfoCom.userUID = [GlobalData sharedInstance].myAccount.userUID;
    
    if (isMore) {
//        issueInfoCom.searchEndID = gridview.endId;
        issueInfoCom.searchEndID = (self.tableView.dataArr && self.tableView.dataArr.count > 0)? ((MyIssueInfo *)[self.tableView.dataArr objectAtIndex:self.tableView.dataArr.count-1]).likeid : [NSNumber numberWithInt:-1];
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
    }
    else
    {
//        issueInfoCom.searchStartID = gridview.startId;        
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];//(self.tableView.dataArr && self.tableView.dataArr.count > 0)? ((MyIssueInfo *)[self.tableView.dataArr objectAtIndex:0]).likeid : [NSNumber numberWithInt:-1];
        issueInfoCom.searchEndID = [NSNumber numberWithInt:-1];
    }
    
    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:FAVORTYPAGESIZE];

    [iis getLikeList:issueInfoCom];
}

-(void)deletelike:(NSMutableArray*)issueidlist
{
    if (self.loading) {
        return;
    }
    
    if([GlobalData sharedInstance].myAccount == nil)
        return;
    
    self.loading = YES;
    
    if (!self.dislikeSp) {
        self.dislikeSp = [[[LikeInfoComServerProxy alloc] init] autorelease];
        self.dislikeSp.delegate = self;
    }
    
    LikeInfoComServerProxy *iis = (LikeInfoComServerProxy *)self.dislikeSp;
    LikeInfoCom *issueInfoCom = [[[LikeInfoCom alloc] init] autorelease];
    issueInfoCom.issueIdList = issueidlist;
    [iis deleteLikeIssue:issueInfoCom];
}

#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _type = kGetLike;
    }
    return self;
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}

#pragma mark - View lifecycle

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self setNavigationTitleView:NSLocalizedString(@"Favorites", @"Favorites")];
}

-(void)showbottom:(BOOL)showflag
{
    [UIView beginAnimations:nil context:nil];    
    if(showflag){
        self.bottombar.frame = CGRectMake(0, 372, self.view.frame.size.width, 44);
    }else{
        self.bottombar.frame = CGRectMake(0, 416, self.view.frame.size.width, 44);
    }
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:1000];
    [UIView commitAnimations];    
    self.bottombar.unlikebtn.enabled = FALSE;
    self.bottombar.sharebtn.enabled = FALSE;
    bottombar.unlikebtn.alpha=UN_ALPHA;
    bottombar.sharebtn.alpha=UN_ALPHA;
}

-(void)rightAction:(id)sender
{
    _orgflag = !_orgflag;
    [gridview setSelectEnable:_orgflag];
    [self setIsRightBarSelected:_orgflag];
    [self showbottom:_orgflag];
}

-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
//    view.backgroundColor= [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    self.view = view;
}

- (void)viewDidLoad
{
    self.gridview = [[[ClCheckGridView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    self.tableView = self.gridview;
    [self.view addSubview:self.tableView];
    self.gridview.refreshableTableDelegate = self;
    self.gridview.pageDelegate = self;
    self.gridview.checkGridDelegate = self;
     self.gridview.bottomOffset = 1;
    [super viewDidLoad];
    
    _orgflag = FALSE;
    [self setRightNavigationBarWithTitleAndImage:nil image:SNS_ORGANIZE_BUTTON pressimage:SNS_ORGANIZE_BUTTON_PRESSED];
//    self.navigationItem.rightBarButtonItem =  [GlobalUtils customBarButton:nil normalimg:[UIImage imageNamed: SNS_ORGANIZE_BUTTON] highlightimg:[UIImage imageNamed: SNS_ORGANIZE_BUTTON_PRESSED] addTarget:self action:@selector(orgbtnpress)];
    
    self.bottombar = [[[FavortiesBottomBar alloc]initWithFrame:CGRectMake(0, self.gridview.frame.size.height, self.view.frame.size.width, 44)]autorelease];
    [self showbottom:NO];//默认不显示
    self.bottombar.bottombardelegate = self;
    [self.view addSubview:self.bottombar];
    
    
    self.poupwindow = [[[PoupWindowViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    self.poupwindow.alpha = 0.0;
    self.poupwindow.delegate = self;
    [self.poupwindow settTitle: NSLocalizedString(@"Are you sure you want to remove from favorites?",@"Are you sure you want to remove from favorites?")];
    [self.poupwindow setleftbtn: NSLocalizedString(@"Remove",@"Remove") bgimg:[UIImage imageNamed:SNS_ALBUM_DELETE_BUTTON]];
    [self.view addSubview:self.poupwindow];


    
    [self getLikeList:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - bottombar degelate

-(NSString*)createDescription:(NSInteger)numphoto videonum:(NSInteger)videonum
{
    NSString *content;
    if(numphoto == 0 && videonum == 0){
        content = NSLocalizedString(@"You have selected nothing",@"You have selected nothing");
    }else if(numphoto == 0 && videonum > 0){
        content = [NSString stringWithFormat:NSLocalizedString(@"You have selected %d video",@"You have selected %d video"),videonum];
    }else if(numphoto > 0 && videonum == 0){
        content = [NSString stringWithFormat:NSLocalizedString(@"You have selected %d photo",@"You have selected %d photo"),numphoto];
    }else{
        content = [NSString stringWithFormat:NSLocalizedString(@"You have selected %d photo and %d video",@"You have selected %d photo and %d video"),numphoto,videonum];
    }
    return content;
}


-(void)sharecommand
{
    ShareFeedViewController *vc = [[[ShareFeedViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.descriptionStr = [self createDescription:[gridview getPhotoSelectNum] videonum:[gridview getVideoSelectNum]];
    vc.shareType = SHAREISSUE;
    vc.issueList =[gridview selectcells];
    vc.shareComeFrom=FROM_GALLERY_SHARE;
    vc.delegate = self;
//    NSLog(@"vc issueList count = %d",vc.issueList.count);
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)unlikecommand
{
//    [poupwindow show];
    NSString *titleString =  NSLocalizedString(@"Are you sure you want to remove from favorites?",@"Are you sure you want to remove from favorites?");
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:titleString message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Remove", @"Remove"),NSLocalizedString(@"Cancel", @"Cancel"), nil] autorelease];
    [alert show];
    
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (buttonIndex) {
        case 0:
        {
            _type = kDeleteLike;
            NSMutableArray *array = [[[NSMutableArray alloc]init]autorelease];
            for(Issueinfo *info in gridview.selectcells){
                [array addObject:info.id];
            }            
            [self deletelike:array];
        }
            break;
            
        default:
            break;
    }
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}
#pragma mark - popuwindow degelate
-(void)poupwindowLeftAction
{
    [poupwindow hide];
    [self.navigationItem.rightBarButtonItem setEnabled:TRUE];
    _type = kDeleteLike;
    
    
    NSMutableArray *array = [[[NSMutableArray alloc]init]autorelease];
    for(Issueinfo *info in gridview.selectcells){
        [array addObject:info.id];
    }
    
    [self deletelike:array];
    
    
}
-(void)poupwindowRightAction
{
    [poupwindow hide];
    [self.navigationItem.rightBarButtonItem setEnabled:TRUE];
}

#pragma mark - gridview degelate

-(void)checkgridSelectItem:(id)item
{
//    NSLog(@"SelectItem %d",gridview.getselectnum);
    if(gridview.getselectnum == 1){
        bottombar.unlikebtn.enabled = TRUE;
        bottombar.sharebtn.enabled = TRUE;
        bottombar.unlikebtn.alpha=EN_ALPHA;
        bottombar.sharebtn.alpha =EN_ALPHA;
    }else if(gridview.getselectnum > 1){
        bottombar.sharebtn.enabled = FALSE;
        bottombar.sharebtn.alpha =UN_ALPHA;
    }
}

-(void)checkgridSelectNull
{
    bottombar.unlikebtn.enabled = FALSE;
    bottombar.sharebtn.enabled = FALSE;
    bottombar.unlikebtn.alpha=UN_ALPHA;
    bottombar.sharebtn.alpha=UN_ALPHA;
}

-(void)checkgridUnSelectItem:(id)item
{
    if(gridview.getselectnum == 0){
        bottombar.unlikebtn.enabled = FALSE;
        bottombar.sharebtn.enabled = FALSE;
        bottombar.unlikebtn.alpha=UN_ALPHA;
        bottombar.sharebtn.alpha=UN_ALPHA;
    }else if(gridview.getselectnum == 1){
        bottombar.sharebtn.enabled = TRUE;
        bottombar.sharebtn.alpha =EN_ALPHA;
    }
}

-(void)checkgridSelectIssueInfo:(id)info
{
    FeedViewerViewController *viewerController = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewerController.issueInfo = info;
    [self.navigationController pushViewController:viewerController animated:YES];
}



#pragma net work

-(void)transactionFinished:(BaseServerProxy *)sp
{
    
    [super transactionFinished:sp];
    
//    NSLog(@"favorties transactionFinished");
    
    if(self.dislikeSp == sp){
        [gridview removeSelect];
        [gridview.tableView reloadData];
    }else{
        IssueInfoCom* issue = (IssueInfoCom *)sp.response;
//        if(issue)
//            NSLog(@"issue != nil");
        NSMutableArray *myIssueInfoList = [issue myIssueInfoList];
        if(myIssueInfoList) {
//            NSLog(@"myIssueInfoList != nil count = %d",myIssueInfoList.count);
//            [self updateView:(ClPageTableView *)self.tableView withResponse:issue data:myIssueInfoList];
            [self updateView:self.gridview withResponse:issue data:myIssueInfoList];
        }
    }
}

-(void)updateView:(ClCheckGridView *)tableView withResponse:(BasePageParameter *)response data:(NSArray *)dataArr
{
//    if (!dataArr)
//    {
//        dataArr = [[[NSArray alloc]init]autorelease];
//    }
//    {
//        if ([response.searchStartID intValue] == -1) {
//            [tableView.dataArr removeAllObjects];
//        }
//        
//        [tableView.dataArr addObjectsFromArray:dataArr];
//    }
//    
//    if ([response.searchStartID intValue] == -1) 
//    {
//        [tableView checkMore:dataArr];
//    }
    if (dataArr && dataArr.count > 0)
    {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
        [tableView.dataArr addObjectsFromArray:dataArr];
    } else {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
    }
    
    if ([response.searchStartID longLongValue] == -1) {
        [tableView checkMore:dataArr];
    }
    
    [tableView.tableView reloadData];
    
//    [tableView.tableView reloadData];
}

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    [super pageTableViewRequestLoadingMore:tableView];
    [self getLikeList:YES];
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    [self getLikeList:NO];
}

-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [self.dislikeSp cancelAll];
//    @property(nonatomic, retain) LikeInfoComServerProxy *dislikeSp;
}

@end
