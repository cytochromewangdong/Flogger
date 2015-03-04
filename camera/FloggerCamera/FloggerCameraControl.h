//
//  Temp.h
//  FloggerVideo
//
//  Created by wyf on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "MenuView.h"
#import "FloggerCaptureManage.h"
#import "OpenGLRenderCenter.h"
#import "FloggerUtility.h"
#import "FloggerGLView.h"
#import "FloggerVideoWriteManage.h"
#import "FloggerServerManage.h"
#import "FloggerGestureRecognizer.h"
#import "ISIrisView.h"
#import "FloggerImageName.h"
#import "FloggerCommon.h"
#import "FloggerQueue.h"
#import "DataCache.h"
#import "FloggerFilterAdapter.h"

#define MAXIMUMDURATION 15

#define USE_SYSTEM_THREAD YES

typedef enum
{
//    INITIALMODE = 1,
    PHOTOMODE = 1,
    PHOTOEDITMODE,
    STILLIMAGEMODE,
    VIDEOMODE,
    VIDEOEDITMODE,
    RECORDINGMODE,    
} STATUSMODE;

enum BUTTONTAG
{
    FLASHITEM = 0,
    TILTITEM,    
    SWAPITEM,
    FILTERITEM,
    CANCELITEM,      
    FLASHTAG,
    FLASHOFFTAG,
    FLASHAUTOTAG,
    TILTSHIFTTAG,
    TILTSHIFTHORIZONTAG,
    TILTSHIFTRADIAL,
    PHOTOTAG,
    IMPORTTAG,
    VIDEORECORD,
    VIDEOSHOOT,
    SLIDETAG,
    CANCELBTN,
    CONFIRMBTN,
    PLAYBTN,
    PAUSEBTN,
    ADJUSTITEM,
    RESETBTN,
    ADJUSTRESETBTN
};

typedef enum {
    TILTSTATUSOFF = 0,
    TILTSTATUSRADIAL,
    TILTSTATUSHORIZON
} TILTSTATUS;

//@protocol FloggerCameraDelegate <NSObject>
//
//@optional
//-(void) handleWithEditedPhoto: (UIImage*) image;
//@end

@class FloggerCameraControl;
@protocol FloggerCameraControlDelegate <NSObject>
-(void)floggerCameraControl:(FloggerCameraControl *)cameraControl didFinishPickingMediaWithInfo:(NSDictionary *)info;
-(void)floggerCameraControlDidCancelledPickingMedia:(FloggerCameraControl *)cameraControl;
@end

@interface FloggerCameraControl : UIViewController
<AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureAudioDataOutputSampleBufferDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate,FloggerPhotoDelegate,UIGestureRecognizerDelegate,UIVideoEditorControllerDelegate,FloggerServerDelegate,FloggerGLViewDelegate,ResourceProvider,UIActionSheetDelegate,UIAccelerometerDelegate>
{
    //    NSData *_imageData;
    UIImageOrientation _videoOrientation;
    BOOL _isConfirming;
    
    CGRect radiusRect;
    CGRect horizonRect;
    BOOL _isFilterHidden;
    int _swapStatus;

    int _adjustMode;
    BOOL _isAdjust;
    BOOL _isTilt;
    BOOL _isVideoRotate;
    //int _bright;
    CGSize _videoSize;
    
    CGFloat _circleRadius;
    CGFloat _scale;
    CGFloat _rotate;
    int _tiltStatus;
    dispatch_queue_t _writerMovieQueue;
#if defined(USE_SYSTEM_THREAD)
    dispatch_queue_t _standardOpenGLQueue;
#else 
    FloggerQueue *_openGLQueue;
#endif
    CADisplayLink *_displayLink;
    CFAbsoluteTime _startTime;
    UIBackgroundTaskIdentifier _backgroundRecordingID;
    
    STATUSMODE _statusMode;
    NSString *_filterXml;
    UIImage *_originalImage;
    ISIrisView *_isIrisView;
    
    FloggerCaptureManage *_captureManage;
    FloggerVideoWriteManage *_writeManage;
    FloggerServerManage *_serverManage;
    OpenGLRenderCenter *_render;
    OpenGLRenderCenter *_backgroundRender;
    UIView *_controlView;
    FloggerGLView *_glRenderView;
    UIView *_toolBarView;
    UIButton *_flashItem;
    UIButton *_adjustItem;
    UIButton *_tiltItem;
    UIButton *_swapItem;
    UIButton *_cancelItem;
    UIButton *_filterItem;
    UIView *_flashMenu;
    UIView *_tiltMenu;
    UIButton *_cameraShootBtn;
    UIImageView *_cameraBtnIcon;
    UIButton *_slideBtn;
    UIButton *_importBtn;
    UIScrollView *_scrollView;
    UIButton *_recordingDuration;
    UILabel *_recordingDurationLabel;
    UIButton *_videoRecordingBtn;
    UIButton *_videoShootBtn;    
    NSMutableDictionary *_filterDic;    
    UIButton *_photoSlider;
    UIButton *_videoSlider;
    UIImageView *_cameraConfirm;
    UIButton *_cancelBtn;
    UIButton *_confirmBtn;
    UIButton *_playBtn;
    //    UIButton *_pauseBtn;
    NSURL *_videoURL;
    UISlider *_timeSlider;
    //dispatch_queue_t _mediaQueue;
    UIImageView *_adjustTypeView;
    UILabel *_adjustType;
    
    UIImageView *_slideTimeView;
    UIView *_bottmonView;
    CALayer *_adjustLayer;
    NSArray *_viewArray;
    
    float _renderBufferRatio;
    
    dispatch_queue_t _slideVideoQueue;
    UIImageOrientation _pictureOrientation;
    int _normalizeOrientation;
    FilterProperty *_currentFilter;
    FilterProperty *_normalFilter;
    int _filterHightIndex , _borderHightIndex;
    BOOL _isAccessLock;
}

@property(nonatomic, assign) id/*<FloggerCameraControlDelegate>*/ delegate;

@property (retain)  UIImage* originalImage;
@property (nonatomic) STATUSMODE statusMode;

@property (nonatomic, retain) NSString *filterXml;

@property (nonatomic,retain) ISIrisView *isIrisView;
@property (retain, nonatomic) FloggerCaptureManage *captureManage;
@property (retain, nonatomic) FloggerVideoWriteManage *writeManage;
@property (retain, nonatomic) FloggerServerManage *serverManage;
//opengl
@property (retain, nonatomic) OpenGLRenderCenter *render;
@property (retain, nonatomic) OpenGLRenderCenter *backgroundRender;

@property (retain, nonatomic) UIView *controlView;
@property (retain, nonatomic) FloggerGLView *glRenderView;
@property (retain, nonatomic) UIView *bottmonView;
//
@property (retain, nonatomic) UIView *toolBarView;
@property (retain, nonatomic) UIButton *flashItem;
@property (retain, nonatomic) UIButton *adjustItem;
@property (retain, nonatomic) UIButton *tiltItem;
@property (retain, nonatomic) UIButton *swapItem;
@property (retain, nonatomic) UIButton *cancelItem;

@property (retain, nonatomic) UIButton *filterItem;

@property (retain, nonatomic) UIView *flashMenu;
@property (retain, nonatomic) UIView *tiltMenu;

@property (retain, nonatomic) UIButton *cameraShootBtn;
@property (retain, nonatomic) UIImageView *cameraBtnIcon;
@property (retain, nonatomic) UIButton *slideBtn;
@property (retain, nonatomic) UIButton *importBtn;

@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UIScrollView *borderScrollView;
@property (retain, nonatomic) UIButton *recordingDuration;
@property (retain, nonatomic) UILabel *recordingDurationLabel;

//video
@property (retain, nonatomic) UIButton *videoRecordingBtn;
@property (retain, nonatomic) UIButton *videoShootBtn;

@property (retain, nonatomic) NSMutableDictionary *filterDic;

@property (retain, nonatomic) UIButton *photoSlider;
@property (retain, nonatomic) UIButton *videoSlider;

//confirm view
@property (retain, nonatomic) UIImageView *cameraConfirm;
@property (retain, nonatomic) UIButton *cancelBtn;
@property (retain, nonatomic) UIButton *confirmBtn;
@property (retain, nonatomic) UIButton *playBtn;
//@property (retain, nonatomic) UIButton *pauseBtn;

@property (retain, nonatomic) NSURL *videoURL;

@property (retain, nonatomic) CALayer *adjustLayer;

@property (retain, nonatomic) UIImageView *adjustTypeView;
@property (retain, nonatomic) UILabel *adjustType;

@property (retain, nonatomic) UISlider *timeSlider;

@property (retain, nonatomic) UIImageView *slideTimeView;

//@property (retain, nonatomic) FloggerQueue *
#if defined(USE_SYSTEM_THREAD)
// placeholder
#else
@property (retain, readonly) FloggerQueue *openGLQueue;
#endif
@property (retain, nonatomic) UIImageView *testView;
//test
@property (retain, nonatomic) UIView *radiusView;
@property (retain,nonatomic) UIView *horizonView;
@property (retain, nonatomic) NSMutableArray *rotateIconArray;

@property (retain, nonatomic) AVAssetReader *videoReader;
@property (retain, nonatomic) UIImageView *focusImage;

@property (retain, nonatomic) UIView *filterView;
@property (retain, nonatomic) UILabel *adjustmentIndicator;
@property (retain, nonatomic) UILabel *adjustmentNumber;

@property (retain, nonatomic) UIView *middleView;
@property (retain, nonatomic) UIImageView *adjustmentIndicatorView;
@property (retain, nonatomic) UIImage *videoThumbImage;
@property (retain, nonatomic) UIButton *resetBtn;
@property (retain, nonatomic) NSArray* viewArray;
@property (retain, nonatomic) FilterProperty* currentFilter;
@property (retain, nonatomic) FilterProperty* normalFilter;
@property (retain, nonatomic) FilterProperty* currentBorder;
@property (retain, nonatomic) NSArray* filters;
@property (retain, nonatomic) NSArray* borders;
@property (retain, nonatomic) NSString* syntax;
@property (retain, nonatomic) UIButton *filterBtn,*borderBtn;
@property (nonatomic)UIInterfaceOrientation deviceOrientation;
@property (nonatomic, retain) UIAccelerometer *deviceAccelerometer;
//@property (retain, nonatomic) UILabel *downUpLabel;
//@property (retain, nonatomic) UIImageView *downArrowImageV,*upArrowImageV;
//@property (retain, nonatomic) UIButton *filterHightlightBtn, *borderHightligthBtn;

//-(void) flashClick;
-(void) filterClick;
//-(void) tiltClick;
-(void) swapClick;
-(void) cancelClick;

-(void) photoClick;
-(void) importClick;

-(void) photoSlideVideo;

//-(void) handleWithVideo;
-(void) startRecord;
-(void) stopRecord;

-(void) startBtnChange:(id) sender;

-(void) btnClick : (id)sender;
-(void) toolBarItemClick : (int) itemTag;
-(void) dropDownClick : (id) sender;
-(void) setHidenItemsDefault:(NSInteger) itemTag;

-(UIButton *) setButtonProperty:(UIImage *) btnImage withHighlightImage: (UIImage *) btnHighlight withPoint: (CGPoint) point withButtonTag: (int) btnTag;
-(void) buildInvisibleViewAtStart;

-(void) tapOnGLView: (UITapGestureRecognizer *)recognizer;


-(void) addOpenGlRender;
-(void) addFocusLayOnGLView;
-(void) buildToolBarView;
-(void) buildBottomView;
-(void) myCaptureAndWriteManage;
-(void) hidenConfirmView;

- (void)updateRecordingValues;

-(void) switchStatusMode : (STATUSMODE) statusMode;
-(void) handleWithVideoFromAlbum : (NSURL *) videoPathURL;
-(void) updateAdjustType;
-(void) confirm;

-(UIButton *) setButtonProperty:(UIImage *) btnImage withDisableImage: (UIImage *) btnDisable withPoint: (CGPoint) point withButtonTag: (int) btnTag;
-(void) drawAdjustArea : (CGContextRef) context withFrame : (CGRect) rect withOrientation : (int) orientation
;
-(void) addAndManageGesture;
-(void) drawTiltRadius : (CGPoint) currentPoint;
-(void) drawTiltHorizon : (CGPoint) currentTouchPoint;

-(void) timeSliderValueChanged: (id) sender;
-(void) extractImageFromVideo : (NSURL *) mediaURL withTime : (CMTime) thumbTime Sync:(BOOL) sync;
//-(void) extractImageFromVideoTouch : (NSURL *) mediaURL withTime : (CMTime) thumbTime;
-(void) playVideoForWriter;
-(void) pauseVideoForWriter;

-(void) displayAdjustType;
-(void) displaySliderTime : (CMTime) time;

-(void) performSimpleRecording : (dispatch_block_t) block  withSync : (BOOL) sync;

#if defined(USE_SYSTEM_THREAD)
// placeholder
-(void) performSimpleOpenGL : (dispatch_block_t) block;
-(void) performSimpleOpenGL : (dispatch_block_t) block  withSync : (BOOL) sync;
#else
-(void) performSimpleOpenGL : (dispatch_block_t) block;
#endif
-(void) renderImage:(BOOL) preview;
-(void) renderImage:(BOOL) preview Orientation:(UIImageOrientation) orientation;
-(void) tiltShiftGesture : (FloggerTiltShiftRecognizer *) recognizer;
-(void) receivedRotate;

-(void) videoImageConvertImageOrientation : (CGAffineTransform ) videoTrackTrans;

-(void) doubleTapView;
-(void) applicationWillResign;
-(void) transTiltAndAdjust : (BOOL) tiltOrAdjust;

-(void) hidenAdjustType;
-(void)viewDealloc;

-(void) resetAction;
-(void) writerFileFinish;
-(NSString*) collectCurrentFilter; 

-(void) borderToggleAction : (id) sender;
-(void) InitializeDefaultBorderButtons;
-(void) showHelpView : (NSString *) helpImageURL;
@end
