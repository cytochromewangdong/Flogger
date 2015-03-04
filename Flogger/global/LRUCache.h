//
//  LRUCache.h
//  Flogger
//
//  Created by jwchen on 12-3-16.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRUCache : NSObject
@property(nonatomic, assign) NSInteger maxCount;
@property(nonatomic, readonly) NSArray *dataArray;

-(void)addObject:(id)object;
-(void)load;
-(void)save;
@end
