//
//  FloggerButtonView.h
//  Flogger
//
//  Created by wyf on 12-5-16.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloggerLayoutAdapter.h"
@interface FloggerButtonView : UIButton
{
    TTImageEffect* _effect;
    UIViewContentMode _oldMode;
    UIColor *_backColor;
}
@property (nonatomic, assign) id<TapDelegate>/**/ actionDelegate;
@property (nonatomic, retain) TTImageEffect* effect;
@property (nonatomic, retain) UIImage* defaultImage;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) id data;
@property (nonatomic, assign) NSString *action;
@property (nonatomic, assign) BOOL applyAnimation;
@end