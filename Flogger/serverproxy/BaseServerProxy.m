//
//  BaseServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-1-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "ASIHTTPRequest.h"
#import "NetworkManager.h"
#import "NetworkData.h"
#import "SBJson.h"
#import "BaseParameter.h"
#import "GTMBase64.h"
#import "GlobalData.h"

#define SERVER_DEBUG YES
@interface BaseServerProxy()
//@property(retain) NSString *errorMessage;
@end
@implementation BaseServerProxy
@synthesize delegate, response = _response, keyCom;
@dynamic errorMessage;

-(id)init
{
    self = [super init];
    if (self) {
        _taskList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    return nil;
}
+(void)cancelAllOnEarth:(RequestLevel)level
{
    if(level == normalLevel)
    {
        [[NetworkManager sharedInstance] cancelAll];
    } else {
        [[NetworkManager sharedInstanceForBackground] cancelAll];
    }
}
-(void)cancelAll
{
    if (_taskList) {
        for (RequestTask *task in _taskList) {
            if(task.requestLevel == normalLevel)
            {
                [self cancelTask:task];
            }
        }
    }
}

-(void)cancelTask:(RequestTask *)task
{
    if(task.requestLevel == normalLevel)
    {
        [[NetworkManager sharedInstance] cancelSyncTask:task]; 
    } else {
        [[NetworkManager sharedInstanceForBackground] cancelSyncTask:task];   
    }

}

-(NSString *)generateRequestIdForTask:(RequestTask *)task
{
    NSString *requestId = nil;
    requestId = [NSString stringWithFormat:@"%@", task.action];
    return  requestId;
}

-(NSMutableDictionary *)generateBodyDict:(id)value forKey:(NSString *)key
{
    NSMutableDictionary *bodyDict = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
    [bodyDict setObject:value forKey:key];
    return bodyDict;
}

-(NSData *)generateDataFromDictionary:(NSMutableDictionary *)dataDict
{
    SBJsonWriter* writer = [[[SBJsonWriter alloc] init] autorelease];
    return [writer dataWithObject: dataDict];
}

-(RequestTask *)generateRequestTask:(id)value key:(NSString *)key forAction:(NSString *)action
{
    RequestTask *task = [[[RequestTask alloc] init] autorelease];
    task.action = action;
    NSMutableDictionary *dict = [self generateBodyDict:value forKey:key];
    if (SERVER_DEBUG) {
        NSLog(@"request body: %@", [dict JSONRepresentation]);
    }
    NSData *data = [self generateDataFromDictionary:dict];
    [task.bodyData addObject: data];
    task.url = [self urlByAction:action];
    task.requestId = [self generateRequestIdForTask:task];
    return task;
}

-(RequestTask *)generateRequestTaskWithBody:(NSString*)dataFile header:(id)headerData headerKey:(NSString *)headerKey forAction:(NSString *)action
{
    RequestTask *task = [[[RequestTask alloc] init] autorelease];
    task.action = action;
    task.dataFile = dataFile;
    NSLog(@"DataFile Name: %@", dataFile);
    
    task.shouldStreamPostDataFromDisk = YES;
    if (headerData) {
        NSMutableDictionary *dict = [self generateBodyDict:headerData forKey:headerKey];
        
//        NSLog(@"request header: %@", [dict JSONRepresentation]);
        NSData *data = [self generateDataFromDictionary:dict];
        NSData *base64Data = [GTMBase64 encodeData: data];
        NSString *base64Str = [[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding] autorelease];
        [task.headerParameters setObject:base64Str forKey:@"data-in-header"];
    }
    
    task.url = [self urlByAction:action];
    task.requestId = [self generateRequestIdForTask:task];
    return task;
}
-(RequestTask *)generateRequestTaskWithBody:(id)bodyData bodyKey:(NSString *)bodyKey header:(id)headerData headerKey:(NSString *)headerKey forAction:(NSString *)action
{
    RequestTask *task = [[[RequestTask alloc] init] autorelease];
    task.action = action;
    
    if (bodyData) {
        if ([bodyData isKindOfClass:[NSData class]]) {
            [task.bodyData addObject: bodyData];
            task.shouldStreamPostDataFromDisk = YES;
        }
        else
        {
            NSMutableDictionary *dict = [self generateBodyDict:bodyData forKey:bodyKey];
            [task.bodyData addObject: dict];
            //if (DEBUG)
            {
                NSLog(@"request body: %@", [dict JSONRepresentation]);
            }
        }
       
    }
    
    if (headerData) {
        NSMutableDictionary *dict = [self generateBodyDict:headerData forKey:headerKey];
        
        //if (DEBUG)
        {
//            NSLog(@"request header: %@", [dict JSONRepresentation]);
        }
//        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] initWithCapacity:1];
//        [headerDict setObject:dict forKey:@"data-in-header"];
        NSData *data = [self generateDataFromDictionary:dict];
        NSData *base64Data = [GTMBase64 encodeData: data];
        NSString *base64Str = [[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding] autorelease];
        [task.headerParameters setObject:base64Str forKey:@"data-in-header"];
    }
    
    task.url = [self urlByAction:action];
    task.requestId = [self generateRequestIdForTask:task];
    return task;
}

-(void)doRequest:(RequestTask *)task
{
    [task.headerParameters addEntriesFromDictionary:[NetworkData sharedInstance].commonHeaderDict];
    if(task.fileID)
    {
        [task.headerParameters setObject:task.fileID forKey:@"x-token-in-head"];
    } else {
        if ([GlobalData sharedInstance].myAccount.token) {
            [task.headerParameters setObject:[GlobalData sharedInstance].myAccount.token forKey:@"x-token-in-head"];
        }
    }
    task.networkDelegate = self;
    if(task.requestLevel == normalLevel)
    {
        [_taskList addObject:task];
        //    [taskDict setObject:task forKey:task.requestId];
        [[NetworkManager sharedInstance] addSyncTask:task];
        return;
    }
    if(task.requestLevel == backgroundLevel)
    {
        [_taskList addObject:task];
        //    [taskDict setObject:task forKey:task.requestId];
        [[NetworkManager sharedInstanceForBackground] addSyncTask:task];
        return;
    }
    
    [[NetworkManager sharedInstance]performAndWaitTask:task];
    
}

#pragma mark -- asihttprequest delegate
-(void)notifyNetworkError
{
    if (self.delegate && [delegate respondsToSelector:@selector(networkError:)])
    {
        [delegate networkError:self];
    }
}

-(void)notifyTransactionFinished
{
    if (self.delegate && [delegate respondsToSelector:@selector(transactionFinished:)])
    {
        [delegate transactionFinished:self];
    }
}

-(void)notifyTransactionFailed
{
    if (self.delegate && [delegate respondsToSelector:@selector(transactionFailed:)])
    {
        [delegate transactionFailed:self];
    }
}

-(void)networkFinished:(ASIHTTPRequest *)request
{
    RequestTask *task = [[NetworkManager sharedInstance] removeSyncTaskByRequest:request];
    if(task)
    {
         task = [[NetworkManager sharedInstanceForBackground] removeSyncTaskByRequest:request];
    }
    if(task)
    {
        [_taskList removeObject:task];
    }
    if (self.delegate && [delegate respondsToSelector:@selector(networkFinished:)])
    {
        [delegate networkFinished:self];
    }
}

-(void)parseResponse:(id)responseData
{
    return;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"requestFinished: %@", request.originalURL.absoluteString);
    
    NSData *responseData = [request responseData];
    NSLog(@"responseData: %d", responseData.length);
    
//    NSDictionary *headerDict = [request responseHeaders];
//    NSString *contentType = [headerDict objectForKey:@"Content-Type"];
//    NSLog(@"content-type: %@", contentType);
    
    int statusCode = [request responseStatusCode];
    NSLog(@"statusCode: %d", statusCode);
    if (statusCode == 200) {
//        if ([contentType rangeOfString:@"json"].location != NSNotFound) 
        {
            NSString * str = [[[NSString alloc]initWithData:responseData encoding: NSUTF8StringEncoding] autorelease];
//            NSLog(@"requestFinished: %@", str);
            
            NSDictionary *dict = [str JSONValue];
            if (dict) {
                NSMutableDictionary *responseDict = [[dict mutableCopy] autorelease];
                [self parseResponse:responseDict];
                [self.response.dataDict addEntriesFromDictionary:[responseDict objectForKey:keyCom]];
                if ([self.response succeed]) {
                    [self notifyTransactionFinished];
                }
                else
                {
                    [self notifyTransactionFailed];
                }
            }
            else
            {
                NSLog(@"ERROR --- not a valid dictionary!");
                [self notifyTransactionFailed];
            }
            
        }
    }
    else
    {
        //[GlobalUtils showAlert:nil message:];
        [self notifyTransactionFailed];
    }
    
    [self networkFinished:request];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if(error.code!=ASIRequestCancelledErrorType)
    {
        self.errorMessage = error.localizedDescription;
    } else 
    {
        int i =1;
    }
    NSLog(@"requestFailed: %@", error.localizedDescription);
    [self notifyNetworkError];
    [self networkFinished:request];
}

-(NSString *)errorMessage
{
    if (self.response) {
        return self.response.errorMessage;
    }
    return _errorMessage;
}
-(void) setErrorMessage:(NSString *)errorMessage
{
    RELEASE_SAFELY(_errorMessage);
    _errorMessage = errorMessage.retain;
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes;
{
    NSLog(@"didReceiveBytes: %lld", bytes);
}

- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    NSLog(@"didSendBytes: %lld", bytes);
}

// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength;
{
    NSLog(@"incrementDownloadSizeBy: %lld", newLength);
}

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
    {
        NSLog(@"incrementUploadSizeBy: %lld", newLength);
    }
}

-(void)dealloc
{
    NSLog(@"serverproxy: -- %@", [[self class] description]);
    [self cancelAll];
    RELEASE_SAFELY(_response);
    RELEASE_SAFELY(_taskList);
    self.errorMessage = nil;
    self.keyCom = nil;
    [super dealloc];
}

@end
