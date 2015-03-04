//
//  ClIconTitleTableViewCell.h
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kClIconTitleTableViewCellHeight 60

@interface ClIconTitleTableViewCell : UITableViewCell
@property(nonatomic, retain) UIImageView *iconView;
@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) UILabel *descrLabel;
@end
