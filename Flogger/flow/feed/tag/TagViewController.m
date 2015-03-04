//
//  TagViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "TagViewController.h"
#import "AccountEntity.h"
#import "AccountServerProxy.h"
#import "EntityEnumHeader.h"

#import "LRUCache.h"

@interface TagViewController()
@property(nonatomic, retain) LRUCache *atCache;
@property(nonatomic, retain) NSMutableArray *matchedArray;
@end

@implementation TagViewController
@synthesize tagType = _tagType, searchField, delegate, atCache, matchedArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.atCache = [[[LRUCache alloc] init] autorelease];
        [self.atCache load];
        self.matchedArray = [[[NSMutableArray alloc] initWithArray:self.atCache.dataArray] autorelease];
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

-(void) adjustTagViewLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
    self.view = view;
    
    //button
    UIImage *followImage = [[FloggerUIFactory uiFactory] createImage:SNS_FOLLOW_FEED_BUTTON_BLANK];
    UIImage *followImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_HIGHLIGHTED_FOLLOW_FEED_BUTTON_BLANK];
    UIImage *popularImage = [[FloggerUIFactory uiFactory] createImage:SNS_POPULAR_FEED_BUTTON_BLANK];
    UIImage *popularImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_HIGHLIGHTED_POPULAR_FEED_BLANK];
    UIImage *featureImage = [[FloggerUIFactory uiFactory] createImage:SNS_FEATURED_FEED_BUTTON_BLANK];
    UIImage *featureImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_HIGHLIGHT_FEATURED_FEED_BLANK];
    
    UIButton *followBtn = [[FloggerUIFactory uiFactory] createHeadButton:followImage withSelImage:followImageSelected];
    [followBtn setBackgroundImage:followImageSelected forState:UIControlStateHighlighted];
    followBtn.frame = CGRectMake(10, 5, followImage.size.width, followImage.size.height);
    [followBtn setTitle:NSLocalizedString(@"Recent", @"Recent") forState:UIControlStateNormal];
    followBtn.tag = TAG_RECENT;
    [followBtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *popularBtn = [[FloggerUIFactory uiFactory] createHeadButton:popularImage withSelImage:popularImageSelected];
    [popularBtn setBackgroundImage:popularImageSelected forState:UIControlStateHighlighted];
    popularBtn.frame = CGRectMake(followBtn.frame.origin.x+followImage.size.width, 5, popularImage.size.width, popularImage.size.height);
    [popularBtn setTitle:NSLocalizedString(@"Following", @"Following") forState:UIControlStateNormal];
    popularBtn.tag = TAG_FOLLOWING;
    [popularBtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *featurebtn = [[FloggerUIFactory uiFactory] createHeadButton:featureImage withSelImage:featureImageSelected];
    [featurebtn setBackgroundImage:featureImageSelected forState:UIControlStateHighlighted];
    featurebtn.frame = CGRectMake(popularBtn.frame.origin.x+popularImage.size.width, 5, featureImage.size.width, featureImage.size.height);
    [featurebtn setTitle:NSLocalizedString(@"Followers", @"Followers") forState:UIControlStateNormal];
    featurebtn.tag = TAG_FEATURED;
    [featurebtn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIView *viewBtns = [[FloggerUIFactory uiFactory] createButtonsBackgroundView];
    viewBtns.frame = CGRectMake(0, 0, 320, 40);
     [self.view addSubview:viewBtns];
    [self.view addSubview:followBtn];
    [self.view addSubview:popularBtn];
    [self.view addSubview:featurebtn];
    
    //line
    UIView *upperLine = [[FloggerUIFactory uiFactory] createView];
    upperLine.frame =CGRectMake(0, 47, 320, 1);
    upperLine.backgroundColor = [UIColor grayColor];
    
    UITextField *searchFie = [[FloggerUIFactory uiFactory] createSearchTextField];
    searchFie.placeholder = NSLocalizedString(@"Who are you looking for", @"Who are you looking for");
    searchFie.delegate = self;
    searchFie.frame = CGRectMake(39, 48, 238, 29);    
    
    UIView *downLine = [[FloggerUIFactory uiFactory] createView];
    downLine.frame = CGRectMake(0, 100, 320, 1);
    downLine.backgroundColor = [UIColor grayColor];
    
//    [self.view addSubview:upperLine];
    [self.view addSubview:searchFie];
//    [self.view addSubview:downLine];
    
    ClPageTableView *clTableView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(0, 86, 320, 328)] autorelease];
    clTableView.delegate = self;
    clTableView.dataSource = self;
    clTableView.tableView.allowsSelection = YES;
    clTableView.pageDelegate = self;
    clTableView.refreshableTableDelegate = self;
    clTableView.idKey = @"friendshipid";
    [self.view addSubview:clTableView];
    
    [self setSearchField:searchFie];
    [self setTableView:clTableView];
//    self.tableView
    
}

-(void) refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
//    [self doRequest];
    if (self.tagType == TAG_RECENT) {
        [self updateMatchedArray];
    }
    else {
        [self doRequest];
    }
}

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    if (self.tagType == TAG_RECENT) {
        //
    } else {
        [self doRequest:YES];
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doSearch];
    [textField resignFirstResponder];
    return YES;
}

-(void)updateMatchedArray
{
    ClPageTableView *pageTableView = (ClPageTableView *) self.tableView;
    if (self.searchField.text.length==0) {
        self.atCache = [[[LRUCache alloc] init] autorelease];
        [self.atCache load];
        self.matchedArray = [[[NSMutableArray alloc] initWithArray:self.atCache.dataArray] autorelease];
        [self.tableView.dataArr removeAllObjects];
        [self.tableView.dataArr addObjectsFromArray:self.matchedArray];
        pageTableView.hasMore = NO;
        [self.tableView.tableView reloadData];
        
        
        return;
    }
    
    [self.matchedArray removeAllObjects];
    
    NSString *ketword = [self.searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString *str in self.atCache.dataArray) {
        if ([str rangeOfString:ketword options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [self.matchedArray addObject:str];
        }
    }
    
    [self.tableView.dataArr removeAllObjects];
    [self.tableView.dataArr addObjectsFromArray:self.matchedArray];
    pageTableView.hasMore = NO;
    [self.tableView.tableView reloadData];
}

#pragma mark - View lifecycle
-(void) loadView
{
  [self adjustTagViewLayout];  
}

- (void)viewDidLoad
{
    [self adjustTagViewLayout];
    [super viewDidLoad];
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Done", @"Done") image:nil];
    self.tagType = TAG_RECENT;
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
    [self setNavigationTitleView: NSLocalizedString(@"People",@"People")];
//    [self registerForTextFieldTextChangedNotification];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self unregisterForTextFieldTextChangedNotification];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString *) getSearchKeyWord
{
    NSString *string = self.searchField.text;
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return string;
}

-(void)doRequest: (BOOL)isMore
{
    
    
    if (self.loading) {
        return;
    }
    
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init]autorelease];
        self.serverProxy.delegate = self;
    }
//    else
//    {
//        [self.serverProxy cancelAll];
//    }
    
    AccountCom *com = [[[AccountCom alloc] init] autorelease];

    if ([self getSearchKeyWord].length > 0) 
    {
        com.type = [NSNumber numberWithInt: ACCOUNTCOM_USER];
    } else if (self.tagType == TAG_FOLLOWING) 
    {
        com.type = [NSNumber numberWithInt: ACCOUNTCOM_FOLLOWING];
    }else
    {
        com.type = [NSNumber numberWithInt: ACCOUNTCOM_FOLLOWER];
    }
//    NSLog(@"%@",self.searchField.text);
    if (isMore) {
        com.searchEndID = ((ClPageTableView *)self.tableView).endId;
        com.searchStartID = [NSNumber numberWithInt:-1];        
    } else {
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
    }
    
    com.keyword = [self getSearchKeyWord];//self.searchField.text;
    com.currentPage = [NSNumber numberWithInt:self.currentPage];
    com.itemNumberOfPage = [NSNumber numberWithInt:self.pageSize];
    [((AccountServerProxy *)self.serverProxy) getUserList:com];
    
}

-(void)doRequest
{
    if (self.loading) {
        return;
    }
    
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init]autorelease];
        self.serverProxy.delegate = self;
    }
    else
    {
        [self.serverProxy cancelAll];
    }
    
    AccountCom *com = [[[AccountCom alloc] init] autorelease];
    if ([self getSearchKeyWord].length > 0) 
    {
        com.type = [NSNumber numberWithInt: ACCOUNTCOM_USER];
    } else if (self.tagType == TAG_FOLLOWING) 
    {
        com.type = [NSNumber numberWithInt: ACCOUNTCOM_FOLLOWING];
    }else
    {
        com.type = [NSNumber numberWithInt: ACCOUNTCOM_FOLLOWER];
    }
//    NSLog(@"%@",self.searchField.text);
    com.keyword = [self getSearchKeyWord];//self.searchField.text;
    com.currentPage = [NSNumber numberWithInt:self.currentPage];
    com.itemNumberOfPage = [NSNumber numberWithInt:self.pageSize];
    [((AccountServerProxy *)self.serverProxy) getUserList:com];
}

-(void)doSearch
{
    /*if (self.tagType == TAG_RECENT) {
        [self updateMatchedArray];
    }
    else {
        [self doRequest];
    }*/
    if (self.tagType == TAG_RECENT && [self getSearchKeyWord].length==0) {
        ClPageTableView *pageTableView = (ClPageTableView *) self.tableView;
//        if (self.searchField.text.length==0) 
        {
            self.atCache = [[[LRUCache alloc] init] autorelease];
            [self.atCache load];
            self.matchedArray = [[[NSMutableArray alloc] initWithArray:self.atCache.dataArray] autorelease];
            [self.tableView.dataArr removeAllObjects];
            [self.tableView.dataArr addObjectsFromArray:self.matchedArray];
            pageTableView.hasMore = NO;
            [self.tableView.tableView reloadData];
        }
    } else {
        [self doRequest];
    }
}

-(void)updateSelectedBtn:(NSInteger)tag
{
    for (NSInteger i = 1; i <= 3; i ++) {
        if (tag != i) {
            [(UIButton *)[self.view viewWithTag:i] setSelected:NO];
        }
        else
        {
            [(UIButton *)[self.view viewWithTag:i] setSelected:YES];
        }
    }
}

-(void)setTagType:(TagType)tagType
{
    if (_tagType == tagType) {
        return;
    }
    _tagType = tagType;
    [self updateSelectedBtn:self.tagType];
    [self.tableView.dataArr removeAllObjects];
    
    
    if (tagType == TAG_RECENT) {
        [self.tableView.dataArr addObjectsFromArray:self.matchedArray];
    }
    else {
        [self doRequest];
    }
    
    [self.tableView.tableView reloadData];
}


-(void)btnTapped:(id)sender
{
    [self cancelNetworkRequests];
    
    self.searchField.text=@"";
    NSInteger tag = [(UIButton *)sender tag];
    self.tagType = tag;
    [self doSearch];
    [self.searchField resignFirstResponder];
    
}
-(void) myReleaseSource
{
    ((ClPageTableView *)self.tableView).pageDelegate = nil;
    ((ClPageTableView *)self.tableView).refreshableTableDelegate = nil;
    ((ClPageTableView *)self.tableView).dataSource = nil;
    ((ClPageTableView *)self.tableView).delegate = nil;
    self.tableView = nil;
    
    self.searchField.delegate = self;
    self.searchField = nil;
    self.atCache = nil;
    self.matchedArray = nil;
//    [self unregisterForTextFieldTextChangedNotification];
}

-(void)dealloc
{
    [self myReleaseSource];

    [super dealloc];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [((ClPageTableView *) self.tableView) cancelAll];
    [self.searchField resignFirstResponder];
}


-(UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = [tableView.tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier] autorelease];
    }
    
    id account = [self.tableView.dataArr objectAtIndex:[indexPath row]];
    NSString *str = nil;
    if ([account isKindOfClass:[NSString class]]) {
        str = [NSString stringWithFormat:@"%@", account];
    }
    else {
        str = [NSString stringWithFormat:@"@%@", [account valueForKey:@"username"]];
    }
    cell.textLabel.text = str;
    UILabel *lineLab = [[FloggerUIFactory uiFactory] createLable];
    lineLab.frame = CGRectMake(0, 48, 320, 1);
    lineLab.backgroundColor =  [UIColor colorWithRed:181/255.0  green:180/255.0 blue:174/255.0 alpha:1.0];
    
    UILabel *lineLab2 = [[FloggerUIFactory uiFactory] createLable];
    lineLab2.frame = CGRectMake(0, 49, 320, 1);
    lineLab2.backgroundColor =  [UIColor whiteColor];
    [cell addSubview:lineLab];
    [cell addSubview:lineLab2];
    return cell;
}

//-(void)textChanged:(id)notification
//{
//    NSLog(@"textChanged: %@", self.searchField.text);
//    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(doSearch) object:nil];
//    
//    [self performSelector:@selector(doSearch) withObject:nil afterDelay:1.0];
//}


-(void)updateView:(ClPageTableView *)tableView withResponse:(AccountCom *)response
{
    if (response.accountList && response.accountList.count > 0)
    {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
        [tableView.dataArr addObjectsFromArray:response.accountList];
    } else {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
    }
    
    if ([response.searchStartID longLongValue] == -1) {
        [tableView checkMore:response.accountList];
    }
    [tableView.tableView reloadData];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
//    [self.tableView.dataArr removeAllObjects];
//    [super transactionFinished:serverproxy];
//    [self.tableView.dataArr addObjectsFromArray:((AccountCom *)self.serverProxy.response).accountList];
//    [self.tableView.tableView reloadData];
    
    [super transactionFinished:serverproxy];
    [self updateView:(ClPageTableView *)self.tableView withResponse:(AccountCom *)serverproxy.response];
}

-(void)didSelectedUser:(NSString *)user
{
    if ((![GlobalUtils isEmpty:user]) && (![user hasPrefix:@"@"])) {
        user = [NSString stringWithFormat:@"@%@", user];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAtSelection:)]) {
        [self.delegate didAtSelection:user];
    }
    
    if (![GlobalUtils isEmpty:user]) {
        [self.atCache addObject:user];
        [self.atCache save];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightAction:(id)sender
{
    [self didSelectedUser:self.searchField.text];
}

-(void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    id account = [self.tableView.dataArr objectAtIndex:[indexPath row]];
    NSString *str = nil;
    if ([account isKindOfClass:[NSString class]]) {
        str = [NSString stringWithFormat:@"%@", account];;
    }
    else {
        str = [NSString stringWithFormat:@"@%@", [account valueForKey:@"username"]];
    }
    
    [self didSelectedUser: str];
}

@end
