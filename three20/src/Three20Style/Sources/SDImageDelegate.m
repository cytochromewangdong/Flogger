//
//  SDImageDelegate.m
//  Flogger
//
//  Created by dong wang on 12-4-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SDImageDelegate.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation SDImageDelegate
@synthesize delegate;
@synthesize lastKey;
@synthesize image = _image;
@synthesize userInfo;
- (BOOL)loadImageWithURL:(NSString*) key
{
    return [self loadImageWithURL:key placeholderImage:nil];
}
- (BOOL)loadImageWithURL:(NSString*)key placeholderImage:(UIImage *)placeholder
{
    self.lastKey = key;
    //BOOL ret =  [[SDImageCache sharedImageCache] imageExists:key];
    self.image = [[SDImageCache sharedImageCache] imageFromKey:key];
    if (self.image) return YES;
    if (![[key lowercaseString] hasPrefix:@"http:"] && ![[key lowercaseString] hasPrefix:@"https:"])
    {
        self.image = [UIImage imageNamed:key];
        if (!self.image)
        {
            self.image = [[[UIImage alloc] initWithContentsOfFile:key] autorelease];
            //NSString *ext = [key pathExtension];
            //NSString *prefix = [key stringByDeletingPathExtension];
            //NSString *newPath = [NSString stringWithFormat:@"%@@2x.%@",prefix,ext];
            //NSLog(@"path===%@",newPath);
            
        }
        return YES;
    }
    if(self.image) return YES;
    self.image = placeholder;
    SDWebImageManager *manager = (SDWebImageManager*)[SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    if (key)
    {
        [manager downloadWithURL:[NSURL URLWithString:key]  delegate:self];
    }
    return NO;
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
    if(delegate)
    {
        [delegate performSelector:@selector(downloadFinished:) withObject:self];
    }
}
-(void) dealloc
{
    self.lastKey = nil;
    self.image = nil;
    [super dealloc];
    
}
@end
