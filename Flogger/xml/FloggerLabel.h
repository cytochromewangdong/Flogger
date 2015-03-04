//
//  FloggerLabel.h
//  Flogger
//
//  Created by dong wang on 12-5-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloggerLayoutAdapter.h"
@interface FloggerLabel : UILabel
{
    TTImageEffect* _effect;
}
@property (nonatomic, assign) id<TapDelegate>/**/ actionDelegate;
@property (nonatomic, retain) TTImageEffect* effect;
@property (nonatomic, retain) id data;
@property (nonatomic, assign) NSString *action;
@end
