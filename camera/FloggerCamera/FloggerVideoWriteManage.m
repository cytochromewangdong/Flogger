//
//  FloggerVideoWriteManage.m
//  FloggerVideo
//
//  Created by wyf on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FloggerVideoWriteManage.h"

@implementation FloggerVideoWriteManage
@synthesize assetWriter = _assetWriter;
@synthesize videoAssetWriterInput = _videoAssetWriterInput;
@synthesize audioAssetWriterInput = _audioAssetWriterInput;
@synthesize inputBufferAdaptor = _inputBufferAdaptor;
@synthesize isBackgroundRender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
    return self;
}

- (NSURL *) tempFileURL
{
//    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    NSString *outputPath = [[[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"] autorelease];
    if (isBackgroundRender) {
        outputPath = [[[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"backgroundoutput.mov"] autorelease];
    }
    
    NSURL *outputURL = [[[NSURL alloc] initFileURLWithPath:outputPath] autorelease];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO) {         
        }
    }
//    [outputPath release];
    return outputURL;
}


- (NSURL *) testFileURL
{
    //    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"test.mov"];
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"test.mov"];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO) {         
        }
    }
    [outputPath release];
    return [outputURL autorelease];
}



- (CGFloat)angleOffsetFromPortraitOrientationToOrientation:(AVCaptureVideoOrientation)orientation
{
	CGFloat angle = 0.0;
	
	switch (orientation) {
		case AVCaptureVideoOrientationPortrait:
			angle = 0.0;
			break;
		case AVCaptureVideoOrientationPortraitUpsideDown:
			angle = M_PI;
			break;
		case AVCaptureVideoOrientationLandscapeRight:
			angle = -M_PI_2;
			break;
		case AVCaptureVideoOrientationLandscapeLeft:
			angle = M_PI_2;
			break;
		default:
			break;
	}
    
	return angle;
}

- (CGAffineTransform)transformFromCurrentVideoOrientationToOrientation:(AVCaptureVideoOrientation)orientation
{
	CGAffineTransform transform = CGAffineTransformIdentity;
    
	// Calculate offsets from an arbitrary reference orientation (portrait)
	CGFloat orientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:orientation];
    
//    AVCaptureVideoOrientation videoOrientation = []
//	CGFloat videoOrientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:videoOrientation];
	
	// Find the difference in angle between the passed in orientation and the current video orientation
//	CGFloat angleOffset = orientationAngleOffset - videoOrientationAngleOffset;
//	transform = CGAffineTransformMakeRotation(angleOffset);
    transform = CGAffineTransformMakeRotation(orientationAngleOffset);
//    NSLog(@"rotate angelOffset is %f",angleOffset);
//    NSLog(@"orientationAngleOffset is %f",orientationAngleOffset);
//    NSLog(@"videoOrientationAngleOffset is %f",videoOrientationAngleOffset);
	
	return transform;
}

-(void) setupAssetWriter : (UIDeviceOrientation) interfaceOrientation
{    
    NSError *error = nil;
    //set up assetwriter
    //url
    NSURL *fileURL = [self tempFileURL];
    
    
    CGFloat assetWidth = RECORDING_OUTPUT_WIDTH;
    CGFloat assetHeight = RECORDING_OUTPUT_HEIGHT;
//    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
//    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//        assetWidth = RECORDING_OUTPUT_HEIGHT;
//        assetHeight = RECORDING_OUTPUT_WIDTH;
//    }
    AVAssetWriter *assetWirter =  [[[AVAssetWriter alloc] initWithURL:fileURL fileType:AVFileTypeQuickTimeMovie error:&error ] autorelease];
    
//        AVAssetWriter *assetWirter =  [[[AVAssetWriter alloc] initWithURL:fileURL fileType:AVFileTypeMPEG4 error:&error ] autorelease];
//    [assetWirter setMovieFragmentInterval:0.01];
    //set up assetwriterInput
//    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   AVVideoCodecH264, AVVideoCodecKey,
//                                   [NSNumber numberWithInt:RECORDING_OUTPUT_WIDTH], AVVideoWidthKey,
//                                   [NSNumber numberWithInt:RECORDING_OUTPUT_HEIGHT], AVVideoHeightKey,
//                                   nil];
    
    //test begin
    NSDictionary *videoCleanApertureSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [NSNumber numberWithInt:assetWidth], AVVideoCleanApertureWidthKey,
                                                [NSNumber numberWithInt:assetHeight], AVVideoCleanApertureHeightKey,
                                                [NSNumber numberWithInt:10], AVVideoCleanApertureHorizontalOffsetKey,
                                                [NSNumber numberWithInt:10], AVVideoCleanApertureVerticalOffsetKey,
                                                nil];
    
//    NSDictionary *videoAspectRatioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                              [NSNumber numberWithInt:3], AVVideoPixelAspectRatioHorizontalSpacingKey,
//                                              [NSNumber numberWithInt:3],AVVideoPixelAspectRatioVerticalSpacingKey,
//                                              nil];
    
    
    
    NSDictionary *codecSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:1500*1000], AVVideoAverageBitRateKey,
//                                   [NSNumber numberWithInt:1],AVVideoMaxKeyFrameIntervalKey,
                                   videoCleanApertureSettings, AVVideoCleanApertureKey,
                                   //videoAspectRatioSettings, AVVideoPixelAspectRatioKey,
                                   //AVVideoProfileLevelH264Main30, AVVideoProfileLevelKey,
                                   nil];
//    NSString *targetDevice = [[UIDevice currentDevice] model];
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   codecSettings,AVVideoCompressionPropertiesKey,
//                                   AVVideoScalingModeResizeAspect,AVVideoScalingModeKey,
                                   [NSNumber numberWithInt:assetWidth], AVVideoWidthKey,
                                   [NSNumber numberWithInt:assetHeight], AVVideoHeightKey,
                                   nil];
    
    //test end
//    UIBarButtonSystemItemAdd
    AVAssetWriterInput *videoAssetWriterInput = [[[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:videoSettings] autorelease];
    
//    movieFragmentInterval
//    [videoAssetWriterInput setmo]
    [videoAssetWriterInput setExpectsMediaDataInRealTime:YES];
    
    videoAssetWriterInput.transform = [self transformFromCurrentVideoOrientationToOrientation:interfaceOrientation];
    
    //set up inputBufferAdaptor
    NSDictionary *adaptorSetting = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA],kCVPixelBufferPixelFormatTypeKey,nil];
    AVAssetWriterInputPixelBufferAdaptor *inputBufferAdaptor = [[[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:videoAssetWriterInput sourcePixelBufferAttributes:adaptorSetting] autorelease];
    
    
    
    // Add the audio input
    AudioChannelLayout acl;
    bzero( &acl, sizeof(acl));
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
    
    
    NSDictionary* audioOutputSettings = nil;          
    // Both type of audio inputs causes output video file to be corrupted.
    if( NO ) {
        // should work from iphone 3GS on and from ipod 3rd generation
        audioOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                               [ NSNumber numberWithInt: kAudioFormatMPEG4AAC ], AVFormatIDKey,
                               [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,
                               [ NSNumber numberWithFloat: 44100.0 ], AVSampleRateKey,
                               [ NSNumber numberWithInt: 64000 ], AVEncoderBitRateKey,
                               [ NSData dataWithBytes: &acl length: sizeof( acl ) ], AVChannelLayoutKey,
                               nil];
    } else {
        // should work on any device requires more space
//        audioOutputSettings = [ NSDictionary dictionaryWithObjectsAndKeys:                       
//                               [ NSNumber numberWithInt: kAudioFormatAppleLossless ], AVFormatIDKey,
//                               [ NSNumber numberWithInt: 16 ], AVEncoderBitDepthHintKey,
//                               [ NSNumber numberWithFloat: 44100.0 ], AVSampleRateKey,
//                               [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,                                      
//                               [ NSData dataWithBytes: &acl length: sizeof( acl ) ], AVChannelLayoutKey,
//                               nil ];
        audioOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                               [ NSNumber numberWithInt: kAudioFormatMPEG4AAC ], AVFormatIDKey,
                               [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,
                               [ NSNumber numberWithFloat: 44100.0 ], AVSampleRateKey,
                               [ NSNumber numberWithInt: 64000 ], AVEncoderBitRateKey,
                               [ NSData dataWithBytes: &acl length: sizeof( acl ) ], AVChannelLayoutKey,
                               nil];
    } 
    
    AVAssetWriterInput *audioAssetWriterInput = [AVAssetWriterInput 
                                                 assetWriterInputWithMediaType: AVMediaTypeAudio 
                                                 outputSettings: audioOutputSettings ];
    //[[AVAssetWriterInput assetWriterInputWithMediaType: AVMediaTypeAudio outputSettings: audioOutputSettings ] retain];
    
    [audioAssetWriterInput setExpectsMediaDataInRealTime:NO];
    
    //add videoSetWriterInput and audioSetWriterInput in SetWriter
    [assetWirter addInput:videoAssetWriterInput];
    [assetWirter addInput:audioAssetWriterInput];
    
    [self setAssetWriter:assetWirter];
    [self setVideoAssetWriterInput:videoAssetWriterInput];
    [self setAudioAssetWriterInput:audioAssetWriterInput];
    [self setInputBufferAdaptor:inputBufferAdaptor];
    
//    NSLog(@"===setwriter finish====");
    
}





-(void) dealloc
{
    [self setAssetWriter:nil];
    [self setVideoAssetWriterInput:nil];
    [self setAudioAssetWriterInput:nil];
    [self setInputBufferAdaptor:nil];
    
    [super dealloc];
}



@end
