//
//  JwPageViewController.h
//  TingJing2
//
//  Created by jwchen on 11-11-16.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "ClRefreshableTableViewController.h"
#import "ClPageTableView.h"
#import "BasePageParameter.h"

@interface ClPageViewController : ClRefreshableTableViewController

-(NSInteger)currentPage;
-(void)setCurrentPage:(NSInteger)currentPage;

-(NSInteger)pageSize;;
-(void)setPageSize:(NSInteger)pageSize;

-(void)updateView:(ClPageTableView *)tableView withResponse:(BasePageParameter *)response data:(NSArray *)dataArr;

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView;

@end
