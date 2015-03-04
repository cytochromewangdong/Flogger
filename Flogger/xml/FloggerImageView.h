//
//  FloggerImageView.h
//  Flogger
//
//  Created by dong wang on 12-5-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloggerLayoutAdapter.h"
@interface FloggerImageView : UIImageView
{
    TTImageEffect* _effect;
    UIViewContentMode _oldMode;
    UIColor *_backColor;
}
@property (nonatomic, assign) id<TapDelegate>/**/ actionDelegate;
@property (nonatomic, retain) TTImageEffect* effect;
@property (nonatomic, retain) UIImage* defaultImage;
@property (nonatomic, retain) id data;
@property (nonatomic, assign) BOOL applyAnimation;
@property (nonatomic, assign) NSString *action;
@property (nonatomic, assign)BOOL progressable;
@end
