//
//  FilteredWebCache.h
//  WdaTest
//
//  Created by dong wang on 11-11-28.
//  Copyright (c) 2011年 atoato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloggerFilteredWebCache : NSURLCache
@property (retain,nonatomic) NSMutableDictionary *memCache;
@end
