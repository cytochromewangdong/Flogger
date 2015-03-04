//
//  SDImageDelegate.h
//  Flogger
//
//  Created by dong wang on 12-4-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"

@interface SDImageDelegate : NSObject<SDWebImageManagerDelegate>
{
    UIImage *_image;
}

@property (retain) NSString *lastKey; 
@property (assign) id delegate;
@property (retain) UIImage *image;
@property (assign) id userInfo;
- (BOOL)loadImageWithURL:(NSString *)key;
- (BOOL)loadImageWithURL:(NSString*)key placeholderImage:(UIImage *)placeholder;
- (void)cancelCurrentImageLoad;
@end
