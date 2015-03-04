//
//  ShareSettingViewController.m
//  Flogger
//
//  Created by jwchen on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ShareSettingViewController.h"
#import "GlobalData.h"
#import "ShareConfigurationView.h"
#import "ExternalBindViewController.h"
//#import "SingleShareView.h"
#import "SingleShareCell.h"
#import "MyExternalaccount.h"


@implementation ShareSettingViewController
@synthesize tableV;
@synthesize tokenServerProxy,isExpire;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if ([GlobalUtils checkExpiredToken]) {
            [self doTokenRequest];
        }        
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

//-(void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//   
//}

#pragma mark - View lifecycle
-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
//    view.backgroundColor= [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    self.view = view;
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{   
    [super viewDidLoad];
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped]autorelease];
    tableView.backgroundColor = [UIColor clearColor];
    if ([GlobalUtils checkIOS_6]) {
        tableView.backgroundView = nil;
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 45;
    [self.view addSubview:tableView];
    
    self.tableV = tableView;
}

-(void) doTokenRequest
{
    if(!self.tokenServerProxy)
    {
        self.tokenServerProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.tokenServerProxy.delegate = self;
    }
    AccountCom *com = [[[AccountCom alloc] init] autorelease];
    [self.tokenServerProxy getExternalAccountList:com];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"count is %d",[GlobalData sharedInstance].exPlatform.externalplatforms.count);
    return [GlobalData sharedInstance].exPlatform.externalplatforms.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
//-(MyExternalaccount *)getExternalAccount:(MyExternalPlatform *)platform
//{
//    for (MyExternalaccount *eaccount in [GlobalData sharedInstance].myAccount.externalaccounts) {
//        if ([eaccount.usersource intValue] == [platform.id intValue]) {
//            return eaccount;
//        }
//    }
//    return nil;
//}
//-(MyExternalaccount *)getExternalAccount:(NSNumber*)sourceID List:(NSArray*)externalAccountList
//{
//    for (MyExternalaccount *eaccount in externalAccountList) {
//        if ([eaccount.usersource intValue] == [sourceID intValue]) {
//            return eaccount;
//        }
//    }
//    return nil;
//}
//
//-(MyExternalaccount *)getExternalAccount:(NSNumber*)sourceID
//{
//    return [self getExternalAccount:sourceID  List:[GlobalData sharedInstance].myAccount.externalaccounts];
//}

-(UITableViewCell*) createSharedRow:(NSIndexPath *)indexPath offset:(int)offset
{
    SingleShareCell *cell = nil;
    static NSString *kSourceCellID = @"SourceCellID";
    cell = [self.tableV dequeueReusableCellWithIdentifier:kSourceCellID];
    MyExternalPlatform *externalPlatform = [[GlobalData sharedInstance].exPlatform.externalplatforms objectAtIndex:indexPath.row + offset];
    MyExternalaccount *myAccount = [GlobalUtils getExternalAccount:externalPlatform.id];
    if (cell == nil)
    {
          cell = [[SingleShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID platform:externalPlatform account:myAccount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (myAccount) {
        if ([myAccount.expired boolValue]) {
            //            cell.configButton.titleLabel.text = NSLocalizedString(@"ReConfigure >",@"ReConfigure >");
            [cell.configButton setTitle: NSLocalizedString(@"Reconfigure   ",@"Reconfigure   ") forState:UIControlStateNormal];
            cell.unBindButton.hidden = YES;
            cell.configButton.hidden = NO;
            cell.switchButton.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {//unbind
            if ([GlobalData sharedInstance].myAccount.account.usersource.intValue==myAccount.usersource.intValue&&myAccount.usersource.intValue>0) {
                cell.unBindButton.hidden = YES;
            }else{
                cell.unBindButton.hidden = NO;
            }
            cell.configButton.hidden = YES;
            cell.switchButton.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {//configure
        cell.unBindButton.hidden = YES;
        cell.configButton.hidden = NO;
        cell.switchButton.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self createSharedRow:indexPath offset:0];
}
-(void) myReleaseSource
{
    self.tableV.dataSource = nil;
    self.tableV.delegate = nil;
    self.tableV = nil;
    self.tokenServerProxy = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self myReleaseSource];
}

-(void) dealloc
{
    [self myReleaseSource];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)singleShareView:(SingleShareCell *)singleShareView platform:(MyExternalPlatform *)platform
{
    ExternalBindViewController *vc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.platform = platform;
    vc.isBind = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)singleShareViewUnBind:(SingleShareCell *)singleShareView platform:(MyExternalPlatform *)platform
{
    self.loading = YES;
    //clear
    [GlobalUtils clearExternalPlatformCacheAndCookie: platform.url];
    
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init]  autorelease];
        self.serverProxy.delegate = self;
    }
    
    AccountCom *com = [[[AccountCom alloc] init] autorelease];
    com.usersource = platform.id;
    [((AccountServerProxy *)(self.serverProxy)) unBind:com];
    
    [GlobalUtils clearExternalPlatformCacheAndCookie:platform.url];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableV reloadData];
     [self setNavigationTitleView:NSLocalizedString(@"Share Settings", @"Share Settings")];
}

//-(void) transactionFailed:(BaseServerProxy *)serverproxy
//{
//    
//}



-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
//    MyAccount
    AccountCom *com = (AccountCom *)serverproxy.response;
    if (self.tokenServerProxy == serverproxy) {        
        for (MyExternalPlatform *externalPlatform  in [GlobalData sharedInstance].exPlatform.externalplatforms)
        {
            
            MyExternalaccount *myNewAccount = [GlobalUtils getExternalAccount:externalPlatform.id List:com.externalaccounts];
            MyExternalaccount *myLocalAccount = [GlobalUtils getExternalAccount:externalPlatform.id];
            if (myNewAccount)
            {
                myNewAccount.sharestatus = myLocalAccount.sharestatus;
            }
            
        }
        [GlobalData sharedInstance].myAccount.externalaccounts = com.externalaccounts;
        [[GlobalData sharedInstance] saveLoginAccount];
        //save token time
        [GlobalUtils saveTokenTime];
        
        [self.tableV reloadData];
        [self.tableV setNeedsDisplay];
    } 
    else if([serverproxy isKindOfClass:[AccountServerProxy class]]) {
        
//        [GlobalData sharedInstance].myAccount = (AccountCom *)serverproxy.response;
        [GlobalData sharedInstance].myAccount.externalaccounts = com.externalaccounts;
        [[GlobalData sharedInstance] saveLoginAccount];
        [self.tableV reloadData];
        [self.tableV setNeedsDisplay];
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyExternalPlatform *externalPlatform = (MyExternalPlatform *)[[GlobalData sharedInstance].exPlatform.externalplatforms objectAtIndex:indexPath.row];
    MyExternalaccount *myAccount = [GlobalUtils getExternalAccount:externalPlatform.id];

    if (myAccount) {
        if ([myAccount.expired boolValue]) {
            //  再配置
            ExternalBindViewController *ebvc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            ebvc.platform = externalPlatform;
            ebvc.isBind = YES;
            [self.navigationController pushViewController:ebvc animated:YES];
        } else {
            //解除绑定
        }
    } else {//配置
            ExternalBindViewController *ebvc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            ebvc.platform = externalPlatform;
            ebvc.isBind = YES;
            [self.navigationController pushViewController:ebvc animated:YES];
    }

}

-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [self.tokenServerProxy cancelAll];
}
@end
