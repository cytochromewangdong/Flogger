//
//  ExternalPlatformServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-2-25.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ExternalPlatformServerProxy.h"

#define kGetExternalPlatformAction @"ExternalPlatformCom-kGetExternalPlatformAction"
#define kExternalPlatformCom @"ExternalPlatformCom"

@implementation ExternalPlatformServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kExternalPlatformCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kGetExternalPlatformAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getExternalPlatform", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)getExternalPlatform:(ExternalPlatformCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:self.keyCom forAction:kGetExternalPlatformAction];
    task.requestLevel = backgroundLevel;
    [self doRequest:task];
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[ExternalPlatformCom alloc] init] autorelease];
}

@end
