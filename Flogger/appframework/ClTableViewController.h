//
//  JwBaseTableViewController.h
//  TingJing2
//
//  Created by jwchen on 11-9-17.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "ClTableView.h"

@interface ClTableViewController : BaseNetworkViewController<ClTableViewDelegate, ClTableViewDataSource>

@property (nonatomic, retain) ClTableView *tableView;

- (void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(ClTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
