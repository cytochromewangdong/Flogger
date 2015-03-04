//
//  FloggerCaptureManage.m
//  FloggerVideo
//
//  Created by wyf on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FloggerCaptureManage.h"

@implementation FloggerCaptureManage
//capture
@synthesize captureSession=_captureSession;
@synthesize videoInput=_videoInput,videoCaptureOutput=_videoCaptureOutput;
@synthesize audioInput=_audioInput,audioCaptureOutput=_audioCaptureOutput;
@synthesize stillImageOutput=_stillImageOutput;
@synthesize outputDelegate = _outputDelegate;
@synthesize captureQueue;
@dynamic flashMode ,focusMode ,torchMode ,exposureMode ,whiteBalanceMode;


- (id)init
{
    [super init];
      
    return self;
}

-(void) setupCaptureSession: (NSString *) videoOrPhoto
{
    //session
    AVCaptureSession *captureSession = [[[AVCaptureSession alloc] init] autorelease];
    if ([videoOrPhoto isEqualToString:@"photo"]) {
        [captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
        
    } else if([videoOrPhoto isEqualToString:@"video"])
    {
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (version >= 5.0)
        {            
            [captureSession setSessionPreset:AVCaptureSessionPreset640x480];
        } else {
            [captureSession setSessionPreset:AVCaptureSessionPresetMedium];
        }
    }
    
//    [captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    
    
    //input
    AVCaptureDeviceInput *videoInput = [[[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera]  error:nil] autorelease]; 
    AVCaptureDeviceInput *audioInput = [[[AVCaptureDeviceInput alloc] initWithDevice:[self audioDevice] error:nil] autorelease];
    if ([captureSession canAddInput:videoInput]) {
        [captureSession addInput:videoInput];
    }
    if ([captureSession canAddInput:audioInput]) {
        [captureSession addInput:audioInput];
    }
    [self setVideoInput:videoInput];
    [self setAudioInput:audioInput];
    
    //output
    AVCaptureVideoDataOutput *videoCaptureOutput = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
    videoCaptureOutput.alwaysDiscardsLateVideoFrames = YES;
    //set video outputSetting
    NSString* key = (NSString *) kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSetting = [NSDictionary dictionaryWithObject:value forKey:key];
    [videoCaptureOutput setVideoSettings: videoSetting];
    AVCaptureAudioDataOutput *audioCaptureOutput = [[[AVCaptureAudioDataOutput alloc] init] autorelease];
    
    //set video and audio delegate
    captureQueue = dispatch_queue_create("capture", NULL);
    [videoCaptureOutput setSampleBufferDelegate:self queue:captureQueue]; 
   [audioCaptureOutput setSampleBufferDelegate:self queue:captureQueue];
    
    //    dispatch_queue_t audioCaptureQueue = dispatch_queue_create("audiocapture", NULL);
    //    [audioCaptureOutput setSampleBufferDelegate:self queue:audioCaptureQueue];
    //    dispatch_release(audioCaptureQueue);
    //add output
    if ([captureSession canAddOutput:videoCaptureOutput]) {
        [captureSession addOutput:videoCaptureOutput];
    }
    if ([captureSession canAddOutput:audioCaptureOutput]) {
        [captureSession addOutput:audioCaptureOutput];
    }
    [self setVideoCaptureOutput:videoCaptureOutput];
    [self setAudioCaptureOutput:audioCaptureOutput];
    //    [videoCaptureOutput setMinFrameDuration:1.];
    
    //take a picture
    //self.stillImageOutput
    AVCaptureStillImageOutput* stillImageOutput= [[[AVCaptureStillImageOutput alloc] init] autorelease];
    //    NSDictionary *stillImageOutputSetting = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    NSDictionary *stillImageOutputSetting = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                             AVVideoCodecJPEG, AVVideoCodecKey,
                                             nil] autorelease];
    [stillImageOutput setOutputSettings:stillImageOutputSetting];
    
    if ([captureSession canAddOutput:stillImageOutput]) {
        [captureSession addOutput:stillImageOutput];
    }
    [self setStillImageOutput:stillImageOutput];
    
    [self setCaptureSession:captureSession];
    
}

-(void) performWaitLoop
{
    dispatch_sync(self.captureQueue, ^{});
}

-(void) startCapture
{
//    NSLog(@"start capture");
//    [[self captureSession] setSessionPreset:AVCaptureSessionPresetHigh];
    [[self captureSession] startRunning];
}

-(void) captureStillImageReturnData
{
    AVCaptureConnection *videoConnection = [FloggerCaptureManage connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    if ([videoConnection isVideoOrientationSupported]) {
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                             if (imageDataSampleBuffer != NULL) {
//                                                                 NSLog(@"take a photo");
                                                                 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                                 UIImage *image = [[[UIImage alloc] initWithData:imageData] autorelease];   
                                                                  [self.outputDelegate performSelectorOnMainThread:@selector(dealWithImageDataImage:) withObject:(id)image waitUntilDone:YES];
                                                                 
                                                                 /*CVImageBufferRef pixBuffer = CMSampleBufferGetImageBuffer(imageDataSampleBuffer);
                                                                 NSLog(@"pixbuffer width is %zu == height is%zu",CVPixelBufferGetWidth(pixBuffer),CVPixelBufferGetHeight(pixBuffer))
                                                                 ;
                                                                 [self.outputDelegate performSelectorOnMainThread:@selector(dealWithImageData:) withObject:(id)pixBuffer waitUntilDone:YES];*/
//                                                                [[self captureSession] setSessionPreset:AVCaptureSessionPresetMedium];
                                                                 
                                                             } else if (error) {
                                                                 
                                                             }
                                                         }];
    
    
}

-(void) swapScreen
{
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [self videoInput];
    AVCaptureDevicePosition position = [[videoInput device] position];
    AVCaptureDeviceInput *newVideoInput = nil;
    if (position == AVCaptureDevicePositionFront) {
//        NSLog(@"swape to back");
        newVideoInput = [[[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error] autorelease];
        
    } else if (position == AVCaptureDevicePositionBack){
//        NSLog(@"swape to front");
        newVideoInput = [[[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error] autorelease];
    }
    if (newVideoInput != nil) {
        [[self captureSession] beginConfiguration];
        [[self captureSession] removeInput:videoInput];
        NSString *currentPreset = [[self captureSession] sessionPreset];
        if (![[newVideoInput device] supportsAVCaptureSessionPreset:currentPreset]) {
            [[self captureSession] setSessionPreset:AVCaptureSessionPresetHigh];
        }
        if ([[self captureSession] canAddInput:newVideoInput]) {
            [[self captureSession] addInput:newVideoInput];
            [self setVideoInput:newVideoInput];
        } else
        {
            [[self captureSession] setSessionPreset:currentPreset];
            [[self captureSession] addInput:videoInput];
        }
        [[self captureSession] commitConfiguration];
    }

    
}

//double lastTime ;
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
//    if (captureOutput == self.audioCaptureOutput) {
////        NSLog(@"lastTime is %f",CFAbsoluteTimeGetCurrent() - lastTime);
//        if ((CFAbsoluteTimeGetCurrent() - lastTime) < 0.01) {
//            return;
//        }
//        
//        lastTime = CFAbsoluteTimeGetCurrent();
//    }
    [self.outputDelegate  captureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection];
//    [self outputDelegate] performSelectorOnMainThread:<#(SEL)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#> modes:<#(NSArray *)#>
}


- (BOOL) hasFlash
{
    return [[[self videoInput] device] hasFlash];
}

- (AVCaptureFlashMode) flashMode
{
    return [[[self videoInput] device] flashMode];
}

- (void) setFlashMode:(AVCaptureFlashMode)flashMode
{
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isFlashModeSupported:flashMode] && [device flashMode] != flashMode) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        } else {

        }    
    }
}

- (BOOL) hasTorch
{
    return [[[self videoInput] device] hasTorch];
}

- (AVCaptureTorchMode) torchMode
{
    return [[[self videoInput] device] torchMode];
}

- (void) setTorchMode:(AVCaptureTorchMode)torchMode
{
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isTorchModeSupported:torchMode] && [device torchMode] != torchMode) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setTorchMode:torchMode];
            [device unlockForConfiguration];
        } else {

        }
    }
}

- (BOOL) hasFocus
{
    AVCaptureDevice *device = [[self videoInput] device];
    
    return  [device isFocusModeSupported:AVCaptureFocusModeLocked] ||
    [device isFocusModeSupported:AVCaptureFocusModeAutoFocus] ||
    [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus];
}

- (AVCaptureFocusMode) focusMode
{
    return [[[self videoInput] device] focusMode];
}

- (void) setFocusMode:(AVCaptureFocusMode)focusMode
{
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isFocusModeSupported:focusMode] && [device focusMode] != focusMode) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setFocusMode:focusMode];
            [device unlockForConfiguration];
        } else {

        }    
    }
}

- (BOOL) hasExposure
{
    AVCaptureDevice *device = [[self videoInput] device];
    
    return  [device isExposureModeSupported:AVCaptureExposureModeLocked] ||
    [device isExposureModeSupported:AVCaptureExposureModeAutoExpose] ||
    [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure];
}

- (AVCaptureExposureMode) exposureMode
{
    return [[[self videoInput] device] exposureMode];
}

- (void) setExposureMode:(AVCaptureExposureMode)exposureMode
{
    if (exposureMode == 1) {
        exposureMode = 2;
    }
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isExposureModeSupported:exposureMode] && [device exposureMode] != exposureMode) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setExposureMode:exposureMode];
            [device unlockForConfiguration];
        } else {

        }
    }
}

- (BOOL) hasWhiteBalance
{
    AVCaptureDevice *device = [[self videoInput] device];
    
    return  [device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked] ||
    [device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance];
}

- (AVCaptureWhiteBalanceMode) whiteBalanceMode
{
    return [[[self videoInput] device] whiteBalanceMode];
}

- (void) setWhiteBalanceMode:(AVCaptureWhiteBalanceMode)whiteBalanceMode
{
    if (whiteBalanceMode == 1) {
        whiteBalanceMode = 2;
    }    
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isWhiteBalanceModeSupported:whiteBalanceMode] && [device whiteBalanceMode] != whiteBalanceMode) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setWhiteBalanceMode:whiteBalanceMode];
            [device unlockForConfiguration];
        } else {
//            id delegate = [self delegate];
//            if ([delegate respondsToSelector:@selector(acquiringDeviceLockFailedWithError:)]) {
//                [delegate acquiringDeviceLockFailedWithError:error];
//            }
        }
    }
}

- (void) focusAtPoint:(CGPoint)point
{
//    CGPoint newPoint =  CGPointMake(point.y, point.x);
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
//            NSLog(@"point x is %f==== y is %f",newPoint.x,newPoint.y);
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
//            id delegate = [self delegate];
//            if ([delegate respondsToSelector:@selector(acquiringDeviceLockFailedWithError:)]) {
//                [delegate acquiringDeviceLockFailedWithError:error];
//            }
        }        
    }
}

- (void) exposureAtPoint:(CGPoint)point
{
    AVCaptureDevice *device = [[self videoInput] device];
    if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setExposurePointOfInterest:point];
            [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            [device unlockForConfiguration];
        } else {
//            id delegate = [self delegate];
//            if ([delegate respondsToSelector:@selector(acquiringDeviceLockFailedWithError:)]) {
//                [delegate acquiringDeviceLockFailedWithError:error];
//            }
        }
    }    
}



+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections
{
	for ( AVCaptureConnection *connection in connections ) {
		for ( AVCaptureInputPort *port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:mediaType] ) {
				return [[connection retain] autorelease];
			}
		}
	}
	return nil;
}
-(void) dealloc
{
    if(self.captureQueue)
    {
        dispatch_release(self.captureQueue);
    }
    self.captureQueue = nil;
    [self setOutputDelegate:nil];
    [self setCaptureSession:nil];
    [self setVideoInput:nil];
    [self setAudioInput:nil];
    [self setVideoCaptureOutput:nil];
    [self setAudioCaptureOutput:nil];
    [self setStillImageOutput:nil];
//    [self setFocusMode:nil];
//    [self setFlashMode:nil];
//    [self setTorchMode:nil];
//    [self setExposureMode:nil];
//    [self setWhiteBalanceMode:nil];    
    [super dealloc];
}

@end

@implementation FloggerCaptureManage (Internal)

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *) frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *) audioDevice
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    if ([devices count] > 0) {
        return [devices objectAtIndex:0];
    }
    return nil;
}
@end

