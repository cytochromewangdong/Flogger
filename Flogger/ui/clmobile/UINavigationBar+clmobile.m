//
//  UINavigationBar+clmobile.m
//  Flogger
//
//  Created by jwchen on 12-1-20.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "UINavigationBar+clmobile.h"

@implementation UINavigationBar (clmobile)
- (void)drawRect:(CGRect)rect {  
    UIImage *image = [UIImage imageNamed:SNS_TOP_BAR];  
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
}  
@end
