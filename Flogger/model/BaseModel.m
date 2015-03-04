//
//  BaseModel.m
//  Flogger
//
//  Created by jwchen on 11-12-26.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

@synthesize dataDict = _dataDict;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.dataDict = [aDecoder decodeObject];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.dataDict];
}

-(id)init
{
    self = [super init];
    if (self) {
        _dataDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(BOOL)succeed
{
//    NSLog(@"ret: %@", self);
    return YES;
}

-(void)setInt:(NSUInteger)value forKey:(NSString *)key
{
    [_dataDict setObject:[NSNumber numberWithInt:value] forKey:key];
}
-(void)setObject:(id)value forKey:(NSString *)key
{
    [_dataDict setObject:value forKey:key];
}

-(NSUInteger)intForKey:(NSString *)key
{
    NSNumber *number = [_dataDict objectForKey:key];
    return number? [number intValue] : -1;
}

-(id)objectForKey:(NSString *)key
{
    return [_dataDict objectForKey:key];
}


-(void)dealloc
{
    self.dataDict = nil;
    [super dealloc];
}

@end
