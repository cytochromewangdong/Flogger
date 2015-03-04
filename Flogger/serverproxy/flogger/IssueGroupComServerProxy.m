//
//  IssueGroupComServerProxy.m
//  Flogger
//
//  Created by steveli on 17/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "IssueGroupComServerProxy.h"
#import "IssueGruopCom.h"
#import "IssueInfoCom.h"

#define kAlbumListAction   @"Album-IssueGroupInfoListAction"
#define kGetAlbumInfoAction   @"Album-kGetAlbumInfoAction"
#define kAddAlbumAction    @"Album-Add"
#define kDeleteAlbumAction @"Album-Delete"
#define kSetAlbumAction    @"Album-Set"
#define kIssueGruopCom     @"IssueGruopCom"


@implementation IssueGroupComServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kIssueGruopCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kAlbumListAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getGroupInfo", [GlobalUtils serverUrl]];
    }else if([kSetAlbumAction isEqualToString:action]){
        url = [NSString stringWithFormat:@"%@setGroupInfo", [GlobalUtils serverUrl]];
    }
    else if ([kGetAlbumInfoAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getAlbumInfo", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[IssueGruopCom alloc] init] autorelease];
}

-(void)doSendTask:(IssueGruopCom *)issueGruopCom withAction:(NSString *)action
{
    RequestTask *task = [self generateRequestTask:issueGruopCom.dataDict key:kIssueGruopCom forAction:action];
    [self doRequest:task];
}

-(void)getAlbumInfoList:(IssueGruopCom *)issueGroupCom
{
    RequestTask *task = [self generateRequestTask:issueGroupCom.dataDict key:kIssueGruopCom forAction:kAlbumListAction];
    [self doRequest:task];

}

-(void)getAlbumInfo:(IssueGruopCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:kIssueGruopCom forAction:kGetAlbumInfoAction];
    [self doRequest:task];
}

-(void)addAlbum:(IssueGruopCom*)issueGroupCom
{
    issueGroupCom.type = [NSNumber numberWithInt:Album_Add];
    RequestTask *task = [self generateRequestTask:issueGroupCom.dataDict key:kIssueGruopCom forAction:kSetAlbumAction];
    [self doRequest:task];
}

-(void)deleteAlbum:(IssueGruopCom*)issueGroupCom
{
    issueGroupCom.type = [NSNumber numberWithInt:Album_Delete];
    RequestTask *task = [self generateRequestTask:issueGroupCom.dataDict key:kIssueGruopCom forAction:kSetAlbumAction];
    [self doRequest:task];
}

-(void)updateAlbum:(IssueGruopCom*)issueGroupCom
{
    issueGroupCom.type = [NSNumber numberWithInt:Album_Update];
    RequestTask *task = [self generateRequestTask:issueGroupCom.dataDict key:kIssueGruopCom forAction:kSetAlbumAction];
    [self doRequest:task];
}



@end
