//
//  ShareConfigurationView.h
//  Flogger
//
//  Created by jwchen on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Externalplatform.h"

@class ShareConfigurationView;
@protocol ShareConfigurationViewDelegate <NSObject>

-(void)shareConfigurationView:(ShareConfigurationView *)shareView platform:(Externalplatform *)platform;

@end

@interface ShareConfigurationView : UIView
{
    NSArray *_platformArray;
}
@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) NSArray *platformArray;
@end
