//
//  SearchViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SearchViewController.h"
#import "AccountServerProxy.h"
#import "EntityEnumHeader.h"
#import "ClIconTitleTableViewCell.h"
#import "Taglist.h"
#import "TagFeedViewController.h"
#import "ProfileViewController.h"
#define SEARCHPAGESIZE 100

@implementation SearchViewController
@synthesize keywordField, userBtn, topicBtn, searchType, tagServerProxy;
@synthesize searchMode;
@synthesize currentTagInfoCom,currentAccountCom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)doSearchUser:(BOOL)isMore
{
    self.loading = YES;
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    else
    {
        [self.serverProxy cancelAll];
    }
    
    AccountCom *accountCom = [[[AccountCom alloc] init] autorelease];
    accountCom.type = [NSNumber numberWithInt:ACCOUNTCOM_USER];
    
    NSInteger pageIndex = self.currentPage;
    if (isMore) {
        pageIndex ++;
    }
    else
    {
        pageIndex = 1;
    }
    
    accountCom.currentPage = [NSNumber numberWithInt:pageIndex];
    accountCom.itemNumberOfPage = [NSNumber numberWithInt:SEARCHPAGESIZE];
    
    accountCom.keyword = self.keywordField.text;
    [((AccountServerProxy *)self.serverProxy) getUserList:accountCom];
}

-(void)doSearchTopic:(BOOL)isMore
{
    self.loading = YES;
    
    if (!self.tagServerProxy) {
        self.tagServerProxy = [[[TagInfoComServerProxy alloc] init] autorelease];
        self.tagServerProxy.delegate = self;
    }
    else
    {
        [self.tagServerProxy cancelAll];
    }
    
    TagInfoCom *tagCom = [[[TagInfoCom alloc] init] autorelease];
    NSInteger pageIndex = self.currentPage;
    if (isMore) {
        pageIndex ++;
    }
    else
    {
        pageIndex = 1;
    }
    
    tagCom.currentPage = [NSNumber numberWithInt:pageIndex];
    tagCom.itemNumberOfPage = [NSNumber numberWithInt:SEARCHPAGESIZE];
    tagCom.content = self.keywordField.text;
    tagCom.type = [NSNumber numberWithInt:1];
    [self.tagServerProxy getTaglist:tagCom];
}

-(void)doRequest:(BOOL)isMore
{
    if (searchType == SEARCH_USER) {
        [self doSearchUser:isMore];
    }
    else
    {
        [self doSearchTopic:isMore];
    }    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)textChanged:(id)notification
{
//    [self.tableView.dataArr removeAllObjects];
//    [((ClPageTableView *)self.tableView) checkMore:nil];
//    [self.tableView.tableView reloadData];
//    NSLog(@"textChanged: %@", self.keywordField.text);
//    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRequest:) object:nil];
//    [self performSelector:@selector(doRequest:) withObject:(void*)NO afterDelay:1.0];
//    [self doRequest];
}

-(void)registerForTextFieldTextChangedNotification
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(textChanged:) name: UITextFieldTextDidChangeNotification object:self.keywordField];
}

-(void)unregisterForTextFieldTextChangedNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.keywordField];
}

-(void) adjustSearchViewLayout
{
//    [[FloggerUIFactory uiFactory] createBackgroundColor];

    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 431);
//    view.frame = CGRectMake(0, 0, 320, 480);
//    view.backgroundColor = [UIColor redColor];
    self.view = view;
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    UIImage *topBarImage = [[FloggerUIFactory uiFactory] createImage:SNS_TOP_BAR];
    UIImage *cancelImage = [[FloggerUIFactory uiFactory] createImage:SNS_BUTTON];
    
    UIImage *userImage = [[FloggerUIFactory uiFactory] createImage:SNS_TOPIC];
    UIImage *userImagePress = [[FloggerUIFactory uiFactory] createImage:SNS_TOPIC_PRESSED];
    
    UIImage *topicImage = [[FloggerUIFactory uiFactory] createImage:SNS_USERS];
    UIImage *topicImagePress = [[FloggerUIFactory uiFactory] createImage:SNS_USERS_PRESSED];
    
    UIView *topBarView = [[FloggerUIFactory uiFactory] createView];
    topBarView.frame = CGRectMake(0, 0, topBarImage.size.width, topBarImage.size.height);
    [topBarView setBackgroundColor: [UIColor colorWithPatternImage:topBarImage]];
    //todo image change
    UIButton *cancelBtn = [[FloggerUIFactory uiFactory] createButton:cancelImage];
    cancelBtn.frame = CGRectMake(253, 6, cancelImage.size.width, cancelImage.size.height);
    [cancelBtn setTitle:NSLocalizedString(@"Cancel", @"Cancel") forState:UIControlStateNormal];
    cancelBtn.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [cancelBtn setTitleColor: [[[UIColor alloc] initWithRed:64/255.0 green:64/255.0 blue:62/255.0 alpha:1.0] autorelease]forState:UIControlStateNormal];
    cancelBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [cancelBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];    
    
    UITextField *searchField = [[FloggerUIFactory uiFactory] createSearchTextField];
    searchField.frame = CGRectMake(11, 6, 225, 31);
    searchField.delegate = self;
    
    
    [topBarView addSubview:cancelBtn];
    [topBarView addSubview:searchField];
    
//    UIButton *userButton = [[FloggerUIFactory uiFactory] createHeadButton:userImage withSelImage:userImagePress];
//    userButton.frame = CGRectMake(5, 54, userImage.size.width, userImage.size.height);   
//    [userButton setTitle:NSLocalizedString(@"Users", @"Users") forState:UIControlStateNormal];
//    userButton.tag = SEARCH_USER;
//    [userButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *userButton = [[FloggerUIFactory uiFactory] createHeadButton:topicImage withSelImage:topicImagePress];
     [userButton setBackgroundImage:topicImagePress forState:UIControlStateHighlighted];
    userButton.frame = CGRectMake(10,  topBarImage.size.height+5, topicImage.size.width, topicImage.size.height);   
    [userButton setTitle:NSLocalizedString(@"Users", @"Users") forState:UIControlStateNormal];
    userButton.tag = SEARCH_USER;
    [userButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *topicButton = [[FloggerUIFactory uiFactory] createHeadButton:userImage withSelImage:userImagePress];
     [topicButton setBackgroundImage:userImagePress forState:UIControlStateHighlighted];
    topicButton.frame = CGRectMake(userButton.frame.origin.x + userButton.frame.size.width, topBarImage.size.height+5, topicImage.size.width, topicImage.size.height);   
    [topicButton setTitle:NSLocalizedString(@"Topics", @"Topics") forState:UIControlStateNormal];
    topicButton.tag = SEARCH_TOPIC;
    [topicButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    ClPageTableView *clTableView;
    if (self.searchMode && self.searchMode == FROM_FIND_FRIEND) {
        clTableView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(0, 45, 320, 415)] autorelease];
    } else
    {
        clTableView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(0, 84, 320, 325)] autorelease];
            UIView *viewBtns = [[FloggerUIFactory uiFactory] createButtonsBackgroundView];
            viewBtns.frame = CGRectMake(0, topBarImage.size.height, 320, 40);
            [self.view addSubview:viewBtns];
        
    }
    
    clTableView.dataSource = self;
    clTableView.delegate = self;
    clTableView.pageSize = SEARCHPAGESIZE;
//    clTableView.backgroundColor = [UIColor blueColor];
//    clTableView.tableView.allowsSelection = YES;
//    clTableView.pageDelegate = self;
//    clTableView.refreshableTableDelegate = self;
    
    [self.view addSubview:topBarView];

    [self.view addSubview:userButton];
    [self.view addSubview:topicButton];
    [self.view addSubview:clTableView];
    
    [self setKeywordField:searchField];
    [self setUserBtn:userButton];
    [self setTopicBtn:topicButton];
    [self setTableView:clTableView];
    

//    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableView.separatorColor
//    for (UIView *view in self.view.subviews) {
//        NSLog(@"===== subviews is %@",view);
//    }
    
//    self.tableView.tableView.separatorColor
    
}

-(BOOL) checkIsFullScreen
{
    if (self.searchMode == FROM_FIND_FRIEND) {
        return YES;
    }
    return NO;
}
#pragma mark - View lifecycle
-(void) loadView
{
    [self adjustSearchViewLayout];
}

//-(void) checkisf

-(BOOL) showFirstActivityView
{
    if (self.tableView.dataArr.count > 0 || self.firstActivityOriginalY < 0) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableView.rowHeight = 60;
    self.searchType = SEARCH_USER;
    self.userBtn.selected = YES;
    self.topicBtn.selected = NO;
    
    if (self.searchMode && self.searchMode == FROM_FIND_FRIEND) {
        self.view.frame = CGRectMake(0, 0, 320, 480);
        self.userBtn.hidden = YES;
        self.topicBtn.hidden = YES;
//        self.tableView.frame = CGRectMake(0, 45, 320, 435);
//        self.tableView.tableView
        self.searchType = SEARCH_USER;
    }
    [self doRequest:NO];
    //show firstActivity
//    [self showFirstActivity];
    self.firstActivityOriginalY = self.tableView.frame.origin.y;
//    self.keywordField.delegate = self;
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self myReleaseSource];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self registerForTextFieldTextChangedNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self unregisterForTextFieldTextChangedNotification];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) myReleaseSource
{
    self.keywordField.delegate = nil;
    self.keywordField = nil;
    self.userBtn = nil;
    self.topicBtn = nil;
    self.tagServerProxy.delegate = nil;
    self.tagServerProxy = nil;
    self.currentAccountCom = nil;
    self.currentTagInfoCom = nil;
}

-(void)dealloc
{
    [self myReleaseSource];
    [super dealloc];
}

-(BOOL) stringCompareString : (NSString *) string withCompare: (NSString *) keyword
{
    if (!string && !keyword) {
        return YES;
    } else  if ([string isEqualToString:keyword]){
        return YES;
    } else {
        return NO;
    }
}

-(BOOL) restoreDataFromCurrentData
{
    NSArray *dataArr = nil;
    BOOL isRestroFromCurrent;
    if (self.searchType == SEARCH_USER) {
        if (self.currentAccountCom && [self stringCompareString:self.currentAccountCom.keyword withCompare:self.keywordField.text] ) {
            dataArr = self.currentAccountCom.accountList;
            [self.tableView.dataArr addObjectsFromArray:dataArr];
            [(ClPageTableView *)self.tableView checkMore:dataArr];
            [self.tableView.tableView reloadData];
            isRestroFromCurrent = YES;
        } else {
            isRestroFromCurrent = NO;
        }
    } else if (self.searchType == SEARCH_TOPIC){
        if (self.currentTagInfoCom && [self stringCompareString:self.currentTagInfoCom.content withCompare:self.keywordField.text]) {
            dataArr = self.currentTagInfoCom.taglit;
            [self.tableView.dataArr addObjectsFromArray:dataArr];
            [(ClPageTableView *)self.tableView checkMore:dataArr];
            [self.tableView.tableView reloadData];
            isRestroFromCurrent = YES;
        } else {
            isRestroFromCurrent = NO;
        }
    }
    return isRestroFromCurrent;
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    
    if ((self.serverProxy == serverproxy && self.searchType != SEARCH_USER) || (self.tagServerProxy == serverproxy && self.searchType != SEARCH_TOPIC)) {
        return;
    }
    
    NSArray *dataArr = nil;
    if (serverproxy == self.serverProxy) {
        dataArr = ((AccountCom *)serverproxy.response).accountList;
        self.currentAccountCom = (AccountCom *)serverproxy.response;
    }
    else
    {
        dataArr = ((TagInfoCom *)serverproxy.response).taglit;
        self.currentTagInfoCom = (TagInfoCom *)serverproxy.response;
    }
    
    BasePageParameter *result = (BasePageParameter *)serverproxy.response;
    NSInteger pageIndex = [result.currentPage intValue];
    if (pageIndex == 1) {
        [self.tableView.dataArr removeAllObjects];
    }
    
    [self.tableView.dataArr addObjectsFromArray:dataArr];
    [(ClPageTableView *)self.tableView checkMore:dataArr];
    [self.tableView.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(ClTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kClIconTitleTableViewCellHeight;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForAccountAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellUserIndentifier = @"ClIconTitleTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellUserIndentifier];
    if (!cell) {
        cell = [[[ClIconTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellUserIndentifier] autorelease];
    }
    
    MyAccount *account = [self.tableView.dataArr objectAtIndex:[indexPath row]];
    
    if (account.fname && account.fname.length > 0) {
        ((ClIconTitleTableViewCell *)cell).titleLabel.text = account.fname;
    } 
    else
    {
        ((ClIconTitleTableViewCell *)cell).titleLabel.text = account.username;
    }
    ((ClIconTitleTableViewCell *)cell).descrLabel.text = [NSString stringWithFormat:@"@%@", account.username];
    
//    ((ClIconTitleTableViewCell *)cell).titleLabel.text = account.username;
//    ((ClIconTitleTableViewCell *)cell).titleLabel.font=[[FloggerUIFactory uiFactory] createMiddleBoldFont];
//    ((ClIconTitleTableViewCell *)cell).titleLabel.text = account.fir;
    UIImage *defaultImage = [GlobalUtils getDefaultImage:account.gender];//[UIImage imageNamed:@"default_photo.png"];
    if (account.imageurl) {
        [((ClIconTitleTableViewCell *)cell).iconView setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:account.imageurl]] placeholderImage:defaultImage];
    }
    else
    {
        ((ClIconTitleTableViewCell *)cell).iconView.image = defaultImage;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForTopicAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"CellTopicIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier] autorelease];
    }
    
    Taglist *taginfo = [self.tableView.dataArr objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"#%@#", taginfo.content];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    UILabel *lineLab = [[FloggerUIFactory uiFactory] createLable];
    lineLab.frame = CGRectMake(0, 58, 320, 1);
    lineLab.backgroundColor =  [UIColor colorWithRed:181/255.0  green:180/255.0 blue:174/255.0 alpha:1.0];
    
    UILabel *lineLab2 = [[FloggerUIFactory uiFactory] createLable];
    lineLab2.frame = CGRectMake(0, 59, 320, 1);
    lineLab2.backgroundColor =  [UIColor whiteColor];
    [cell addSubview:lineLab];
    [cell addSubview:lineLab2];
    return cell;
}

-(UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchType == SEARCH_USER) {
        return [self tableView:tableView.tableView cellForAccountAtIndexPath:indexPath];
    }
    else
    {
        return [self tableView:tableView.tableView cellForTopicAtIndexPath:indexPath];
    }
}


-(void)btnClicked:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    if (searchType == tag) {
        return;
    }
    
    searchType = tag;
    
    if (searchType == SEARCH_USER) {
        [userBtn setSelected:YES];
        [topicBtn setSelected:NO];
        [self.tagServerProxy cancelAll];
    }
    else
    {
        [userBtn setSelected:NO];
        [topicBtn setSelected:YES];
        [self.serverProxy cancelAll]; 
    }
    self.currentPage = 1;
    [self.tableView.dataArr removeAllObjects];
    [(ClPageTableView *)self.tableView checkMore:nil];
    [self.tableView.tableView reloadData];
    if (![self restoreDataFromCurrentData]) {
        [self doRequest:NO];
        self.firstActivityOriginalY = self.tableView.frame.origin.y;
        [self showFirstActivity];
    }
    
}

- (void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.tableView.dataArr objectAtIndex:[indexPath row]];
    if ([data isKindOfClass:[Taglist class]]) {
        TagFeedViewController *listVc = [[[TagFeedViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        listVc.taginfo = data;
        [self.navigationController pushViewController:listVc animated:YES];
    }
    else
    {
        ProfileViewController *pvic = [[[ProfileViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        pvic.account = (MyAccount*)data;
        pvic.ismyself =  NO;
        [self.navigationController pushViewController:pvic animated:YES];
    }
}

#pragma mark textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.tableView.dataArr removeAllObjects];
    [((ClPageTableView *)self.tableView) checkMore:nil];
    [self.tableView.tableView reloadData];
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRequest:) object:nil];
    //[self performSelector:@selector(doRequest:) withObject:(void*)NO afterDelay:0];
    [self doRequest:NO];
    [textField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    [self doRequest:NO];
}

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    [self doRequest:YES];
}

@end
