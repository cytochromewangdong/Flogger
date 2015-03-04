//
//  GridTableViewCell.h
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellHeight 80


@class GridTableViewCell;
@protocol GridTableViewCellDelegate <NSObject>
-(void)selectGridTableViewCell:(GridTableViewCell *)gridTableViewCell atIndex:(NSInteger)index;
@end

@interface GridTableViewCell : UITableViewCell
@property(nonatomic, assign) id /*<GridTableViewCellDelegate>*/ delegate;
@property(nonatomic, retain) UIImageView *imageView1P, *imageView2P, *imageView3P, *imageView4P;
@property(nonatomic, retain) UIButton *imageView1, *imageView2, *imageView3, *imageView4;
@property(nonatomic, assign) NSInteger imageCount;

-(void)btnClicked:(id)sender;

-(void)reset;
@end
