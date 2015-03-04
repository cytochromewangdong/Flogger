//
//  FeedGridPageTableView.h
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClGridPageTableView.h"

@interface FeedRange : NSObject
@property (assign) NSInteger startIndex;
@property (assign) NSInteger endIndex;
@property (assign) float scale;
@end

@class FeedGridPageTableView;
@protocol FeedGridPageTableViewDelegate <NSObject>
-(void)feedGridPageTableView:(FeedGridPageTableView *)feedGridPageTableView atRow:(NSInteger)row withIndex:(NSInteger)index;
@end


@interface FeedGridPageTableView : ClGridPageTableView
{
    int _my_rowCount;
}
+(void) reorderForFreeLayout:(NSMutableArray*)data;
@property(nonatomic, assign) id /*<FeedGridPageTableViewDelegate>*/ feedGridTableViewDelegate;

@end
