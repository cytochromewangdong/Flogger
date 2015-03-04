//
//  BaseModel.h
//  Flogger
//
//  Created by jwchen on 11-12-26.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<NSCoding>
{
    NSMutableDictionary *_dataDict;
}

//@property (retain)NSNumber* id;

@property(nonatomic, retain)NSMutableDictionary *dataDict;


-(void)setInt:(NSUInteger)value forKey:(NSString *)key;
-(void)setObject:(id)value forKey:(NSString *)key;

-(NSUInteger)intForKey:(NSString *)key;
-(id)objectForKey:(NSString *)key;
@end
