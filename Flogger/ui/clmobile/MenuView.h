//
//  MenuView.h
//  Flogger
//
//  Created by jwchen on 11-12-8.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIControl
{
    @protected
    UIControl *topView;
    UIView *leftView;
    UIView *rightView;
    UIView *bottomView;
    
    @private
    CGRect topFrame;
    CGRect bottomFrame;
    CGRect leftFrame;
    CGRect rightFrame;
    
    CGRect topBeginFrame;
    CGRect bottomBeginFrame;
    CGRect leftBeginFrame;
    CGRect rightBeginFrame;
}

@property(nonatomic, readonly)UIView *topView, *leftView, *rightView, *bottomView;

-(void)hide;

-(void)show;

@end
