//
//  CommentPostViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#define ComposeMediaViewWidth 70
#define ComposeMediaViewHeight 100
#define MAXLENGTH 140

#import "CommentPostViewController.h"
#import "UploadServerProxy.h"
#import "IssueInfoCom.h"
#import "GlobalData.h"
#import "IssueinfoBean.h"
#import "FloggerCameraControl.h"
#import "TagViewController.h"
#import "TopicViewController.h"
#import "EntityEnumHeader.h"
#import "GeoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"
#import "AlbumViewController.h"
#import "ShareFeedViewController.h"
#import "AsyncTaskManager.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIViewController+iconImage.h"
#import "SBJson.h"
#import "Guid.h"
//typedef enum 
//{
//    MEDIA_PHOTO,
//    MEDIA_VIDEO
//}MediaType;

@interface CommentPostViewController(){
@private
}
-(CGFloat) getMediaHeight : (CGSize) mediaSize;
@end

@implementation CommentPostViewController
@synthesize delegate;
@synthesize countLabel, geoLabel, messageTV, actionView, issueinfo,groupid,uploadFileID;
#ifdef __IPHONE_5_0

#else
@synthesize reverseGeocoder;
#endif
@synthesize composeMode;
@synthesize mediaContent;
@synthesize cameraBtn;
@synthesize composeView;
@synthesize cameraInfo;
@synthesize playerLayer;
@synthesize playBtn;
@synthesize preUploadProxy;
@synthesize paraDictonary;
@synthesize displayVc;

//+(NSString *)description
//{
//    IssueInfoCom *issue = [[[IssueInfoCom alloc] init]autorelease];
//    
//    return [issue.dataDict JSONRepresentation];
//}

//-(NSString *) description
//{
//    return [NSString stringWithFormat:@"<%@ %p>{foo: %@}", [self class], self, [self paraDictonary]];
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        groupid = -1;
        self.uploadFileID = [[Guid randomGuid]stringValue];
        //test finish
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(compressVideo:) name:kFinishServer object:nil];
    }
    return self;
}

-(void) compressVideo : (NSNotification *) notification
{
//    self.cameraInfo
    NSDictionary *data = (NSDictionary *) notification.object;
    NSURL *videoURL =  [data objectForKey:kFinishVideoURL];
    if (self.playerLayer) {
        [self.playerLayer removeFromSuperlayer];
        AVPlayer *player = [[[AVPlayer alloc] initWithURL:videoURL] autorelease];
        AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playLayer.frame = CGRectMake(0, 0, self.mediaContent.frame.size.width, self.mediaContent.frame.size.height);
        //    playLayer.hidden = NO;
        [self.mediaContent.layer addSublayer:playLayer];
        [self setPlayerLayer:playerLayer];
//        self.playerLayer = [[AVPlayerLayer playerLayerWithPlayer:[[AVPlayer alloc] initWithURL:videoURL]] autorelease];
    }
//    [self.cameraInfo objectForKey:fVideoURL];
//    [self.cameraInfo setob]
    [self.cameraInfo setValue:videoURL forKey:fVideoURL];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL) checkIsFullScreen
{
    return YES;
}

-(void)showImage:(UIImage *) image
{
    self.displayVc = [[[PhotoDisplayViewController alloc] init] autorelease];
    self.displayVc.image = image;
    self.displayVc.delegate = self;
    if (self.bcTabBarController)
    {
        if ([GlobalUtils checkIOS_6]) {
            [self.navigationController.view addSubview:self.displayVc.view];
        } else
        {
            [self.bcTabBarController.view addSubview:self.displayVc.view];
        }
    } else {
        [self.navigationController.view addSubview:self.displayVc.view];
    }
    self.displayVc.view.alpha = 0.0;
    self.displayVc.view.frame = CGRectMake(0, 0, 320, 480);
    //sel
    [self.messageTV resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    //self.displayVc.view.frame = frame;
    self.displayVc.view.alpha = 1.0;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.25];
    [UIView commitAnimations];
}

-(void)dismissDisplayView
{
    [UIView beginAnimations:@"fadeout" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.25];
    self.displayVc.view.alpha = 0.0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(photoAnimationDidStop:finished: context:)];
    [UIView commitAnimations];
    [self.messageTV becomeFirstResponder];
}


-(void) go2PlayVideo:(NSURL *) videoURL
{
    
//    MPMovieSourceType movieSourceType = MPMovieSourceTypeStreaming;
//    NSLog(@"====videoURL is %@",videoURL);
    MPMoviePlayerViewController *moviePlayer = [[[MPMoviePlayerViewController alloc] initWithContentURL:videoURL] autorelease];
    moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    moviePlayer.moviePlayer.playbackState = MPMoviePlaybackStatePaused;
    [moviePlayer.moviePlayer prepareToPlay];
    [moviePlayer.moviePlayer play];
    //    [self.feedTableDelegate.navigationController presentModalViewController:moviePlayer animated:YES];  
    if (self.bcTabBarController) {
        if ([GlobalUtils checkIOS_6]) {
            [self.navigationController presentModalViewController:moviePlayer animated:NO];
        } else
        {
            [self.bcTabBarController presentModalViewController:moviePlayer animated:NO];
        }        
    } else {
        [self presentModalViewController:moviePlayer animated:NO];
    }
}


-(void) mediaBtnAction : (id) sender
{
    if ([self.cameraInfo objectForKey:fImage]) {
        UIImage *cameraImage =[self.cameraInfo objectForKey:fImage];
        [self showImage:cameraImage];
    } else if ([self.cameraInfo objectForKey:fVideoURL])
    {
        [self go2PlayVideo:[self.cameraInfo objectForKey:fVideoURL]];
    }
    
}

-(void) adjustComposeLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
//    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UIView *composeV = [[FloggerUIFactory uiFactory] createView];
//    composeV.layer.borderWidth = 1.0;
//    composeV.layer.borderColor = [UIColor grayColor].CGColor;
    composeV.layer.cornerRadius = 5;
    composeV.frame = CGRectMake(10, 10, 300, 145);
    composeV.backgroundColor = [UIColor whiteColor];
    composeV.layer.shadowColor = [[UIColor grayColor] CGColor];
    composeV.layer.shadowOffset = CGSizeMake(0, 1);
    composeV.layer.shadowRadius = 1;
    composeV.layer.shadowOpacity = 0.8;
    composeV.layer.shadowPath = [[UIBezierPath bezierPathWithRect:composeV.bounds]CGPath];
    
    UITextView *messageTextView = [[FloggerUIFactory uiFactory] createTextView];
    //messageTextView.backgroundColor = [UIColor clearColor];
    messageTextView.frame = CGRectMake(0, 0, 200, 145);
    messageTextView.layer.cornerRadius = 5;
    messageTextView.font = [UIFont systemFontOfSize:15];
    messageTextView.delegate = self;
    
    
    UIButton *mediaBtn = [[FloggerUIFactory uiFactory] createButton:nil];
    mediaBtn.frame = CGRectMake(320-ComposeMediaViewWidth-20-10, 10, ComposeMediaViewWidth, 145);
    mediaBtn.layer.cornerRadius = 3;
    mediaBtn.layer.masksToBounds = NO;
    mediaBtn.layer.shadowColor = [[UIColor grayColor] CGColor];
    mediaBtn.layer.shadowOffset = CGSizeMake(0, 1);
    mediaBtn.layer.shadowRadius = 1;
    mediaBtn.layer.shadowOpacity = 0.8;
//    mediaBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:mediaBtn.bounds]CGPath];
    [mediaBtn addTarget:self action:@selector(mediaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [composeV addSubview:messageTextView];
    [composeV addSubview:mediaBtn];
    
    [self.view addSubview:composeV];
    [self setComposeView:composeV];
    
    
    //action view
    UIImage *tagImage = [[FloggerUIFactory uiFactory] createImage:SNS_INSERT_TAG];
    UIImage *atImage = [[FloggerUIFactory uiFactory] createImage:SNS_INSERT_AT];
    UIImage *locationImage = [[FloggerUIFactory uiFactory] createImage:SNS_GEOTAG_ICON];
    UIImage *cameraImage = [[FloggerUIFactory uiFactory] createImage:SNS_IMPORT_MEDIA];
    
    UIView *actionV = [[FloggerUIFactory uiFactory] createView];
    actionV.frame = CGRectMake(0, 170, 320, 30);
    int actionHeight = 0;
    
    UIButton *tagBtn = [[FloggerUIFactory uiFactory] createButton:tagImage];
    tagBtn.frame = CGRectMake(15, actionHeight, tagImage.size.width, tagImage.size.height);
    [tagBtn addTarget:self action:@selector(topicBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *atBtn = [[FloggerUIFactory uiFactory] createButton:atImage];
    atBtn.frame = CGRectMake(60, actionHeight, atImage.size.width, atImage.size.height);
    [atBtn addTarget:self action:@selector(atBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cameraButton = [[FloggerUIFactory uiFactory] createButton:cameraImage] ;
    cameraButton.frame = CGRectMake(105, actionHeight, cameraImage.size.width, cameraImage.size.height);
    [cameraButton addTarget:self action:@selector(cameraTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *geoBtn = [[FloggerUIFactory uiFactory] createButton:locationImage];
    geoBtn.frame = CGRectMake(150, actionHeight, locationImage.size.width, locationImage.size.height);
    [geoBtn addTarget:self action:@selector(geoBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *locationLab = [[FloggerUIFactory uiFactory] createLable];
    locationLab.font = [UIFont systemFontOfSize:14];
    locationLab.frame = CGRectMake(geoBtn.frame.origin.x + geoBtn.frame.size.width+2 , actionHeight-3, 110, 25);
    locationLab.textAlignment = UITextAlignmentCenter;
    
    UILabel *countLab = [[FloggerUIFactory uiFactory] createLable];
    countLab.frame = CGRectMake(276, actionHeight-3, 45, 25);
    countLab.font = [UIFont boldSystemFontOfSize:14];
    countLab.text = @"140";
    
    //post mode
    if (self.composeMode == POSTMODE) {
        [cameraButton setHidden:YES];
        geoBtn.frame = CGRectMake(105, actionHeight, locationImage.size.width, locationImage.size.height);
        locationLab.frame = CGRectMake(geoBtn.frame.origin.x + geoBtn.frame.size.width +2, actionHeight-3, 156, 25);
    }
    
    [actionV addSubview:tagBtn];
    [actionV addSubview:atBtn];
    [actionV addSubview:geoBtn];
    [actionV addSubview:cameraButton];
    [actionV addSubview:locationLab];
    [actionV addSubview:countLab];
    
    [self.view addSubview:actionV];
    
    [self setMessageTV:messageTextView];
    [self setActionView:actionV];
    [self setCountLabel:countLab];
    [self setGeoLabel:locationLab];
    
    [self setMediaContent:mediaBtn];
    [self setCameraBtn:cameraButton];
    

    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adjustComposeLayout];
    // Do any additional setup after loading the view from its nib.
    if (self.composeMode == COMMENTMODE) {
        [self setRightNavigationBarWithTitle:NSLocalizedString(@"Post", @"Post") image:nil];
//        [self setLeftNavigationBarWithTitle:NSLocalizedString(@"Cancel", @"Cancel") image:nil];
    } else if(self.composeMode == TWEETMODE) {
        [self setRightNavigationBarWithTitle:NSLocalizedString(@"Next", @"Next") image:nil];
        [self setLeftNavigationBarWithTitle:NSLocalizedString(@"Cancel", @"Cancel") image:nil];
    } else if(self.composeMode == POSTMODE) {
        [self setRightNavigationBarWithTitle:NSLocalizedString(@"Next", @"Next") image:nil];
//        [self displayMediaContent:[self.cameraInfo objectForKey:fImage]];
        [self transCameraInfo];
    }

    [self.messageTV becomeFirstResponder];
//    self.loading = YES;
    [self requestGeoByGeoCoder];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self requestGeoByGeoCoder];
}

-(void)requestGeoByGeoCoder
{
//    self.loading = YES;
    CLLocation *currentLocation = [LocationManager sharedInstance].currentLocation;
    
    if (currentLocation) {
#ifdef __IPHONE_5_0
        CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
        [geocoder reverseGeocodeLocation:currentLocation 
                       completionHandler:^(NSArray *placemarks, NSError *error) {
//                           NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                           
                           if (error){
//                               NSLog(@"Geocode failed with error: %@", error);            
                               return;
                               
                           }
                           
                           if(placemarks && placemarks.count > 0)
                               
                           {
                               //do something   
                               CLPlacemark *topResult = [placemarks objectAtIndex:0];
                               NSString *addressTxt = [NSString stringWithFormat:@"%@ %@,%@ %@", 
                                                       [topResult subThoroughfare],[topResult thoroughfare],
                                                       [topResult locality], [topResult administrativeArea]];
//                               NSLog(@"%@",addressTxt);
                               
                               
//                               NSString *tmpPro = [NSString stringWithFormat:@"%@ %@ %@",[topResult thoroughfare]?[topResult thoroughfare]:@"", [topResult locality]?[topResult locality]:@"",[topResult administrativeArea]?[topResult administrativeArea]:@""];

                               NSLocale *locale = [NSLocale currentLocale];
                               NSString *language =[locale objectForKey:NSLocaleLanguageCode];
                               NSString *tmpPro;
                               if ([language isEqualToString:@"zh"]) {
                                   tmpPro = [NSString stringWithFormat:@"%@%@%@",[topResult administrativeArea]?[topResult administrativeArea]:@"", [topResult locality]?[topResult locality]:@"",[topResult subLocality]?[topResult subLocality]:@""];
                                   if(topResult.country)
                                   {
                                       tmpPro = [NSString stringWithFormat:@"%@, %@",tmpPro,topResult.country];
                                   }
                               }else{
                                   tmpPro = [NSString stringWithFormat:@"%@ %@ %@",[topResult subLocality]?[topResult subLocality]:@"", [topResult locality]?[topResult locality]:@"",[topResult administrativeArea]?[topResult administrativeArea]:@""];
                                   if(topResult.country)
                                   {
                                       tmpPro = [NSString stringWithFormat:@"%@, %@", tmpPro, topResult.country];
                                   }
                               }

                               /*NSString *tmpPro;
                               if (topResult.administrativeArea) {
                                   tmpPro = [NSString stringWithFormat:@"%@ %@",topResult.administrativeArea,topResult.country];
                               } else {
                                   tmpPro = [NSString stringWithFormat:@"%@",topResult.country];
                               }*/
                               self.geoLabel.text = tmpPro;
                               self.loading = NO;
                           }
                       }];
#else
        CLLocationCoordinate2D coord = currentLocation.coordinate;
        MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coord];
        geocoder.delegate = self;
        self.reverseGeocoder = geocoder;
        [geocoder start];
        [geocoder release];
#endif
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
//    NSLog(@"获取地址失败");
    self.loading = NO;
//    self.geoLabel.text = NSLocalizedString(@"ShangHai China", @"ShangHai China");
    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    
    //获取到地址 
    /*NSString *tmpPro;
    if (placemark.administrativeArea) {
        tmpPro = [NSString stringWithFormat:@"%@ %@",placemark.administrativeArea,placemark.country];
    } else {
        tmpPro = [NSString stringWithFormat:@"%@",placemark.country];
    }*/
    
    /*NSString *tmpPro = [NSString stringWithFormat:@"%@ %@ %@",[placemark thoroughfare]?[placemark thoroughfare]:@"", [placemark locality]?[placemark locality]:@"",[placemark administrativeArea]?[placemark administrativeArea]:@""];
    if([tmpPro length]<5 && placemark.country)
    {
        tmpPro = [NSString stringWithFormat:@"%@, %@", tmpPro, placemark.country];
    }*/
    MKPlacemark * topResult = placemark;
    NSLocale *locale = [NSLocale currentLocale];
    NSString *language =[locale objectForKey:NSLocaleLanguageCode];
    NSString *tmpPro;
    if (![language isEqualToString:@"zh"]) {
        tmpPro = [NSString stringWithFormat:@"%@%@%@",[topResult administrativeArea]?[topResult administrativeArea]:@"", [topResult locality]?[topResult locality]:@"",[topResult subLocality]?[topResult subLocality]:@""];
        if([tmpPro length]<5 && topResult.country)
        {
            tmpPro = [NSString stringWithFormat:@"%@%@",topResult.country, tmpPro];
        }
    }else{
        tmpPro = [NSString stringWithFormat:@"%@ %@ %@",[topResult subLocality]?[topResult subLocality]:@"", [topResult locality]?[topResult locality]:@"",[topResult administrativeArea]?[topResult administrativeArea]:@""];
        if([tmpPro length]<5 && topResult.country)
        {
            tmpPro = [NSString stringWithFormat:@"%@, %@", tmpPro, topResult.country];
        }
    }
//    NSString *tmpPro = [NSString stringWithFormat:@"%@ %@",placemark.administrativeArea,placemark.country];
    self.geoLabel.text = tmpPro;
    self.loading = NO;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    [self unregisterForKeyboardNotifications];
    [self myReleaseSource];
}

-(void) myReleaseSource
{
    
    self.messageTV.delegate = nil;
    self.messageTV = nil;
    self.actionView = nil;
    self.countLabel = nil;
    self.geoLabel = nil;
    self.issueinfo = nil;
#ifdef __IPHONE_5_0
    
#else
    self.reverseGeocoder.delegate = nil;
    self.reverseGeocoder = nil;
#endif
    self.preUploadProxy.delegate = nil;
    self.preUploadProxy = nil;
    self.cameraInfo = nil;
    self.playerLayer = nil;
    self.playBtn = nil;
    self.mediaContent = nil;
    self.cameraBtn = nil;
    self.composeView = nil;
    self.paraDictonary = nil;
    
    self.displayVc = nil;
    
    
//    @property(nonatomic, retain) UIButton *mediaContent;
//    @property(nonatomic, retain) UIButton *cameraBtn;
//    @property(nonatomic, retain) UIView *composeView;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView: NSLocalizedString(@"Compose",@"Compose")];
    [self registerForKeyboardNotifications];
    //will appear
//    [floggerr]
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterForKeyboardNotifications];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)keyboardWillBeShown:(NSNotification *)aNotification
{
    [super keyboardWillBeShown:aNotification];
    
    [UIView beginAnimations:nil context:nil];
    CGRect viewFrame = self.view.frame;
    CGRect messageFrame = self.messageTV.frame;
    CGRect actionFrame = self.actionView.frame;
    CGRect composeRect = self.composeView.frame;
    
    CGRect tmpFrame;
//    NSLog(@"viewFrame is %@",[NSValue valueWithCGRect:viewFrame]);
//    if (self.composeMode == COMMENTMODE) {
//        tmpFrame = CGRectMake(actionFrame.origin.x, 367 - actionFrame.size.height - self.keyboardRect.size.height+49, actionFrame.size.width, actionFrame.size.height);
//        composeRect = CGRectMake(composeRect.origin.x, composeRect.origin.y, composeRect.size.width, 367 - composeRect.origin.y - self.keyboardRect.size.height - actionFrame.size.height + 49 -10);
//        messageFrame = CGRectMake(messageFrame.origin.x, messageFrame.origin.y, messageFrame.size.width, composeRect.size.height);
//    } else 
    {
        tmpFrame = CGRectMake(actionFrame.origin.x, 416 - actionFrame.size.height - self.keyboardRect.size.height, actionFrame.size.width, actionFrame.size.height);
        composeRect = CGRectMake(composeRect.origin.x, composeRect.origin.y, composeRect.size.width, 416 - composeRect.origin.y - self.keyboardRect.size.height - actionFrame.size.height-10);
        messageFrame = CGRectMake(messageFrame.origin.x, messageFrame.origin.y, messageFrame.size.width, composeRect.size.height);
        
    }
    self.actionView.frame = tmpFrame;    
//    NSLog(@"action is %@",[NSValue valueWithCGRect:tmpFrame]);
    self.composeView.frame = composeRect;
    self.messageTV.frame = messageFrame;
    //message lay shawdow
    self.composeView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.composeView.bounds]CGPath];
    
    [UIView setAnimationDelay:100];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:200];
    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    [super keyboardWillBeHidden:aNotification];
    [UIView beginAnimations:nil context:nil];
    [UIView commitAnimations];
}

#define kMaxLength 140
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger avaibleLength = kMaxLength - (textView.text.length);
    if (avaibleLength < 0) {
        avaibleLength = 0;
        self.messageTV.text = [self.messageTV.text substringToIndex:kMaxLength];
    }
    else
    {
        self.countLabel.textColor = [UIColor blackColor];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%d", avaibleLength];
}

-(NSMutableDictionary *) getIssueParaDic
{
    NSMutableDictionary *paraDic = [[[NSMutableDictionary alloc] init] autorelease];
    
    IssueInfoCom *com = [[[IssueInfoCom alloc] init] autorelease];
    IssueinfoBean *tmpIssueinfo = [[[IssueinfoBean alloc] init] autorelease];
    com.issueinfo = tmpIssueinfo;
    tmpIssueinfo.location = self.geoLabel.text;
    
    if (self.issueinfo) 
    {
        com.issueinfo.parentid = self.issueinfo.id;
    }
    com.issueinfo.text = [messageTV text];
    
    NSInteger category = ISSUE_CATEGORY_TWEET;
    com.uploadFileID = self.uploadFileID;
    NSString *thumbnailFileID = [NSString stringWithFormat:kThumbnailFormat,uploadFileID];
    NSString *newPath = nil;
    if ([self.cameraInfo objectForKey:fImagePath]) {
        category = ISSUE_CATEGORY_PICTURE;
        if ([self.cameraInfo objectForKey:fCameraInfoImageSize]) {
            NSValue *imageSizeValue = [self.cameraInfo objectForKey:fCameraInfoImageSize];
            CGSize imageSize = [imageSizeValue CGSizeValue];
            com.issueinfo.photowidth = [NSNumber numberWithFloat:imageSize.width];
            com.issueinfo.photoheight = [NSNumber numberWithFloat:imageSize.height];
        }
        [paraDic setObject:[self.cameraInfo objectForKey:fImagePath] forKey:kPostImagePath];
        [paraDic setObject:[self.cameraInfo objectForKey:fImage] forKey:kPostOriginalImage];

        newPath = [[DataCache sharedInstance] cachePathForKey:uploadFileID andCategory:nil];
        NSError * error = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:newPath error:&error];
        }
        [[NSFileManager defaultManager] copyItemAtPath:[self.cameraInfo objectForKey:fImagePath] toPath:newPath error:&error];
//        NSLog(@"fimagepath is %@",[self.cameraInfo objectForKey:fImagePath]);
        if(error)
        {
//            NSLog(@"error is %@",error);
        }
        
    } else if ([self.cameraInfo objectForKey:fVideoURL])
    {
        category = ISSUE_CATEGORY_VIDEO;
        if ([self.cameraInfo objectForKey:fCameraInfoVideoSize]) {
            NSValue *imageSizeValue = [self.cameraInfo objectForKey:fCameraInfoVideoSize];
            CGSize imageSize = [imageSizeValue CGSizeValue];
            com.issueinfo.photowidth = [NSNumber numberWithFloat:imageSize.width];
            com.issueinfo.photoheight = [NSNumber numberWithFloat:imageSize.height];
            com.issueinfo.videoDuration = [self.cameraInfo valueForKey:fVideoTimeSeconds];
        }
        [paraDic setObject:[self.cameraInfo objectForKey:fVideoThumbnail] forKey:kPostVideoThumbnail];
        [paraDic setObject:[self.cameraInfo objectForKey:fVideoURL] forKey:kPostVideoURL];
//        [paraDic setObject:[self.cameraInfo objectForKey:fVideoTransforRect] forKey:]
        //com 
        if ([self.cameraInfo objectForKey:fVideoTransforRect]) 
        {
            com.issueinfo.videoDirection = [self.cameraInfo objectForKey:fVideoTransforRect];
        }
        
        UIImage *mediaImage = [self.cameraInfo objectForKey:fVideoThumbnail];
        [[DataCache sharedInstance] storeImage:mediaImage forKey:thumbnailFileID];                
        newPath = [[DataCache sharedInstance] cachePathForKey:uploadFileID andCategory:nil];
        NSError * error = nil;
//        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSURL fileURLWithPath:newPath]]) {
//            [[NSFileManager defaultManager] removeItemAtPath:[NSURL fileURLWithPath:newPath] error:&error];
//        } 
//        if ([NSFileManager defaultManager]) {
//            <#statements#>
//        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
            [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:newPath] error:&error];
        }     
//        CFAbsoluteTime moveTime = CFAbsoluteTimeGetCurrent();
        [[NSFileManager defaultManager] copyItemAtURL:[self.cameraInfo objectForKey:fVideoURL] toURL:[NSURL fileURLWithPath:newPath] error:&error];
//        NSLog(@"=== move time is %f",CFAbsoluteTimeGetCurrent() - moveTime);
        if(error)
        {
//            NSLog(@"error is %@",error);
        }
    }
    if ([self.cameraInfo objectForKey:fCameraInfoSyntax])
    {
        com.issueinfo.filtersyntax = [self.cameraInfo objectForKey:fCameraInfoSyntax];
    }
    
    com.issueinfo.issuecategory = [NSNumber numberWithInt:category];
    [paraDic setObject:com forKey:kPostIssueInfoCom];
    //is import image
    [paraDic setObject:[NSNumber numberWithBool:isImportMedia] forKey:kPostIsImportImage];
    if(newPath)
    {
        [paraDic setObject:newPath forKey:kUploadFilePATHKey];
    }
    return paraDic;
}

-(void)doRequest
{
//    if (self.loading) {
//        return;
//    }
//    
//    self.loading = YES;
    
   // if (!preUploadProxy) {
    //    self.preUploadProxy = [[[UploadServerProxy alloc] init] autorelease];
        //self.preUploadProxy.delegate = [AsyncTaskManager sharedInstance];//self;
    //}
   UploadServerProxy* currentPreUploadProxy = [[[UploadServerProxy alloc] init] autorelease];
    NSMutableDictionary *paraDic = [self getIssueParaDic];
    IssueInfoCom *com = [paraDic valueForKey:kPostIssueInfoCom];
    self.paraDictonary = paraDic;
    NSString* newPath  = [paraDic valueForKey:kUploadFilePATHKey];
    [[AsyncTaskManager sharedInstance] addTask:currentPreUploadProxy];
    [currentPreUploadProxy preUploadIssue:com withData:newPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
}
-(void)doUploadRequest : (IssueInfoCom *) resInfo withPath: (NSString *) newDataPath
{
//    if (self.loading) {
//        return;
//    }
//    
//    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[UploadServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    //NSMutableDictionary *paraDic = [self getIssueParaDic:resInfo];
    IssueInfoCom *com = resInfo;//[paraDic valueForKey:kPostIssueInfoCom];


    [[AsyncTaskManager sharedInstance] addTask:self.serverProxy];
    [(UploadServerProxy *)self.serverProxy uploadFileIssue:com withData:newDataPath];
    
//    if (!self.delegate) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if ([textView.text length] > MAXLENGTH) {
//        textView.text = [textView.text substringToIndex:MAXLENGTH-1];
//        return NO;
//    }
    return YES;
}

-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    [super networkFinished:serverproxy];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    //    [GlobalUtils showPostMessageAlert:@""];
    [super transactionFinished:serverproxy];
    if (serverproxy == self.preUploadProxy) {
        self.loading = NO;
        IssueInfoCom *com = (IssueInfoCom *)serverproxy.response;
        
        NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] init] autorelease];
        NSString * deco;
        if (com.threadHead.hypertext) {
            deco = [NSString stringWithFormat:@"<span class='userFormat'>%@</span> %@",com.threadHead.username,com.threadHead.hypertext];
        } else {
            deco = [NSString stringWithFormat:@"<span class='userFormat'>%@</span>",com.threadHead.username];
        }            
        [com.threadHead.dataDict setObject:deco forKey:@"decoratedHypertext"];
        
        if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_PICTURE || [com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO) {
            NSString *newPath = nil;
            if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_PICTURE) {
                newPath = [[DataCache sharedInstance] cachePathForKey:com.threadHead.bmiddleurl andCategory:nil];
                NSError * error = nil;
                [[NSFileManager defaultManager] copyItemAtPath:[self.cameraInfo objectForKey:fImagePath] toPath:newPath error:&error];
                if(error)
                {
//                    NSLog(@"error is %@",error);
                }

                [dataDic setObject:kNotificationCommentAction forKey:kNotificationAction];
                [dataDic setObject:com.threadHead forKey:kNotificationInfoIssueThread];
                if (!isImportMedia) {
//                UIImageWriteToSavedPhotosAlbum([self.cameraInfo objectForKey:fImage], nil, nil, nil);
                }
                
            } else if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO)
            {
                UIImage *mediaImage = [self.cameraInfo objectForKey:fVideoThumbnail];
                [[DataCache sharedInstance] storeImage:mediaImage forKey:com.threadHead.bmiddleurl];                
                newPath = [[[DataCache sharedInstance] cachePathForKey:com.threadHead.videourl andCategory:nil] stringByAppendingPathExtension:@"mov"];
                NSError * error = nil;
                [[NSFileManager defaultManager] copyItemAtURL:[self.cameraInfo objectForKey:fVideoURL] toURL:[NSURL fileURLWithPath:newPath] error:&error];
                if(error)
                {
//                    NSLog(@"error is %@",error);
                }
//                NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] init] autorelease];
                [dataDic setObject:kNotificationCommentAction forKey:kNotificationAction];
                [dataDic setObject:com.threadHead forKey:kNotificationInfoIssueThread];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
                //save video to album
                if (!isImportMedia) {
//                    UISaveVideoAtPathToSavedPhotosAlbum([[self.cameraInfo objectForKey:fVideoURL] path], nil, nil, nil);
                }
                
            }
            [self doUploadRequest:com withPath:newPath];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:NO];
//            });
            
        } else {
            [dataDic setObject:kNotificationCommentAction forKey:kNotificationAction];
            [dataDic setObject:com.threadHead forKey:kNotificationInfoIssueThread];

            if (!self.delegate) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
                dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:NO];
                });
                
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
            }

        }     
        
        
    } 
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
    
//    IssueInfoCom *com = (IssueInfoCom *)serverproxy.response;
//    if (self.delegate) {
//        [self.delegate composePostResultDoneWithIssueInfoCom:com];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftAction:(id)sender
{
    [self.messageTV resignFirstResponder];
    if (self.composeMode == TWEETMODE) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
//    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
//    [self.messageTV resignFirstResponder];
//    if (!vc) {
//        [[GlobalData sharedInstance].menuView show];
//    }
}


-(BOOL) isEmpty:(NSString*) text
{
    return ![text length];
}

-(BOOL) checkInputValid
{
    NSString *string = self.messageTV.text;
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.cameraInfo) {
        return YES;
    }
    
    if([self isEmpty:string])
    {        
        [GlobalUtils showAlert:NSLocalizedString(@"", @"") message:NSLocalizedString(@"Please write a message",@"Please write a message")];
        return NO;
    }
    return YES;
    
}

-(void)rightAction:(id)sender
{
    if (![self checkInputValid]) {
        return;
    }
    if (self.composeMode == COMMENTMODE) {
        UIButton *barButton = (UIButton *) sender;
        barButton.userInteractionEnabled = NO;
        self.isNeedProgress = YES;
        [self doRequest];

    } else {
        ShareFeedViewController *shareControl = [[[ShareFeedViewController alloc] init]autorelease];
        shareControl.shareComeFrom=FROM_CAMERA_SHARE;
//        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        NSMutableDictionary *uploadDic = [self getIssueParaDic];
//        NSLog(@"===== go to sharefeed view is %f",CFAbsoluteTimeGetCurrent() - startTime);
        shareControl.uploadDic = uploadDic;
        shareControl.shareType = SHAREMEDIA;
        [self.navigationController pushViewController:shareControl animated:YES];
    }

    
}

//-(void)showCaptureMedia:(MediaTypeCOM)mediaType
//{
//    FloggerCameraControl *carmeraControl = [[FloggerCameraControl alloc] initWithNibName:nil bundle:nil];
//    carmeraControl.delegate = self;
//    [self presentModalViewController:carmeraControl animated:YES];
//    [carmeraControl release];
//}

-(void)atBtnTapped:(id)sender
{
    TagViewController *tagvc = [[TagViewController alloc] initWithNibName:nil bundle:nil];
    tagvc.delegate = self;
    [self.navigationController pushViewController:tagvc animated:YES];
    [tagvc release];
}

-(void)topicBtnTapped:(id)sender
{
    TopicViewController *tvc = [[TopicViewController alloc] initWithNibName:nil bundle:nil];
    tvc.delegate = self;
    [self.navigationController pushViewController:tvc animated:YES];
    [tvc release];
}

-(void)cameraTapped:(id)sender
{
    //    [self showCaptureMedia];
    
//    FloggerCameraControl *cameraControl = [[[FloggerCameraControl alloc] init] autorelease];
//    cameraControl.delegate = self;
//    cameraControl.statusMode = PHOTOMODE;
//    [self presentModalViewController:cameraControl animated:NO];
    
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"Take Photo", @"Take Photo"), NSLocalizedString(@"Import Picture", @"Import Picture"), NSLocalizedString(@"Import Video", @"Import Video"), nil];
//    ac.delegate = self;
    ac.tag = 1;
	
//	ac.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    if (self.bcTabBarController) {
        [ac showInView:self.bcTabBarController.view];
    } else {
        [ac showInView:self.view];
    }
    
	[ac release];
}

-(void)geoBtnTapped:(id)sender
{
    if (self.geoLabel.text.length > 0) {
        UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"Disable Location", @"Disable Location"), NSLocalizedString(@"Change Location", @"Change Location"), nil] autorelease];
        actionSheet.tag = 2;
        if (self.bcTabBarController) {
            [actionSheet showInView:self.bcTabBarController.view];
        } else {
            [actionSheet showInView:self.view];
        }

    } else {
        GeoViewController *gvc = [[[GeoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        gvc.delegate = self;
        [self.navigationController pushViewController:gvc animated:YES];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2) {
        switch (buttonIndex) {
            case 0:
            {
                self.geoLabel.text =@"";
            }
                break;
            case 1:
            {
                GeoViewController *gvc = [[[GeoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                gvc.delegate = self;
                [self.navigationController pushViewController:gvc animated:YES];
            }
                break;
                
            default:
                break;
        }
    } else if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:{
                FloggerCameraControl *cameraControl = [[[FloggerCameraControl alloc] init] autorelease];
                cameraControl.delegate = self;
                cameraControl.statusMode = PHOTOMODE;
                if (self.bcTabBarController) {
                    if ([GlobalUtils checkIOS_6]) {
                        [self.navigationController presentModalViewController:cameraControl animated:YES];
                    } else
                    {
                        [self.bcTabBarController presentModalViewController:cameraControl animated:YES];
                    }                    
                } else {
                    [self presentModalViewController:cameraControl animated:YES];
                }
                
            }
                break;
            case 1:
            {
                UIImagePickerController *pickercontroller = [[[UIImagePickerController alloc] init]autorelease];
                pickercontroller.delegate = self;
                pickercontroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //            pickercontroller.mediaTypes = kUTTypeImage;
                //            pickercontroller.allowsEditing = YES;
                if (self.bcTabBarController) {
                    if ([GlobalUtils checkIOS_6]) {
                        [self.navigationController presentModalViewController:pickercontroller animated:YES];
                    }else
                    {
                        [self.bcTabBarController presentModalViewController:pickercontroller animated:YES];
                    }
                }else {
                    [self presentModalViewController:pickercontroller animated:YES];
                }
            }
                break;
            case 2:
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
                if (self.bcTabBarController) {
                    if ([GlobalUtils checkIOS_6]) {
                        [self.navigationController presentModalViewController:pickercontroller animated:YES];
                    }else
                    {
                        [self.bcTabBarController presentModalViewController:pickercontroller animated:YES];
                    }
                } else {
                    [self presentModalViewController:pickercontroller animated:YES];
                }
                
            }
                break;
        }
    }
   
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


#pragma mark - camera
-(void)floggerCameraControl:(FloggerCameraControl *)cameraControl didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isImportMedia = NO;
    [cameraControl dismissModalViewControllerAnimated:YES];
    self.cameraInfo = info;
    [self transCameraInfo];
   
}

-(void) transCameraInfo
{
    if ([self.cameraInfo objectForKey:fVideoURL]) {
        [self displayVideoImage:[self.cameraInfo objectForKey:fVideoURL]];
    } else if ([self.cameraInfo objectForKey:fImage]){
        [self displayMediaContent:[self.cameraInfo objectForKey:fImage]];
    }
}

-(void) displayVideoImage: (NSURL *) videoURL
{    
    if (self.playerLayer) {
        [self.playerLayer removeFromSuperlayer];
    }
    CGRect mediaFrame = self.mediaContent.frame;    
    CGSize videoSize =  [[self.cameraInfo objectForKey:fCameraInfoVideoSize] CGSizeValue];
    UIImage *playImage = [[FloggerUIFactory uiFactory] createImage:SNS_PLAY];
    
    if (videoSize.width > ComposeMediaViewWidth || videoSize.height > ComposeMediaViewHeight) {
        float wScale = videoSize.width / ComposeMediaViewWidth;
        float hScale = videoSize.height / ComposeMediaViewHeight;
        float scale =  MAX(wScale, hScale);
        self.mediaContent.frame = CGRectMake(mediaFrame.origin.x + (ComposeMediaViewWidth - videoSize.width / scale)/2, mediaFrame.origin.y, videoSize.width / scale, videoSize.height / scale);
    } else {
        self.mediaContent.frame = CGRectMake(mediaFrame.origin.x, mediaFrame.origin.y, mediaFrame.size.width, [self getMediaHeight:videoSize]);
    }
//    self.mediaContent.frame = CGRectMake(mediaFrame.origin.x, mediaFrame.origin.y, mediaFrame.size.width, [self getMediaHeight:videoSize]);
    
    AVPlayer *player = [[[AVPlayer alloc] initWithURL:videoURL] autorelease];
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playLayer.frame = CGRectMake(0, 0, self.mediaContent.frame.size.width, self.mediaContent.frame.size.height);
    //    playLayer.hidden = NO;
    [self.mediaContent.layer addSublayer:playLayer];
    
    [self setPlayerLayer:playLayer];
    
    UIButton *playButton = [[FloggerUIFactory uiFactory] createButton:playImage];//[[[UIImageView alloc] initWithImage:playImage] autorelease];
    int playWidth = 15;
    playButton.frame = CGRectMake(self.mediaContent.frame.size.width/2 - playWidth/2, self.mediaContent.frame.size.height/2-playWidth/2, playWidth, playWidth);
    playButton.userInteractionEnabled = NO;
//    [playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mediaContent addSubview:playButton];
    [self setPlayBtn:playButton];
}


/*-(void) displayVideoImage: (NSURL *) videoURL
{
    CGRect mediaFrame = self.mediaContent.frame;  
    CGSize videoSize =  [[self.cameraInfo objectForKey:fCameraInfoVideoSize] CGSizeValue];
    UIImage *playImage = [[FloggerUIFactory uiFactory] createImage:SNS_PLAY];
    
    self.mediaContent.frame = CGRectMake(mediaFrame.origin.x, mediaFrame.origin.y, mediaFrame.size.width, [self getMediaHeight:videoSize]);
    
    AVPlayer *player = [[[AVPlayer alloc] initWithURL:videoURL] autorelease];
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playLayer.frame = CGRectMake(0, 0, self.mediaContent.frame.size.width, self.mediaContent.frame.size.height);
//    playLayer.hidden = NO;
    [self.mediaContent.layer addSublayer:playLayer];
    
    [self setPlayerLayer:playLayer];
    
    UIButton *playButton = [[FloggerUIFactory uiFactory] createButton:playImage];//[[[UIImageView alloc] initWithImage:playImage] autorelease];
    int playWidth = 15;
    playButton.frame = CGRectMake(ComposeMediaViewWidth/2 - playWidth/2, self.mediaContent.frame.size.height/2-playWidth/2, playWidth, playWidth);
    [playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mediaContent addSubview:playButton];
    [self setPlayBtn:playButton];
}*/

-(void) playVideo
{
    [self.playerLayer.player play]; 
}

-(CGFloat) getMediaHeight : (CGSize) mediaSize
{
//    NSLog(@"media size is %@",[NSValue valueWithCGSize:mediaSize]);
    CGFloat mediaHeight = 0;
    if (mediaSize.width > 0) {
        mediaHeight = mediaSize.height/mediaSize.width * ComposeMediaViewWidth; 
    }    
    return mediaHeight;    
}

-(void)floggerCameraControlDidCancelledPickingMedia:(FloggerCameraControl *)cameraControl
{
    [cameraControl dismissModalViewControllerAnimated:YES];
}

-(void) displayMediaContent:(UIImage *) mediaImage
{
    CGRect mediaFrame = self.mediaContent.frame; 
    
    if (mediaImage.size.width > ComposeMediaViewWidth || mediaImage.size.height > ComposeMediaViewHeight) {
        float wScale = mediaImage.size.width / ComposeMediaViewWidth;
        float hScale = mediaImage.size.height / ComposeMediaViewHeight;
        float scale =  MAX(wScale, hScale);
        self.mediaContent.frame = CGRectMake(mediaFrame.origin.x + (ComposeMediaViewWidth - mediaImage.size.width / scale)/2, mediaFrame.origin.y, mediaImage.size.width / scale, mediaImage.size.height / scale);
    } else {
        self.mediaContent.frame = CGRectMake(mediaFrame.origin.x, mediaFrame.origin.y, mediaFrame.size.width, [self getMediaHeight:mediaImage.size]);
    }
    
    

    if (self.playerLayer) {
        [self.playerLayer setHidden:YES];
        [self.playBtn setHidden:YES];
    }
    [self.mediaContent setImage:mediaImage forState:UIControlStateNormal];
}

-(void)didSelectedAlbumn:(Albuminfo *)albuminfo
{
    [self.navigationController popViewControllerAnimated:YES];
    UIImage *imageFromAlbum = [[DataCache sharedInstance] imageFromKey:albuminfo.thumbnailurl];
    [self displayMediaContent:imageFromAlbum];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    //again to retrieve 
//    self.uploadFileID = [[Guid randomGuid]stringValue];
    
    isImportMedia = YES;
    [picker dismissModalViewControllerAnimated:YES];
    NSMutableDictionary *cameraData = [[[NSMutableDictionary alloc] init] autorelease];
    
    if ([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString: @"public.movie"]) {
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
        
        
                
    } else if ([[info valueForKey:UIImagePickerControllerMediaType]isEqualToString: @"public.image"])
    {
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        //UIImage *adjustSizedImage = image;
        UIImage *resultImage =  image;
        if (image.size.width > 640 || image.size.height>960) {
            float wScale = image.size.width / 640;
            float hScale = image.size.height / 960;
            UIImage *adjustSizedImage = [UIImage imageWithCGImage:image.CGImage scale:MAX(wScale, hScale) orientation:image.imageOrientation];
            resultImage = [self transforNormalizeImage:adjustSizedImage];
        } else {
            resultImage = [self transforNormalizeImage:resultImage];
        }
        
        NSData *imageData = UIImageJPEGRepresentation(resultImage, JPEGQUAILTY);
        
//        NSLog(@"original image size is %@",[NSValue valueWithCGSize:image.size]);
//        NSLog(@"transform image size is %@",[NSValue valueWithCGSize:resultImage.size]);
        NSString *imagePath = [self saveDataToPath:@"image" withData:imageData];
        
        [cameraData setObject:image forKey:fImage];
        [cameraData setObject:[NSValue valueWithCGSize:resultImage.size] forKey:fCameraInfoImageSize];
        
        [cameraData setObject:imagePath forKey:fImagePath];
      
    }
    
    
    self.cameraInfo = cameraData;
    [self transCameraInfo];
    
    
    
}

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
//    tempNum++;    
    return @"";
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    [picker dismissModalViewControllerAnimated:YES];
    
}

//-(void)floggerCameraControl:(FloggerCameraControl *)cameraControl didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    self.image = [info objectForKey:@"image"];
//    [self dismissModalViewControllerAnimated:YES];
//    [messageTV becomeFirstResponder];
//}

-(void)didSelectedTopic:(NSString *)topic
{
    if (topic && topic.length > 0) {
        NSString *preStr = self.messageTV.text;
        self.messageTV.text = [NSString stringWithFormat:@"%@#%@#", preStr, topic];
        [self textViewDidChange:self.messageTV];
    }
}

-(void)geoLocationSelected:(NSString *)location
{
    self.geoLabel.text = location;
}

-(void)didAtSelection:(NSString *)username
{
    if (username && username.length > 0) {
        NSString *preStr = self.messageTV.text;
        self.messageTV.text = [NSString stringWithFormat:@"%@%@ ", preStr, username];
        [self textViewDidChange:self.messageTV];
    }
}

-(void)dealloc
{
//    RELEASE_SAFELY(countLabel);
//    RELEASE_SAFELY(messageTV);
//    RELEASE_SAFELY(actionView);
//    RELEASE_SAFELY(issueinfo);
//    self.geoLabel = nil;
    [self myReleaseSource];
    self.uploadFileID = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFinishServer object:nil];
    [super dealloc];
}

@end
