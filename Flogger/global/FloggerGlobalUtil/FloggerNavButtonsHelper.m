//
//  FloggerNavButtonsHelper.m
//  Flogger
//
//  Created by steveli on 10/08/2012.
//  Copyright (c) 2012 atoato. All rights reserved.
//

#import "FloggerNavButtonsHelper.h"

@implementation FloggerNavButtonsHelper
+(void)addNavTwoButton:(UINavigationBar *)navigationBar leftBtton:(UIButton *)leftBtton  rightButton:(UIButton *)rightButton {
    leftBtton.titleEdgeInsets=UIEdgeInsetsMake(1, 2, 0, 0);
   //去掉上面的文字
    if ([navigationBar viewWithTag:kLable]) {
        UIView *view = [navigationBar viewWithTag:kLable];
        [view removeFromSuperview];
    }
    
    if ([navigationBar viewWithTag:kTwoView]) {
        UIView *temp = [navigationBar viewWithTag:kTwoView];
        for (UIView *sub in [temp subviews]){
            [sub removeFromSuperview];
        }
        [temp removeFromSuperview];
    }
    
    UIImage *leftImage = [[FloggerUIFactory uiFactory] createImage:SNS_TWO_BUTTON_LEFT];
    UIImage *leftImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_TWO_BUTTON_LEFT_PRESSED];
   // leftBtton.tag = leftTag;
    [leftBtton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [leftBtton setBackgroundImage:leftImageSelected forState:UIControlStateSelected];
    [leftBtton setBackgroundImage:leftImageSelected forState:UIControlStateHighlighted];
    leftBtton.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [navigationBar addSubview:leftBtton];
    
    UIImage *rightImage = [[FloggerUIFactory uiFactory] createImage:SNS_TWO_BUTTON_RIGHT];
    UIImage *rightImageSelected = [[FloggerUIFactory uiFactory] createImage:SNS_TWO_BUTTON_RIGHT_PRESSED];
    
   // rightButton.tag = rightTag;
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton setBackgroundImage:rightImageSelected forState:UIControlStateSelected];
     [rightButton setBackgroundImage:rightImageSelected forState:UIControlStateHighlighted];
    rightButton.frame = CGRectMake(leftBtton.frame.origin.x + leftBtton.frame.size.width, 0, rightImage.size.width, rightImage.size.height);
    [navigationBar addSubview:rightButton];
    
    UIView *temp=[[FloggerUIFactory uiFactory] createView];
    temp.tag=kTwoView;
    temp.frame=CGRectMake(77, 8, leftImage.size.width+rightImage.size.width, leftImage.size.height);
    [temp addSubview:leftBtton];
    [temp addSubview:rightButton];
    [navigationBar addSubview:temp];
       
    
}

@end
