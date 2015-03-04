//
//  LikeInfoComServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-2-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "LikeInfoComServerProxy.h"
#import "LikeInfoCom.h"

#define kAddLikeAction @"LikeInfoCom-AddLikeAction"
#define kDeleteLikeIssueAction @"LikeInfoCom-DeleteLikeIssueAction"

#define kLikeInfoCom @"LikeInfoCom"

@implementation LikeInfoComServerProxy
-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kLikeInfoCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kAddLikeAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@addLike", [GlobalUtils serverUrl]];
    }
    else if ([kDeleteLikeIssueAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@deleteLikeIssue", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)addLike:(LikeInfoCom *)likeInfoCom
{
    RequestTask *task = [self generateRequestTask:likeInfoCom.dataDict key:kLikeInfoCom forAction:kAddLikeAction];
    //task.requestLevel = blockLevel;
    [self doRequest:task];
}

-(void)deleteLikeIssue:(LikeInfoCom *)likeInfoCom
{
    RequestTask *task = [self generateRequestTask:likeInfoCom.dataDict key:kLikeInfoCom forAction:kDeleteLikeIssueAction];
    //task.requestLevel = blockLevel;
    [self doRequest:task];
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[LikeInfoCom alloc] init] autorelease];
}
@end
