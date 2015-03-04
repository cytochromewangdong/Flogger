//
//  FeedGridTableViewCell.h
//  Flogger
//
//  Created by dong wang on 12-4-26.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyIssueInfo.h"

/*@class GridTableViewCell;
@protocol GridTableViewCellDelegate <NSObject>
-(void)selectGridTableViewCell:(GridTableViewCell *)gridTableViewCell atIndex:(NSInteger)index;
@end*/
@class FeedGridTableViewCell;
@protocol FeedGridTableViewCellDelegate <NSObject>
-(void)selectGridTableViewCell:(FeedGridTableViewCell *)gridTableViewCell atIndex:(NSInteger)index;
@end
@interface FeedGridTableViewCell : UITableViewCell
@property(nonatomic, assign) id delegate;
//@property(nonatomic, retain) UIImageView *imageView1P, *imageView2P, *imageView3P, *imageView4P;
//@property(nonatomic, retain) UIButton *imageView1, *imageView2, *imageView3, *imageView4;
@property(nonatomic, retain) NSMutableArray *imageViews;
@property(nonatomic, assign) NSInteger imageCount;
-(void) addImageToView:(BOOL) isPlay subIndex:(int) subindex X:(float) x Y:(float) y W:(float) w H:(float) h TheIssue:(MyIssueInfo*) info;
-(void)btnClicked:(id)sender;

-(void)clear;
@end
