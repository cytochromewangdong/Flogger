//
//  ISIrisView.h
//  IrisViewDemo
//
//  Created by yoyokko on 11-2-27.
//  Copyright 2011 yoyokko@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ISIrisView : UIView
{
@private
    NSInteger   currentAction_;
    UIImageView *statisIrisView_;
}
@property (nonatomic, retain) UIImageView *statisIrisView;
+ (ISIrisView*)sharedInstance; 
- (void) openIris;
- (void) closeIris;
- (void) shutterIris;

@end
