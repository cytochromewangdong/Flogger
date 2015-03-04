//
//  FloggerGestureRecognizer.m
//  FloggerVideo
//
//  Created by wyf on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FloggerGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "CGPointUtils.h"


#define kMinimum    10
#define kMinimumLength   50
#define kMinimumDistance   10
#define kMinimumTime   0.6
#define kSudu 20

@implementation FloggerGestureRecognizer
@synthesize floggerRecognizerDirection = _floggerRecognizerDirection;
@synthesize distance = _distance;


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    _beginPoint = point;
    _lineLengthSoFar = 0.0f;
            self.state = UIGestureRecognizerStateBegan;
    [self setDistance:0.0f];
    _status = 0;
    _dist = 0;
    
    _beginTime = [event timestamp];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [super touchesMoved:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//    CGPoint currentPoint = [touch locationInView:self.view];
//    CGFloat tempFloat = distanceBetweenPoints(_beginPoint, currentPoint);
//    if (tempFloat > 10) {
//        [self setFloggerRecognizerDirection: 0];
        self.state = UIGestureRecognizerStateEnded;
//    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"=====move====");
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    CGPoint lastPoint = [touch previousLocationInView:self.view];
    _lineLengthSoFar += distanceBetweenPoints(_beginPoint, currentPoint);
    
    _lineLengthSoFarTemp += distanceBetweenPoints(lastPoint, currentPoint);
    
    if (_lineLengthSoFarTemp > 8) {
//        CGFloat distanceTemp = distanceBetweenPoints(lastPoint, currentPoint);
            if ((currentPoint.x - lastPoint.x) > 0) {
                _dist = _lineLengthSoFarTemp;
            } else
            {
                _dist = -_lineLengthSoFarTemp;
            }
        _lineLengthSoFarTemp = 0;
        [self setDistance:_dist];
        self.state = UIGestureRecognizerStateChanged;
    }
    
//    CGFloat distance = distanceBetweenPoints(_beginPoint, currentPoint);
//    if ((currentPoint.x - _beginPoint.x) > 0) {
//        distance = distance;
//    } else
//    {
//        distance = -distance;
//    }
//    [self setDistance:distance];
//    if (distance > kMinimumDistance) {
//        distance = distanceBetweenPoints(lastPoint, currentPoint);
//    CGFloat distanceTemp = distanceBetweenPoints(lastPoint, currentPoint);
//        double timeInterval = event.timestamp - _beginTime;
//        double vol = _dist / timeInterval;
////        NSLog(@"=======time is %f",timeInterval);
////        if (vol > kSudu)
//        {
////            if ((currentPoint.x - _beginPoint.x) > 0 &&((currentPoint.x - lastPoint.x) > 0)) {
//            if ((currentPoint.x - lastPoint.x) > 0) {
//                _dist += distanceTemp;
//            } else
//            {
////                _dist = 0;
//                _dist -= distanceTemp;
//            }
//
//            NSLog(@"=======distance=== %f",_dist);
//            [self setDistance:_dist];
//             self.state = UIGestureRecognizerStateChanged;
////            return;
//        }
//    } 
//    else
//    {
//        _status = 1;
//    }
    
//    if ([touches count] > 1) {
//        NSLog(@"gefw");
//        CGFloat distance = distanceBetweenPoints(_beginPoint, currentPoint);
//        [self setDistance:distance];
//        self.state = UIGestureRecognizerStateChanged;
//    }
    
    if (_lineLengthSoFar > kMinimumLength) {
        if ((currentPoint.x - _beginPoint.x) > kMinimum && (currentPoint.y - _beginPoint.y) > kMinimum) {
//            NSLog(@"44444");
            [self setFloggerRecognizerDirection: FloggerGestureRecognizerDirectionFourth];
        }
        if ((currentPoint.x - _beginPoint.x) > kMinimum && (currentPoint.y - _beginPoint.y) < -kMinimum) {
            [self setFloggerRecognizerDirection:FloggerGestureRecognizerDirectionFirst];
//            NSLog(@"11111");
        }
        
        if ((currentPoint.x - _beginPoint.x) < -kMinimum && (currentPoint.y - _beginPoint.y) > kMinimum) {
//            NSLog(@"3333");
            [self setFloggerRecognizerDirection:FloggerGestureRecognizerDirectionThird];
        }
        if ((currentPoint.x - _beginPoint.x) < -kMinimum && (currentPoint.y - _beginPoint.y) < -kMinimum) {
//            NSLog(@"22222");
            [self setFloggerRecognizerDirection:FloggerGestureRecognizerDirectionSecond];
        }
        self.state = UIGestureRecognizerStateChanged;
        
    }
    
//    CGFloat angle = angleBetweenLines(lastPreviousPoint,
//                                      lastCurrentPoint,
//                                      previousPoint,
//                                      currentPoint);
//    if (angle >= kMinimumCheckMarkAngle && angle <= kMaximumCheckMarkAngle
//        && lineLengthSoFar > kMinimumCheckMarkLength) {
//        self.state = UIGestureRecognizerStateEnded;
//    }
//    lineLengthSoFar += distanceBetweenPoints(previousPoint, currentPoint);
//    lastPreviousPoint = previousPoint;
//    lastCurrentPoint = currentPoint;
}


@end

@implementation FloggerTiltShiftRecognizer
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [touches count]
   
    if ([[event allTouches] count] == 1) {
//         NSLog(@"toucher begin count is %d",[[event allTouches] count]);
        self.state = UIGestureRecognizerStateBegan;
    }
    

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([[event allTouches] count] == 1) {
//        NSLog(@"toucher move count is %d",[[event allTouches] count]);
        self.state = UIGestureRecognizerStateChanged;
    }
    
    
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[event allTouches] count] == 1) {
//        NSLog(@"toucher end count is %d",[[event allTouches] count]);
        self.state = UIGestureRecognizerStateEnded;
    }
}


@end
