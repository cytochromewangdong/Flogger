//
//  ClTableView.m
//  Flogger
//
//  Created by jwchen on 12-2-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FeedTableView.h"
#import "FeedViewCell.h"
#import "LikeInfoCom.h"
#import "MyIssueInfo.h"
#import "SBJson.h"
#import "Taglist.h"
#import "TagFeedViewController.h"
#import "FeedViewerViewController.h"
#import "ShareFeedViewController.h"
#import "ProfileViewController.h"
#import "PhotoDisplayViewController.h"
#import "MyAccount.h"
#import "DataCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FloggerCameraControl.h"
#import "CameraNaviViewController.h"
#import "MapViewController.h"
#import "MBProgressHUD.h"
#import "MyMovieViewController.h"
#import "UIViewController+iconImage.h"
#import "CommentPostViewController.h"
#import "GlobalData.h"
#import "FriendListViewController.h"
#import "CommentViewController.h"
#import "MyMoviePlayerManager.h"

#define kTagShowImage 20000
#define pageSize 100
#define VIDEOTAG 5678

static NSString *CellIdentifier = @"FeedViewCell";
static MyMovieHandler *movieHandler;
static int isplaying;
@implementation MyMovieHandler
+(MyMovieHandler *)sharedInstance
{
    if (!movieHandler) {
        movieHandler = [[MyMovieHandler alloc] init];
    }
    return movieHandler;
}
+(void)purgeSharedInstance
{
    [movieHandler release];
    movieHandler = nil;
}
-(void) myMoviewFinish:(UIViewController *) viewControl 
{
    isplaying =0;
    [viewControl.view removeFromSuperview];
//    viewControl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [viewControl dismissModalViewControllerAnimated:YES];
    //    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.001];
    //    for (UIView; <#condition#>; <#increment#>) {
    //        <#statements#>
    //    }
    //    [self.tableView reloadData];
//    if (self.v) {
//        <#statements#>
//    }
}
@end
@interface FeedTableView()
@property(nonatomic, retain) PhotoDisplayViewController *displayVc;
@property(nonatomic, retain) Issueinfo *currentIssueInfo;

@end
@implementation FeedTableView
@synthesize feedTableDelegate, reportSp, sp;
@synthesize action = _action;
@synthesize firstLoaded = _firstLoaded;
@synthesize cellLayout;
@dynamic heightview;
@synthesize deleteInfoSp;
@synthesize displayVc;
@synthesize currentIssueInfo;
@synthesize videoPlayerViewController;
@synthesize bufferCell;
@synthesize customMovieController;
@synthesize isNeedRotate;


////test begin
//static CGPoint previousOffSet;
////- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView 
//{
//    NSLog(@"test scroll  did drag");
//    [super scrollViewDidScroll:scrollView];
//    
//    BOOL directDown;      
//    if (previousOffSet.y < scrollView.contentOffset.y) {          
//        directDown = YES;          
//    }      
//    else{          
//        directDown = NO;          
//    }      
//    previousOffSet.y = scrollView.contentOffset.y; 
//    if (scrollView.contentOffset.y < 0) {
//        return;
//    }
//    
////    [super scrollViewWillBeginDragging:scrollView];
//    // Refrain the view from scrolling up
//    if (directDown) {
//        [self.feedTableDelegate.navigationController.navigationBar setHidden:YES];
//        self.feedTableDelegate.bcTabBarController.tabBarVisible = NO;
//        self.tableView.frame = CGRectMake(0, 0, 320, 480);
//        self.frame = CGRectMake(0, 0, 320, 480);
//    } else {
//        [self.feedTableDelegate.navigationController.navigationBar setHidden:NO];
//        self.feedTableDelegate.bcTabBarController.tabBarVisible = YES;
//        self.tableView.frame = CGRectMake(0, 0, 320, 376);
//        self.frame = CGRectMake(0, 0, 320, 376);
//    }
//
////    [self.navigationController.navigationBar setHidden:YES];
////    self.bcTabBarController.tabBarVisible = YES;
//}

-(void)setupFeedView:(CGRect)frame
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    UITableViewCell
}
-(FloggerLayout*) getMainlayout
{
    if(!self.cellLayout)
    {
        NSString *xmlLayoutPath = [[NSBundle mainBundle]pathForResource:@"feed" ofType:@"xml"];
        NSString *xmlCSSLayoutPath = [[NSBundle mainBundle]pathForResource:@"feed.css" ofType:@"xml"];
        cellLayout = [[FloggerLayoutAdapter sharedInstance]createLayout:xmlLayoutPath StylePath:xmlCSSLayoutPath];
    }
    return self.cellLayout;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFeedView:frame];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:kNotificationReloadTableView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableCell) name:kNotificationReloadCell object:nil];
//    if ([GlobalUtils checkIOS_6]) {
//        [self.tableView registerClass:[FeedViewCell class] forCellReuseIdentifier:CellIdentifier];
//    }
    return self;
}
-(void) setAction:(NSString *)action
{
    _action = [action retain];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupFeedView:self.frame];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadTableView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReloadCell object:nil];
    
    self.customMovieController = nil;
    self.videoPlayerViewController = nil;
    self.currentIssueInfo = nil;
    self.sp.delegate = nil;
    self.sp = nil;
    reportSp.delegate = nil;
    self.reportSp = nil;
    self.cellLayout = nil;
    self.bufferCell = nil;
    //self.heightview = nil;
    //self.action = nil;
    RELEASE_SAFELY(_heightview);
    RELEASE_SAFELY(_action);
    [super dealloc];
}

-(void) reloadTableView
{
//    [self.tableView reloadData];
    [self reloadTableCell];
//    [self]
}

-(void) reloadTableCell
{
    [MyMoviePlayerManager restoreMyMoviePlayerManager];
    [self.bufferCell restoreNormalState];
    [self.bufferCell viewWithTag:kTableViewVideoTag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"tableview cellForRow at index path indexPath is %d",indexPath.row);
    if ([self isCellForMore:[indexPath row]]) {
        return [self cellForMore:tableView];
    }
    
    FeedViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[[FeedViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.action = self.action;
        cell.delegate = self;
    }
/*FeedViewCell* cell;
    if ([GlobalUtils checkIOS_6]) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell)
        {
            cell = [[[FeedViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.action = self.action;
            cell.delegate = self;
        }
    }*/
    cell.extraParam = [NSMutableDictionary dictionaryWithObject:@"0" forKey:@"delete"];
    
    Issueinfo *issueinfo = [self.dataArr objectAtIndex:[indexPath row]];
    
    cell.issueInfo = issueinfo;
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"tableview heghtForRowAtInde is row %d",indexPath.row);
    if ([self isCellForMore:[indexPath row]]) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    Issueinfo *issueinfo = [self.dataArr objectAtIndex:[indexPath row]];
    
    CGRect rect = [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.heightview ViewDisplayParameters:[FeedViewCell createParamFromIssueInfo:issueinfo ExtraParam:nil] DataFillParameters:issueinfo.dataDict InvisibleViews:[FeedViewCell createInvisibleList:issueinfo ExtraParam:nil]];
    return rect.size.height;//[FeedViewCell tableView:tableView heightForItem:issueinfo];
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    FeedViewCell *feedCell = (FeedViewCell *) cell;
    [feedCell removeMovInCell];
}

-(void)requestAddLike:(Issueinfo *)issueInfo
{
    //    NSString *dataString = [SBJson stringWithFormat]
    NSString *sData = [issueInfo.dataDict JSONRepresentation];
    //    NSLog(@"====== request add like is %@",sData);
    if([((MyIssueInfo *)issueInfo).liked boolValue])
    {
        return;
    }
    self.userInteractionEnabled = NO;
    if (!self.sp) {
        self.sp = [[[LikeInfoComServerProxy alloc] init] autorelease];
    }
    LikeInfoCom *likeInfoCom = [[[LikeInfoCom alloc] init] autorelease];
    likeInfoCom.parentID = issueInfo.id;
    [self.sp addLike:likeInfoCom];
    MyIssueInfo * myIssueInfor = (MyIssueInfo *)issueInfo;
    myIssueInfor.liked = [NSNumber numberWithBool:YES];
    
    //[self.tableView reloadData];
    
    //post like notification
    
      /*
    
    AccountCom *com =[GlobalData sharedInstance].myAccount;
    NSMutableString * strName=[NSMutableString stringWithFormat:@"<A href='at://doaction?%@'>%@</A>"  ,com.userUID,com.username];
    
    //if([myIssueInfor.likecnt intValue]>1&&[myIssueInfor.likecnt intValue]<11)
    if(myIssueInfor.likers)
    {
        [strName appendFormat:@",%@",myIssueInfor.likers];
    } 
    myIssueInfor.likers  = strName;
    
    Likeinfo* objLikeinfo=[[[Likeinfo alloc]init]autorelease];
    objLikeinfo.username=com.username;
    objLikeinfo.useruid=com.userUID;
    NSMutableArray *likerList = myIssueInfor.likerList;
    [likerList  addObject:objLikeinfo];
    myIssueInfor.likerList = likerList;
    //[objLikeinfo release];
  
       */
    NSMutableDictionary *dataChangeDic = [[[NSMutableDictionary alloc] init] autorelease];
    [dataChangeDic setObject:issueInfo.id forKey:kNotificationInfoIssueId];
    [dataChangeDic setObject:kNotificationLikeAction forKey:kNotificationAction];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataChangeDic];
    
    self.userInteractionEnabled = YES;
    
}

-(void)requestDeleteLike:(Issueinfo *)issueInfo
{
    if(![((MyIssueInfo *)issueInfo).liked boolValue])
    {
        return;
    }
    self.userInteractionEnabled = NO;
    if (!self.sp) {
        self.sp = [[[LikeInfoComServerProxy alloc] init] autorelease];
    }
    LikeInfoCom *likeInfoCom = [[[LikeInfoCom alloc] init] autorelease];
    NSMutableArray *issueIdList = [[[NSMutableArray alloc] initWithObjects:issueInfo.id, nil] autorelease];
    likeInfoCom.issueIdList = issueIdList;
    [self.sp deleteLikeIssue:likeInfoCom];
    MyIssueInfo * myIssueInfor = (MyIssueInfo *)issueInfo;
    myIssueInfor.liked = [NSNumber numberWithBool:NO];
    //[self.tableView reloadData];
    //post unlike notification
    /*
    AccountCom *com =[GlobalData sharedInstance].myAccount;
   //NSLog(@"jiesu %@", [NSString stringWithFormat:NSLocalizedString(@"%d people",@"%d people"),[ myIssueInfor.id longLongValue ],[myIssueInfor.likecnt intValue]-1]);
    if (myIssueInfor.likerList.count <=0) {
        myIssueInfor.likers=[NSString stringWithFormat:NSLocalizedString(@"%d people",@"%d people"),[ myIssueInfor.id longLongValue ],[myIssueInfor.likecnt intValue]-1];
    }else{
        NSMutableArray* objLikeinfoToRemove=[[NSMutableArray alloc] initWithCapacity:1];
        NSMutableArray *likerList = myIssueInfor.likerList;
        for (Likeinfo *objLikeinfoTemp in likerList) {
            if ([com.username isEqualToString:objLikeinfoTemp.username]) {
                [objLikeinfoToRemove addObject:objLikeinfoTemp];
            }
        }
        [likerList removeObjectsInArray:objLikeinfoToRemove];
        [objLikeinfoToRemove release];
          [myIssueInfor setLikerList:likerList];
        if(myIssueInfor.likerList.count<1&& [myIssueInfor.likecnt intValue]<=1){
            myIssueInfor.likers=nil;
        }else{
            myIssueInfor.likers=[myIssueInfor.likers substringFromIndex:[myIssueInfor.likers rangeOfString:@","].location+1];
        }
            
    }
    
    */
    
    
    
    
    NSMutableDictionary *dataChangeDic = [[[NSMutableDictionary alloc] init] autorelease];
    [dataChangeDic setObject:issueInfo.id forKey:kNotificationInfoIssueId];
    [dataChangeDic setObject:kNotificationUnLikeAction forKey:kNotificationAction];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataChangeDic];
    //[self.tableView reloadData];
    self.userInteractionEnabled = YES;
}

-(void) showReportAlertView
{
    UIAlertView *reportAlertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Thanks", @"Thanks") message: NSLocalizedString(@"We'll review this media as soon as possible", @"We'll review this media as soon as possible")  delegate:self cancelButtonTitle:nil otherButtonTitles: NSLocalizedString(@"Dismiss", @"Dismiss") , nil] autorelease];
    reportAlertView.tag = 2;
    [reportAlertView show]; 
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!self.reportSp) {
        self.reportSp = [[[ReportServerProxy alloc] init] autorelease];
    }     
    ReportCom *com = [[[ReportCom alloc] init] autorelease];
    //    NSString *comContent = 
    switch (buttonIndex) {
        case 0:
        {
            com.issueID = self.currentIssueInfo.id;
            com.content = NSLocalizedString(@"Nudity", @"Nudity");
            [self.reportSp addReport:com];
            [self showReportAlertView];
        }
            break;
        case 1:
        {
            com.issueID = self.currentIssueInfo.id;
            com.content = NSLocalizedString(@"Copyright", @"Copyright");
            [self.reportSp addReport:com];
            [self showReportAlertView];
        }
            break;
        case 2:
        {
            com.issueID = self.currentIssueInfo.id;
            com.content = NSLocalizedString(@"Terms of Use Violation",@"Terms of Use Violation");
            [self.reportSp addReport:com];
            [self showReportAlertView];
        }
            break;
            
        default:
            break;
    }    
}

-(void)addReport:(Issueinfo *)issueinfo
{
    //    [GlobalUtils a\]
    UIActionSheet *action = [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Reason for reporting", @"Reason for reporting") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Nudity", @"Nudity"),NSLocalizedString(@"Copyright", @"Copyright"),NSLocalizedString(@"Terms of Use Violation",@"Terms of Use Violation"), nil] autorelease];
    [action showInView:self];
}

-(void) copyFilter : (Issueinfo *) issueinfo
{
    FloggerCameraControl *cameraControl = [[[FloggerCameraControl alloc] init] autorelease];
    cameraControl.statusMode = PHOTOMODE;  
    cameraControl.syntax = issueinfo.filtersyntax;
    CameraNaviViewController *cameraNav = [[[CameraNaviViewController alloc] initWithRootViewController:cameraControl] autorelease];
    if (feedTableDelegate.bcTabBarController) {
        [feedTableDelegate.bcTabBarController presentModalViewController:cameraNav animated:YES];
    } else {
        [feedTableDelegate presentModalViewController:cameraNav animated:YES];
    }
    
    
}

//-(void) inspireAction : (Issueinfo *) issueinfo
//{
////    FloggerCameraControl *cameraControl = [[[FloggerCameraControl alloc] init] autorelease];
////    cameraControl.statusMode = PHOTOMODE;  
////    cameraControl.syntax = issueinfo.filtersyntax;
////    CameraNaviViewController *cameraNav = [[[CameraNaviViewController alloc] initWithRootViewController:cameraControl] autorelease];
////    [feedTableDelegate presentModalViewController:cameraNav animated:NO];
//    FeedViewerViewController *feedViewrControl = [[[FeedViewerViewController alloc] init] autorelease];
//    feedViewrControl.issueInfo = issueinfo;
//    [feedTableDelegate.navigationController pushViewController:feedViewrControl animated:YES];
//    
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        switch (buttonIndex)
        {
            case 0:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *progressHud;
                    progressHud = [MBProgressHUD showHUDAddedTo:self animated:NO];
                    progressHud.labelText = NSLocalizedString(@"Deleting...", @"Deleting...") ;
                });
                
                if (!self.deleteInfoSp) {
                    self.deleteInfoSp = [[[IssueInfoComServerProxy alloc] init] autorelease];
                    self.deleteInfoSp.delegate = self;
                }
                IssueInfoCom *com = [[[IssueInfoCom alloc] init] autorelease];
                com.issueId = self.currentIssueInfo.id;
                //                NSLog(@"delete before is %lld",[com.issueId longLongValue]);
                [self.deleteInfoSp deleteIssueInfo:com];
            }
                break;
            default:
                break;
        }  
    }
    //    else if (alertView.tag == 2)
    //    {
    //        switch (buttonIndex) {
    //            case 0:
    //                <#statements#>
    //                break;
    //                
    //            default:
    //                break;
    //        }
    //    }
    
}


-(void) deleteFeed : (Issueinfo *) issueinfo
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure want to delete it from iflogger?",@"Are you sure want to delete it from iflogger?") message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @"OK"), NSLocalizedString(@"Cancel", @"Cancel"),nil] autorelease];
    alertView.tag = 1;
    [alertView show];
    
}

-(void)transactionFailed:(BaseServerProxy *)serverproxy
{
    if (deleteInfoSp == serverproxy)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self animated:NO];
        });        
    }
}

-(void)networkError:(BaseServerProxy *)serverproxy
{
    if (deleteInfoSp == serverproxy)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self animated:NO];
        });        
    }
}

//- (void)networkFinished:(BaseServerProxy *)serverproxy
//{    
//    if (serverproxy.errorMessage) {
//        [GlobalUtils showPostMessageAlert:serverproxy.errorMessage];
//        serverproxy.response = nil;
//        serverproxy.errorMessage = nil;
//    }
//}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    //    NSLog(@"server proxy is %@",[serverproxy class]);
    if (deleteInfoSp == serverproxy)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self animated:NO];
        });
        IssueInfoCom *com = (IssueInfoCom *) serverproxy.response;
        NSMutableDictionary *dataChangeDic = [[[NSMutableDictionary alloc] init] autorelease];
        //        NSLog(@"delete finish com.issueId is %lld",[com.issueId longLongValue]);
        [dataChangeDic setObject:com.issueId forKey:kNotificationInfoIssueId];
        [dataChangeDic setObject:kNotificationDeleteAction forKey:kNotificationAction];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataChangeDic];
        if ([self isKindOfClass:[ViewerFeedTableView class]]) {
            [self.feedTableDelegate.navigationController popViewControllerAnimated:NO];
        }
    }
    
}


-(void)showMap:(Issueinfo *)issueinfo
{
    //   UI
    MapViewController *mapViewController = [[[MapViewController alloc] init] autorelease];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [issueinfo.shootlat doubleValue];//[issueinfo shootlat];
    coordinate.longitude = [issueinfo.shootlon doubleValue];//[issueinfo shootlon];
    MapPoint *mapPoint = [[[MapPoint alloc] initWithCoordinate:coordinate title:issueinfo.location subTitle:nil] autorelease];
    
    mapViewController.mapPoint = mapPoint;
    
    [self.feedTableDelegate.bcTabBarController presentModalViewController:mapViewController animated:YES];
    
    //    mapViewController.mapPoint =
}

-(void)showImage:(Issueinfo *)issueinfo
{
    if(![[DataCache sharedInstance] imageFromKey:issueinfo.bmiddleurl])
    {
        return;
    }
    self.displayVc = [[[PhotoDisplayViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    self.displayVc.image = [[DataCache sharedInstance] imageFromKey:issueinfo.bmiddleurl];
    self.displayVc.delegate = self;
    //    self.displayVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    [self.feedTableDelegate presentModalViewController:self.displayVc animated:NO];
    self.displayVc.view.frame =CGRectMake(0, 0, 320, 480);
    /*self.displayVc.view.frame =CGRectMake(0, 0, 320, 480);
     if (self.feedTableDelegate.tabBarController)
     {
     [self.feedTableDelegate.tabBarController.view addSubview:self.displayVc.view];
     } else {
     [self.feedTableDelegate.navigationController.view addSubview:self.displayVc.view];
     }*/
    self.displayVc.view.alpha = 0.0;
    
    [self.window addSubview:self.displayVc.view];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    [UIView beginAnimations:nil context:nil];
    self.displayVc.view.alpha = 1.0;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.25];
    [UIView commitAnimations];
}
-(void)dismissDisplayView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [UIView beginAnimations:@"fadeout" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.25];
    self.displayVc.view.alpha = 0.0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(photoAnimationDidStop:finished: context:)];
    [UIView commitAnimations];
    //    [self.displayVc dismissModalViewControllerAnimated:NO];
}

-(void)photoAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if([@"fadeout" isEqualToString:animationID])
    {
        [self.displayVc.view removeFromSuperview];
        [self.displayVc unregisterNotification];
        self.displayVc = nil;
        //        [self.displayVc dismissModalViewControllerAnimated:NO];
    }
}




-(void)go2ViewerWithIssueinfo:(Issueinfo *)issueinfo
{
    FeedViewerViewController *viewerController = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewerController.showHeader = NO;
    viewerController.issueInfo = [[[MyIssueInfo alloc] init] autorelease];//issueinfo;
    viewerController.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:issueinfo.dataDict];
    [self.feedTableDelegate.navigationController pushViewController:viewerController animated:YES];
    //    [self bringSubviewToFront:viewerController.view];
}

-(void)go2ViewerFullThreadWithIssueinfo:(Issueinfo *)issueinfo
{
    FeedViewerViewController *viewerController = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewerController.showHeader = YES;
    viewerController.issueInfo = [[[MyIssueInfo alloc] init] autorelease];//issueinfo;
    viewerController.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:issueinfo.dataDict];
    [self.feedTableDelegate.navigationController pushViewController:viewerController animated:YES];
    //    [self bringSubviewToFront:viewerController.view];
}

-(void)go2Share:(Issueinfo *)issueInfo
{
    ShareFeedViewController *vc = [[[ShareFeedViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.issueList = [[[NSMutableArray alloc] initWithObjects:issueInfo, nil] autorelease];
    vc.shareType = SHAREISSUE;
    [self.feedTableDelegate.navigationController pushViewController:vc animated:YES];
    //    [self.feedTableDelegate.navigationController presentModalViewController:vc animated:YES];
}

//-(void)playVideoStream:(NSURL *)movieFileURL {
//    
//    MPMovieSourceType movieSourceType = MPMovieSourceTypeUnknown;
//    movieSourceType = MPMovieSourceTypeStreaming;
//    [self createAndPlayMovieForURL:movieFileURL sourceType:movieSourceType]; 
//}

//-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType {
//    
//    /* Play the video! */    
//
//    MPMoviePlayerViewController *moviePlayer = [[[MPMoviePlayerViewController alloc] initWithContentURL:movieURL] autorelease];
//    moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//    moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [moviePlayer.moviePlayer prepareToPlay];
//    [moviePlayer.moviePlayer play];
//    [self.feedTableDelegate.navigationController presentModalViewController:moviePlayer animated:YES];
//}


//-(void) go2PlayVideo:(Issueinfo *)issueinfo
//{
////    NSString *bufferFilePath =  [[[DataCache sharedInstance] cachePathForKey:issueinfo.videourl andCategory:nil]stringByAppendingPathExtension:@"mov"];
////    NSURL *videoUrl = [NSURL URLWithString:[NSString stringWithFormat:issueinfo.videourl]];
////    
////    NSLog(@"bufferFilePath is %@",bufferFilePath);
////    
////    MPMovieSourceType movieSourceType = MPMovieSourceTypeStreaming;
////    if ([[NSFileManager defaultManager] fileExistsAtPath:bufferFilePath]) {
////        videoUrl = [NSURL fileURLWithPath:bufferFilePath];
////        //        [ns]
////        //        [NSFileManager defaultManager] removeItemAtURL:<#(NSURL *)#> error:<#(NSError **)#>
////        //        [NSFileManager defaultManager]
////        movieSourceType = MPMovieSourceTypeFile;
////    }
//    
//}



/*-(void) go2PlayVideoBefore:(Issueinfo *)issueinfo
 {
 //to do play video   
 
 NSString *bufferFilePath =  [[[DataCache sharedInstance] cachePathForKey:issueinfo.videourl andCategory:nil]stringByAppendingPathExtension:@"mov"];
 NSURL *videoUrl = [NSURL URLWithString:[NSString stringWithFormat:issueinfo.videourl]];
 
 NSLog(@"bufferFilePath is %@",bufferFilePath);
 
 MPMovieSourceType movieSourceType = MPMovieSourceTypeStreaming;
 if ([[NSFileManager defaultManager] fileExistsAtPath:bufferFilePath]) {
 videoUrl = [NSURL fileURLWithPath:bufferFilePath];
 //        [ns]
 //        [NSFileManager defaultManager] removeItemAtURL:<#(NSURL *)#> error:<#(NSError **)#>
 //        [NSFileManager defaultManager]
 movieSourceType = MPMovieSourceTypeFile;
 }
 
 MPMoviePlayerViewController *moviePlayer = [[[MPMoviePlayerViewController alloc] initWithContentURL:videoUrl] autorelease];
 moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
 moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 [moviePlayer.moviePlayer prepareToPlay];
 [moviePlayer.moviePlayer play];
 //    [self.feedTableDelegate.navigationController presentModalViewController:moviePlayer animated:YES];  
 if (self.feedTableDelegate.bcTabBarController) {
 [self.feedTableDelegate.bcTabBarController presentModalViewController:moviePlayer animated:NO];
 } else {
 [self.feedTableDelegate presentModalViewController:moviePlayer animated:NO];
 }
 }*/
-(void)displayError:(NSError *)theError
{
	if (theError)
	{
		UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: [theError localizedDescription]
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.delegate = self;
		[alert show];
		[alert release];
	}
}

-(void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = [self videoPlayerViewController];
    
//	[[NSNotificationCenter defaultCenter] addObserver:self 
//                                             selector:@selector(loadStateDidChange:) 
//                                                 name:MPMoviePlayerLoadStateDidChangeNotification 
//                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:player];
    
//	[[NSNotificationCenter defaultCenter] addObserver:self 
//                                             selector:@selector(mediaIsPreparedToPlayDidChange:) 
//                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification 
//                                               object:player];
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self 
//                                             selector:@selector(moviePlayBackStateDidChange:) 
//                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification 
//                                               object:player]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
}

-(void)removeMovieNotificationHandlers
{    
    MPMoviePlayerController *player = [self videoPlayerViewController];
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:nil];
}

- (void)willEnterFullscreen:(NSNotification*)notification {
//    NSLog(@"willEnterFullscreen");
}

- (void)enteredFullscreen:(NSNotification*)notification {
//    NSLog(@"enteredFullscreen");
}

- (void)willExitFullscreen:(NSNotification*)notification {
//    NSLog(@"willExitFullscreen");
}

- (void)exitedFullscreen:(NSNotification*)notification {
//    NSLog(@"exitedFullscreen");

    [self stopVideo:notification];
    

}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]; 
	switch ([reason integerValue]) 
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
            //            [self dismissModalViewControllerAnimated:NO];
            //            [self.moviePlayerController pause];
            //            [self.moviePlayerController ]
            //close
            [self stopVideo:notification];
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
            //            NSLog(@"An error was encountered during playback");
            [self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:@"error"] 
                                waitUntilDone:NO];
            //            [self removeMovieViewFromViewHierarchy];
            //            [self removeOverlayView];
            //            [self.backgroundView removeFromSuperview];
            
			break;
            
            /* The user stopped playback. */
		case MPMovieFinishReasonUserExited:
            //            [self removeMovieViewFromViewHierarchy];
            //            [self removeOverlayView];
            //            [self.backgroundView removeFromSuperview];
            //close
            [self stopVideo:notification];
			break;
            
		default:
			break;
	}
//    [self.videoPlayerViewController setFullscreen:NO animated:YES];
}

-(void) go2PlayVideoBySystem : (Issueinfo *) issueinfo
{
//    FloggerViewAdpater *videoplay = [self.mainview getAdpaterByName:@"videoPlay"];
//    FloggerImageView * playView = (FloggerImageView *) videoplay.view;
//    if (!playView) {
//        return;
//    }
//    if (![self.bufferCell checkPlayView]) {
//        return;
//    }
    
    NSString *bufferFilePath =  [[[DataCache sharedInstance] cachePathForKey:issueinfo.videourl andCategory:nil]stringByAppendingPathExtension:@"mov"];
    NSURL *videoUrl = [NSURL URLWithString:issueinfo.videourl];
//    self.isNeedRotate = YES;
    [self.bufferCell addMoviePlayer:videoUrl withBufferPath:bufferFilePath withController:self.feedTableDelegate];
    
//    [self.bufferCell addMoviePlayer:videoUrl withBufferPath:bufferFilePath];
//    [self.bufferCell addMoviePlayer:<#(NSURL *)#> withBufferPath:<#(NSString *)#> withController:<#(UIViewController *)#>]
    
//    [self.bufferCell addMoviePlayer:videoUrl withBufferPath:bufferFilePath withController:self.feedTableDelegate withTableView:self];
    
//    [self.bufferCell addMoviePlayer:videoUrl withBufferPath:bufferFilePath];
//    []
    
    /*FloggerViewAdpater *videoplay = [self.bufferCell.mainview getAdpaterByName:@"photo"];
    FloggerImageView * playView = (FloggerImageView *) videoplay.view;
    
    MyMovieViewController *myMovieViewControl = [[[MyMovieViewController alloc] init] autorelease];
//    myMovieViewControl.moviePlayerController.view.frame = playView.bounds;
    [myMovieViewControl  iniViewFrame:playView.bounds];
    
//    myMovieViewControl.cellView = self.bufferCell;
    myMovieViewControl.view.tag = VIDEOTAG;
//    myMovieViewControl.movieDelegate = [MyMovieHandler sharedInstance];
   
    if ([[NSFileManager defaultManager] fileExistsAtPath:bufferFilePath]) {
        videoUrl = [NSURL fileURLWithPath:bufferFilePath];
        [myMovieViewControl playMovieFile:videoUrl];
    } else {
        [myMovieViewControl playMovieStream:videoUrl];
    }
//    [playView addSubview:myMovieViewControl.moviePlayerController.view];
    self.bufferCell.isPlaying = YES;
     self.customMovieController = myMovieViewControl;*/
}

-(void) go2PlayVideoBySystemXXX : (Issueinfo *) issueinfo
{
    NSString *bufferFilePath =  [[[DataCache sharedInstance] cachePathForKey:issueinfo.videourl andCategory:nil]stringByAppendingPathExtension:@"mov"];
    NSURL *videoUrl = [NSURL URLWithString:issueinfo.videourl];
    
    FloggerViewAdpater *videoplay = [self.bufferCell.mainview getAdpaterByName:@"photo"];
    FloggerImageView * playView = (FloggerImageView *) videoplay.view;
    
    MPMoviePlayerController *moviePlayerControl = [[[MPMoviePlayerController alloc] init] autorelease];
    moviePlayerControl.view.frame = playView.bounds;
    self.videoPlayerViewController = moviePlayerControl;
    
    [self installMovieNotificationObservers];
    
    self.videoPlayerViewController.controlStyle = MPMovieControlStyleEmbedded;
    self.videoPlayerViewController.view.tag = VIDEOTAG;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:bufferFilePath]) {
        videoUrl = [NSURL fileURLWithPath:bufferFilePath];
        self.videoPlayerViewController.movieSourceType = MPMovieSourceTypeFile;
    } else {
        self.videoPlayerViewController.movieSourceType = MPMovieSourceTypeStreaming;
    }
    self.videoPlayerViewController.contentURL = videoUrl;
    [self.videoPlayerViewController setFullscreen:YES animated:YES];
    [self.videoPlayerViewController prepareToPlay];
    [self.videoPlayerViewController play];
    
    [playView addSubview:self.videoPlayerViewController.view];
    
    [self.bufferCell restoreNormalState];
    
}

-(void) go2PlayVideo:(Issueinfo *)issueinfo
{
    if (isplaying) {
        return;
    }
    isplaying =1;
    NSString *bufferFilePath =  [[[DataCache sharedInstance] cachePathForKey:issueinfo.videourl andCategory:nil]stringByAppendingPathExtension:@"mov"];
    NSURL *videoUrl = [NSURL URLWithString:issueinfo.videourl];
    
    //    NSLog(@"bufferFilePath is %@",bufferFilePath);
    
    MyMovieViewController *myMovieViewControl = [[[MyMovieViewController alloc] init] autorelease];
    myMovieViewControl.movieDelegate = [MyMovieHandler sharedInstance];
    
    //    videoUrl = [NSURL URLWithString:@"http://www.iflogger.com/video/test/test.m3u8"]; 
    //    [myMovieViewControl playMovieStream:videoUrl];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:bufferFilePath]) {
        videoUrl = [NSURL fileURLWithPath:bufferFilePath];
        [myMovieViewControl playMovieFile:videoUrl];
    } else {
        [myMovieViewControl playMovieStream:videoUrl];
    }
    
    //    NSLog(@"videourl is %@",videoUrl);  
    //[self.tableView reloadData];
    //[self removeActiviteView];
    [self.bufferCell restoreNormalState];
    
    if (self.feedTableDelegate.bcTabBarController) {
        [self.feedTableDelegate.bcTabBarController presentModalViewController:myMovieViewControl animated:NO];
    } else {
        [self.feedTableDelegate presentModalViewController:myMovieViewControl animated:NO];
    }
    
    //    [self.feedTableDelegate presentModalViewController:myMovieViewControl animated:NO];
    //    if ([myMovieViewControl.moviePlayerController isPreparedToPlay]) {
    //    }
    
}

-(void) removeActiviteView
{
    for (UIView *view in self.tableView.subviews) {
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView *act = (UIActivityIndicatorView *) view;
            [act stopAnimating];
            [view removeFromSuperview];
            break;
        }
    }
}




///*-(void) go2PlayVideoxxx:(Issueinfo *)issueinfo
//{
//    //to do play video   
//    
//    NSString *bufferFilePath =  [[[DataCache sharedInstance] cachePathForKey:issueinfo.videourl andCategory:nil]stringByAppendingPathExtension:@"mov"];
//    NSURL *videoUrl = [NSURL URLWithString:[NSString stringWithFormat:issueinfo.videourl]];
//    
//    NSLog(@"bufferFilePath is %@",bufferFilePath);
//    
//    MPMovieSourceType movieSourceType = MPMovieSourceTypeStreaming;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:bufferFilePath]) {
//        videoUrl = [NSURL fileURLWithPath:bufferFilePath];
//        //        [ns]
//        //        [NSFileManager defaultManager] removeItemAtURL:<#(NSURL *)#> error:<#(NSError **)#>
//        //        [NSFileManager defaultManager]
//        movieSourceType = MPMovieSourceTypeFile;
//    }
//        
//    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:videoUrl];
////    moviePlayer shouldAutorotateToInterfaceOrientation:<#(UIInterfaceOrientation)#>
//    
////    [moviePlayer shouldAutorotateToInterfaceOrientation:[UIDevice currentDevice].orientation];
//    
//    moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//    moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [moviePlayer.moviePlayer prepareToPlay];
//    [moviePlayer.moviePlayer play];
//    
//    [self setVideoPlayerViewController:moviePlayer];
//    //[moviePlayer.moviePlayer setShouldAutoplay:YES];
//    moviePlayer.moviePlayer.view.frame = self.window.bounds;
//    [self.window addSubview:moviePlayer.moviePlayer.view];
//    [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVideo:) 
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:moviePlayer.moviePlayer];
//    /*if (self.feedTableDelegate.tabBarController) {
//        [self.feedTableDelegate.tabBarController.view addSubview:moviePlayer.view];
//    } else {
//        [self.feedTableDelegate.view addSubview:moviePlayer.view];
//    }*/
//    [moviePlayer release];
//    //    [self.feedTableDelegate.navigationController presentModalViewController:moviePlayer animated:YES];  
//}


/*-(void) go2PlayVideo:(Issueinfo *)issueinfo
 {
 //to do play video   
 
 NSString *bufferFilePath =  [[[DataCache sharedInstance] cachePathForKey:issueinfo.videourl andCategory:nil]stringByAppendingPathExtension:@"mov"];
 NSURL *videoUrl = [NSURL URLWithString:[NSString stringWithFormat:issueinfo.videourl]];
 
 NSLog(@"bufferFilePath is %@",bufferFilePath);
 
 MPMovieSourceType movieSourceType = MPMovieSourceTypeStreaming;
 if ([[NSFileManager defaultManager] fileExistsAtPath:bufferFilePath]) {
 videoUrl = [NSURL fileURLWithPath:bufferFilePath];
 //        [ns]
 //        [NSFileManager defaultManager] removeItemAtURL:<#(NSURL *)#> error:<#(NSError **)#>
 //        [NSFileManager defaultManager]
 movieSourceType = MPMovieSourceTypeFile;
 }
 
 //    [MPMoviePlayerController s]
 
 MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:videoUrl];
 
 moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
 moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 [moviePlayer.moviePlayer prepareToPlay];
 [moviePlayer.moviePlayer play];
 
 [self setVideoPlayerViewController:moviePlayer];
 //[moviePlayer.moviePlayer setShouldAutoplay:YES];
 moviePlayer.moviePlayer.view.frame = self.window.bounds;
 [self.window addSubview:moviePlayer.moviePlayer.view];
 [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVideo:) 
 name:MPMoviePlayerPlaybackDidFinishNotification
 object:moviePlayer.moviePlayer];
 //    if (self.feedTableDelegate.tabBarController) {
 //     [self.feedTableDelegate.tabBarController.view addSubview:moviePlayer.view];
 //     } else {
 //     [self.feedTableDelegate.view addSubview:moviePlayer.view];
 //     }
 [moviePlayer release];
 //    [self.feedTableDelegate.navigationController presentModalViewController:moviePlayer animated:YES];  
 //    if (self.feedTableDelegate.tabBarController) {
 //     [self.feedTableDelegate.tabBarController presentModalViewController:moviePlayer animated:NO];
 //     } else {
 //     [self.feedTableDelegate presentModalViewController:moviePlayer animated:NO];
 //     }
 }*/

-(void) didStopVideo
{
    [self.videoPlayerViewController.view removeFromSuperview];
    self.videoPlayerViewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void) stopVideo:(NSNotification *)notification 
{
    [self.videoPlayerViewController setFullscreen:NO animated:YES];
    
    [self.videoPlayerViewController.view removeFromSuperview];
    self.videoPlayerViewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self performSelector:@selector(didStopVideo) withObject:nil afterDelay:0.01];
}

-(void)go2Profile:(Issueinfo *)issueinfo
{
    MyAccount *account = [[[MyAccount alloc] init] autorelease];
    account.useruid = issueinfo.useruid;
    account.username = issueinfo.username;
    account.imageurl = issueinfo.imageurl;
    ProfileViewController *vc = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.account = account;
    [self.feedTableDelegate.navigationController pushViewController:vc animated:YES];
}

-(void)go2LikeList:(Issueinfo *)issueinfo
{
    FriendListViewController *friendListViewController=[[[FriendListViewController alloc]init] autorelease];
    friendListViewController.type = FriendListVIew_Likes;
    IssueInfoCom *issueInfoCom=[[[IssueInfoCom alloc] init] autorelease];
    issueInfoCom.issueId=issueinfo.id;
    issueInfoCom.itemNumberOfPage=[NSNumber numberWithInt:pageSize];
    friendListViewController.issueInfoCom=issueInfoCom;
    [self.feedTableDelegate.navigationController pushViewController:friendListViewController animated:YES];
}

-(void)writeComment:(Issueinfo *)issueinfo
{
    /*CommentPostViewController *vc = [[[CommentPostViewController alloc] init] autorelease];
    vc.issueinfo = issueinfo;
    vc.composeMode = COMMENTMODE;
    [self.feedTableDelegate.navigationController pushViewController:vc animated:YES];*/
    CommentViewController *vc = [[[CommentViewController alloc] init] autorelease];
    vc.issueInfo = [[[MyIssueInfo alloc] init] autorelease];//issueinfo;
    vc.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:issueinfo.dataDict];
    vc.showHeader = NO;
    vc.commentMode = WRITEVIEWCOMMENT;
    [self.feedTableDelegate.navigationController pushViewController:vc animated:YES];
}

-(void)showComment:(Issueinfo *)issueinfo
{
    /*CommentPostViewController *vc = [[[CommentPostViewController alloc] init] autorelease];
     vc.issueinfo = issueinfo;
     vc.composeMode = COMMENTMODE;
     [self.feedTableDelegate.navigationController pushViewController:vc animated:YES];*/
    CommentViewController *vc = [[[CommentViewController alloc] init] autorelease];
    vc.issueInfo = [[[MyIssueInfo alloc] init] autorelease];//issueinfo;
    vc.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:issueinfo.dataDict];
    vc.showHeader = NO;
    vc.commentMode = SHOWCOMMNENT;
    [self.feedTableDelegate.navigationController pushViewController:vc animated:YES];
}


-(void)openTag:(NSString *)tag
{
    Taglist *taglist = [[[Taglist alloc] init] autorelease];
    taglist.content = tag;
    TagFeedViewController *vc = [[[TagFeedViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.taginfo = taglist;
    [self.feedTableDelegate.navigationController pushViewController:vc animated:YES];
}


-(void)handleAction:(NSInteger)actionType withIssueInfo:(Issueinfo *)issueInfo
{
    self.currentIssueInfo = issueInfo;
    switch (actionType) {
        case kTagImageBtn:
            // click on the image TODO
            [self showImage:issueInfo];
            break;
        case kTagMap:
            [self showMap:issueInfo];
            break;
        case kTagCommentBtn:
//            [self go2ViewerWithIssueinfo:issueInfo];
            [self showComment:issueInfo];
            break;
        case kTagShowFullThread:
            [self go2ViewerFullThreadWithIssueinfo:issueInfo];
            break;   
        case kTagLikeBtn:
            [MyMoviePlayerManager restoreMyMoviePlayerManager];
            [self requestAddLike:issueInfo];
            //            issueInfo.likecnt = [NSNumber numberWithInt:issueInfo.likecnt.intValue + 1];
            //            ((MyIssueInfo *)issueInfo).liked = [NSNumber numberWithBool:YES];
            //            [self.tableView reloadData];
            break;
        case kTagDeleteLikeBtn:
            //            issueInfo.likecnt = [NSNumber numberWithInt:issueInfo.likecnt.intValue - 1];
            //            ((MyIssueInfo *)issueInfo).liked = [NSNumber numberWithBool:NO];
            [MyMoviePlayerManager restoreMyMoviePlayerManager];
            [self requestDeleteLike:issueInfo];
            //            [self.tableView reloadData];
            break;
        case kTagFlagBtn:
            [self addReport:issueInfo];
            break;
        case kTagShareBtn:
            [self go2Share:issueInfo];
            break;
        case kTagProfileBtn:
            [self go2Profile:issueInfo];
            break;
        case kTagPlayVideo:
            //            [self go2PlayVideo:issueInfo];
            [self performSelector:@selector(go2PlayVideoBySystem:) withObject:issueInfo afterDelay:0.01];
            break;
        case kTagDelete:
            [self deleteFeed:issueInfo];
            break;
        case kTagCopyFilter:
            //dispatch_async(dispatch_get_main_queue(), ^{
            //[self copyFilter:issueInfo];
            [self performSelector:@selector(copyFilter:) withObject:issueInfo afterDelay:0.01];
            //});
            break;
        case kTagInspire:
            //            issueInfo.parentid
            //issueInfo.id = issueInfo.parentid;
        {
            Issueinfo *parentIssueid = [[[MyIssueInfo alloc]init]autorelease];
            parentIssueid.id = issueInfo.parentid;
            [self go2ViewerWithIssueinfo:parentIssueid];
        }
            break;
        case kTagWriteComment:
            [self writeComment:issueInfo];
            break;
        case  kTagShowLikers:
            [self go2LikeList:issueInfo];
            break;
        default:
            break;
    }
}

//-(void)willMoveToSuperview:(UIView *)newSuperview
//{
//    [super willMoveToSuperview:newSuperview];
//    if ([self.bufferCell viewWithTag:kTableViewVideoTag] && (newSuperview == [self.bufferCell viewWithTag:kTableViewVideoTag])) {
//        MPMoviePlayerController *customPlayerController =  [MyMoviePlayerManager getMyMoviePlayerManager].moviePlayerController;
//    }
//}

@end
