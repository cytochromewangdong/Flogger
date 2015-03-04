//
//  FindFriendSelectionViewController.m
//  Flogger
//
//  Created by jwchen on 12-3-8.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FindFriendSelectionViewController.h"
#import "GlobalData.h"
#import "Externalplatform.h"
#import "ExternalBindViewController.h"
#import "FriendListViewController.h"
#import "SingleShareCell.h"
#import "SearchViewController.h"
#import "NewFriendListViewController.h"


@implementation FindFriendSelectionViewController
@synthesize tokenServerProxy;
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

-(NSString *)getStrFromExPlatForm:(Externalplatform *)platform
{

    return [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"Find",@"Find"), platform.name, NSLocalizedString(@"friends",@"friends")];
}

-(void)setupTableData
{
//    NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:[GlobalUtils getLocalizedString:@"Scan address book"], nil];
    //    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dataArray, @" ", nil];
    
    [self.tableView.dataArr addObject:NSLocalizedString(@"Scan address book",@"Scan address book")];
    [self.tableView.dataArr addObject:NSLocalizedString(@"Scan userName of iFlogger",@"Scan userName of iFlogger")];
    for (Externalplatform *platform in [GlobalData sharedInstance].exPlatform.externalplatforms) {
        [self.tableView.dataArr addObject:[self getStrFromExPlatForm:platform]];
    }
}


#pragma mark - View lifecycle
-(void) loadView
{
   // UIImage *backgroundImage = [[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND];
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
//    view.backgroundColor = [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];//[[[UIColor alloc] initWithPatternImage:backgroundImage] autorelease];
    self.view = view;
    self.tableView = [[[ClTableView alloc] initWithFrame:self.view.bounds withStyle:UITableViewStyleGrouped] autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    if ([GlobalUtils checkIOS_6]) {
        self.tableView.tableView.backgroundView = nil;
    }    
    self.tableView.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableView.allowsSelection = YES;
    self.tableView.custHeight=45;
//    self.tableView.tableView.delegate = self;
    [self.view addSubview:self.tableView];
       

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:NSLocalizedString(@"Find friends", @"Find friends")];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTableData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tokenServerProxy = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(UITableViewCell*) createSharedRow:(NSIndexPath *)indexPath offset:(int)offset
{
    static NSString *CellIdentifier = @"CellIdentifierShare";
    SingleShareCell *cell = nil;
     cell = [self.tableView.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MyExternalPlatform *externalPlatform = [[GlobalData sharedInstance].exPlatform.externalplatforms objectAtIndex:indexPath.row + offset];
    MyExternalaccount *myAccount = [GlobalUtils getExternalAccount:externalPlatform.id];
    if (!cell) {
       cell = [[[SingleShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier platform:externalPlatform account:myAccount] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.configButton.enabled=NO ;
    }
    if (myAccount) {
        if ([myAccount.expired boolValue]) {
            //在配置
            [cell.configButton setTitle: NSLocalizedString(@"Reconfigure   ",@"Reconfigure   ") forState:UIControlStateNormal];
            cell.unBindButton.hidden = YES;
            cell.configButton.hidden = NO;
            cell.switchButton.hidden = YES;
        } else {
            //                [cell.configButton setTitle: NSLocalizedString(@">",@">") forState:UIControlStateNormal];
            cell.unBindButton.hidden = YES;
            cell.configButton.hidden = YES;
            cell.switchButton.hidden = YES;
        }
    } else {
        //配置
        cell.unBindButton.hidden = YES;
        cell.configButton.hidden = NO;
        cell.switchButton.hidden = YES;
    }
    cell.stringLabel.text = externalPlatform.findfriendsName;
    return cell;

}




-(UITableViewCell *)tableView:(ClTableView *)cltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleShareCell *cell = nil;
    static NSString *CellIdentifier = @"CellIdentifier";
    if (indexPath.row == 0) {
        if (!cell) {
            cell = [[[SingleShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.stringLabel.text = NSLocalizedString(@"Scan address book",@"Scan address book");
            cell.unBindButton.hidden = YES;
            cell.configButton.hidden = YES;
            cell.switchButton.hidden = YES;
            [cell.iconImage setImage:[[FloggerUIFactory uiFactory]createImage:SNS_INVITE_ADRESSBOOK]  ];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    } else if(indexPath.row == 1){
        if (!cell) {
            cell = [[[SingleShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.stringLabel.text = NSLocalizedString(@"Scan userName of iFlogger",@"Scan userName of iFlogger");
            cell.unBindButton.hidden = YES;
            cell.configButton.hidden = YES;
            cell.switchButton.hidden = YES;
            [cell.iconImage setImage:[[FloggerUIFactory uiFactory]createImage:SNS_LOGO_ICON]  ];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
    }else {
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

-(void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 0) {
        FriendListViewController *vc = [[[FriendListViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        vc.type = FriendListView_Addressbook;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([indexPath row] == 1){
        SearchViewController *searchViewControl = [[[SearchViewController alloc] init] autorelease];
        searchViewControl.searchMode = FROM_FIND_FRIEND;
        [self.navigationController pushViewController:searchViewControl animated:YES];
    }
    else
    {
        NSInteger index = [indexPath row] - 2;
        Externalplatform *platform = [[GlobalData sharedInstance].exPlatform.externalplatforms objectAtIndex:index];        
        MyExternalPlatform *externalPlatform = (MyExternalPlatform *)[[GlobalData sharedInstance].exPlatform.externalplatforms objectAtIndex:index];
        MyExternalaccount *myAccount = [GlobalUtils getExternalAccount:externalPlatform.id];
        if (myAccount) {
            if ([myAccount.expired boolValue]) {
                //  再配置
                ExternalBindViewController *ebvc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                ebvc.platform = externalPlatform;
                ebvc.isBind = YES;
                [self.navigationController pushViewController:ebvc animated:YES];
            } else {
//                NewFriendListViewController *flvc = [[[NewFriendListViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//                flvc.platform = platform;
//                [self.navigationController pushViewController:flvc animated:YES];
                
                FriendListViewController *flvc = [[[FriendListViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                flvc.platform = platform;
                [self.navigationController pushViewController:flvc animated:YES];
            }
        } else {//配置
            ExternalBindViewController *ebvc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            ebvc.platform = externalPlatform;
            ebvc.isBind = YES;
            [self.navigationController pushViewController:ebvc animated:YES];
        }
    }
}
-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    if (self.tokenServerProxy == serverproxy) {
        AccountCom *com = (AccountCom *)serverproxy.response;
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
        //        AccountCom *com = (AccountCom *)serverproxy.response;
        //        [GlobalData sharedInstance].myAccount.externalaccounts = com.externalaccounts;
        //save token time
        [GlobalUtils saveTokenTime];
        
        [self.tableView.tableView reloadData];
        [self.tableView setNeedsDisplay];
    } 
}
-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [self.tokenServerProxy cancelAll];
}

@end
