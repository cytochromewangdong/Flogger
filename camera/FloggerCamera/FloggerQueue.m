//
//  FoggerQueue.m
//  FloggerVideo
//
//  Created by dong wang on 12-2-14.
//  Copyright (c) 2012年 atoato. All rights reserved.
//

#import "FloggerQueue.h"
@interface FloggerQueue()

- (void)addTask:(id)target selector:(SEL)selector withObject:(id)param sync:(BOOL) sync;
@end

@interface FloggerTask()
-(void) lock;
@end
@implementation FloggerTask
@synthesize param = _param;
@synthesize target=_target;
@synthesize sync=_sync;
@synthesize done;

- (id)initWithTarget:(id)target selector:(SEL)selector withObject:(id)param queue:(id)queue sync:(BOOL)sync
{
    self = [super init];
    if (self) {
        _target = [target retain];
        _selector = selector;
        _queue = [queue retain];
        self.param = param;
        _sync = sync;
        if(_sync)
        {
            [self retain];
            //_syncCondition = [[NSCondition alloc]init];
             _frameRenderingSemaphore = dispatch_semaphore_create(0);
        }

    }
    return self;
}

- (void)exec
{
    //[_target performSelector:_selector];
    [_target performSelector:_selector withObject:_param];
    self.done = YES;
    if(_sync) 
    {
        dispatch_semaphore_signal(_frameRenderingSemaphore);

        /*[_syncCondition lock];
        [_syncCondition signal];
        [_syncCondition unlock];*/

    } 
}
-(void) lock {
    if(_sync) 
    {
        //[self retain];
        //if(!self.done) 
        { 
            /*[_syncCondition lock];
            [_syncCondition wait];
            [_syncCondition unlock];*/
            dispatch_semaphore_wait(_frameRenderingSemaphore, DISPATCH_TIME_FOREVER);
        }
        [self release];
    }
}
- (void)dealloc
{
    [_target release];
    [_queue release];
    //[_syncCondition release];
    if(_frameRenderingSemaphore) {
        dispatch_release(_frameRenderingSemaphore);
    }
    [super dealloc];
}
@end

@implementation FloggerQueue
@synthesize priority;
- (id)init
{
    self = [super init];
    if (self) {
        _array = [[NSMutableArray alloc] init];
        _condition = [[NSCondition alloc] init];
        _thread = [[NSThread alloc]
                   initWithTarget:self selector:@selector(execQueue) object:nil];
        self.priority = 0.5;
  
    }
    return self;
}
- (void) start
{
    if([_thread isFinished] || [_thread isExecuting] || [_thread isExecuting])
    {
        return;
    }
    [_thread start];   
}
- (void)addTask:(id)target selector:(SEL)selector withObject:(id)param sync:(BOOL) sync
{
    [_condition lock];
    FloggerTask *task = [[FloggerTask alloc]
                        initWithTarget:target selector:selector withObject:param queue:self sync:sync];
    [_array addObject:task];
    [_condition signal];
    [_condition unlock];
    if(sync)
    {
        [task lock];
    }
}
- (void)performTask:(id)target selector:(SEL)selector withObject:(id) param Sync:(BOOL) sync
{
    [self addTask:target selector:selector withObject:param sync:sync];
}

- (void)quit
{
    [self addTask:nil selector:nil withObject:nil sync:NO];
}

- (void)execQueue
{
    [NSThread setThreadPriority:self.priority];
    for (;;) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        [_condition lock];
        if (_array.count == 0)
            [_condition wait];
        FloggerTask *task = [_array objectAtIndex:0];
        [_array removeObjectAtIndex:0];
        [_condition unlock];
        
        if (!task.target) {
            [task release];
            [pool drain];
            break;
        }
        
        [task exec];
        [task release];
        //task.done =YES;
        /*if(!task.sync)
        {
            [task release];
        }*/
        
        [pool drain];
    }
}

- (void)dealloc
{
    [self quit];
    [_array release];
    [_condition release];
    [super dealloc];
}
@end

/*@implementation FloggerQueue
@synthesize isAlive;
- (id)init
{
    self = [super init];
    if (self) {
        _thread = [[NSThread alloc]
                   initWithTarget:self selector:@selector(startRunLoop:) object:nil];
        self.isAlive = YES;
        _condition = [[NSCondition alloc] init];
        [_thread start];
    }
    return self;
}
- (void)startRunLoop:(id)param
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    while (self.isAlive &&[runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
    }
    //[[NSRunLoop currentRunLoop] run];
    
    [pool release];
}
- (void)performTask:(id)target selector:(SEL)selector withObject:(id) param Sync:(BOOL) sync
{
    [target performSelector:selector onThread:_thread withObject:param waitUntilDone:sync];
    //[_thread start];
}
-(void) quit{
    self.isAlive = NO;
}
@end*/