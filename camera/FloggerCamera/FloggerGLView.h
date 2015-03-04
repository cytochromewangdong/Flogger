//
//  FloggerGLView.h
//  FloggerVideo
//
//  Created by wyf on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FloggerGLViewDelegate
@optional
- (void)tapToFocus:(CGPoint)point;
- (void)tapToExpose:(CGPoint)point;
- (void)resetFocusAndExpose;
-(void)cycleGravity;
@end

@interface FloggerGLView : UIView
{
    id <FloggerGLViewDelegate> _delegate;
}

@property (nonatomic,assign) id <FloggerGLViewDelegate> delegate;

@end
