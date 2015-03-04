//
//  UploadServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-2-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "UploadServerProxy.h"
#import "GlobalData.h"

#define kUploadAction @"UploadServerProxy-UploadAction"
#define kIssueInfoCom @"IssueInfoCom"

@implementation UploadServerProxy

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kUploadAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@", [GlobalUtils uploadServerUrl]];
    }
    return url;
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[IssueInfoCom alloc] init] autorelease];
    //    self.response.dataDict = [[[responseData objectForKey:kAccountCom] mutableCopy] autorelease];
    //    [self.response.dataDict addEntriesFromDictionary:[responseData objectForKey:kAccountCom]];
}

-(void)uploadIssue:(IssueInfoCom *)issueInfoCom withData:(NSData *)data
{
    if (data) {
        issueInfoCom.uploadFileSize = [NSNumber numberWithInt: [data length]];
        issueInfoCom.uploadFileID = [NSString stringWithFormat:@"%@%d", [GlobalData sharedInstance].myAccount.token, random()];
    }
    
    RequestTask *task = [[[self generateRequestTaskWithBody:data bodyKey:nil header:issueInfoCom.dataDict headerKey:kIssueInfoCom forAction:kUploadAction] retain] autorelease];
    [self doRequest:task];
}
@end
