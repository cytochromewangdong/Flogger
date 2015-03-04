//
//  UtilityServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-2-27.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "UtilityServerProxy.h"

#define kGetLatestActivitiesAction @"UtilityCom-kGetLatestActivitiesAction"
#define kUtilityCom @"UtilityCom"

@implementation UtilityServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kUtilityCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kGetLatestActivitiesAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getLatestActivities", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)getLatestActivities:(UtilityCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:self.keyCom forAction:kGetLatestActivitiesAction];
    [self doRequest:task];
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[UtilityCom alloc] init] autorelease];
}

@end
