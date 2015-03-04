//
//  JwPageViewController.m
//  TingJing2
//
//  Created by jwchen on 11-11-16.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "ClPageViewController.h"
#import "ClPageTableView.h"
#import "BasePageParameter.h"

@implementation ClPageViewController
//@synthesize currentPage, pageSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    if (!self.tableView) {
        self.tableView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
//        ((ClPageTableView *)self.tableView).currentPage = self.currentPage;
//        ((ClPageTableView *)self.tableView).pageSize = self.pageSize;
    }
    ((ClPageTableView *)self.tableView).pageDelegate = self;
    //initial cell border set none
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [super viewDidLoad];
}

-(BOOL) canLoading
{
    return [super canLoading] && !((ClPageTableView *)self.tableView).isLoadingMore;
}

-(void)networkFinished:(BaseServerProxy *)sp
{
    [super networkFinished:sp];
    ((ClPageTableView *)self.tableView).isLoadingMore = NO;
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    ((ClPageTableView *)self.tableView).currentPage = currentPage;
}

-(NSInteger)currentPage
{
    return ((ClPageTableView *)self.tableView).currentPage;
}

-(void)setPageSize:(NSInteger)pageSize
{
    ((ClPageTableView *)self.tableView).pageSize = pageSize;
}

-(NSInteger)pageSize
{
    return ((ClPageTableView *)self.tableView).pageSize;
}

-(void)updateView:(ClPageTableView *)tableView withResponse:(BasePageParameter *)response data:(NSArray *)dataArr
{
    if (!dataArr)
    {
        dataArr = [[[NSArray alloc]init]autorelease];
    }
    {
        NSMutableArray *tmpArr = nil;
        if ([response.searchStartID longLongValue] != -1) {
            tmpArr = [NSArray arrayWithArray:tableView.dataArr];
            [tableView.dataArr removeAllObjects];
        }
        
        [tableView.dataArr addObjectsFromArray:dataArr];
        if (tmpArr && dataArr.count < tableView.pageSize) {
            [tableView.dataArr addObjectsFromArray:tmpArr];
        }
    }
    
    if ([response.searchStartID longLongValue] == -1) 
    {
        [tableView checkMore:dataArr];
    }
    
    [tableView.tableView reloadData];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    BasePageParameter *result = (BasePageParameter *)serverproxy.response;
    self.currentPage = [result.currentPage intValue];
}

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    
}

@end
