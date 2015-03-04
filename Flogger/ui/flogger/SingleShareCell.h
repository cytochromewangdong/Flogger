//
//  SingleShareCell.h
//  Flogger
//
//  Created by wyf on 12-4-15.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Externalplatform.h"
//#import "Externalaccount.h"
#import "MyExternalaccount.h"
#import "MyExternalPlatform.h"

@class SingleShareCell;
@protocol SingleShareCellDelegate <NSObject>
@optional
-(void)singleShareView:(SingleShareCell *)singleShareView platform:(MyExternalPlatform *)platform;
-(void)singleShareViewUnBind:(SingleShareCell *)singleShareView platform:(MyExternalPlatform *)platform;
@end

@interface SingleShareCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier platform:(MyExternalPlatform *)epf account:(MyExternalaccount *)acc;

@property(nonatomic, assign) id<SingleShareCellDelegate> delegate;
@property(nonatomic, retain) MyExternalPlatform *platform;
@property(nonatomic, retain) MyExternalaccount *account;
@property(nonatomic, assign) BOOL isShare;
@property (nonatomic, retain) UIButton *unBindButton, *configButton;
@property (nonatomic, retain) UISwitch *switchButton;
@property (nonatomic, retain) UIImageView *iconImage;
@property (nonatomic, retain) UILabel *stringLabel;
@end
