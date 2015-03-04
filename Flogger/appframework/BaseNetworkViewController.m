//
//  BaseNetworkViewController.m
//  Flogger
//
//  Created by jwchen on 12-1-20.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "MBProgressHUD.h"
#import "CommentPostViewController.h"
#import "MyMoviePlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>


#define LOADINGTEXTVIEWTAG 555

@interface BaseNetworkViewController() <MBProgressHUDDelegate>
@property (retain,nonatomic) MBProgressHUD *hud;

@end

@implementation BaseNetworkViewController
@synthesize loading = _loading, serverProxy = _serverProxy;
@synthesize hud;
@synthesize loadingThread,isNeedProgress;
@synthesize firstActivityIndicatorView,firstActivityOriginalY;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        loadingThread = YES;
        self.firstActivityOriginalY = -1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)reloading
{
    self.loading = YES;
}

/*-(void)setLoading:(BOOL)isLoading
{
    _loading = isLoading;
    if (isLoading) {
        [self.view bringSubviewToFront:_indecatorView];
        [_indecatorView startAnimating];
    }
    else
    {
        [_indecatorView stopAnimating];
    }
}*/

-(void) myTask
{
    sleep(8);
}
-(void)setLoading:(BOOL)isLoading
{
    if(_loading == isLoading)
    {
        return;
    }
    _loading = isLoading;
    
    if (!isNeedProgress) {
        return;
    }
    
    if (isLoading) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *progressHud;
            progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            progressHud.labelText = NSLocalizedString(@"Loading...", @"Loading...") ;
        });
        
    }
    else
//        if (!isLoading && loadingThread)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        });
    }
}

//- (void)hudWasHidden:(MBProgressHUD *)hud {
//    // Remove HUD from screen when the HUD was hidded
//    [self.hud removeFromSuperview];
//    [self.hud release];
//	self.hud = nil;
//}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*_indecatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indecatorView.center = self.view.center;
    [self.view addSubview:_indecatorView];*/
    
//    self.hud = [[[MBProgressHUD alloc] initWithView:self.tabBarController.view] autorelease];
//    [self.tabBarController.view addSubview:self.hud];
//    self.hud.delegate = self;
}
-(BOOL) showFirstActivityView
{
    return NO;
}

-(void) showFirstActivity
{
    if ([self showFirstActivityView]) {
        if (!self.firstActivityIndicatorView) {
            UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            activityView.frame = CGRectMake(20, self.firstActivityOriginalY + 20, 20, 20);
            [self.view addSubview:activityView];
            self.firstActivityIndicatorView = activityView;
        }
        
        if (![self.view viewWithTag:LOADINGTEXTVIEWTAG]) {
            UILabel *textLabel = [[FloggerUIFactory uiFactory] createLable];
            textLabel.font = [UIFont boldSystemFontOfSize:14];
            textLabel.frame =CGRectMake(40, self.firstActivityOriginalY, 240, 60);
            textLabel.textAlignment = UITextAlignmentCenter;
            textLabel.tag = LOADINGTEXTVIEWTAG;
            textLabel.text = NSLocalizedString(@"Loading...", @"Loading...");
            [self.view addSubview:textLabel];
        }
        
        [self.firstActivityIndicatorView startAnimating];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showFirstActivity];
}

-(void) cancelPlayVideo
{
//    NSLog(@"=== cancel play video is %@===",[self class]);
    MyMoviePlayerManager *myMovieManager = [MyMoviePlayerManager getMyMoviePlayerManager];
    if (!myMovieManager.isEnterFullScreen) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadTableView object:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:self.view animated:NO];
//    });
    [self cancelNetworkRequests];
    [self cancelPlayVideo];
    
//    [BaseServerProxy cancelAllOnEarth:normalLevel];
   
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self cancelPlayVideo];
    
}

-(void)cancelNetworkRequests
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    });
    [self.serverProxy cancelAll];
    self.loading = NO;
    
    [self closeFirstLoadingActivity];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    RELEASE_SAFELY(_indecatorView);
}

-(void) dealloc
{
//    RELEASE_SAFELY(_indecatorView);
    self.firstActivityIndicatorView = nil;
    
    if (self.serverProxy.delegate == self) {
        self.serverProxy.delegate = nil;
    }
    
    self.serverProxy = nil;
//    self.hud = nil;
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) closeFirstLoadingActivity
{
    if ([self showFirstActivityView] && self.firstActivityIndicatorView && self.firstActivityOriginalY >= 0) {
        [self.firstActivityIndicatorView stopAnimating];
        self.firstActivityOriginalY = -1;
        [[self.view viewWithTag:LOADINGTEXTVIEWTAG] removeFromSuperview];
    }
}

- (void)networkFinished:(BaseServerProxy *)serverproxy
{
    self.loading = NO;
    [self closeFirstLoadingActivity];
    
    if (serverproxy.errorMessage) {
//        [GlobalUtils showAlert:nil message:serverproxy.errorMessage];
        [GlobalUtils showPostMessageAlert:serverproxy.errorMessage];
        serverproxy.response = nil;
        serverproxy.errorMessage = nil;
    }
    
}

-(void)transactionFinished:(BaseServerProxy *)sp
{
    [self closeFirstLoadingActivity];
}

-(void)transactionFailed:(BaseServerProxy *)sp
{
    self.loading = NO;
//    NSLog(@"transactionFailed");     
  //  [self networkFinished:sp];
//    [self closeFirstLoadingActivity];
}

-(void)networkError:(BaseServerProxy *)sp
{
    self.loading = NO;
//    NSLog(@"networkError");
   // [self networkFinished:sp]; 
}

@end
