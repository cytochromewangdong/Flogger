//
//  GridPageView.h
//  Flogger
//
//  Created by jwchen on 12-1-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageView.h"
#import "AQGridView.h"
#import "GlobalUtils.h"

@class GridPageView;
@protocol GridPageViewDelegate <NSObject>

-(void)gridPageView:(GridPageView *)pageView atPageIndex:(NSInteger)pageIndex index:(NSInteger)index;

@end

@interface GridPageView : PageView<AQGridViewDataSource, AQGridViewDelegate>{
    @private
    NSMutableArray *_photoArray;
    NSMutableArray *_videoArray;
}
@property(nonatomic, assign) id<GridPageViewDelegate>delegate;
@property(retain, nonatomic) AQGridView *photoGridView, *videoGridView;
@property(nonatomic, retain) NSMutableArray *photoArray, *videoArray;

-(void)reloadData;

@end
