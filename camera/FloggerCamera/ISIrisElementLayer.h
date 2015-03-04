//
//  ISIrisElementLayer.h
//  IrisViewDemo
//
//  Created by yoyokko on 11-2-25.
//  Copyright 2011 yoyokko@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface ISIrisElementLayer : CALayer
{
@private
    NSUInteger  layerIndex_;
}

@property (nonatomic) NSUInteger layerIndex;
- (void) resetTransform;

- (CGPoint) originAtIndex:(int) i
               withRadius:(CGFloat) radius
          withCenterPoint:(CGPoint) center
                withAngle:(double) angle;

@end
