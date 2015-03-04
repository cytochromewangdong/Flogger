//
//  AlbumInfoComServerProxy.m
//  Flogger
//
//  Created by steveli on 29/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "AlbumInfoComServerProxy.h"
#import "GlobalData.h"

#define kUploadAlbumAction @"AlbumInfoComServerProxy-UploadAction"
#define kMoveAlbumAction  @"AlbumInfoComServerProxy-MoveAction"
#define kAlbumInfoCom @"AlbuminfoCom"

@implementation AlbumInfoComServerProxy

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kUploadAlbumAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@AlbumInfo", [GlobalUtils uploadServerUrlHTTPS]];
    }else if([kMoveAlbumAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@setAlbumInfo", [GlobalUtils serverUrl]];
    }
    return url;
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[AlbuminfoCom alloc] init] autorelease];
    //    self.response.dataDict = [[[responseData objectForKey:kAccountCom] mutableCopy] autorelease];
    //    [self.response.dataDict addEntriesFromDictionary:[responseData objectForKey:kAccountCom]];
}

-(void)uploadAlbumInfo:(AlbuminfoCom *)issueInfoCom withData:(NSData *)data
{
    if (data) {
        issueInfoCom.uploadFileSize = [NSNumber numberWithInt: [data length]];
        issueInfoCom.uploadFileID = [NSString stringWithFormat:@"%@%d", [GlobalData sharedInstance].myAccount.token, random()];
    }
    
    RequestTask *task = [self generateRequestTaskWithBody:data bodyKey:nil header:issueInfoCom.dataDict headerKey:kAlbumInfoCom forAction:kUploadAlbumAction];
    [self doRequest:task];
}

-(void)moveAlbum:(AlbuminfoCom *)albuminfoCom
{
    albuminfoCom.type = [NSNumber numberWithInt:1];
    RequestTask *task = [self generateRequestTask:albuminfoCom.dataDict key:kAlbumInfoCom forAction:kMoveAlbumAction];
    [self doRequest:task];
}

-(void)deleteAlbumInfo:(AlbuminfoCom *)albuminfoCom
{
    albuminfoCom.type = [NSNumber numberWithInt:2];
    RequestTask *task = [self generateRequestTask:albuminfoCom.dataDict key:kAlbumInfoCom forAction:kMoveAlbumAction];
    [self doRequest:task];
}
@end
