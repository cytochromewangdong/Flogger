//
//  ExternalBindViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-25.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ExternalBindViewController.h"
#import "AccountServerProxy.h"
#import "GlobalData.h"
#import "AccountCom.h"
#import "FloggerAppDelegate.h"
#import "FloggerUIFactory.h"
#import "SnsInviteViewController.h"

#define kRedirectUrl @"http://www.atoato.com"

@implementation ExternalBindViewController
@synthesize isBind;
@synthesize webView, platform, aServerProxy, tokenSecret,doingLogin;
@synthesize loginMode;

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
-(BOOL) checkIsFullScreen
{
    return YES;
}

-(void)doRequestUrl
{
    if (!self.aServerProxy) {
        self.aServerProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.aServerProxy.delegate = self;
    }
    
    AccountCom *com = [[[AccountCom alloc] init] autorelease];
    com.usersource = self.platform.id;
    [self.aServerProxy getRequestUrl:com];
}

-(void)go2ExternalWithUrl:(NSString *) url 
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//    [self.webView ]
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isNeedProgress = YES;
    self.loading = YES;
    
    UIView *view = [[FloggerUIFactory uiFactory] createView];
    view.frame = CGRectMake(0, 0, 320, 460);
    self.view = view;
    
    UIWebView *web = [[FloggerUIFactory uiFactory] createWebView];
    web.frame = CGRectMake(0, 0, 320, 460);
    web.backgroundColor  = [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    [self.view addSubview:web];
    
    [self setWebView:web];
    
    
    NSString *url = self.platform.url;
    // Do any additional setup after loading the view from its nib.
    if (url&&url.length>0) {
        [self go2ExternalWithUrl:url];
    } 
    else
    {
        [self doRequestUrl];
    }
    
    self.webView.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.platform) {
        [self setNavigationTitleView:[NSString stringWithFormat:@"%@ %@",self.platform.name, NSLocalizedString(@"Login", @"Login")]];
    }

}

-(void)doLogin:(NSString *)url
{
//    if (self.loading) {
//        return;
//    }
    
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init]  autorelease];
        self.serverProxy.delegate = self;
    }
    
    AccountCom *com = [[[AccountCom alloc] init] autorelease];
    com.contactList = [GlobalUtils getAllContacts];
    com.usersource = self.platform.id;
    com.usersourcename = url;
    com.tokenSecret = self.tokenSecret;
    if (isBind) {
        [((AccountServerProxy *)(self.serverProxy)) bind:com];
    }
    else
    {
        [((AccountServerProxy *)(self.serverProxy)) externalLogin:com];
    }
//    [((AccountServerProxy *)(self.serverProxy)) externalLogin:com];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // prevent any request while doing login
    if(self.doingLogin)
    {
        return NO;
    }
    if([@"capture" isEqualToString:request.URL.scheme])
    {
        self.loading = NO;
        return NO;
    }
    NSURL *url = request.URL;
    BOOL result =  [[[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ] hasPrefix: self.platform.matchurl];
    if (result) {
        [self doLogin:url.absoluteString];
        self.doingLogin = YES;
        return NO;
    }
    self.loading = YES;
    return YES;
}

-(void) transactionFailed:(BaseServerProxy *)serverproxy
{
    [super transactionFailed:serverproxy];
//    if(self.platform.url)
    {

    }
    if (self.serverProxy == serverproxy)
    {
        
        self.doingLogin = NO;
        [GlobalUtils clearExternalPlatformCacheAndCookie: self.platform.url];
    }
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    
//    if (self.serverProxy == serverproxy) {
//        [GlobalData sharedInstance].myAccount = (AccountCom *)serverproxy.response;
//        [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showFeed];
//    }
//    else
//    {
//        self.platform.url = ((AccountCom *)serverproxy.response).requestUrl;
//        [self go2External];
//    }
    if (self.serverProxy == serverproxy) {
        
        if (isBind) {
            AccountCom *com = (AccountCom *)serverproxy.response;
            [GlobalData sharedInstance].myAccount.externalaccounts = com.externalaccounts;
            
            if (self.loginMode == INVITEMODE) {
                UINavigationController *testNav = self.navigationController;
                [testNav popViewControllerAnimated:NO];
                SnsInviteViewController *snsInviteControl = [[[SnsInviteViewController alloc] init] autorelease];
                snsInviteControl.platform = self.platform;
                snsInviteControl.isFromLogin = YES;
                
                //                [self dismissModalViewControllerAnimated:NO];
                [testNav pushViewController:snsInviteControl animated:YES];
                
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }            
        }
        else
        {
            AccountCom *com = (AccountCom *)serverproxy.response;
            [GlobalData sharedInstance].myAccount = com;
            if ([com.firstLogin boolValue]) {
                [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showFirstRegisterScreen:com.accountList];
            } else {
                [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showMain];
            }
            
        }
        self.doingLogin = NO;
        [[GlobalData sharedInstance] saveLoginAccount];
    }
    else
    {
        NSString* url = ((AccountCom *)serverproxy.response).requestUrl;
        self.tokenSecret = ((AccountCom *)serverproxy.response).tokenSecret;
        [self go2ExternalWithUrl:url];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    if(self.doingLogin)
    {
        return;
    }
    self.loading = NO;
}
-(void)dealloc
{
    self.webView.delegate = nil;
    self.webView = nil;
    self.platform = nil;
    self.aServerProxy.delegate = nil;
    self.aServerProxy = nil;
    self.tokenSecret = nil;
    [super dealloc];
}
-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    //[webView stringByEvaluatingJavaScriptFromString:@"window.location.href='capture://aabb.com';"];
    self.loading = NO;
}

-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [self.aServerProxy cancelAll];
}
@end
