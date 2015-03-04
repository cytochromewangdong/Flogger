//
//  IssueinfoItem.m
//  Flogger
//
//  Created by jwchen on 12-2-25.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "IssueinfoItem.h"

@implementation IssueinfoItem
@synthesize info, isExpend;

-(void)dealloc
{
    self.info = nil;
    [super dealloc];
}
@end
