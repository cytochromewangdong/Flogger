//
//  FindFriendSelectionViewController.h
//  Flogger
//
//  Created by jwchen on 12-3-8.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClTableViewController.h"
#import "AccountServerProxy.h"
@interface FindFriendSelectionViewController : ClTableViewController
@property (nonatomic, retain) AccountServerProxy *tokenServerProxy;


@end
