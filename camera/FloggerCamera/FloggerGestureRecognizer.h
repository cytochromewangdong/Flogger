//
//  FloggerGestureRecognizer.h
//  FloggerVideo
//
//  Created by wyf on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FloggerGestureRecognizerDirectionFirst = 1,
    FloggerGestureRecognizerDirectionSecond = 2,
    FloggerGestureRecognizerDirectionThird  = 3,
    FloggerGestureRecognizerDirectionFourth = 4
} FloggerRecognizerDirection;


@interface FloggerGestureRecognizer : UIGestureRecognizer
{
    CGPoint     _beginPoint;
    CGPoint     _currentPoint;
    CGFloat     _lineLengthSoFarTemp;
    CGFloat     _lineLengthSoFar;
    double _beginTime;
    int _status;
    
    CGFloat    _distance;
    
    CGFloat _dist;
    
    FloggerRecognizerDirection _floggerRecognizerDirection;
}

@property (nonatomic) FloggerRecognizerDirection floggerRecognizerDirection;
@property (nonatomic) CGFloat distance;
@end

@interface FloggerTiltShiftRecognizer : UIGestureRecognizer {
}
@end
