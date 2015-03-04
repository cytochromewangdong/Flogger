//
//  JwMoreViewCell.h
//  TingJing2
//
//  Created by jwchen on 11-11-18.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClMoreViewCell : UITableViewCell
{
    UIActivityIndicatorView*  _activityIndicatorView;
    BOOL                      _animating;
}

@property (nonatomic, readonly, retain) UIActivityIndicatorView*  activityIndicatorView;
@property (nonatomic)                   BOOL                      animating;

-(void)setAnimating:(BOOL)animating force:(BOOL)isForce;

@end
