//
//  FilteredWebCache.m
//  WdaTest
//
//  Created by dong wang on 11-11-28.
//  Copyright (c) 2011年 atoato. All rights reserved.
//

#import "FloggerFilteredWebCache.h"
#import "SBJson.h"
@implementation FloggerFilteredWebCache
@synthesize memCache;
- (void)clearMemory
{
    [memCache removeAllObjects];
}
- (void) removeAllCachedResponses
{
    [super removeAllCachedResponses];
}
-(id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path
{
    self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path];
    if(self)
    {
        memCache = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}
- (NSCachedURLResponse*)cachedResponseForRequest:(NSURLRequest*)request
{
    NSURL *url = [request URL];
    //NSLog(@"==%@==%@===%@===%@", [url.host stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ,url.scheme,url.relativePath,url.absoluteString);
    //if(mem)
    NSCachedURLResponse *cResponse = [memCache objectForKey:url.absoluteString];
    if(cResponse)
    {
        return cResponse;
    }
    if([[SDImageCache sharedImageCache] imageExists:url.absoluteString]){
        NSURLResponse *response =
        [[NSURLResponse alloc] initWithURL:url
                                  MIMEType:@"image/jpeg"
                     expectedContentLength:1
                          textEncodingName:nil];
        
       // NSData *data = 
        UIImage* image =[[[SDImageCache sharedImageCache] imageFromKey:url.absoluteString] retain];
        NSCachedURLResponse *cachedResponse =
        [[[NSCachedURLResponse alloc] initWithResponse:response
                                                 data:UIImageJPEGRepresentation(image, (CGFloat)0.8)]autorelease];
        
        //[super storeCachedResponse:cachedResponse forRequest:request];
        [memCache setObject:cachedResponse forKey:url.absoluteString];
        [image release];
        //[cachedResponse release];
        [response release];
        return cachedResponse;
    }
    return [super cachedResponseForRequest:request];
}
-(void) dealloc
{
    self.memCache = nil;
    [super dealloc];
}
@end
