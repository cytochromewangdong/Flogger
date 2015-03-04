//
//  NetwokManager.m
//  Flogger
//
//  Created by jwchen on 12-1-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "NetworkManager.h"
#import "RequestTask.h"
#import "ASIHTTPRequest.h"

#define kJson @"json"

static SecIdentityRef identity = NULL;
static SecTrustRef trust = NULL;
@implementation NetworkManager
@synthesize oneByOne;
static NetworkManager *sharedInstance = nil;
static NetworkManager *sharedInstanceForBackground = nil;

+(NetworkManager *)sharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[NetworkManager alloc] init];
    }
    
    return sharedInstance;
}
+(NetworkManager *)sharedInstanceForBackground
{
    if (!sharedInstanceForBackground) {
        sharedInstanceForBackground = [[NetworkManager alloc] init];
        sharedInstanceForBackground.oneByOne = YES;
    }
    
    return sharedInstanceForBackground;
}
+(void)purgeSharedInstance
{
    [sharedInstance release];
    sharedInstance = nil;
}
+(void)purgeInstanceForBackground
{
    [sharedInstanceForBackground release];
    sharedInstanceForBackground = nil;
}
+(void)addRequestHeader:(ASIHTTPRequest *) request withParameter:(NSMutableDictionary *)headerParameters
{
    NSArray *keys = headerParameters.allKeys;
    for (NSString *key in keys)
    {
        [request addRequestHeader:key value:[headerParameters objectForKey:key]];
//        NSLog(@"key--%@, value: %@", key, [headerParameters objectForKey:key]);
    }
}

+(void)addRequestBodyData:(ASIHTTPRequest *) request withData:(NSMutableArray *)datas
{
    if(!datas)
    {
        return;
    }
    
    for (NSData *data in datas)
    {
        [request appendPostData:data];
    }
    if([datas count]>1)
    {
//        NSLog(@"warning, two data blocks are sent?????????");
    }
}

+(ASIHTTPRequest *)generateHttpRequest:(RequestTask *)task
{
    NSLog(@"request url: %@, action: %@", task.url, task.action);
    NSURL *url = [NSURL URLWithString:task.url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.timeOutSeconds = 20;
    if(task.requestLevel==backgroundLevel)
    {
        request.timeOutSeconds = 120;
        request.numberOfTimesToRetryOnTimeout = 10;
    }
    //request.numberOfTimesToRetryOnTimeout = 2;
    if (task.shouldStreamPostDataFromDisk) {
        request.shouldStreamPostDataFromDisk = YES;
    }
    [self addRequestHeader:request withParameter:task.headerParameters];
    if(task.dataFile)
    {
        [request appendPostDataFromFile:task.dataFile];
    } else {
        [self addRequestBodyData:request withData:task.bodyData];
    }
    if (task.shouldStreamPostDataFromDisk) {
        [task.bodyData removeAllObjects];
    }
    [request setRequestMethod:task.requestType];
    [request setDelegate:task.networkDelegate];
    return request;
}
+(BOOL) extractIdentityFromFile:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust 
{
    
    NSString *path = [[NSBundle mainBundle]    
                      pathForResource:@"server" ofType:@"p12"];
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:path];
//    NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"server" ofType:@"p12"]];
    return [self extractIdentity:outIdentity andTrust:outTrust fromPKCS12Data:PKCS12Data];
}
+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data
{
	OSStatus securityError = errSecSuccess;
    // TODO
	//NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"atoato" forKey:(id)kSecImportExportPassphrase];
    CFStringRef password = CFSTR("atoato"); 
    const void *keys[] = { kSecImportExportPassphrase }; 
    const void *values[] = { password }; 
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL); 
	CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
	securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,optionsDictionary,&items);
    CFRelease(optionsDictionary);
	if (securityError == 0) { 
		CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
		const void *tempIdentity = NULL;
		tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
		*outIdentity = (SecIdentityRef)tempIdentity;
		const void *tempTrust = NULL;
		tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
		*outTrust = (SecTrustRef)tempTrust;
	} else {
		NSLog(@"Failed with error code %d",(int)securityError);
		return NO;
	}
	return YES;
}
+(void)initialize
{
    identity = NULL;
    trust = NULL;
	[self extractIdentityFromFile:&identity andTrust:&trust];
}
#define MAXIUM_COCURRENT_CONNECTIONS 2
-(void)addSyncTask:(RequestTask *)task
{
    @synchronized(self)
    {
        if (![syncTaskDict objectForKey:task]) {
            if (!syncTaskDict) {
                syncTaskDict = [[NSMutableDictionary alloc] init];
            }
            
            if (!syncRequestDict) {
                syncRequestDict = [[NSMutableDictionary alloc] init];
            }
            
            if (!syncQueue) {
                syncQueue = [[NSOperationQueue alloc] init];
                syncQueue.maxConcurrentOperationCount = MAXIUM_COCURRENT_CONNECTIONS;
                if(self.oneByOne)
                {
                    syncQueue.maxConcurrentOperationCount = 1;
                }
            }
            ASIHTTPRequest *request = [NetworkManager generateHttpRequest:task];
            request.delegate = task.networkDelegate;
//            if (task.filePath) {
//                request.shouldStreamPostDataFromDisk = YES;
//                [request appendPostDataFromFile:task.filePath];
//                request.requestMethod = @"POST";
//            }
            if(task.requestLevel ==backgroundLevel)
            {
                if([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
                {
                    [request setShouldContinueWhenAppEntersBackground:YES];
                }                
            }
            if([request.url.scheme isEqualToString:@"https"] 
               || [request.url.scheme isEqualToString:@"HTTPS"])
            {
                [request setClientCertificateIdentity:identity];
                [request setValidatesSecureCertificate:NO];
            }
            
            [syncTaskDict setObject:request forKey:[NSNumber numberWithLongLong:(long long)task]];
            [syncRequestDict setObject:task forKey:request];
            [syncQueue addOperation:request];
        }
    }
} 
-(void)performAndWaitTask:(RequestTask *)task
{
    
    ASIHTTPRequest *request = [NetworkManager generateHttpRequest:task];
    request.delegate = task.networkDelegate;
    //            if (task.filePath) {
    //                request.shouldStreamPostDataFromDisk = YES;
    //                [request appendPostDataFromFile:task.filePath];
    //                request.requestMethod = @"POST";
    //            }
    [request startSynchronous];
}

-(void)cancelSyncTask:(RequestTask *)task
{
    @synchronized(self)
    {
        ASIHTTPRequest *request = [syncTaskDict objectForKey:[NSNumber numberWithLongLong:(long long)task]];
        if(request)
        {
            [syncRequestDict removeObjectForKey:request];
            [request clearDelegatesAndCancel];
        } else {
            int i =1;
        }
    }
}

-(RequestTask*)removeSyncTaskByRequest:(ASIHTTPRequest *)request
{
    @synchronized(self)
    {
        RequestTask *task = [[[syncRequestDict objectForKey:request] retain]autorelease];
        if(task)
        {
            [syncRequestDict removeObjectForKey:request];
            [syncTaskDict removeObjectForKey:[NSNumber numberWithLongLong:(long long)task]];        
        } else {
            int i =1;
        }
        return task;
        //[task release];
    }
}

/*-(void)removeSyncTask:(RequestTask *)task
{
    @synchronized(self)
    {
        ASIHTTPRequest *request = [[syncTaskDict objectForKey:[NSNumber numberWithLongLong:(long long)task]] retain];
//        [syncTaskDict removeObjectForKey:task];
        [syncRequestDict removeObjectForKey:request];
        [request clearDelegatesAndCancel];
        [request release];
    }
}*/


-(void)cancelAllSyncTask
{
    @synchronized(self)
    {
        if (syncQueue) {
            [syncQueue cancelAllOperations];
        }
        
        if (syncTaskDict) {
            [syncTaskDict removeAllObjects];
        } 
        
        if (syncRequestDict) {
            [syncRequestDict removeAllObjects];
        }
    }
    
}


-(void)cancelAll
{
    [self cancelAllSyncTask];
}


-(void)dealloc
{
    [self cancelAllSyncTask];
    RELEASE_SAFELY(syncQueue);
    RELEASE_SAFELY(syncTaskDict)
    RELEASE_SAFELY(syncRequestDict);
    [super dealloc];
}

@end
