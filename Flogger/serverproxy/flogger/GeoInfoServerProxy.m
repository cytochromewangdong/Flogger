//
//  GeoInfoServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-3-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "GeoInfoServerProxy.h"
#define kGeoInfoCom @"GeoInfoCom"
#define kGetGeoInfoAction @"GeoInfoCom-GetGeoInfoAction"

@implementation GeoInfoServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kGeoInfoCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kGetGeoInfoAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getGeoInfo", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)getGeoInfo:(GeoInfoCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:self.keyCom forAction:kGetGeoInfoAction];
    [self doRequest:task];
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[GeoInfoCom alloc] init] autorelease];
}

@end
