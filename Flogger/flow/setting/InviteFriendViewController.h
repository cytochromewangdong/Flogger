//
//  InviteFriendViewController.h
//  Flogger
//
//  Created by wyf on 12-6-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
#import "SingleShareCell.h"

@interface InviteFriendViewController : BaseNetworkViewController <UITableViewDataSource,UITableViewDelegate,SingleShareCellDelegate>
@property (nonatomic, retain) UITableView *tableV;

@end
