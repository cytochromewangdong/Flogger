//
//  FloggerPrefetch.h
//  Flogger
//
//  Created by wyf on 12-3-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseServerProxy.h"
#import "Reachability.h"
@class ExternalPlatformServerProxy;
@interface FloggerPrefetch : NSObject <NetworkRequestDelegate>
//@property (nonatomic, retain) NSArray *platformArray;
+(FloggerPrefetch*) getSingleton;
+(void)purgeSharedInstance;
@property (nonatomic, retain) NSArray *platformArray;
@property (assign) id delegate;
@property (nonatomic, retain) Reachability *reach;
@property (nonatomic, retain) Reachability *reachWIFI;
@property (retain) ExternalPlatformServerProxy* serverProxy;
-(void) downloadExternalPlatform;

@end
