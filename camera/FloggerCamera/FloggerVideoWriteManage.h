//
//  FloggerVideoWriteManage.h
//  FloggerVideo
//
//  Created by wyf on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FloggerCommon.h"

@interface FloggerVideoWriteManage : NSObject
{
    AVAssetWriter *_assetWriter;
    AVAssetWriterInput *_videoAssetWriterInput;
    AVAssetWriterInput *_audioAssetWriterInput;
    AVAssetWriterInputPixelBufferAdaptor *_inputBufferAdaptor;
    
}

//writer
@property (retain, nonatomic) AVAssetWriter *assetWriter;
@property (retain, nonatomic) AVAssetWriterInput *videoAssetWriterInput;
@property (retain, nonatomic) AVAssetWriterInput *audioAssetWriterInput;
@property (retain, nonatomic) AVAssetWriterInputPixelBufferAdaptor *inputBufferAdaptor;
@property (assign, nonatomic) BOOL isBackgroundRender;


- (NSURL *) tempFileURL;
-(void) setupAssetWriter : (UIDeviceOrientation) interfaceOrientation;

@end
