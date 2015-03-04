//
//  FeedServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-1-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "IssueInfoComServerProxy.h"
#import "IssueInfoCom.h"

#define kIssueListAction @"Feed-IssueListAction"
#define kIssuePopularListAction @"Feed-IssuePopularListAction"
#define kIssueResponseListAction @"Feed-IssueResponseListAction"
#define kGetThreadAction @"Feed-kGetThreadAction"
#define kIssueLikeListAction @"Feed-IssueLikeListAction"
#define kGetPopularUserMediaAction @"Feed-getPopularUserMediaAction"
#define kIssueDeleteLikeAction @"IssueDeleteLikeAction"
#define kAccountProfileAction @"Profile-AccountProfileAction"
#define kDeleteIssueInfoAction @"deleteIssueInfoAction"
#define kGetProfileThread @"getProfileThread"
#define kLikeInfos @"likeInfos"
#define kIssueInfoCom @"IssueInfoCom"

@implementation IssueInfoComServerProxy
//@synthesize issueInfoCom = _issueInfoCom;

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kIssueInfoCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kIssuePopularListAction isEqualToString:action]) {
//        url = [NSString stringWithFormat:@"%@getPopularMedia", [GlobalUtils serverUrl]];
        //101 version
        url = [NSString stringWithFormat:@"%@getPopularMedia101", [GlobalUtils serverUrl]];
    }
    else if([kIssueListAction isEqualToString:action]) {
//        url = [NSString stringWithFormat:@"%@getIssueList", [GlobalUtils serverUrl]];
        //101 version
        url = [NSString stringWithFormat:@"%@getIssueList101", [GlobalUtils serverUrl]];
    }
    else if([kIssueResponseListAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getResponseIssueList", [GlobalUtils serverUrl]];
    }
    else if([kIssueLikeListAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getLikeList", [GlobalUtils serverUrl]];
    }
    else if([kGetPopularUserMediaAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getPopularUserMedia", [GlobalUtils serverUrl]];
    }else if([kIssueDeleteLikeAction isEqualToString:action]){
        url = [NSString stringWithFormat:@"%@deleteLikeIssue", [GlobalUtils serverUrl]];
    }else if([kAccountProfileAction isEqualToString:action]){
        url = [NSString stringWithFormat:@"%@getAccountProfile", [GlobalUtils serverUrl]];
    }else if([kGetThreadAction isEqualToString:action]){
        url = [NSString stringWithFormat:@"%@getThread", [GlobalUtils serverUrl]];
    }else if([kDeleteIssueInfoAction isEqualToString:action])
    {
        url = [NSString stringWithFormat:@"%@deleteIssue",[GlobalUtils serverUrl]];
    }else if ([kGetProfileThread isEqualToString:action])
    {
//        url = [NSString stringWithFormat:@"%@getProfileThread",[GlobalUtils serverUrl]];
        //101 version
        url = [NSString stringWithFormat:@"%@getProfileThread101",[GlobalUtils serverUrl]];
    }else if([kLikeInfos isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getLikersInfo", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)doSendTask:(IssueInfoCom *)issueInfoCom withAction:(NSString *)action
{
    RequestTask *task = [self generateRequestTask:issueInfoCom.dataDict key:kIssueInfoCom forAction:action];
    [self doRequest:task];
}

-(void)getResponseIssueList:(IssueInfoCom *)issueInfoCom
{
    [self doSendTask:issueInfoCom withAction:kIssueResponseListAction];
}

-(void)getThread:(IssueInfoCom *)issueInfoCom
{
    [self doSendTask:issueInfoCom withAction:kGetThreadAction];
}

-(void) deleteIssueInfo : (IssueInfoCom *)issueInfoCom
{
    [self doSendTask:issueInfoCom withAction:kDeleteIssueInfoAction];
}

-(void)getPopularMedia:(IssueInfoCom *)issueInfoCom
{
    RequestTask *task = [self generateRequestTask:issueInfoCom.dataDict key:kIssueInfoCom forAction:kIssuePopularListAction];
    [self doRequest:task];
}

-(void)getIssueList:(IssueInfoCom *)issueInfoCom
{
    RequestTask *task = [self generateRequestTask:issueInfoCom.dataDict key:kIssueInfoCom forAction:kIssueListAction];
    [self doRequest:task];
}

-(void)getAccountProfile:(IssueInfoCom *)issueInfoCom
{
    RequestTask *task = [self generateRequestTask:issueInfoCom.dataDict key:kIssueInfoCom forAction:kAccountProfileAction];
    [self doRequest:task];
}

-(void)getProfileThread:(IssueInfoCom *)issueInfoCom
{
    RequestTask *task = [self generateRequestTask:issueInfoCom.dataDict key:kIssueInfoCom forAction:kGetProfileThread];
    [self doRequest:task];
}


-(void)getLikeList:(IssueInfoCom *)issueInfoCom
{
    RequestTask *task = [self generateRequestTask:issueInfoCom.dataDict key:kIssueInfoCom forAction:kIssueLikeListAction];
    [self doRequest:task];
}

-(void)getPopularUserMedia:(IssueInfoCom *)issueInfoCom
{
    RequestTask *task = [self generateRequestTask:issueInfoCom.dataDict key:kIssueInfoCom forAction:kGetPopularUserMediaAction];
    [self doRequest:task];
}

-(void)deleteLikeList:(IssueInfoCom *)issueInfoCom
{
    RequestTask *task = [self generateRequestTask:issueInfoCom.dataDict key:kIssueInfoCom forAction:kIssueDeleteLikeAction];
    [self doRequest:task];
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[IssueInfoCom alloc] init] autorelease];
}
-(void)viewLikersList:(IssueInfoCom *)com
{
    
    RequestTask *task = [self generateRequestTask:com.dataDict key:self.keyCom forAction:kLikeInfos];
    [self doRequest:task];
    
}
-(void)dealloc
{
//    RELEASE_SAFELY(_issueInfoCom);
    [super dealloc];
}
@end
