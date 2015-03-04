//
//  FriendListViewController.m
//  Flogger
//
//  Created by jwchen on 12-3-8.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FriendListViewController.h"
#import "AccountServerProxy.h"
#import "FollowCom.h"
#import "SuggestUserViewCell.h"
#import "EntityEnumHeader.h"
#import "ProfileViewController.h"
#import "SuggestionUserViewController.h"
#import "SearchViewController.h"
#import "UIViewController+iconImage.h"
#import "IssueInfoComServerProxy.h"
extern NSString * const kFollowingChangedNotification;

@implementation FriendListViewController
@synthesize platform, followSp, type, friendSp,issueInfoComSp;
@synthesize account,accountList,issueInfoCom;

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
    if (self.type == FriendListView_Addressbook || self.type == FriendListView_ExternalPlatform) {
        return YES;
    } else {
        return NO;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.type == FriendListView_FirstScreen) {
        [self setNavigationTitleView:NSLocalizedString(@"Friends", @"Friends")];
        [self setRightNavigationBarWithTitle:NSLocalizedString(@"Next", @"Next") image:nil];
    } else if (self.type == FriendListView_Following) {
        [self setNavigationTitleView:NSLocalizedString(@"Following", @"Following")];
        if ([GlobalUtils checkIsLogin]) {
            [self setRightNavigationBarWithTitleAndImage:nil image:SNS_SEARCH_BUTTON pressimage:nil];
        }
        
    } else if(self.type == FriendListView_Follows)
    {
        [self setNavigationTitleView:NSLocalizedString(@"Followers", @"Followers")];
        if ([GlobalUtils checkIsLogin]) {
            [self setRightNavigationBarWithTitleAndImage:nil image:SNS_SEARCH_BUTTON pressimage:nil];
        }        
    }else if(self.type == FriendListVIew_Likes){
    
    [self setNavigationTitleView:NSLocalizedString(@"People", @"People")];
    }
}

-(void) rightAction:(id)sender
{
    if (![GlobalUtils checkIsLogin]) {
        [super rightAction:sender];
        return;
    }
    
    if (self.type == FriendListView_FirstScreen) {
        SuggestionUserViewController *suggestViewControl = [[[SuggestionUserViewController alloc] init] autorelease];
        suggestViewControl.isFirstScreen = YES;
        [self.navigationController pushViewController:suggestViewControl animated:YES];
    }
    if (self.type == FriendListView_Following||self.type == FriendListView_Follows) {
        SearchViewController *svc = [[[SearchViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        [self.navigationController pushViewController:svc animated:YES];
    }

    
    
}

-(void) doRequestLikes:(BOOL)isMore
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.issueInfoComSp) {
        self.issueInfoComSp = [[[IssueInfoComServerProxy alloc] init] autorelease];
        self.issueInfoComSp.delegate = self;
    }
    
//    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
//    
//    if (isMore)
//    {
//        issueInfoCom.searchEndID = [(ClPageTableView *)self.tableView endId];//self.feedView.endId;
//        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
//    }
//    else
//    {
//        issueInfoCom.searchEndID = [NSNumber numberWithInt:-1];
//        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
//    }
//    
//    //    issueInfoCom.itemNumberOfPage = [NSNumber numberWithInt:self.feedView.pageSize];
//    issueInfoCom.issueId = self.issueInfoCom.issueId;
    [self.issueInfoComSp viewLikersList:self.issueInfoCom];
}

-(void)doRequestByAddressbookInBackground
{
    if (!self.friendSp) {
        self.friendSp = [[[FindFriendServerProxy alloc] init] autorelease];
        self.friendSp.delegate = self;
    }
    FindFriendCom *com = [[[FindFriendCom alloc] init] autorelease];
    com.addressBookInfoList = [GlobalUtils getAllContacts];
    com.searchStartID = [NSNumber numberWithInt:-1];
    com.searchEndID = [NSNumber numberWithInt:-1];
    [self.friendSp findFriendsFromAddressBook:com];
}

-(void)doRequestByAddressbook
{
    [self performSelectorInBackground:@selector(doRequestByAddressbookInBackground) withObject:nil];
}

-(void)doRequestByAccount:(BOOL)isMore
{
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    AccountCom *com = [[[AccountCom alloc] init] autorelease];
    
    if (isMore) {
//        com.searchEndID = [(ClPageTableView *)self.tableView endId];
        com.searchEndID = (self.tableView.dataArr && self.tableView.dataArr.count > 0)? ((MyAccount *)[self.tableView.dataArr objectAtIndex:self.tableView.dataArr.count-1]).friendshipid : [NSNumber numberWithInt:-1];
        com.searchStartID = [NSNumber numberWithInt:-1];
    }
    else {
//        com.searchStartID = [(ClPageTableView *)self.tableView startId];
//        com.searchStartID = (self.tableView.dataArr && self.tableView.dataArr.count > 0)? ((MyAccount *)[self.tableView.dataArr objectAtIndex:0]).friendshipid : [NSNumber numberWithInt:-1];
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
    }
    com.itemNumberOfPage = [NSNumber numberWithInt:((ClPageTableView *)(self.tableView)).pageSize];
    
    if(type == FriendListView_ExternalPlatform){
        com.usersource = self.platform.id;
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
        [((AccountServerProxy *)self.serverProxy) getExternalFriends:com];
            }
    else if(type == FriendListView_Following){
        com.type = [NSNumber numberWithInt:ACCOUNTCOM_FOLLOWING];
        com.userUID = self.account.useruid;
//        NSLog(@"self.account.useruid is %@",self.account.useruid);
        [((AccountServerProxy *)self.serverProxy) getUserList:com];
    }
    else if(type == FriendListView_Follows){
        com.type = [NSNumber numberWithInt:ACCOUNTCOM_FOLLOWER];
        com.userUID = self.account.useruid;
//        NSLog(@"self.account.useruid is %@",self.account.useruid);
        [((AccountServerProxy *)self.serverProxy) getUserList:com];
    }

}

-(void)doRequest:(BOOL)isMore
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (type == FriendListView_Addressbook) {
        [self doRequestByAddressbook];
    }
    else {
        [self doRequestByAccount:isMore];
    }
}

-(void)notifyFollowingChanged
{
    NSNotification *note = [NSNotification notificationWithName:kFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    if ([self.tableView viewWithTag:300]) {
        UIView *view = [self.tableView viewWithTag:300];
        view.hidden = YES;
    }
    
    //followers following 
     if (serverproxy == self.followSp) {
         [self notifyFollowingChanged];
         return;
     }
    
    NSArray *dataArray = nil;
    if (self.serverProxy == serverproxy) {
        dataArray = [(AccountCom *)serverproxy.response accountList];

    }
    else if(self.friendSp == serverproxy){
        dataArray = [(FindFriendCom *)serverproxy.response accountList];
    }
    else if(self.issueInfoComSp == serverproxy){
        dataArray = [(IssueInfoCom *)serverproxy.response myAccountList];
    }
    
    [self updateView:(ClPageTableView *)self.tableView withResponse:(BasePageParameter *)serverproxy.response data:dataArray];
    
    if (type == FriendListView_ExternalPlatform || type == FriendListView_Addressbook) {
        [(ClPageTableView *)self.tableView isHasMore:nil];
    }
    //no result
    if (self.tableView.dataArr.count == 0) {
        if (![self.tableView viewWithTag:300]) {
            UILabel *label = [[FloggerUIFactory uiFactory] createLable];
            label.frame = CGRectMake(20, 0, 300, self.tableView.tableView.rowHeight);
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [[[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:0.7] autorelease];
            label.text = NSLocalizedString(@"No result.", @"No result.");
            label.textAlignment = UITextAlignmentCenter;
            label.tag = 300;
            [self.tableView addSubview:label];
            
//            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [[self.tableView.tableView cellForRowAtIndexPath:indexpath] addSubview:label];
        }
        [[self.tableView viewWithTag:300] setHidden:NO];
    }
}

//need to test
-(void)updateView:(ClPageTableView *)tableView withResponse:(BasePageParameter *)response data:(NSArray *)dataArr
{
    if ([response.searchEndID longLongValue] == -1) {
        [tableView.dataArr removeAllObjects];
    }
    
    if (dataArr && dataArr.count > 0)
    {
//        if ([response.searchEndID intValue] == -1) {
//            [tableView.dataArr removeAllObjects];
//        }
        [tableView.dataArr addObjectsFromArray:dataArr];
    } 
//    else {
//        if ([response.searchEndID intValue] == -1) {
//            [tableView.dataArr removeAllObjects];
//        }
//    }
//    if (tableView.dataArr.count == 0) {
//        [tableView]
//    }
    
    if ([response.searchStartID longLongValue] == -1) {
        [tableView checkMore:dataArr];
    }
    [tableView.tableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForSuggestUserCell:(NSInteger)index
{
    return [SuggestUserViewCell tableView:tableView heightForAccount:(MyAccount *)[self.tableView.dataArr objectAtIndex:index]];
}

-(CGFloat)tableView:(ClTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView.tableView heightForSuggestUserCell:[indexPath row]];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForSuggestUserRowAtIndexPath:(NSInteger)index
{
    static NSString *CellIdentifier = @"SuggestUserViewCell";
    SuggestUserViewCell *cell = [self.tableView.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[SuggestUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.delegate = self;
    }
    
    MyAccount *myAccount = [self.tableView.dataArr objectAtIndex:index];
    cell.account = myAccount;
//    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView.tableView cellForSuggestUserRowAtIndexPath:[indexPath row]];
}

-(void)suggestUserViewCell:(SuggestUserViewCell *)cell didActionOnAccount:(MyAccount *)acc
{
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
    }
}

-(void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAccount *myAccount = [self.tableView.dataArr objectAtIndex:[indexPath row]];
    ProfileViewController *vc = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.account = myAccount;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) adjustFriendListLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
    self.view = view;
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]]; 
    ClPageTableView *clTableView = nil;//[[[ClPageTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width  , self.view.frame.size.height - 49)] autorelease];
    if (self.bcTabBarController) {
        clTableView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width  , self.view.frame.size.height - 49)] autorelease];
    } else {
        clTableView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width  , self.view.frame.size.height)] autorelease];
    }
    
//    clTableView.frame = ;
    clTableView.delegate = self;
    clTableView.dataSource = self;
    clTableView.idKey = @"useruid";
    clTableView.tableView.rowHeight = 60;
    if (self.type == FriendListVIew_Likes) {
//        clTableView.refreshableTableDelegate = self;
        clTableView.pageSize = 100;
    }
    
//    clTableView.tableView.backgroundColor = [UIColor clearColor];
//    clTableView.backgroundColor = [UIColor clearColor];
//    clTableView.tableView.se = uitableviews
//    clTableView.tableView.separatorColor;
//    clTableView.tableView
//    clTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    clTableView.tableView.separatorColor = [UIColor redColor];
    [self.view addSubview:clTableView];
    
    [self setTableView:clTableView];
    
    
}
#pragma mark - View lifecycle
-(void) loadView
{
    [self adjustFriendListLayout];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            self.tableView.dataArr = self.accountList;
            [self.tableView.tableView reloadData];
        }
        default:
            break;
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    if (self.type == FriendListView_FirstScreen) {
        //alert 
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"To find your friends", @"To find your friends, Folo would like to access your address book using a secure connection.")
//                                                       delegate:self cancelButtonTitle:nil
//                                              otherButtonTitles:NSLocalizedString(@"Decline", @"Decline"), NSLocalizedString(@"Accept", @"Accept"), nil];
//        [alert show];
//        [alert release];
        
        self.tableView.dataArr = self.accountList;
        [self.tableView.tableView reloadData]; 

    } else if (self.type == FriendListVIew_Likes)
    {
        [self doRequestLikes:NO];
    }
    
    else {
        [self doRequest:NO];
    }
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    self.platform = nil;
    self.followSp.delegate = nil;
    self.followSp = nil;
    
    self.friendSp.delegate = nil;
    self.friendSp = nil;
    
    self.issueInfoComSp.delegate = nil;
    self.issueInfoComSp = nil;
    
    
    self.account = nil;
    self.issueInfoCom=nil;
    self.accountList = nil;
    [((ClPageTableView*)self.tableView) cancelAll];
//    ((ClPageTableView*)self.tableView).refreshableTableDelegate = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
    [super dealloc];
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView{
    if (self.type == FriendListVIew_Likes)
    {
        [self doRequestLikes:NO];
    } else if (self.type != FriendListView_FirstScreen)
    {
        [self doRequest:NO];
    }

    
}

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    if (self.type == FriendListVIew_Likes)
    {
        [self doRequestLikes:YES];
    } else if (self.type != FriendListView_FirstScreen) {
        [self doRequest:YES];
    }
    
}

-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
//    [self.followSp cancelAll];
    [self.friendSp cancelAll];
//    [self.tableVi]
//    ((ClPageTableView)self.tableView
//    ClPageTableView *page = (ClPageTableView *) self.tableView.tableView;
//    page.isLoadingMore = NO;
//    self.tableView.isLoading
//    @property(nonatomic, retain) FollowComServerProxy *followSp;
//    @property(nonatomic, assign) FriendListViewType type;
//    @property(nonatomic, retain) FindFriendServerProxy *friendSp;
}

@end
