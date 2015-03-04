//
//  FeedListViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FeedListViewController.h"
#import "TagInfoComServerProxy.h"
#import "TagInfoCom.h"
#import "FeedTableView.h"

@implementation FeedListViewController
@synthesize taginfo;

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

-(void)doRequest
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[TagInfoComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    TagInfoCom *infoCom = [[[TagInfoCom alloc] init] autorelease];
    infoCom.content = self.taginfo.content;
    infoCom.currentPage = [NSNumber numberWithInt:self.currentPage];
    infoCom.itemNumberOfPage = [NSNumber numberWithInt:self.pageSize];
    
    [((TagInfoComServerProxy *)self.serverProxy) getIssueListByTag:infoCom];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    [self.tableView.dataArr addObjectsFromArray:((TagInfoCom *)(serverproxy.response)).issueInfoList];
    [self.tableView.tableView reloadData];
}


-(void) adjustFeedListViewLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
    self.view = view;
    
    ClPageTableView *feedTableView = [[[ClPageTableView alloc] init] autorelease];
    feedTableView.frame = CGRectMake(0, 0, 320, 416);
    [self.view addSubview:feedTableView];
    
    self.tableView = feedTableView;
    
}
#pragma mark - View lifecycle
-(void) loadView
{
    [self adjustFeedListViewLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self doRequest];
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
    self.taginfo = nil;
    [super dealloc];
}

@end
