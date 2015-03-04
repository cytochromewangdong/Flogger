//
//  FeedbackServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-3-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#define kAddFeedbackAction @"ShareCom-AddFeedbackAction"
#define kFeedbackCom @"FeedbackCom"

#import "FeedbackServerProxy.h"

@implementation FeedbackServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kFeedbackCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kAddFeedbackAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@addFeedback", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)addFeedback:(FeedbackCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:self.keyCom forAction:kAddFeedbackAction];
    [self doRequest:task];
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[FeedbackCom alloc] init] autorelease];
}
@end
