//
//  MapPoint.m
//  TingJing2
//
//  Created by jwchen on 11-10-24.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint

@synthesize title, subTitle, coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st
{
    if (self = [super init]) {
        self.coordinate = c;
        self.title = t;
        self.subTitle = st;
    }
    
    return self;
}

-(void)dealloc
{
    self.title = nil;
    self.subTitle = nil;
    [super dealloc];
}

@end
