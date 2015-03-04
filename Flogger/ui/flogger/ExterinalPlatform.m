//
//  ExterinalPlatform.m
//  Flogger
//
//  Created by jwchen on 12-3-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ExterinalPlatform.h"

@implementation ExterinalPlatform
@synthesize size, platformArr;

-(void) dealloc
{
    self.platformArr = nil;
    [super dealloc];
}

@end
