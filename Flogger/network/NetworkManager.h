//
//  NetwokManager.h
//  Flogger
//
//  Created by jwchen on 12-1-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@class RequestTask;
@interface NetworkManager : NSObject
{
    @private
    NSOperationQueue *syncQueue;
    
    NSMutableDictionary *syncTaskDict;
    NSMutableDictionary *syncRequestDict;
}
+(NetworkManager *)sharedInstance;
+(NetworkManager *)sharedInstanceForBackground;
@property(nonatomic, assign) BOOL oneByOne;
+(void)purgeSharedInstance;
+(void)purgeInstanceForBackground;
//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(NetworkManager);

-(void)addSyncTask:(RequestTask *)task;
-(void)performAndWaitTask:(RequestTask *)task;
//-(void)removeSyncTask:(RequestTask *)task;
-(RequestTask*)removeSyncTaskByRequest:(ASIHTTPRequest *)request;


-(void)cancelSyncTask:(RequestTask *)task;


-(void)cancelAllSyncTask;


-(void)cancelAll;

@end
