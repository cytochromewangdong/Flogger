//
//  FindFriendServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-3-15.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FindFriendServerProxy.h"


#define kFindFriendsFromAddressbookAction @"FindFriendCom-FindFriendsFromAddressbookAction"

#define kFindFriendCom @"FindFriendCom"


@implementation FindFriendServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kFindFriendCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kFindFriendsFromAddressbookAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@findFriendsFromAddressbook", [GlobalUtils serverUrl]];
    } 
    return url;
}

-(void)findFriendsFromAddressBook:(FindFriendCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:self.keyCom forAction:kFindFriendsFromAddressbookAction];
    [self doRequest:task];
}



-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[FindFriendCom alloc] init] autorelease];
}

@end
