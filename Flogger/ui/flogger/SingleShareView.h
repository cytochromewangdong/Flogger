//
//  SingleShareView.h
//  Flogger
//
//  Created by jwchen on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Externalplatform.h"
#import "Externalaccount.h"

@class SingleShareView;
@protocol SingleShareViewDelegate <NSObject>

-(void)singleShareView:(SingleShareView *)singleShareView platform:(Externalplatform *)platform;
-(void)singleShareViewUnBind:(SingleShareView *)singleShareView platform:(Externalplatform *)platform;


@end

@interface SingleShareView : UIView
- (id)initWithFrame:(CGRect)frame platform:(Externalplatform *)epf account:(Externalaccount *)acc;
- (id)initWithFrameShare:(CGRect)frame platform:(Externalplatform *)epf account:(Externalaccount *)acc;
@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) Externalplatform *platform;
@property(nonatomic, retain) Externalaccount *account;
@property(nonatomic, assign) BOOL isShare;

@property (nonatomic, retain) UIButton *unBindButton, *configButton;
@property (nonatomic, retain) UISwitch *switchButton;
@end
