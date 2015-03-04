//
//  ClRefreshableTableView.h
//  Flogger
//
//  Created by jwchen on 12-2-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClTableView.h"
#import "EGORefreshTableHeaderView.h"

@class ClRefreshableTableView;
@protocol ClRefreshableTableViewDelege <NSObject>
@required
-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView;
//-(BOOL)dataSourceIsLoading:(ClRefreshableTableView *)refreshTableView;
@end

@interface ClRefreshableTableView : ClTableView <EGORefreshTableHeaderDelegate>
@property(nonatomic, assign) id/*<ClRefreshableTableViewDelege>*/ refreshableTableDelegate;
@property(nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, retain) NSDate *lastUpdateDate;
-(void)cancelAll;
@end
