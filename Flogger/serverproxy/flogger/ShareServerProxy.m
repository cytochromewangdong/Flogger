//
//  ShareServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ShareServerProxy.h"

#define kShareAction @"ShareCom-ShareAction"
#define kShareCom @"ShareCom"
#define kInviteFriendAction @"inviteFriend"

@implementation ShareServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kShareCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kShareAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@share", [GlobalUtils serverUrl]];
    } else if ([kInviteFriendAction isEqualToString:action]){
        url = [NSString stringWithFormat:@"%@inviteFriend", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)share:(ShareCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:self.keyCom forAction:kShareAction];
    [self doRequest:task];
}

-(void)inviteFriend:(ShareCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:self.keyCom forAction:kInviteFriendAction];
    [self doRequest:task];
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[ShareCom alloc] init] autorelease];
}
@end
