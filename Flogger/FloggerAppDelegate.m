//
//  FloggerAppDelegate.m
//  Flogger
//
//  Created by jwchen on 11-12-26.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "FloggerAppDelegate.h"
#import "GlobalData.h"
#import "NetworkData.h"
#import "UINavigationBar+clmobile.h"
#import "GlobalData.h"
#import "DataCache.h"
#import "FloggerStarter.h"
#import "FloggerPrefetch.h"
#import "LocationManager.h"
#import "FriendListViewController.h"

#import "AsyncTaskManager.h"

#import "PublicFeedViewController.h"
#import "FeedsViewController.h"
#import "PopularViewController.h"
#import "NotificationViewController.h"
#import "ProfileViewController.h"
#import "CameraNaviViewController.h"
#import "FloggerCameraControl.h"
#import "CommentPostViewController.h"
#import "SuggestionUserViewController.h"
#import "AccountServerProxy.h"
#import "SyncupCom.h"

#define kTabBarMenu 50

static CGSize mySize;
static BOOL loadFlag;


@implementation FloggerNavigationControllerForIos6
//for any version before 6.0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //only allow landscape
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//for 6.0+
- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end

@implementation FloggerNavigationController
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"viewDidAppear navigation nsstring %@",self.view.class);
//    NSLog(@"FloggerNavigationController frame is %@",[NSValue valueWithCGRect:self.view.frame]);
//    NSLog(@"gggggggg frame is %@",[NSValue valueWithCGRect:self.tabBarController.view.frame]);
//    
//    for (UIView *view in self.view.subviews) {
//        NSLog(@"contain view is %@",view.class);
//        NSLog(@"contain view subviews is %@",[NSValue valueWithCGRect:view.frame]);
//    }
    
    self.view.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.navigationBar.frame = CGRectMake(0, 0, 320, 44);
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"viewwillAppear navigation nsstring %@",self.view.class);
//    NSLog(@"FloggerNavigationController frame is %@",[NSValue valueWithCGRect:self.view.frame]);
//    for (UIView *view in self.view.subviews) {
//        NSLog(@"will contain view is %@",view.class);
//        NSLog(@"will contain view subviews is %@",[NSValue valueWithCGRect:view.frame]);
//    }
}

@end
@implementation FloggerTabBarController
-(UIView*)view
{
//    NSLog(@"mmmmdddd frame is %@",[NSValue valueWithCGRect:[super view ].frame]);
    return [super view];
}
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage tabBarIndex:(int) index
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [button addTarget:self action:@selector(btnTabBarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(index * 64, self.tabBar.frame.origin.y, buttonImage.size.width, buttonImage.size.height);
    button.tag = 600 + index;
    [button setBackgroundImage:highlightImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonImage  forState:UIControlStateSelected];
//    [button se]
    
    /*button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
     [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
     [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
     
     CGFloat heightDifference = buttonImage.size.height - self.rootTabBarControl.tabBar.frame.size.height;
     
     if (heightDifference < 0)
     button.center = self.rootTabBarControl.tabBar.center;
     //        button.frame = 
     else
     {
     CGPoint center = self.rootTabBarControl.tabBar.center;
     center.y = center.y - heightDifference/2.0;
     button.center = center;
     }*/
    
    [self.view addSubview:button];
}

-(void) btnTabBarClick : (id) sender
{
    UIButton *btn0 =  (UIButton *)[self.view viewWithTag:600];
    UIButton *btn1 =  (UIButton *)[self.view viewWithTag:601];
    UIButton *btn2 =  (UIButton *)[self.view viewWithTag:602];
    UIButton *btn3 =  (UIButton *)[self.view viewWithTag:603];
    UIButton *btn4 =  (UIButton *)[self.view viewWithTag:604];
    /*[btn0 setSelected:NO];
    [btn1 setSelected:NO];
    [btn2 setSelected:NO];
    [btn3 setSelected:NO];
    [btn4 setSelected:NO];*/
    [btn0 setSelected:YES];
    [btn1 setSelected:YES];
    [btn2 setSelected:YES];
    [btn3 setSelected:YES];
    [btn4 setSelected:YES];
    UIButton *btn = (UIButton *) sender;
    [btn setSelected:NO];
    
    self.selectedIndex = btn.tag - 600;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    loadFlag = NO;
    //tab bar
//    UIImage *feedImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FEED];
//    UIImage *feedImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FEED_HIGHLIGHT];
//    UIImage *iFloggerImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_IFLOGGER];
//    UIImage *iFloggerImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_IFLOGGER_HIGHLIGHT];
//    UIImage *newsImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_NEWS];
//    UIImage *newsImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_NEWS_HIGHLIGHT];
//    UIImage *popularImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_POPULAR];
//    UIImage *popularImageHighlight =  [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_POPULAR_HIGHLIGHT];
//    UIImage *profileImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_PROFILE];
//    UIImage *profileImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_PROFILE_HIGHLIGHT];
//    
//    [self addCenterButtonWithImage:feedImage highlightImage:feedImageHighlight tabBarIndex:0];
//    [self addCenterButtonWithImage:popularImage highlightImage:popularImageHighlight tabBarIndex:1];
//    [self addCenterButtonWithImage:iFloggerImage highlightImage:iFloggerImageHighlight tabBarIndex:2];
//    [self addCenterButtonWithImage:newsImage highlightImage:newsImageHighlight tabBarIndex:3];
//    [self addCenterButtonWithImage:profileImage highlightImage:profileImageHighlight tabBarIndex:4];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mySize = self.view.frame.size;
//    NSLog(@"nsstring %@",self.view.class);
//    NSLog(@"floggerTabBarController frame is %@",[NSValue valueWithCGRect:self.view.frame]);
//    for (UIView *view in self.view.subviews) {
//        NSLog(@"tab willcontain view is %@",view.class);
//        NSLog(@"tab will contain view subviews is %@",[NSValue valueWithCGRect:view.frame]);
//    }
    
    /*UIImage *feedImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FEED];
    UIImage *feedImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FEED_HIGHLIGHT];
    UIImage *iFloggerImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_IFLOGGER];
    UIImage *iFloggerImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_IFLOGGER_HIGHLIGHT];
    UIImage *newsImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_NEWS];
    UIImage *newsImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_NEWS_HIGHLIGHT];
    UIImage *popularImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_POPULAR];
    UIImage *popularImageHighlight =  [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_POPULAR_HIGHLIGHT];
    UIImage *profileImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_PROFILE];
    UIImage *profileImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_PROFILE_HIGHLIGHT];
    
    [self addCenterButtonWithImage:feedImage highlightImage:feedImageHighlight tabBarIndex:0];
    [self addCenterButtonWithImage:popularImage highlightImage:popularImageHighlight tabBarIndex:1];
    [self addCenterButtonWithImage:iFloggerImage highlightImage:iFloggerImageHighlight tabBarIndex:2];
    [self addCenterButtonWithImage:newsImage highlightImage:newsImageHighlight tabBarIndex:3];
    [self addCenterButtonWithImage:profileImage highlightImage:profileImageHighlight tabBarIndex:4];*/
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"viewDidAppear tabbar nsstring %@",self.view.class);
//    NSLog(@"floggerTabBarController frame is %@",[NSValue valueWithCGRect:self.view.frame]);
//    for (UIView *view in self.view.subviews) {
//        NSLog(@"tab did contain view is %@",view.class);
//        NSLog(@"tab did contain view subviews is %@",[NSValue valueWithCGRect:view.frame]);
//    }
    if(loadFlag)
    {
        self.view.frame = CGRectMake(0, 20, mySize.width, mySize.height);
    } else {
        self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    }
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    loadFlag = YES;
}
@end

@implementation UINavigationBar (ClNavigationBar)  
+(Class)class{
    return NSClassFromString(@"ClNavigationBar");
}

- (void)drawRect:(CGRect)rect {  
    UIImage *image = [UIImage imageNamed: SNS_TOP_BAR];  
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    [image release];
}  
@end
//@interface FloggerAppDelegate
//@property (nonatomic,retain) AccountServerProxy *accountProxy;
//@end

@implementation FloggerAppDelegate
@synthesize rootTabBarControl;

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize lastTimeControl;
@synthesize testViewControl;
@synthesize accountProxy;

-(void)clearGlobalDatas
{
    [GlobalData purgeSharedInstance];
    [NetworkData purgeSharedInstance];
    [DataCache purgeSharedInstance];
    [FloggerPrefetch purgeSharedInstance];
    [LocationManager purgeSharedInstance];
    [AsyncTaskManager purgeSharedInstance];
}

-(void)clearNavControllers
{
    
}

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    
    [self clearGlobalDatas];
    [self clearNavControllers];
    self.lastTimeControl = nil;
    self.testViewControl = nil;
    self.accountProxy = nil;
    [super dealloc];
}

//application notification
//- (void)applicationDidFinishLaunching:(UIApplication *)app {
//    // other setup tasks here....
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSMutableString *deviceID = [NSMutableString string];
    // iterate through the bytes and convert to hex
    unsigned char *ptr = (unsigned char *)[deviceToken bytes];
    for (NSInteger i=0; i < 32; ++i) {
        [deviceID appendString:[NSString stringWithFormat:@"%02x", ptr[i]]];
    }
    NSLog(@"My token is: %@", deviceID);
//    [DataCache sharedInstance] s
//    NSUserDefaults *userDefault = [[[NSUserDefaults alloc] init] autorelease];
    [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:kDeviceToken];
    
//    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Test" message:deviceID delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] autorelease];
//    [alertView show];
    
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{ 
    NSLog(@"Failed to get token, error: %@", error);
//    [GlobalUtils ]
//    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Test" message:@"Failed to get token" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] autorelease];
//    [alertView show];
}


-(void)showPublicFeed
{
    PublicFeedViewController *pivc = [[[PublicFeedViewController alloc] init] autorelease];
//    UINavigationController *publicNav = [[[UINavigationController alloc] initWithRootViewController:pivc] autorelease];
    UINavigationController *publicNav = nil;
    if ([GlobalUtils checkIOS_6]) {
        publicNav = [[[FloggerNavigationControllerForIos6 alloc] initWithRootViewController:pivc] autorelease];
//        publicNav = [[[UINavigationController alloc] initWithRootViewController:pivc] autorelease];
    } else
    {
        publicNav = [[[UINavigationController alloc] initWithRootViewController:pivc] autorelease];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    self.window.rootViewController = publicNav;
}

-(void) showFirstRegisterScreen : (NSMutableArray *) contactList
{
    UINavigationController *firstScreenNav;
    if (contactList.count > 0) {
        FriendListViewController *friendListViewControl = [[[FriendListViewController alloc] init] autorelease];
        friendListViewControl.type = FriendListView_FirstScreen;
        friendListViewControl.accountList = contactList;    
        firstScreenNav = [[[UINavigationController alloc] initWithRootViewController:friendListViewControl] autorelease];
    } else
    {
        SuggestionUserViewController *suggestViewControl = [[[SuggestionUserViewController alloc] init] autorelease];
        suggestViewControl.isFirstScreen = YES;
        firstScreenNav = [[[UINavigationController alloc] initWithRootViewController:suggestViewControl] autorelease];
    }

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.window.rootViewController = firstScreenNav;
}


-(void)showMain
{
    if ([GlobalData sharedInstance].myAccount) {        
        [self showTabViewControl];
    }
    else {
        [self showPublicFeed];
    }
}
//-(void) btnTabBarClick : (id) sender
//{
//    UIButton *btn0 =  (UIButton *)[self.rootTabBarControl.view viewWithTag:600];
//    UIButton *btn1 =  (UIButton *)[self.rootTabBarControl.view viewWithTag:601];
//    UIButton *btn2 =  (UIButton *)[self.rootTabBarControl.view viewWithTag:602];
//    UIButton *btn3 =  (UIButton *)[self.rootTabBarControl.view viewWithTag:603];
//    UIButton *btn4 =  (UIButton *)[self.rootTabBarControl.view viewWithTag:604];
//    [btn0 setSelected:NO];
//    [btn1 setSelected:NO];
//    [btn2 setSelected:NO];
//    [btn3 setSelected:NO];
//    [btn4 setSelected:NO];
//    
//    UIButton *btn = (UIButton *) sender;
//    [btn setSelected:YES];
//    
//    self.selectedIndex = btn.tag - 600;
//}

//-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage tabBarIndex:(int) index
//{
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    [button addTarget:self action:@selector(btnTabBarClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    button.frame = CGRectMake(index * 64, self.rootTabBarControl.tabBar.frame.origin.y, buttonImage.size.width, buttonImage.size.height);
//    button.tag = 600 + index;
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
//    [button setBackgroundImage:highlightImage forState:UIControlStateSelected];
//    
//    /*button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
//    
//    CGFloat heightDifference = buttonImage.size.height - self.rootTabBarControl.tabBar.frame.size.height;
//    
//    if (heightDifference < 0)
//        button.center = self.rootTabBarControl.tabBar.center;
////        button.frame = 
//    else
//    {
//        CGPoint center = self.rootTabBarControl.tabBar.center;
//        center.y = center.y - heightDifference/2.0;
//        button.center = center;
//    }*/
//    
//    [self.rootTabBarControl.view addSubview:button];
//}

-(void) showTabViewControl
{
    loadFlag = NO;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //FloggerTabBarController *tabView = [[[FloggerTabBarController alloc] init] autorelease];
    
    FeedsViewController *feedsViewControl = [[[FeedsViewController alloc] init] autorelease];
    /*UIImage *feedImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FEED];
    UIImage *feedImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FEED_HIGHLIGHT];
    UIImage *iFloggerImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_IFLOGGER];
    UIImage *iFloggerImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_IFLOGGER_HIGHLIGHT];
    UIImage *newsImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_NEWS];
    UIImage *newsImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_NEWS_HIGHLIGHT];
    UIImage *popularImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_POPULAR];
    UIImage *popularImageHighlight =  [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_POPULAR_HIGHLIGHT];
    UIImage *profileImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_PROFILE];
    UIImage *profileImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_PROFILE_HIGHLIGHT];
    */
    UINavigationController *feedNav = [[[FloggerNavigationController alloc] initWithRootViewController:feedsViewControl] autorelease];
    feedNav.delegate = self;
    //[feedNav.tabBarItem setFinishedSelectedImage:feedImageHighlight withFinishedUnselectedImage:feedImage];
    
    
    PopularViewController *popularViewControl = [[[PopularViewController alloc] init] autorelease];
    UINavigationController *popularNav = [[[FloggerNavigationController alloc] initWithRootViewController:popularViewControl] autorelease];
    popularNav.delegate = self;
    //[popularNav.tabBarItem setFinishedSelectedImage:popularImageHighlight withFinishedUnselectedImage:popularImage];
    
    UIViewController *cameraControl = [[[UIViewController alloc] init] autorelease];
    //[cameraControl.tabBarItem setFinishedSelectedImage:iFloggerImageHighlight withFinishedUnselectedImage:iFloggerImage];
    cameraControl.tabBarItem.tag = 1;
    
    NotificationViewController *notificationViewControl = [[[NotificationViewController alloc] init] autorelease];
    UINavigationController *notificationNav = [[[FloggerNavigationController alloc] initWithRootViewController:notificationViewControl] autorelease];
    notificationNav.delegate = self;    
    //[notificationNav.tabBarItem setFinishedSelectedImage:newsImageHighlight withFinishedUnselectedImage:newsImage];
    
    ProfileViewController *profileViewControl = [[[ProfileViewController alloc] init] autorelease];
    profileViewControl.account = [GlobalData sharedInstance].myAccount.account;
    profileViewControl.isFromProfile = YES;
    UINavigationController *profileNav = [[[FloggerNavigationController alloc] initWithRootViewController:profileViewControl] autorelease];
    profileNav.tabBarItem.tag  = 2;
    profileNav.delegate = self;    
    //[profileNav.tabBarItem setFinishedSelectedImage:profileImageHighlight withFinishedUnselectedImage:profileImage];
    BCTabBarController *tabView = [[[BCTabBarController alloc] init]autorelease];
	//self.tabBarController = [[BCTabBarController alloc] init];
	tabView.viewControllers = [NSArray arrayWithObjects:
                               feedNav,
                               popularNav,
                               [[[UIViewController alloc] init] autorelease],
                               notificationNav,
                               profileNav,
                               nil];

    tabView.itemImages = [[[NSArray alloc]initWithObjects:SNS_NAVIGATION_FEED,SNS_NAVIGATION_FEED_HIGHLIGHT,SNS_NAVIGATION_POPULAR,SNS_NAVIGATION_POPULAR_HIGHLIGHT,SNS_NAVIGATION_IFLOGGER,SNS_NAVIGATION_IFLOGGER_HIGHLIGHT,SNS_NAVIGATION_NEWS,SNS_NAVIGATION_NEWS_HIGHLIGHT,SNS_NAVIGATION_PROFILE,SNS_NAVIGATION_PROFILE_HIGHLIGHT, nil] autorelease];
    /*tabView.viewControllers = [[NSArray alloc] initWithObjects:feedNav,popularNav,cameraControl,notificationNav,profileNav,nil];*/
    tabView.delegate = self;

    tabView.view.backgroundColor = [[FloggerUIFactory uiFactory] createBackgroundColor];
    tabView.wantsFullScreenLayout = NO;

[[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([GlobalUtils checkIOS_6]) {
        self.window.rootViewController = tabView;
//        [self.window addSubview:tabView.view];
    } else
    {
        self.window.rootViewController = tabView;
    }
    
    //tab bar
//    UIImage *feedImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FEED];
//    UIImage *feedImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FEED_HIGHLIGHT];
//    UIImage *iFloggerImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_IFLOGGER];
//    UIImage *iFloggerImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_IFLOGGER_HIGHLIGHT];
//    UIImage *newsImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_NEWS];
//    UIImage *newsImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_NEWS_HIGHLIGHT];
//    UIImage *popularImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_POPULAR];
//    UIImage *popularImageHighlight =  [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_POPULAR_HIGHLIGHT];
//    UIImage *profileImage = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_PROFILE];
//    UIImage *profileImageHighlight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_PROFILE_HIGHLIGHT];
//   
//    [self addCenterButtonWithImage:feedImage highlightImage:feedImageHighlight tabBarIndex:0];
//    [self addCenterButtonWithImage:popularImage highlightImage:popularImageHighlight tabBarIndex:1];
//    [self addCenterButtonWithImage:iFloggerImage highlightImage:iFloggerImageHighlight tabBarIndex:2];
//    [self addCenterButtonWithImage:newsImage highlightImage:newsImageHighlight tabBarIndex:3];
//    [self addCenterButtonWithImage:profileImage highlightImage:profileImageHighlight tabBarIndex:4];
    [self setRootTabBarControl:tabView];
}

-(void)removeTabBarMenu
{
//    [self.testViewControl dismissModalViewControllerAnimated:NO]; 
    if ([self.rootTabBarControl.view viewWithTag:kTabBarMenu]) {
        [UIView beginAnimations:nil context:nil];
        [self.rootTabBarControl.view viewWithTag:kTabBarMenu].alpha = 0.0;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.25];
        [UIView commitAnimations];
//        [UIView setAnimationDuration:0.];
         [[self.rootTabBarControl.view viewWithTag:kTabBarMenu] removeFromSuperview];
       
    }
   
}

-(void) cameraBtn:(id)sender
{    
    [self removeTabBarMenu];
    UIButton *btn = (UIButton *) sender;
    int buttonIndex = btn.tag;
    if (buttonIndex == 0) {
        //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        CommentPostViewController *vc = [[[CommentPostViewController alloc] init] autorelease];
        vc.composeMode = TWEETMODE;
        CameraNaviViewController *composeNav = [[[CameraNaviViewController alloc] initWithRootViewController:vc] autorelease];
        [self.rootTabBarControl presentModalViewController:composeNav animated:YES];
    } else if (buttonIndex == 1){
        FloggerCameraControl *cameraControl = [[[FloggerCameraControl alloc] init] autorelease];
//        cameraControl.delegate = self;
        cameraControl.statusMode = PHOTOMODE;
        CameraNaviViewController *cameraNav = [[[CameraNaviViewController alloc] initWithRootViewController:cameraControl] autorelease];
        [self.rootTabBarControl presentModalViewController:cameraNav animated:YES];
    } else if (buttonIndex == 2){
        FloggerCameraControl *cameraControl = [[[FloggerCameraControl alloc] init] autorelease];
        cameraControl.statusMode = VIDEOMODE;
        CameraNaviViewController *cameraNav = [[[CameraNaviViewController alloc] initWithRootViewController:cameraControl] autorelease];
        [self.rootTabBarControl presentModalViewController:cameraNav animated:YES];
    }
    
}

- (BOOL)bcTabBarController:(BCTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isMemberOfClass:[UIViewController class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadCell object:nil];
//    NSLog("select index is %d",tabBarController.selectedIndex);
//    if (tabBarController.selectedIndex == 2) {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Write it!",@"Shoot it!",@"Film it!",nil];
//        [actionSheet showInView:self.window.rootViewController.view];
//        UIGraphicsBeginImageContext(self.window.frame.size);
////        [UIScreen screens]
//        //self.window.layer.contentsScale = 2;
//        [self.window.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        btn.frame = CGRectMake(0, 30, 50, 50);
//        [btn addTarget:self action:@selector(testBtn:) forControlEvents:UIControlEventTouchUpInside];

        
        
//        UIViewController *controllerForBlackTransparentView=[[[UIViewController alloc] init] autorelease];
        UIView *viewForProfanity = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
        viewForProfanity.tag = kTabBarMenu;

//        [viewForProfanity addSubview:btn];
//        viewForProfanity
//        [controllerForBlackTransparentView setView:viewForProfanity];
        
        UIImage *backgroundImage = [[FloggerUIFactory uiFactory] createImage:SNS_POPUPMENU_BACKGROUND];
        UIImage *writeIt = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_WRITEIT];
        UIImage *writeItHight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_WRITEIT_HIGHLIGHT];
        UIImage *shootIt = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_SHOOTIT];
        UIImage *shootItHight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_SHOOTIT_HIGHLIGHT];
        UIImage *filmIt = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FILMIT];
        UIImage *filmItHight = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FILMIT_HIGHLIGHT];
        UIImage *foloPress = [[FloggerUIFactory uiFactory] createImage:SNS_NAVIGATION_FOLO_PRESS];
        
        UIColor *selectColor = [[FloggerUIFactory uiFactory] createSelectFontColor];
        UIColor *normalColor = [UIColor whiteColor];
        UIEdgeInsets titleEdgeInsets = UIEdgeInsetsMake(writeIt.size.height - 13, 0, 0, 0);
        CGFloat cameraHeigtht = 304;
        
        
        UIButton *writeBtn = [[FloggerUIFactory uiFactory] createButton:writeIt];
        [writeBtn setBackgroundImage:writeItHight forState:UIControlStateHighlighted];
        writeBtn.frame = CGRectMake(0, cameraHeigtht, writeIt.size.width, writeIt.size.height);
        writeBtn.tag = 0;
        [writeBtn addTarget:self action:@selector(cameraBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [writeBtn setTitleEdgeInsets:titleEdgeInsets];
        writeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];        
//        [writeBtn setTitle:NSLocalizedString(@"Write it", @"Write it") forState:UIControlStateNormal];
        [writeBtn setTitle:NSLocalizedString(@"Shout it", @"Shout it") forState:UIControlStateNormal];
        [writeBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [writeBtn setTitleColor:[[[UIColor alloc] initWithRed:248/255.0 green:62/255.0 blue:62/255.0 alpha:1.0] autorelease]
 forState:UIControlStateHighlighted];
        
        
        
        UIButton *shootBtn = [[FloggerUIFactory uiFactory] createButton:shootIt];
        [shootBtn setBackgroundImage:shootItHight forState:UIControlStateHighlighted];
        shootBtn.frame = CGRectMake(112, cameraHeigtht, shootIt.size.width, shootIt.size.height);
        shootBtn.tag = 1;
        [shootBtn addTarget:self action:@selector(cameraBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [shootBtn setTitleEdgeInsets:titleEdgeInsets];
        shootBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15]; 
//        [shootBtn setTitle:NSLocalizedString(@"Shoot it", @"Shoot it") forState:UIControlStateNormal];
        [shootBtn setTitle:NSLocalizedString(@"Snap it", @"Snap it") forState:UIControlStateNormal];
        [shootBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [shootBtn setTitleColor:[[[UIColor alloc] initWithRed:62/255.0 green:229/255.0 blue:93/255.0 alpha:1.0] autorelease] forState:UIControlStateHighlighted];

        
        UIButton *filmBtn = [[FloggerUIFactory uiFactory] createButton:filmIt];
        [filmBtn setBackgroundImage:filmItHight forState:UIControlStateHighlighted];
        filmBtn.frame = CGRectMake(225, cameraHeigtht, filmIt.size.width, filmIt.size.height);
        filmBtn.tag = 2;
        [filmBtn addTarget:self action:@selector(cameraBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [filmBtn setTitleEdgeInsets:titleEdgeInsets];
        filmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15]; 
//        [filmBtn setTitle:NSLocalizedString(@"Film it", @"Film it") forState:UIControlStateNormal];
        [filmBtn setTitle:NSLocalizedString(@"Shoot it", @"Shoot it") forState:UIControlStateNormal];
        [filmBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [filmBtn setTitleColor:[[[UIColor alloc] initWithRed:57/255.0 green:175/255.0 blue:248/255.0 alpha:1.0] autorelease] forState:UIControlStateHighlighted];
        
        
        UIImageView *foloToolView = [[FloggerUIFactory uiFactory] createImageView:foloPress];
        foloToolView.frame = CGRectMake(0, 380+0.5, foloPress.size.width, foloPress.size.height);
        
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(0, 0, 64, 50);
        cameraBtn.center = foloToolView.center;
        [cameraBtn addTarget:self action:@selector(removeTabBarMenu) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *backgroundView = [[FloggerUIFactory uiFactory] createView];//[[FloggerUIFactory uiFactory] createImageView:backgroundImage];
        backgroundView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        backgroundView.userInteractionEnabled = YES;
        
        UIButton *backgroundBtn = [[FloggerUIFactory uiFactory] createButton:backgroundImage];
        backgroundBtn.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        [backgroundBtn addTarget:self action:@selector(removeTabBarMenu) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:backgroundBtn];
        
        
        [backgroundView addSubview:foloToolView];
        [backgroundView addSubview:writeBtn];
        [backgroundView addSubview:shootBtn];
        [backgroundView addSubview:filmBtn];
////        [backgroundView addSubview:writeLab];
//        [backgroundView addSubview:shootLab];
//        [backgroundView addSubview:filmLab];
        [backgroundView addSubview:cameraBtn];
        
//        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] init] autorelease];
//        [tapGesture addTarget:self action:@selector(removeTabBarMenu)];
//        [backgroundView addGestureRecognizer:tapGesture];
        
//        UIImageView *imageForBackgroundView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, 320, 480)];
//        [imageForBackgroundView setImage:viewImage];
        
//        [imageForBackgroundView addSubview:backgroundView];
        
//        [viewForProfanity insertSubview:imageForBackgroundView atIndex:0];
        [viewForProfanity insertSubview:backgroundView atIndex:0];
        [tabBarController.view addSubview:viewForProfanity];
        
        viewForProfanity.alpha = 0.0;
        
        [UIView beginAnimations:nil context:nil];
        viewForProfanity.alpha = 1.0;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.25];
       
        [UIView commitAnimations];
        
//        controllerForBlackTransparentView.view.t
//        controllerForBlackTransparentView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        self.testViewControl = controllerForBlackTransparentView;
//        [self.rootTabBarControl presentModalViewController:controllerForBlackTransparentView animated:NO];*/
        
        
        
        
//        UIViewController *presentView = [[[UIViewController alloc] init] autorelease];
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        btn.frame = CGRectMake(0, 30, 50, 50);
//        [btn addTarget:self action:@selector(testBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [presentView.view addSubview:btn];
//        presentView.view.frame = CGRectMake(0, 100, 320, 100);
//        presentView.view.backgroundColor = [UIColor clearColor];
//        presentView.modalPresentationStyle = UIModalPresentationCurrentContext;
//        presentView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        self.testViewControl = presentView;
//        [self.rootTabBarControl presentModalViewController:presentView animated:NO];
        return NO;
    }
    
    UINavigationController *navControl = (UINavigationController *) viewController;
//    NSLog(@"tab viewcontrol is %@",[viewController class]);
//    NSLog(@"navcontrol top is %@",[[navControl topViewController] class]);
    
    if([[navControl topViewController] isKindOfClass:[FeedsViewController class]] && [self.lastTimeControl isKindOfClass:[FeedsViewController class]])
    {
        FeedsViewController *feedsViewControl = (FeedsViewController *) [navControl topViewController];
//        [feedsViewControl viewScrollToTop];
        if (_isScrollAndRefresh) {
            [feedsViewControl tabBarClickScrollToTop];
        } else {
            [feedsViewControl viewScrollToTop];
            _isScrollAndRefresh = YES;
        }
        
    }
    
//    NSLog(@"tabBarController.selectedIndex is %d",tabBarController.selectedIndex);    
    if ([[navControl topViewController] isKindOfClass:[ProfileViewController class]] && [self.lastTimeControl isKindOfClass:[ProfileViewController class]] && viewController.tabBarItem.tag == 2) {
        ProfileViewController *profileViewControl = (ProfileViewController *) [navControl topViewController];
        [profileViewControl viewScrollToTop];
    }
    
    if ([[navControl topViewController] isKindOfClass:[PopularViewController class]]&& [self.lastTimeControl isKindOfClass:[PopularViewController class]]) {
        PopularViewController *popularViewControl = (PopularViewController *) [navControl topViewController];
        [popularViewControl viewScrollToTop];
    }
    if ([[navControl topViewController] isKindOfClass:[NotificationViewController class]]&& [self.lastTimeControl isKindOfClass:[NotificationViewController class]]) {
        NotificationViewController *notificationControl = (NotificationViewController *) [navControl topViewController];
        [notificationControl viewScrollToTop];
    }
    
    return YES;
}
-(void)bcTabBarController:(BCTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    NSLog(@"=================== didselect view");
    UINavigationController *navControl = (UINavigationController *) viewController;
    self.lastTimeControl = [navControl topViewController];
//    NSLog(@"lastime control is %@",self.lastTimeControl);
    
}

-(void)closeAlertMessage : (UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
    //    [GlobalUtils ]
}

-(void) showAlertMessage: (NSString *) message
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] autorelease];
    [alert show];
    [self performSelector:@selector(closeAlertMessage:) withObject:alert afterDelay:3];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"select actionSheet is %d", buttonIndex);
    if (buttonIndex == 0) {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        CommentPostViewController *vc = [[[CommentPostViewController alloc] init] autorelease];
        vc.composeMode = TWEETMODE;
        CameraNaviViewController *composeNav = [[[CameraNaviViewController alloc] initWithRootViewController:vc] autorelease];
        [self.rootTabBarControl presentModalViewController:composeNav animated:YES];
    } else if (buttonIndex == 1){
        FloggerCameraControl *cameraControl = [[[FloggerCameraControl alloc] init] autorelease];
        cameraControl.statusMode = PHOTOMODE;
        CameraNaviViewController *cameraNav = [[[CameraNaviViewController alloc] initWithRootViewController:cameraControl] autorelease];
        [self.rootTabBarControl presentModalViewController:cameraNav animated:YES];
    } else if (buttonIndex == 2){
        FloggerCameraControl *cameraControl = [[[FloggerCameraControl alloc] init] autorelease];
        cameraControl.statusMode = VIDEOMODE;
        CameraNaviViewController *cameraNav = [[[CameraNaviViewController alloc] initWithRootViewController:cameraControl] autorelease];
        [self.rootTabBarControl presentModalViewController:cameraNav animated:YES];
    }
}

-(void) showFeedScreen
{
    if (!self.rootTabBarControl) {
        return;
    }
//    self.rootTabBarControl.selectedIndex = 0;
    _isScrollAndRefresh = NO;
    self.rootTabBarControl.selectedViewController = [self.rootTabBarControl.viewControllers objectAtIndex:0];
    if ([self.rootTabBarControl.selectedViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self.rootTabBarControl.selectedViewController popToRootViewControllerAnimated:YES];
    }
//    dispatch_async(<#dispatch_queue_t queue#>, <#^(void)block#>)
}

-(void)showSyncupInfo
{
    if (!self.accountProxy) {
        self.accountProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.accountProxy.delegate = self;
    }
    [self.accountProxy getSyncupInfo];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    if (serverproxy == self.accountProxy) {
        NSLog(@"sysn com");
        SyncupCom *syncup = (SyncupCom *)serverproxy.response;
        [GlobalData sharedInstance].myAccount.clientSystemParameter = syncup.clientSystemParameter;
        [[GlobalData sharedInstance] saveLoginAccount];
    }
}

-(void)logout
{
    //server
    AccountServerProxy *accoutServer = [[[AccountServerProxy alloc] init] autorelease];   
    [[AsyncTaskManager sharedInstance] addTask:accoutServer];
    [accoutServer logout];
//    accoutServer logou
    [[GlobalData sharedInstance]removeAccount];
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
    [[DataCache sharedInstance] removeDataByCategory:kDataCacheTempDataCategory];
    //clear cookie
    [GlobalUtils clearWebCookie];
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]) {
//        [storage deleteCookie:cookie];
//    }
    [self clearNavControllers];
    //self.rootTabBarControl 
//    self.rootTabBarControl.wantsFullScreenLayout = yw
    self.window.rootViewController = [[[UINavigationController alloc]init]autorelease];
    [self.rootTabBarControl dismissModalViewControllerAnimated:NO];
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.frame = [[UIScreen mainScreen] bounds];
    loadFlag = NO;
    [self showMain];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //setvalue
    [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:kRemoteUserInfo];
    int notiCount=[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
    application.applicationIconBadgeNumber =notiCount;
    //type 
    NSString *type = [userInfo objectForKey:@"type"];
    //failed type
    if ([type isEqualToString:@"5"]) {
        NSString *alertInfo = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        [GlobalUtils showPostMessageAlert:alertInfo];
    } else if ([type isEqualToString:@"6"] || [type isEqualToString:@"999"] || [type isEqualToString:@"9999"]) 
    {
        NSString *alertInfo = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        [GlobalUtils showPostMessageAlert:alertInfo];
        [self showSyncupInfo];
    }
    
    if ([GlobalUtils checkIsLogin]) {
//        [self.rootTabBarControl.tabBar show]
        [self.rootTabBarControl.tabBar showBadge];
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSLog(@"application begins");
//    NSLog(@"==== platformString is %@",[GlobalUtils getModel]);
    
//    NSDictionary *pushDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if(pushDict)
//    {
//        [self application:application didReceiveRemoteNotification:pushDict];
//    }
//    [launchOptions obj] 
//    UILocalNotification *localNotif =
//    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    //tabbar style black
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [FloggerStarter doWorkOnStart:self];
    //prepare for camera
     [ISIrisView sharedInstance];
    [self showMain];
//    self.window.rootViewController = [[[UIViewController alloc] init] autorelease];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.window makeKeyAndVisible];
    
    //deal with notification
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]; 
    if (userInfo) {
        //type
        NSString *type = [userInfo objectForKey:@"type"];
        if ([type isEqualToString:@"6"] || [type isEqualToString:@"999"] || [type isEqualToString:@"9999"]) 
        {
            NSString *alertInfo = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            [GlobalUtils showPostMessageAlert:alertInfo];
            [self showSyncupInfo];
        }
    }
    
    return YES;
}

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
//    NSLog(@"========== did finish");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[SDImageCache sharedImageCache]clearMemory];
    [[DataCache sharedInstance]clearMemory];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
//    NSLog(@"enter background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
//    NSLog(@"enter foreground");
//    if ([[NSUserDefaults standardUserDefaults] valueForKey:kRemoteUserInfo]) {
//        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:kRemoteUserInfo];
//        //type 
//        NSString *type = [userInfo objectForKey:@"type"];
//        if ([type isEqualToString:@"6"] || [type isEqualToString:@"999"] || [type isEqualToString:@"9999"]) 
//        {
//            NSString *alertInfo = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//            [GlobalUtils showPostMessageAlert:alertInfo];
//            [self showSyncupInfo];
//        }
//        
//    }
//    [UIApplication sharedApplication] applicationState
    if ([GlobalUtils checkIsLogin]) {
        //        [self.rootTabBarControl.tabBar show]
        [self.rootTabBarControl.tabBar showBadge];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Flogger" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Flogger.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    NSLog(@"openURL is %@",url);
    [self showMain];
    return YES;
}

@end
