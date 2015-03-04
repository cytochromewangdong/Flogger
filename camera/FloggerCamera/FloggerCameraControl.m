//
//  Temp.m
//  FloggerVideo
//
//  Created by wyf on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#define FLOGGERDEBUG

#import "FloggerCameraControl.h"
//#import "MenuView.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "GTMBase64.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
//#import "ComposeCommentViewController.h"
#import "CommentPostViewController.h"
#import "MBProgressHUD.h"
#import "FloggerRenderAdapter.h"
#import "FloggerInstructionView.h"

#define kTiltStatus @"tiltstatus"
#define kScale @"scale"
#define kRotate @"rotate"
#define kFilterStrenth @"filterStrenth"
#define kSaturation @"saturation"
#define kBright @"bright"
#define kContrast @"contrast"

static int photoLayout[]={0,1,5,6,-1,};
static int videoLayout[]={0,1,7,5,-1,};
static int recordingLayout[]={1,2,8,5,-1,};
static int photoEditLayout[]={0,1,5,9,-1,};
static int stillImageLayout[]={0,1,9,5,-1,};
static int videoEditLayout[]={1,5,9,11,12,-1,};//15,
static BOOL iscanceled;
static float kTiltRadiusMax = 1.0;
static float kTiltRadiusMin = 0.05;
static NSString * ADJUSTTYPE[] = {@"Contrast",@"Brightness",@"Saturation",@"Intensity"};


//==============used to pass parameters
@interface  FloggerVideoBuffer: NSObject{
}
@property (assign) CMTime presentTime;
@property (assign) CVImageBufferRef cvImageBuffer;
@end
@implementation FloggerVideoBuffer

@synthesize presentTime;
@synthesize cvImageBuffer;
-(void)dealloc
{
    
    if (self.cvImageBuffer) {
        CVPixelBufferRelease(self.cvImageBuffer);
        self.cvImageBuffer = NULL;
    }
    [super dealloc];
}
@end
//==============end
@interface FloggerCameraControl()
- (void) internalInit;
-(UIImageOrientation) reverseToOrientation:(int) normal Mirrored:(BOOL)mirrored;
-(int) normalizeOrientation:(UIImageOrientation)orientation  Mirrored:(BOOL)mirrored;
@end
@implementation FloggerCameraControl
@synthesize delegate;
@synthesize currentFilter=_currentFilter;
@synthesize normalFilter =_normalFilter;
@synthesize statusMode = _statusMode;
//


// filter menus 
@synthesize scrollView = _scrollView;

// top menus
@synthesize flashMenu = _flashMenu,tiltMenu = _tiltMenu;
@synthesize toolBarView = _toolBarView;
@synthesize flashItem = _flashItem,tiltItem = _tiltItem, filterItem = _filterItem;
@synthesize swapItem = _swapItem,adjustItem = _adjustItem, cancelItem = _cancelItem;

// bottom menus
@synthesize cameraShootBtn = _cameraShootBtn;

// video manager
@synthesize captureManage = _captureManage,writeManage = _writeManage;

// communication manager
@synthesize serverManage = _serverManage;

// used for GLRender operations,etc. tiltshift, C/B/S
@synthesize controlView = _controlView;
@synthesize render = _render;

// TODO should be saved as file
@synthesize filterDic = _filterDic;
// video import
@synthesize importBtn = _importBtn;

// photo and video mode switch
@synthesize photoSlider = _photoSlider,videoSlider = _videoSlider,cameraBtnIcon = _cameraBtnIcon;

@synthesize videoRecordingBtn = _videoRecordingBtn,videoShootBtn = _videoShootBtn,slideBtn = _slideBtn;

//Camera confirm view
@synthesize cameraConfirm = _cameraConfirm, cancelBtn = _cancelBtn;

//video confirm
@synthesize confirmBtn = _confirmBtn , playBtn = _playBtn;

//bottom control
@synthesize bottmonView = _bottmonView;
@synthesize recordingDuration = _recordingDuration;
@synthesize recordingDurationLabel= _recordingDurationLabel;

// the image saved in the memory used to be filtered
@synthesize originalImage = _originalImage;
// todo
@synthesize filterXml = _filterXml;

@synthesize videoURL = _videoURL;

// adjust controls
@synthesize adjustLayer = _adjustLayer;
@synthesize adjustType = _adjustType,adjustTypeView = _adjustTypeView;

//animation
@synthesize isIrisView = _isIrisView;

//to show GL image
@synthesize glRenderView = _glRenderView;

// controls for video imported 
@synthesize timeSlider = _timeSlider;
@synthesize slideTimeView = _slideTimeView;

#if defined(USE_SYSTEM_THREAD)
// placeholder
#else
// customized queque for openGL
@synthesize openGLQueue =_openGLQueue;
#endif

// simulated view to control tiltshift
@synthesize radiusView , horizonView;

// array contains the controls to rotate for orientation
@synthesize rotateIconArray;
@synthesize viewArray=_viewArray;

//video reader for video imported
@synthesize videoReader;
// show on the center of the preview screen , etc. expose/focus
@synthesize focusImage;


@synthesize middleView, filterView;

@synthesize adjustmentIndicator,adjustmentNumber;
@synthesize adjustmentIndicatorView;
@synthesize videoThumbImage;
@synthesize resetBtn;
@synthesize backgroundRender = _backgroundRender;

@synthesize filters,borders;
@synthesize currentBorder;
@synthesize testView;
@synthesize borderScrollView;

@synthesize syntax;
@synthesize filterBtn,borderBtn;
@synthesize deviceOrientation,deviceAccelerometer;
//@synthesize filterHightlightBtn, borderHightligthBtn;
//@synthesize downUpLabel,downArrowImageV,upArrowImageV;

- (FilterProperty*) normalFilter
{
    if(!_normalFilter)
    {
        _normalFilter = [[FilterProperty alloc]init]; 
    }
    return _normalFilter;
}
//static void *p1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self internalInit];        
    }
    return self;
}
- (id)init {
	self = [self initWithNibName:nil bundle:nil];
    if (self) {
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) buildToolBarView
{
    // tool image
    UIImage *cancelButton = [FloggerUtility thumbnailImage:FI_CANCEL_BUTTON];
    UIImage *cancelButtonFaded = [FloggerUtility thumbnailImage:FI_CANCEL_BUTTON_FADED];
    
    UIImage *faceCamera = [FloggerUtility thumbnailImage:FI_FACE_CAMERA];
    UIImage *faceCameraFaded = [FloggerUtility thumbnailImage:FI_FACE_CAMERA_FADED];
    
    UIImage *adjustButton = [FloggerUtility thumbnailImage:FI_GRID];
    UIImage *adjustButtonFaded = [FloggerUtility thumbnailImage:FI_GRID_HIGHLIGHTED];

    UIImage *flashButton = [FloggerUtility thumbnailImage:FI_FLASH_BUTTON_AUTO];
    UIImage *flashButtonFaded = [FloggerUtility thumbnailImage:FI_FLASH_BUTTON_AUTO_FADED];
    UIImage *tiltShift = [FloggerUtility thumbnailImage:FI_TILT_SHIFT];

    
    NSArray *toolBarViewArray = [[[NSArray alloc] initWithObjects:flashButton,flashButtonFaded,tiltShift,faceCamera,faceCameraFaded,adjustButton,adjustButtonFaded,cancelButton,cancelButtonFaded,nil] autorelease];

    int itemHeight = 14;
        
    UIButton *flashItem = [self setButtonProperty:[toolBarViewArray objectAtIndex:0] withDisableImage:[toolBarViewArray objectAtIndex:1] withPoint:CGPointMake(0, itemHeight) withButtonTag:FLASHITEM];


    UIButton *tiltItem = [self setButtonProperty:[toolBarViewArray objectAtIndex:2] withDisableImage:nil withPoint:CGPointMake(57, itemHeight) withButtonTag:TILTITEM];
 
    UIButton *swapItem = [self setButtonProperty:[toolBarViewArray objectAtIndex:3] withHighlightImage:[toolBarViewArray objectAtIndex:4] withPoint:CGPointMake(130, itemHeight) withButtonTag:SWAPITEM];
    
    UIButton *filterItem = [self setButtonProperty:[toolBarViewArray objectAtIndex:5] withHighlightImage:[toolBarViewArray objectAtIndex:6] withPoint:CGPointMake(200, itemHeight) withButtonTag:ADJUSTITEM];
    
    UIButton *cancelItem = [self setButtonProperty:[toolBarViewArray objectAtIndex:7] withHighlightImage:[toolBarViewArray objectAtIndex:8] withPoint:CGPointMake(265, itemHeight) withButtonTag:CANCELITEM];
    
    UIView *toolBarView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    
    [toolBarView addSubview:flashItem];
    [toolBarView addSubview:tiltItem];
    [toolBarView addSubview:swapItem];
    [toolBarView addSubview:filterItem];
    [toolBarView addSubview:cancelItem];
    
    [self.view addSubview:toolBarView];
    //
    self.toolBarView = toolBarView;
    self.flashItem = flashItem;
    self.tiltItem = tiltItem;
    self.swapItem = swapItem;
    self.adjustItem = filterItem;
    self.cancelItem = cancelItem;
    
}

-(void) buildBottomView
{
    // add other view
    UIImage *cameraBar = [FloggerUtility thumbnailImage:FI_CAMERA_BAR];
    UIImage *cameraShootButton = [FloggerUtility thumbnailImage:FI_CAMERA_SHOOT_BUTTON];
//    UIImage *shootBackground = [FloggerUtility thumbnailImage:FI_SHOOT_BACKGROUND];
//    UIImage *cameraShootIcon = [FloggerUtility thumbnailImage:FI_CAMERA_SHOOT_ICON];
    UIImage *importButton = [FloggerUtility thumbnailImage:FI_IMPORT_BUTTON];
    UIImage *photoSliderIcon = [FloggerUtility thumbnailImage:FI_PHOTO_SLIDER_ICON];
    UIImage *sliderBackground = [FloggerUtility thumbnailImage:FI_SLIDER_BACKGROUND];
    UIImage *sliderKnob = [FloggerUtility thumbnailImage:FI_SLIDER_KNOB];
    UIImage *videoSliderIcon = [FloggerUtility thumbnailImage:FI_VIDEO_SLIDER_ICON];
    UIImage *importButtonPress = [FloggerUtility thumbnailImage:FI_IMPORT_BUTTON_PRESSED];
    UIImage *cameraShootButtonPress = [FloggerUtility thumbnailImage:FI_CAMERA_SHOOT_BUTTON_PRESSED];
    
    //cameraBar
    UIImageView *camera = [[[UIImageView alloc] initWithImage:cameraBar] autorelease];
    CGRect cameraRect = CGRectMake(0, 480-cameraBar.size.height, cameraBar.size.width, cameraBar.size.height);
    [camera setFrame:cameraRect];
//    int topParent = 480-cameraBar.size.height;
    //cameraShootView 391
//    CGRect shootBackgroundViewRect = CGRectMake((320-shootBackground.size.width)/2, 391 - topParent, shootBackground.size.width, shootBackground.size.height);
//    UIImageView *shootBackgroundView = [[[UIImageView alloc] initWithImage:shootBackground] autorelease];
//    [shootBackgroundView setFrame:shootBackgroundViewRect];
    //400
    CGPoint cameraShootBtnPoint = CGPointMake(111, 6);
    UIButton *cameraShootBtn = [self setButtonProperty:cameraShootButton withHighlightImage:cameraShootButtonPress withPoint:cameraShootBtnPoint withButtonTag:PHOTOTAG];
    [cameraShootBtn setShowsTouchWhenHighlighted: NO];
    
    //camera button 
//    UIImageView *cameraBtnIcon = [[[UIImageView alloc] initWithImage:cameraShootIcon] autorelease];
//    CGRect cameraBtnIconRect = CGRectMake((cameraShootButton.size.width-cameraShootIcon.size.width)/2, (cameraShootButton.size.height-cameraShootIcon.size.height) / 2 -2, cameraShootIcon.size.width, cameraShootIcon.size.height);
//    [cameraBtnIcon setUserInteractionEnabled:NO];
//    [cameraBtnIcon setFrame:cameraBtnIconRect];
//    [cameraShootBtn addSubview:cameraBtnIcon];


    //imputbutton
    CGPoint importBtnPoint = CGPointMake(3, 7);
    UIButton *importBtn = [self setButtonProperty:importButton withHighlightImage:importButtonPress withPoint:importBtnPoint withButtonTag:IMPORTTAG];
    [importBtn setShowsTouchWhenHighlighted:NO];
    
    //photoSliderIcon
    CGPoint photoSliderPoint = CGPointMake(254, 13);
    UIButton *photoSlider = [self setButtonProperty:photoSliderIcon withHighlightImage:nil withPoint:photoSliderPoint withButtonTag:0];
    
    //videoSliderIcon
    CGPoint videoSliderPoint = CGPointMake(289, 15);
    UIButton *videoSlider = [self setButtonProperty:videoSliderIcon withHighlightImage:nil withPoint:videoSliderPoint withButtonTag:0];

    //slider
    UIImageView *slide = [[[UIImageView alloc] initWithImage:sliderBackground] autorelease];
    CGRect slideRect = CGRectMake(250, 30, sliderBackground.size.width, sliderBackground.size.height);
    [slide setFrame:slideRect]; 
    
    CGPoint slideBtnPoint = CGPointMake(246, 28);
    UIButton *slideBtn = [self setButtonProperty:sliderKnob withHighlightImage:nil withPoint:slideBtnPoint withButtonTag:SLIDETAG];
    
    [camera setUserInteractionEnabled:YES];
    [[self view] addSubview:camera];
    [self setBottmonView:camera];
//    [camera addSubview:shootBackgroundView];
    [camera addSubview:cameraShootBtn]; 
    [camera addSubview:importBtn];
    [camera addSubview:photoSlider];
    [camera addSubview:videoSlider];
    [camera addSubview:slide];
    [camera addSubview:slideBtn];
    

    
    //set     
    [self setCameraShootBtn:cameraShootBtn];
//    [self setCameraBtnIcon:cameraBtnIcon];
    [self setPhotoSlider:photoSlider];
    [self setVideoSlider:videoSlider];
    [self setSlideBtn:slideBtn];
    [self setImportBtn:importBtn];
}

-(void) buildConfirmView
{    
    UIImage *cancelButton = [FloggerUtility thumbnailImage:FI_CANCEL_CONFIRM];
    UIImage *confirmPortrait = [FloggerUtility thumbnailImage:FI_CONFIRM_PORTRAIT];
//    UIImage *cameraBarConfirm = [FloggerUtility thumbnailImage:FI_CAMERA_BAR_CONFIRM];
    UIImage *cameraBarConfirm = [FloggerUtility thumbnailImage:FI_CAMERA_BAR];
    UIImage *play = [FloggerUtility thumbnailImage:FI_PLAYBUTTON];
    UIImage *adjustment = [FloggerUtility thumbnailImage:FI_ADJUSTMENT_INDICATOR];
    
    //cameraConfirm
    UIImageView *cameraConfirm = [[[UIImageView alloc] initWithImage:cameraBarConfirm] autorelease];
    CGRect cameraConfirmRect = CGRectMake(0, 480-cameraBarConfirm.size.height, cameraBarConfirm.size.width, cameraBarConfirm.size.height); 
    [cameraConfirm setFrame:cameraConfirmRect]; 
    [cameraConfirm setUserInteractionEnabled:YES];
        
    //cancelbtn
    CGPoint cancelBtnPoint = CGPointMake(3, 6);
    UIButton *cancelBtn = [self setButtonProperty:cancelButton withHighlightImage:nil withPoint:cancelBtnPoint withButtonTag:CANCELBTN];
    //confirmbtn
    CGPoint confirmBtnPoint = CGPointMake(238, 6);
    UIButton *confirmBtn = [self setButtonProperty:confirmPortrait withHighlightImage:nil withPoint:confirmBtnPoint withButtonTag:CONFIRMBTN];
    
    //adjustment
    UIImageView *adjustmentView = [[[UIImageView alloc] initWithImage:adjustment] autorelease];
    adjustmentView.frame = CGRectMake(86, -1,adjustment.size.width, adjustment.size.height);
    adjustmentView.userInteractionEnabled = YES;
    //add btn
    UIButton *adjustBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    adjustBtn.frame = CGRectMake(0, 5, adjustmentView.frame.size.width, adjustmentView.frame.size.height-15);
    adjustBtn.tag = ADJUSTRESETBTN;
//    adjustBtn.backgroundColor = [UIColor blueColor];
    [adjustBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [adjustBtn setHidden:NO];

    
    //adjustLable
    UILabel *adjustmentType = [[[UILabel alloc] init] autorelease];
    CGRect adjustTypeRect = CGRectMake(20, -1, adjustment.size.width, adjustment.size.height);
    [adjustmentType setFrame:adjustTypeRect];
    [adjustmentType setTextAlignment:UITextAlignmentLeft];
    [adjustmentType setUserInteractionEnabled:NO];
    [adjustmentType setBackgroundColor:[UIColor clearColor]];
    adjustmentType.textColor = [UIColor blackColor];
    adjustmentType.font = [UIFont boldSystemFontOfSize:14];
    adjustmentType.textColor = [UIColor blackColor];
    [self setAdjustmentIndicator:adjustmentType];
    
    //adjustNumber
    UILabel *adjustmentNum = [[[UILabel alloc] init] autorelease];
    CGRect adjustNumRect = CGRectMake(adjustment.size.width - 59, -1, 39, adjustment.size.height);
    [adjustmentNum setFrame:adjustNumRect];
    [adjustmentNum setTextAlignment:UITextAlignmentRight];
    [adjustmentNum setUserInteractionEnabled:NO];
    [adjustmentNum setBackgroundColor:[UIColor clearColor]];
    adjustmentNum.textColor = [UIColor blackColor];
    adjustmentNum.font = [UIFont boldSystemFontOfSize:14];
    [self setAdjustmentNumber:adjustmentNum];
    
    
    [adjustmentView addSubview:adjustmentType];
    [adjustmentView addSubview:adjustmentNum];
    
    [adjustmentView addSubview:adjustBtn];
    
    [[self view] addSubview:cameraConfirm];
    [cameraConfirm addSubview:confirmBtn];
    [cameraConfirm addSubview:cancelBtn];
    [cameraConfirm addSubview:adjustmentView];
    
    [self setAdjustmentIndicatorView:adjustmentView];
    
    CGPoint playPoint = CGPointMake((PRIVIEW_OUTPUT_WIDTH - play.size.width)/2, (PRIVIEW_OUTPUT_HEIGHT - play.size.height)/2);
     UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [playBtn setFrame:CGRectMake(playPoint.x, playPoint.y, play.size.width, play.size.height)];
     [playBtn setImage:play forState:UIControlStateNormal];
     [playBtn setTag:PLAYBTN];
     [playBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: playBtn];
    
    //hide
    
    [self setCameraConfirm:cameraConfirm];
    [self setConfirmBtn:confirmBtn];
    [self setCancelBtn:cancelBtn];
    [self setPlayBtn:playBtn];
}

-(void) showAdjustConfirmByMode
{
 
    if (self.statusMode == VIDEOEDITMODE) {
        [self.adjustmentIndicatorView setHidden:YES];
        
//        self.cancelBtn.frame = CGRectMake(103, self.cancelBtn.frame.origin.y, self.cancelBtn.frame.size.width, self.cancelBtn.frame.size.height);
//        self.confirmBtn.frame = CGRectMake(186, self.confirmBtn.frame.origin.y, self.confirmBtn.frame.size.width, self.confirmBtn.frame.size.height);
    } else {
        [self.adjustmentIndicatorView setHidden:NO];
//        self.cancelBtn.frame = CGRectMake(35, self.cancelBtn.frame.origin.y, self.cancelBtn.frame.size.width, self.cancelBtn.frame.size.height);
//        self.confirmBtn.frame = CGRectMake(258, self.confirmBtn.frame.origin.y, self.confirmBtn.frame.size.width, self.confirmBtn.frame.size.height);
//        [self.dd]
    }
}

-(void) borderToggleAction : (id) sender
{
    [self.filterBtn setHidden:!self.filterBtn.isHidden];
    [self.borderBtn setHidden:!self.borderBtn.isHidden];
    
    UILabel *label = (UILabel *)[self.filterItem viewWithTag:50];

    if (self.borderBtn.isHidden) {
        label.text = NSLocalizedString(@"Borders", @"Borders");
        self.borderScrollView.hidden = NO;
        self.scrollView.hidden = YES;
    } else {
        label.text = NSLocalizedString(@"Filters", @"Filters");
        self.borderScrollView.hidden = YES;
        self.scrollView.hidden = NO;
    }    
}

-(void) buildMiddleView
{
    //end add reset button
//    UIImage *cameraImageBar = [FloggerUtility ]
    //cameraba 54
    UIImage *filterBarImage = [FloggerUtility thumbnailImage:FI_FILTER_BAR];//104
//    UIImage *filterTabImage = [FloggerUtility thumbnailImage:FI_FILTER_BAR_TAB];//28
    
    
    self.middleView = [[[UIView alloc] init] autorelease];
//    int middleViewHeight = 294;
//    self.middleView.frame = CGRectMake(0, 293, 320, 104);
    self.middleView.frame = CGRectMake(0, 399, 320, 104);
//    self.middleView.backgroundColor = [UIColor blueColor];

    UIView *filter = [[[UIView alloc] init] autorelease];        
    filter.frame = CGRectMake(0, 0, filterBarImage.size.width, filterBarImage.size.height);
    //test
    UIImage *cameraIconBackgroundBar = [FloggerUtility thumbnailImage:FI_FILTER_BAR];
    UIImageView *backGroundView = [[[UIImageView alloc] initWithImage:cameraIconBackgroundBar] autorelease];
    backGroundView.frame = CGRectMake(0, 0, filterBarImage.size.width, filterBarImage.size.height);
    [filter addSubview:backGroundView];
        
    UIScrollView *scrollView = [[[UIScrollView alloc] init] autorelease];
    CGRect scrollViewRect = CGRectMake(70, 28, filterBarImage.size.width-70, filterBarImage.size.height);
    [scrollView setFrame:scrollViewRect];
    [self setScrollView:scrollView];
    
    UIScrollView *bordScrollView = [[[UIScrollView alloc] init] autorelease];
//    CGRect scrollViewRect = CGRectMake(70, 28, filterBarImage.size.width-70, filterBarImage.size.height);
    [bordScrollView setFrame:scrollViewRect];
    bordScrollView.hidden = YES;
    [self setBorderScrollView:bordScrollView];
    
//    UIImage* borderToggle = [[FloggerUIFactory uiFactory] createImage:FI_CAMERA_BORDER_TOGGLE];
//    UIImage* filtersToggle = [[FloggerUIFactory uiFactory] createImage:FI_CAMERA_FILTERS_TOGGLE];
    
    backGroundView.userInteractionEnabled = YES;
    
    
    
//    UIButton *toggle = [[FloggerUIFactory uiFactory] createButton:borderToggle];
//    
//    toggle.frame = CGRectMake(10, 56, borderToggle.size.width, borderToggle.size.height);
//    [toggle setBackgroundImage:filtersToggle forState:UIControlStateSelected];
//    [toggle addTarget:self action:@selector(borderToggleAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *filterButton = [[FloggerUIFactory uiFactory] createButton:nil];
    filterButton.frame = CGRectMake(3,37, 50, 72);   
    filterButton.hidden = YES;
    
    UIButton *borderButton = [[FloggerUIFactory uiFactory] createButton:nil];
    borderButton.frame = CGRectMake(3,37, 50, 72); 
//    borderButton.hidden = YES;
    
    [backGroundView addSubview:filterButton];
    [backGroundView addSubview:borderButton];
    
    [self setFilterBtn:filterButton];
    [self setBorderBtn:borderButton];
    
    [filter addSubview:scrollView];
    [filter addSubview:bordScrollView];
    
//    [self.view addSubview:filter];
    [self.middleView   addSubview:filter];
    [self setFilterView:filter];
    
    //filter
    UIImage *filterImage = [FloggerUtility thumbnailImage:FI_FILTER_BAR_TAB];
    CGPoint filterItemPoint = CGPointMake(225, 0);
    UIButton *filterItem = [self setButtonProperty:filterImage withHighlightImage:nil withPoint:filterItemPoint withButtonTag:FILTERITEM];
    //add label up down to filterimage
    CGRect labelRect = CGRectMake(10, 0, filterItem.frame.size.width-10, filterItem.frame.size.height);
    UILabel *tempLabel = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
    tempLabel.font = [UIFont boldSystemFontOfSize:15];
    tempLabel.textColor = [UIColor whiteColor];    
    [tempLabel setText:NSLocalizedString(@"Filters", @"Filters")];
    [tempLabel setTextAlignment :UITextAlignmentCenter];
    [tempLabel setUserInteractionEnabled:NO];
    tempLabel.backgroundColor = [UIColor clearColor];
    
    tempLabel.shadowOffset = CGSizeMake(0, -1);
//    tempLabel.shadowColor = [UIColor blackColor];
    tempLabel.tag = 50;
    
    [filterItem addSubview:tempLabel];
    
    UIImage *upArrow = [[FloggerUIFactory uiFactory] createImage:FI_CAMERA_UP_ARROW];
    UIImage *downArrow = [[FloggerUIFactory uiFactory] createImage:FI_CAMERA_DOWN_ARROW];
    UIImageView *upImageV = [[FloggerUIFactory uiFactory] createImageView:upArrow];
    upImageV.frame = CGRectMake(10, 12, upArrow.size.width, upArrow.size.height);
    upImageV.tag = 51;
    
    UIImageView *downImageV = [[FloggerUIFactory uiFactory] createImageView:downArrow];
    downImageV.frame = CGRectMake(10, 12, downArrow.size.width, downArrow.size.height);
    downImageV.tag = 52;
    
    [filterItem addSubview:upImageV];
    [filterItem addSubview:downImageV];
    
    
    
    [self setFilterItem:filterItem];
//    [self.view addSubview:filterItem];
    [self.middleView addSubview:filterItem];
    
    //begin add reset button
    UIImage *resetImage = [FloggerUtility thumbnailImage:FI_RESET_ICON];
    CGPoint resetPoint = CGPointMake(0, -15);
    UIButton *resetButton = [self setButtonProperty:resetImage withHighlightImage:nil withPoint:resetPoint withButtonTag:RESETBTN];
    [resetButton setShowsTouchWhenHighlighted:YES];
    
    [resetButton setHidden:YES];
    [self.middleView addSubview:resetButton];
    [self setResetBtn:resetButton];
    //end add reset button
    [self.view addSubview:self.middleView];

    //adjustType
    UIImage *adjustImage = [FloggerUtility thumbnailImage:FI_ADJUSTMENT_INDICATOR_BOX];
    UILabel *adjustType = [[[UILabel alloc] init] autorelease];
    CGRect adjustTypeRect = CGRectMake(0, 0, adjustImage.size.width, adjustImage.size.height);
    [adjustType setFrame:adjustTypeRect];
    [adjustType setTextAlignment:UITextAlignmentCenter];
    [adjustType setUserInteractionEnabled:NO];
    [adjustType setBackgroundColor:[UIColor clearColor]];
    //    [adjustType setText:@"qwewewq"];
    
    UIImageView *adjustImageView = [[[UIImageView alloc] initWithImage:adjustImage] autorelease];
    adjustImageView.frame = CGRectMake(160-adjustImage.size.width/2, 55, adjustImage.size.width, adjustImage.size.height);
    [adjustImageView addSubview:adjustType];
    
    [self setAdjustTypeView:adjustImageView];
    
    [self setAdjustType:adjustType];
    [self.view addSubview:adjustImageView];

 
    //adjustLayer
    CALayer *adjustLayer = [[[CALayer alloc] init] autorelease];
    [adjustLayer setFrame:[[self controlView] frame]];
    adjustLayer.contentsScale = 2;
    [adjustLayer setDelegate:self];
    [[[self controlView] layer] addSublayer:adjustLayer];
    [self setAdjustLayer:adjustLayer];
     
    //timeslider for editVideo
    UIImage *slider = [FloggerUtility thumbnailImage:FI_SLIDER];
    UIImage *progressBar = [FloggerUtility thumbnailImage:FI_PROGRESS_BAR];
    UIImage *trackBar = [FloggerUtility thumbnailImage:FI_TRACK_BAR];
    
    UISlider *timeSlider = [[[UISlider alloc] init] autorelease];
    timeSlider.frame = CGRectMake(10, 20, 300, trackBar.size.height);
    [timeSlider setThumbImage:slider forState:UIControlStateNormal];
    [timeSlider setMinimumTrackImage:progressBar forState:UIControlStateNormal];
    [timeSlider setMaximumTrackImage:trackBar forState:UIControlStateNormal];
    [timeSlider addTarget:self action:@selector(timeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    //  return; 
    //gesture
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] init] autorelease];
    [tapGesture addTarget:self action:@selector(tapSlider:)];
    [timeSlider addGestureRecognizer:tapGesture];
    
    [self.view addSubview:timeSlider];
    [self setTimeSlider:timeSlider];

    //    UIImage
    UIImage *timeBox = [FloggerUtility thumbnailImage:FI_TIME_BOX];
    UIImageView *slideTimeView = [[[UIImageView alloc] initWithImage:timeBox] autorelease];
    [slideTimeView setFrame:CGRectMake(0, 40, timeBox.size.width, timeBox.size.height)];
    UILabel *slideTimeLabel = [[[UILabel alloc] init] autorelease];
    [slideTimeLabel setTextAlignment:UITextAlignmentCenter];
    [slideTimeLabel setFrame:CGRectMake(0, 0, timeBox.size.width, timeBox.size.height)];
    [slideTimeLabel setBackgroundColor:[UIColor clearColor]];
    [slideTimeLabel setTextColor:[UIColor whiteColor]];
    [slideTimeView addSubview:slideTimeLabel];
    [self.view addSubview:slideTimeView];
    [self setSlideTimeView:slideTimeView];
    //return;
    //ISIrisView *irisView = [ISIrisView sharedInstance]; //[[[ISIrisView alloc] initWithFrame:CGRectMake(0, 0, 320, 427)] autorelease];    
    //self.isIrisView = irisView;    
    //[self.view addSubview:irisView]; 
    
}

-(ISIrisView*) isIrisView
{
    if(!_isIrisView)
    {
        ISIrisView *irisView = [ISIrisView sharedInstance];//[[[ISIrisView alloc] initWithFrame:CGRectMake(0, 0, 320, 427)] autorelease]; 
        //    [ISIrisView sharedInstance]; // 
        //    [irisView setHidden:YES];
        //[irisView.statisIrisView setHidden:YES];
        self.isIrisView = irisView;    
        [self.view addSubview:irisView]; 
        [irisView bringSubviewToFront:self.middleView];
        //        [irisView openIris];
    } 
    return _isIrisView;
}
/*-(void) myIrisView
{
//    dispatch_async(<#dispatch_queue_t queue#>, <#^(void)block#>)
    if(!self.isIrisView)
    {
        ISIrisView *irisView = [ISIrisView sharedInstance];//[[[ISIrisView alloc] initWithFrame:CGRectMake(0, 0, 320, 427)] autorelease]; 
        //    [ISIrisView sharedInstance]; // 
        //    [irisView setHidden:YES];
        //[irisView.statisIrisView setHidden:YES];
        self.isIrisView = irisView;    
        [self.view addSubview:irisView]; 
        [irisView bringSubviewToFront:self.middleView];
//        [irisView openIris];
    }
    
}*/

- (void) myloadView
{    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    //set view 
    CGRect viewFrameRect = CGRectMake(0, 0, 320, 480);
    [[self view] setFrame:viewFrameRect];
    
    //add Tool bar
    [self buildToolBarView];


    //add myMiddleView
    [self buildMiddleView];
 
    //    return;
    //add myBottomView
    [self buildBottomView];
    
    //add myConfirmView
    [self buildConfirmView];
      
}

-(void) buildInvisibleViewAtStart
{
    //flash
    UIImage *flashAutoButton = [FloggerUtility thumbnailImage:FI_FLASH_AUTO];
    UIImage *flashAutoButtonHighlighted = [FloggerUtility thumbnailImage:FI_FLASH_AUTO_HIGHLIGHT];
    UIImage *flashButton = [FloggerUtility thumbnailImage:FI_FLASH_ON];
    UIImage *flashButtonHighlighted = [FloggerUtility thumbnailImage:FI_FLASH_ON_HIGHLIGHT];
    UIImage *flashOffButton = [FloggerUtility thumbnailImage:FI_FLASH_OFF];
    UIImage *flashOffButtonHighlighted = [FloggerUtility thumbnailImage:FI_FLASH_OFF_HIGHLIGHT];


    CGPoint flashOffBtnPoint = CGPointMake(0, 0);
    UIButton *flashOffBtn = [self setButtonProperty:flashOffButton withHighlightImage:flashOffButtonHighlighted withPoint:flashOffBtnPoint withButtonTag:FLASHOFFTAG];
    
    CGPoint flashBtnPoint = CGPointMake(0, flashOffButton.size.height);
    UIButton *flashBtn = [self setButtonProperty:flashButton withHighlightImage : flashButtonHighlighted withPoint:flashBtnPoint withButtonTag:FLASHTAG];
        
    CGPoint flashAutoBtnPoint = CGPointMake(0, flashButtonHighlighted.size.height + flashOffButtonHighlighted.size.height );
    UIButton *flashAutoBtn = [self setButtonProperty:flashAutoButton withHighlightImage: flashAutoButtonHighlighted withPoint:flashAutoBtnPoint withButtonTag:FLASHAUTOTAG];
    
    int flashMenuWidth = flashOffButtonHighlighted.size.width;
    int flashMenuHeight = flashButtonHighlighted.size.height + flashOffButtonHighlighted.size.height + flashAutoButtonHighlighted.size.height;
    UIView *flashMenu = [[[UIView alloc] initWithFrame:CGRectMake(9, 50, flashMenuWidth, flashMenuHeight)] autorelease];
    
    [flashMenu addSubview:flashBtn];
    [flashMenu addSubview:flashAutoBtn];
    [flashMenu addSubview:flashOffBtn];

    //tiltMenu
    UIImage *tiltShiftButtonHighlighted = [FloggerUtility thumbnailImage:FI_TILT_OFF_HIGHLIGHT];
    UIImage *tiltShiftHorizontalButton = [FloggerUtility thumbnailImage:FI_TILT_LINEAR];
    UIImage *tiltShiftHorizontalButtonHighlighted = [FloggerUtility thumbnailImage:FI_TILT_LINEAR_HIGHLIGHT];
    UIImage *tiltShiftIcon = [FloggerUtility thumbnailImage:FI_TILT_OFF];
    UIImage *tiltShiftRadialButton = [FloggerUtility thumbnailImage:FI_TILT_RADIAL];
    UIImage *tiltShiftRadialButtonHighlighted = [FloggerUtility thumbnailImage:FI_TILT_RADIAL_HIGHLIGHT];
    
    CGPoint tiltShiftBtnPoint = CGPointMake(0, 0);
    UIButton *tiltShiftBtn = [self setButtonProperty:tiltShiftIcon withHighlightImage:tiltShiftButtonHighlighted withPoint:tiltShiftBtnPoint withButtonTag:TILTSHIFTTAG];
    
    CGPoint tiltShiftRadialBtnPoint = CGPointMake(0, tiltShiftButtonHighlighted.size.height);
    UIButton *tiltShiftRadialBtn = [self setButtonProperty:tiltShiftRadialButton withHighlightImage:tiltShiftRadialButtonHighlighted withPoint:tiltShiftRadialBtnPoint withButtonTag:TILTSHIFTRADIAL];
    
    CGPoint tiltShiftHorizonBtnPoint = CGPointMake(0, tiltShiftButtonHighlighted.size.height + tiltShiftRadialButtonHighlighted.size.height);
    UIButton *tiltShiftHorizonBtn = [self setButtonProperty:tiltShiftHorizontalButton withHighlightImage:tiltShiftHorizontalButtonHighlighted withPoint:tiltShiftHorizonBtnPoint withButtonTag:TILTSHIFTHORIZONTAG];
    

    
    int tiltMenuWidth = tiltShiftIcon.size.width;
    int tiltMenuHeight = tiltShiftButtonHighlighted.size.height + tiltShiftRadialButtonHighlighted.size.height +tiltShiftIcon.size.width;
    
    UIView *tiltMenu = [[[UIView alloc] initWithFrame:CGRectMake(66, 50, tiltMenuWidth, tiltMenuHeight)] autorelease];
    [tiltMenu setUserInteractionEnabled:YES];
    [tiltMenu addSubview:tiltShiftBtn];
    [tiltMenu addSubview:tiltShiftHorizonBtn];
    [tiltMenu addSubview:tiltShiftRadialBtn];
    
    //add
    [[self view] addSubview:flashMenu];
    [[self view] addSubview:tiltMenu];
    
    //set
    [self setTiltMenu:tiltMenu];
    [self setFlashMenu:flashMenu];
    
    //===============================
    //video button
    UIImage *videoRecording = [FloggerUtility thumbnailImage:FI_VIDEO_RECORDING];
    UIImage *videoShoot = [FloggerUtility thumbnailImage:FI_VIDEO_SHOOT];
    //display time (to do)
    UIImage *feedFollowPhoto = [FloggerUtility thumbnailImage:FI_FEED_FOLLOW_PHOTO];
    
    CGPoint videoRecordingBtnPoint = CGPointMake(111, 432);
    UIButton *videoRecordingBtn = [self setButtonProperty:videoRecording withHighlightImage:nil withPoint:videoRecordingBtnPoint withButtonTag:VIDEORECORD];
    
    
    CGPoint videoShootBtnPoint = CGPointMake(111, 432);
    UIButton *videoShootBtn = [self setButtonProperty:videoShoot withHighlightImage:nil withPoint:videoShootBtnPoint withButtonTag:VIDEOSHOOT];
    
    //add recordDuration
    CGPoint recordDurationPoint = CGPointMake((320-feedFollowPhoto.size.width)-15, 10);
    UIButton *recordDuration = [self setButtonProperty:feedFollowPhoto withHighlightImage:nil withPoint:recordDurationPoint withButtonTag:99];
    
    UILabel *recordDurationLabel = [[[UILabel alloc] init] autorelease];
    CGRect recordDurationLabelRect = CGRectMake(0, 0, feedFollowPhoto.size.width, feedFollowPhoto.size.height);
    [recordDurationLabel setFrame:recordDurationLabelRect];
    [recordDurationLabel setTextAlignment:UITextAlignmentCenter];
    [recordDurationLabel setUserInteractionEnabled:NO];
    [recordDurationLabel setBackgroundColor:[UIColor clearColor]];
    [recordDurationLabel setTextColor:[UIColor whiteColor]];
    [recordDuration addSubview:recordDurationLabel];
    
    //add
    [[self view] addSubview:videoRecordingBtn];
    [[self view] addSubview:videoShootBtn];
 
    [[self view] addSubview:recordDuration];
    
    //set
    [self setVideoRecordingBtn:videoRecordingBtn];
    [self setVideoShootBtn:videoShootBtn];
    [self setRecordingDuration:recordDuration];
    [self setRecordingDurationLabel:recordDurationLabel];
    
}

-(BOOL) hasExtraEffect
{
     return _tiltStatus == TILTSHIFTHORIZONTAG || _tiltStatus == TILTSHIFTRADIAL|| self.render.postFilterMode;
}
#pragma mark - View lifecycle
-(void) addOpenGlRender
{
    //glview
    UIView *controlView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,PRIVIEW_OUTPUT_WIDTH,PRIVIEW_OUTPUT_HEIGHT)] autorelease];
    //[controlView setDelegate:self];
    
    
    FloggerGLView *glRenderView = [[[FloggerGLView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,PRIVIEW_OUTPUT_WIDTH,PRIVIEW_OUTPUT_HEIGHT)] autorelease];
    
    self.glRenderView = glRenderView;
    
    //opengl
    self.glRenderView.contentScaleFactor = [[UIScreen mainScreen] scale];
//    NSLog(@"main scale: %f",[[UIScreen mainScreen] scale]);
        
    UIView *backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,PRIVIEW_OUTPUT_WIDTH,PRIVIEW_OUTPUT_HEIGHT-0)] autorelease];
    backgroundView.backgroundColor = [UIColor blackColor];
    [[self view]addSubview:backgroundView];
    
    [[self view ]addSubview:glRenderView];
    // add     
	[[self view] addSubview:controlView];
    
    controlView.opaque = NO;
    //set
    [self setControlView:controlView];
}

-(void) addFocusLayOnGLView
{
    UIImage *focus = [FloggerUtility thumbnailImage:FI_FOCUSCROSS];
    UIImageView *focusCrossImage = [[[UIImageView alloc] initWithImage:focus] autorelease];
    [self setFocusImage:focusCrossImage];

}

-(void) myCaptureAndWriteManage
{
    //captureManage
    FloggerCaptureManage *captureManage = [[[FloggerCaptureManage alloc] init] autorelease];
    [captureManage setOutputDelegate:self];
    if (self.statusMode == VIDEOMODE) {
        [captureManage setupCaptureSession:@"video"];
    } else 
    {
        [captureManage setupCaptureSession:@"photo"];

    }
    
    //set focus
    [captureManage setFocusMode:AVCaptureFocusModeAutoFocus];
    //set exposure
    [captureManage setExposureMode:AVCaptureExposureModeAutoExpose];
    //set whiteBalance
    
    //write manage
    FloggerVideoWriteManage *writeManage = [[[FloggerVideoWriteManage alloc] init] autorelease];
    
    //add
    [self setCaptureManage:captureManage];
    [self setWriteManage:writeManage];   
    
    _writerMovieQueue = dispatch_queue_create("writerMovieQueue", NULL);
    //if(self.isViewLoaded && self.view.window)
    {
        
        [self.captureManage.captureSession startRunning];
    }
}


#define MAX_INDEX 25
- (void) displayView:(int*) layout
{
    for (int i=0;i<MAX_INDEX&&layout[i]>=0;i++) {
        [[self.viewArray objectAtIndex:layout[i]] setHidden:NO];
    }
}
- (void) switchStatusMode : (STATUSMODE) statusMode
{    
    //==================================
    // display view layout begin
    // hiden all view or layer
    for (id view in self.viewArray) {
        [view setHidden:YES];
    }
    _renderBufferRatio = 2.0;
    [self render].staticPreviewMode = NO;   
    [self render].quality = _renderBufferRatio;
     self.glRenderView.contentScaleFactor = [[UIScreen mainScreen] scale];
    switch (statusMode) {
        case PHOTOMODE:
            [self displayView: photoLayout];
            break;
        case VIDEOMODE:
            [self displayView: videoLayout];
            break;
        case RECORDINGMODE:
            // use th worst quality and best speed
            _renderBufferRatio = 1.0;
            [self render].quality = _renderBufferRatio;
            [self displayView: recordingLayout];
            break;
        case PHOTOEDITMODE:
            [self displayView: photoEditLayout];
            [self render].staticPreviewMode=YES;
            [self displayAdjustType];
            break;
        case STILLIMAGEMODE:
            [self displayView: stillImageLayout];
            [self render].staticPreviewMode=YES;
            [self displayAdjustType];
            break;
        case VIDEOEDITMODE:
            // use th worst quality and best speed
            //self.glRenderView.contentScaleFactor = 1.0;
            _renderBufferRatio = 1.0;
            [self render].quality = _renderBufferRatio;
            [self displayView: videoEditLayout];
            break;
        default:
            break;
    }
    // change Location begin
    UIButton *slideBtn = [self slideBtn];
    //set statusmode
    if (statusMode == PHOTOMODE) 
    {
        //set slidebtn
        CGRect slideBtnRect = CGRectMake(246, slideBtn.frame.origin.y, slideBtn.frame.size.width, slideBtn.frame.size.height);
        [slideBtn setFrame:slideBtnRect];
    } else if (statusMode == VIDEOMODE)
    {
        //set slidebtn
        CGRect slideBtnRect = CGRectMake(279, slideBtn.frame.origin.y, slideBtn.frame.size.width, slideBtn.frame.size.height);
        [slideBtn setFrame:slideBtnRect];
    }
    // change Location end
    //=============================
    if (statusMode == RECORDINGMODE) 
    {        
//        self.glRenderView.contentScaleFactor = 1.0;
        [self performSimpleOpenGL:^{
            self.render.quality = 1.0;
            [self.render setNewDimention:RECORDING_OUTPUT_WIDTH 
                                  Height:RECORDING_OUTPUT_HEIGHT preview:NO];
        }];

    } else if (statusMode == PHOTOEDITMODE || statusMode == VIDEOEDITMODE) 
    {
        [self performSimpleOpenGL:^{
            if (!self.syntax) {
                //copyfilter not exist
                self.currentFilter = self.normalFilter; 
                [self.render installProgram:self.currentFilter.filter];
            }
        }];
    } else if (statusMode == PHOTOMODE || statusMode == VIDEOMODE)
    {
//        self.glRenderView.contentScaleFactor = [[UIScreen mainScreen] scale];
        /*if(_tiltStatus == TILTSHIFTHORIZONTAG || _tiltStatus == TILTSHIFTRADIAL)
        {
            float qRatio =[self.currentFilter getQualityPrefered:_renderBufferRatio];
            [self performSimpleOpenGL:^{
                [self.render setNewDimention:PRIVIEW_OUTPUT_WIDTH Height:PRIVIEW_OUTPUT_HEIGHT preview:YES];
            }];   
        } else {*/
        self.render.openGL.eaglLayer.frame = CGRectMake(0, 0, PRIVIEW_OUTPUT_WIDTH, PRIVIEW_OUTPUT_HEIGHT);
            [self performSimpleOpenGL:^{
                float qRatio =[self.currentFilter getQualityPrefered:_renderBufferRatio Mode:[self hasExtraEffect]];
                self.render.quality = qRatio;
//                NSLog(@"photo mode qration is %f",qRatio);
                [self.render setNewDimention:PRIVIEW_OUTPUT_WIDTH*qRatio Height:PRIVIEW_OUTPUT_HEIGHT*qRatio preview:YES];
            }];
        //}
    }
    //set
    if (statusMode == RECORDINGMODE) {
        [[self render] setGlMode:OFFSCREEN_MODE];
        [self.render setNeedOnlyRawData:YES];
        
        [self.slideBtn setEnabled:NO];
        [self.importBtn setEnabled:NO];
        
        [self.captureManage setFocusMode:AVCaptureFocusModeLocked];
    } else
    {
        [self.render setNeedOnlyRawData:NO];
        [[self render] setGlMode:VIEW_MODE];
        
        [self.slideBtn setEnabled:YES];
        [self.importBtn setEnabled:YES];
        
        [self.captureManage setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    /* test begin modify
    [self.render clearPostFilter];
     */
    if (statusMode == PHOTOEDITMODE || statusMode == VIDEOEDITMODE)
    {
        if (!self.syntax) {
            [self.render clearPostFilter];
            [self.render clearTiltBlur];
            [self.resetBtn setHidden:YES];
        }
        
        _tiltStatus = TILTSTATUSOFF;
        _isTilt = false;
        _adjustMode = 0;
        UIImage *tiltShiftIcon = [FloggerUtility thumbnailImage:FI_TILT_SHIFT];
        UIImage *adjustImage = [FloggerUtility thumbnailImage:FI_GRID];
        [self.tiltItem setImage:tiltShiftIcon forState:UIControlStateNormal];
        [self.adjustItem setImage:adjustImage forState:UIControlStateNormal];

    }
    [self updateAdjustType];
    [self.adjustLayer setNeedsDisplay];
    [self.render setTiltShowMode:NO];
    //blur
    if (statusMode == VIDEOMODE) {
        UIImage *tiltShiftIcon = [FloggerUtility thumbnailImage:FI_TILT_SHIFT];
        [self.tiltItem setImage:tiltShiftIcon forState:UIControlStateNormal];
        _tiltStatus = TILTSTATUSOFF;
        //            [self renderImage:YES];
        _isTilt = false;
        [self.render clearTiltBlur];  
    }
    
    
    //[self updateAdjustType:_adjustArea :_bright];
    if ((statusMode == PHOTOEDITMODE) || (statusMode == STILLIMAGEMODE)
        || (statusMode == VIDEOEDITMODE)) {        
        [self.flashItem setEnabled:NO];
        [self.tiltItem setEnabled:YES];
        [self.swapItem setEnabled:NO];
        [self.adjustItem setEnabled:YES];
        [self.cancelItem setEnabled:NO];
    } else if(statusMode == VIDEOMODE)
    {
        [self.flashItem setEnabled:YES];
        [self.tiltItem setEnabled:NO];
        [self.swapItem setEnabled:YES];
        [self.adjustItem setEnabled:YES];
        [self.cancelItem setEnabled:YES];
    } else if (statusMode == VIDEOEDITMODE)
    {
        [self.flashItem setEnabled:NO];
        [self.tiltItem setEnabled:NO];
        [self.swapItem setEnabled:NO];
        [self.adjustItem setEnabled:YES];
        [self.cancelItem setEnabled:YES];
    } else if (statusMode == PHOTOMODE)
    {
        [self.flashItem setEnabled:YES];
        [self.tiltItem setEnabled:YES];
        [self.swapItem setEnabled:YES];
        [self.adjustItem setEnabled:YES];
        [self.cancelItem setEnabled:YES];
    }
    [self setStatusMode:statusMode];
    //add gesture
    [self addAndManageGesture];
    
    //test begin
    if (self.statusMode == PHOTOEDITMODE || self.statusMode == VIDEOEDITMODE) {
        _isFilterHidden = false;
    } else {
        _isFilterHidden = true;
    }
    self.render.usingIOS5 = YES;
    //test end
    [self displayAdjustType];
    [self showAdjustConfirmByMode];
    
    

}

- (void)startOpenGL
{
    OpenGLRenderCenter *render = [[[OpenGLRenderCenter alloc]init]autorelease];
    [render setNeedOnlyRawData:NO];
    //set mode
    [render setGlMode:VIEW_MODE];
    
    //retrieve filter
    render.resourceProvider = self;
    NSDictionary *syntaxParam = [self.syntax JSONValue];

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
        //border set todo tilet change  late
        NSString *borderName = [syntaxParam objectForKey:kBorderName];
//        NSLog(@"bordername is %@",borderName);
        NSArray *bList = [[[FloggerFilterAdapter sharedInstance] createBorderList] autorelease];
        for (FilterProperty *bFilter in bList) {
            if ([bFilter.title isEqualToString:borderName]) {
                self.currentBorder = bFilter;
                break;
            }
        }
        
        _tiltStatus = [[syntaxParam objectForKey:kTiltStatus]intValue];
        if(_tiltStatus)
        {
            _scale = [[syntaxParam objectForKey:kScale] floatValue];
            _rotate = [[syntaxParam objectForKey:kRotate]floatValue];
            // TODO set the titl button status
        }
        render.degreeStrenthStandard = [[syntaxParam objectForKey:kFilterStrenth]floatValue];
        render.degreeSaturationStandard = [[syntaxParam objectForKey:kSaturation]floatValue];
        render.degreeBrightnessStandard = [[syntaxParam objectForKey:kBright]floatValue];
        render.degreeContrastStandard = [[syntaxParam objectForKey:kContrast]floatValue];
    
    }
    
    if(!self.currentFilter || [self.currentFilter.name isEqualToString:@"normal"])
    {
        self.currentFilter = self.normalFilter;
    }
    GLfloat quality = [self.currentFilter getQualityPrefered:_renderBufferRatio Mode:[self hasExtraEffect]];
    render.quality = quality;
    [render setupProgram:PRIVIEW_OUTPUT_WIDTH * quality 
                  Height:PRIVIEW_OUTPUT_HEIGHT * quality Data:self.currentFilter.filter StringType:XML preview:NO];
    //border set
    if (self.currentBorder) {
        UIImage* borderImage = [self createTextureImageFromName:self.currentBorder.borderImageName]; 
        [render registerBorderImage:borderImage];
        if(!borderImage)
        {
            self.currentBorder = nil;
        }
    }
    [self setRender:render];
}
- (void)buildSimulatedViewsOfTiltShift
{
    //test begin
    UIView *radius = [[[UIView alloc] init] autorelease];
    //    radius.frame = CGRectMake(135, 215, 50, 50);
    radius.frame = CGRectMake(0, 0, PRIVIEW_OUTPUT_WIDTH, PRIVIEW_OUTPUT_HEIGHT);
    [radius setHidden:YES];
    [self.view addSubview:radius];
    [self setRadiusView:radius];
    
    UIView *horizon = [[[UIView alloc] init]autorelease];
    //    horizon.frame = CGRectMake(0, 200, 320, 80);
    horizon.frame =CGRectMake(0, 0, PRIVIEW_OUTPUT_WIDTH, PRIVIEW_OUTPUT_HEIGHT);
    [horizon setHidden:YES];
    [horizon setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:horizon];
    [self setHorizonView:horizon];
}
- (void) internalInit
{
    ADJUSTTYPE[0] = NSLocalizedString(@"Contrast", @"Contrast");
    ADJUSTTYPE[1] = NSLocalizedString(@"Brightness", @"Brightness");
    ADJUSTTYPE[2] = NSLocalizedString(@"Saturation", @"Saturation");
    ADJUSTTYPE[3] = NSLocalizedString(@"Intensity", @"Intensity");
    
    _renderBufferRatio = 2.0;

    _adjustMode = 0;
    _isAdjust = false;
    
    _tiltStatus = 0;
    _isTilt = false;
    _swapStatus = 0;
    // default Mode TODO, should switch according the mode passed in
    self.statusMode = PHOTOMODE;
    
    //set filter button
    FloggerServerManage *serverManage = [[[FloggerServerManage alloc] init] autorelease];
    [serverManage setServerDelegate:self];
    [self setServerManage:serverManage];
    
    _slideVideoQueue  = dispatch_queue_create("slideVideoQueue", NULL);
#if defined(USE_SYSTEM_THREAD)
    _standardOpenGLQueue = dispatch_queue_create("standardOpenGLQueue", NULL);
#else
    _openGLQueue = [[FloggerQueue alloc]init];
    _openGLQueue.priority = 0.7;
    [_openGLQueue start];
#endif
    [[DataCache sharedInstance] clearMemory];
    [[SDImageCache sharedImageCache] clearMemory];
    
}

- (void) connectGLViewToRender
{
    [self.render setGLLayer:(CAEAGLLayer*)[self.glRenderView layer]];
    //[self.view bringSubviewToFront:self.glRenderView];
            //[self.render processImage];
    //[self.isIrisView performSelectorOnMainThread:@selector(openIris) withObject:nil waitUntilDone:NO];
}
/*- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self cancelClick];
}*/
-(void) loadView
{    
    UIView * mainview = [[[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]]autorelease];
    self.view = mainview;
}

-(UIImage *) transforNormalizeImage : (UIImage*) inImage
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
//    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = inImage.size.width;//CGImageGetWidth(inImage);
    size_t pixelsHigh = inImage.size.height;//CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
//    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
    // per component. Regardless of what the source image format is 
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (NULL,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
    
    CGRect rect = {{0,0},{pixelsWide,pixelsHigh}};
    dispatch_block_t block =  ^{
        UIGraphicsPushContext(context);
        
        CGContextSaveGState(context); 
        CGContextTranslateCTM(context, 0, pixelsHigh);
        CGContextScaleCTM(context, 1.0, -1.0);
        [inImage drawInRect:rect];
        CGContextRestoreGState(context);
        //[originImage drawAtPoint:CGPointMake(0, 0)];
        
        UIGraphicsPopContext();
    };
    if([NSThread currentThread].isMainThread) 
    {
        block();
        
    } 
    else
    {
        dispatch_sync(dispatch_get_main_queue(),block);
    }
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    UIImage * retImage = [UIImage imageWithCGImage:newImage];
    CGImageRelease(newImage);
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    CGContextRelease(context); 
    return retImage;//CGBitmapContextGetData (context);
}

-(void) startOpenGLTest
{
#if defined(USE_SYSTEM_THREAD)
    if(!self.render)
    {
        [self performSimpleOpenGL:^{
            [self startOpenGL];
        } withSync:NO];  
    }
    [self performSimpleOpenGL:^{
        [self connectGLViewToRender];
        [self performSelectorOnMainThread:@selector(enableInitialComponent) withObject:nil waitUntilDone:NO ];
    } withSync:NO];  
#else 
    if(!self.render)
    {
        [_openGLQueue performTask:self selector:@selector(startOpenGL) withObject:nil Sync:NO];
    }
    [_openGLQueue performTask:self selector:@selector(connectGLViewToRender) withObject:nil Sync:NO];
#endif
}

-(void) enableInitialComponent
{
    //to do
    self.toolBarView.userInteractionEnabled = YES;
    self.bottmonView.userInteractionEnabled = YES;
    self.middleView.userInteractionEnabled = YES;
    self.controlView.userInteractionEnabled = YES;
    self.videoRecordingBtn.userInteractionEnabled = YES;
    self.videoShootBtn.userInteractionEnabled = YES;
    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{ 
	// Get the current device angle
	float xx = -[acceleration x]; 
	float yy = [acceleration y]; 
	float angle = atan2(yy, xx); 
	NSLog(@"=== angle %f",angle);
	// Add 1.5 to the angle to keep the label constantly horizontal to the viewer.
//	[interfaceOrientationLabel setTransform:CGAffineTransformMakeRotation(angle+1.5)]; 
	
	// Read my blog for more details on the angles. It should be obvious that you 
	// could fire a custom shouldAutorotateToInterfaceOrientation-event here.
	if(angle >= -2.25 && angle <= -0.25)
	{
		if(deviceOrientation != UIInterfaceOrientationPortrait)
		{
			deviceOrientation = UIInterfaceOrientationPortrait;
            [self receivedRotate];
//			[interfaceOrientationLabel setText:@"UIInterfaceOrientationPortrait"];
		}
	}
	else if(angle >= -1.75 && angle <= 0.75)
	{
		if(deviceOrientation != UIInterfaceOrientationLandscapeRight)
		{
			deviceOrientation = UIInterfaceOrientationLandscapeRight;
            [self receivedRotate];
//			[interfaceOrientationLabel setText:@"UIInterfaceOrientationLandscapeRight"];
		}
	}
	else if(angle >= 0.75 && angle <= 2.25)
	{
		if(deviceOrientation != UIInterfaceOrientationPortraitUpsideDown)
		{
			deviceOrientation = UIInterfaceOrientationPortraitUpsideDown;
            [self receivedRotate];
//			[interfaceOrientationLabel setText:@"UIInterfaceOrientationPortraitUpsideDown"];
		}
	}
	else if(angle <= -2.25 || angle >= 2.25)
	{
		if(deviceOrientation != UIInterfaceOrientationLandscapeLeft)
		{
			deviceOrientation = UIInterfaceOrientationLandscapeLeft;
            [self receivedRotate];
//			[interfaceOrientationLabel setText:@"UIInterfaceOrientationLandscapeLeft"];
		}
	}
} 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Bind the accelerometer events to our instance
    if (_isAccessLock) {
        self.deviceAccelerometer = [UIAccelerometer sharedAccelerometer];
        self.deviceAccelerometer.delegate = self;
    } else {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receivedRotate) name: UIDeviceOrientationDidChangeNotification object: nil];
    }

//	[[UIAccelerometer sharedAccelerometer] setDelegate:self]; 
    //return;
//    NSLog(@"camera begin");
//    [self.navigationController.navigationBar setHidden:YES];
    //dispatch_async(dispatch_get_main_queue(), ^{
    //opengl
    [self addOpenGlRender];
    //focusbox
    [self addFocusLayOnGLView];

   
    [self myloadView];

     //return;
    //[self myCaptureAndWriteManage];
    [self performSelector:@selector(myCaptureAndWriteManage) withObject:nil afterDelay:0.01];
    dispatch_async(dispatch_get_main_queue(), ^{
        //hiden item 
        [self buildInvisibleViewAtStart];
        
        self.viewArray = [[[NSArray alloc] 
                           initWithObjects:[self toolBarView],[self bottmonView],
                           [self recordingDuration],[self flashMenu],[self tiltMenu],
                           [self filterView],[self cameraShootBtn],
                           [self videoShootBtn],[self videoRecordingBtn], 
                           [self cameraConfirm],[self adjustTypeView],[self timeSlider],[self playBtn],[self adjustLayer],[self slideTimeView],nil] autorelease];
        
        [self switchStatusMode:self.statusMode];
        
        //en
        self.toolBarView.userInteractionEnabled = NO;
        self.bottmonView.userInteractionEnabled = NO;
        self.middleView.userInteractionEnabled = NO;
        self.controlView.userInteractionEnabled = NO;
        self.videoShootBtn.userInteractionEnabled = NO;
        self.videoRecordingBtn.userInteractionEnabled = NO;
        
        [self buildSimulatedViewsOfTiltShift]; 
    });
    //en
    self.toolBarView.userInteractionEnabled = NO;
    self.bottmonView.userInteractionEnabled = NO;
    self.middleView.userInteractionEnabled = NO;
    self.controlView.userInteractionEnabled = NO;
    self.videoShootBtn.userInteractionEnabled = NO;
    self.videoRecordingBtn.userInteractionEnabled = NO;
    
    [[self playBtn] setHidden:YES];
    [[self cameraConfirm]setHidden:YES];
    //return;
    //[self.isIrisView  closeIris];
    NSMutableArray *iconArray = [[[NSMutableArray alloc] initWithObjects:self.flashItem,
                           self.tiltItem,self.swapItem,self.adjustItem,self.cancelItem,
                           self.photoSlider,self.videoSlider,nil] autorelease];
    self.rotateIconArray = iconArray;
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receivedRotate) name: UIDeviceOrientationDidChangeNotification object: nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResign)
     name:UIApplicationWillResignActiveNotification object:NULL];
    

    // should be removed todo
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //[self.serverManage retrieveFilter]; 
    });
    //[self startOpenGLTest];
    //[self performSelector:@selector(startOpenGLTest) withObject:nil afterDelay:0.01];
    //return;
    if(!self.render)
    {
        //[self startOpenGLTest];
        [self performSelector:@selector(startOpenGLTest) withObject:nil afterDelay:0.01];
    }
    //[self InitializeDefaultButtons];
    [self performSelector:@selector(InitializeDefaultButtons) withObject:nil afterDelay:2];
    //[self performSelector:@selector(myIrisView) withObject:nil afterDelay:0.5];
}

-(void) applicationWillResign
{
    if (self.statusMode == RECORDINGMODE) {
        [self.videoRecordingBtn setEnabled:NO];    
        [self.videoShootBtn setEnabled:YES];
        [[[self writeManage] assetWriter] cancelWriting];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self switchStatusMode:VIDEOMODE];
        });
    }    
}

-(void) execBlock : (dispatch_block_t) block
{
    block();
}
-(void) performSimpleRecording : (dispatch_block_t) block  withSync : (BOOL) sync
{
    if(sync)
    {
        dispatch_sync(_writerMovieQueue, block);
    } 
    else
    {
        dispatch_async(_writerMovieQueue, block);
    }
}

- (void)addAdjustingAnimationToLayer:(CALayer *)layer removeAnimation:(BOOL)remove
{
    if (remove) {
        [layer removeAnimationForKey:@"animateOpacity"];
    }
    if ([layer animationForKey:@"animateOpacity"] == nil) {
        [layer setHidden:NO];
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setDuration:0.7f];
                [opacityAnimation setRepeatCount:1.f];
        //        [opacityAnimation setAutoreverses:YES];
        [opacityAnimation setFromValue:[NSNumber numberWithFloat:1.f]];
        [opacityAnimation setToValue:[NSNumber numberWithFloat:0.f]];
//        [opacityAnimation setAutoreverses: YES];
        opacityAnimation.fillMode = kCAFillModeBoth;
        [opacityAnimation setRemovedOnCompletion:NO];
//        [opacityAnimation ]
        [layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    }
}

// the tap event on GL Layer
-(void) tapOnGLView: (UITapGestureRecognizer *)recognizer
{
    if (self.statusMode == VIDEOMODE || self.statusMode == PHOTOMODE) {
        CGPoint point = [recognizer locationInView:self.view];
        [self tapToExpose:point];
    }
    
    if (self.statusMode == PHOTOMODE) {

        if (!_adjustMode) {
            CGPoint currentTouchPoint = [recognizer locationInView:self.glRenderView];
            if (_tiltStatus == TILTSTATUSRADIAL) {
                [self drawTiltRadius:currentTouchPoint];
            }
            if (_tiltStatus == TILTSTATUSHORIZON) {
                [self drawTiltHorizon:currentTouchPoint];
            }
        }
        
        [self performSelector:@selector(showTiltMask) withObject:nil afterDelay:0.6];
    }
    
    if (self.statusMode == VIDEOEDITMODE) {
        if (self.playBtn.isHidden) {
            [self pauseVideoForWriter];
        }
    }
    
}
-(void) postVideoRender
{
    CMTime newTime = CMTimeMakeWithSeconds(self.timeSlider.value, VIDEOTIMESCALE);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displaySliderTime:newTime];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVideoRender) object:nil];
        [self performSelector:@selector(doVideoRender) withObject:nil afterDelay:0.5];
    }); 
}
-(void) tapSlider: (UITapGestureRecognizer *)recognizer
{
    UISlider* slider = (UISlider*)recognizer.view;
    if (slider.highlighted)
        return; // tap on thumb, let slider deal with it
    CGPoint pt = [recognizer locationInView: slider];
    CGFloat percentage = pt.x / slider.bounds.size.width;
    CGFloat delta = percentage * (slider.maximumValue - slider.minimumValue);
    CGFloat value = slider.minimumValue + delta;
    [slider setValue:value animated:YES];
    
    [slider setHidden:NO];
    [self.slideTimeView setHidden:NO];
    [self postVideoRender];
    /*CMTime newTime = CMTimeMakeWithSeconds(slider.value, VIDEOTIMESCALE);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self extractImageFromVideo:self.videoURL withTime:newTime];
        [self displaySliderTime:newTime];
    });  */
    
}

-(void) writeToVideo:(FloggerVideoBuffer*) videoParam
{
    {
        if( [[self writeManage] assetWriter].status != AVAssetWriterStatusWriting  )
        {
            [[[self writeManage] assetWriter] startWriting];
            [[[self writeManage] assetWriter] startSessionAtSourceTime:videoParam.presentTime];
        }
        while ( ![[self writeManage] videoAssetWriterInput].readyForMoreMediaData)
        {
            [NSThread sleepForTimeInterval:0.0001];
        }
        CVPixelBufferLockBaseAddress(self.render.resultData, kCVPixelBufferLock_ReadOnly);
//        CVPixelBufferRef pixelBuffer = self.render.resultData;
//        NSLog(@"pixelBuffer width is %lu ", CVPixelBufferGetWidth(pixelBuffer));
        if (![[[self writeManage] inputBufferAdaptor] appendPixelBuffer:self.render.resultData withPresentationTime:videoParam.presentTime])
        {
//            NSLog(@"Unable to write to video input");//cvImageBuffer
        }
        
        CVPixelBufferUnlockBaseAddress(self.render.resultData, kCVPixelBufferLock_ReadOnly);
        [videoParam release];
    } 
}

-(void) writeToVideoForBelowIOS5:(FloggerVideoBuffer*) videoParam
{
    {
        if( [[self writeManage] assetWriter].status != AVAssetWriterStatusWriting  )
        {
            [[[self writeManage] assetWriter] startWriting];
            [[[self writeManage] assetWriter] startSessionAtSourceTime:videoParam.presentTime];
        }
        while ( ![[self writeManage] videoAssetWriterInput].readyForMoreMediaData)
        {
            [NSThread sleepForTimeInterval:0.0001];
        }
        if (![[[self writeManage] inputBufferAdaptor] appendPixelBuffer:videoParam.cvImageBuffer withPresentationTime:videoParam.presentTime])
        {
//            NSLog(@"Unable to write to video input");//cvImageBuffer
        }
        
        [videoParam release];
    } 
}


-(void) renderForQueue:(FloggerVideoBuffer*) videoParam
{
    if(self.statusMode== RECORDINGMODE){
        [self performSimpleRecording:^{} withSync:YES];
    };
    
    if (_swapStatus == 0) {
        [self.render render:UIImageOrientationRight willKeepTexture:YES];
    } else {
        [self.render render:UIImageOrientationRightMirrored willKeepTexture:YES];
    }
    
    
    if(self.statusMode== RECORDINGMODE)
    {
        
        {
            if ([self.render.openGL supportFastOpenGL]) {
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
                dispatch_async(_writerMovieQueue, ^{
                    [self writeToVideo:videoParam];
                });
                //            [_writerQueue performTask:self selector:@selector(writeToVideo:) withObject:videoParam Sync:NO];
            } else
            {
                CVPixelBufferRef newBuffer = NULL;
                CVPixelBufferCreateWithBytes(NULL, self.render.openGL.width, self.render.openGL.height, kCVPixelFormatType_32ARGB, self.render.resultData, 4*self.render.openGL.width, NULL, 0, NULL, &newBuffer);            
                videoParam.cvImageBuffer = newBuffer;
                dispatch_async(_writerMovieQueue, ^{
                    [self writeToVideoForBelowIOS5:videoParam];
                });
                //            [_writerQueue performTask:self selector:@selector(writeToVideoForBelowIOS5:) withObject:videoParam Sync:NO];
            }
        }
        
        
        //[self writeToVideo:videoParam];
    } else {
        [videoParam release];
    }
}
//static CFAbsoluteTime testTime = 0;
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
#if defined(FLOGGERDEBUG)  
    NSLog(@"capture output");
#endif
    if (!(([self statusMode] == VIDEOMODE) 
          ||  ([self statusMode] == RECORDINGMODE) 
          || ([self statusMode] == PHOTOMODE))) {
        
        return;
    }
//    NSLog(@"self.status mode is %d",self.statusMode);
//    NSLog(@"captureOutput type is %@",[captureOutput class]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CMTime presentTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    


    /*if(self.statusMode== RECORDINGMODE)
     {
     
     if( [[self writeManage] assetWriter].status != AVAssetWriterStatusWriting  )
     {
     [[[self writeManage] assetWriter] startWriting];
     [[[self writeManage] assetWriter] startSessionAtSourceTime:presentTime];
     }
     }*/
    if (captureOutput == [[self captureManage] videoCaptureOutput]) {
        CVImageBufferRef cvImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress(cvImageBuffer, 0);
        [self performSimpleOpenGL:^{
            if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
            {                
                [self.render setupTextureWithCameraFrame:cvImageBuffer];
            }
        }];
        if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
        {  
            FloggerVideoBuffer *videoParam = [[FloggerVideoBuffer alloc]init];
            videoParam.presentTime = presentTime;
#if defined(USE_SYSTEM_THREAD)
            [self performSimpleOpenGL:^{
                [self renderForQueue:videoParam];
            } withSync:NO];
#else 
            [_openGLQueue performTask:self selector:@selector(renderForQueue:) withObject:videoParam Sync:NO];
#endif
        }
        CVPixelBufferUnlockBaseAddress(cvImageBuffer, 0);
    } else  if (self.statusMode== RECORDINGMODE && captureOutput == [[self captureManage] audioCaptureOutput])
//        } else  if (captureOutput == [[self captureManage] audioCaptureOutput])
    {
        [self performSimpleRecording:^
         {
             if( [[self writeManage] assetWriter].status != AVAssetWriterStatusWriting  )
             {
                 return;
                 //[[[self writeManage] assetWriter] startWriting];
                 //[[[self writeManage] assetWriter] startSessionAtSourceTime:presentTime];
             }
             if( [[self writeManage] assetWriter].status > AVAssetWriterStatusWriting )
             {
                 if( [[self writeManage] assetWriter].status == AVAssetWriterStatusFailed )
//                     NSLog(@"Error: %@", [[self writeManage] assetWriter].error);
                 return;
             }
             int count = 0;
             
             while ( ![[self writeManage] audioAssetWriterInput].readyForMoreMediaData && (count++<5) )
             {
                 [NSThread sleepForTimeInterval:0.001];
             }
             
             if( ![[[self writeManage] audioAssetWriterInput] appendSampleBuffer:sampleBuffer] )
             {
//                 NSLog(@"Unable to write to audio input");
             }
         } 
                            withSync:YES];
    }   
    [pool drain];
}


-(void) clearAdjustLabel
{
    [self.render clearPostFilter];
    _adjustMode = 0;
    [self updateAdjustType];
    [self.resetBtn setHidden:YES];
}


-(void) showTiltMask
{
    [self.render setTiltShowMode:NO];
    [self performSimpleOpenGL:^{
        if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE)){
            [self.render processImage];
//            NSLog(@"===preocess==");
        }
    }];
//    NSLog(@"test===tilt");
}

-(void) initialTilt
{
    if (_tiltStatus == TILTSTATUSRADIAL || _tiltStatus == TILTSTATUSHORIZON) {
        CGPoint currentTouchPoint = CGPointMake(PRIVIEW_OUTPUT_WIDTH/2, PRIVIEW_OUTPUT_HEIGHT/2);
        _scale = 1.0;
        _rotate = 0.0;
        
        if (_tiltStatus == TILTSTATUSRADIAL) {
            self.radiusView.frame = CGRectMake(0, 0, PRIVIEW_OUTPUT_WIDTH, PRIVIEW_OUTPUT_HEIGHT);
            [self drawTiltRadius:currentTouchPoint];
        }
        if (_tiltStatus == TILTSTATUSHORIZON) {
            self.horizonView.frame = CGRectMake(0, 0, PRIVIEW_OUTPUT_WIDTH, PRIVIEW_OUTPUT_HEIGHT);
            [self drawTiltHorizon:currentTouchPoint];
        }
        
        [self performSimpleOpenGL:^{
            if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE)){
                [self.render processImage];
//                NSLog(@"===preocess==");
            }
        }];
        [self performSimpleOpenGL:^{
//            dispatch_async(dispatch_get_main_queue(), ^{
                if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE)){
                    [self performSelector:@selector(showTiltMask) withObject:nil afterDelay:3];
                }
//            });
        }];
        if (!([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE))
        {
            [self performSelector:@selector(showTiltMask) withObject:nil afterDelay:0.3];
        }
        //        if (!([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE)) {
//            [self performSelector:@selector(testTilt) withObject:nil afterDelay:0.3];
//        } else
//        {
//            [self performSimpleOpenGL:^{}];
//            [self performSelector:@selector(testTilt) withObject:nil afterDelay:0.3];
//        }
        
    } else {
        [self performSimpleOpenGL:^{
            if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE)){
                [self.render processImage];
//                NSLog(@"===preocess==");
            }
        }]; 
    }
    
}
-(CGSize) getImageShowSize
{
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    UIImageOrientation fitOrientation = UIImageOrientationUp;
    int startOrientation = _statusMode == STILLIMAGEMODE?_normalizeOrientation:0;
    int currentNormalizeOrientation = 0;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        currentNormalizeOrientation = 0;
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        currentNormalizeOrientation = 2;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        currentNormalizeOrientation = 3;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        currentNormalizeOrientation = 1;
    } 
    int intFitOrientation = currentNormalizeOrientation - startOrientation;
    fitOrientation = [self reverseToOrientation:intFitOrientation Mirrored:NO];
    BOOL mirrored = [self originalImage].imageOrientation>4;
    int intOrb = [self normalizeOrientation:[self originalImage].imageOrientation Mirrored:mirrored] - [self normalizeOrientation:fitOrientation Mirrored:mirrored];
    UIImageOrientation drawOrt = [self reverseToOrientation:intOrb Mirrored:mirrored];
    //[EAGLContext setCurrentContext:self.render.openGL.context];
    UIImage *newImage = [UIImage imageWithCGImage:[self originalImage].CGImage scale:1 orientation:drawOrt];
    
    return [self.render getImagePreviewSize:newImage];
}
//handle with drapDown event
-(void) dropDownClick : (id) sender
{
    [self.adjustLayer setHidden:YES];
    [self.adjustTypeView setHidden:YES];
    
    UIButton *btn = (UIButton *)sender;
    int buttonTag = btn.tag;
    //flash
    UIImage *flashAutoButton = [FloggerUtility thumbnailImage:FI_FLASH_BUTTON_AUTO];
    UIImage *flashButton = [FloggerUtility thumbnailImage:FI_FLASH_BUTTON];
    UIImage *flashOffButton = [FloggerUtility thumbnailImage:FI_FLASH_CANCEL];
    //tilt
    UIImage *tiltShiftHorizontalButton = [FloggerUtility thumbnailImage:FI_TILT_SHIFT_LINEAR];
    UIImage *tiltShiftIcon = [FloggerUtility thumbnailImage:FI_TILT_SHIFT];
    UIImage *tiltShiftRadialButton = [FloggerUtility thumbnailImage:FI_TILT_SHIFT_RADIAL];
    
    //flashfade
    UIImage *flashButtonFade = [FloggerUtility thumbnailImage:FI_FLASH_BUTTON_FADED] ;
    UIImage *flashButtonAutoFaded = [FloggerUtility thumbnailImage:FI_FLASH_BUTTON_AUTO_FADED];    
    UIImage *flashCancelFaded = [FloggerUtility thumbnailImage:FI_FLASH_CANCEL_FADED];    
    
    NSArray *flashImageArray = [[[NSArray alloc] initWithObjects:
                                 flashButton,flashOffButton,flashAutoButton, nil] autorelease];
    NSArray *flashFadeImageArray = [[[NSArray alloc] initWithObjects:
                                 flashButtonFade,flashCancelFaded,flashButtonAutoFaded, nil] autorelease];
    NSArray *tiltShiftImageArray = [[[NSArray alloc] initWithObjects:
                                 tiltShiftIcon,tiltShiftHorizontalButton,tiltShiftRadialButton, nil] autorelease];;
    
    if (buttonTag == FLASHTAG || buttonTag == FLASHOFFTAG || buttonTag == FLASHAUTOTAG) {
        int flashNum = buttonTag - 5;
        [self.flashItem setImage:[flashImageArray objectAtIndex:flashNum] forState:UIControlStateNormal];
        [self.flashItem setImage:[flashFadeImageArray objectAtIndex:flashNum] forState:UIControlStateDisabled];
        [self.flashMenu setHidden:YES];
        if (self.statusMode == PHOTOMODE) {
            switch (buttonTag) {
                case FLASHTAG:
                    [self.captureManage setFlashMode:AVCaptureFlashModeOn];
                    break;
                case FLASHOFFTAG:
                    [self.captureManage setFlashMode:AVCaptureFlashModeOff];
                    break;
                case FLASHAUTOTAG:
                    [self.captureManage setFlashMode:AVCaptureFlashModeAuto];
                    break;
                default:
                    break;
            }
        } else {
            switch (buttonTag) {
                case FLASHTAG:
                    [self.captureManage setTorchMode:AVCaptureTorchModeOn];
                    break;
                case FLASHOFFTAG:
                    [self.captureManage setTorchMode:AVCaptureTorchModeOff];
                    break;
                case FLASHAUTOTAG:
                    [self.captureManage setTorchMode:AVCaptureTorchModeAuto];
                    break;
                default:
                    break;
            }
        }
        
        
        return;
    }
    if (buttonTag == TILTSHIFTTAG || buttonTag == TILTSHIFTHORIZONTAG 
        || buttonTag == TILTSHIFTRADIAL) {
        int tiltNum = buttonTag - 8;
        [self.tiltItem setImage:[tiltShiftImageArray objectAtIndex:tiltNum] forState:UIControlStateNormal];
        [self.tiltMenu setHidden:YES];
    }
    _isAdjust = false;
    CGSize sizeOfBB = CGSizeMake(PRIVIEW_OUTPUT_WIDTH, PRIVIEW_OUTPUT_HEIGHT);
    if(self.statusMode == STILLIMAGEMODE || self.statusMode == PHOTOEDITMODE)
    {
        sizeOfBB=[self getImageShowSize];
    }
    switch (buttonTag) {
        case TILTSHIFTTAG:
            [self.render clearTiltBlur];
            _tiltStatus = TILTSTATUSOFF;
            //if()
//            if(self.statusMode == PHOTOMODE || self.statusMode == STILLIMAGEMODE || self.statusMode == PHOTOEDITMODE)
            {
                [self performSimpleOpenGL:^{
                    float qRatio =[self.currentFilter getQualityPrefered:_renderBufferRatio Mode:[self hasExtraEffect]];
                    self.render.quality = qRatio;
                    [self.render setNewDimention:sizeOfBB.width*qRatio Height:sizeOfBB.height*qRatio preview:NO];
                }];
            }
//            [self renderImage:YES];
            _isTilt = true;
            [self showHelpView:SNS_INSTRUCTIONS_CAMERA_TILTSHIFT];
            break;
        case TILTSHIFTHORIZONTAG:
//            if(self.statusMode == PHOTOMODE || self.statusMode == STILLIMAGEMODE || self.statusMode == PHOTOEDITMODE)
            {
                float qRatio =[self.currentFilter getQualityPrefered:_renderBufferRatio Mode:YES];
                self.render.quality = qRatio;
                [self performSimpleOpenGL:^{
                    [self.render setNewDimention:sizeOfBB.width*qRatio Height:sizeOfBB.height*qRatio preview:NO];
                }];
            }
            _tiltStatus = TILTSTATUSHORIZON; 
            _isTilt = true;
            [self showHelpView:SNS_INSTRUCTIONS_CAMERA_TILTSHIFT];
            break;
        case TILTSHIFTRADIAL:
            _tiltStatus = TILTSTATUSRADIAL;
//            if(self.statusMode == PHOTOMODE || self.statusMode == STILLIMAGEMODE || self.statusMode == PHOTOEDITMODE)
            {
                float qRatio =[self.currentFilter getQualityPrefered:_renderBufferRatio Mode:YES];
                self.render.quality = qRatio;
                [self performSimpleOpenGL:^{
                    [self.render setNewDimention:sizeOfBB.width*qRatio Height:sizeOfBB.height*qRatio preview:NO];
                }];
            }
            _isTilt = true;
            [self showHelpView:SNS_INSTRUCTIONS_CAMERA_TILTSHIFT];
            break;
            
        default:
            break;
    }
    [self addAndManageGesture];
    [self transTiltAndAdjust:true];
    [self initialTilt];
    
}

-(void) btnClick : (id)sender
{
    UIButton *btn = (UIButton *) sender;
//    [btn setSelected:TRUE];
    switch (btn.tag) {
        case FLASHITEM:
        case TILTITEM:
        case SWAPITEM:
        case FILTERITEM:    
        case CANCELITEM:
        case ADJUSTITEM:
            [self toolBarItemClick:btn.tag];
            break;            
        case FLASHTAG:
        case FLASHOFFTAG:
        case FLASHAUTOTAG:
        case TILTSHIFTTAG:
        case TILTSHIFTHORIZONTAG:
        case TILTSHIFTRADIAL:
            [self dropDownClick:sender];
            break;
        case PHOTOTAG:
            [self photoClick];
            break;
        case IMPORTTAG:
            [self importClick];
            break;
        case SLIDETAG:
            [self photoSlideVideo];
            break;    
        case VIDEOSHOOT:
            [self startRecord];
            break;
        case VIDEORECORD:
            [self stopRecord];
            break;  
        case CANCELBTN:
            [self hidenConfirmView];
            break;
        case CONFIRMBTN:
            [self confirm];
            break;
        case PLAYBTN:
            [self playVideoForWriter];
            break;
        case PAUSEBTN:
            [self pauseVideoForWriter];
            break;
        case RESETBTN:  
            [self resetAction];
            break;
        case ADJUSTRESETBTN:
            [self adjustRestAction];
            break;
        default:
            break;
    }
}
-(void) adjustRestAction
{
    switch (_adjustMode) {
        case FloggerGestureRecognizerDirectionFirst:
            self.render.degreeContrastStandard=0;
            break;
        case FloggerGestureRecognizerDirectionSecond:
            self.render.degreeBrightnessStandard=0;
            break;
        case FloggerGestureRecognizerDirectionThird:
            self.render.degreeSaturationStandard=0;
            break;
        case FloggerGestureRecognizerDirectionFourth:
            self.render.degreeStrenthStandard=100;
            break;
    }
    if (self.statusMode == PHOTOEDITMODE || self.statusMode == STILLIMAGEMODE) {
        [self performSimpleOpenGL:^{
            [[self render] processImage];
        }];
    }
    [self updateAdjustType];
}

-(void) resetAction
{
//    NSLog(@"reset action");
    [self.render clearPostFilter];
    if (self.statusMode == PHOTOEDITMODE || self.statusMode == STILLIMAGEMODE) {
        [self performSimpleOpenGL:^{
            [[self render] processImage];
        }];
    }
    [self updateAdjustType];
    [self.resetBtn setHidden:YES];
}

//true is tilt
//false is adjust
-(void) transTiltAndAdjust : (BOOL) tiltOrAdjust
{
    //tiltMenu
    UIImage *tiltShiftIcon = [FloggerUtility thumbnailImage:FI_TILT_SHIFT];
    UIImage *tiltShiftRadialButton = [FloggerUtility thumbnailImage:FI_TILT_SHIFT_RADIAL];
    UIImage *tiltShiftHorizontalButton = [FloggerUtility thumbnailImage:FI_TILT_SHIFT_LINEAR];
    
    UIImage *tiltShiftButtonHighlighted = [FloggerUtility thumbnailImage:FI_TILT_SHIFT_HIGHLIGHTED];
    UIImage *tiltShiftRadialButtonHighlighted = [FloggerUtility thumbnailImage:FI_TILT_SHIFT_RADIAL_HIGHLIGHTED];
    UIImage *tiltShiftHorizontalButtonHighlighted = [FloggerUtility thumbnailImage:FI_TILT_SHIFT_LINEAR_HIGHLIGHTED];
    UIImage *adjustImage = [FloggerUtility thumbnailImage:FI_GRID]; 
    UIImage *adjustImageHighlight = [FloggerUtility thumbnailImage:FI_GRID_HIGHLIGHTED];
    
    if (tiltOrAdjust) {
        [self.adjustItem setImage:adjustImage forState:UIControlStateNormal];
//        [self.resetBtn setHidden:YES];
        if (_tiltStatus == TILTSTATUSOFF) {
            [self.tiltItem setImage:tiltShiftButtonHighlighted forState:UIControlStateNormal];
        } else if (_tiltStatus == TILTSTATUSRADIAL) {
            [self.tiltItem setImage:tiltShiftRadialButtonHighlighted forState:UIControlStateNormal];
        } else if (_tiltStatus == TILTSTATUSHORIZON) {
            [self.tiltItem setImage:tiltShiftHorizontalButtonHighlighted forState:UIControlStateNormal];
        }
    } else {
        [self.adjustItem setImage:adjustImageHighlight forState:UIControlStateNormal];
//        [self.resetBtn setHidden:NO];
        if (self.tiltItem.enabled) {
            if (_tiltStatus == TILTSTATUSOFF) {
                [self.tiltItem setImage:tiltShiftIcon forState:UIControlStateNormal];
            } else if (_tiltStatus == TILTSTATUSRADIAL) {
                [self.tiltItem setImage:tiltShiftRadialButton forState:UIControlStateNormal];
            } else if (_tiltStatus == TILTSTATUSHORIZON) {
                [self.tiltItem setImage:tiltShiftHorizontalButton forState:UIControlStateNormal];
            }
        }

    }
}

-(void) adjustItemClick
{
//    [self showHelpView:SNS_INSTRUCTIONS_CAMERA_ADJUSTMENTS];
    [self transTiltAndAdjust:false];
    if (self.adjustLayer.isHidden) {
        [self doubleTapView];
    } else {
        [self.adjustLayer setHidden:YES];
    }
}

//click item in toolbar
-(void) toolBarItemClick : (int) itemTag
{
    //flash and swap enable
    if ((itemTag == FLASHTAG) || (itemTag == SWAPITEM)) {
        if (([self statusMode] == PHOTOEDITMODE) || ([self statusMode] == VIDEOEDITMODE)) {
            return;
        }
    }
    //set default
    [self setHidenItemsDefault:itemTag];
    // handle with barbuttonitem
    switch (itemTag) {
        case FLASHITEM:
            [self.flashMenu setHidden:!self.flashMenu.isHidden];
            break; 
        case TILTITEM:
            [self.tiltMenu setHidden:!self.tiltMenu.isHidden];
                [self transTiltAndAdjust:true];
//            //hiden layer
//            [self.adjustLayer setHidden:YES];
//            [self.adjustTypeView setHidden:YES];
            break;   
        case SWAPITEM: 
//            [self.captureManage swapScreen];
            [self swapClick];
            break;     
        case FILTERITEM:
            [self filterClick];
            break;    
        case CANCELITEM:
            [self cancelClick];
            break;
        case ADJUSTITEM:
            [self adjustItemClick];
            break;
        default:
            break;
    }
}

- (void) buttonHighlighted:(id)sender
{
    //code here
    UIButton *btn = (UIButton *) sender;
//    [btn setHighlighted:YES];
//    [btn imageForState:UIControlStateHighlighted];
    [btn setImage:[btn imageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [btn setShowsTouchWhenHighlighted:YES]; 
    
}

-(UIButton *) setButtonProperty:(UIImage *) btnImage withHighlightImage: (UIImage *) btnHighlight withPoint: (CGPoint) point withButtonTag: (int) btnTag;
{
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempBtn setImage:btnImage forState:UIControlStateNormal];

//    if (btnTag) {
        tempBtn.tag = btnTag;
        [tempBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [tempBtn addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlStateHighlighted];
//    [button1 addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlStateHighlighted]
//    }
    CGRect tempBtnFrame ;
    if (btnHighlight) {
        [tempBtn setShowsTouchWhenHighlighted:YES];  
        [tempBtn setImage:btnHighlight forState:UIControlStateHighlighted];
              
        tempBtnFrame = CGRectMake(point.x, point.y, btnHighlight.size.width, btnHighlight.size.height);
    } else {
        tempBtnFrame = CGRectMake(point.x, point.y, btnImage.size.width, btnImage.size.height);
    }
    [tempBtn setFrame:tempBtnFrame];
    [tempBtn setBackgroundColor:[UIColor clearColor]];
    return tempBtn;
}

-(UIButton *) setButtonProperty:(UIImage *) btnImage withDisableImage: (UIImage *) btnDisable withPoint: (CGPoint) point withButtonTag: (int) btnTag;
{
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempBtn setImage:btnImage forState:UIControlStateNormal];
    
    //    if (btnTag) {
    tempBtn.tag = btnTag;
    [tempBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    }
    CGRect tempBtnFrame ;
    tempBtnFrame = CGRectMake(point.x, point.y, btnImage.size.width, btnImage.size.height);
//    NSLog(@"btnImage.size.width is %f",btnImage.size.width);
//     NSLog(@"btnImage.size.height is %f",btnImage.size.height);
//    if (btnDisable) {
//        [tempBtn setImage:btnDisable forState:UIControlStateHighlighted];
//        tempBtnFrame = CGRectMake(point.x, point.y, btnDisable.size.width, btnDisable.size.height);
//    } else {
//        tempBtnFrame = CGRectMake(point.x, point.y, btnImage.size.width, btnImage.size.height);
//    }
    [tempBtn setShowsTouchWhenHighlighted:YES];
    [tempBtn setFrame:tempBtnFrame];
    return tempBtn;
}


-(void) setHidenItemsDefault : (NSInteger) itemTag
{
    if (itemTag == FLASHITEM) {
        [[self tiltMenu] setHidden:YES];
//        [self.filterView setHidden:YES];
        _isFilterHidden = YES;
    } else if (itemTag == TILTITEM) {
        [[self flashMenu] setHidden:YES];
//        [[self filterView] setHidden:YES];
        _isFilterHidden = YES;
    } else if (itemTag == FILTERITEM) {
        [[self flashMenu] setHidden:YES];
        [[self tiltMenu] setHidden:YES];
    } else {
        [[self flashMenu] setHidden:YES];
        [[self tiltMenu] setHidden:YES];
//        [[self filterView] setHidden:YES];
        _isFilterHidden = YES;
    }
//    [self displayAdjustType];
    
    //hiden layer
    if (itemTag != ADJUSTITEM) {
        [self.adjustLayer setHidden:YES];
    }
    [self.adjustTypeView setHidden:YES];


}

-(void) hidenConfirmView
{
//    NSLog(@"cancel");
    [self switchStatusMode:PHOTOMODE];
//    if ([[self videoPlayerlayer] superlayer]) {
//        NSLog(@"superview");
//        [[self videoPlayerlayer] removeFromSuperlayer];
//    }
    [[[self captureManage] captureSession] startRunning];
//    [self.captureManage.captureSession setSessionPreset:AVCaptureSessionPresetMedium];
}

-(void) displayConfirmView
{
//    dispatch_queue_t queue = dispatch_queue_create("stopCaptureSession", NULL);
//    dispatch_async(queue, ^{
//        //stop session
//        [[[self captureManage] captureSession] stopRunning];
//        
//    });
//    dispatch_release(queue);
    self.bottmonView.hidden = YES;
//    [[self mediaView] setHidden:NO];
    [[self cameraConfirm] setHidden:NO];
    [[self confirmBtn] setHidden:NO];
    [[self cancelBtn] setHidden:NO];
//    [self toolBar]
//    [self mediaView] inser
}

//-(void) flashClick
//{
//    [[self flashMenu] setHidden:![[self flashMenu] isHidden]];
//}

//-(void) startBorderBtnChange:(id)sender{
//    
//    [self.render clearPostFilter];
//    [self.resetBtn setHidden:YES];
//    //    [self.render clearTiltBlur];
//    
//	UIButton *button = (UIButton*)sender;
//    NSInteger index = button.tag;
//    self.currentFilter = [self.filters objectAtIndex:index];
//    
//    [self performSimpleOpenGL:^{
//        if(_statusMode == RECORDINGMODE)
//        {
//            [[self render] installProgram:self.currentFilter.filter];
//        } else {
//            float tempRenderBufferRatio =[self.currentFilter getQualityPrefered:_renderBufferRatio Mode:[self hasExtraEffect]];
//            self.render.quality = tempRenderBufferRatio;
//            [self.render setupProgram:PRIVIEW_OUTPUT_WIDTH * tempRenderBufferRatio 
//                               Height:PRIVIEW_OUTPUT_HEIGHT * tempRenderBufferRatio Data:self.currentFilter.filter StringType:XML preview:NO];
//        }
//        //[[self render] installProgram:myJson];
//        if (([self statusMode] == PHOTOEDITMODE)
//            || ([self statusMode] == STILLIMAGEMODE))
//        {
//            [self.render processImage];
//        }
//        if (self.statusMode == VIDEOEDITMODE) {
//            if (self.videoThumbImage) {
//                [self.render processImage];
//            } else {
//                [self.render processImage:_videoOrientation];
//            }
//            
//        }
//    }];
//    //    [self.render registerBorderImage:<#(UIImage *)#> ]
//    //    if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE))
//    {
//        //        [self.render clearPostFilter];
//        //        _adjustArea = 0;
//        [self updateAdjustType];
//        
//    } 
//}
-(void) changeBorder : (id) sender
{
    UIButton *btn = (UIButton *) sender;
    NSInteger index = btn.tag;
    
    if (_borderHightIndex > 0) {
        UIButton *lastTimeBtn = (UIButton *) [self.middleView viewWithTag:_borderHightIndex];
        [lastTimeBtn setSelected:false];
    }
    UIButton *hightlightBtn = (UIButton *) [self.middleView viewWithTag:index + 2000];
    [hightlightBtn setSelected:YES];
    hightlightBtn.alpha=0.0;
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacityAnimation setDuration:0.35f];
    [opacityAnimation setRepeatCount:1.f];
    //        [opacityAnimation setAutoreverses:YES];
    [opacityAnimation setFromValue:[NSNumber numberWithFloat:0.f]];
    [opacityAnimation setToValue:[NSNumber numberWithFloat:1.f]];
    //        [opacityAnimation setAutoreverses: YES];
    opacityAnimation.fillMode = kCAFillModeBoth;
    [opacityAnimation setRemovedOnCompletion:NO];
    //        [opacityAnimation ]
    [hightlightBtn.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    
    _borderHightIndex = index + 2000;
    
    
    self.currentBorder = [self.borders objectAtIndex:index];
    
//    NSLog(@"self.currentBorder.title] is %@", self.currentBorder.title);
    if ([@"Normal" isEqualToString:self.currentBorder.name]) {
        [self.render clearBorderImage];
        
    } else {
        UIImage* borderImage = [self createTextureImageFromName:self.currentBorder.borderImageName];
        if(!borderImage)
        {
            self.currentBorder = nil;
        }
        [self performSimpleOpenGL:^{
            [self.render registerBorderImage:borderImage];
        }];
    }
    [self performSimpleOpenGL:^{
        
        if (([self statusMode] == PHOTOEDITMODE)
            || ([self statusMode] == STILLIMAGEMODE))
        {
            [self.render processImage];
        }
        if (self.statusMode == VIDEOEDITMODE) {
            if (self.videoThumbImage) {
                [self.render processImage];
            } else {
                [self.render processImage:_videoOrientation];
            }
            
        }
    }];
}

-(void) startBtnChange:(id)sender{
    
    [self.render clearPostFilter];
    [self.resetBtn setHidden:YES];
//    [self.render clearTiltBlur];
    
	UIButton *button = (UIButton*)sender;
    NSInteger index = button.tag;
    
    if (_filterHightIndex > 0) {
        UIButton *lastTimeBtn = (UIButton *) [self.middleView viewWithTag:_filterHightIndex];
        [lastTimeBtn setSelected:false];
    }
    UIButton *hightlightBtn = (UIButton *) [self.middleView viewWithTag:index + 1000];
    [hightlightBtn setSelected:YES];
    hightlightBtn.alpha=0.0;
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacityAnimation setDuration:0.35f];
    [opacityAnimation setRepeatCount:1.f];
    //        [opacityAnimation setAutoreverses:YES];
    [opacityAnimation setFromValue:[NSNumber numberWithFloat:0.f]];
    [opacityAnimation setToValue:[NSNumber numberWithFloat:1.f]];
    //        [opacityAnimation setAutoreverses: YES];
    opacityAnimation.fillMode = kCAFillModeBoth;
    [opacityAnimation setRemovedOnCompletion:NO];
    //        [opacityAnimation ]
    [hightlightBtn.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    
    _filterHightIndex = index + 1000;
    
    
    self.currentFilter = [self.filters objectAtIndex:index];

    [self performSimpleOpenGL:^{
        if(_statusMode == RECORDINGMODE)
        {
            [[self render] installProgram:self.currentFilter.filter];
        } else {
            float tempRenderBufferRatio =[self.currentFilter getQualityPrefered:_renderBufferRatio Mode:[self hasExtraEffect]];
            self.render.quality = tempRenderBufferRatio;
            CGSize sizeOfBB = CGSizeMake(PRIVIEW_OUTPUT_WIDTH, PRIVIEW_OUTPUT_HEIGHT);
            if(self.statusMode == STILLIMAGEMODE || self.statusMode == PHOTOEDITMODE)
            {
                sizeOfBB=[self getImageShowSize];
            }
            [self.render setupProgram:sizeOfBB.width * tempRenderBufferRatio 
                               Height:sizeOfBB.height * tempRenderBufferRatio Data:self.currentFilter.filter StringType:XML preview:NO];
//            if (self.borders) {
//                <#statements#>
//            }
        }
        //[[self render] installProgram:myJson];
        if (([self statusMode] == PHOTOEDITMODE)
            || ([self statusMode] == STILLIMAGEMODE))
        {
            [self.render processImage];
        }
        if (self.statusMode == VIDEOEDITMODE) {
            if (self.videoThumbImage) {
                [self.render processImage];
            } else {
                [self.render processImage:_videoOrientation];
            }
            
        }
    } withSync:YES];
//    [self.render registerBorderImage:<#(UIImage *)#> ]
//    if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE))
    {
//        [self.render clearPostFilter];
//        _adjustArea = 0;
        [self updateAdjustType];

    } 
}

//-(void) handleWithVideoFromAlbumBackup : (NSURL *) videoPathURL
//{
//    
////    if ([self videoPlayerlayer]) {
////        [[self videoPlayerlayer] removeFromSuperlayer];
////    }
//    //set up writer
//    
//    [[self writeManage] setupAssetWriter];
//    //input asset
//    AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:videoPathURL options:nil] autorelease];     
//    //construct an AVAssetReader
//    AVAssetReader *reader = [[[AVAssetReader alloc] initWithAsset:inputAsset error:nil] autorelease];
//    AVAssetReader *audioReader = [[[AVAssetReader alloc] initWithAsset:inputAsset error:nil] autorelease];
//    //Get video track from asset
//    NSArray *videoTracks = [inputAsset tracksWithMediaType:AVMediaTypeVideo];
//    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
//    [videoTrack nominalFrameRate];
////    [videoTrack ]
////    videoTrack
////    //set videoSize
////    _videoSize = [videoTrack naturalSize];
//    NSArray *audioTracks = [inputAsset tracksWithMediaType:AVMediaTypeAudio];
//    AVAssetTrack *audioTrack = [audioTracks objectAtIndex:0];
//    //set the desired frame format
//    NSMutableDictionary *videoOutputSettings = [NSMutableDictionary dictionary];
//    [videoOutputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
//    NSMutableDictionary* audioReadSettings = [NSMutableDictionary dictionary];
//    [audioReadSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM]
//                         forKey:AVFormatIDKey];
//    //contruct an actual output track 
//    AVAssetReaderTrackOutput *readerTrackOutput = [[[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:videoOutputSettings] autorelease];  
//    AVAssetReaderTrackOutput *audioReaderTrackOutput = [[[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:audioReadSettings] autorelease];
//    //add readertrack output in  asset reader
//    [reader addOutput:readerTrackOutput];
//    [audioReader addOutput:audioReaderTrackOutput];
//    //kick off the asset 
//    [reader startReading];
//    [audioReader startReading];
//    //kick off the videowriter input
//    [[[self writeManage] assetWriter] startWriting];
//    [[[self writeManage] assetWriter] startSessionAtSourceTime:kCMTimeZero];
//    
//    //write video
//    dispatch_queue_t readAndWriteQueue = dispatch_queue_create("readAndWriteQueue", NULL);
//    //
//    [self.render setNeedOnlyRawData:YES];
//    [self.render setGlMode:OFFSCREEN_MODE];
//    //write audio
//    [[[self writeManage] audioAssetWriterInput] requestMediaDataWhenReadyOnQueue:readAndWriteQueue usingBlock:^{
//        while ([[[self writeManage] audioAssetWriterInput] isReadyForMoreMediaData]) {
//            
//            CMSampleBufferRef nextImageBuffer = [audioReaderTrackOutput copyNextSampleBuffer];
//            if (nextImageBuffer) {
//                [[[self writeManage] audioAssetWriterInput] appendSampleBuffer:nextImageBuffer];
//                CFRelease(nextImageBuffer);
//            } else {
//                [[[self writeManage] audioAssetWriterInput] markAsFinished];
//                [audioReader cancelReading];
//                break;
//            }
//            
//        }
//    }];
//    //write video
//    [[[self writeManage] videoAssetWriterInput] requestMediaDataWhenReadyOnQueue:readAndWriteQueue usingBlock:^{
//        while ([[[self writeManage] videoAssetWriterInput] isReadyForMoreMediaData]) {
////            NSLog(@"=======video edit======");
//            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//            CMSampleBufferRef nextImageBuffer = [readerTrackOutput copyNextSampleBuffer];
//            if (nextImageBuffer) {
//                CVImageBufferRef cvImageBuffer = CMSampleBufferGetImageBuffer(nextImageBuffer);
//                 CVPixelBufferLockBaseAddress(cvImageBuffer,0);
//                [self performSimpleOpenGL:^{
//                   
//                    [self.render setupTextureWithCameraFrame:cvImageBuffer];
//                    
//                    CMTime presentTime = CMSampleBufferGetPresentationTimeStamp(nextImageBuffer);
//                    [self.render render:self.originalImage.imageOrientation willKeepTexture:YES];
//                    /*CVPixelBufferRef newBuffer = NULL;
//                    CVPixelBufferCreateWithBytes(NULL, self.render.openGL.width, self.render.openGL.height, kCVPixelFormatType_32ARGB, self.render.resultData, 4*self.render.openGL.width, NULL, 0, NULL, &newBuffer);*/
//                    while ( ![[self writeManage] videoAssetWriterInput].readyForMoreMediaData)
//                    {
//                        [NSThread sleepForTimeInterval:0.001];
//                    }
//                    if (![[[self writeManage] inputBufferAdaptor] appendPixelBuffer:self.render.resultData withPresentationTime:presentTime])
//                    {
////                        NSLog(@"Unable to write to video input");
//                    }
//                    
//                }];
//                CVPixelBufferUnlockBaseAddress(cvImageBuffer, 0);
//                CFRelease(nextImageBuffer);
//                
//            } else {
//                [[[self writeManage] videoAssetWriterInput] markAsFinished];
//                //                NSLog(@"====videocount is %d",_count);
//                [reader cancelReading];
////                                NSLog(@"video finish=========");
//                [[[self writeManage] assetWriter] finishWriting];
////                UISaveVideoAtPathToSavedPhotosAlbum([[[[self writeManage] assetWriter] outputURL] path], nil, nil, nil);
//                break;
//            }
//            [pool drain];
//        }
//    }];
//    
//    dispatch_release(readAndWriteQueue);
//}

-(void) handleWithVideoFromAlbum : (NSURL *) videoPathURL
{
//    NSLog(@"[UIDevice currentDevice] model] is %@",[[UIDevice currentDevice] model]);
    if ([[[UIDevice currentDevice] model] isEqualToString: @"iPod touch"]) {
        self.render.usingIOS5 =NO;
    }
//    if ([[UIDevice currentDevice] model].) {
//        <#statements#>
//    }
    //input asset
    AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:videoPathURL options:nil] autorelease];     
    //construct an AVAssetReader
    AVAssetReader *reader = [[[AVAssetReader alloc] initWithAsset:inputAsset error:nil] autorelease];
    //Get video track from asset
    NSArray *videoTracks = [inputAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    //set the desired frame format
//    videoTrack.nominalFrameRate;
//    NSLog(@"====videoTrack.nominalFrameRate is %f",videoTrack.nominalFrameRate);
    float frameRate = videoTrack.nominalFrameRate;
//    NSLog(@"===videotrack time is %lld",videoTrack.timeRange.duration.value / videoTrack.timeRange.duration.timescale);
    double assetSecond = inputAsset.duration.value / inputAsset.duration.timescale;
//    NSLog(@"====inputurl is %lld",inputAsset.duration.value / inputAsset.duration.timescale);
    
    NSMutableDictionary *videoOutputSettings = [NSMutableDictionary dictionary];
    [videoOutputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
    //contruct an actual output track 
    AVAssetReaderTrackOutput *readerTrackOutput = [[[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:videoOutputSettings] autorelease];  
    //add readertrack output in  asset reader
    [reader addOutput:readerTrackOutput];
    
    [self setVideoReader:reader];
    CMTime startTime = CMTimeMake(self.timeSlider.value * videoTrack.timeRange.duration.timescale , videoTrack.timeRange.duration.timescale);
    reader.timeRange = CMTimeRangeMake(startTime, videoTrack.timeRange.duration);
    
    if(iscanceled)
    {
        return;
    }
    //kick off the asset 
    @synchronized(self) {
//        NSLog(@"startreading");
        [reader startReading];
    }
    if(iscanceled)
    {
        return;
    }
    //
//    NSLog(@"rending");
//    [self.render setNeedOnlyRawData:YES];
//     NSLog(@"glmode");
//    [self.render setGlMode:OFFSCREEN_MODE];
    int test = 0;
    int frame = self.timeSlider.value * frameRate;
//    NSValue 
    
    
    [self.cancelBtn setEnabled:NO];
    while (reader.status == AVAssetReaderStatusReading){
//        [self performSimpleOpenGL:^{}]; 
        {
            @synchronized(self) {
                if (reader.status != AVAssetReaderStatusReading) {
                    return;
                }
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                CMSampleBufferRef nextImageBuffer = [readerTrackOutput copyNextSampleBuffer];
//                NSLog(@"===test is %d",test);
//                NSLog(@"====frame == is %d",frame);
//                if (frame <= test)
                {
                    if (nextImageBuffer){
                        CVImageBufferRef cvImageBuffer = CMSampleBufferGetImageBuffer(nextImageBuffer);
                        CVPixelBufferLockBaseAddress(cvImageBuffer,0);
                        
                        [self performSimpleOpenGL:^{
                            [self.render setupTextureWithCameraFrame:cvImageBuffer];
                            [self.render render:_videoOrientation willKeepTexture:YES];
                        }];
                        CVPixelBufferUnlockBaseAddress(cvImageBuffer, 0);
                        //            CMSampleBufferInvalidate(nextImageBuffer);
                        CFRelease(nextImageBuffer);
                    }
                             [pool drain];
                    //timeslide
                    dispatch_async(dispatch_get_main_queue(), ^{
                        float minValue = [self.timeSlider minimumValue];
                        float maxValue = [self.timeSlider maximumValue];
                        //        (maxValue - minValue) * time / duration + minValue
                        int currentFrame = frame + test;
                        [self.timeSlider setValue: (maxValue - minValue) *(currentFrame / (frameRate * assetSecond)) + minValue animated:NO]; 
                    });
                } 
                test++;
//                [pool drain];
            }

        };

    }
//    NSLog(@"frame is %d",test);
//    NSLog(@"finish===");
    [self.cancelBtn setEnabled:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!iscanceled)
        {
            [self.timeSlider setValue:0.0];
        }        
        [self.playBtn setHidden:NO];        
    });
//    [self.playBtn setHidden:NO];
//    [self.playBtn setNeedsDisplay];
    
}


-(void) setTextureImage:(NSMutableArray *)imageArray
{
    for (UIImage* image in imageArray) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
    };
    
}


-(void) InitializeDefaultButtons
{    
    UIScrollView *scrollView = [self scrollView];
    for (UIView *view in scrollView.subviews) {
        [view removeFromSuperview];        
    }
    UIImage *filterIcon = [FloggerUtility thumbnailImage:FI_FILTER_ICON];
    UIImage *filterIconHighlight = [FloggerUtility thumbnailImage:FI_CAMERA_FILTER_HIGHLIGHT];
    self.filters = [[[FloggerFilterAdapter sharedInstance]createFilterList]autorelease];
    //    }
    int btnWidth = filterIcon.size.width;
    int btnHeigh = filterIcon.size.height;
    
//    NSArray *filterIconName = [NSArray arrayWithObjects:FI_FILTER_ICON,SNS_FILTER_DAWN,SNS_FILTER_WINTER,SNS_FILTER_NOSTALGIA,SNS_FILTER_FLOMO,SNS_FILTER_SWEET,SNS_FILTER_SEA,SNS_FILTER_MONO,SNS_FILTER_OUTBACK,SNS_FILTER_RETRO,SNS_FILTER_METAL,SNS_FILTER_ORIGIN,SNS_FILTER_CROSS,SNS_FILTER_SEPIA,SNS_FILTER_CHILL,SNS_FILTER_VINTAGE,SNS_FILTER_COAL,SNS_FILTER_COMIC,SNS_FILTER_NOIR,SNS_FILTER_COMIC2, nil];
    
    
    for (int i = 0; i < filters.count; i++) {
//        filterIcon = [FloggerUtility thumbnailImage:[filterIconName objectAtIndex:i]];
        FilterProperty *filter =  [filters objectAtIndex:i];
        CGRect btnRect = CGRectMake(9*(1 + i) + i * btnWidth, 8, btnWidth, btnHeigh);
        CGRect hightlightRect = CGRectMake(btnRect.origin.x - 12, btnRect.origin.y -9, filterIconHighlight.size.width, filterIconHighlight.size.height);
        UIButton *hightlightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [hightlightBtn setBackgroundImage:filterIconHighlight forState:UIControlStateSelected];
        [hightlightBtn setBackgroundImage:filterIconHighlight forState:UIControlStateHighlighted];
        hightlightBtn.userInteractionEnabled = NO;
        hightlightBtn.frame = hightlightRect;
        hightlightBtn.tag = 1000 + i;
        
        CGRect labelRect = CGRectMake(0, 2*btnHeigh/3+9, btnHeigh, btnHeigh/3);
        
        UILabel *tempLabel = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
        tempLabel.font = [UIFont boldSystemFontOfSize:12];
        tempLabel.textColor = [UIColor whiteColor];

        [tempLabel setText:filter.title];
        [tempLabel setTextAlignment :UITextAlignmentCenter];
        //[tempLabel setUserInteractionEnabled:NO];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        tempLabel.shadowOffset = CGSizeMake(0, -1);
        tempLabel.shadowColor = [UIColor blackColor];
//        tempLabel.layer.borderWidth = 1;
//        tempLabel.layer.borderColor =[UIColor redColor].CGColor;
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.frame = btnRect;
//        [tempBtn setImage:filterIcon forState:UIControlStateNormal];
        [tempBtn setBackgroundImage:filter.icon forState:UIControlStateNormal];
        tempBtn.tag = i;
        
//        tempBtn.titleLabel.text = filter.title;
//        tempBtn.titleLabel.textAlignment = UITextAlignmentCenter;
//        tempBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//        tempBtn.titleLabel.textColor = [UIColor whiteColor];
//        tempBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
//        tempBtn.titleLabel.shadowColor = [UIColor blackColor];
//        tempBtn.titleLabel.layer.shadowOpacity = 1.0;
//        tempBtn.titleLabel.layer.shadowRadius = 0.0;
//        tempBtn.titleEdgeInsets = UIEdgeInsetsMake(2*btnHeigh/3+19, 0, 0, 0);
//        tempBtn.contentScaleFactor = 2;
//        tempBtn.alpha = 1.0;
        
//        [tempBtn setTitle:filter.title forState:UIControlStateNormal];
        [tempBtn addTarget:self action:@selector(startBtnChange:) forControlEvents:UIControlEventTouchDown];
        //tempBtn.showsTouchWhenHighlighted = YES;
        [tempBtn addSubview:tempLabel];
        tempLabel.userInteractionEnabled = NO;
//        tempBtn.titleLabel = tempLabel;

        
        
        
        [scrollView addSubview:hightlightBtn];
        [scrollView addSubview:tempBtn];
    }
    CGSize tempScrollViewContentSize = CGSizeMake(9*(1 + filters.count) + filters.count * btnWidth, 78);
    [scrollView setContentSize:tempScrollViewContentSize];
    [scrollView setCanCancelContentTouches: NO];
    
    [self.scrollView setHidden:NO];
    
    //border button

    UIButton *filterButton = self.borderBtn;
//    filterButton setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>
//    filterButton.backgroundColor = [UIColor blueColor];
    
    filterButton.hidden = NO;
    filterButton.frame = CGRectMake(filterButton.frame.origin.x, filterButton.frame.origin.y, btnWidth, btnHeigh);
    [filterButton addTarget:self action:@selector(borderToggleAction:) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = CGRectMake(-1, 2*btnHeigh/3+3, btnWidth+2, btnHeigh/3);
    
    UILabel *tempLabel = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
    tempLabel.font = [UIFont boldSystemFontOfSize:12];
    tempLabel.textColor = [UIColor whiteColor];
    
    [tempLabel setText:NSLocalizedString(@"Borders", @"Borders")];
    [tempLabel setTextAlignment :UITextAlignmentCenter];
    [tempLabel setUserInteractionEnabled:NO];
    tempLabel.backgroundColor = [UIColor clearColor];
    
    tempLabel.shadowOffset = CGSizeMake(0, -1);
    tempLabel.shadowColor = [UIColor clearColor];
    [filterButton addSubview:tempLabel];
    
    UIImage *borderImage = [[FloggerUIFactory uiFactory] createImage:FI_CAMERA_BORDER_TOGGLE];
    UIImageView *borderImageV = [[FloggerUIFactory uiFactory] createImageView:borderImage];
    borderImageV.userInteractionEnabled = NO;
//    borderImageV.backgroundColor = [UIColor orangeColor];
    borderImageV.frame = CGRectMake(16, 11, borderImage.size.width, borderImage.size.height);
    [filterButton addSubview:borderImageV];
    
    //border set
    [self InitializeDefaultBorderButtons];
}


-(void) InitializeDefaultBorderButtons
{    
    UIScrollView *scrollView = [self borderScrollView];
    for (UIView *view in scrollView.subviews) {
        [view removeFromSuperview];        
    }
//    [scrollView scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
    UIImage *filterIcon = [FloggerUtility thumbnailImage:FI_FILTER_ICON];
    UIImage *filterIconHighlight = [FloggerUtility thumbnailImage:FI_CAMERA_FILTER_HIGHLIGHT];
    self.borders = [[[FloggerFilterAdapter sharedInstance] createBorderList] autorelease];
    //    }
    int btnWidth = filterIcon.size.width;
    int btnHeigh = filterIcon.size.height;
    
    for (int i = 0; i < borders.count; i++) {
        FilterProperty *filter =  [borders objectAtIndex:i];
        CGRect btnRect = CGRectMake(9*(1 + i) + i * btnWidth, 8, btnWidth, btnHeigh);
        CGRect labelRect = CGRectMake(-1, 2*btnHeigh/3+9, btnWidth + 2, btnHeigh/3);
        
        CGRect hightlightRect = CGRectMake(btnRect.origin.x - 12, btnRect.origin.y -9, filterIconHighlight.size.width, filterIconHighlight.size.height);
        UIButton *hightlightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [hightlightBtn setBackgroundImage:filterIconHighlight forState:UIControlStateSelected];
        [hightlightBtn setBackgroundImage:filterIconHighlight forState:UIControlStateHighlighted];
        hightlightBtn.frame = hightlightRect;
        hightlightBtn.tag = 2000 + i;
        
        UILabel *tempLabel = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
        tempLabel.font = [UIFont boldSystemFontOfSize:12];
        tempLabel.textColor = [UIColor whiteColor];
        
        [tempLabel setText:filter.title];
        [tempLabel setTextAlignment :UITextAlignmentCenter];
        [tempLabel setUserInteractionEnabled:NO];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        tempLabel.shadowOffset = CGSizeMake(0, -1);
        tempLabel.shadowColor = [UIColor blackColor];
        
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.frame = btnRect;
        [tempBtn setImage:filter.icon forState:UIControlStateNormal];
        tempBtn.tag = i;
        [tempBtn setTitle:filter.title forState:UIControlStateNormal];
        [tempBtn addTarget:self action:@selector(changeBorder:) forControlEvents:UIControlEventTouchUpInside];
        
        tempBtn.showsTouchWhenHighlighted = YES;
        [tempBtn addSubview:tempLabel];
        
        [scrollView addSubview:hightlightBtn];
        [scrollView addSubview:tempBtn];
    }
    CGSize tempScrollViewContentSize = CGSizeMake(9*(1 + borders.count) + borders.count * btnWidth, 78);
    [scrollView setContentSize:tempScrollViewContentSize];
    [scrollView setCanCancelContentTouches: NO];

    [self.borderScrollView setHidden:YES];
    //test
    //    [self.render ]
    UIButton *filterButton = self.filterBtn;//self.borderBtn;
    
//    filterButton.backgroundColor = [UIColor grayColor];
    
    filterButton.hidden = YES;
    filterButton.frame = CGRectMake(filterButton.frame.origin.x, filterButton.frame.origin.y, btnWidth, btnHeigh);
    [filterButton addTarget:self action:@selector(borderToggleAction:) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = CGRectMake(0, 2*btnHeigh/3+3, btnHeigh, btnHeigh/3);
    
    UILabel *tempLabel = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
    tempLabel.font = [UIFont boldSystemFontOfSize:12];
    tempLabel.textColor = [UIColor whiteColor];
    
    [tempLabel setText:NSLocalizedString(@"Filters", @"Filters")];
    [tempLabel setTextAlignment :UITextAlignmentCenter];
    [tempLabel setUserInteractionEnabled:NO];
    tempLabel.backgroundColor = [UIColor clearColor];
    
    tempLabel.shadowOffset = CGSizeMake(0, -1);
    tempLabel.shadowColor = [UIColor clearColor];
    [filterButton addSubview:tempLabel];
    
    UIImage *borderImage = [[FloggerUIFactory uiFactory] createImage:FI_CAMERA_FILTERS_TOGGLE];
    UIImageView *borderImageV = [[FloggerUIFactory uiFactory] createImageView:borderImage];
    borderImageV.frame = CGRectMake(16, 11, borderImage.size.width, borderImage.size.height);
    borderImageV.userInteractionEnabled = NO;
//    borderImageV.backgroundColor = [UIColor redColor];
    [filterButton addSubview:borderImageV];
    
    [filterButton setHidden:YES];
    
}



//FloggerServerDelegate method
-(void) setFilterButtonFromServer : (NSMutableDictionary *) filterDic
{    
//    //test
//    UIImage *cameraIconBackgroundBar = [FloggerUtility thumbnailImage:FI_FILTER_BAR];//= [FloggerUtility thumbnailImage:@"Camera_Icon_Background_Bar.png"];
//    UIImageView *backGroundView = [[[UIImageView alloc] initWithImage:cameraIconBackgroundBar] autorelease];
    //test
    UIScrollView *scrollView = [self scrollView];//[[[UIScrollView alloc] init] autorelease];
//    [scrollView addSubview:backGroundView];
    UIImage *filterIcon = [FloggerUtility thumbnailImage:FI_FILTER_ICON];
    //filter
//    NSMutableArray *nameArray = nil;
//    if (self.serverManage.finishLoad) {
        NSMutableArray *nameArray = [filterDic objectForKey:@"nameList"];
//    }
    int btnWidth = filterIcon.size.width;
    int btnWeigh = filterIcon.size.height;
    
    for (int i = 0; i < nameArray.count; i++) {
        CGRect btnRect = CGRectMake(9*(1 + i) + i * btnWidth, 8, btnWidth, btnWeigh);
        CGRect labelRect = CGRectMake(0, 2*btnWeigh/3, btnWeigh, btnWeigh/3);
        
        UILabel *tempLabel = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
        [tempLabel setText:[nameArray objectAtIndex:i]];
        [tempLabel setTextAlignment :UITextAlignmentCenter];
        [tempLabel setUserInteractionEnabled:NO];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.frame = btnRect;
        [tempBtn setImage:filterIcon forState:UIControlStateNormal];
        tempBtn.tag = 100 + i;
        [tempBtn setTitle:[nameArray objectAtIndex:i] forState:UIControlStateNormal];
        [tempBtn addTarget:self action:@selector(startBtnChange:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.showsTouchWhenHighlighted = YES;
        [tempBtn addSubview:tempLabel];
        [scrollView addSubview:tempBtn];
    }
    CGSize tempScrollViewContentSize = CGSizeMake(9*(1 + nameArray.count) + nameArray.count * btnWidth, 78);
    [scrollView setContentSize:tempScrollViewContentSize];
    [scrollView setCanCancelContentTouches: NO];
    [self setFilterDic:filterDic];
    
    [self.scrollView setHidden:NO];
    //test
//    [self.render ]
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

-(void) displayAdjustType
{
    int middleHigh = 323;
    
    UIImageView *upImageV = (UIImageView *) [self.filterItem viewWithTag:51];
    UIImageView *downImageV = (UIImageView *) [self.filterItem viewWithTag:52];
    
    UIView *adjustMiddleView = self.middleView;
    
    CGRect adjustMiddleViewRect;
    if (_isFilterHidden) {
        adjustMiddleViewRect = CGRectMake(adjustMiddleView.frame.origin.x, middleHigh + 76, adjustMiddleView.frame.size.width, adjustMiddleView.frame.size.height);

        [upImageV setHidden:NO];
        [downImageV setHidden:YES];
    } else {
        
        adjustMiddleViewRect = CGRectMake(adjustMiddleView.frame.origin.x, middleHigh, adjustMiddleView.frame.size.width, adjustMiddleView.frame.size.height);
        
        [upImageV setHidden:YES];
        [downImageV setHidden:NO];
    }
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [adjustMiddleView setFrame:adjustMiddleViewRect];
    [UIView commitAnimations];
    
}

-(void) filterClick
{
//    [UIView beg]

    
    /*if (_isFilterHidden) {
        
        [UIView beginAnimations:nil context:nil];
        
//        [self.filterView setHidden:NO];
//        _isFilterHidden = false;
        CATransition *animation = [CATransition animation];
        //animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        [self.middleView.layer addAnimation:animation forKey:@"animation"];
        
//        CATransition *animationItem = [CATransition animation];
//        //animation.delegate = self;
//        animationItem.duration = 0.1f;
//        animationItem.timingFunction = UIViewAnimationCurveEaseInOut;
//        animationItem.fillMode = kCAFillModeForwards;
//        animationItem.type = kCATransitionPush;
//        animationItem.subtype = kCATransitionFromTop;
//        [self.filterItem.layer addAnimation:animationItem forKey:@"filterAnimation"];
    } else {
        
        CATransition *animation = [CATransition animation];
        //animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeRemoved;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [self.middleView.layer addAnimation:animation forKey:@"animation"];
        
//        CATransition *animationItem = [CATransition animation];
//        //animation.delegate = self;
//        animationItem.duration = 0.1f;
//        animationItem.timingFunction = UIViewAnimationCurveEaseInOut;
//        animationItem.fillMode = kCAFillModeRemoved;
//        animationItem.type = kCATransitionPush;
//        animationItem.subtype = kCATransitionFromBottom;
//        [self.filterItem.layer addAnimation:animationItem forKey:@"filterAnimation"];
//        [self.filterView setHidden:YES];
//        _isFilterHidden = true;
    }
    _isFilterHidden = !_isFilterHidden;*/
    _isFilterHidden = !_isFilterHidden;
    [self.filterView setHidden:NO];
    
    [self displayAdjustType];


}

//-(void) tiltClick
//{
//    [[self tiltMenu] setHidden:![[self tiltMenu] isHidden]];
//    
//}

-(void) swapClick
{
    [[self captureManage] swapScreen];
    
    dispatch_async(dispatch_get_main_queue(), 
                   ^{
                       if (self.captureManage.videoInput.device.position == AVCaptureDevicePositionBack)
                       {
                           [self.flashItem setEnabled:YES];
                           _swapStatus = 0;
                       } else {
                           [self.flashItem setEnabled:NO];
                           _swapStatus = 1;
                       }
                });
}

-(void) cancelClick
{
//    avcapturesession'
    
//    AVCaptureAudioDataOutput *audioOutput = self.captureManage.audioCaptureOutput;
//    [session beginConfiguration];
//    [session removeOutput:audioOutput];
//    [session commitConfiguration];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        AVCaptureSession *session = self.captureManage.captureSession;
//        [session beginConfiguration];
//        [session setSessionPreset:AVCaptureSessionPresetPhoto];
//        [session commitConfiguration];
//    });

    //    self.captureManage.captureSession
    
//    [self.captureManage.captureSession removeOutput:self.captureManage.audioCaptureOutput];
//    dispatch_async(dispatch_get_main_queue(), ^{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        if (self.delegate) {
            [self.delegate floggerCameraControlDidCancelledPickingMedia:self];
        } else {
            
            [self dismissModalViewControllerAnimated:YES];
        }
        
//    });



}

-(void) photoClick
{
//    [self.isIrisView closeIris];
//    NSLog(@"====photo click=====");
//    @synchronized (self)
//    {
//    [self setStatusMode:STILLIMAGEMODE]; 
//    }
    [self.captureManage captureStillImageReturnData];    
//    [self.isIrisView performSelectorOnMainThread:@selector(shutterIris) withObject:nil waitUntilDone:YES];

//    [self.isIrisView performSelector:@selector(openIris) withObject:nil afterDelay:1];
    
}



-(void) transformVideo
{
//    fefe
    OpenGLRenderCenter *backgroundRender = [[[OpenGLRenderCenter alloc] init] autorelease];
//    backgroundRender

    if (self.currentFilter) {
//        GLfloat quality = [self.currentFilter getQualityPrefered:_renderBufferRatio Mode:[self hasExtraEffect]];
//        backgroundRender.quality = quality;
        [backgroundRender setupProgram:PRIVIEW_OUTPUT_WIDTH 
                      Height:PRIVIEW_OUTPUT_HEIGHT Data:self.currentFilter.filter StringType:XML preview:NO];
    } 
//    else 
//    {
//        //TODO 
//        NSString *commonPath = [[NSBundle mainBundle] pathForResource:@"normal" ofType:@"xml"]; 
//        NSString *normalXml= [NSString stringWithContentsOfFile:commonPath encoding:NSUTF8StringEncoding error:NULL];
//        [backgroundRender setupProgram:PRIVIEW_OUTPUT_WIDTH 
//                                Height:PRIVIEW_OUTPUT_HEIGHT Data:normalXml StringType:XML preview:NO];
//    }
        
    [backgroundRender setNeedOnlyRawData:YES];
    //set mode
    [backgroundRender setGlMode:OFFSCREEN_MODE];
    
   
    
    [self setBackgroundRender:backgroundRender];
//    self.backgroundRender = self.render;
    UIInterfaceOrientation currentOrient = [[UIDevice currentDevice] orientation];
    if (_isAccessLock) {
        currentOrient = deviceOrientation;
    }
    
    [[self writeManage] setupAssetWriter:currentOrient];
    //input asset
    AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:self.videoURL options:nil] autorelease]; 
    
    
    //construct an AVAssetReader
    

    //Get video track from asset
    NSArray *videoTracks = [inputAsset tracksWithMediaType:AVMediaTypeVideo];
//    if ([videoTracks count] > 0) {
        AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
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
    if ([audioTracks count] > 0) 
    {
        AVAssetTrack *audioTrack = [audioTracks objectAtIndex:0];
        AVAssetReader *audioReader = [[[AVAssetReader alloc] initWithAsset:inputAsset error:nil] autorelease];
        NSMutableDictionary* audioReadSettings = [NSMutableDictionary dictionary];
        [audioReadSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM]
                             forKey:AVFormatIDKey];
        AVAssetReaderTrackOutput *audioReaderTrackOutput = [[[AVAssetReaderTrackOutput alloc] initWithTrack:audioTrack outputSettings:audioReadSettings] autorelease];
        [audioReader addOutput:audioReaderTrackOutput];
            [audioReader startReading];
    }
    
    
    [[[self writeManage] assetWriter] startWriting];
    [[[self writeManage] assetWriter] startSessionAtSourceTime:kCMTimeZero];
    //
    [self.backgroundRender setNeedOnlyRawData:YES];
    [self.backgroundRender setGlMode:OFFSCREEN_MODE];
        
    //
    //write audio
     //write video
     dispatch_queue_t readAndWriteQueue = dispatch_queue_create("backgroundReadAndWriteQueue", NULL);
    
//    cmbu
    __block int finishCount = 1;
    self.backgroundRender.usingIOS5 = NO;
    self.backgroundRender.quality = 1;
    
    /*[[[self writeManage] audioAssetWriterInput] requestMediaDataWhenReadyOnQueue:readAndWriteQueue usingBlock:^{
        while ([[[self writeManage] audioAssetWriterInput] isReadyForMoreMediaData]) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            CMSampleBufferRef nextImageBuffer = [audioReaderTrackOutput copyNextSampleBuffer];
            if (nextImageBuffer) {
                [[[self writeManage] audioAssetWriterInput] appendSampleBuffer:nextImageBuffer];
                CFRelease(nextImageBuffer);
            } else {
                NSLog(@"audio finish");
                [[[self writeManage] audioAssetWriterInput] markAsFinished];
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
    }];*/
    //write video
    self.backgroundRender.usingIOS5 = NO;
    [[[self writeManage] videoAssetWriterInput] requestMediaDataWhenReadyOnQueue:readAndWriteQueue usingBlock:^{
        while ([[[self writeManage] videoAssetWriterInput] isReadyForMoreMediaData]) {
//            NSLog(@"=======video edit======");
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            CMSampleBufferRef nextImageBuffer = [readerTrackOutput copyNextSampleBuffer];
            if (nextImageBuffer) {
                CVImageBufferRef cvImageBuffer = CMSampleBufferGetImageBuffer(nextImageBuffer);
                CMTime presentTime = CMSampleBufferGetPresentationTimeStamp(nextImageBuffer);
                CVPixelBufferLockBaseAddress(cvImageBuffer,0);
//                static int ii=0;
                dispatch_sync(dispatch_get_main_queue(), ^{
//                                NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
                    //if(!ii) 
                    {
                    [self.backgroundRender setupTextureWithCameraFrame:cvImageBuffer];
                    [self.backgroundRender render:_videoOrientation willKeepTexture:NO];
                      //  ii++;
                    }
//                                    [pool2 drain];
                });
                while ( ![[self writeManage] videoAssetWriterInput].readyForMoreMediaData)
                {
                    [NSThread sleepForTimeInterval:0.001];
                }
                
                if([self.backgroundRender supportIOS5]) {
                    if (![[[self writeManage] inputBufferAdaptor] appendPixelBuffer:self.backgroundRender.resultData withPresentationTime:presentTime])
                    {
//                        NSLog(@"Unable to write to video input");
                    } 
                } else {
                    CVPixelBufferRef newBuffer = NULL;
                    CVPixelBufferCreateWithBytes(NULL, self.backgroundRender.openGL.width, self.backgroundRender.openGL.height, kCVPixelFormatType_32ARGB, self.backgroundRender.resultData, 4*self.backgroundRender.openGL.width, NULL, 0, NULL, &newBuffer);            
                    
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
    }];
    
    dispatch_release(readAndWriteQueue);    
}

-(void) writerFileFinish
{
    [self setBackgroundRender:nil];
//    NSLog(@"video finish=========");
    [[[self writeManage] assetWriter] finishWriting];
    UISaveVideoAtPathToSavedPhotosAlbum([[[[self writeManage] assetWriter] outputURL] path], nil, nil, nil);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"test" 
                                                       message:@"Finish"
                                                      delegate:self 
                                             cancelButtonTitle:@"ok" 
                                             otherButtonTitles:nil];
        [alert show];
        [alert release];
    });

}
static int tempNum = 0;

-(NSString *) saveDataToPath : (NSString *) mediaType withData : (NSData *) mediaData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *rootPath = [FloggerServerManage getMediaSavePath];
    if ([mediaType isEqualToString:@"image"]) {        
        NSString *imageFileName = @"tempImage.jpg";//[[[NSString alloc] initWithFormat:@"%@%@",@"IMG_",tempNum,@".jpg"] autorelease];
        NSString *imageFullFileName = [rootPath stringByAppendingPathComponent:imageFileName];
//        NSLog(@"imageFullFileName is %@",imageFullFileName);
        [fileManager createFileAtPath:imageFullFileName contents:mediaData attributes:nil];
        return imageFullFileName;
        
    } else if ([mediaType isEqualToString:@"video"]){
        //        NSString *videoFileName = [[NSString alloc] initWithFormat:@"%@%@%d%@",[FloggerServerManage getMediaSavePath],@"MOV_",tempNum,@".mov"];
        //        NSLog(@"videoFileName is %@",videoFileName);
        //        [fileManager createFileAtPath:videoFileName contents:mediaData attributes:nil];
    }
    tempNum++;    
    return @"";
}


-(void) saveDataToTempPath : (NSString *) mediaType withData : (NSData *) mediaData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *rootPath = [FloggerServerManage getMediaSavePath];
    if ([mediaType isEqualToString:@"image"]) {        
        NSString *imageFileName = [[[NSString alloc] initWithFormat:@"%@%d%@",@"IMG_",tempNum,@".jpg"] autorelease];
        NSString *imageFullFileName = [rootPath stringByAppendingPathComponent:imageFileName];
//        NSLog(@"imageFullFileName is %@",imageFullFileName);
        if ([fileManager fileExistsAtPath:imageFullFileName]) {
            tempNum++;
            [self saveDataToTempPath:mediaType withData:mediaData];
//            imageFileName = [[NSString alloc] initWithFormat:@"%@%d%@",@"IMG_",tempNum,@".jpg"];
//            imageFullFileName = [rootPath stringByAppendingPathComponent:imageFileName];
            
        }
        [fileManager createFileAtPath:imageFullFileName contents:mediaData attributes:nil];
        
    } else if ([mediaType isEqualToString:@"video"]){
//        NSString *videoFileName = [[NSString alloc] initWithFormat:@"%@%@%d%@",[FloggerServerManage getMediaSavePath],@"MOV_",tempNum,@".mov"];
//        NSLog(@"videoFileName is %@",videoFileName);
//        [fileManager createFileAtPath:videoFileName contents:mediaData attributes:nil];
    }
    tempNum++;    
}

-(CGFloat) getAdjustDataSizeFromData : (CGSize) dataSize
{
//    dataSize.width
    CGFloat adjustBilv = 0;
    if (dataSize.width > 640) {
        if (dataSize.height * dataSize.width/640 > 960) {
            adjustBilv = dataSize.height/960;
        } else {
            adjustBilv = dataSize.width/640;
        }        
    }
    
    return adjustBilv;
}
-(void) convertAsPhoto
{
    _isConfirming = YES;
    NSMutableDictionary *infoDict = [[[NSMutableDictionary alloc] init] autorelease];
    if ((self.statusMode == STILLIMAGEMODE) || (self.statusMode == PHOTOEDITMODE)) {
        //show MBProgressHUD
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        //            hud.labelText = NSLocalizedString(@"Loading...", @"Loading...") ;
        //            [hud bringSubviewToFront:self.view];
        //        });
        
        
        //        progressHud.labelText = NSLocalizedString(@"Loading...", @"Loading...") ;
        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
        
        [self render].staticPreviewMode = NO;
        self.render.needOnlyRawData = NO;
        UIImageOrientation fitOrientation = [self reverseToOrientation:_statusMode == STILLIMAGEMODE?-_normalizeOrientation:0 Mirrored:NO];
        [self renderImage:NO  Orientation:fitOrientation];
        UIImage *image = [self.render resultImage];
        //save image
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        UIImage *adjustSizedImage = image;
        UIImage *resultImage =  image;
        if (image.size.width > 640 || image.size.height>960) {
            float wScale = image.size.width / 640;
            float hScale = image.size.height / 960;
            adjustSizedImage = [UIImage imageWithCGImage:image.CGImage scale:MAX(wScale, hScale) orientation:image.imageOrientation];
            resultImage = [self transforNormalizeImage:adjustSizedImage];
        }
        
        NSData *imageData = UIImageJPEGRepresentation(resultImage, JPEGQUAILTY);
        
//        NSLog(@"original image size is %@",[NSValue valueWithCGSize:image.size]);
//        NSLog(@"transform image size is %@",[NSValue valueWithCGSize:resultImage.size]);
        NSString *imagePath = [self saveDataToPath:@"image" withData:imageData];
        
        [infoDict setObject:image forKey:fImage];
        [infoDict setObject:[NSValue valueWithCGSize:resultImage.size] forKey:fCameraInfoImageSize];
        [infoDict setObject:imagePath forKey:fImagePath];
        NSString * currentSyntax = [self collectCurrentFilter];
        if(currentSyntax)
        {
            [infoDict setObject:currentSyntax forKey:fCameraInfoSyntax];
        }
        
//        NSLog(@"save part image is %f",CFAbsoluteTimeGetCurrent() - start);
//        start = CFAbsoluteTimeGetCurrent();
        //hiden MBProcess hud
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [MBProgressHUD hideHUDForView:self.view animated:NO];
        //        });
        //        [activityIndicator stopAnimating];
        
    }
    
    if ((self.statusMode == RECORDINGMODE) || (self.statusMode == VIDEOEDITMODE) || (self.statusMode == VIDEOMODE)) {
        
//        if (self.statusMode == VIDEOEDITMODE) {
//            [self performSimpleOpenGL:^{
//                [self transformVideo];
//            }];
//            return;
//        }
        
        AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:self.videoURL options:nil] autorelease]; 
        NSArray *videoTracks = [inputAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
        
        //NSData *videoData = [NSData dataWithContentsOfURL:self.videoURL];
        
        //[infoDict setObject:videoData forKey:fVideo];
        [infoDict setObject:self.videoURL forKey:fVideoURL];
        
        //video image begin
        AVAssetImageGenerator *generator = [[[AVAssetImageGenerator alloc] initWithAsset:inputAsset] autorelease];
        CMTime actualTime = CMTimeMake(CMTimeGetSeconds(inputAsset.duration) * VIDEOTIMESCALE, VIDEOTIMESCALE);    
        generator.appliesPreferredTrackTransform = YES;
        CGImageRef imageRef = [generator copyCGImageAtTime:CMTimeMake(1, VIDEOTIMESCALE) actualTime:&actualTime error:nil];
        UIImage *thumbImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
//        if (self.currentFilter) {
//            <#statements#>
//        }
        
        [infoDict setObject:thumbImage forKey:fVideoThumbnail];   
        
        CGSize naturalSizeTransformed = CGSizeApplyAffineTransform (videoTrack.naturalSize, videoTrack.preferredTransform);
        naturalSizeTransformed.width = fabs(naturalSizeTransformed.width);
        naturalSizeTransformed.height = fabs(naturalSizeTransformed.height);
        
        [infoDict setObject:[NSValue valueWithCGSize:naturalSizeTransformed] forKey:fCameraInfoVideoSize];
        
        //tranfor infomation
        //todo import raw video
        NSString *transforInfo = [NSString stringWithFormat:@"%f,%f,%f,%f,%f,%f",videoTrack.preferredTransform.a,videoTrack.preferredTransform.b,videoTrack.preferredTransform.c,videoTrack.preferredTransform.d,videoTrack.preferredTransform.tx,videoTrack.preferredTransform.ty];
//        NSLog(@"===== camera transfor info is %@",transforInfo);
        [infoDict setObject:transforInfo forKey:fVideoTransforRect];
        //video time 
//        CMTimeGetSeconds(inputAsset.duration) ;
//        NSLog(@"===== video size is %f",CMTimeGetSeconds(inputAsset.duration));
        [infoDict setObject:[NSNumber numberWithFloat:CMTimeGetSeconds(inputAsset.duration)] forKey:fVideoTimeSeconds];
        
        //filter syntax
        NSString * currentSyntax = [self collectCurrentFilter];
        if(currentSyntax)
        {
            [infoDict setObject:currentSyntax forKey:fCameraInfoSyntax];
        }
        
        //background render
        if (self.statusMode == VIDEOEDITMODE && currentSyntax) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                FloggerRenderAdapter *backRender = [FloggerRenderAdapter getRenderAdapter];
                [backRender transformVideo:infoDict];
            });
        }
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            FloggerRenderAdapter *backRender = [FloggerRenderAdapter getRenderAdapter];
//            [backRender transformVideo:infoDict];
//        });
        
//        [self performSimpleOpenGL:^{
//            [self transformVideo];
//        }];
        
        //        backRender tran
    }
    _isConfirming = NO;
    if (delegate && [delegate respondsToSelector:@selector(floggerCameraControl:didFinishPickingMediaWithInfo:)]) {
        [delegate floggerCameraControl:self didFinishPickingMediaWithInfo:infoDict];
    } else {
        CommentPostViewController *commentPostControl = [[[CommentPostViewController alloc] init] autorelease];
        commentPostControl.composeMode = POSTMODE;
        commentPostControl.cameraInfo = infoDict;
        [self.navigationController pushViewController:commentPostControl animated:NO];
    }
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
}
-(void) confirm
{
//    UIActivityIndicatorView *activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
//    activityIndicator.center = self.view.center;
//    [activityIndicator bringSubviewToFront:self.view];
//    [self.view addSubview:activityIndicator];
//        [activityIndicator startAnimating];
    //[activityIndicator setNeedsDisplay];
    //dispatch_async(dispatch_get_main_queue(), ^{
    //});
    if ((self.statusMode == STILLIMAGEMODE) || (self.statusMode == PHOTOEDITMODE)) {
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    };
    [self performSelector:@selector(convertAsPhoto) withObject:nil afterDelay:0.02];
}

-(void) delayLay {
    [self.adjustLayer setHidden:YES];
    _isAdjust = false;
    [self addAndManageGesture];
}

-(void) tapView:(UITapGestureRecognizer *)recognizer 
{
//    NSLog(@"tapView");
    if (_isAdjust)
    {
//        [self.adjustLayer setHidden:YES];
        CGPoint point = [recognizer locationInView:self.controlView];
        if (point.x < 160) {
            if (point.y < 240) {
                _adjustMode = FloggerGestureRecognizerDirectionSecond;
            } else {
                _adjustMode = FloggerGestureRecognizerDirectionThird;
            }
        } else {
            if (point.y < 240) {
                _adjustMode = FloggerGestureRecognizerDirectionFirst;
            } else {
                _adjustMode = FloggerGestureRecognizerDirectionFourth;
            }
        }
        [self updateAdjustType];
        [[self adjustLayer] setNeedsDisplay];
        
        [self performSelector:@selector(delayLay) withObject:nil afterDelay:0.5];
        
        [self showHelpView:SNS_INSTRUCTIONS_CAMERA_ADJUSTMENTS];
        
    }
    
}



-(void) doubleTapView
{
//    NSLog(@"doubleTapView");
    _isAdjust = true;
    [[self adjustLayer] setHidden:NO];
    //scroll
//    [self.filterView setHidden:YES];
    _isFilterHidden = YES;
    [self displayAdjustType];
    //scroll
    [[self adjustLayer] setNeedsDisplay];
    _isTilt = false;
    
        [self transTiltAndAdjust:false];
    
    [self addAndManageGesture]; 
//    [self performSelector:@selector(addAndManageGesture:) withObject:self.controlView afterDelay:0.3];

    
}


-(void) floggerGesture:(FloggerGestureRecognizer *)recognizer 
{
//    NSLog(@"floggerGesture");
    if (!(([self statusMode] == PHOTOEDITMODE) || ([self statusMode] == STILLIMAGEMODE)
          || ([self statusMode] == PHOTOMODE) || self.statusMode == VIDEOMODE)) {
        [[self adjustLayer] setHidden:YES];
        return;
    }    

    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        if (!_isAdjust) {
            //reset
//            if (_adjustArea!= 0) {
                [self.resetBtn setHidden:NO];
//            }
            
            //end
            [[self adjustLayer] setHidden:YES];
            [self.adjustTypeView setHidden:NO];
            int bilu = [recognizer distance] / 8;
            switch (_adjustMode) {
                case FloggerGestureRecognizerDirectionFirst:
                    self.render.degreeContrastStandard+=bilu;
                    NSLog(@"====degreeeCont=== is %d",self.render.degreeContrastStandard);
                    break;
                case FloggerGestureRecognizerDirectionSecond:
                    self.render.degreeBrightnessStandard+=bilu;
                    break;
                case FloggerGestureRecognizerDirectionThird:
                    self.render.degreeSaturationStandard+=bilu;
                    break;
                case FloggerGestureRecognizerDirectionFourth:
                    self.render.degreeStrenthStandard+=bilu;
                    break;
                    
                default:
                    break;
            }     
            if (self.statusMode == PHOTOEDITMODE || self.statusMode == STILLIMAGEMODE) {
                [self performSimpleOpenGL:^{
                    [[self render] processImage];
                }];
            }

            [self updateAdjustType];          
        } else {
            [self showHelpView:SNS_INSTRUCTIONS_CAMERA_ADJUSTMENTS];
            _adjustMode = [recognizer floggerRecognizerDirection];
            [self updateAdjustType];
            [[self adjustLayer] setNeedsDisplay];
        }
           
        
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
//        [[self adjustLayer] setHidden:YES];
//        [[self adjustLayer] setNeedsDisplay];
//        _isAdjust = false;
        [self delayLay];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidenAdjustType) object:nil];
        [self performSelector:@selector(hidenAdjustType) withObject:nil afterDelay:0.5];
//        []
    }
    
}

-(void) hidenAdjustType
{
    [self.adjustTypeView setHidden:YES];
}

-(void) updateAdjustType
{
    int degreeNum[] = {self.render.degreeContrastStandard,self.render.degreeBrightnessStandard,
                        self.render.degreeSaturationStandard,self.render.degreeStrenthStandard};
    if (_adjustMode != 0) {
//        [self.adjustTypeView setHidden:NO];
        NSString *labelText;
        NSString *leftLable;
        NSString *rightLable;
        if (degreeNum[_adjustMode -1] > 0) 
        {
            if(_adjustMode == 4) {
                labelText = [NSString stringWithFormat
                             :@"%@ %d%%",ADJUSTTYPE[_adjustMode - 1],degreeNum[_adjustMode - 1]];
                leftLable = ADJUSTTYPE[_adjustMode - 1];
                rightLable = [NSString stringWithFormat
                              :@"%d",degreeNum[_adjustMode - 1]];
            } else {
                labelText = [NSString stringWithFormat
                             :@"%@ +%d",ADJUSTTYPE[_adjustMode - 1],degreeNum[_adjustMode - 1]];
                leftLable = ADJUSTTYPE[_adjustMode - 1];
                rightLable = [NSString stringWithFormat
                              :@"+%d",degreeNum[_adjustMode - 1]];
            }
        } else
        {
            labelText = [NSString stringWithFormat
                         :@"%@ %d",ADJUSTTYPE[_adjustMode - 1],degreeNum[_adjustMode - 1]];
            leftLable = ADJUSTTYPE[_adjustMode - 1];
            rightLable = [NSString stringWithFormat
                          :@"%d",degreeNum[_adjustMode - 1]];
        }
        
        self.adjustType.text = labelText;
        self.adjustType.textColor = [UIColor whiteColor];
        self.adjustType.font = [UIFont systemFontOfSize:15];
        //adjustment
        self.adjustmentIndicator.text = leftLable;
        //number
        self.adjustmentNumber.text = rightLable;
        
//        [self performSelector:@selector(hidenAdjustType) withObject:nil afterDelay:1];
    } else {
        [self.adjustTypeView setHidden:YES];
        self.adjustType.text = @"";
        //adjustment
        //Brighteness
        self.adjustmentIndicator.text = ADJUSTTYPE[1];
        self.adjustmentNumber.text = @"0";
    }

}


// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        UIView *piece = self.horizonView;//gestureRecognizer.view;
//        CGPoint locationInView = [gestureRecognizer locationInView:piece];
//        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
//        
//        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
//        
//        piece.center = locationInSuperview;
    }
}
-(void) redraw{
    
    [self.render processImage];
}
-(void) rotatePiece : (UIRotationGestureRecognizer *) gestureRecognizer
{
//    NSLog(@"rotatePiece");
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        _rotate += [gestureRecognizer rotation] * 180 / M_PI;
        //test begin
        self.horizonView.transform = CGAffineTransformRotate([self.horizonView transform], [gestureRecognizer rotation]);
        CGPoint currentTouchPoint = self.horizonView.center;
        //test end
        [self drawTiltHorizon:currentTouchPoint];        
        [gestureRecognizer setRotation:0];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.render setTiltShowMode:NO];
    }
    
    if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE)){
        [self performSimpleOpenGL:^{
            [self redraw];
        }];
    }
    
}

-(void) pinchPiece : (UIPinchGestureRecognizer *) gestureRecognizer
{
    //NSLog(@"pinchPiece");
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _scale = 1;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        _scale +=  [gestureRecognizer scale] - 1;
        //CGPoint currentTouchPointTest = [gestureRecognizer locationInView:self.glRenderView];
        //test begin
//        CGRect inRect = self.glRenderView.frame;
//        CGAffineTransform transform = CGAffineTransformMakeScale(gestureRecognizer.scale, gestureRecognizer.scale);//CGAffineTransformMakeRotation(angle / 180.0 * M_PI);
//        CGRect outRect = CGRectIntegral(CGRectApplyAffineTransform(inRect, transform));
//        CGFloat width = outRect.size.width;
//        CGFloat height = outRect.size.height;
//        CGPoint currentTouchPoint = CGPointMake(width/2, height/2);
        UIView *view = nil;
        if (_tiltStatus == TILTSTATUSRADIAL) {
            view = self.radiusView;
        }
        if (_tiltStatus == TILTSTATUSHORIZON) {
            view = self.horizonView;
        }
        
        view.transform = CGAffineTransformScale([view transform], [gestureRecognizer scale], [gestureRecognizer scale]);
//        [gestureRecognizer setScale:1];
        CGPoint currentTouchPoint = view.center;

        if (_tiltStatus == TILTSTATUSRADIAL) {
            [self drawTiltRadius:currentTouchPoint];
        }
        if (_tiltStatus == TILTSTATUSHORIZON) {
            [self drawTiltHorizon:currentTouchPoint];
        }
        
        [gestureRecognizer setScale:1.0];
        //NSLog(@"========_scale  is %f", _scale);
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.render setTiltShowMode:NO];
    }
    
    //[self performSimpleOpenGL:^{
    
        //if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE)){
         //   [self.render processImage];
        //}
    
    //}];
    if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE)){
        //dispatch_async(_testQueue, ^{
        [self performSimpleOpenGL:^{
            [self redraw];
        }];
        //});
    }
}

-(void) panPiece : (UIPanGestureRecognizer *) gestureRecognizer
{
    //NSLog(@"panPiece");
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
//    [self.adjustLayer setHidden:YES];
    //CGPoint currentTouchPointTest = [gestureRecognizer locationInView:self.glRenderView];
//    CGPoint translation = [gestureRecognizer translationInView:[self.controlView superview]];
//    CGPoint currentTouchPoint = CGPointMake([self.controlView center].x + translation.x, [self.controlView center].y + translation.y);
//    [gestureRecognizer setTranslation:CGPointZero inView:[self.controlView superview]];
    
    //test begin
//    CGPoint currentTouchPoint;
    UIView *view = nil;
    if (_tiltStatus == TILTSTATUSRADIAL) 
    {
        view = self.radiusView;
        
    } else if (_tiltStatus == TILTSTATUSHORIZON)
    {
        view = self.horizonView;
    }    
    CGPoint translation = [gestureRecognizer translationInView:[view superview]];
    [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
    [gestureRecognizer setTranslation:CGPointZero inView:[view superview]];
    CGPoint currentTouchPoint = view.center;
    
    [gestureRecognizer setTranslation:CGPointZero inView:[view superview]];
    //test end
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (_tiltStatus == TILTSTATUSRADIAL) 
        {
            [self drawTiltRadius:currentTouchPoint];
        } else if (_tiltStatus == TILTSTATUSHORIZON)
        {
            [self drawTiltHorizon:currentTouchPoint];
        }        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.render setTiltShowMode:NO];
    }
    if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE)){
        //dispatch_async(_testQueue, ^{
        [self performSimpleOpenGL:^{
            [self redraw];
        }];

        //});
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//        return NO;
//    }
    return YES;
}

-(void) addAndManageGesture
{
    
    UIView *view = self.controlView;
    view.userInteractionEnabled = YES;
    view.multipleTouchEnabled = YES;
    NSArray *gesturesArray = [view gestureRecognizers];
    for (UIGestureRecognizer *gesture in gesturesArray) {
        [view removeGestureRecognizer:gesture];
    }    
    if (self.statusMode == VIDEORECORD) {
        return;
    }
    if (self.statusMode == VIDEOEDITMODE) {
        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnGLView:)] autorelease];
        [view addGestureRecognizer:tapGesture];
        return;
    }
        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnGLView:)] autorelease];
    [tapGesture setDelegate:self];
    //exposure
    if ((self.statusMode == PHOTOMODE || self.statusMode == VIDEOMODE) && !_isAdjust) {

//        [tapGesture setDelegate:self];
        
        [view addGestureRecognizer:tapGesture];
    }
    
    if (self.statusMode == VIDEOMODE || self.statusMode == PHOTOMODE || self.statusMode == PHOTOEDITMODE || self.statusMode == STILLIMAGEMODE) {
        if (!_isAdjust) {
            UITapGestureRecognizer *doubleTapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapView)] autorelease];
            [doubleTapGesture setNumberOfTapsRequired:2];
            if (self.statusMode != PHOTOMODE) {
                [view addGestureRecognizer:doubleTapGesture];
            }
            
            if (!_isTilt && _adjustMode != 0) {
                FloggerGestureRecognizer *floggerGesture = [[[FloggerGestureRecognizer alloc] initWithTarget:self action:@selector(floggerGesture:)] autorelease];
                //            [floggerGesture setDelegate:self];
                [floggerGesture requireGestureRecognizerToFail:tapGesture];
                [floggerGesture requireGestureRecognizerToFail:doubleTapGesture];
                [view addGestureRecognizer:floggerGesture];

            }                    
        } else {
            UITapGestureRecognizer *singleTapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)] autorelease];
            [singleTapGesture setNumberOfTapsRequired:1];
            //            [tapGesture setNumberOfTouchesRequired:1];
            //            [tapGesture setDelegate:self];
                        [singleTapGesture requireGestureRecognizerToFail:tapGesture];
            [view addGestureRecognizer:singleTapGesture];
            
            FloggerGestureRecognizer *floggerGesture = [[[FloggerGestureRecognizer alloc] initWithTarget:self action:@selector(floggerGesture:)] autorelease];
            //            [floggerGesture setDelegate:self];
            [floggerGesture requireGestureRecognizerToFail:singleTapGesture];
            //            [floggerGesture requireGestureRecognizerToFail:doubleTapGesture];
            [view addGestureRecognizer:floggerGesture];
        }        

    }

    if (_tiltStatus == TILTSTATUSRADIAL && _isTilt) {
        
        UIPinchGestureRecognizer *pinchGesture = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchPiece:)] autorelease];
        [pinchGesture setDelegate:self];
        [view addGestureRecognizer:pinchGesture];
        
        UIPanGestureRecognizer *panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)] autorelease];
        [panGesture setMaximumNumberOfTouches:1];
        [panGesture setMinimumNumberOfTouches:1];
        [panGesture setDelegate:self];
        [view addGestureRecognizer:panGesture];
    }
    if (_tiltStatus == TILTSTATUSHORIZON && _isTilt) {
        
        UIRotationGestureRecognizer *rotateGesture = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)] autorelease];
        [view addGestureRecognizer:rotateGesture];
        
        UIPinchGestureRecognizer *pinchGesture = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchPiece:)] autorelease];
        [pinchGesture setDelegate:self];
        [view addGestureRecognizer:pinchGesture];
        
        UIPanGestureRecognizer *panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)] autorelease];
        [panGesture setMaximumNumberOfTouches:1];
        [panGesture setMinimumNumberOfTouches:1];
        [panGesture setDelegate:self];
        [view addGestureRecognizer:panGesture];
    }
    
}
-(void) renderImage:(BOOL) preview 
{
    [self renderImage:preview Orientation:UIImageOrientationUp];
}
-(int) normalizeOrientation:(UIImageOrientation)orientation  Mirrored:(BOOL)mirrored
{
    static int orts[] = {
     0,2,3,1
    };
    static int ortsMirror[] = {
        0,2,1,3
    };
    return mirrored?ortsMirror[orientation>3?orientation-4:orientation]:orts[orientation>3?orientation-4:orientation];
}
-(UIImageOrientation) reverseToOrientation:(int) normal Mirrored:(BOOL)mirrored
{
    static UIImageOrientation orts[] = {
        UIImageOrientationUp,            // default orientation
        UIImageOrientationRight,         // 90 deg CW
        UIImageOrientationDown,          // 180 deg rotation
        UIImageOrientationLeft,          // 90 deg CCW
        UIImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip
        UIImageOrientationLeftMirrored,  // vertical flip
        UIImageOrientationDownMirrored,  // horizontal flip
        UIImageOrientationRightMirrored, // vertical flip
    };
    if(normal<0) normal+=4;
    if(mirrored && normal<4) normal+=4;
    return orts[mirrored?normal:normal>3?normal-4:normal]; 
}
-(void) renderImage: (BOOL) preview Orientation:(UIImageOrientation) orientation Sync:(BOOL)sync
{ 
    BOOL mirrored = [self originalImage].imageOrientation>4;
    int intOrb = [self normalizeOrientation:[self originalImage].imageOrientation Mirrored:mirrored] - [self normalizeOrientation:orientation Mirrored:mirrored];
    UIImageOrientation drawOrt = [self reverseToOrientation:intOrb Mirrored:mirrored];
    //[EAGLContext setCurrentContext:self.render.openGL.context];
    UIImage *newImage = [[self render]prepareImageForRegister:[UIImage imageWithCGImage:[self originalImage].CGImage scale:1 orientation:drawOrt] forPreview:preview];
    //[[self render] registerImage:[self originalImage] forPreview:preview];
    [self performSimpleOpenGL:^{
        [[self render] registerImageAfterPrepare:newImage forPreview:preview];
        [[self render] processImage];
    }];
    if(preview && mirrored)
    {
#if defined(USE_SYSTEM_THREAD)
        [self performSimpleOpenGL:^{
            [self.render processImage];
        } withSync:sync];
#else 
        [_openGLQueue performTask:self.render selector:@selector(processImage) withObject:nil Sync:NO];
#endif
    }
    //glFlush();
    //[EAGLContext setCurrentContext:nil];
}
-(void) renderImage: (BOOL) preview Orientation:(UIImageOrientation) orientation
{
    [self renderImage:preview Orientation:orientation Sync:NO];
}
-(void) testSwitch
{
    [self switchStatusMode:STILLIMAGEMODE];
}

-(void) dealWithImageDataImage: (UIImage *) image
{
    [self setStatusMode:STILLIMAGEMODE];
    //[self performSimpleOpenGL:^{}];
    self.originalImage = self.captureManage.videoInput.device.position==AVCaptureDevicePositionFront?[UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeftMirrored]:image;
    //UIImage* newImage = self.captureManage.videoInput.device.position==AVCaptureDevicePositionFront?[UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeftMirrored]:[UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
    //self.originalImage = [self transforNormalizeImage:newImage];
//    NSLog(@"orientation:%d",image.imageOrientation);
    
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    if (_isAccessLock) {
        interfaceOrientation = deviceOrientation;
    }
    
    _pictureOrientation = UIImageOrientationUp;
    _normalizeOrientation = 0;
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        _pictureOrientation = UIImageOrientationUp;
        _normalizeOrientation = 0;
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        _pictureOrientation = UIImageOrientationDown;
        _normalizeOrientation = 2;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        _pictureOrientation = UIImageOrientationLeft;
        _normalizeOrientation = 3;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        _pictureOrientation = UIImageOrientationRight;
        _normalizeOrientation = 1;
    } 
    
    [self renderImage:YES];
   //[self performSimpleOpenGL:^{}];
    /*[EAGLContext setCurrentContext:self.render.openGL.context];
    [[self render] registerImage:[self originalImage] forPreview:YES];
    [[self render] processImage];
    glFlush();
    [EAGLContext setCurrentContext:nil];*/
    //[self performSimpleOpenGL:^{
    //[[self render] processImage];
    //}];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self switchStatusMode:STILLIMAGEMODE];
    });
}

-(void) drawAdjustArea : (CGContextRef) context withFrame : (CGRect) rect withOrientation : (int) orientation
{
    int radius = 30;
    // And draw with a black fill color 
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.5); 
    // And draw with a black fill color 
    CGContextFillRect(context, rect);
    CGContextFillPath(context);
    
    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1);
    switch (orientation) {
        case FloggerGestureRecognizerDirectionFirst:
            CGContextMoveToPoint(context, rect.origin.x , rect.origin.y + rect.size.height - radius);
            CGContextAddArcToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, rect.origin.x + radius, rect.origin.y + rect.size.height, radius);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
            break;
        case FloggerGestureRecognizerDirectionSecond:
            CGContextMoveToPoint(context, rect.size.width - radius , rect.origin.y + rect.size.height);
            CGContextAddArcToPoint(context, rect.size.width - radius, rect.origin.y + rect.size.height - radius, rect.size.width, rect.origin.y + rect.size.height- radius, radius);
            CGContextAddLineToPoint(context, rect.size.width, rect.origin.y + rect.size.height);
            break;
        case FloggerGestureRecognizerDirectionThird:
            CGContextMoveToPoint(context, rect.size.width - radius, rect.origin.y);
            CGContextAddArcToPoint(context, rect.size.width - radius, rect.origin.y + radius, rect.size.width, rect.origin.y + radius, radius);
            CGContextAddLineToPoint(context, rect.size.width, rect.origin.y);
            break;
        case FloggerGestureRecognizerDirectionFourth:
            CGContextMoveToPoint(context, rect.origin.x + radius , rect.origin.y);
            CGContextAddArcToPoint(context, rect.origin.x + radius , rect.origin.y + radius, rect.origin.x, rect.origin.y + radius, radius);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
            break;   
            
        default:
            break;
    }
    CGContextFillPath(context);
}


-(void) drawTiltRadius : (CGPoint) currentPoint
{   
    if (!_scale) {
        _scale = 1.0;
    }
    float radius = 0.25 * _scale;
    if ((radius < kTiltRadiusMax) && (radius >  kTiltRadiusMin))
    {
        [self.render setRadiusTiltBlur: radius X:currentPoint.x/self.glRenderView.frame.size.width Y:currentPoint.y/self.glRenderView.frame.size.height];
    }
    
    [self.render setTiltShowMode:YES];
}

-(void) drawTiltHorizon : (CGPoint) currentTouchPoint {
    if (!_scale) {
        _scale = 1.0;
    }  
    
    float radius = 0.25 * _scale;
    if ((radius < kTiltRadiusMax) && (radius >  kTiltRadiusMin))
    {
    [self.render setParTiltBlur:radius X:currentTouchPoint.x/self.glRenderView.frame.size.width  Y:currentTouchPoint.y/self.glRenderView.frame.size.height angle:_rotate];
    }
    [self.render setTiltShowMode:YES];
}


-(void) tiltShiftGesture : (FloggerTiltShiftRecognizer *) recognizer
{
//    NSLog(@"tiltshift");
    [self.adjustLayer setHidden:YES];
    CGPoint currentTouchPoint = [recognizer locationInView:self.glRenderView];
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        if (_tiltStatus == TILTSTATUSRADIAL) 
        {
            [self drawTiltRadius:currentTouchPoint];
        } else if (_tiltStatus == TILTSTATUSHORIZON)
        {
            [self drawTiltHorizon:currentTouchPoint];
        }        
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.render setTiltShowMode:NO];
    }
    [self performSimpleOpenGL:^{
        if (([self statusMode] == PHOTOEDITMODE)|| ([self statusMode] == STILLIMAGEMODE)){
            [self.render processImage];
        }
    }];
}

-(void) drawString : (NSString *) content withPoint: (CGPoint) point withContext : (CGContextRef )context
{
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    UIGraphicsPushContext(context);
    [content drawAtPoint:point withFont:[UIFont boldSystemFontOfSize:16]];
    UIGraphicsPopContext();
}

-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
//    NSLog(@"drawlayer========");
    if (!(([self statusMode] == PHOTOMODE) || ([self statusMode] == STILLIMAGEMODE)
          || ([self statusMode] == PHOTOEDITMODE || self.statusMode == VIDEOMODE))) {
        [layer setHidden:YES];
        return;
    }    
    int width = layer.frame.size.width;
    int height = layer.frame.size.height;
    int heightMargin = 50;
//    radius
    int radius = 30;
    
    // Drawing with a black stroke color
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1);
    // And draw with a black fill color 
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.5); 
    // draw circle
    CGContextFillEllipseInRect(context, CGRectMake(width / 2 - radius, height / 2 - radius, 2 * radius, 2 * radius));
    
    //draw text label
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    UIGraphicsPushContext(context);
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    //double stringHight = 10;

    CGRect firstRect = CGRectMake(width/2, heightMargin, width/2, height/2 - heightMargin);
//    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.5); 
//    CGContextFillRect(context, firstRect);
    CGRect secondRect = CGRectMake(0, heightMargin, width/2, height/2 - heightMargin);
//    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5); 
//    CGContextFillRect(context, secondRect);
    CGRect thirdRect = CGRectMake(0, height/2 , width/2, height/2 - heightMargin);
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.5); 
//    CGContextFillRect(context, thirdRect);
    CGRect fourthRect = CGRectMake(width/2, height/2, width/2, height/2 - heightMargin);
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.5, 0.5); 
//    CGContextFillRect(context, fourthRect);
    
    CGSize firstString = [ADJUSTTYPE[0] sizeWithFont:font];
    CGSize secondString = [ADJUSTTYPE[1] sizeWithFont:font];
    CGSize thirdString = [ADJUSTTYPE[2] sizeWithFont:font];
    CGSize fourthString = [ADJUSTTYPE[3] sizeWithFont:font];
    
    CGPoint firstPoint = CGPointMake(firstRect.origin.x + firstRect.size.width / 2 - firstString.width/2, firstRect.origin.y + firstRect.size.height / 2 - firstString.height/2);
    
    CGPoint secondPoint = CGPointMake(secondRect.origin.x + secondRect.size.width / 2 - secondString.width/2, secondRect.origin.y + secondRect.size.height / 2 - secondString.height/2);
    CGPoint thirdPoint = CGPointMake(thirdRect.origin.x + thirdRect.size.width / 2 - thirdString.width/2, thirdRect.origin.y + thirdRect.size.height / 2 - thirdString.height/2);
    CGPoint fourthPoint = CGPointMake(fourthRect.origin.x + fourthRect.size.width / 2 - fourthString.width/2, fourthRect.origin.y + fourthRect.size.height / 2 - fourthString.height/2);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(3, 3), 10, [[UIColor blackColor] CGColor]);
    
    [ADJUSTTYPE[0] drawAtPoint:firstPoint withFont:font];
    [ADJUSTTYPE[1] drawAtPoint:secondPoint withFont:font];    
    [ADJUSTTYPE[2] drawAtPoint:thirdPoint withFont:font];    
    [ADJUSTTYPE[3] drawAtPoint:fourthPoint withFont:font];   
    CGContextRestoreGState(context);
    UIGraphicsPopContext();
    
    //draw select status
    switch (_adjustMode) {
        case FloggerGestureRecognizerDirectionFirst:
            [self drawAdjustArea:context withFrame:CGRectMake(width / 2, heightMargin, width / 2, height / 2 -heightMargin) withOrientation:FloggerGestureRecognizerDirectionFirst];
            [self drawString:ADJUSTTYPE[0] withPoint:firstPoint withContext:context];
            
            break;
        case FloggerGestureRecognizerDirectionSecond:
            [self drawAdjustArea:context withFrame:CGRectMake(0, heightMargin, width / 2, height / 2 -heightMargin) withOrientation:FloggerGestureRecognizerDirectionSecond];
             [self drawString:ADJUSTTYPE[1] withPoint:secondPoint withContext:context];
            break;
        case FloggerGestureRecognizerDirectionThird:
            [self drawAdjustArea:context withFrame:CGRectMake(0, height / 2, width / 2, height / 2 -heightMargin) withOrientation:FloggerGestureRecognizerDirectionThird];
             [self drawString:ADJUSTTYPE[2] withPoint:thirdPoint withContext:context];            
            break;
        case FloggerGestureRecognizerDirectionFourth:
            [self drawAdjustArea:context withFrame:CGRectMake(width / 2, height / 2, width / 2, height / 2 -heightMargin) withOrientation:FloggerGestureRecognizerDirectionFourth];
            [self drawString:ADJUSTTYPE[3] withPoint:fourthPoint withContext:context];
            
            break;            
        default:
            break;
    }
    
    //draw line
    CGContextMoveToPoint(context,0,heightMargin);
    CGContextAddLineToPoint(context, width, heightMargin);
    CGContextMoveToPoint(context, width / 2, heightMargin);
    CGContextAddLineToPoint(context, width / 2, height - heightMargin);
    CGContextMoveToPoint(context, 0, height / 2);
    CGContextAddLineToPoint(context, width, height / 2);
    CGContextMoveToPoint(context, 0, height - heightMargin);
    CGContextAddLineToPoint(context, width, height - heightMargin);
    CGContextStrokePath(context);
}


-(void) importClick
{
//    UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
////        imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie];
//    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePicker.delegate = self;
//
//    imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
//    imagePicker.videoMaximumDuration = MAXIMUMDURATION;
//    [self presentModalViewController:imagePicker animated:NO];
    
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Choose Photo", @"Choose Photo"), NSLocalizedString(@"Choose Video", @"Choose Video"), nil];
    [ac showInView:self.view];
    
    /*UIImagePickerController *pickercontroller = [[[UIImagePickerController alloc] init]autorelease];
    pickercontroller.delegate = self;
    pickercontroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:pickercontroller animated:YES];*/
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *pickercontroller = [[[UIImagePickerController alloc] init]autorelease];
            pickercontroller.delegate = self;
            pickercontroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:pickercontroller animated:YES];
        }
            break;
        case 1:
        {
            UIImagePickerController *pickercontroller = [[[UIImagePickerController alloc] init]autorelease];
            pickercontroller.delegate = self;
            pickercontroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            pickercontroller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            pickercontroller.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil] autorelease];
            pickercontroller.allowsEditing = YES;
            pickercontroller.videoMaximumDuration = [GlobalUtils getCropVideoTime];//kVideoCropTime;
            //            pickercontroller.mediaTypes = kUTTypeImage;
            //            pickercontroller.allowsEditing = YES;
            [self presentModalViewController:pickercontroller animated:YES];
        }
            break;
    }
}

-(void) playVideoForWriter
{
    //test
    self.videoThumbImage = nil;
    
    iscanceled = FALSE;
    [self.playBtn setHidden:YES];    
    //play
//    NSLog(@"play");
    //input asset
    AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:self.videoURL options:nil] autorelease];     
    //Get video track from asset
    NSArray *videoTracks = [inputAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    CGSize naturalSize = videoTrack.naturalSize;
    //        CGSize
    CGSize naturalSizeTransformed = CGSizeApplyAffineTransform (naturalSize, videoTrack.preferredTransform);
    naturalSizeTransformed.width = fabs(naturalSizeTransformed.width);
    naturalSizeTransformed.height = fabs(naturalSizeTransformed.height);
    //        _isVideoRotate = (naturalSize.width == naturalSizeTransformed.width ? FALSE:TRUE);
    _isVideoRotate = TRUE;
    _videoSize = naturalSizeTransformed;
//    NSLog(@"preferredTransform a is %f==b is %f== c is %f===d is %f===tx is %f==ty is %f", videoTrack.preferredTransform.a, videoTrack.preferredTransform.b, videoTrack.preferredTransform.c, videoTrack.preferredTransform.d, videoTrack.preferredTransform.tx, videoTrack.preferredTransform.ty);
//    NSLog(@"naturalSize width is %f=====height====%f",naturalSize.width,naturalSize.height);
//    NSLog(@"_videosize width is %f=====height====%f",_videoSize.width,_videoSize.height);
    
    [self.slideTimeView setHidden:YES];
    dispatch_queue_t readQueue = dispatch_queue_create("readQueue", NULL);
    dispatch_async(readQueue, ^{
        [self handleWithVideoFromAlbum:self.videoURL];
    });
    dispatch_release(readQueue);
//    [self performSelector:<#(SEL)#> withObject:<#(id)#> afterDelay:<#(NSTimeInterval)#>]
//    [self handleWithVideoFromAlbumBackup:self.videoURL];
//    [self handleWithVideoFromAlbum];
}
-(void) pauseVideoForWriter
{
    [self.playBtn setHidden:NO];
//    [self.pauseBtn setHidden:YES];
    
//    [self performSimpleOpenGL:^{
//        
//    } ];
    @synchronized(self) {

        iscanceled = YES;
        if(self.videoReader.status == AVAssetReaderStatusReading) {
            [self.videoReader cancelReading];
            [self.cancelBtn setEnabled:YES];
        }
    }
    
}

-(void) drawImage
{
    //[[self render] registerImage:[self originalImage] forPreview:YES];
    [[self render] registerImageAfterPrepare:[self originalImage] forPreview:YES];
    [[self render] processImage];
    //varible
    self.videoThumbImage = self.originalImage;
}
//static CFAbsoluteTime actionTime;
-(void) extractImageFromVideo : (NSURL *) mediaURL withTime : (CMTime) thumbTime Sync:(BOOL)sync
{
    //dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //input asset
    AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:mediaURL options:nil] autorelease];
    AVAssetImageGenerator *generator = [[[AVAssetImageGenerator alloc] initWithAsset:inputAsset] autorelease];
    CMTime actualTime = CMTimeMake(CMTimeGetSeconds(inputAsset.duration) * VIDEOTIMESCALE, VIDEOTIMESCALE);    
    generator.appliesPreferredTrackTransform = YES;
    CGImageRef imageRef = [generator copyCGImageAtTime:thumbTime actualTime:&actualTime error:nil];
    UIImage *thumbImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    [self setOriginalImage:[_render prepareImageForRegister:thumbImage forPreview:YES]];
#if defined(USE_SYSTEM_THREAD)
    [self performSimpleOpenGL:^{
        [self drawImage];
    } withSync:NO];
#else 
    [_openGLQueue performTask:self selector:@selector(drawImage) withObject:nil Sync:NO];
#endif
        //[pool drain];
    //});
}

/*-(void) extractImageFromVideoTouch : (NSURL *) mediaURL withTime : (CMTime) thumbTime
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:mediaURL options:nil] autorelease];
        AVAssetImageGenerator *generator = [[[AVAssetImageGenerator alloc] initWithAsset:inputAsset] autorelease];
        CMTime actualTime = CMTimeMake(CMTimeGetSeconds(inputAsset.duration) * VIDEOTIMESCALE, VIDEOTIMESCALE);    generator.appliesPreferredTrackTransform = YES;
        CGImageRef imageRef = [generator copyCGImageAtTime:thumbTime actualTime:&actualTime error:nil];
        UIImage *thumbImage = [UIImage imageWithCGImage:imageRef];
        //[self setOriginalImage:thumbImage];
        [self setOriginalImage:[_render prepareImageForRegister:thumbImage forPreview:YES]];
        CGImageRelease(imageRef);
        [_openGLQueue performTask:self selector:@selector(drawImage) withObject:nil Sync:NO];
        [pool drain];
    });
    
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:NO];
    
    if ([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString: @"public.movie"]) {
        NSMutableDictionary *cameraData = [[[NSMutableDictionary alloc] init] autorelease];
        NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
        
        AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:videoURL options:nil] autorelease]; 
        NSArray *videoTracks = [inputAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
        
        [cameraData setObject:videoURL forKey:fVideoURL];
        
        //video image begin
        AVAssetImageGenerator *generator = [[[AVAssetImageGenerator alloc] initWithAsset:inputAsset] autorelease];
        CMTime actualTime = CMTimeMake(CMTimeGetSeconds(inputAsset.duration) * VIDEOTIMESCALE, VIDEOTIMESCALE);    
        generator.appliesPreferredTrackTransform = YES;
        CGImageRef imageRef = [generator copyCGImageAtTime:CMTimeMake(1, VIDEOTIMESCALE) actualTime:&actualTime error:nil];
        UIImage *thumbImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        [cameraData setObject:thumbImage forKey:fVideoThumbnail]; 
        
        CGSize naturalSizeTransformed = CGSizeApplyAffineTransform (videoTrack.naturalSize, videoTrack.preferredTransform);
        naturalSizeTransformed.width = fabs(naturalSizeTransformed.width);
        naturalSizeTransformed.height = fabs(naturalSizeTransformed.height);
        
        [cameraData setObject:[NSValue valueWithCGSize:naturalSizeTransformed] forKey:fCameraInfoVideoSize];
        
        //tranfor infomation
        NSString *transforInfo = [NSString stringWithFormat:@"%f,%f,%f,%f,%f,%f",videoTrack.preferredTransform.a,videoTrack.preferredTransform.b,videoTrack.preferredTransform.c,videoTrack.preferredTransform.d,videoTrack.preferredTransform.tx,videoTrack.preferredTransform.ty];
        [cameraData setObject:transforInfo forKey:fVideoTransforRect];
        
        //video seconds
        [cameraData setValue:[NSNumber numberWithFloat:CMTimeGetSeconds(inputAsset.duration)] forKey:fVideoTimeSeconds];
        CommentPostViewController *commentPostControl = [[[CommentPostViewController alloc] init] autorelease];
        commentPostControl.composeMode = POSTMODE;        
        commentPostControl.cameraInfo = cameraData;
        [self.navigationController pushViewController:commentPostControl animated:YES];
        
       /* [self switchStatusMode:VIDEOEDITMODE];
        NSURL *albumMediaURl = [info valueForKey:UIImagePickerControllerMediaURL]; 

        //set maxtime
        AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:albumMediaURl options:nil] autorelease];
        NSArray *videoTracks = [inputAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
        [self videoImageConvertImageOrientation : videoTrack.preferredTransform];
        
        float durationSeconds = inputAsset.duration.value / inputAsset.duration.timescale;
        [self.timeSlider setMaximumValue: durationSeconds];
        [self.timeSlider setValue:0.0];
        [self setVideoURL:albumMediaURl];
        [self extractImageFromVideo:albumMediaURl withTime:CMTimeMake(1, VIDEOTIMESCALE) Sync:YES];*/
        
    } else if ([[info valueForKey:UIImagePickerControllerMediaType]isEqualToString: @"public.image"])
    {
        [self setStatusMode:PHOTOEDITMODE];
        self.originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self switchStatusMode:PHOTOEDITMODE]; 
            [self renderImage:YES];
        });        
    }
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

-(NSString*) labelStringForTime: (Float64) time {
	int minutes = ((int) time / 60) % 60;
	int seconds = (int) time % 60;
	return [NSString stringWithFormat:@"%02d:%02d",
			minutes, seconds];
}

-(void) displaySliderTime : (CMTime) time
{
    //test begin
//    CGFloat sliderMin =  self.timeSlider.minimumValue;
	CGFloat sliderMax = self.timeSlider.maximumValue;
//	CGFloat sliderMaxMinDiff = sliderMax - sliderMin;
	CGFloat sliderValue = self.timeSlider.value;
    
    CGFloat location = sliderValue / sliderMax * self.timeSlider.frame.size.width 
                        + self.timeSlider.frame.origin.x - self.slideTimeView.frame.size.width/2;
    if (location < 0) {
        location = 0;
    } else if (location > (320 - self.slideTimeView.frame.size.width))
    {
        location = 320 - self.slideTimeView.frame.size.width;
    }
    [self.slideTimeView setFrame:CGRectMake(location, self.slideTimeView.frame.origin.y
                                            , self.slideTimeView.frame.size.width, self.slideTimeView.frame.size.height)];
    for (UIView *view in self.slideTimeView.subviews) {
        UILabel *label = (UILabel *) view;
        [label setText:[self labelStringForTime:(time.value / time.timescale)]];
    }
    
}
- (void) doVideoRender{
    CMTime newTime = CMTimeMakeWithSeconds(self.timeSlider.value, VIDEOTIMESCALE);
    [self extractImageFromVideo:self.videoURL withTime:newTime Sync:NO];
}

-(void) timeSliderValueChanged: (id) sender
{
    [self.slideTimeView setHidden:NO];
    [self postVideoRender];
}

-(void) timeSliderValueTouch: (id) sender
{  
    [self postVideoRender];
}


-(void) photoSlideVideo
{
    //[self.isIrisView.statisIrisView setHidden:NO];
    [self.isIrisView closeIris];
    //switch mode 
    STATUSMODE statusMode = ([self statusMode] == PHOTOMODE) ? VIDEOMODE:PHOTOMODE;
    [self switchStatusMode:statusMode];
//    dispatch_queue_t switchQueue = dispatch_queue_create("switchQueue", 0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{        
        //start capture session 
        AVCaptureSession *session = [[self captureManage] captureSession];
        if (statusMode == VIDEOMODE) {
            [session beginConfiguration];
            [session setSessionPreset:AVCaptureSessionPresetMedium];
            [session commitConfiguration];
            [self.render clearTiltBlur];
            
        } else {
            [session beginConfiguration];
            [session setSessionPreset:AVCaptureSessionPresetPhoto];
            [session commitConfiguration];
        }
        if (![session isRunning]) {
            [session startRunning];
        }    

    });
//    dispatch_release(switchQueue);
    [self.isIrisView performSelector:@selector(openIris) withObject:nil afterDelay:2];    
}

-(void) startRecord
{
//    NSLog(@"start record");
    [self.videoShootBtn setEnabled:NO];
    [self.videoRecordingBtn  setEnabled:YES];
    
    _startTime =  CFAbsoluteTimeGetCurrent();
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateRecordingValues)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    //dispatch_async(_writerMovieQueue, 
     [self performSimpleRecording: ^{
     {
//            NSLog(@"=======thread protect=====");
            AVCaptureSession *session = [[self captureManage] captureSession];
            if (![session isRunning]) {
                [session startRunning];
            }
         UIInterfaceOrientation currentOrient = [[UIDevice currentDevice] orientation];
         if (_isAccessLock) {
             currentOrient = deviceOrientation;
         }
         [[self writeManage] setupAssetWriter:currentOrient];
         
//         [self.writeManage setupAssetWriterAudioInput];
            //set statusmode;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self switchStatusMode:RECORDINGMODE];
            });
//            NSLog(@"=======thread protect   end=====");
        }
        
     } withSync:NO];
    //);
}

-(void) stopRecord
{
//    NSLog(@"stop record");
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self setStatusMode:VIDEOMODE];
    [self.videoRecordingBtn setEnabled:NO];    
    [self.videoShootBtn setEnabled:YES];
    
    //[self performSimpleRecording:^
    {     
        [self performSimpleRecording:^{
            
        } withSync:YES];
        if([[self writeManage] assetWriter].status != AVAssetWriterStatusWriting)
        {
            [[[self writeManage] assetWriter] cancelWriting];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self switchStatusMode:VIDEOMODE];
            });
        } else 
        {
            if(![[[self writeManage] assetWriter] finishWriting]) { 
//                NSLog(@"finishWriting returned NO") ;
            }
            
            ALAssetsLibrary *library = [[[ALAssetsLibrary alloc] init] autorelease];
            [library writeVideoAtPathToSavedPhotosAlbum:[[[self writeManage] assetWriter] outputURL]
                                        completionBlock:^(NSURL *assetURL, NSError *error){
                                            
                                        }];
//            NSLog(@"stop finish");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIVideoEditorController *videoEdit = [[[UIVideoEditorController alloc] init] autorelease];
                [videoEdit setDelegate:self];
                [videoEdit setVideoPath:[[[[self writeManage] assetWriter] outputURL] path]];
                [videoEdit setVideoMaximumDuration:[GlobalUtils getCropVideoTime]];
                [videoEdit setVideoQuality:UIImagePickerControllerQualityTypeHigh];
                //[self presentModalViewController:videoEdit animated:NO];
//                [self p]
                [self presentModalViewController:videoEdit animated:NO];
//                [self presentViewController:videoEdit animated:NO completion:^{}];
            });
        }
    }
    // }  withSync:NO];
}

-(void) callBackVideo: (NSString *) editedVideoPath
{
    /*UISaveVideoAtPathToSavedPhotosAlbum(editedVideoPath, nil, nil, nil);
    NSLog(@"edit video path is %@",editedVideoPath);
    NSURL *url = [NSURL URLWithString:editedVideoPath];
    AVURLAsset *inputAsset = [AVURLAsset assetWithURL:url];
    
    NSData* videoData = [NSData dataWithContentsOfFile:editedVideoPath];
    NSMutableDictionary *infoDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSLog(@"video size is %@",[NSValue valueWithCGSize:inputAsset.naturalSize]);
//    [infoDict setObject:videoData forKey:fVideo];
    [infoDict setObject:[NSValue valueWithCGSize:inputAsset.naturalSize] forKey:fCameraInfoVideoSize];
    NSString * currentSyntax = [self collectCurrentFilter];
    if(currentSyntax)
    {
        [infoDict setObject:currentSyntax forKey:fCameraInfoSyntax];
    }
    if (delegate && [delegate respondsToSelector:@selector(floggerCameraControl:didFinishPickingMediaWithInfo:)]) {
        [delegate floggerCameraControl:self didFinishPickingMediaWithInfo:infoDict];
    }*/
}

- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath
{
    if (!delegate) {
        [self.navigationController dismissModalViewControllerAnimated:NO];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self switchStatusMode:VIDEOMODE];
    });
    self.videoURL = [[[NSURL alloc] initFileURLWithPath:editedVideoPath] autorelease];
//    self.videoURL = self.writeManage.assetWriter.outputURL;
    
//    [self confirm];
    [self convertAsPhoto];
    
    /*AVURLAsset *inputAsset = [[[AVURLAsset alloc] initWithURL:self.videoURL options:nil] autorelease]; 
    NSArray *videoTracks = [inputAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    
    //NSData *videoData = [NSData dataWithContentsOfURL:self.videoURL];
    NSMutableDictionary *infoDict = [[[NSMutableDictionary alloc] init] autorelease];
    //[infoDict setObject:videoData forKey:fVideo];
    [infoDict setObject:self.videoURL forKey:fVideoURL];
    
    //video image begin
    AVAssetImageGenerator *generator = [[[AVAssetImageGenerator alloc] initWithAsset:inputAsset] autorelease];
    CMTime actualTime = CMTimeMake(CMTimeGetSeconds(inputAsset.duration) * VIDEOTIMESCALE, VIDEOTIMESCALE);    
    generator.appliesPreferredTrackTransform = YES;
    CGImageRef imageRef = [generator copyCGImageAtTime:CMTimeMake(1, VIDEOTIMESCALE) actualTime:&actualTime error:nil];
    UIImage *thumbImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    [infoDict setObject:thumbImage forKey:fVideoThumbnail];    
    [infoDict setObject:[NSValue valueWithCGSize:videoTrack.naturalSize] forKey:fCameraInfoVideoSize];
    
    if (delegate && [delegate respondsToSelector:@selector(floggerCameraControl:didFinishPickingMediaWithInfo:)]) {
        [delegate floggerCameraControl:self didFinishPickingMediaWithInfo:infoDict];
    } else {
        CommentPostViewController *commentPostControl = [[[CommentPostViewController alloc] init] autorelease];
        commentPostControl.composeMode = POSTMODE;
        commentPostControl.cameraInfo = infoDict;
        [editor pushViewController:commentPostControl animated:NO];
    }*/

}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error
{
    [editor dismissModalViewControllerAnimated:YES];
    [self switchStatusMode:VIDEOMODE];
    
}
- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor{
    [editor dismissModalViewControllerAnimated:YES];
    [self switchStatusMode:VIDEOMODE];
    
}

- (void)updateRecordingValues
{
    if ([self statusMode] == RECORDINGMODE) {
        CFAbsoluteTime time = CFAbsoluteTimeGetCurrent()-_startTime;
        Float64 seconds = time;
        Float64 hours = trunc(seconds / 3600.f);
        seconds -= hours * 3600.f;
        Float64 minutes = trunc(seconds / 60.f);
        seconds -= minutes * 60.f;
        NSString *labelText = [NSString stringWithFormat:@"%02.0f:%02.0f:%02.0f",hours,minutes,seconds];        
        for (UIView *view in self.recordingDuration.subviews) {
            if ([view.class isSubclassOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *) view;
                [label setText:labelText];
                break;
            }
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self viewDealloc];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillAppear: (BOOL) animated{
    [super viewWillAppear:animated];
//    NSLog(@"willappear");
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self.navigationController.navigationBar setHidden:YES];
    
    if([self captureManage]) {
        //dispatch_async(dispatch_get_main_queue(), ^{
          [[[self captureManage] captureSession] startRunning];
            //// Disable the idle timer while we are recording
            [UIApplication sharedApplication].idleTimerDisabled = YES;
        //});
        
    }
    if (self.statusMode == PHOTOEDITMODE || self.statusMode == STILLIMAGEMODE) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self renderImage:YES];
            UIImageOrientation fitOrientation = [self reverseToOrientation:_statusMode == STILLIMAGEMODE?-_normalizeOrientation:0 Mirrored:NO];
            [self renderImage:YES Orientation:fitOrientation];
        }); 
        //cancel write
//        [[FloggerRenderAdapter getRenderAdapter] cancelWriteFile];
    }
    //videoEdit
    if (self.statusMode == VIDEOEDITMODE) {
        [[FloggerRenderAdapter getRenderAdapter]cancelWriteFile];
    }
}

-(void) showHelpView : (NSString *) helpImageURL
{
    if ([GlobalUtils checkIsFirstShowHelpView:helpImageURL]) {
        FloggerInstructionView *instructionView = [[[FloggerInstructionView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withImageURL:helpImageURL] autorelease];
        [self.view.window addSubview:instructionView];        
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self setModalInPopover:YES];
//     NSLog(@"didappear");
    [self showHelpView:SNS_INSTRUCTIONS_CAMERA_OPTIONS];
    

}
-(void) viewWillDisappear: (BOOL) animated{
    [super viewWillDisappear:animated];
//    NSLog(@"willdisappeal");
    //dispatch_async(dispatch_get_main_queue(), ^{
        [[[self captureManage] captureSession] stopRunning];
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    //});
    
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    NSLog(@"view did disappera");
}
-(void) rotateIcon : (UIView *) view withCurrentOrient: (CGFloat) deviceAngle
{
    CALayer *myLayer = view.layer; 
    NSNumber *rotationAtStart = [myLayer valueForKeyPath:@"transform.rotation"];

    CGFloat rotateAngle;
    if ((rotationAtStart.floatValue < 0) && (deviceAngle > M_PI_2)) {
        rotateAngle = -M_PI_2;
    } else if ((rotationAtStart.floatValue > M_PI_2) && (deviceAngle < 0))
    {
        rotateAngle = M_PI_2;
    } else {
        rotateAngle = deviceAngle  - rotationAtStart.floatValue;
    }
    
    //    catransform
//    myLayer.anchorPoint = view.center;
    CATransform3D myRotationTransform = CATransform3DRotate(myLayer.transform, rotateAngle, 0.0, 0.0, 1.0);
    myLayer.transform = myRotationTransform;        
    CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    myAnimation.duration = 0.2;
    myAnimation.fromValue = rotationAtStart;
    myAnimation.toValue = [NSNumber numberWithFloat:(rotationAtStart.floatValue + rotateAngle)];
    [myLayer addAnimation:myAnimation forKey:@"transform.rotation"];
}
-(void) animaTest
{

}
-(void) receivedRotate
{        
    //return;
    if (_isConfirming) {
        return;
    }
    CGFloat deviceAngle ;
    
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    if(_isAccessLock)
    {
        interfaceOrientation = deviceOrientation;
    }
    UIImageOrientation fitOrientation = UIImageOrientationUp;
    int startOrientation = _statusMode == STILLIMAGEMODE?_normalizeOrientation:0;
    int currentNormalizeOrientation = 0;
//    UIDeviceOrientationFaceUp
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        deviceAngle = 0;
        currentNormalizeOrientation = 0;
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        deviceAngle = M_PI;
        currentNormalizeOrientation = 2;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        deviceAngle = M_PI_2;
        currentNormalizeOrientation = 3;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        deviceAngle = -M_PI_2;
        currentNormalizeOrientation = 1;
    } else 
    {
        deviceAngle = 0;
        //return;
    }
    if(_statusMode == PHOTOEDITMODE || _statusMode == STILLIMAGEMODE)
    {
        int intFitOrientation = currentNormalizeOrientation - startOrientation;
        fitOrientation = [self reverseToOrientation:intFitOrientation Mirrored:NO];
        [self renderImage:YES Orientation:fitOrientation Sync:YES];
        [self animaTest];
        //[self performSelector:@selector(animaTest) withObject:nil afterDelay:0.3];
        /*dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *rotationAtStart = 0;//[_eaglLayer valueForKeyPath:@"transform.rotation"];
            
            CGFloat rotateAngle =deviceAngle<0? -M_PI_2:M_PI_2;       
            CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            myAnimation.duration = 0.3;
            myAnimation.fromValue = [NSNumber numberWithFloat:(rotationAtStart.floatValue + rotateAngle)];
            [CATransaction setDisableActions:YES];
            //[CATransaction setCompletionBlock:^{
            //   [self renderImage:YES Orientation:fitOrientation];
            //}];
            myAnimation.toValue = rotationAtStart;
            myAnimation.removedOnCompletion =YES;
            [self.render.openGL.eaglLayer addAnimation:myAnimation forKey:@"transform.rotation"];
            });*/
        
       // [self renderImage:YES];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *iconView in self.rotateIconArray) {
            [self rotateIcon:iconView withCurrentOrient:deviceAngle];
            
        }
    });
    
}

-(void) addAnimate
{
    [self.focusImage.layer removeAllAnimations];
    [self addAdjustingAnimationToLayer:self.focusImage.layer removeAnimation:YES];
}

- (void)drawExposeBoxAtPointOfInterest:(CGPoint)point
{
    FloggerCaptureManage *captureManager = [self captureManage];
    if ([captureManager hasExposure]) {
        CALayer *exposureBox = self.focusImage.layer;
        int width = exposureBox.frame.size.width;
        int height = exposureBox.frame.size.height;
        exposureBox.frame = CGRectMake(point.x - width / 2, point.y - height / 2, width, height);
        [[[self controlView] layer] addSublayer:exposureBox];
        [self performSelector:@selector(addAnimate) withObject:nil afterDelay:0.001];

    }
}

- (void) clearResource
{
    self.captureManage.outputDelegate = nil;
    [self.captureManage performWaitLoop]; 
    [self setCaptureManage:nil];
    [self setWriteManage:nil];
    
    [self setRender:nil];
    
    [self setOriginalImage:nil];
    [self setVideoThumbImage:nil];
    [self setFilterXml:nil];
    
    // TODO 
    [self setServerManage:nil];

    [self setFilterDic:nil];
    
#if defined(USE_SYSTEM_THREAD)
    if(_standardOpenGLQueue)
    {
        dispatch_release(_standardOpenGLQueue);
        _standardOpenGLQueue = NULL;
    }
#else 
    [_openGLQueue release];
    _openGLQueue =NULL;
#endif
    if(_slideVideoQueue)
    {
        dispatch_release(_slideVideoQueue);
        _slideVideoQueue = NULL;
    }

}

-(void)viewDealloc{
    self.deviceAccelerometer.delegate = nil;
    self.deviceAccelerometer = nil;
    self.captureManage.outputDelegate = nil;
    [self.captureManage performWaitLoop]; 
    [self setCaptureManage:nil];
    self.filterBtn = nil;
    self.borderBtn = nil;
    self.borderScrollView = nil;
    self.normalFilter = nil;
    self.currentBorder = nil;
    [self setFilters:nil];
    self.borders = nil;
    [self setWriteManage:nil];
    
    [self setRender:nil];
    
    [self setResetBtn:nil];
    
    [self setFlashItem:nil];
    [self setAdjustItem:nil];
    [self setTiltItem:nil];
    [self setSwapItem:nil];
    [self setCancelItem:nil];
    [self setFilterItem:nil];
    
    [self setCameraBtnIcon:nil];
    [self setCameraShootBtn:nil];
 
    
    [self setFlashMenu:nil];
    [self setTiltMenu:nil];
    [self setSlideBtn:nil];
    [self setScrollView:nil];
    
    [self setRecordingDurationLabel:nil];
    [self setRecordingDuration:nil];
    
    [self setVideoRecordingBtn:nil];
    [self setVideoShootBtn:nil];

    [self setPhotoSlider:nil];
    [self setVideoSlider:nil];
    //confirm view
    [self setCameraConfirm:nil];
    [self setViewArray:nil];
    [self setToolBarView:nil];
    [self setControlView:nil];
    [self setCancelBtn:nil];
    [self setPlayBtn:nil];
    [self setVideoURL:nil];
    self.adjustLayer.delegate =nil;
    [self setAdjustLayer:nil];
    
    [self setAdjustType:nil];
    [self setAdjustTypeView:nil];
    
    [self setTimeSlider:nil];
    [self setGlRenderView:nil];
    [self setSlideTimeView:nil];
    
    
    [self setRadiusView:nil];
    [self setHorizonView:nil];
    [self setRotateIconArray:nil];
    [self setVideoReader:nil];
    [self setFocusImage:nil];
    [self setFilterView:nil];
    [self setAdjustmentNumber:nil];
    [self setAdjustmentIndicator:nil];

    [self setMiddleView:nil];
    
    [self setBottmonView:nil];
    [self setBackgroundRender:nil];
    [self setAdjustmentIndicatorView:nil];
    
    
    self.isIrisView = nil;
    if(_writerMovieQueue)
    {
        dispatch_release(_writerMovieQueue);
        _writerMovieQueue = NULL;
    }
    
}
- (void) dealloc
{
    [self clearResource];
    [self viewDealloc];
    [super dealloc];
}

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates 
{
    CGPoint pointOfInterest;// = CGPointMake(.5f, .5f);
    CGSize frameSize = [[self controlView] frame].size;
    pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    
    return pointOfInterest;
}

-(void) testFocus
{
    [self.captureManage setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
}

- (void)tapToExpose:(CGPoint)point
{
    FloggerCaptureManage *captureManager = [self captureManage];
    
    if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint convertPoint = [self convertToPointOfInterestFromViewCoordinates:point];
        [captureManager focusAtPoint:convertPoint];
    }
    
    if ([[[captureManager videoInput] device] isExposurePointOfInterestSupported]) {
        CGPoint convertPoint = [self convertToPointOfInterestFromViewCoordinates:point];
        [captureManager exposureAtPoint:convertPoint];

    }

    [self drawExposeBoxAtPointOfInterest:point];

    [self performSelectorOnMainThread:@selector(testFocus) withObject:nil waitUntilDone:1];
}
-(NSString*) collectCurrentFilter
{

    if([self.currentFilter.name isEqualToString:NORMAL_FILTER_NAME] 
       && !_tiltStatus 
       && (!self.currentBorder)
       && ![self.render degreeSaturationStandard]
       && ![self.render degreeBrightnessStandard]
       && ![self.render degreeContrastStandard]
       && [self.render degreeStrenthStandard]==100) return nil;
     
    NSMutableDictionary *dicFilter =[[[NSMutableDictionary alloc]init]autorelease];
    // filter
    if (self.currentFilter) {
        [dicFilter setValue:self.currentFilter.name forKey:kFilterName];
    }
    if (self.currentBorder && self.currentBorder){
        [dicFilter setValue:self.currentBorder.title forKey:kBorderName];
    }
    
    
    // tiltshift 
    if(_tiltStatus)
    {
        [dicFilter setValue:[NSNumber numberWithInt:_tiltStatus] forKey:kTiltStatus];
        [dicFilter setValue:[NSNumber numberWithFloat:_scale] forKey:kScale];
        [dicFilter setValue:[NSNumber numberWithFloat:_rotate] forKey:kRotate];
    }
    // adjustment
    [dicFilter setValue:[NSNumber numberWithInt:[self.render degreeStrenthStandard]] forKey:kFilterStrenth];
    [dicFilter setValue:[NSNumber numberWithInt:[self.render degreeSaturationStandard]]  forKey:kSaturation];
    [dicFilter setValue:[NSNumber numberWithInt:[self.render degreeBrightnessStandard]] forKey:kBright];
    [dicFilter setValue:[NSNumber numberWithInt:[self.render degreeContrastStandard]] forKey:kContrast];
    return [dicFilter JSONRepresentation];
}
#if defined(USE_SYSTEM_THREAD)
-(void) performSimpleOpenGL : (dispatch_block_t) block
{
    [self performSimpleOpenGL:block withSync:YES];
}
-(void) performSimpleOpenGL : (dispatch_block_t) block withSync:(BOOL)sync
{
    if(!_standardOpenGLQueue)
    {
        return;
    }
    if(sync)
    {
        dispatch_sync(_standardOpenGLQueue, ^{
            [_render.openGL switchContext];
            block();
            [_render.openGL clearContext];
        });
    } else {
        dispatch_async(_standardOpenGLQueue, ^{
            [_render.openGL switchContext];
            block();
            [_render.openGL clearContext];
        });      
    }
    //[_openGLQueue performTask:self selector:@selector(execBlock:) withObject:block Sync:YES];
}
#else 
-(void) performSimpleOpenGL : (dispatch_block_t) block
{
    [_openGLQueue performTask:self selector:@selector(execBlock:) withObject:block Sync:YES];
}
#endif
@end
