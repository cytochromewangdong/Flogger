//
//  FloggerPrefetch.m
//  Flogger
//
//  Created by wyf on 12-3-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerPrefetch.h"
#import "ExternalPlatformServerProxy.h"
#import "GlobalData.h"
#import "UploadServerProxy.h"

static FloggerPrefetch *prefetch;

@implementation FloggerPrefetch
@synthesize serverProxy;
@synthesize delegate,platformArray,reach, reachWIFI;

+(FloggerPrefetch*) getSingleton
{ 
    if(!prefetch)
    {
        prefetch = [[FloggerPrefetch alloc]init];
    }
    return prefetch;
}
+(void)purgeSharedInstance
{
    [prefetch release];
    prefetch = nil;
    
}


- (void)fetch_external
{
    ExternalPlatformCom *com = [[[ExternalPlatformCom alloc] init] autorelease];
    
    [self.serverProxy getExternalPlatform:com];
}

- (void) reachabilityChanged:(NSNotification *)notification
{
    Reachability *localReachability = [notification object]; 
    
    if ([localReachability isReachable])
    {
        [UploadServerProxy loadFileAndResumeTask];
    } 
}

-(void) downloadExternalPlatform
{
//    if ([GlobalUtils checkIsLogin]) {
//        self.platformArray = [GlobalData sharedInstance].exPlatform.externalplatforms;
//        return;
//    }
//    self.serverProxy = [[[ExternalPlatformServerProxy alloc] init]autorelease];;
//    self.serverProxy.delegate = self;
//    
//    [self fetch_external];
//    return;
    //engilish en
    //chinese zh-Hans
    self.reach = [Reachability reachabilityForInternetConnection];
    // Reachability *reach = [Reachability reachabilityWithHostName:@"www.folo.mobi"]; 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    if([reach isReachable])
    {
        [UploadServerProxy loadFileAndResumeTask];
    }
    [reach startNotifier];
    self.reachWIFI = [Reachability reachabilityForLocalWiFi];
    [reachWIFI startNotifier];
    /*NSString *preferredLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
//    NSLog(@"preferedlanuage is %@",preferredLanguage);
    NSString *strPath;
    if ([preferredLanguage isEqualToString:@"zh-Hans"]) {
        strPath = [[NSBundle mainBundle] pathForResource:@"kExternalCom_Chinese" ofType:nil];
    } else {
        strPath = [[NSBundle mainBundle] pathForResource:@"kExternalCom_English" ofType:nil];
    }*/
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"kExternalCom" ofType:nil];
    
    ExternalPlatformCom *com = [NSKeyedUnarchiver unarchiveObjectWithFile: strPath];
    self.platformArray = com.externalplatforms;
    
    [GlobalData sharedInstance].exPlatform = com;
    [[GlobalData sharedInstance] saveExternalPlatform];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    if([serverproxy isKindOfClass:[ExternalPlatformServerProxy class]])
    {
        ExternalPlatformServerProxy *proxy = (ExternalPlatformServerProxy*) serverproxy;
        ExternalPlatformCom *com = (ExternalPlatformCom*)proxy.response;
        self.platformArray = com.externalplatforms;
        
        [GlobalData sharedInstance].exPlatform = com;
        [[GlobalData sharedInstance] saveExternalPlatform];
        
//        Externalplatform
        //get externalplatform
//        NSString *strPath = [[NSBundle mainBundle] pathForResource:@"kExternalCom" ofType:nil];
//        ExternalPlatformCom *testCom = [NSKeyedUnarchiver unarchiveObjectWithFile: strPath];
        
//        NSString *string;
//        [NSOutputStream outputStreamToFileAtPath:nil append:NO];
        
        
        if(self.delegate)
        {
            [self.delegate performSelector:@selector(updateShareView:) withObject:self.platformArray];
        }
        
//        [[GlobalData sharedInstance] saveExternalPlatform];
    }
}
-(void)transactionFailed:(BaseServerProxy *)serverproxy
{
}
-(void)networkError:(BaseServerProxy *)serverproxy
{
    if(self.serverProxy == serverproxy)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(fetch_external) withObject:nil afterDelay:5];
    }
    
}

-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    
}
-(void) dealloc
{
    [self setPlatformArray:nil];
    self.serverProxy = nil;
    [super dealloc];
}
@end
