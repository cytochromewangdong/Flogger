/*
 
 File: MyMovieViewController.m 
 Abstract:  A UIViewController controller subclass that implements a movie playback view.
 Uses a MyMovieController object to control playback of a movie.
 Adds and removes an overlay view to the view hierarchy. Handles button presses to the
 'Close Movie' button in the overlay view.
 Adds and removes a background view to hide any underlying user interface controls when playing a movie.
 Gets user movie settings preferences by calling the MoviePlayerUserPref methods. Apply these settings to the movie with the MyMovieController singleton.
 
 Version: 1.4 
 
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

#import "MyMovieViewController.h"
//#import "MoviePlayerUserPrefs.h"

CGFloat kMovieViewOffsetX = 20.0;
CGFloat kMovieViewOffsetY = 20.0;

@interface MyMovieViewController (OverlayView)

-(void)addOverlayView;
-(void)removeOverlayView;
-(void)resizeOverlayWindow;

@end

@interface MyMovieViewController(MovieControllerInternal)
-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType;
-(void)applyUserSettingsToMoviePlayer;
-(void)moviePlayBackDidFinish:(NSNotification*)notification;
-(void)loadStateDidChange:(NSNotification *)notification;
-(void)moviePlayBackStateDidChange:(NSNotification*)notification;
-(void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification;
-(void)installMovieNotificationObservers;
-(void)removeMovieNotificationHandlers;
-(void)deletePlayerAndNotificationObservers;
@end

@interface MyMovieViewController (ViewController)
-(void)removeMovieViewFromViewHierarchy;
@end

@implementation MyMovieViewController(ViewController)

#pragma mark View Controller

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
//    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    
    
    CGSize size = self.view.frame.size;
    CGRect newRect;
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                newRect = CGRectMake(0, 0, MIN(size.width, size.height), MAX(size.width, size.height));
    } else {
                newRect = CGRectMake(0, 0, MAX(size.width, size.height), MIN(size.width, size.height));
    }
    [UIView animateWithDuration:duration animations:^{
        self.moviePlayerController.view.frame = newRect;
        self.activityIndicator.center = self.moviePlayerController.view.center;
    }];
}

/* Sent to the view controller after the user interface rotates. */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	/* Size movie view to fit parent view. */
    //	CGRect viewInsetRect = CGRectInset ([self.view bounds],
    //										kMovieViewOffsetX,
    //										kMovieViewOffsetY );
    //	[[[self moviePlayerController] view] setFrame:viewInsetRect];
    //[UIView beginAnimations:nil context:nil];
    
    /*CGRect viewInsetRect = CGRectInset ([self.view bounds],
										0,
										0 );
	[[[self moviePlayerController] view] setFrame:viewInsetRect];*/
    //    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    [UIView setAnimationDuration:1000];
    //[UIView commitAnimations];
    
    //    self.moviePlayerController.view.frame = CGRectMake(0, 0, 320, 460);
    
    /* Size the overlay view for the current orientation. */
	//[self resizeOverlayWindow];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    /* Return YES for supported orientations. */
    return YES;
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

-(void) closeMovieAction
{
    if (self.moviePlayerController.playbackState != MPMoviePlaybackStateStopped) {
        [self.moviePlayerController stop];
    }    
    [self removeMovieViewFromViewHierarchy];
    [self removeOverlayView];
//    [self.backgroundView removeFromSuperview];
    [self deletePlayerAndNotificationObservers];
    
//    [self dismissModalViewControllerAnimated:YES];
    [self.moviePlayerController.view removeFromSuperview];
    self.moviePlayerController = nil;
    
//    if (self.movieDelegate && [self.movieDelegate respondsToSelector:@selector(myMoviewFinish:)]) {
//        
//        [self.movieDelegate myMoviewFinish:self];
//    }
    
}

-(void) closeViewControl
{
    if (_isFailToLoad) {
        [self closeMovieAction];
    }
}


-(void) loadView
{
    UIView *view = [[[UIView alloc] init] autorelease];
    //    view.backgroundColor = [UIColor whiteColor];
    view.frame = viewFrame;//CGRectMake(0, 0, 320, 480);
    self.view = view;
    self.wantsFullScreenLayout = YES;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    _isFailToLoad = YES;
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(closeViewControl) userInfo:nil repeats:NO];
    
//    UILongPressGestureRecognizer *longGesture = [[[UILongPressGestureRecognizer alloc] init] autorelease];
//    [longGesture addTarget:self action:@selector(closeViewControl)];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self deletePlayerAndNotificationObservers];
    
    [super viewDidUnload];
}

/* Notifies the view controller that its view is about to be become visible. */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /* Size the overlay view for the current orientation. */
	//[self resizeOverlayWindow];
    /* Update user settings for the movie (in case they changed). */
    //[self applyUserSettingsToMoviePlayer];
    //test
    //    [self.moviePlayerController play];
}

/* Notifies the view controller that its view is about to be dismissed, 
 covered, or otherwise hidden from view. */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* Remove the movie view from the current view hierarchy. */
	[self removeMovieViewFromViewHierarchy];
    /* Removie the overlay view. */
	[self removeOverlayView];
    /* Remove the background view. */
//	[self.backgroundView removeFromSuperview];
    
    /* Delete the movie player object and remove the notification observers. */
    [self deletePlayerAndNotificationObservers];
}

- (void)dealloc 
{	
    self.activityIndicator = nil;
    
    [self setMoviePlayerController:nil];
    //    self.imageView = nil;
//    self.movieBackgroundImageView = nil;
//    self.backgroundView = nil;
    self.overlayController = nil;
    
    [super dealloc];
}

/* Remove the movie view from the view hierarchy. */
-(void)removeMovieViewFromViewHierarchy
{
    MPMoviePlayerController *player = [self moviePlayerController];
    
	[player.view removeFromSuperview];
}

#pragma mark Error Reporting

-(void)displayError:(NSError *)theError
{
	if (theError)
	{
		UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: [theError localizedDescription]
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.delegate = self;
		[alert show];
		[alert release];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self closeMovieAction];
}

@end

#pragma mark -
@implementation MyMovieViewController (OverlayView)


/* Add an overlay view on top of the movie. This view will display movie
 play states and includes a 'Close Movie' button. */
-(void)addOverlayView
{
    MPMoviePlayerController *player = [self moviePlayerController];
    
    if (!([self.overlayController.view isDescendantOfView:self.view])
        && ([player.view isDescendantOfView:self.view])) 
    {
        // add an overlay view to the window view hierarchy
//        [self.view addSubview:self.overlayController.view];
    }
}

/* Remove overlay view from the view hierarchy. */
-(void)removeOverlayView
{
//	[self.overlayController.view removeFromSuperview];
}

-(void)resizeOverlayWindow
{
	CGRect frame = self.overlayController.view.frame;
	frame.origin.x = round((self.view.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = round((self.view.frame.size.height - frame.size.height) / 2.0);
	self.overlayController.view.frame = frame;
}

@end

#pragma mark -
@implementation MyMovieViewController

@synthesize moviePlayerController;

//@synthesize imageView;
//@synthesize movieBackgroundImageView;
//@synthesize backgroundView;
@synthesize overlayController;
@synthesize movieDelegate,activityIndicator;
@synthesize cellView;

//@synthesize appDelegate;

-(void) iniViewFrame : (CGRect) testViewFrame
{
    viewFrame = testViewFrame;
}

/* Action method for the overlay view 'Close Movie' button.
 Remove the movie view and overlay view from the window,
 dispose the movie object and remove the notification
 handlers. */
-(void)overlayViewCloseButtonPress:(id)sender
{
	[[self moviePlayerController] stop];
    
	[self removeMovieViewFromViewHierarchy];
    
	[self removeOverlayView];
//	[self.backgroundView removeFromSuperview];
    
    [self deletePlayerAndNotificationObservers];
}

/*  
 Called by the MoviePlayerAppDelegate (UIApplicationDelegate protocol) 
 applicationWillEnterForeground when the app is about to enter
 the foreground.
 */
- (void)viewWillEnterForeground
{
	/* Set the movie object settings (control mode, background color, and so on) 
     in case these changed. */
	[self applyUserSettingsToMoviePlayer];
}

#pragma mark Play Movie Actions

/* Called soon after the Play Movie button is pressed to play the local movie. */
-(void)playMovieFile:(NSURL *)movieFileURL
{
    [self createAndPlayMovieForURL:movieFileURL sourceType:MPMovieSourceTypeFile];   
}

/* Called soon after the Play Movie button is pressed to play the streaming movie. */
-(void)playMovieStream:(NSURL *)movieFileURL
{
    MPMovieSourceType movieSourceType = MPMovieSourceTypeUnknown;
    /* If we have a streaming url then specify the movie source type. */
    if ([[movieFileURL pathExtension] compare:@"m3u8" options:NSCaseInsensitiveSearch] == NSOrderedSame) 
    {
        movieSourceType = MPMovieSourceTypeStreaming;
    }
    [self createAndPlayMovieForURL:movieFileURL sourceType:movieSourceType];   
}

@end

#pragma mark -
#pragma mark Movie Player Controller Methods
#pragma mark -

@implementation MyMovieViewController (MovieControllerInternal)

#pragma mark Create and Play Movie URL

/*
 Create a MPMoviePlayerController movie object for the specified URL and add movie notification
 observers. Configure the movie object for the source type, scaling mode, control style, background
 color, background image, repeat mode and AirPlay mode. Add the view containing the movie content and 
 controls to the existing view hierarchy.
 */
-(void)createAndConfigurePlayerWithURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType 
{    
    /* Create a new movie player object. */
    MPMoviePlayerController *player = [[[MPMoviePlayerController alloc] initWithContentURL:movieURL] autorelease];
    
    if (player) 
    {
        /* Save the movie object. */
        [self setMoviePlayerController:player];
        
        /* Register the current object as an observer for the movie
         notifications. */
        [self installMovieNotificationObservers];
        
        /* Specify the URL that points to the movie file. */
        [player setContentURL:movieURL];        
        
        /* If you specify the movie type before playing the movie it can result 
         in faster load times. */
        [player setMovieSourceType:sourceType];
        
        /* Apply the user movie preference settings to the movie player object. */
        [self applyUserSettingsToMoviePlayer];
        
        /* Add a background view as a subview to hide our other view controls 
         underneath during movie playback. */
        //        [self.view addSubview:self.backgroundView];
        
        //        CGRect viewInsetRect = CGRectInset ([self.view bounds],
        //                                            kMovieViewOffsetX,
        //                                            kMovieViewOffsetY );
        /* Inset the movie frame in the parent view frame. */
        //        [[player view] setFrame:viewInsetRect];
        
        //        [player view].backgroundColor = [UIColor lightGrayColor];
        
        
        
        /* To present a movie in your application, incorporate the view contained 
         in a movie player’s view property into your application’s view hierarchy. 
         Be sure to size the frame correctly. */
        
        player.view.frame = viewFrame;//CGRectMake(0, 0, 320, 480);
        
    
        UIActivityIndicatorView *activityIndicatorTemp = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
        activityIndicatorTemp.center = player.view.center;
        activityIndicatorTemp.hidesWhenStopped = YES;
//        [activityIndicatorTemp startAnimating];
        [self setActivityIndicator:activityIndicatorTemp];
        [player.view addSubview:activityIndicatorTemp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator startAnimating];
        });
        
        [self.view addSubview: [player view]];        
//        [self.view.window addSubview:[player view]];
    } else {
        [self closeMovieAction];
    }
    UILongPressGestureRecognizer *longGesture = [[[UILongPressGestureRecognizer alloc] init] autorelease];
    longGesture.minimumPressDuration = 1.5;
    [longGesture addTarget:self action:@selector(closeMovieAction)];
    [player.view addGestureRecognizer:longGesture];
}

/* Load and play the specified movie url with the given file type. */
-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    [self createAndConfigurePlayerWithURL:movieURL sourceType:sourceType];
    
    //test begin
    //    self.moviePlayerController.view.frame = CGRectMake(0, 0, 320, 480);
    //test end
    /* Play the movie! */
    [self.moviePlayerController prepareToPlay];
    [[self moviePlayerController] play];
}

#pragma mark Movie Notification Handlers

/*  Notification called when the movie finished playing. */
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]; 
	switch ([reason integerValue]) 
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
            //            [self dismissModalViewControllerAnimated:NO];
//            [self.moviePlayerController pause];
//            [self.moviePlayerController ]
//            [self closeMovieAction];
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
//            NSLog(@"An error was encountered during playback");
            [self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:@"error"] 
                                waitUntilDone:NO];
//            [self removeMovieViewFromViewHierarchy];
//            [self removeOverlayView];
//            [self.backgroundView removeFromSuperview];
            
			break;
            
            /* The user stopped playback. */
		case MPMovieFinishReasonUserExited:
//            [self removeMovieViewFromViewHierarchy];
//            [self removeOverlayView];
//            [self.backgroundView removeFromSuperview];
            //close
            [self closeMovieAction];
			break;
            
		default:
			break;
	}
    [self.moviePlayerController setFullscreen:NO animated:NO];
}

/* Handle movie load state changes. */
- (void)loadStateDidChange:(NSNotification *)notification 
{   
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;	
    
	/* The load state is not known at this time. */
	if (loadState & MPMovieLoadStateUnknown)
	{
        [self.overlayController setLoadStateDisplayString:@"n/a"];
        
        [overlayController setLoadStateDisplayString:@"unknown"];
//        NSLog(@"loadstate is unknown");
        [self closeMovieAction];
	}
	
	/* The buffer has enough data that playback can begin, but it 
	 may run out of data before playback finishes. */
	if (loadState & MPMovieLoadStatePlayable)
	{
        [overlayController setLoadStateDisplayString:@"playable"];
//        NSLog(@"loadstate is playable");
        if (self.cellView) {
            FloggerViewAdpater *videoplay = [self.cellView.mainview getAdpaterByName:@"photo"];
            FloggerImageView * playView = (FloggerImageView *) videoplay.view;
            
            [playView addSubview:self.view];
            [self.cellView restoreNormalState];
        }
        
//        [self activityIndicatorAnimate:0];
	}
	
	/* Enough data has been buffered for playback to continue uninterrupted. */
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
        // Add an overlay view on top of the movie view
        [self addOverlayView];
//        NSLog(@"loadstate is playthrough");
        
        [overlayController setLoadStateDisplayString:@"playthrough ok"];
	}
	
	/* The buffering of data has stalled. */
	if (loadState & MPMovieLoadStateStalled)
	{
//        NSLog(@"loadstate is StateStalled");
        [overlayController setLoadStateDisplayString:@"stalled"];
//        [self activityIndicatorAnimate:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.activityIndicator) {
                [self.activityIndicator stopAnimating];
                [self.activityIndicator removeFromSuperview];
            }

        });

	}
}

/* Called when the movie playback state has changed. */
- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    
	/* Playback is currently stopped. */
	if (player.playbackState == MPMoviePlaybackStateStopped) 
	{
//        NSLog(@"play back is stop");
        [overlayController setPlaybackStateDisplayString:@"stopped"];
	}
	/*  Playback is currently under way. */
	else if (player.playbackState == MPMoviePlaybackStatePlaying) 
	{
//        NSLog(@"play back is playing");
        [overlayController setPlaybackStateDisplayString:@"playing"];
        _isFailToLoad = NO;
	}
	/* Playback is currently paused. */
	else if (player.playbackState == MPMoviePlaybackStatePaused) 
	{
//        NSLog(@"play back is paused");
        [overlayController setPlaybackStateDisplayString:@"paused"];
	}
	/* Playback is temporarily interrupted, perhaps because the buffer 
	 ran out of content. */
	else if (player.playbackState == MPMoviePlaybackStateInterrupted) 
	{
//        NSLog(@"play back is interrupted");
        
        [overlayController setPlaybackStateDisplayString:@"interrupted"];
	}
}

/* Notifies observers of a change in the prepared-to-play state of an object 
 conforming to the MPMediaPlayback protocol. */
- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
	// Add an overlay view on top of the movie view
//    NSLog(@"media is prepared");
    [self addOverlayView];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.activityIndicator)
        {
            [self.activityIndicator stopAnimating];
        }        
    });
    
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = [self moviePlayerController];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(loadStateDidChange:) 
                                                 name:MPMoviePlayerLoadStateDidChangeNotification 
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(mediaIsPreparedToPlayDidChange:) 
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification 
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackStateDidChange:) 
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification 
                                               object:player];   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationHandlers
{    
    MPMoviePlayerController *player = [self moviePlayerController];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:nil];
}


- (void)willEnterFullscreen:(NSNotification*)notification {
//    NSLog(@"willEnterFullscreen");
}

- (void)enteredFullscreen:(NSNotification*)notification {
//    NSLog(@"enteredFullscreen");
}

- (void)willExitFullscreen:(NSNotification*)notification {
//    NSLog(@"willExitFullscreen");
    
}

- (void)exitedFullscreen:(NSNotification*)notification {
    NSLog(@"exitedFullscreen");
//    [self stopVideo:notification];
    
    [self closeMovieAction];
    
}

/* Delete the movie player object, and remove the movie notification observers. */
-(void)deletePlayerAndNotificationObservers
{
    [self removeMovieNotificationHandlers];
    [self setMoviePlayerController:nil];
}

#pragma mark Movie Settings

/* Apply user movie preference settings (these are set from the Settings: iPhone Settings->Movie Player)
 for scaling mode, control style, background color, repeat mode, application audio session, background
 image and AirPlay mode. 
 */
-(void)applyUserSettingsToMoviePlayer
{
    MPMoviePlayerController *player = [self moviePlayerController];
    if (player) 
    {
        //        player.scalingMode = [MoviePlayerUserPrefs scalingModeUserSetting];
        //        player.controlStyle =[MoviePlayerUserPrefs controlStyleUserSetting];	
        ////        player.backgroundView.backgroundColor = [MoviePlayerUserPrefs backgroundColorUserSetting];
        //        player.repeatMode = [MoviePlayerUserPrefs repeatModeUserSetting];
        //        player.useApplicationAudioSession = [MoviePlayerUserPrefs audioSessionUserSetting];
        //        if ([MoviePlayerUserPrefs backgroundImageUserSetting] == YES)
        //        {
        //            [self.movieBackgroundImageView setFrame:[self.view bounds]];
        //            [player.backgroundView addSubview:self.movieBackgroundImageView];
        //        }
        //        else
        //        {
        //            [self.movieBackgroundImageView removeFromSuperview];
        //        }
        //        player.backgroundView.backgroundColor = [UIColor blackColor];
        player.scalingMode = MPMovieScalingModeAspectFit;
        player.controlStyle = MPMovieControlStyleEmbedded;//MPMovieControlStyleFullscreen;
//        player.controlStyle = MPMovieControlStyleNone;
//        player.loadS = MPMovieLoadStatePlayable;
//        player.fullscreen = YES;
        //        player.repeatMode = MPMovieRepeatModeNone;
        //        player.useApplicationAudioSession = YES;
        /* Indicate the movie player allows AirPlay movie playback. */
        player.allowsAirPlay = YES;        
    }
}

//- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated
//{
//    
//}

//-(void)activityIndicatorAnimate :(int)action
//{
//    if (action == 0) {
//        /* STOP ANIMATING ACTIVITY INDICATOR */        
//        if (activityIndicator != nil) {
//            [[self navigationItem] setRightBarButtonItem:nil];
//            [activityIndicator stopAnimating];
//            [activityIndicator release];
//            activityIndicator = nil;
//        }
//        NSLog(@"Stop activityIndicator");
//    } else if (action == 1) {
//        /* START ANIMATING ACTIVITY INDICATOR */
//        if (activityIndicator == nil) {
//            activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//            UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
//            [[self navigationItem] setRightBarButtonItem:barButton];            
//            [barButton release];
//            NSLog(@"Start activityIndicator");
//        }
//        
//        [activityIndicator startAnimating];
//    }
//    
//}


@end



