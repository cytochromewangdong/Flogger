//
//  CheckGridViewCell.h
//  Flogger
//
//  Created by steveli on 10/03/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CheckGridViewCell;
@protocol CheckGridViewCellDelegate <NSObject>
-(void)selectcell:(id)sender;
@end


@interface CheckGridViewCell : UITableViewCell
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, retain) NSMutableArray   *controlArray;
@property(nonatomic, assign) id checkGridViewCellDelegate;



@end
