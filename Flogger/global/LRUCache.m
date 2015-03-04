//
//  LRUCache.m
//  Flogger
//
//  Created by jwchen on 12-3-16.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "LRUCache.h"
#import "DataCache.h"
#import "SBJson.h"

#define kMaxCount 100

static NSString *kLRUCache = @"LRUCache";

@interface LRUCache()
{
    NSMutableArray *_dataArray;
}
@end

@implementation LRUCache

@synthesize dataArray, maxCount;

-(id)init
{
    self = [super init];
    if (self) {
        maxCount = kMaxCount;
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSArray *)dataArray
{
    return _dataArray;
}

-(void)addObject:(id)object
{
    if ([_dataArray containsObject:object]) {
        [_dataArray removeObject:object];
    }
    else if(_dataArray.count >= self.maxCount){
        [_dataArray removeLastObject];
    }
    
    [_dataArray insertObject:object atIndex:0];
}

-(void)save
{
    SBJsonWriter* writer = [[[SBJsonWriter alloc] init] autorelease];
    NSData *data = [writer dataWithObject: _dataArray];
    if (data) {
        [[DataCache sharedInstance] storeData:data forKey:kLRUCache];
    }
}

-(void)load
{
    NSData *data = [[DataCache sharedInstance] dataFromKey:kLRUCache];
    if (data) {
        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
        NSArray *array = [parser objectWithData:data];
        if (array) {
            [_dataArray addObjectsFromArray:array];
        }
    }
    
}

-(void)dealloc
{
    [self save];
    [_dataArray release];
    _dataArray = nil;
    [super dealloc];
}
@end
