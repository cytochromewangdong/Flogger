//
//  UploadServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-2-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "IssueInfoCom.h"
#define XXYY_UPLOADING_FILE 0
#define XXYY_PREUPLOAD 1
@interface UploadServerProxy : BaseServerProxy
//-(void)uploadIssue:(IssueInfoCom *)issueInfoCom withData:(NSData *)data;
//-(void)uploadAlbumInfo:(IssueInfoCom *)issueInfoCom withData:(NSData *)data;
@property (nonatomic,assign)BOOL isUploading;
@property (nonatomic,assign)int XXYYType;
@property (nonatomic,retain)NSString *fileName;
@property (nonatomic,retain)NSString *uniqueID;
-(void)preUploadIssue:(IssueInfoCom *)issueInfoCom withData:(NSString *)dataFile;
-(void)preUploadIssue:(IssueInfoCom *)issueInfoCom withData:(NSString *)dataFile Resend:(BOOL)resend;
+(void) loadFileAndResumeTask;
//-(void)uploadFileIssue:(IssueInfoCom *)issueInfoCom withData:(NSData *)data;
-(void)uploadFileIssue:(IssueInfoCom *)issueInfoCom withData:(NSString *)dataFile;
-(void)uploadFileIssue:(IssueInfoCom *)issueInfoCom withData:(NSString *)dataFile Resend:(BOOL)resend;
@end
