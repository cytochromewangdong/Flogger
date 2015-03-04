//
//  ShareSettingViewController.h
//  Flogger
//
//  Created by jwchen on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "SingleShareCell.h"
#import "AccountServerProxy.h"

@interface ShareSettingViewController : BaseNetworkViewController <UITableViewDataSource,UITableViewDelegate,SingleShareCellDelegate>
@property (nonatomic, retain) UITableView *tableV;
@property (nonatomic, retain) AccountServerProxy *tokenServerProxy;
@property (nonatomic, assign) bool isExpire;

@end
