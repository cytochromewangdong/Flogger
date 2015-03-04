//
//  FloggerCommon.h
//  FloggerVideo
//
//  Created by wyf on 12-2-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PRIVIEW_OUTPUT_WIDTH 320
#define PRIVIEW_OUTPUT_HEIGHT 426

//#define PRIVIEW_OUTPUT_WIDTH 640
//#define PRIVIEW_OUTPUT_HEIGHT 852

//#define RECORDING_OUTPUT_WIDTH 360
//#define RECORDING_OUTPUT_HEIGHT 480
#if defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    #define RECORDING_OUTPUT_WIDTH 480
    #define RECORDING_OUTPUT_HEIGHT 640
#else
    #define RECORDING_OUTPUT_WIDTH 360
    #define RECORDING_OUTPUT_HEIGHT 480
#endif

#define JPEGQUAILTY  0.85
//#define JPEGQUAILTY  0.7

#define VIDEOTIMESCALE 600


#define kBorderName @"borderName"
#define kFilterName @"filterName"

#define fCameraInfoImageSize @"imageSize"
#define fCameraInfoSyntax @"syntax"
#define fImage @"image"
//#define fVideo @"video"
#define fCameraInfoVideoSize @"videSize"
#define fVideoTransforRect @"videoTransforRect"
#define fVideoTimeSeconds @"videoTimeSeconds"
#define fVideoURL @"videoURL"
#define fVideoThumbnail @"videoThumbnail"
#define fVideoThumbnailPath @"videoThumbnailPath"
#define fImagePath @"imagePath"

@interface FloggerCommon : NSObject

@end
