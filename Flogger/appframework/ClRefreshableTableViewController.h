//
//  JwRefreshableTableViewController.h
//  TingJing2
//
//  Created by jwchen on 11-9-19.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import "ClTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ClRefreshableTableView.h"

@interface ClRefreshableTableViewController : ClTableViewController

-(BOOL) canLoading;

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView;

@end
