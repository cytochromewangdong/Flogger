//
//  FloggerLayoutManager.m
//  Flogger
//
//  Created by wyf on 12-3-23.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerLayoutManager.h"
static FloggerLayoutManager* globalScreenLayout; 
//static NSArray* screenNameArray = 
@implementation FloggerLayoutManager
+(FloggerLayoutManager*) screenLayoutManager
{
    if(!globalScreenLayout)
    {
        globalScreenLayout =  [[FloggerLayoutManager alloc] init];
    }
    return globalScreenLayout;
}

-(CGRect) getLayout : (NSString *) screenName withUI:(NSString *) uiName
{
    NSMutableArray* screenNameArray = [[[NSMutableArray alloc] init] autorelease];
    [screenNameArray addObject:@"Feed"];
    
    NSMutableDictionary *feedScreenLayout = [[[NSMutableDictionary alloc] init] autorelease];
//    feedScreenLayout add
    CGRect feedTable = CGRectMake(0, 0, 320, 372);
    [feedScreenLayout setObject:[NSValue valueWithCGRect:feedTable]forKey:@"feedTable"];
    
    NSValue *testRect = [feedScreenLayout objectForKey:@"feedTable"];
    
    CGRect rect =  [testRect CGRectValue];
    return rect;
}

@end
