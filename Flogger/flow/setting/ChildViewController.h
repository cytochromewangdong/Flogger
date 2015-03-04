//
//  ChildViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#define kWebTitle @"webTitle"
#define kWebURLPath @"urlPath"

@interface ChildViewController : BaseViewController

@property (nonatomic, retain) NSMutableDictionary *webInfoDic;
@end
