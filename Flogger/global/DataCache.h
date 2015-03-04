//
//  DataCache.h
//  FuelOa
//
//  Created by jwchen on 12-1-5.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SynthesizeSingleton.h"

@interface DataCache : NSObject
{
    NSMutableDictionary *memCache;
    NSString *diskCachePath;
    NSOperationQueue *cacheInQueue, *cacheOutQueue;
}

+(DataCache *)sharedInstance;
+(void)purgeSharedInstance;

//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(DataCache);
- (NSString *)cachePathForKey:(NSString *)key andCategory:(NSString *)category;
-(void)storeImage:(UIImage *)image forKey:(NSString *)key;
-(void)storeString:(NSString *)string forKey:(NSString *)key;
-(void)storeData:(NSData *)data forKey:(NSString *)key;

-(void)storeImage:(UIImage *)image forKey:(NSString *)key Category:(NSString*)category;
-(void)storeString:(NSString *)string forKey:(NSString *)key Category:(NSString*)category;
-(void)storeData:(NSData *)data forKey:(NSString *)key Category:(NSString*)category;

-(void)storeData:(NSData *)data forKey:(NSString *)key wait2Done:(BOOL)isWait2Done;
-(void)storeDataToDisk:(NSData *)data forKey:(NSString *)key wait2Done:(BOOL)isWait2Done;

- (NSData *)dataFromKey:(NSString *)key;
- (NSString *)stringFromKey:(NSString *)key;
- (UIImage *)imageFromKey:(NSString *)key;

//- (NSData *)dataFromKey:(NSString *)key category:(NSString *)category;
- (NSString *)stringFromKey:(NSString *)key category:(NSString *)category;
- (UIImage *)imageFromKey:(NSString *)key category:(NSString *)category;

- (NSData *)dataFromKey:(NSString *)key Category:(NSString*)category;
- (NSString *)stringFromKey:(NSString *)key Category:(NSString*)category;
- (UIImage *)imageFromKey:(NSString *)key Category:(NSString*)category;

- (NSString *)cachePathForKey:(NSString *)key;
- (NSString *)pathForKey:(NSString *)key;

- (void)storeKeyWithDataToDisk:(NSArray *)keyAndData;
- (void)removeDataByCategory:(NSString *)category;
- (void)removeDataForKey:(NSString *)key;
- (void)removeDataForKey:(NSString *)key Category:(NSString*)category;
- (void)clearMemory;
- (void)clearDisk;
- (void)cleanDisk;
@end
