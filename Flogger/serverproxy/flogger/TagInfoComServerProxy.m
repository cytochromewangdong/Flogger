//
//  TagInfoComServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-2-22.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "TagInfoComServerProxy.h"

#define kTagInfoCom @"TagInfoCom"

#define kGetTaglistAction @"TagInfoCom-GetTaglistAction"
#define kGetIssuelistByTagAction @"TagInfoCom-GetIssuelistByTagAction"

@implementation TagInfoComServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kTagInfoCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kGetTaglistAction isEqualToString:action]) {
//        url = [NSString stringWithFormat:@"%@getTaglist", [GlobalUtils serverUrl]];
        url = [NSString stringWithFormat:@"%@getTaglist120", [GlobalUtils serverUrl]];
    }
    else if ([kGetIssuelistByTagAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getIssueListByTag", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)getTaglist:(TagInfoCom *)tagcom
{
    RequestTask *task = [self generateRequestTask:tagcom.dataDict key:self.keyCom forAction:kGetTaglistAction];
    [self doRequest:task];
}

-(void)getIssueListByTag:(TagInfoCom *)tagcom
{
    RequestTask *task = [self generateRequestTask:tagcom.dataDict key:self.keyCom forAction:kGetIssuelistByTagAction];
    [self doRequest:task];
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[TagInfoCom alloc] init] autorelease];
}

@end
