//
//  ImageDetail.m
//  Flogger
//
//  Created by jwchen on 11-12-13.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import "ImageDetail.h"


@implementation ImageDetail
@synthesize img,date,name;

-(void)setData:(UIImage*)img:(NSString*)n:(NSString*)d
{
    self.img = img;
    self.name = n;
    self.date = d;
}

@end
