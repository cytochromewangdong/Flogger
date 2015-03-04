//
//  ProfileViewController.m
//  Flogger
//
//  Created by steveli on 09/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "ProfileViewController.h"
#import "AccountCom.h"
#import "FeedTableView.h"
#import "IssueInfoCom.h"
#import "IssueInfoComServerProxy.h"
#import "AlbumViewController.h"
#import "BiographyViewController.h"
#import "GlobalData.h"
#import "FollowComServerProxy.h"
#import "FollowCom.h"
#import "FriendListViewController.h"
#import "FloggerCameraControl.h"
#import "DataCache.h"
#import "ProfileTableView.h"
#import "ShareFeedViewController.h"
#import "VideoPlayViewController.h"
#import "FeedViewerViewController.h"
//#import "UIImageView+WebCache.h"
#import "SettingViewController.h"
#import "UIViewController+iconImage.h"


#define kTakePhoto 100
#define kGallery   200
#define kPhotoLibrary 300
#define kCancel 400
#define kProfilePagesize 60

#define kCurrentAction @"profile"
extern NSString * const kFollowingChangedNotification;

NSString * const kProfileChangedNotification    = @"kProfileChangedNotification";

@interface ProfileViewController ()
- (void) myRleaseResource;
@end
@implementation ProfileViewController
@synthesize account,feedtableview,ismyself,accountImageProxy,accountStatusProxy,pickercontroller,followComServerProxy, isFollowedChanged, profileServerProxy;
@synthesize galleryButton,biograButton;
@synthesize isFromProfile;

-(void)followChanged
{
    self.isFollowedChanged = YES;
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(followChanged) 
                                                 name:kFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(followChanged) 
                                                 name:kProfileChangedNotification object:nil];
}

-(void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProfileChangedNotification object:nil];
}


-(void)notifyFollowingChanged
{
    NSNotification *note = [NSNotification notificationWithName:kFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ismyself = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChangeAction:) name:kDataChangeIssueInfo object:nil];
        currentDataRow = -1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


-(void)setDetailBtn:(UIButton*)btn
{
    
}

#pragma http

-(void)dofollowset:(BOOL)isFollow
{
    if (_isFollowing)
    {
        return;
    }
    _isFollowing = YES;
    
    if(!self.followComServerProxy)
    {
        self.followComServerProxy = [[[FollowComServerProxy alloc] init] autorelease];
        self.followComServerProxy.delegate = self;
    }
    

    FollowCom *followcom = [[[FollowCom alloc] init] autorelease];
    followcom.requestedUserUID = account.useruid;
    
    _isFollow = isFollow;
    if(isFollow)
        [followComServerProxy follow:followcom];
    else
        [followComServerProxy unfollow:followcom];
}


-(void)uploadStatus:(NSString*)status
{
    AccountCom *accountCom = [[[AccountCom alloc] init] autorelease];
    
    
    if (_isUpdateingStatus)
    {
        return;
    }
    _isUpdateingStatus = YES;
    
    accountCom.userUID = [GlobalData sharedInstance].myAccount.userUID;
    
    if (!self.accountStatusProxy) 
    {
        self.accountStatusProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.accountStatusProxy.delegate = self;
    }
    [accountStatusProxy updateStatus:accountCom withStatus:status];
    
}

-(void)uploadImage:(UIImage*)img
{
    AccountCom *accountCom = [[[AccountCom alloc] init] autorelease];//[GlobalData sharedInstance].myAccount;
    
    if (_isUpdateingImage) 
    {
        return;
    }
    _isUpdateingImage = YES;
    
    accountCom.userUID = [GlobalData sharedInstance].myAccount.userUID;
    
    if (!self.accountImageProxy) 
    {
        self.accountImageProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.accountImageProxy.delegate = self;
    }
    
    [accountImageProxy updateImage:accountCom withPhoto:img];
    
}

/*-(void)doRequest:(BOOL)isMore

{
//    if (self.loading) {
//        return;
//    }
//    _isSearchingMore = isMore;
    self.loading = YES;
    
    if(!self.serverProxy)
    {
        self.serverProxy = [[[IssueInfoComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    
    if (isMore) 
    {
        issueInfoCom.searchEndID = self.feedtableview.endId;
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
    }
    else
    {
        
        issueInfoCom.searchEndID = [NSNumber numberWithInt:-1];
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
//        if (self.feedtableview.dataArr.count > 1)
//        {
//            issueInfoCom.searchStartID = ((Issueinfo *)[self.feedtableview.dataArr objectAtIndex:1]).id;
//        }
    }
    
    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:feedtableview.pageSize];
    
    if(!ismyself)
    {
        issueInfoCom.userUID = account.useruid;
    }
    [(IssueInfoComServerProxy *)self.serverProxy getIssueList:issueInfoCom];
}*/


-(void)doRequest:(BOOL)isMore

{
    if (self.loading) {
        return;
    }
    //    _isSearchingMore = isMore;
    self.loading = YES;
    
    if(!self.serverProxy)
    {
        self.serverProxy = [[[IssueInfoComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    
    if (isMore) 
    {
        issueInfoCom.searchEndID = self.feedtableview.endId;
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
    }
    else
    {
        
        issueInfoCom.searchEndID = [NSNumber numberWithInt:-1];
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
    }
    
    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:feedtableview.pageSize];
    
    if(!ismyself)
    {
        issueInfoCom.userUID = account.useruid;
    }
    [(IssueInfoComServerProxy *)self.serverProxy getProfileThread:issueInfoCom];
}

/*-(void)doRequestGetAccountProfile
{
//    if (_isProfileRetrieving)
//    {
//        return;
//    }
//    _isProfileRetrieving = YES;
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if(!self.profileServerProxy)
    {
        self.profileServerProxy = [[[IssueInfoComServerProxy alloc] init] autorelease];
        self.profileServerProxy.delegate = self;
    }

    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    if(!ismyself)
    {
       issueInfoCom.userUID = account.useruid; 
    }
    [self.profileServerProxy getAccountProfile:issueInfoCom];
}*/

-(void)doRequestGetAccountProfile
{
    //    if (_isProfileRetrieving)
    //    {
    //        return;
    //    }
    //    _isProfileRetrieving = YES;
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if(!self.profileServerProxy)
    {
        self.profileServerProxy = [[[IssueInfoComServerProxy alloc] init] autorelease];
        self.profileServerProxy.delegate = self;
    }
    
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    if(!ismyself)
    {
        issueInfoCom.userUID = account.useruid; 
    }
    [self.profileServerProxy getAccountProfile:issueInfoCom];
}


#pragma init control data
//-(BOOL)isTheOwner
//{
//    if (![GlobalData sharedInstance].myAccount) {
//        return NO;
//    }
//    if([account.useruid isEqualToNumber:[GlobalData sharedInstance].myAccount.account.useruid])
//        return YES;
//    else
//        return NO;
//}

-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
    self.view = view;
    
    //upper button
    UIImage *galleryImage = [[FloggerUIFactory uiFactory] createImage:SNS_TOPIC_PRESSED];
    UIImage *biographyImage = [[FloggerUIFactory uiFactory] createImage:SNS_USERS_PRESSED];
    
    UIButton *galleryBtn = [[FloggerUIFactory uiFactory] createButton:galleryImage];
//    UIButton *galleryBtn = [[FloggerUIFactory uiFactory] createHeadButton:galleryImage withSelImage:nil];
    
    galleryBtn.frame = CGRectMake(5, 9, galleryImage.size.width, galleryImage.size.height);
    [galleryBtn setTitle:NSLocalizedString(@"Gallery", @"Gallery") forState:UIControlStateNormal];
    galleryBtn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleFont];
    UIFont *famFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    galleryBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    //    famFont = [self createMiddleFont];
    //    [famFont ]
    galleryBtn.titleLabel.font = famFont;
    galleryBtn.tag = 0;
    [galleryBtn addTarget:self action:@selector(btnpressed:) forControlEvents:UIControlEventTouchUpInside];
    //    galleryBtn.tag = ktag
    
    UIButton *biographyBtn = [[FloggerUIFactory uiFactory] createButton:biographyImage];
//    UIButton *biographyBtn = [[FloggerUIFactory uiFactory] createHeadButton:biographyImage withSelImage:nil];
    biographyBtn.frame = CGRectMake(galleryBtn.frame.origin.x + galleryBtn.frame.size.width, 9, biographyImage.size.width, biographyImage.size.height);
    [biographyBtn setTitle:NSLocalizedString(@"Biography", @"Biography") forState:UIControlStateNormal];
//    biographyBtn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleFont];
    biographyBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    //    famFont = [self createMiddleFont];
    //    [famFont ]
    biographyBtn.titleLabel.font = famFont;
    biographyBtn.tag = 1;
    [biographyBtn addTarget:self action:@selector(btnpressed:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:galleryBtn];
//    [self.view addSubview:biographyBtn];
    
    [self setGalleryButton:galleryBtn];
    [self setBiograButton:biographyBtn];
}

-(void)initAccountComValue
{
    
    [self.galleryButton setTitle:[NSString stringWithFormat:@"Gallery(%d)",account.gallerycount.intValue] forState:UIControlStateNormal];
    
    
}
-(void)rightAction:(id)sender
{
//    self.ismyself = [self isTheOwner];
    if (![GlobalUtils checkIsLogin]) {
        [super rightAction:sender];
        return;
    }
    if (self.isFromProfile) {
        SettingViewController *settingControl = [[[SettingViewController alloc] init] autorelease];
        [self.navigationController pushViewController:settingControl animated:YES];
    } else {
        BiographyViewController *biographyControl = [[[BiographyViewController alloc] init] autorelease];
        biographyControl.account = self.account;
        biographyControl.ismyself = self.ismyself;
        [self.navigationController pushViewController:biographyControl animated:YES];
    }
}

-(void) leftAction:(id)sender
{
    if (self.ismyself) {
        BiographyViewController *biographyControl = [[[BiographyViewController alloc] init] autorelease];
        biographyControl.account = self.account;
        biographyControl.ismyself = self.ismyself;
        [self.navigationController pushViewController:biographyControl animated:YES];
    }
}

-(BOOL) checkIsShowHelpView
{
    self.helpImageURL = SNS_INSTRUCTIONS_PROFILE;
    
    if ([GlobalUtils checkIsFirstShowHelpView:self.helpImageURL] && [GlobalUtils checkIsOwner:self.account]) {
        return YES;
    } else {
        return NO; 
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.ismyself = [GlobalUtils checkIsOwner:self.account];//[self isTheOwner];
//    UIImage *settingImage = [[FloggerUIFactory uiFactory] createImage:SNS_PROFILE_SETTINGS];
//    UIImage *biographyImage = [[FloggerUIFactory uiFactory] createImage:SNS_PROFILE_BIOGRAPHY];
    
    if (self.isFromProfile) 
    {
        [self registerNotification];
        [self setRightNavigationBarWithTitle:nil image:SNS_PROFILE_SETTINGS];
        if ([GlobalUtils checkIsLogin]) {
            [self setLeftNavigationBarWithTitle:nil image:SNS_PROFILE_BIOGRAPHY];
        }
        
    } else {
        if ([GlobalUtils checkIsLogin]) {
            [self setRightNavigationBarWithTitle:nil image:SNS_PROFILE_BIOGRAPHY];
        }
    }
    
    if (self.bcTabBarController) {
        self.feedtableview = [[[ProfileTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height - 49)]autorelease];
    } else {
        self.feedtableview = [[[ProfileTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)]autorelease];
    }
    
    
    self.feedtableview.action = kCurrentAction;
    feedtableview.pageDelegate = self;
    feedtableview.refreshableTableDelegate = self;
    feedtableview.feedTableDelegate = self;
    feedtableview.handler = self;
    feedtableview.pageSize = kProfilePagesize;
    [self.view addSubview:feedtableview];
    
//    if (![GlobalUtils checkIsLogin]) {
//        UITabBar *tabBar = [[[UITabBar alloc] init] autorelease];
//        tabBar.frame = CGRectMake(0, 367, 320, 49);
//        [self.view addSubview:tabBar];
//    }
    
    [self.feedtableview.dataArr addObject:self.account];
    [self.feedtableview.tableView reloadData];
    
    //  get the profile information
//    if(![self restoreData])
//    {
//        self.loadingThread = NO;
//        [self doRequest:NO];
//    }
    
//    [self restoreData];
//    self.loadingThread = NO;
//    [self doRequest:NO];
    
        
    //[self registerForKeyboardNotifications];
    
    self.pickercontroller = [[[UIImagePickerController alloc] init]autorelease];
    self.pickercontroller.delegate = self;
    self.pickercontroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.pickercontroller.editing = YES;
    self.pickercontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.pickercontroller.allowsEditing = YES;
    
    
    [self initAccountComValue];
    
    _isFirst = YES;
}

-(BOOL) showFirstActivityView
{
    if (self.feedtableview.dataArr.count > 1 || self.firstActivityOriginalY < 0) {
        return NO;
    }
    return YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isFollowedChanged)
    {
        //        [self doRequestGetAccountProfile];
        [self doRequest:NO];
        self.isFollowedChanged = NO;
    } else {
        if (_isDataChange) {
            _isDataChange = NO;
            [self.feedtableview.tableView reloadData];
        }
        if (_isScrollTop) {
            _isScrollTop = NO; 
            if (currentDataRow == -1) {
                [self viewScrollToTop];
            } else {
                [self viewScrollToCellBottom];
            }
            
        }
    }
    if (_isFirst) {
        if (![self restoreData]) {
            self.firstActivityOriginalY = self.feedtableview.tableView.frame.origin.y + self.feedtableview.headerView.view.frame.size.height;
            [self showFirstActivity];
        }
        [self doRequest:NO];
        _isFirst = NO;
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self myRleaseResource];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark image picker

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
//
//{
//    
//    [self dismissModalViewControllerAnimated:YES];
////    UIImage* editedImage = [editingInfo objectForKey:@""]
//    
//    [self uploadImage:image];
//    
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self uploadImage:image];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
//    NSLog(@"view imagePickerControllerDidCancel");
    [picker dismissModalViewControllerAnimated:YES];
    
}

-(void)showActionSheet
{
    UIActionSheet *uias=[[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take Photo", @"Take Photo"), NSLocalizedString(@"Choose From Gallery",@"Choose From Gallery"),NSLocalizedString(@"Choose from Photo Library",@"Choose from Photo Library"),nil] autorelease];

//    [uias showFromTabBar:self.bcTabBarController.tabBar];
    [uias showInView:self.bcTabBarController.view];
}

-(void)btnpressed:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    if(btn.tag  == 0){
        AlbumViewController *nextController = [[[AlbumViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        nextController.account = self.account;
        [self.navigationController pushViewController:nextController animated:YES];
    }else if(btn.tag  == 1){
        BiographyViewController *nextController = [[[BiographyViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        nextController.account = self.account;
        nextController.ismyself = ismyself;
        
        [self.navigationController pushViewController:nextController animated:YES];
    }
}

- (void) handleAction:(NSNotification *)notification
{
    if(!notification.object)
    {
        [self.feedtableview.tableView reloadData];
    } 
    else 
    {
        if([@"photo" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            if(ismyself)
            {
                [self showActionSheet];
            }
        }else if([@"gallery" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            AlbumViewController *nextController = [[[AlbumViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            nextController.account = self.account;
            [self.navigationController pushViewController:nextController animated:YES];
        }else if([@"biography" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            BiographyViewController *nextController = [[[BiographyViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            nextController.account = self.account;
            nextController.ismyself = ismyself;
            [self.navigationController pushViewController:nextController animated:YES];
        }else if([@"follow" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            [self dofollowset:YES];
            
        }else if([@"unfollow" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            [self dofollowset:NO];
        } 
        else if([@"followers" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {//
            FriendListViewController *nextController = [[[FriendListViewController alloc] init] autorelease];
            nextController.type = FriendListView_Follows;
            nextController.account = self.account;
            [self.navigationController pushViewController:nextController animated:YES];
        }else if([@"following" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            FriendListViewController *nextController = [[[FriendListViewController alloc] init] autorelease];
            nextController.type = FriendListView_Following;
            nextController.account = self.account;
            [self.navigationController pushViewController:nextController animated:YES];
        } else if([@"updataStatus" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            [self uploadStatus:[notification.object objectForKey:@"status"]];
        }

    }
}

-(void) applicationWillResign:(NSNotification *)notification
{
    [self saveDataToFile];
}

-(void) saveDataToFile
{
    if (![GlobalUtils checkIsOwner:self.account]) {
        return;
    }
    NSString *dataKey = [NSString stringWithFormat:@"%@%lld",kDataCacheProfileData,[self.account.useruid longLongValue]];
    if([self.feedtableview.dataArr count] < 1)
    {
        [[DataCache sharedInstance] removeDataForKey:dataKey];
        return;
    }
    NSMutableDictionary *data = [[[NSMutableDictionary alloc]init]autorelease];
    //MyAccount *account = [self.feedtableview.dataArr objectAtIndex:0];
    
    IssueInfoCom *com = [[[IssueInfoCom alloc] init] autorelease];
    com.account = [self.feedtableview.dataArr objectAtIndex:0];
    
    NSMutableArray* issueInfoList = [NSMutableArray arrayWithArray:self.feedtableview.dataArr];
    [issueInfoList removeObjectAtIndex:0];
    
    com.myIssueInfoList = issueInfoList;
    [data setObject:com.dataDict forKey:kSavedDataMainData];
    [data setObject:[NSNumber numberWithBool:self.feedtableview.hasMore] forKey:kSavedDataHasMore];
    
    double currentSec = [self.feedtableview.lastUpdateDate timeIntervalSince1970];
    [data setObject:[NSNumber numberWithDouble:currentSec] forKey:kSavedDataLastUpdateTime];

    
    NSIndexPath* indexPath = [self.feedtableview.tableView indexPathForRowAtPoint:[self.feedtableview.tableView contentOffset]];
    [data setObject:[NSNumber numberWithDouble:indexPath.row] forKey:kSavedDataCurrentRow];
    
    NSString *sData = [data JSONRepresentation];
    NSData* pureData = [sData dataUsingEncoding:NSUTF8StringEncoding];
    [[DataCache sharedInstance]storeData:pureData forKey:dataKey Category:kDataCacheTempDataCategory];
}
-(BOOL) restoreData
{
    NSString *dataKey = [NSString stringWithFormat:@"%@%lld",kDataCacheProfileData,[self.account.useruid longLongValue]];
    NSData* pureData = [[DataCache sharedInstance]dataFromKey:dataKey Category:kDataCacheTempDataCategory];
    if(pureData)
    {
        NSString *sData = [[[NSString alloc]initWithData:pureData encoding:NSUTF8StringEncoding] autorelease];
        //NSMutableDictionary *data = [sData JSONValue];
        IssueInfoCom *com = [[[IssueInfoCom alloc]init]autorelease];
        NSMutableDictionary *data = [sData JSONValue];
        com.dataDict = [data objectForKey:kSavedDataMainData];

        NSMutableArray* issueInfoList = [[[NSMutableArray alloc]init]autorelease]; 
        [issueInfoList addObject:com.account];
        [issueInfoList addObjectsFromArray:com.myIssueInfoList];
        self.feedtableview.dataArr = issueInfoList; //com.myIssueInfoList;
        self.feedtableview.hasMore = [[data objectForKey:kSavedDataHasMore] boolValue];
//        self.feedtableview.lastUpdateDate = [data objectForKey:kSavedDataLastUpdateTime];
        self.feedtableview.lastUpdateDate =  [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:kSavedDataLastUpdateTime]doubleValue]];
        
        [self.feedtableview.tableView reloadData];

//        if ([[data objectForKey:kSavedDataCurrentRow]intValue] < [self.feedtableview.dataArr count]) {
//            [self.feedtableview.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[data objectForKey:kSavedDataCurrentRow]intValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        }
        return YES;
    }
    return NO;
}

-(void) dataChangeAction : (NSNotification *) notification
{
//    if (![GlobalUtils checkIsOwner:self.account]) {
//        return;
//    } 
    if(!self.feedtableview || [self.feedtableview.dataArr count] == 0)
    {
        NSString *dataKey = [NSString stringWithFormat:@"%@%d",kDataCacheProfileData,self.account.useruid];
        [[DataCache sharedInstance]removeDataForKey:dataKey Category:kDataCacheTempDataCategory]; 
        return;
    }  
    NSMutableDictionary *data = (NSMutableDictionary *) notification.object;
    if ([kNotificationPostAction isEqualToString:[data objectForKey:kNotificationAction]]) {
//        return;
        if (![GlobalUtils checkIsOwner:self.account]) {
            return;
        } 
        //gallery count
        MyAccount *respondAccount = [self.feedtableview.dataArr objectAtIndex:0];
        
//        Issueinfo *issueInfo = [data objectForKey:kNotificationInfoIssueThread];
        //from notificaton to tranIssueInfo
        Issueinfo *notificationIssueInfo = [data objectForKey:kNotificationInfoIssueThread];
        Issueinfo *tranIssueInfo = [[[MyIssueInfo alloc] init] autorelease];
        tranIssueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:notificationIssueInfo.dataDict];  
        

        
//        [self.feedtableview.dataArr insertObject:tranIssueInfo atIndex:1];
        //test start
        if(!tranIssueInfo.id)
        {
            if ([tranIssueInfo.issuecategory intValue] != 0) {
                respondAccount.gallerycount = [NSNumber numberWithInt:([respondAccount.gallerycount intValue] + 1)];
            }
            [self.feedtableview.dataArr insertObject:tranIssueInfo atIndex:1];
            
        } else {
            NSString *transLocalID =  [tranIssueInfo.dataDict objectForKey:kLocalIssueID];
            BOOL found = NO;
            for (int i = 0; i < [self.feedtableview.dataArr count]; i++) {
                Issueinfo *currentIssueInfo = [self.feedtableview.dataArr objectAtIndex:i];
                NSString * currentLocalID = [currentIssueInfo.dataDict objectForKey:kLocalIssueID];
                if ([currentLocalID isEqualToString:transLocalID]) {
                    currentIssueInfo.dataDict = tranIssueInfo.dataDict;
                    found = YES;
                    break;
                }
            }
            if(!found)
            {
                [self.feedtableview.dataArr insertObject:tranIssueInfo atIndex:1];
            }
        }
        //test end
        
        
        
        
        if (self.isViewLoaded && self.view.window) {
            [self.feedtableview.tableView reloadData];
        } else {
            _isDataChange = TRUE;            
            _isScrollTop = TRUE;
        }
        //dispatch_async(dispatch_get_main_queue(), ^{
        [self saveDataToFile];
        //});  
        return;
    } else if([kNotificationDeleteAction isEqualToString:[data objectForKey:kNotificationAction]]) {
        if (![GlobalUtils checkIsOwner:self.account]) {
            return;
        } 
        NSNumber *issueId = [data objectForKey:kNotificationInfoIssueId];
        MyAccount *respondAccount = [self.feedtableview.dataArr objectAtIndex:0];
        
        for (int i = 1; i < [self.feedtableview.dataArr count]; i++) {        
            Issueinfo *issueInfo = [self.feedtableview.dataArr objectAtIndex:i];  
            if ([issueInfo.id isEqualToNumber:issueId]) { 
                [self.feedtableview.dataArr removeObject:issueInfo];
                if ([issueInfo.issuecategory intValue] != 0) {
                    respondAccount.gallerycount = [NSNumber numberWithInt:([respondAccount.gallerycount intValue] - 1)];
                }
                _isDataChange = YES;
                break;
            }        
        }
        for (int i = 1; i < [self.feedtableview.dataArr count]; i++) {        
            Issueinfo *issueInfo = [self.feedtableview.dataArr objectAtIndex:i];  
            if ([issueInfo.parentid isEqualToNumber:issueId]) {
                issueInfo.parentid = nil;
                _isDataChange = YES;
            }        
        }
        if(_isDataChange)
        {
            if (self.isViewLoaded && self.view.window) {
                _isDataChange=NO;
                [self.feedtableview.tableView reloadData];
            } 
            [self saveDataToFile];
        }
        
    } else if ([kNotificationCommentAction isEqualToString:[data objectForKey:kNotificationAction]])
    {
//        if (![GlobalUtils checkIsOwner:self.account]) {
//            return;
//        } 
//        Issueinfo *issueInfo = [data objectForKey:kNotificationInfoIssueThread];
        //from notificaton to tranIssueInfo
        Issueinfo *notificationIssueInfo = [data objectForKey:kNotificationInfoIssueThread];
        Issueinfo *tranIssueInfo = [[[MyIssueInfo alloc] init] autorelease];
        tranIssueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:notificationIssueInfo.dataDict]; 
        
        for (int i = 1; i < [self.feedtableview.dataArr count]; i++) {
            Issueinfo *parentIssueInfo = [self.feedtableview.dataArr objectAtIndex:i];
            if ([parentIssueInfo.id isEqualToNumber:tranIssueInfo.parentid]) {
                if (!tranIssueInfo.id) {
                    NSMutableArray *cmtList = ((MyIssueInfo *)parentIssueInfo).commentList;
                    [cmtList addObject:tranIssueInfo];
                    if(cmtList.count>3)
                    {
                        [cmtList removeObjectAtIndex:0];
                    }
                    ((MyIssueInfo *)parentIssueInfo).commentList = cmtList;
                    //                NSLog(@"parentIssueInfo.commentcnt is %d",[parentIssueInfo.commentcnt intValue]);
                    parentIssueInfo.commentcnt =  [NSNumber numberWithInt:([parentIssueInfo.commentcnt intValue] + 1)];
                    currentDataRow = i;
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
//                    parentIssueInfo.commentcnt =  [NSNumber numberWithInt:([parentIssueInfo.commentcnt intValue] + 1)];
                    currentDataRow = i;
                }
                
                currentDataRow = i;
                break;
            }
        }  
        
        
        if ([GlobalUtils checkIsOwner:self.account]) {
//            NSMutableDictionary *testCopy = [NSMutableDictionary dictionaryWithDictionary:tranIssueInfo.dataDict];
//            Issueinfo *newIssueInfo = [[[Issueinfo alloc]init]autorelease];
//            newIssueInfo.dataDict = testCopy;
            
            if ([tranIssueInfo.issuecategory intValue] != 3) {
//                [self.feedtableview.dataArr insertObject:tranIssueInfo atIndex:1];
                MyAccount *respondAccount = [self.feedtableview.dataArr objectAtIndex:0];
                respondAccount.gallerycount = [NSNumber numberWithInt:([respondAccount.gallerycount intValue] + 1)];
            }
        }
  
        if (self.isViewLoaded && self.view.window) {
            [self.feedtableview.tableView reloadData];
            [self viewScrollToCellBottom];
        } else {
            _isDataChange = TRUE; 
            if ([GlobalUtils checkIsOwner:self.account]) {
                if ([tranIssueInfo.issuecategory intValue] != 3)
                    _isScrollTop = TRUE;
            }
        }
        [self saveDataToFile];
        return;
        
    }else if ([kNotificationLikeAction isEqualToString:[data objectForKey:kNotificationAction]])
    {
        NSNumber *issueId = [data objectForKey:kNotificationInfoIssueId];
        for (int i = 1; i < [self.feedtableview.dataArr count]; i++) {
            Issueinfo *issueInfo = [self.feedtableview.dataArr objectAtIndex:i];
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
                    [self.feedtableview.tableView reloadData];
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
        for (int i = 1; i < [self.feedtableview.dataArr count]; i++) {
            Issueinfo *issueInfo = [self.feedtableview.dataArr objectAtIndex:i];
             MyIssueInfo * myIssueInfor = (MyIssueInfo *)issueInfo;
            if ([issueInfo.id isEqualToNumber:issueId]) {
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
                
                issueInfo.likecnt = [NSNumber numberWithInt:issueInfo.likecnt.intValue - 1];
                ((MyIssueInfo *)issueInfo).liked = [NSNumber numberWithBool:NO];
                
                if (self.isViewLoaded && self.view.window) {
                    [self.feedtableview.tableView reloadData];
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

-(void)registerNotificationNew
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:kShapeWeb object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:kCurrentAction object:nil];
}
-(void)unregisterNotificationNew
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShapeWeb object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCurrentAction object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotificationNew];
    if ([GlobalUtils checkIsOwner:self.account]) {
        [self saveDataToFile];
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self registerNotificationNew];
    //title view
    if (self.account.username) {
        [self setNavigationTitleView:[NSString stringWithFormat:@"@%@",self.account.username]];
    }
    
}

-(void) viewScrollToTop
{
    if (self.feedtableview && [self.feedtableview.dataArr count] > 0) {
            [self.feedtableview.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

-(void) viewScrollToCellBottom 
{
    if (self.feedtableview && [self.feedtableview.dataArr count] > 0 && currentDataRow > -1) {
        [self.feedtableview.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentDataRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        currentDataRow = -1;
    }
}


#pragma keyboard

-(void)doRequestFinished:(BaseServerProxy *)serverproxy
{
    IssueInfoCom *response = (IssueInfoCom *)serverproxy.response;
    if (response.myIssueInfoList && response.myIssueInfoList.count > 0)
    {
        if ([response.searchEndID longLongValue] == -1) {
            [feedtableview.dataArr removeAllObjects];
            [feedtableview.dataArr addObject:self.account];
        }        
        [feedtableview.dataArr addObjectsFromArray:response.myIssueInfoList];
    } else {
        if ([response.searchEndID longLongValue] == -1)
        {
            [feedtableview.dataArr removeAllObjects];
            [feedtableview.dataArr addObject:self.account];
        }
    }  
    if ([response.searchStartID longLongValue] == -1) 
    {
        [feedtableview checkMore:response.myIssueInfoList];
    }
    [self saveDataToFile];
    [feedtableview.tableView reloadData];
}

- (void)networkFinished:(BaseServerProxy *)serverproxy
{
    [super networkFinished:serverproxy];
    feedtableview.lastUpdateDate = [NSDate date];
    if(serverproxy == self.profileServerProxy)
    {
        _isProfileRetrieving  = NO;
        self.loadingThread = YES;
        return;
    }
    if(serverproxy == self.accountStatusProxy)
    {
        _isUpdateingStatus = NO;
        return;
    }
    if(serverproxy == self.accountImageProxy)
    {
        _isUpdateingImage = NO;
        return;
    }
    if(serverproxy == self.followComServerProxy)
    {
        _isFollowing  = NO;
    }

    
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    
    self.feedtableview.isLoadingMore = NO;
    
    if(serverproxy == self.profileServerProxy)
    {
        IssueInfoCom *response = (IssueInfoCom *)serverproxy.response;
        self.account = response.account;
        [self initAccountComValue];
//        [feedtableview.dataArr removeAllObjects];
//        [feedtableview.dataArr addObject:self.account];
//        [self.feedtableview.tableView reloadData];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.loadingThread = YES; 
//        });
       
        [self doRequest:NO];
        return;
    }
    if(serverproxy == self.serverProxy)
    {
//        if(!_isSearchingMore)
//        {
//            [self doRequestFinished:serverproxy];
//        } else {
//            IssueInfoCom *response = (IssueInfoCom *)serverproxy.response;
//            [feedtableview.dataArr addObjectsFromArray:response.myIssueInfoList];
//            [feedtableview.tableView reloadData];  
//        }
        IssueInfoCom *response = (IssueInfoCom *)serverproxy.response;
        
        if (([response.searchEndID longLongValue] == -1) && ([response.searchStartID longLongValue] == -1)) {
            self.account = response.account;
            //        self setNavigationTitleView:self
//            NSLog(@"=========self.accout.username  is %@",self.account.username);
            [self setNavigationTitleView:[NSString stringWithFormat:@"@%@",self.account.username]];
        }
        [self doRequestFinished:serverproxy];
        return;
    }
    if(serverproxy == self.accountStatusProxy)
    {
        AccountCom* acom = (AccountCom *)serverproxy.response;
        [GlobalData sharedInstance].myAccount.account.status = acom.status;
        self.account.status = acom.status;
        [self.feedtableview.tableView reloadData];
        [[GlobalData sharedInstance]saveLoginAccount];
        return;
    }
    if(serverproxy == self.accountImageProxy)
    {
        AccountCom *acom = (AccountCom *)serverproxy.response;
        {
            [[SDImageCache sharedImageCache] removeImageForKey:acom.imageUrl];
//            NSLog(@"account imageurl is %@",acom.imageUrl);
            [GlobalData sharedInstance].myAccount.account.imageurl = acom.imageUrl;            
            [self.feedtableview.dataArr removeObjectAtIndex:0];
            [self.feedtableview.dataArr insertObject:[GlobalData sharedInstance].myAccount.account atIndex:0];
            //add
            self.account = [GlobalData sharedInstance].myAccount.account;
        }
        [self.feedtableview.tableView reloadData];
        [[GlobalData sharedInstance]saveLoginAccount];
        return;
    }
    if(serverproxy == self.followComServerProxy)
    {
        if(_isFollow){
            NSInteger v = [[GlobalData sharedInstance].myAccount.account.followerscount intValue];
            v++;
            [GlobalData sharedInstance].myAccount.account.friendscount = [NSNumber numberWithInt:v];
            self.account.followerscount = [NSNumber numberWithInt: [self.account.followerscount intValue] + 1];
            self.account.followed = [NSNumber numberWithBool:YES];
        }else{
            NSInteger v = [[GlobalData sharedInstance].myAccount.account.followerscount intValue];
            v--;
            [GlobalData sharedInstance].myAccount.account.friendscount = [NSNumber numberWithInt:v];
            self.account.followerscount = [NSNumber numberWithInt: [self.account.followerscount intValue] - 1];
            self.account.followed = [NSNumber numberWithBool:NO];
        }
        [[GlobalData sharedInstance]saveLoginAccount];
        [self.feedtableview.tableView reloadData];
        [self notifyFollowingChanged];
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    printf("User Pressed Button %d\n", buttonIndex + 1);
    switch(buttonIndex)
    {
        case 0:{
            FloggerCameraControl *carmeraControl = [[[FloggerCameraControl alloc] init] autorelease];
            carmeraControl.delegate = self;
//            BCTabBarController *bc = self.bcTabBarController;
            [self.bcTabBarController presentModalViewController:carmeraControl animated:NO];
        }
            break;
        case 1:
        {
            AlbumViewController *albumView = [[[AlbumViewController alloc] init] autorelease];
            albumView.isSelectionMode = YES;
            albumView.selectionDelegate = self;
//            [self presentModalViewController:albumView animated:YES];
            [self.navigationController pushViewController:albumView animated:YES];
//            AlbumViewController.isSelectionMode = YES;
//            AlbumViewController.selectionDelegate = self;
//            selectionDelegate为
//            @protocol AlbumSelectionDelegate <NSObject>
//            -(void)didSelectedAlbumn:(Albuminfo *)albuminfo;
//            @end
//            [self uploadImage:[info objectForKey:@"image"]];
        }
            break;
        case 2:
            [self.bcTabBarController presentModalViewController:self.pickercontroller animated:YES];
            break;
        default:
            break;
    }

}

-(void)didSelectedAlbumn:(Albuminfo *)albuminfo
{
//    NSLog(@"select album");
    [self.navigationController popViewControllerAnimated:YES];
    UIImage *image = [[DataCache sharedInstance] imageFromKey:albuminfo.thumbnailurl];
    if (image) {
        [self uploadImage:image];
    }
    
//    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma poupmenu
-(void)PoupMenuCommand:(NSInteger)tag
{
    switch(tag)
    {
        case kPhotoLibrary:
            [self presentModalViewController:self.pickercontroller animated:YES];
            break;
        case kTakePhoto:
        {
            FloggerCameraControl *carmeraControl = [[[FloggerCameraControl alloc] init] autorelease];
            carmeraControl.delegate = self;
            [self presentModalViewController:carmeraControl animated:NO];
        }
            break;
    }
}


#pragma mark - camera
-(void)floggerCameraControl:(FloggerCameraControl *)cameraControl didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [cameraControl dismissModalViewControllerAnimated:NO];
    [self uploadImage:[info objectForKey:@"image"]];
}
-(void)floggerCameraControlDidCancelledPickingMedia:(FloggerCameraControl *)cameraControl
{
    [cameraControl dismissModalViewControllerAnimated:YES];
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    [self doRequest:NO];
}


-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    //[super pageTableViewRequestLoadingMore:tableView];
    //[self getLikeList:YES];
//    NSLog(@"profile pageTableViewRequestLoadingMore");
    [self doRequest:YES];
}


-(void)go2Viewer:(Issueinfo *)issueInfo
{
    FeedViewerViewController *vc = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.issueInfo = [[[MyIssueInfo alloc]init]autorelease];// issueInfo;
    vc.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:issueInfo.dataDict];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)go2Share:(Issueinfo *)issueInfo
{
    ShareFeedViewController *vc = [[[ShareFeedViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.issueList = [[[NSMutableArray alloc] initWithObjects:issueInfo, nil] autorelease];
    vc.shareType = SHAREISSUE;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)go2Profile:(MyAccount *)acc
{
    ProfileViewController *vc = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.account = acc;
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
    MyAccount *acc = [[[MyAccount alloc] init] autorelease];
    acc.useruid = issueinfo.useruid;
    account.username = issueinfo.username;
    [self go2Profile:acc];
}


- (void) myRleaseResource
{
    self.pickercontroller = nil;
    self.feedtableview.pageDelegate = nil;
    self.feedtableview.refreshableTableDelegate = nil;
    self.feedtableview.feedTableDelegate = nil;
    self.feedtableview    = nil;
    self.accountImageProxy.delegate = nil;
    self.accountImageProxy      = nil;
    self.accountStatusProxy.delegate = nil;
    self.accountStatusProxy =nil;
    self.followComServerProxy.delegate = nil;
    self.followComServerProxy    = nil;
    self.profileServerProxy.delegate = nil;
    self.profileServerProxy = nil;
    if ([GlobalUtils checkIsOwner:self.account]) 
    {
        [self unregisterNotification];
    }
}
-(void)dealloc
{
    
    [self myRleaseResource];
    self.account                 = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataChangeIssueInfo object:nil];
    
    [super dealloc];
    
}

-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [self.accountStatusProxy cancelAll];
    [self.accountImageProxy cancelAll];
    [self.followComServerProxy cancelAll];
    [self.profileServerProxy cancelAll];
    _isProfileRetrieving  = NO;
    _isUpdateingStatus = NO;
    _isUpdateingImage = NO;
    _isFollowing  = NO;
    self.feedtableview.isLoadingMore = NO;

}
@end
