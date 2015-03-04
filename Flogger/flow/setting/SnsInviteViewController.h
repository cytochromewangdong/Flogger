//
//  SnsInviteViewController.h
//  Flogger
//
//  Created by wyf on 12-6-26.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
#import "Externalplatform.h"

@interface SnsInviteViewController : BaseNetworkViewController <UITextViewDelegate>
@property (nonatomic, retain) UITextView *messageTextV;
@property(nonatomic, retain) Externalplatform *platform;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, assign) BOOL isFromLogin;

@end
