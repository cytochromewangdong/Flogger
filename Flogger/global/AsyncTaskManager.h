//
//  AsyncTaskManager.h
//  Flogger
//
//  Created by jwchen on 12-3-31.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseServerProxy.h"

@interface AsyncTaskManager : NSObject
@property(nonatomic, retain)NSMutableArray *taskArray;

-(void)addTask:(BaseServerProxy *)sp;

+(AsyncTaskManager *)sharedInstance;
+(void)purgeSharedInstance;
@end
