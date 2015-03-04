//
//  ClIconTitleTableViewCell.m
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClIconTitleTableViewCell.h"

@implementation ClIconTitleTableViewCell
@synthesize iconView, titleLabel,descrLabel;

-(void) adjustIconTitleLayout
{
    UIImageView *iconImageView = [[FloggerUIFactory uiFactory] createImageView:nil];
//    iconImageView.frame = CGRectMake(5, 4, 51, 51);
    iconImageView.layer.cornerRadius = 3;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.frame = CGRectMake(10, 10, 40, 40);
    
    UILabel *titleLab = [[FloggerUIFactory uiFactory] createLable];
//    titleLab.frame = CGRectMake(64, 5, 249, 50);
//    titleLab.textAlignment = UITextAlignmentLeft;
    titleLab.frame = CGRectMake(60, 17, 170, 17);
    titleLab.textAlignment = UITextAlignmentLeft;
    titleLab.font = [UIFont boldSystemFontOfSize: 16];
    titleLab.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
    
    UILabel *descLab = [[FloggerUIFactory uiFactory] createLable];
    descLab.frame = CGRectMake(60, 31, 170, 15);
    descLab.textAlignment = UITextAlignmentLeft;
    descLab.font = [UIFont systemFontOfSize: 12];
    descLab.textColor = [[FloggerUIFactory uiFactory] createDescFontColor];//[[UIColor alloc] initWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];

    UILabel *lineLab = [[FloggerUIFactory uiFactory] createLable];
    lineLab.frame = CGRectMake(0, 58, 320, 1);
    lineLab.backgroundColor =  [UIColor colorWithRed:181/255.0  green:180/255.0 blue:174/255.0 alpha:1.0];
//    lineLab.backgroundColor =  [[FloggerUIFactory uiFactory] createDescFontColor];
    
    UILabel *lineLab2 = [[FloggerUIFactory uiFactory] createLable];
    lineLab2.frame = CGRectMake(0, 59, 320, 1);
        //    lineLab.backgroundColor =  [UIColor colorWithRed:185/255  green:186/255 blue:178/255 alpha:1.0];
    lineLab2.backgroundColor =  [UIColor whiteColor];
    

    
    
    [self addSubview:iconImageView];
    [self addSubview:titleLab];
    [self addSubview:descLab];
    [self addSubview:lineLab];
    [self addSubview:lineLab2];
    
    [self setIconView:iconImageView];
    [self setTitleLabel:titleLab];
    [self setDescrLabel:descLab];
    
    
//    UIImageView *iconImageV = [[FloggerUIFactory uiFactory] createImageView:iconImage];
//    iconImageV.layer.cornerRadius = 3;
//    iconImageV.layer.masksToBounds = YES;
//    iconImageV.frame = CGRectMake(10, 10, 40, 40);
//    
//    UILabel *userLab = [[FloggerUIFactory uiFactory] createLable];
//    userLab.frame = CGRectMake(60, 17, 170, 17);
//    userLab.textAlignment = UITextAlignmentLeft;
//    userLab.font = [UIFont boldSystemFontOfSize: 16];
//    userLab.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
//        //    userLab.font = [[FloggerUIFactory uiFactory] createSmallBoldFont];
//    
//    UILabel *followLab = [[FloggerUIFactory uiFactory] createLable];
//    followLab.frame = CGRectMake(60, 31, 170, 15);
//    followLab.textAlignment = UITextAlignmentLeft;
//    followLab.font = [UIFont systemFontOfSize: 12];
//    followLab.textColor = [[FloggerUIFactory uiFactory] createDescFontColor];//[[UIColor alloc] initWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
//    
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self adjustIconTitleLayout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    self.iconView = nil;
    self.titleLabel = nil;
    self.descrLabel = nil;
    [super dealloc];
}

@end
