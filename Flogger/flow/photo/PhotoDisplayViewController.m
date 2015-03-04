/*
 File: PhotoDisplayViewController.m
 Abstract: View controller to manaage displaying a photo.
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import "PhotoDisplayViewController.h"

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5
#define degreesToRadian(x) (M_PI * (x) / 180.0)
@implementation FloggerCenterScrollView
@synthesize touchDelegate;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 1) {
        if(self.touchDelegate && [self.touchDelegate respondsToSelector:@selector(tapOnScroll:)]) 
        {
            [self.touchDelegate  performSelector:@selector(tapOnScroll:) withObject:self];
            //[self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
        }
    }
}
@end
@interface PhotoDisplayViewController (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation PhotoDisplayViewController
@synthesize image, photoImageView, imageUrl, delegate;
@synthesize floggerScrollView;
//@synthesize asset;

-(void) adjustPhotoDisplayViewLayout
{
    
    FloggerCenterScrollView *scrollView = [[[FloggerCenterScrollView alloc]init]autorelease];//[[FloggerUIFactory uiFactory] createScrollView];
    scrollView.touchDelegate = self;
    scrollView.frame = CGRectMake(0, 0, 320, 460);
    scrollView.delegate = self;
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)]autorelease];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
    self.floggerScrollView = scrollView;
    /*scrollView.bouncesZoom = YES;
     UIImageView *imageV = [[FloggerUIFactory uiFactory] createImageView:nil];
     imageV.frame = CGRectMake(0, 0, 320, 460);
     [self.view addSubview:imageV];
     
     scrollView.tileContainerView = imageV;
     [self setPhotoImageView:imageV];*/
    
    
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? 
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? 
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, 
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


-(void) loadView
{
    [self adjustPhotoDisplayViewLayout];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.wantsFullScreenLayout = YES;
    
    
    
    UIScrollView *imageScrollView = self.floggerScrollView;
    //UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBackview)] autorelease];
    //[imageScrollView addGestureRecognizer:tapGesture];
    [imageScrollView setBackgroundColor:[UIColor blackColor]];
    [imageScrollView setDelegate:self];
    [imageScrollView setBouncesZoom:YES];
    
    
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    
    if (interfaceOrientation == UIDeviceOrientationPortrait||interfaceOrientation == UIDeviceOrientationPortraitUpsideDown||interfaceOrientation == UIDeviceOrientationLandscapeLeft||interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        [self receivedRotate];
    } else
        {
            [[imageScrollView viewWithTag:ZOOM_VIEW_TAG] removeFromSuperview];
            
                // add touch-sensitive image view to the scroll view
            TapDetectingImageView *imageView = [[[TapDetectingImageView alloc] initWithImage:self.image] autorelease];
            
            [imageView setDelegate:self];
            [imageView setTag:ZOOM_VIEW_TAG];
            [imageScrollView addSubview:imageView];
            [imageScrollView setContentSize:[imageView frame].size];
            
            
                // choose minimum scale so image width fits screen
            float wminScale  = [imageScrollView frame].size.width  / [imageView frame].size.width;
            float hminScale  = [imageScrollView frame].size.height  / [imageView frame].size.height;
            float minScale=wminScale;//<hminScale?wminScale:hminScale;
            [imageScrollView setMinimumZoomScale:MIN(minScale,hminScale)];
            [imageScrollView setZoomScale:minScale];
            [imageScrollView setContentOffset:CGPointZero];
            [imageScrollView setMaximumZoomScale:2.5];
            
            CGRect imageFrame = imageView.frame;
            imageView.frame = CGRectMake((imageScrollView.frame.size.width - imageFrame.size.width)/2, (imageScrollView.frame.size.height - imageFrame.size.height)/2<0?0:(imageScrollView.frame.size.height - imageFrame.size.height)/2, imageFrame.size.width, imageFrame.size.height);//
            [self setPhotoImageView:imageView];
        }
    
    
       [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receivedRotate) name: UIDeviceOrientationDidChangeNotification object: nil];
    // first remove previous image view, if any
    /*[[imageScrollView viewWithTag:ZOOM_VIEW_TAG] removeFromSuperview];
    
    // add touch-sensitive image view to the scroll view
    TapDetectingImageView *imageView = [[[TapDetectingImageView alloc] initWithImage:self.image] autorelease];
    
    [imageView setDelegate:self];
    [imageView setTag:ZOOM_VIEW_TAG];
    [imageScrollView addSubview:imageView];
    [imageScrollView setContentSize:[imageView frame].size];
    
    
    // choose minimum scale so image width fits screen
    float wminScale  = [imageScrollView frame].size.width  / [imageView frame].size.width;
    float hminScale  = [imageScrollView frame].size.height  / [imageView frame].size.height;
    float minScale=wminScale<hminScale?wminScale:hminScale;
    [imageScrollView setMinimumZoomScale:minScale];
    [imageScrollView setZoomScale:minScale];
    [imageScrollView setContentOffset:CGPointZero];
    [imageScrollView setMaximumZoomScale:2.5];
    
    CGRect imageFrame = imageView.frame;
    imageView.frame = CGRectMake((imageScrollView.frame.size.width - imageFrame.size.width)/2, (imageScrollView.frame.size.height - imageFrame.size.height)/2, imageFrame.size.width, imageFrame.size.height);
    [self setPhotoImageView:imageView];*/
}

-(void) receivedRotate{
    
    /*UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
     if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) { 
     self.view.transform = CGAffineTransformIdentity;
     [self.view viewWithTag:ZOOM_VIEW_TAG].transform = CGAffineTransformIdentity;
     } else {
     CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(degreesToRadian(-90));
     //landscapeTransform = CGAffineTransformScale(landscapeTransform,480/320.0, 320.0/480.0);
     [self.view setTransform:landscapeTransform];
     [self.view viewWithTag:ZOOM_VIEW_TAG].transform = CGAffineTransformScale(CGAffineTransformIdentity, 320.0/480.0 *320.0/480.0,1.0);
     }
     
     return;
     [UIView beginAnimations:@"View Flip" context:nil];
     [UIView setAnimationDuration:1.25];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     
     if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {      
     self.view.transform = CGAffineTransformIdentity;
     self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
     self.view.bounds = CGRectMake(0.0, 0.0, 480, 320);
     } else {
     
     }
     [UIView commitAnimations];
     return;*/
//    NSLog(@"aaaaaaaaaaa");
    
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.wantsFullScreenLayout = YES;
    UIScrollView *imageScrollView = (UIScrollView *)self.floggerScrollView;
//    if (interfaceOrientation == UIInterfaceOrientationPortrait) {      
//        NSLog(@"正");
//        imageScrollView.transform = CGAffineTransformIdentity;
//    }else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
//        NSLog(@"反");
//        imageScrollView.transform = CGAffineTransformIdentity;
//        imageScrollView.transform  = CGAffineTransformMakeRotation(degreesToRadian(-180));
//    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        NSLog(@"左");
//        imageScrollView.transform = CGAffineTransformIdentity;
//        imageScrollView.transform  =CGAffineTransformMakeRotation(degreesToRadian(90));
//        
//    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//        NSLog(@"右");
//        imageScrollView.transform = CGAffineTransformIdentity;
//        imageScrollView.transform  = CGAffineTransformMakeRotation(degreesToRadian(-90));
//    } 
//    else 
//    {
//        NSLog(@"5");
//        [UIView commitAnimations];
//        return;
//    }
    
    
    
    if (interfaceOrientation == UIDeviceOrientationPortrait) {   
        // Device oriented vertically, home button on the bottom
//        NSLog(@"正向垂直");
        imageScrollView.transform = CGAffineTransformIdentity;
    }else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        // Device oriented vertically, home button on the bottom
//        NSLog(@"反向垂直");
        imageScrollView.transform = CGAffineTransformIdentity;
        imageScrollView.transform  = CGAffineTransformMakeRotation(degreesToRadian(-180));
    } else if (interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        // Device oriented vertically, home button on the right
//        NSLog(@"左");
        imageScrollView.transform = CGAffineTransformIdentity;
        imageScrollView.transform  =CGAffineTransformMakeRotation(degreesToRadian(90));
        
    } else if (interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        // Device oriented horizontally, home button on the left
//        NSLog(@"右");
        imageScrollView.transform = CGAffineTransformIdentity;
        imageScrollView.transform  = CGAffineTransformMakeRotation(degreesToRadian(-90));
   
    } else /*if (  interfaceOrientation == UIDeviceOrientationFaceUp 
               ||interfaceOrientation == UIDeviceOrientationFaceDown 
               ||interfaceOrientation == UIDeviceOrientationUnknown)*/ {
        // Device oriented flat, face up ,face down
        NSLog(@"face up || FaceDown || Unknown");
        [UIView commitAnimations];
        return;
                               
    } 


    [UIView commitAnimations];
    CGRect newRect=CGRectMake(0, 0, 480, 320);
    if (interfaceOrientation != UIDeviceOrientationPortrait && interfaceOrientation != UIDeviceOrientationPortraitUpsideDown) { 
        //imageScrollView.transform = CGAffineTransformScale(imageScrollView.transform,480/320.0, 320.0/480.0);
        imageScrollView.frame = CGRectMake(0, 0, 320, 480);
        //NSLog(@"=====%@",[NSValue valueWithCGRect:imageScrollView.frame]);
    } else {
        imageScrollView.frame = CGRectMake(0, 0, 320, 480);
        newRect=CGRectMake(0, 0, 320, 480);
        //NSLog(@"=====%@",[NSValue valueWithCGRect:imageScrollView.frame]);  
    }
    
    //        [imageScrollView setBackgroundColor:[UIColor blackColor]];
    //        [imageScrollView setDelegate:self];
    //        [imageScrollView setBouncesZoom:YES];
    // first remove previous image view, if any
    [[imageScrollView viewWithTag:ZOOM_VIEW_TAG] removeFromSuperview];
    
    // add touch-sensitive image view to the scroll view
    TapDetectingImageView *imageView = [[[TapDetectingImageView alloc] initWithImage:self.image] autorelease];
    [imageView setDelegate:self];
    [imageView setTag:ZOOM_VIEW_TAG];
    [imageScrollView addSubview:imageView];
    [imageScrollView setContentSize:[imageView frame].size];
    // choose minimum scale so image width fits screen
    float wminScale  = newRect.size.width  / [imageView frame].size.width;
    float hminScale  = newRect.size.height  / [imageView frame].size.height;
    float minScale=wminScale;//<hminScale?wminScale:hminScale;
    [imageScrollView setMinimumZoomScale:MIN(minScale,hminScale)];
    [imageScrollView setZoomScale:minScale];
    [imageScrollView setContentOffset:CGPointZero];
    [imageScrollView setMaximumZoomScale:2.5];
    
    CGRect imageFrame = imageView.frame;
    imageView.frame = CGRectMake((newRect.size.width - imageFrame.size.width)/2, (newRect.size.height - imageFrame.size.height)/2<0?0:(newRect.size.height - imageFrame.size.height)/2, imageFrame.size.width, imageFrame.size.height);//(newRect.size.height - imageFrame.size.height)/2
    
    [self setPhotoImageView:imageView];
    
    
}
/*
 - (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
 {
 NSLog(@"willlllllll");
 }
 
 - (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
 {
 NSLog(@"didddddddd");
 }
 
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
 {
 return YES;
 }
 */

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [(UIScrollView *)self.floggerScrollView viewWithTag:ZOOM_VIEW_TAG];
}


#pragma mark -
#pragma mark TapDetectingImageViewDelegate methods

//-(void)removeShowView
//{
//    [NSThread sleepForTimeInterval:1];
//    [self.view removeFromSuperview];
//}
-(void)tapOnScroll:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissDisplayView)]) {
        [self.delegate dismissDisplayView];
    }  
}
- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
    // single tap does nothing for now
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissDisplayView)]) {
        [self.delegate dismissDisplayView];
    }
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
    UIScrollView *imageScrollView = (UIScrollView *)self.floggerScrollView;
    // double tap zooms in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    
//    UIScrollView *imageScrollView = (UIScrollView *)self.floggerScrollView;
//    // two-finger tap zooms out
//    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
//    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
//    [imageScrollView zoomToRect:zoomRect animated:YES];
}


#pragma mark -
#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    UIScrollView *imageScrollView = (UIScrollView *)self.floggerScrollView;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    //CGRect imageFrame = self.photoImageView.frame;
    //self.photoImageView.frame = CGRectMake((imageScrollView.frame.size.width - imageFrame.size.width)/2, (imageScrollView.frame.size.height - imageFrame.size.height)/2, imageFrame.size.width, imageFrame.size.height);
    
    return zoomRect;
}

-(void)unregisterNotification
{
      [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];  
}
- (void)dealloc {
    [self unregisterNotification];
    //    self.view
    self.image = nil;
    self.floggerScrollView.delegate = nil;
    self.floggerScrollView  = nil;
    self.delegate = nil;
    self.photoImageView.delegate = nil;
    self.photoImageView = nil;
    self.imageUrl = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskAll;
}

@end

