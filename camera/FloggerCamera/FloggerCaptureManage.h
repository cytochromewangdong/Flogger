//
//  FloggerCaptureManage.h
//  FloggerVideo
//
//  Created by wyf on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol FloggerPhotoDelegate <NSObject>
@optional
-(void) dealWithImageData: (CVImageBufferRef) pixBuffer;
-(void) dealWithImageDataImage: (UIImage *) image;
@end

@interface FloggerCaptureManage : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate> 
{
@private
    NSObject <AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,FloggerPhotoDelegate> *_outputDelegate;
    
   AVCaptureSession *_captureSession;
    //input
    AVCaptureDeviceInput *_videoInput;
    AVCaptureDeviceInput *_audioInput;
    //output
    AVCaptureVideoDataOutput *_videoCaptureOutput;
    AVCaptureAudioDataOutput *_audioCaptureOutput;
    
    //take a picture
    AVCaptureStillImageOutput *_stillImageOutput;
}
@property (assign, atomic)  NSObject <AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,FloggerPhotoDelegate> *outputDelegate;

@property (retain, nonatomic) AVCaptureSession *captureSession;
//input
@property (retain, nonatomic) AVCaptureDeviceInput *videoInput;
@property (retain, nonatomic) AVCaptureDeviceInput *audioInput;
//output
@property (retain, nonatomic) AVCaptureVideoDataOutput *videoCaptureOutput;
@property (retain, nonatomic) AVCaptureAudioDataOutput *audioCaptureOutput;

//take a picture
@property (retain, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
//@property (retain, nonatomic) AVCaptureConnection *photoConnection;
//flashmode
@property (nonatomic,assign) AVCaptureFlashMode flashMode;
//focusemode
@property (nonatomic,assign) AVCaptureFocusMode focusMode;
//torch
@property (nonatomic,assign) AVCaptureTorchMode torchMode;
//exposure
@property (nonatomic,assign) AVCaptureExposureMode exposureMode;
//whiteBalanceMode
@property (nonatomic,assign) AVCaptureWhiteBalanceMode whiteBalanceMode;

@property (nonatomic,assign) dispatch_queue_t captureQueue;


+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;
-(void) performWaitLoop;
-(void) setupCaptureSession: (NSString *) videoOrPhoto;
-(void) startCapture;
-(void) captureStillImageReturnData;
-(void) swapScreen;
//add system
- (BOOL) hasFlash;
- (BOOL) hasTorch;
- (BOOL) hasFocus;
- (BOOL) hasExposure;
- (BOOL) hasWhiteBalance;
- (void) focusAtPoint:(CGPoint)point;
- (void) exposureAtPoint:(CGPoint)point;
 
@end

@interface FloggerCaptureManage (Internal)

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition)position;
- (AVCaptureDevice *) frontFacingCamera;
- (AVCaptureDevice *) backFacingCamera;
- (AVCaptureDevice *) audioDevice;

@end
