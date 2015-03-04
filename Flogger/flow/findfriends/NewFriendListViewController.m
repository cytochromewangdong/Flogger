//
//  NewFriendListViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "NewFriendListViewController.h"
#import "SettingAboutViewController.h"
#import "SettingAccountViewController.h"
#import "SettingFeedBackViewController.h"
#import "ShareSettingViewController.h"
#import "FloggerAppDelegate.h"
#import "FavortiesViewController.h"
#import "FindFriendSelectionViewController.h"
#import "SuggestionUserViewController.h"
#import "GlobalData.h"
#import "InviteFriendViewController.h"
#import "SettingPushNotification.h"
#import "ExternalFriendGroup.h"
#import "SuggestUserViewCell.h"
#import "ProfileViewController.h"
#import "FollowCom.h"
extern NSString * const kFollowingChangedNotification;
@interface NewFriendListViewController()
-(void) myReleaseSource;
@end
@implementation NewFriendListViewController

@synthesize data;
@synthesize followSp;

-(void)suggestUserViewCell:(SuggestUserViewCell *)cell didActionOnAccount:(MyAccount *)acc
{
    //    cell.mode=ComeFromNewFriendListView;
    if (!self.followSp) {
        self.followSp = [[[FollowComServerProxy alloc] init] autorelease];
        self.followSp.delegate = self;
    }
    FollowCom *com = [[[FollowCom alloc] init] autorelease];
    com.requestedUserUID = acc.useruid;
    
    if ([acc.followed boolValue]) {
        [self.followSp unfollow:com];
    }
    else
    {
        [self.followSp follow:com];
        [cell.followBtn setHidden:YES];
    }
}

-(void)notifyFollowingChanged
{
    NSNotification *note = [NSNotification notificationWithName:kFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    
    //followers following 
    if (serverproxy == self.followSp) {
        [self notifyFollowingChanged];
        return;
    }
    
}

-(void)dealloc
{
    [self myReleaseSource];
    [super dealloc];
}

-(void) myReleaseSource
{
    
    self.data = nil;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:NSLocalizedString(@"New Friends", @"New Friends")];
    
}
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

#pragma mark - View lifecycle
-(void) loadView
{
//    UIImage *backgroundImage = [[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND];
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
    
    self.view = view;  
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain] autorelease];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 60;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}


- (void)viewDidLoad
{ 
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self myReleaseSource];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"SuggestFriendViewCell";
    
    SuggestUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[SuggestUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.delegate = self;
    }
    
    ExternalFriendGroup* externalFriendGroup = [self.data objectAtIndex:[indexPath section]];
    MyAccount *myAccount = [externalFriendGroup.externalfriendsList objectAtIndex:[indexPath row]] ;
    
     cell.account = myAccount;//必须放在if之前，因为setAccount有update
    if ([myAccount.followed boolValue]) {
        [cell.followBtn setHidden:YES];
    }
   
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExternalFriendGroup* externalFriendGroup = [self.data objectAtIndex:[indexPath section]];
    MyAccount *myAccount = [externalFriendGroup.externalfriendsList objectAtIndex:[indexPath row]] ;
    ProfileViewController *vc = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.account = myAccount;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ExternalFriendGroup* externalFriendGroup = [self.data objectAtIndex:section];
    return externalFriendGroup.usersourcename;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ExternalFriendGroup* externalFriendGroup = [self.data objectAtIndex:section];
    return externalFriendGroup.externalfriendsList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SuggestUserViewCell tableView:tableView heightForAccount:nil];;
}
@end




