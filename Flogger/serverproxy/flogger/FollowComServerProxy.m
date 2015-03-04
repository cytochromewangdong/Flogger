//
//  FollowComServerProxy.m
//  Flogger
//
//  Created by steveli on 27/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "FollowComServerProxy.h"
#import "FollowCom.h"

#define kFollowAction @"FollowCom-follow"
#define kUnFollowAction @"FollowCom-unfollow"
#define kFollowCom @"FollowCom"

@implementation FollowComServerProxy
-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kFollowCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kFollowAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@follow", [GlobalUtils serverUrl]];
    }else if ([kUnFollowAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@unFollow", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void) follow:(FollowCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:kFollowCom forAction:kFollowAction];
    [self doRequest:task];
}
-(void) unfollow:(FollowCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:kFollowCom forAction:kUnFollowAction];
    [self doRequest:task];
}


-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[FollowCom alloc] init] autorelease];
}


@end
