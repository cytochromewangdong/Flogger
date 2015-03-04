//
//  JwRefreshableTableViewController.m
//  TingJing2
//
//  Created by jwchen on 11-9-19.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import "ClRefreshableTableViewController.h"
#import "ClRefreshableTableView.h"
@implementation ClRefreshableTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if (!self.tableView) {
        self.tableView = [[[ClRefreshableTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    }
    
    ((ClRefreshableTableView *)self.tableView).refreshableTableDelegate = self;
    [super viewDidLoad];
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView{
    if ([self canLoading]) {
        self.loading = YES;
        [self reloading];
    }
}

-(BOOL) canLoading
{
    return !self.loading;
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    ((ClRefreshableTableView *)self.tableView).lastUpdateDate = [NSDate date];
}

-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    [super networkFinished:serverproxy];
    ((ClRefreshableTableView *)self.tableView).lastUpdateDate = [NSDate date];
}


@end
