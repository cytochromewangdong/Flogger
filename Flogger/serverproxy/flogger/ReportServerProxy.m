//
//  ReportServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-2-27.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ReportServerProxy.h"

#define kAddReportAction @"ReportCom-kAddReportAction"
#define kReportCom @"ReportCom"

@implementation ReportServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kReportCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kAddReportAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@addReport", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)addReport:(ReportCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:self.keyCom forAction:kAddReportAction];
    [self doRequest:task];
}


-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[ReportCom alloc] init] autorelease];
}
@end
