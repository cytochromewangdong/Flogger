//
//  ClPageTableView.h
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClRefreshableTableView.h"
#import "ClMoreViewCell.h"

@class ClPageTableView;
@protocol ClPageTableViewDelegate <NSObject>

-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView;

@end

@interface ClPageTableView : ClRefreshableTableView
{
    BOOL _hasMore;
    BOOL _isLoadingMore;

    @private
    ClMoreViewCell *_moreViewCell;
}

@property(nonatomic, assign) BOOL isLoadingMore;
@property(nonatomic, assign) id /*<ClPageTableViewDelegate>*/ pageDelegate;
@property(nonatomic, assign) BOOL hasMore;
@property(nonatomic, retain) NSString *idKey;
@property(nonatomic, retain) NSIndexPath *currentIndexPath;

-(BOOL)isHasMore:(NSArray *)dataArray;

-(void) loadingMore;

-(void) checkMore:(NSArray *)dataArray;

-(BOOL) isCellForMore:(NSUInteger)index;

-(NSInteger)heightForMore;

-(UITableViewCell *) cellForMore:(UITableView *)tableView;

@property(nonatomic, assign) NSInteger currentPage, pageSize;

@property(nonatomic, readonly) NSNumber *startId, *endId;

@end
