//
//  ActivitiesEntity.m
//  Flogger
//
//  Created by jwchen on 12-3-6.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ActivitiesEntity.h"

@implementation ActivitiesEntity
@synthesize user, actionType, category, activities;

-(void)dealloc
{
    self.user = nil;
    self.activities = nil;
    [super dealloc];
}

@end
