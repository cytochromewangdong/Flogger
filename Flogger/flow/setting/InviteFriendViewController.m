//
//  InviteFriendViewController.m
//  Flogger
//
//  Created by wyf on 12-6-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "GlobalData.h"
#import "ExternalBindViewController.h"
#import "ContactsViewController.h"
#import "SnsInviteViewController.h"

@interface InviteFriendViewController ()

@end

@implementation InviteFriendViewController
@synthesize tableV;

-(void) dealloc
{
    self.tableV.dataSource = nil;
    self.tableV.delegate = nil;
    self.tableV = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL) checkIsFullScreen
{
    return YES;
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:NSLocalizedString(@"Invite friends", @"Invite Friends")];
}

-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
    self.view = view;
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([GlobalData sharedInstance].exPlatform.externalplatforms.count+2);
}

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
    cell.unBindButton.hidden = NO;
    [cell.unBindButton setTitle:NSLocalizedString(@"Invite", @"Invite") forState:UIControlStateNormal];
    [cell.unBindButton setBackgroundImage:[UIImage imageNamed:SNS_BUTTON] forState:UIControlStateNormal];
    [cell.unBindButton setTitleColor: [[[UIColor alloc] initWithRed:64/255.0 green:64/255.0 blue:62/255.0 alpha:1.0] autorelease]forState:UIControlStateNormal];
    cell.unBindButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [cell.unBindButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.configButton.hidden = YES;
    cell.switchButton.hidden = YES;
//    if (myAccount) {
//        if ([myAccount.expired boolValue]) {
//            [cell.configButton setTitle: NSLocalizedString(@"Reconfigure   ",@"Reconfigure   ") forState:UIControlStateNormal];
//            cell.unBindButton.hidden = YES;
//            cell.configButton.hidden = NO;
//            cell.switchButton.hidden = YES;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        } else {
//            cell.unBindButton.hidden = YES;
//            cell.configButton.hidden = YES;
//            cell.switchButton.hidden = NO;
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//    } else {
//        cell.unBindButton.hidden = YES;
//        cell.configButton.hidden = NO;
//        cell.switchButton.hidden = YES;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleShareCell *cell = nil;
    static NSString *kSourceCellID = @"SourceCellIDShare";
        if (indexPath.row == 0 || indexPath.row == 1) {
            if (!cell) {
                cell = [[[SingleShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row == 0) {
                cell.stringLabel.text = NSLocalizedString(@"SMS", @"SMS");
                cell.unBindButton.hidden = YES;
                cell.configButton.hidden = YES;
                cell.switchButton.hidden = YES;
                [cell.iconImage setImage:[[FloggerUIFactory uiFactory]createImage:SNS_SMS]  ];
            } else {
                cell.stringLabel.text = NSLocalizedString(@"Email", @"Email");
                cell.unBindButton.hidden = YES;
                cell.configButton.hidden = YES;
                cell.switchButton.hidden = YES;
                [cell.iconImage setImage:[[FloggerUIFactory uiFactory]createImage:SNS_EMAIL]  ];
            }
            
        }
        else
        {
            return [self createSharedRow:indexPath offset:-2];
            
        }
    return cell;
}

-(void)singleShareView:(SingleShareCell *)singleShareView platform:(MyExternalPlatform *)platform
{
    ExternalBindViewController *vc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.platform = platform;
    vc.isBind = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void) doSnsAction : (Externalplatform *) externalPlatform
{
    MyExternalaccount *myAccount = [GlobalUtils getExternalAccount:externalPlatform.id];
    if (myAccount) {
        if ([myAccount.expired boolValue]) {
            //  再配置
            ExternalBindViewController *ebvc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            ebvc.platform = externalPlatform;
            ebvc.isBind = YES;
            ebvc.loginMode = INVITEMODE;
            [self.navigationController pushViewController:ebvc animated:YES];
        } else {
            //
            SnsInviteViewController *snsInviteControl = [[[SnsInviteViewController alloc] init] autorelease];
            snsInviteControl.platform = externalPlatform;
            [self.navigationController pushViewController:snsInviteControl animated:YES];
        }
    } else {//配置
        ExternalBindViewController *ebvc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        ebvc.platform = externalPlatform;
        ebvc.isBind = YES;
        ebvc.loginMode = INVITEMODE;
        [self.navigationController pushViewController:ebvc animated:YES];
    }
}

-(void)singleShareViewUnBind:(SingleShareCell *)singleShareView platform:(MyExternalPlatform *)platform
{
    [self doSnsAction:platform];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 0) {
//        NSLog(@"share address book");
        if ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"]) {
            return;
        }
        
        ContactsViewController *contactViewControl = [[[ContactsViewController alloc] init] autorelease];
        contactViewControl.contactMode = PHONECONTACT;        
//        [self.navigationController pushViewController:contactViewControl animated:YES];
        
        UINavigationController *naviControl = [[[UINavigationController alloc] initWithRootViewController:contactViewControl] autorelease];
        [self presentModalViewController:naviControl animated:YES];
        return;
    } else if ([indexPath row] == 1)
    {
        ContactsViewController *contactViewControl = [[[ContactsViewController alloc] init] autorelease];
        contactViewControl.contactMode = EMAILCONTACT;        
//        [self.navigationController pushViewController:contactViewControl animated:YES];
        UINavigationController *naviControl = [[[UINavigationController alloc] initWithRootViewController:contactViewControl] autorelease];
        [self presentModalViewController:naviControl animated:YES];
        return;
    } else {
        MyExternalPlatform *externalPlatform = (MyExternalPlatform *)[[GlobalData sharedInstance].exPlatform.externalplatforms objectAtIndex:indexPath.row-2];
        
        [self doSnsAction:externalPlatform];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
