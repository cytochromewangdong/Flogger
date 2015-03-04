//
//  FloggerDefaultStyleSheet.m
//  Flogger
//
//  Created by wyf on 12-3-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerDefaultStyleSheet.h"

@implementation FloggerDefaultStyleSheet

-(TTStyle *) flatButton : (UIControlState ) state
{
    return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4] next:
     [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
      [TTSolidBorderStyle styleWithColor:RGBCOLOR(175, 175, 175) width:1 
        next:[TTTextStyle styleWithFont:nil color:RGBCOLOR(0, 0, 0) textAlignment:UITextAlignmentCenter next:nil]]]];
}

-(UIFont*) buttonFont
{
    return [UIFont boldSystemFontOfSize:14];
}
@end
