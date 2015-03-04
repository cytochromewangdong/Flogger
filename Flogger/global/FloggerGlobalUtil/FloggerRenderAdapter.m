//
//  FloggerRenderAdapter.m
//  Flogger
//
//  Created by wyf on 12-4-5.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerRenderAdapter.h"
#import "FloggerCommon.h"
#import "FloggerServerManage.h"


static FloggerRenderAdapter *renderAdapter;
@implementation FloggerRenderAdapter
@synthesize writeManage;
@synthesize currentBorder,currentFilter;
@synthesize videoReader,audioReader,cancelling;

-(void) dealloc
{
    self.writeManage = nil;
    self.currentBorder = nil;
    self.currentFilter = nil;
    self.videoReader = nil;
    self.audioReader = nil;
    [super dealloc];
}

+(FloggerRenderAdapter *) getRenderAdapter
{
    if(!renderAdapter)
    {
        renderAdapter =  [[FloggerRenderAdapter alloc]init];
    }
    return renderAdapter;
}

-(OpenGLRenderCenter *) createBackgroundRender : (NSString *) normalXml
{
    OpenGLRenderCenter *backgroundRender = [[[OpenGLRenderCenter alloc] init] autorelease];
//    NSString *commonPath = [[NSBundle mainBundle] pathForResource:@"normal" ofType:@"xml"]; 
//    NSString *normalXml= [NSString stringWithContentsOfFile:commonPath encoding:NSUTF8StringEncoding error:NULL];
    [backgroundRender setupProgram:PRIVIEW_OUTPUT_WIDTH 
                            Height:PRIVIEW_OUTPUT_HEIGHT Data:normalXml StringType:XML preview:NO];
    
    [backgroundRender setNeedOnlyRawData:YES];
    //set mode
    [backgroundRender setGlMode:OFFSCREEN_MODE];
    return backgroundRender;
}

-(void) cancelWriteFile
{
//    []
    if (!self.writeManage) {
        return;
    }
    
    if (self.writeManage.assetWriter.status == AVAssetWriterStatusCompleted) {
        return;
    }
    @synchronized(self)
    {
        cancelling = YES; 
    }
    [self.videoReader cancelReading];
    [self.writeManage.assetWriter finishWriting];
    
    self.videoReader = nil;
    self.writeManage.videoAssetWriterInput = nil;
    self.writeManage.audioAssetWriterInput = nil;
    self.writeManage.assetWriter = nil;
    self.writeManage.inputBufferAdaptor = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"test" 
                                                       message:@"Cancel"
                                                      delegate:self 
                                             cancelButtonTitle:@"ok" 
                                             otherButtonTitles:nil];
        [alert show];
        [alert release];
    });
}

-(void) writerFileFinish
{
//    [self setBackgroundRender:nil];
//    NSLog(@"video finish=========");
    [[[self writeManage] assetWriter] finishWriting];
    UISaveVideoAtPathToSavedPhotosAlbum([[[[self writeManage] assetWriter] outputURL] path], nil, nil, nil);
//    
//    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"test" 
                                                       message:@"Finish"
                                                      delegate:self 
                                             cancelButtonTitle:@"ok" 
                                             otherButtonTitles:nil];
        [alert show];
        [alert release];
    });
    
//    [NSNotification CE]
    NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    [dataDic setObject:self.writeManage.assetWriter.outputURL forKey:kFinishVideoURL];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFinishServer object:dataDic];
    
}

-(void) videoImageConvertImageOrientation : (CGAffineTransform ) videoTrackTrans
{
    int tranA = videoTrackTrans.a;
    int tranB = videoTrackTrans.b;
    //    int tranC = videoTrackTrans.c;
    //    int tranD = videoTrackTrans.d;
    
    if (tranA == 0 && tranB == 1) 
    {
        _videoOrientation = UIImageOrientationRight;
    } else if(tranA == 1 && tranB == 0)
    {
        _videoOrientation = UIImageOrientationUp;
    } else if (tranA == 0 && tranB == -1)
    {
        _videoOrientation = UIImageOrientationLeft;
    } else if (tranA == -1 && tranB == 0)
    {
        _videoOrientation = UIImageOrientationDown;
    }
    //    _videoOrientation = 0;
//    NSLog(@"_videoOrientation is %d",_videoOrientation);
    
}

- (UIImage*) createTextureImageFromName:(NSString*)name
{
    NSString *imgPath = [FloggerServerManage getImageSavePath];
    UIImage *image =  [[UIImage imageWithContentsOfFile:[imgPath stringByAppendingPathComponent:name]]retain];
    if(!image) {
        image = [[UIImage imageNamed:name]retain];
    }
    return image;
}

-(void) transformVideo : (NSMutableDictionary *) info
{
    cancelling = NO;
    //    fefe
    OpenGLRenderCenter *backgroundRender = [[[OpenGLRenderCenter alloc] init] autorelease];
    NSMutableDictionary *dataDictionary = info;//[[NSMutableDictionary alloc] initWithCapacity:10];
    NSString *cameraInfoSyntax = [dataDictionary objectForKey:fCameraInfoSyntax];
    NSDictionary *syntaxParam = [cameraInfoSyntax JSONValue];
    NSURL *originalVideoURL = [dataDictionary objectForKey:fVideoURL];
    if(syntaxParam)
    {
        //filter set
        NSString *filterName = [syntaxParam objectForKey:kFilterName];        
        NSArray *fList =[[[FloggerFilterAdapter sharedInstance]createFilterList]autorelease];
        for (FilterProperty *cFilter in fList) {
            if([cFilter.name isEqualToString:filterName])
            {
                self.currentFilter = cFilter; 
                break;
            }
        } 
        //border set
        NSString *borderName = [syntaxParam objectForKey:kBorderName];
        NSArray *bList = [[[FloggerFilterAdapter sharedInstance] createBorderList] autorelease];
        for (FilterProperty *cBorder in bList) {
            if ([cBorder.title isEqualToString:borderName]) {
                self.currentBorder = cBorder;
                break;
            }
        }
    }
    
    if (!self.currentFilter) {
        FilterProperty *normalFilter = [[[FilterProperty alloc] init] autorelease];
        self.currentFilter = normalFilter;
    }    
    [backgroundRender setupProgram:RECORDING_OUTPUT_WIDTH 
                            Height:RECORDING_OUTPUT_HEIGHT Data:self.currentFilter.filter StringType:XML preview:NO];
    
    //border set
    if (self.currentBorder) {
        UIImage* borderImage = [self createTextureImageFromName:self.currentBorder.borderImageName]; 
        [backgroundRender registerBorderImage:borderImage];
        if(!borderImage)
        {
            self.currentBorder = nil;
        }
    }
        
    self.writeManage = [[[FloggerVideoWriteManage alloc] init] autorelease];
    self.writeManage.isBackgroundRender = YES;
    
    [[self writeManage] setupAssetWriter];
    //input asset
    AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:originalVideoURL options:nil] autorelease]; 
    
    //Get video track from asset
    NSArray *videoTracks = [inputAsset tracksWithMediaType:AVMediaTypeVideo];
    

    //    if ([videoTracks count] > 0) {
    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    //uiimage orientation
    [self videoImageConvertImageOrientation : videoTrack.preferredTransform];
    
    AVAssetReader *reader = [[[AVAssetReader alloc] initWithAsset:inputAsset error:nil] autorelease];
    //set the desired frame format
    NSMutableDictionary *videoOutputSettings = [NSMutableDictionary dictionary];
    [videoOutputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
    
    //contruct an actual output track 
    AVAssetReaderTrackOutput *readerTrackOutput = [[[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:videoOutputSettings] autorelease];   
    //add readertrack output in  asset reader
    [reader addOutput:readerTrackOutput];
    //kick off the asset 
    [reader startReading];
    
    //    }   
    //audio
    NSArray *audioTracks = [inputAsset tracksWithMediaType:AVMediaTypeAudio];
    AVAssetReaderTrackOutput *audioReaderTrackOutput = nil;
    
    if ([audioTracks count] > 0) 
    {
        AVAssetTrack *audioTrack = [audioTracks objectAtIndex:0];
        AVAssetReader *audioReaderTemp = [[[AVAssetReader alloc] initWithAsset:inputAsset error:nil] autorelease];
        NSMutableDictionary* audioReadSettings = [NSMutableDictionary dictionary];
        [audioReadSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM]
                             forKey:AVFormatIDKey];
        audioReaderTrackOutput = [[[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:audioReadSettings] autorelease];
        [audioReaderTemp addOutput:audioReaderTrackOutput];
        [audioReaderTemp startReading];
        [self setAudioReader:audioReaderTemp];
    }
    
    
    [self setVideoReader:reader];
    
    [[[self writeManage] assetWriter] startWriting];
    [[[self writeManage] assetWriter] startSessionAtSourceTime:kCMTimeZero];
    //
    [backgroundRender setNeedOnlyRawData:YES];
    [backgroundRender setGlMode:OFFSCREEN_MODE];
//    [backgroundRender setGlMode:VIEW_MODE];
    
    //
    //write audio
    //write video
    dispatch_queue_t readAndWriteQueue = dispatch_queue_create("backgroundReadAndWriteQueue", NULL);

    __block int finishCount = 0;
    backgroundRender.usingIOS5 = NO;
    backgroundRender.quality = 1;
    
    if ([audioTracks count] > 0) 
    {
        [[[self writeManage] audioAssetWriterInput] requestMediaDataWhenReadyOnQueue:readAndWriteQueue usingBlock:^{
            while ([[[self writeManage] audioAssetWriterInput] isReadyForMoreMediaData]) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                CMSampleBufferRef nextImageBuffer ;//= [audioReaderTrackOutput copyNextSampleBuffer];
                @synchronized(self)
                {
                    if(!cancelling)
                    {
                        nextImageBuffer = [audioReaderTrackOutput copyNextSampleBuffer];
                    } else {
                        [pool drain];
                        break;
                    }
                }
                
                if (nextImageBuffer) {
                    [[[self writeManage] audioAssetWriterInput] appendSampleBuffer:nextImageBuffer];
                    CFRelease(nextImageBuffer);
                } else {
//                    NSLog(@"audio finish");
                    [[[self writeManage] audioAssetWriterInput] markAsFinished];
//                    [audioReader cancelReading];
                    [audioReader cancelReading];
                    finishCount++;
                    if (finishCount == 2) {
                        [self writerFileFinish];
                    }
                    [pool drain];
                    break;
                }
                [pool drain];
                
            }
        }];
    }
    //write video
    //    self.backgroundRender.usingIOS5 = NO;
    [[[self writeManage] videoAssetWriterInput] requestMediaDataWhenReadyOnQueue:readAndWriteQueue usingBlock:^{
        [backgroundRender.openGL switchContext];
        while ([[[self writeManage] videoAssetWriterInput] isReadyForMoreMediaData]) {
//            NSLog(@"=======video edit======");
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            CMSampleBufferRef nextImageBuffer;
            @synchronized(self)
            {
                if(!cancelling)
                {
                    nextImageBuffer = [readerTrackOutput copyNextSampleBuffer];
                } else {
                    [pool drain];
                    break;
                }
            }
            if (nextImageBuffer) {
                CVImageBufferRef cvImageBuffer = CMSampleBufferGetImageBuffer(nextImageBuffer);
                CMTime presentTime = CMSampleBufferGetPresentationTimeStamp(nextImageBuffer);
                CVPixelBufferLockBaseAddress(cvImageBuffer,0);
                //                static int ii=0;
                //                                NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
                //if(!ii) 
                {
                    [backgroundRender setupTextureWithCameraFrame:cvImageBuffer];
                    [backgroundRender render:_videoOrientation willKeepTexture:NO];
                    //                        [backgroundRender render:<#(UIImageOrientation)#> willKeepTexture:<#(BOOL)#>]
                    //  ii++;
                }
                //                                    [pool2 drain];
                while ( ![[self writeManage] videoAssetWriterInput].readyForMoreMediaData)
                {
                    [NSThread sleepForTimeInterval:0.001];
                }
                if( [[self writeManage] assetWriter].status != AVAssetWriterStatusWriting)
                {
                    [[[self writeManage] assetWriter] startWriting];
                    [[[self writeManage] assetWriter] startSessionAtSourceTime:kCMTimeZero];
                }
                if([backgroundRender.openGL supportFastOpenGL]) {
                    if (![[[self writeManage] inputBufferAdaptor] appendPixelBuffer:backgroundRender.resultData withPresentationTime:presentTime])
                    {
//                        NSLog(@"Unable to write to video input");
                    } 
                } else {
                    CVPixelBufferRef newBuffer = NULL;
                    CVPixelBufferCreateWithBytes(NULL, backgroundRender.openGL.width, backgroundRender.openGL.height, kCVPixelFormatType_32ARGB, backgroundRender.resultData, 4*backgroundRender.openGL.width, NULL, 0, NULL, &newBuffer);            
                    
                    if (![[[self writeManage] inputBufferAdaptor] appendPixelBuffer:newBuffer withPresentationTime:presentTime])
                    {
//                        NSLog(@"Unable to write to video input");
                    }
                    CFRelease(newBuffer);  
                }
                CVPixelBufferUnlockBaseAddress(cvImageBuffer, 0);
                CFRelease(nextImageBuffer);
                
            } else {
                [[[self writeManage] videoAssetWriterInput] markAsFinished];
                //                NSLog(@"====videocount is %d",_count);
                [reader cancelReading];
                finishCount++;
                if (finishCount == 2) {
                    [self writerFileFinish];
                }
                [pool drain];
                break;
            }
            [pool drain];
        }
        [backgroundRender.openGL clearContext];
    }];
    
    dispatch_release(readAndWriteQueue); 
}

- (void)main
{
//    [self transformVideo];
}

@end
