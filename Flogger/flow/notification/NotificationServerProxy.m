//
//  NotificationServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "NotificationServerProxy.h"
#import "NotificationCom.h"

#define kGetNotificationAction @"Account-getNotification"
#define kNotificationCom @"NotificationCom"

@implementation NotificationServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kNotificationCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kGetNotificationAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getNotification", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)getNotification:(NotificationCom *)notificationCom
{
    RequestTask *task = [self generateRequestTask:notificationCom.dataDict key:self.keyCom forAction:kGetNotificationAction];
    [self doRequest:task];
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[NotificationCom alloc] init] autorelease];
}
@end
