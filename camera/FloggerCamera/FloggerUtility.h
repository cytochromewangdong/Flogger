//
//  FloggerUtility.h
//  FloggerVideo
//
//  Created by wyf on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloggerUtility : NSObject
+(UIImage *) thumbnailImage: (NSString *) imagePath;
+(UIImage*) copyImage:(CGImageRef) inImage;
+(CVImageBufferRef) obtainPixelBufferFromCGImage:(CGImageRef)image;
+(CVImageBufferRef) obtainPixelBufferFromCGImage:(CGImageRef)image withSize : (CGSize) videoSize;
@end
