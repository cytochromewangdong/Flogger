//
//  GridPageView.h
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "PageView.h"
#import "FeedGridPageTableView.h"

@class FeedGridPageView;
@protocol FeedGridPageViewDelegate <NSObject>

-(void)selectFeedGridPageView:(FeedGridPageView *)feedGridPageView atPage:(NSInteger)page index:(NSInteger)index;

@end

@interface FeedGridPageView : PageView
@property(nonatomic, retain) FeedGridPageTableView *leftPageView, *rightPageView;
@property(nonatomic, assign) id /*<FeedGridPageViewDelegate>*/ delegate;
@end
