//
//  FoggerQueue.h
//  FloggerVideo
//
//  Created by dong wang on 12-2-14.
//  Copyright (c) 2012年 atoato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloggerTask : NSObject
{
    id _target;
    SEL _selector;
    id _queue;
    id _param;
    BOOL _sync;
    //NSCondition *_syncCondition;
    dispatch_semaphore_t _frameRenderingSemaphore;
}
@property (nonatomic, readonly) id target;
@property (nonatomic,retain) id param;
@property (assign) BOOL sync;
@property (assign) BOOL done;

- (id)initWithTarget:(id)target selector:(SEL)selector withObject:(id) param queue:(id)queue sync:(BOOL) sync;
- (void)exec;
@end

@interface FloggerQueue : NSObject
{
    NSCondition *_condition;
    NSMutableArray *_array;
    NSThread *_thread;
}
@property (assign) double priority;
//- (void)addTask:(id)target selector:(SEL)selector withObject:(id) param;
- (void)performTask:(id)target selector:(SEL)selector withObject:(id) param Sync:(BOOL) sync;
- (void) start;
@end

/*@interface FloggerQueue : NSObject
{
    NSThread *_thread;
    NSCondition *_condition;
}
@property (assign)BOOL isAlive;
- (void)startRunLoop:(id)param;
- (void)performTask:(id)target selector:(SEL)selector withObject:(id) param Sync:(BOOL) sync;
-(void) quit;
@end*/

