//
//  BiographyViewController.m
//  Flogger
//
//  Created by steveli on 17/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "BiographyViewController.h"
#import "MyAccount.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalData.h"
#import "AccountServerProxy.h"
#import "Taglist.h"
#import "TagFeedViewController.h"
#import "FloggerWebAdapter.h"
#import "SBJson.h"
#import "Taglist.h"
#import "FloggerScrollView.h"
#define TAG_FIELD_H 45
#define KEY_USER_NAME @"username"
#define KEY_BIOGRAPHY @"biography"
#define KEY_INTEREST @"interest"
#define KEY_WEBSITE @"website"
#define KEY_TAG @"tagName"
#define WEBSITE_TAG @"website"
@implementation BiographyViewController
@synthesize account,ismyself;
@synthesize webview=_webview;
@synthesize profileServerProxy;

-(void)internalClear
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.webview.action object:nil];
    self.webview = nil;
}
-(void)dealloc
{
    [self internalClear];
    self.profileServerProxy.delegate = nil;
    self.profileServerProxy = nil;
    self.account     = nil;
    [[FloggerWebAdapter getSingleton] refreshBiographyView];
    [super dealloc];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(BOOL) checkIsFullScreen
{
    if ([GlobalUtils checkIsOwner:self.account]) {
        return YES;
    } else {
        return NO;
    }
}

//-(BOOL)checkAccount
//{
//    if([account.useruid isEqualToNumber:[GlobalData sharedInstance].myAccount.account.useruid])
//        return YES;
//    else
//        return NO;
//}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:[NSString stringWithFormat:@"@%@",self.account.username]];
}

-(void) adjustBiographyViewLayout
{
    UIView *view;
    if ([GlobalUtils checkIsOwner:self.account]) {
        view = [[[FloggerScrollView  alloc]initWithFrame:CGRectMake(0, 0, 320, 416)] autorelease];
    } else {
        view = [[[FloggerScrollView  alloc]initWithFrame:CGRectMake(0, 0, 320, 367)] autorelease];
    }
//    UIView *view = [[FloggerScrollView  alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];//[[FloggerUIFactory uiFactory] createView];
//    view.frame = CGRectMake(0, 0, 320, 416);
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    
}
-(void) loadView
{
    [self adjustBiographyViewLayout];

}
- (NSMutableDictionary *)collectDisplayData
{
    NSMutableDictionary *data = [[[NSMutableDictionary alloc]init]autorelease];
    if(self.account.username)
    {
        [data setObject:self.account.username forKey:KEY_USER_NAME];
    }
    if(self.account.biography){
        [data setObject:self.account.biography forKey:KEY_BIOGRAPHY];
    }
    if(self.account.interest){
        [data setObject:self.account.interest forKey:KEY_INTEREST];
    }
    if(self.account.website)
    {
        [data setObject:self.account.website forKey:KEY_WEBSITE];
    }
 
    [data setObject:NSLocalizedString(@"'s Biography",@"") forKey:@"lblBiography"];
    [data setObject:NSLocalizedString(@"Click here to write your biography",@"") forKey:@"lblPlaceholderBiography"];
    [data setObject:NSLocalizedString(@"Click here to add a website",@"") forKey:@"lblPlaceholderWebsite"];
    [data setObject:NSLocalizedString(@"Interest",@"") forKey:@"lblInterest"];
    [data setObject:NSLocalizedString(@"Type interest here",@"") forKey:@"lblTypeinterest"];
    
    BOOL isOwn = [self ismyself];
    [data setObject:[NSNumber numberWithBool:isOwn] forKey:KEY_ISOWN];
//    NSLog(@"data passed to the JS:%@", [data JSONRepresentation]);
    return data;
}

-(void) fillDataToWebView
{
    NSMutableDictionary *data;
    data = [self collectDisplayData];
    
    NSString *ret = [self.webview fillData:[data JSONRepresentation]];
//    NSLog(@"javascript return value:%@", ret);
    //self.webview
}

-(void)doRequestGetAccountProfile
{
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


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.ismyself = [GlobalUtils checkIsOwner:self.account];//[self checkAccount];
    

    self.webview = [[FloggerWebAdapter getSingleton]getBiographyView]; 
    if ([GlobalUtils checkIsOwner:self.account]) {
        self.webview.frame = CGRectMake(0, 0, 320, 416);
    }else {
        self.webview.frame = CGRectMake(0, 0, 320, 367);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:_webview.action object:nil];
    if([self.webview isLoaded])
    {
        [self fillDataToWebView];
    }
    [self doRequestGetAccountProfile];
    
    [self.view addSubview:_webview];
}

- (void) handleAction:(NSNotification *)notification
{
    if(notification.object)
    {
        if([@"update" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            [self uploadWebSite:notification.object];
            return;
        }     
        if([@"goTag" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            NSString *tag = [notification.object objectForKey:KEY_TAG];
            TagFeedViewController *listVc = [[[TagFeedViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            listVc.taginfo = [[[Taglist alloc]init]autorelease];
            listVc.taginfo.content = tag;
            [self.navigationController pushViewController:listVc animated:YES];
            return;
        }
        if([@"goWebsite" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            NSString *website = [notification.object objectForKey:WEBSITE_TAG];
            website = [website stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            BOOL result;
            result=[website hasPrefix:@"http://"];
            if (result==YES) {
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
            }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://%@",website]]];
            }
            
            return;
        }

    } else {
        [self fillDataToWebView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self internalClear];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma upload


-(void)uploadWebSite:(NSDictionary*)data
{
    AccountCom *accountcom = [[[AccountCom alloc] init] autorelease];//[GlobalData sharedInstance].myAccount;
    if(accountcom == nil)
        return;
    
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    accountcom.userUID = [GlobalData sharedInstance].myAccount.userUID;
    accountcom.uploadType = [NSNumber numberWithInt:2];
    
    accountcom.website = [data objectForKey:KEY_WEBSITE];
    accountcom.interests = [data objectForKey:KEY_INTEREST];
    accountcom.biography = [data objectForKey:KEY_BIOGRAPHY];
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    AccountServerProxy *asp = (AccountServerProxy *)self.serverProxy;
    [asp updateBiography:accountcom];
    
}


#pragma net finished
-(void)transactionFinished:(BaseServerProxy *)sp
{
    [super transactionFinished:sp];
    
    if (sp == self.profileServerProxy) {
        IssueInfoCom *response = (IssueInfoCom *)sp.response;
        self.account = response.account;
        [self fillDataToWebView];
        return;
    }
    
    AccountCom* acom = (AccountCom *)sp.response;
    
    [GlobalData sharedInstance].myAccount.account.interest = acom.interests;
    [GlobalData sharedInstance].myAccount.account.biography = acom.biography;
    [GlobalData sharedInstance].myAccount.account.website = acom.website;
    [[GlobalData sharedInstance] saveLoginAccount];
    
    self.account.interest = acom.interests;
    self.account.biography = acom.biography;
    self.account.website = acom.website;
    NSMutableDictionary *data = [self collectDisplayData];
    [data setObject:@"true" forKey:KEY_WEB_SUCCESS];
    [self.webview hostCallBack:[data JSONRepresentation]];
}
-(void)transactionFailed:(BaseServerProxy *)serverproxy
{
    [super transactionFailed:serverproxy];
    [self.webview hostCallBack:@"{\"success\":false}"];
}

@end
