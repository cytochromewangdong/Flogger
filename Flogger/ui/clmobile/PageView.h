//
//  PageView.h
//  Flogger
//
//  Created by jwchen on 12-1-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIView<UIScrollViewDelegate>{
    BOOL _pageControlIsChangingPage;
}

@property (nonatomic, retain) UIScrollView  *scrollview;
@property (nonatomic, retain) UIPageControl *pagecontrol;

- (void)changePage:(NSNumber *)sender;

@end
