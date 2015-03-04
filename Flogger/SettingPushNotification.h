
    //
    //  SettingAboutViewController.h
    //  Flogger
    //
    //  Created by jwchen on 12-2-4.
    //  Copyright (c) 2012年 jwchen. All rights reserved.
    //

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"

@interface SettingPushNotification : BaseNetworkViewController<UITableViewDataSource, UITableViewDelegate , UITextViewDelegate>

@property (nonatomic, retain) UITableView *tableV;
@end
