//
//  AsyncTaskManager.m
//  Flogger
//
//  Created by jwchen on 12-3-31.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "AsyncTaskManager.h"
#import "UploadServerProxy.h"
#import "Pushinfo.h"
#import "UploadServerProxy.h"
#import "DataCache.h"

static AsyncTaskManager *sharedAsyncTaskManager = nil;
@implementation AsyncTaskManager
@synthesize taskArray;

-(void)dealloc
{
    for (BaseServerProxy *sp in self.taskArray) {
        [sp release];
    }
    
    self.taskArray = nil;
    [super dealloc];
}

+(AsyncTaskManager *)sharedInstance
{
    if (!sharedAsyncTaskManager) {
        sharedAsyncTaskManager = [[AsyncTaskManager alloc] init];
    }
    return sharedAsyncTaskManager;
}
+(void)purgeSharedInstance
{
    [sharedAsyncTaskManager release];
    sharedAsyncTaskManager = nil;
}

-(id) init
{
    self = [super init];
    if (self) {
        self.taskArray = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

-(void)addTask:(BaseServerProxy *)sp
{
//    NSLog(@"addTask ---before %d", [sp retainCount]);
    [self.taskArray addObject:sp];
//    NSLog(@"addTask ---after %d", [sp retainCount]);
    sp.delegate = self;
}

-(void) closeAlertView : (UIAlertView *) alertView
{
//    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
    [GlobalUtils closeAlertView:alertView];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    if (![serverproxy isKindOfClass:[UploadServerProxy class]]) {
        return;
    }
    
    UploadServerProxy *proxy = (UploadServerProxy*)serverproxy;
    if(proxy.XXYYType == XXYY_PREUPLOAD)
    {
        IssueInfoCom *com = (IssueInfoCom *)serverproxy.response;
        
        NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] init] autorelease];
        MyIssueInfo *dataThreadHeader = [[[MyIssueInfo alloc]init]autorelease];
        dataThreadHeader.dataDict = [NSMutableDictionary dictionaryWithDictionary:com.threadHead.dataDict];
        
        [dataThreadHeader.dataDict setObject:proxy.uniqueID forKey:kLocalIssueID];
        if(com.issueinfo.parentid && [com.issueinfo.parentid longLongValue]>0)
        {
            NSString * deco;
            if (com.threadHead.hypertext) {
                deco = [NSString stringWithFormat:@"<span class='userFormat'>%@:</span> %@",com.threadHead.username,com.threadHead.hypertext];
            } else {
                deco = [NSString stringWithFormat:@"<span class='userFormat'>%@</span>",com.threadHead.username];
            }
            [dataThreadHeader.dataDict setObject:deco forKey:@"decoratedHypertext"];
        }
        if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_PICTURE || [com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO) {
            NSString *newPath = nil;
            if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_PICTURE) {
                newPath = [[DataCache sharedInstance] cachePathForKey:com.threadHead.bmiddleurl andCategory:nil];
                NSError * error = nil;
                [[NSFileManager defaultManager] copyItemAtPath:proxy.fileName toPath:newPath error:&error];
                if(error)
                {
//                    NSLog(@"error is %@",error);
                }
                
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
                NSString *thumbnailPath = [[DataCache sharedInstance] cachePathForKey:thumbnailFileID andCategory:nil];
                NSString *bufferpath = [[DataCache sharedInstance] cachePathForKey:com.threadHead.bmiddleurl andCategory:nil];
                NSError * error = nil;
                [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:thumbnailPath] toURL:[NSURL fileURLWithPath:bufferpath] error:&error];  
                if(error)
                {
//                    NSLog(@"error is %@",error);
                }
                newPath = [[[DataCache sharedInstance] cachePathForKey:com.threadHead.videourl andCategory:nil] stringByAppendingPathExtension:@"mov"];
                error = nil;
                [[NSFileManager defaultManager] copyItemAtPath:proxy.fileName toPath:newPath error:&error];
//                    NSLog(@"copy :%@   %@",proxy.fileName,newPath);
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
                [[DataCache sharedInstance]removeDataForKey:thumbnailFileID];
            }
            [[DataCache sharedInstance]removeDataForKey:com.uploadFileID];
            dispatch_async(dispatch_get_main_queue(), ^{
                UploadServerProxy *newServerProxy = [[[UploadServerProxy alloc] init] autorelease];
                [[AsyncTaskManager sharedInstance] addTask:newServerProxy];
                [newServerProxy uploadFileIssue:com withData:newPath];
            });
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
            
        } else {
            if(com.issueinfo.parentid && [com.issueinfo.parentid longLongValue]>0)
            {
                [dataDic setObject:kNotificationCommentAction forKey:kNotificationAction];
                [dataDic setObject:dataThreadHeader forKey:kNotificationInfoIssueThread];
            } else{
                [dataDic setObject:kNotificationPostAction forKey:kNotificationAction];
                [dataDic setObject:dataThreadHeader forKey:kNotificationInfoIssueThread];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
            
        }     
        
    } else{
        IssueInfoCom *com = (IssueInfoCom *)proxy.response;
        //check upload video
        Pushinfo *push = [[[Pushinfo alloc] init] autorelease];
        push.dataDict = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kPushInfo]];
        if (push.dataDict.count != 0 && [push.uploadflg intValue] != 0) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO)
            {
                NSString *message = NSLocalizedString(@"Your video has finished uploading", @"Your video has finished uploading");
                [GlobalUtils showPostMessageAlert:message];
                /*UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] autorelease];
                [alert show];
                [self performSelector:@selector(closeAlertView:) withObject:alert afterDelay:3];*/
//                [GlobalUtils p]
            }
        });

    }
}

-(void)networkFinished:(BaseServerProxy *)sp
{
//    NSLog(@"networkFinished --- %@", [[sp class] description]);
    [self.taskArray removeObject:sp];
//    [sp release];
}
//-(void)transactionFinished:(BaseServerProxy *)serverproxy
//{

//}
//-(void)transactionFailed:(BaseServerProxy *)serverproxy
//{
//}
-(void)networkError:(BaseServerProxy *)serverproxy
{
}



@end
