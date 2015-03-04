//
//  DataCache.m
//  FuelOa
//
//  Created by jwchen on 12-1-5.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "DataCache.h"
#import <CommonCrypto/CommonDigest.h>

static NSInteger cacheMaxCacheAge = 60*60*24*7;

static DataCache *instance;
@implementation DataCache

+(DataCache *)sharedInstance
{
    if (!instance) {
        instance = [[DataCache alloc] init];
    }
    
    return instance;
}

+(void)purgeSharedInstance
{
    [instance release];
    instance = nil;
}

//SYNTHESIZE_SINGLETON_FOR_CLASS(DataCache);

- (id)init
{
    if ((self = [super init]))
    {
        // Init the memory cache
        memCache = [[NSMutableDictionary alloc] init];
        
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        diskCachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"] retain];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        // Init the operation queue
        cacheInQueue = [[NSOperationQueue alloc] init];
        cacheInQueue.maxConcurrentOperationCount = 1;
        cacheOutQueue = [[NSOperationQueue alloc] init];
        cacheOutQueue.maxConcurrentOperationCount = 1;
        
#if TARGET_OS_IPHONE
        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
#ifdef __IPHONE_4_0
        UIDevice *device = [UIDevice currentDevice];
        if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported)
        {
            // When in background, clean memory in order to have less chance to be killed
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(clearMemory)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
#endif
#endif
    }
    
    return self;
}

- (void)dealloc
{
    [memCache release], memCache = nil;
    [diskCachePath release], diskCachePath = nil;
    [cacheInQueue release], cacheInQueue = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

#pragma mark SDImageCache (private)

- (NSString *) cacheFileNameForKey:(NSString *)key
{
    /*const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;*/
    return [self cacheFileNameForKey:key andCategory:nil];
}

- (NSString *) cacheFileNameForKey:(NSString *)key andCategory:(NSString *)category
{
    NSString *saveKey = category?[NSString stringWithFormat:@"%@.%@",category, key]:key;
//    NSLog(@"all save key: %@",saveKey);
    const char *str = [saveKey UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;
    //return [self cachePathForKey:key andCategory:nil];
}

- (NSString *)cachePathForKey:(NSString *)key andCategory:(NSString *)category
{
    /*const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];*/
    NSString * filename = [self cacheFileNameForKey:key andCategory:category];
    
    NSString *cachePath = diskCachePath;
    if (category) {
        cachePath = [cachePath stringByAppendingPathComponent:category];
    }
    cachePath = [cachePath stringByAppendingPathComponent:filename];
    
    return cachePath;
}

- (NSString *)cachePathForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return [diskCachePath stringByAppendingPathComponent:filename];
}

//- (void)storeKeyWithDataToDisk:(NSArray *)keyAndData
//{
//    // Can't use defaultManager another thread
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    
//    NSString *key = [keyAndData objectAtIndex:0];
//    NSData *data = [keyAndData count] > 1 ? [keyAndData objectAtIndex:1] : nil;
//    
//    if (data)
//    {
//        [fileManager createFileAtPath:[self cachePathForKey:key] contents:data attributes:nil];
//    }
//    [fileManager release];
//}

- (void)storeKeyWithDataToDisk:(NSArray *)keyAndData
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *key = [keyAndData objectAtIndex:0];
    NSData *data = [keyAndData count] > 1 ? [keyAndData objectAtIndex:1] : nil;
    
    NSString *category = [keyAndData count] > 2 ? [keyAndData objectAtIndex:2] : nil;
    
    if (data)
    {
        NSString *fileName = diskCachePath;
        //test start
//        BOOL isExist =  [fileManager fileExistsAtPath:fileName];
        //test end
        if (category) {
            fileName = [diskCachePath stringByAppendingPathComponent:category];
            
            if (![fileManager fileExistsAtPath:fileName]) {
                NSError *error = nil;
                
                [[NSFileManager defaultManager] createDirectoryAtPath:fileName withIntermediateDirectories:YES attributes:nil error:&error];
                if (error) {
//                    NSLog(@"error===== is %@",error.localizedFailureReason);
                }
            }
        }
        fileName = [ fileName stringByAppendingPathComponent: [self cacheFileNameForKey:key andCategory:category]];
//        NSLog(@"storeKeyWithDataToDisk fileName is %@",fileName);
        [fileManager createFileAtPath:fileName contents:data attributes:nil];
    }
    [fileManager release];
}

-(void)storeDataToDisk:(NSData *)data forKey:(NSString *)key category:(NSString *)category wait2Done:(BOOL)isWait2Done
{
    NSArray *keyWithData;
    
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
    if (key) {
        [array addObject:key];
    }
    
    if (data) {
        [array addObject:data];
    }
    
    if(category)
    {
        [array addObject:category];
    }
    
    keyWithData = array;
    
//    if (data)
//    {
//        keyWithData = [NSArray arrayWithObjects:key, data, nil];
//    }
//    else
//    {
//        keyWithData = [NSArray arrayWithObjects:key, nil];
//    }
    if (!isWait2Done) {
        [cacheInQueue addOperation:[[[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(storeKeyWithDataToDisk:)
                                                                           object:keyWithData] autorelease]];
    }
    else
    {
        [self storeKeyWithDataToDisk:keyWithData];
    }
}

-(void)storeDataToDisk:(NSData *)data forKey:(NSString *)key wait2Done:(BOOL)isWait2Done
{
    NSArray *keyWithData;
    if (data)
    {
        keyWithData = [NSArray arrayWithObjects:key, data, nil];
    }
    else
    {
        keyWithData = [NSArray arrayWithObjects:key, nil];
    }
    if (!isWait2Done) {
        [cacheInQueue addOperation:[[[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(storeKeyWithDataToDisk:)
                                                                           object:keyWithData] autorelease]];
    }
    else
    {
        [self storeKeyWithDataToDisk:keyWithData];
    }
}

-(void)storeDataToDisk:(NSData *)data forKey:(NSString *)key
{
    [self storeDataToDisk:data forKey:key wait2Done:NO];
}

-(void)storeDataToDisk:(NSData *)data forKey:(NSString *)key category:(NSString *)category
{
    [self storeDataToDisk:data forKey:key category:category wait2Done:NO];
}

-(void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    [self storeImage:image forKey:key Category:nil];
}

-(void)storeImage:(UIImage *)image forKey:(NSString *)key Category:(NSString *)category
{
    if (!image || !key)
    {
        return;
    }
    
    NSString *saveKey = category?[NSString stringWithFormat:@"%@.%@",category, key]:key;
    NSData * imageData = UIImageJPEGRepresentation(image, 1.0);
    [memCache setObject:image forKey:saveKey];
    [self storeDataToDisk:imageData forKey:key category:category];
}
-(void)storeString:(NSString *)string forKey:(NSString *)key
{
    [self storeString:string forKey:key Category:nil];
}

-(void)storeString:(NSString *)string forKey:(NSString *)key Category:(NSString *)category
{
    if (!string || !key)
    {
        return;
    }
    NSString *saveKey = category?[NSString stringWithFormat:@"%@.%@",category, key]:key;
    NSData *strData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [memCache setObject:string forKey:saveKey];
    [self storeDataToDisk:strData forKey:key category:category];
}

-(void)storeData:(NSData *)data forKey:(NSString *)key wait2Done:(BOOL)isWait2Done
{
    if (!data || !key)
    {
        return;
    }
    
    [memCache setObject:data forKey:key];
    [self storeDataToDisk:data forKey:key wait2Done:isWait2Done];
}

- (void)storeData:(NSData *)data forKey:(NSString *)key
{
    [self storeData:data forKey:key Category:nil];
}

- (void)storeData:(NSData *)data forKey:(NSString *)key Category:(NSString *)category
{
    if (!data || !key)
    {
        return;
    }
    NSString *saveKey = category?[NSString stringWithFormat:@"%@.%@",category, key]:key;
    [memCache setObject:data forKey:saveKey];
    [self storeDataToDisk:data forKey:key category:category];
    
}
- (NSData *)dataFromKey:(NSString *)key 
{
    return [self dataFromKey:key Category:nil];
}

- (NSData *)dataFromKey:(NSString *)key Category:(NSString *)category
{
    if (key == nil)
    {
        return nil;
    }
    
    NSString *saveKey = category?[NSString stringWithFormat:@"%@.%@",category, key]:key;
    NSData *data = [memCache objectForKey:saveKey];
    
    if (!data)
    {
        data = [NSData dataWithContentsOfFile:[self cachePathForKey:key andCategory:category]];
        if (data)
        {
            [memCache setObject:data forKey:saveKey];
        } else {
            [self removeDataForKey:key Category:category];
        }
    }
    
    return data;
}
- (NSString *)stringFromKey:(NSString *)key
{
    return [self stringFromKey:key Category:nil];
}

- (NSString *)stringFromKey:(NSString *)key Category:(NSString *)category
{
    if (key == nil)
    {
        return nil;
    }
   NSString *saveKey = category?[NSString stringWithFormat:@"%@.%@",category, key]:key;
    NSString *str = [memCache objectForKey:saveKey];
    if (!str)
    {
        
        str = [NSString stringWithContentsOfFile:[self cachePathForKey:key andCategory:category] encoding:NSUTF8StringEncoding error:nil];
        if (str)
        {
            [memCache setObject:str forKey:saveKey];
        }
    }
    
    return str;
}
- (UIImage *)imageFromKey:(NSString *)key 
{
    return [self imageFromKey:key Category:nil];
}
- (UIImage *)imageFromKey:(NSString *)key  Category:(NSString *)category
{
    if (key == nil)
    {
        return nil;
    }
    
   NSString *saveKey = category?[NSString stringWithFormat:@"%@.%@",category, key]:key;
    UIImage *image = [memCache objectForKey:saveKey];
    
    if (!image)
    {
        image = [UIImage imageWithContentsOfFile:[self cachePathForKey:key andCategory:category]];
        if (image)
        {
            [memCache setObject:image forKey:saveKey];
        } else{
            [self removeDataForKey:key Category:category];
        }
    }
    
    return image;
}


- (NSString *)pathForKey:(NSString *)key
{
    NSString *path = [self cachePathForKey:key];
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    if([fileManager fileExistsAtPath:path])
    {
        return path;
    }
    else
    {
        return nil;
    }
}

- (void)removeDataByCategory:(NSString *)category
{
    if (!category) {
        return;
    }
    
    [self clearMemory];
    
   // NSFileManager *removeFileManager = [[[NSFileManager alloc] init] autorelease];
    [[NSFileManager defaultManager] removeItemAtPath:[diskCachePath stringByAppendingPathComponent:category] error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[diskCachePath stringByAppendingPathComponent:category]
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}

- (void)removeDataForKey:(NSString *)key
{
    /*if (key == nil)
    {
        return;
    }
    
    [memCache removeObjectForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:nil];*/
    [self removeDataForKey:key Category:nil];
}
- (void)removeDataForKey:(NSString *)key Category:(NSString*)category
{
    if (key == nil)
    {
        return;
    }
    NSString *saveKey = category?[NSString stringWithFormat:@"%@.%@",category, key]:key;
    [memCache removeObjectForKey:saveKey];
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key andCategory:category] error:nil];
}
- (void)clearMemory
{
    [cacheInQueue cancelAllOperations]; // won't be able to complete
    [memCache removeAllObjects];
}

- (void)clearDisk
{
    [cacheInQueue cancelAllOperations];
    [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}

- (void)cleanDisk
{
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-cacheMaxCacheAge];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}


@end
