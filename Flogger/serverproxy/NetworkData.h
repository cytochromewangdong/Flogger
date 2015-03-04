//
//  NetworkData.h
//  Flogger
//
//  Created by jwchen on 12-1-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityEnumHeader.h"

@interface NetworkData : NSObject
{
    @private
    NSMutableDictionary *_mandantoryDict;
    NSMutableDictionary *_commonHeaderDict;
}
//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(NetworkData);
+(NetworkData *)sharedInstance;
+(void)purgeSharedInstance;
@property(nonatomic, retain) NSMutableDictionary *mandantoryDict, *commonHeaderDict;
@end
