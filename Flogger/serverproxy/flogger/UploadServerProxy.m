//
//  UploadServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-2-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "UploadServerProxy.h"
#import "GlobalData.h"
#import "Guid.h"
#import "DataCache.h"
#import "SBJson.h"
#import "AsyncTaskManager.h"

#define kUploadAction @"UploadServerProxy-UploadAction"
#define kUploadAlbumAction @"UploadServerProxy-UploadAlbumAction"
#define kIssueInfoCom @"IssueInfoCom"
#define kPreUploadAction @"preUpload"
#define kUploadFileAction @"uploadFileAction"
#define kSavedDataFile @"upload_savedDataFileContinue"
#define kSavedComContent @"upload_savedComContent"
#define kSavedContentType @"upload_XXYYType"
#define kSavedUploadFileName @"upload_SavedUploadFileName"
#define kSavedMainArray @"upload_saveMainArray"
#define kSavedGUID @"upload_savedGUID"
static NSMutableDictionary *savedFileData;
static NSMutableDictionary *runningCache;
@implementation UploadServerProxy
@synthesize isUploading;
@synthesize fileName;
@synthesize XXYYType;
@synthesize uniqueID;
+(void)initialize
{
    NSData* pureData = [[DataCache sharedInstance]dataFromKey:kSavedDataFile];
    if(pureData)
    {
        NSString *sData = [[[NSString alloc]initWithData:pureData encoding:NSUTF8StringEncoding] autorelease];
        
        savedFileData = [[sData JSONValue] retain];
    }
    else
    {
        savedFileData = [[NSMutableDictionary alloc]init];
    }

    runningCache = [[NSMutableDictionary alloc]init];
}
+(void) loadFileAndResumeTask
{

    {
        NSMutableArray *savedMainArray = [savedFileData objectForKey:kSavedMainArray];
        //(IssueInfoCom *)issueInfoCom withData:(NSString *)dataFile
        for (NSMutableDictionary *rowData in savedMainArray) {
            
            NSString *key = [rowData objectForKey:kSavedGUID];
            if([runningCache objectForKey:key])
            {
                continue;
            }
            NSMutableDictionary *comDict = [rowData objectForKey:kSavedComContent];
            NSString *fileName = [rowData objectForKey:kSavedUploadFileName];
            IssueInfoCom *com = [[[IssueInfoCom alloc]init]autorelease];
            com.dataDict = comDict;
            UploadServerProxy *serverProxy = [[[UploadServerProxy alloc] init] autorelease];
            NSNumber *uploadType = [rowData objectForKey:kSavedContentType];
            if(uploadType && [uploadType integerValue] == XXYY_PREUPLOAD)
            {
                
                serverProxy.XXYYType = XXYY_PREUPLOAD;
                [[AsyncTaskManager sharedInstance] addTask:serverProxy];
                [serverProxy preUploadIssue:com withData:fileName Resend:YES];
            } 
            else 
            {
                [[AsyncTaskManager sharedInstance] addTask:serverProxy];
                [serverProxy uploadFileIssue:com withData:fileName Resend:YES];
            }
        }
    }

}
+(void) saveDataToFile:(IssueInfoCom *)issueInfoCom withData:(NSString *)dataFile Type:(int)dataType
{
    //savedFileData
    NSMutableArray *savedMainArray = [savedFileData objectForKey:kSavedMainArray];
    if(!savedMainArray)
    {
        savedMainArray = [[[NSMutableArray alloc]init]autorelease];
        [savedFileData setObject:savedMainArray forKey:kSavedMainArray];
    }
    NSMutableDictionary *rowData = [[[NSMutableDictionary alloc]init]autorelease];

    [rowData setObject:issueInfoCom.dataDict forKey:kSavedComContent];
    if(dataFile)
    {
        [rowData setObject:dataFile forKey:kSavedUploadFileName];
    }
    if(dataType==XXYY_PREUPLOAD)
    {
        [rowData setObject:issueInfoCom.uploadFileID forKey:kSavedGUID];
        [rowData setObject:[NSNumber numberWithInteger:XXYY_PREUPLOAD] forKey:kSavedContentType];
    } 
    else
    {
        [rowData setObject:issueInfoCom.guid forKey:kSavedGUID];
    }

    [savedMainArray addObject:rowData];
    
    NSString *sData = [savedFileData JSONRepresentation];
    NSData* pureData = [sData dataUsingEncoding:NSUTF8StringEncoding];
    [[DataCache sharedInstance]storeData:pureData forKey:kSavedDataFile];
}
+(void) removeDataFromFile:(NSString*) guid
{
    //savedFileData
    NSMutableArray *savedMainArray = [savedFileData objectForKey:kSavedMainArray];
    if(!savedMainArray)
    {
        return;
    }
    //guid
    for (NSMutableDictionary *rowData in savedMainArray) {
        NSString  *cGuid = [rowData objectForKey:kSavedGUID];
        if([cGuid isEqualToString:guid])
        {
            [savedMainArray removeObject:rowData];
            break;
        }
    }
    NSString *sData = [savedFileData JSONRepresentation];
    NSData* pureData = [sData dataUsingEncoding:NSUTF8StringEncoding];
    [[DataCache sharedInstance]storeData:pureData forKey:kSavedDataFile];
}
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
    if ([kUploadAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@", [GlobalUtils uploadServerUrl]];
    }else if([kUploadAlbumAction isEqualToString:action]){
        url = [NSString stringWithFormat:@"%@AlbumInfo", [GlobalUtils uploadServerUrl]];
    }else if([kPreUploadAction isEqualToString:action])
    {
        url = [NSString stringWithFormat:@"%@preUpload", [GlobalUtils preUploadServerUrl]];
    }else if([kUploadFileAction isEqualToString:action])
    {
        url = [NSString stringWithFormat:@"%@uploadFile", [GlobalUtils preUploadServerUrl]];
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

/*-(void)uploadIssue:(IssueInfoCom *)issueInfoCom withData:(NSData *)data
{
    if (data) {
        issueInfoCom.uploadFileSize = [NSNumber numberWithInt: [data length]];
        //issueInfoCom.uploadFileID = [NSString stringWithFormat:@"%@%d", [GlobalData sharedInstance].myAccount.token, random()];
    }
    issueInfoCom.uploadFileID = [[Guid randomGuid]stringValue];
    RequestTask *task = [self generateRequestTaskWithBody:data bodyKey:nil header:issueInfoCom.dataDict headerKey:kIssueInfoCom forAction:kUploadAction];
    [self doRequest:task];
}*/
-(void)uploadFileIssue:(IssueInfoCom *)issueInfoCom withData:(NSString *)dataFile
{
    [self uploadFileIssue:issueInfoCom withData:dataFile Resend:NO];
}

-(void)uploadFileIssue:(IssueInfoCom *)issueInfoCom withData:(NSString *)dataFile Resend:(BOOL)resend
{
    self.uniqueID = issueInfoCom.guid;
    [runningCache setObject:self.uniqueID forKey:self.uniqueID];
    if(!resend)
    {
        [UploadServerProxy saveDataToFile:issueInfoCom withData:dataFile Type:XXYY_UPLOADING_FILE]; 
    }
//    [NSFileManager defaultManager]
//    int fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:dataFile error:nil] fileSize];
//    int fil
//    NSLog(@"dataFile path is %@",dataFile);
    int fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:dataFile error:nil] fileSize];
//    NSLog(@"fileSize is %d",fileSize);
//    int fileSize = [[[NSFileManager defaultManager] fileAttributesAtPath:dataFile traverseLink:YES] fileSize];
    
    issueInfoCom.uploadFileSize = [NSNumber numberWithInt: fileSize];

        //issueInfoCom.uploadFileID = [NSString stringWithFormat:@"%@%d", [GlobalData sharedInstance].myAccount.token, random()];
//    issueInfoCom.uploadFileID = [[Guid randomGuid]stringValue];
    RequestTask *task = [self generateRequestTaskWithBody:dataFile header:issueInfoCom.dataDict headerKey:kIssueInfoCom forAction:kUploadFileAction];
    task.requestLevel = backgroundLevel;
    task.fileID = issueInfoCom.guid;
    //[self generateRequestTaskWithBody:data bodyKey:nil header:issueInfoCom.dataDict headerKey:kIssueInfoCom forAction:kUploadFileAction];
    self.isUploading = YES;
    [self doRequest:task];
}

/*-(void)uploadAlbumInfo:(IssueInfoCom *)issueInfoCom withData:(NSData *)data
{
    if (data) {
        issueInfoCom.uploadFileSize = [NSNumber numberWithInt: [data length]];
        issueInfoCom.uploadFileID = [NSString stringWithFormat:@"%@%d", [GlobalData sharedInstance].myAccount.token, random()];
    }
    
    RequestTask *task = [self generateRequestTaskWithBody:data bodyKey:nil header:issueInfoCom.dataDict headerKey:kIssueInfoCom forAction:kUploadAlbumAction];
    [self doRequest:task];

}*/
-(void)notifyTransactionFinished
{
    [super notifyTransactionFinished];
    if(isUploading)
    {
        if(self.XXYYType == XXYY_PREUPLOAD)
        {
            [UploadServerProxy removeDataFromFile:((IssueInfoCom*)self.response).uploadFileID];  
        } else {
            [UploadServerProxy removeDataFromFile:((IssueInfoCom*)self.response).guid];
        }
    }
}
-(void)notifyNetworkError
{
    [super notifyNetworkError];
    if(self.uniqueID)
    {
        [runningCache removeObjectForKey:self.uniqueID];
    }
}
-(void)preUploadIssue:(IssueInfoCom *)issueInfoCom withData:(NSString *)dataFile
{
    self.XXYYType = XXYY_PREUPLOAD;
    [self preUploadIssue:issueInfoCom withData:dataFile Resend:NO];
}
-(void)postNotification:(IssueInfoCom *) com
{
    NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] init] autorelease];
    MyIssueInfo *dataThreadHeader = [[[MyIssueInfo alloc]init]autorelease];
    dataThreadHeader.dataDict = [NSMutableDictionary dictionaryWithDictionary:com.issueinfo.dataDict];
    if(dataThreadHeader.text)
    {
        dataThreadHeader.hypertext = dataThreadHeader.text;
    }
    if (com.issueinfo.parentid) {
        dataThreadHeader.parentid = com.issueinfo.parentid;
    }

    dataThreadHeader.username = [GlobalData sharedInstance].myAccount.account.username;
    dataThreadHeader.useruid = [GlobalData sharedInstance].myAccount.account.useruid;
    if([GlobalData sharedInstance].myAccount.account.imageurl)
    {
        dataThreadHeader.imageurl = [GlobalData sharedInstance].myAccount.account.imageurl;
    }
    NSLog(@"================ %@",[GlobalData sharedInstance].myAccount.account.imageurl);
    NSString *userName = [GlobalData sharedInstance].myAccount.username;
    
    //add like
    dataThreadHeader.likecnt = [NSNumber numberWithInt:0];
    //add time
    dataThreadHeader.createdate = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000] ;
    
    if(com.issueinfo.parentid && [com.issueinfo.parentid longLongValue]>0)
    {
        NSString * deco;
        if (dataThreadHeader.hypertext) {
            deco = [NSString stringWithFormat:@"<span class='userFormat'>%@:</span> %@",userName,dataThreadHeader.hypertext];
        } else {
            deco = [NSString stringWithFormat:@"<span class='userFormat'>%@</span>",userName];
        }
        [dataThreadHeader.dataDict setObject:deco forKey:@"decoratedHypertext"];
    }
    [dataThreadHeader.dataDict setObject:com.uploadFileID forKey:kLocalIssueID];
    if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_PICTURE || [com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO) {
        NSString *newPath = nil;
        if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_PICTURE) {
            
            //newPath = [[DataCache sharedInstance] cachePathForKey:com.threadHead.bmiddleurl andCategory:nil];
            dataThreadHeader.bmiddleurl = com.uploadFileID;
            
            if(com.issueinfo.parentid && [com.issueinfo.parentid longLongValue]>0)
            {
                [dataDic setObject:kNotificationCommentAction forKey:kNotificationAction];
                [dataDic setObject:dataThreadHeader forKey:kNotificationInfoIssueThread];
            } else{
                
                [dataDic setObject:kNotificationPostAction forKey:kNotificationAction];
                [dataDic setObject:dataThreadHeader forKey:kNotificationInfoIssueThread];
            }
        } else if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO)
        {
            //UIImage *mediaImage = [self.cameraInfo objectForKey:fVideoThumbnail];
            
            NSString *thumbnailFileID = [NSString stringWithFormat:kThumbnailFormat,com.uploadFileID];
            dataThreadHeader.bmiddleurl = thumbnailFileID;
            dataThreadHeader.videourl = com.uploadFileID;
            //video duration
            dataThreadHeader.videoduration = com.issueinfo.videoDuration;

            NSString *nameWithoutExt = [[DataCache sharedInstance] cachePathForKey:com.uploadFileID andCategory:nil];
            newPath = [nameWithoutExt stringByAppendingPathExtension:@"mov"];
            
            NSError *error = nil;
            [[NSFileManager defaultManager] linkItemAtPath:nameWithoutExt toPath:newPath error:&error];
            NSLog(@"copy :%@   %@",nameWithoutExt,newPath);
            //[[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:proxy.fileName] toURL:[NSURL fileURLWithPath:newPath] error:&error];
            if(error)
            {
                NSLog(@"error is %@",error);
            }
            if(com.issueinfo.parentid && [com.issueinfo.parentid longLongValue]>0)
            {
                [dataDic setObject:kNotificationCommentAction forKey:kNotificationAction];
                [dataDic setObject:dataThreadHeader forKey:kNotificationInfoIssueThread];
            } else{
                
                [dataDic setObject:kNotificationPostAction forKey:kNotificationAction];
                [dataDic setObject:dataThreadHeader forKey:kNotificationInfoIssueThread];
            }
            //[[DataCache sharedInstance]removeDataForKey:thumbnailFileID];
        }
        //[[DataCache sharedInstance]removeDataForKey:com.uploadFileID];
        //[[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
        
    } else {
        if(com.issueinfo.parentid && [com.issueinfo.parentid longLongValue]>0)
        {
            [dataDic setObject:kNotificationCommentAction forKey:kNotificationAction];
            [dataDic setObject:dataThreadHeader forKey:kNotificationInfoIssueThread];
        } else{
            [dataDic setObject:kNotificationPostAction forKey:kNotificationAction];
            [dataDic setObject:dataThreadHeader forKey:kNotificationInfoIssueThread];
        }
        
        
    }  
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
    });
    
}
-(void)preUploadIssue:(IssueInfoCom *)issueInfoCom withData:(NSString *)dataFile Resend:(BOOL)resend
{
    self.XXYYType = XXYY_PREUPLOAD;
    self.fileName = dataFile;
    //issueInfoCom.uploadFileID = [[Guid randomGuid]stringValue];
    self.uniqueID = issueInfoCom.uploadFileID;
    [runningCache setObject:self.uniqueID  forKey:self.uniqueID];
    if(!resend)
    {
        [UploadServerProxy saveDataToFile:issueInfoCom withData:dataFile Type:XXYY_PREUPLOAD]; 
        [self postNotification:issueInfoCom];
    }
    RequestTask *task = [self generateRequestTaskWithBody:nil bodyKey:nil header:issueInfoCom.dataDict headerKey:kIssueInfoCom forAction:kPreUploadAction];
    task.requestLevel = backgroundLevel;
    self.isUploading = YES;
    [self doRequest:task];
}
-(void)dealloc
{
    self.fileName = nil;
    self.uniqueID = nil;
    [super dealloc];
}
@end
