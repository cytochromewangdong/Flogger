//
//  TopicViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "TopicViewController.h"
#import "TagInfoComServerProxy.h"
#import "TagInfoCom.h"
#import "Taglist.h"
#define TOPICPAGESEZE 100

@implementation TopicViewController
@synthesize searchField, delegate;

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

-(void)registerForTextFieldTextChangedNotification
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(textChanged:) name: UITextFieldTextDidChangeNotification object:nil];
}

-(void)unregisterForTextFieldTextChangedNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)doRequest
{
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[TagInfoComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    else
    {
        [self.serverProxy cancelAll];
    }
    
    TagInfoCom *tagCom = [[[TagInfoCom alloc] init] autorelease];
    //NSLog(@"currentPage is %@",self.currentPage);
    tagCom.currentPage = [NSNumber numberWithInt: self.currentPage];
    tagCom.itemNumberOfPage = [NSNumber numberWithInt:TOPICPAGESEZE];
    tagCom.content = self.searchField.text;
    tagCom.type = [NSNumber numberWithInt:2];
    [(TagInfoComServerProxy *)self.serverProxy getTaglist:tagCom];
}

-(void)doRequest : (BOOL) isMore
{
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[TagInfoComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    else
    {
        [self.serverProxy cancelAll];
    }
    
    
    
    TagInfoCom *tagCom = [[[TagInfoCom alloc] init] autorelease];
    
    if (isMore) {
        tagCom.searchEndID = ((ClPageTableView *)self.tableView).endId;
        tagCom.searchStartID = [NSNumber numberWithInt:-1];        
    } else {
        tagCom.searchStartID = [NSNumber numberWithInt:-1];
        tagCom.searchEndID = [NSNumber numberWithInt:-1];
    }
    
    //NSLog(@"currentPage is %@",self.currentPage);
    tagCom.currentPage = [NSNumber numberWithInt: self.currentPage];
    tagCom.itemNumberOfPage = [NSNumber numberWithInt:TOPICPAGESEZE];
    tagCom.content = self.searchField.text;
    tagCom.type = [NSNumber numberWithInt:2];
    [(TagInfoComServerProxy *)self.serverProxy getTaglist:tagCom];
}



-(void) adjustTopicViewLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
    self.view = view;
    
    UITextField *searchFie = [[FloggerUIFactory uiFactory] createSearchTextField];
    searchFie.placeholder = NSLocalizedString(@"What topic?", @"What topic?");
    searchFie.frame = CGRectMake(41, 9, 238, 29);
    searchFie.delegate = self;
    
    [self.view addSubview:searchFie];
    
    ClPageTableView *clTableView = [[ClPageTableView alloc] initWithFrame:CGRectMake(0, 47, 320, 369)];
    clTableView.dataSource = self;
    clTableView.delegate = self;
    clTableView.tableView.allowsSelection = YES;
    clTableView.pageDelegate = self;
    clTableView.refreshableTableDelegate = self;
    clTableView.pageSize = TOPICPAGESEZE;
    [self.view addSubview:clTableView];
    
    [self setSearchField:searchFie];
    [self setTableView:clTableView];
    
}
-(void) refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    [self doRequest];
}

-(void) pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    [self doRequest:YES];
}

#pragma mark - View lifecycle
-(void) loadView
{
    [self adjustTopicViewLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Done", @"Done") image:nil];
    [self doRequest];
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
        [self setNavigationTitleView: NSLocalizedString(@"Topics",@"Topics")];
    [self registerForTextFieldTextChangedNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"topic viewwill disappear");
    [super viewWillDisappear:animated];
    [((ClPageTableView *) self.tableView) cancelAll];
    [self unregisterForTextFieldTextChangedNotification];
    [self.searchField resignFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) myReleaseSource
{
    NSLog(@"topic dealloc");
    ((ClPageTableView *) self.tableView).dataSource = nil;
    ((ClPageTableView *) self.tableView).delegate = nil;
    ((ClPageTableView *) self.tableView).pageDelegate = nil;
    ((ClPageTableView *) self.tableView).refreshableTableDelegate = nil;
    self.tableView = nil;
        
    self.searchField.delegate = nil;
    self.searchField = nil;
}

-(void)dealloc
{
    [self myReleaseSource];
    [super dealloc];
}

-(void)textChanged:(id)notification
{
//    NSLog(@"textChanged: %@", self.searchField.text);
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRequest) object:nil];
    
    [self performSelector:@selector(doRequest) withObject:nil afterDelay:1.0];
}

-(UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"topic cellforrowat index path");
    static NSString *CellIndentifier = @"CellTopicIndentifier";
    UITableViewCell *cell = [tableView.tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier] autorelease];
    }
    
    Taglist *taginfo = [self.tableView.dataArr objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"#%@#", taginfo.content];
    UILabel *lineLab = [[FloggerUIFactory uiFactory] createLable];
    lineLab.frame = CGRectMake(0, 47, 320, 1);
    lineLab.backgroundColor =  [UIColor colorWithRed:181/255.0  green:180/255.0 blue:174/255.0 alpha:1.0];
    
    UILabel *lineLab2 = [[FloggerUIFactory uiFactory] createLable];
    lineLab2.frame = CGRectMake(0, 48, 320, 1);
    lineLab2.backgroundColor =  [UIColor whiteColor];
    [cell addSubview:lineLab];
    [cell addSubview:lineLab2];
    return cell;
}

-(void)updateView:(ClPageTableView *)tableView withResponse:(TagInfoCom *)response
{
//     ((ClPageTableView *)self.tableView).hasMore = NO;
    if (response.taglit && response.taglit.count > 0)
    {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
        [tableView.dataArr addObjectsFromArray:response.taglit];
    } else {
        if ([response.searchEndID longLongValue] == -1) {
            [tableView.dataArr removeAllObjects];
        }
    }
    
    if ([response.searchStartID longLongValue] == -1) {
        [tableView checkMore:response.taglit];
    }
    if (self.searchField.text.length == 0) {
        ((ClPageTableView *)self.tableView).hasMore = NO;
    }
    NSLog(@"topic reload");
    [tableView.tableView reloadData];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    [self updateView:(ClPageTableView *)self.tableView withResponse:(TagInfoCom *)serverproxy.response];
    
//    [self.tableView.dataArr removeAllObjects];
//    [self.tableView.dataArr addObjectsFromArray:((TagInfoCom *)serverproxy.response).taglit];
//    [self.tableView.tableView reloadData];
}

-(void)didSelectedTopic:(NSString *)topic
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedTopic:)]) {
        [self.delegate didSelectedTopic:topic];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightAction:(id)sender
{
    [self didSelectedTopic:self.searchField.text];
}

-(void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectedTopic:((Taglist *)([self.tableView.dataArr objectAtIndex:[indexPath row]])).content];
}



@end
