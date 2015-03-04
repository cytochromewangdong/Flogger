//
//  FloggerUtility.m
//  FloggerVideo
//
//  Created by wyf on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FloggerUtility.h"
static NSMutableDictionary *data;
@implementation FloggerUtility
+(void)initialize
{
    //data = [[NSMutableDictionary alloc]init];
}
+(UIImage *) thumbnailImage: (NSString *) imagePath
{
    //UIImage *image = [data objectForKey:imagePath];
    //if(image) return image;
     UIImage *image = [UIImage imageNamed:imagePath];
    //[data setObject:image forKey:imagePath];
    return image;
}
+(UIImage*) copyImage:(CGImageRef) inImage
{
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	
	//int length = CFDataGetLength(m_DataRef);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
											 CGImageGetWidth(inImage),  
											 CGImageGetHeight(inImage),  
											 CGImageGetBitsPerComponent(inImage),
											 CGImageGetBytesPerRow(inImage),  
											 CGImageGetColorSpace(inImage),  
											 CGImageGetBitmapInfo(inImage) 
											 ); 
	
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    [finalImage retain];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
	return finalImage;
	
}


+(CVImageBufferRef) obtainPixelBufferFromCGImage:(CGImageRef)image
{
    //    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    CGSize frameSize = CGSizeMake(CGImageGetHeight(image), CGImageGetWidth(image));
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                          frameSize.height,  kCVPixelFormatType_32BGRA, (CFDictionaryRef) options, 
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
                                                 frameSize.height, 8, 4*frameSize.width, rgbColorSpace, 
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
    
    CGContextDrawImage(context, CGRectMake(0, 0, frameSize.width,frameSize.height), image);
    //    CGContextDrawImage(context, CGRectMake(0, 0, 50, 
    //                                           50), testImage);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    
    return pxbuffer; 
    
    
}

+(CVImageBufferRef) obtainPixelBufferFromCGImage:(CGImageRef)image withSize : (CGSize) videoSize
{
    CGSize frameSize;
    if (videoSize.width > videoSize.height) 
    {
        frameSize = CGSizeMake(CGImageGetHeight(image), CGImageGetWidth(image));
    } else
    {
        frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    }
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                          frameSize.height,  kCVPixelFormatType_32BGRA, (CFDictionaryRef) options, 
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
                                                 frameSize.height, 8, 4*frameSize.width, rgbColorSpace, 
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
    
    CGContextDrawImage(context, CGRectMake(0, 0, frameSize.width,frameSize.height), image);
    //    CGContextDrawImage(context, CGRectMake(0, 0, 50, 
    //                                           50), testImage);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    
    return pxbuffer; 
    
    
}

@end
