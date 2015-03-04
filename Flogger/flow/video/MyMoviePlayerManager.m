//
//  MyMoviePlayerManager.m
//  Flogger
//
//  Created by wyf on 12-8-3.
//  Copyright (c) 2012年 atoato. All rights reserved.
//

#import "MyMoviePlayerManager.h"
#import "MyRotateMovieViewController.h"
#import "UIViewController+iconImage.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)


@implementation MyMoviePlayerManager
@synthesize moviePlayerController;
@synthesize cellView;
@synthesize currentViewController;
@synthesize moviePlayViewController;
@synthesize isEnterFullScreen;
//@synthesize isClose;

static MyMoviePlayerManager *myMoviePlayerController;


-(void) dealloc
{
    
    self.moviePlayerController = nil;
    self.cellView = nil;
    self.currentViewController = nil;
    self.moviePlayerController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self removeMovieNotificationHandlers];
    [super dealloc];
}
//-(void) init
- (id)init
{
    [super init];
    
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receivedRotate) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    return self;
}

-(void) closeMovieAction
{
    [self deletePlayerAndNotificationObservers];
    [self.moviePlayerController.view removeFromSuperview];
    self.moviePlayerController = nil;
    
    //test start
    [[self.moviePlayerController.view superview] removeFromSuperview];
    //test end
    FloggerViewAdpater *videoplay = [self.cellView.mainview getAdpaterByName:@"photo"];
    FloggerImageView * playView = (FloggerImageView *) videoplay.view;
    [[playView viewWithTag:kTableViewVideoTag] removeFromSuperview];
    
    
    //reload
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadTableView object:nil];
    
} 
-(void)deletePlayerAndNotificationObservers
{
    [self removeMovieNotificationHandlers];
    [self setMoviePlayerController:nil];
}

-(void) receivedRotate
{
    CGSize size = self.moviePlayerController.view.frame.size;//self.view.frame.size;
    CGRect newRect;
//    UIInterfaceOrientation toInterfaceOrientation = [UIDevice]
    UIDeviceOrientation toInterfaceOrientation = [[UIDevice currentDevice] orientation];

    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        newRect = CGRectMake(0, 0, MIN(size.width, size.height), MAX(size.width, size.height));
    } else {
        newRect = CGRectMake(0, 0, MAX(size.width, size.height), MIN(size.width, size.height));
    }
    NSTimeInterval duration = 0.001;
    [UIView animateWithDuration:duration animations:^{
        //self.moviePlayerController.view.frame = newRect;
        //self.moviePlayerController.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
//        self.activityIndicator.center = self.moviePlayerController.view.center;
    }];
    
}

+(MyMoviePlayerManager *) getMyMoviePlayerManager
{
    if(!myMoviePlayerController)
    {
        myMoviePlayerController =  [[MyMoviePlayerManager alloc]init];
        [myMoviePlayerController installMovieNotificationObservers];
    }
    if (myMoviePlayerController.moviePlayerController.playbackState != MPMoviePlaybackStateStopped && !myMoviePlayerController.isEnterFullScreen) {
//        myMoviePlayerController.isClose = YES;
        [myMoviePlayerController.moviePlayerController stop];
        [myMoviePlayerController.moviePlayerController.view removeFromSuperview];
        
    }
    //[myMoviePlayerController installMovieNotificationObservers];
    return myMoviePlayerController;
}

+(void) restoreMyMoviePlayerManager
{
//    NSLog(@"=== restore myMovie ===");
//    myMoviePlayerController.isClose = YES;
    if (myMoviePlayerController && myMoviePlayerController.moviePlayerController) {
//        NSLog(@"=== restore myMovie ===");
        [myMoviePlayerController.moviePlayerController stop];
        [myMoviePlayerController.moviePlayerController.view removeFromSuperview];
        myMoviePlayerController.moviePlayerController = nil;
//        myMoviePlayerController.isClose = YES;
    }

}

//-(void) getMoviePlayer : (CGRect ) playFrame WithURL :(NSURL *) videoURL
//{
//    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
//    moviePlayer.view.frame = playFrame;
//    
//    
//}
-(void) iniViewFrame : (CGRect) testViewFrame
{
    viewFrame = testViewFrame;
}

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
/* Load and play the specified movie url with the given file type. */
-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
//    NSLog(@"== begin play video == ");
    [self createAndConfigurePlayerWithURL:movieURL sourceType:sourceType];
    
    //test begin
    //    self.moviePlayerController.view.frame = CGRectMake(0, 0, 320, 480);
    //test end
    /* Play the movie! */
//    self.isClose = NO;
    [self.moviePlayerController prepareToPlay];
    [[self moviePlayerController] play];
//    NSLog(@"== end play video == ");
}

-(void)createAndConfigurePlayerWithURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{    
//    self.isClose = NO;
    /* Create a new movie player object. */
    MPMoviePlayerController *player = [[[MPMoviePlayerController alloc] initWithContentURL:movieURL] autorelease];
    
    if (player) 
    {
        /* Save the movie object. */
        [self setMoviePlayerController:player];
        
        /* Register the current object as an observer for the movie
         notifications. */
//        [self installMovieNotificationObservers];
        
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
        
//        [self.cellView addSubview:player.view];
//        [self.view addSubview: [player view]];        
        //        [self.view.window addSubview:[player view]];
    } else {
        [self closeMovieAction];
    }
//    UILongPressGestureRecognizer *longGesture = [[[UILongPressGestureRecognizer alloc] init] autorelease];
//    longGesture.minimumPressDuration = 1.5;
//    [longGesture addTarget:self action:@selector(closeMovieAction)];
//    [player.view addGestureRecognizer:longGesture];
}
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
    /*MPMoviePlayerController *player = [self moviePlayerController];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:nil];*/
}


- (void)willEnterFullscreen:(NSNotification*)notification {
//    NSLog(@"willEnterFullscreen");
//    MyRotateMovieViewController *playerView = [[[MyRotateMovieViewController alloc]init] autorelease];
////   [self.moviePlayerController.view removeFromSuperview];
//    [playerView setView:self.moviePlayerController.view];
//    
//    self.moviePlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.moviePlayViewController = playerView;
//    
//    //[self.moviePlayerController.view removeFromSuperview];
//    [[self.currentViewController bcTabBarController] presentModalViewController:playerView animated:NO];
//    [self.moviePlayerController.view removeFromSuperview];
    isEnterFullScreen = YES;
    if (![GlobalUtils checkIOS_6]) {
        [self showPlayer];
    }
    
//    [self performSelector:@selector(showPlayer) withObject:nil afterDelay:0.5];
}

- (void)showPlayer {
    MyRotateMovieViewController *playerView = [[[MyRotateMovieViewController alloc]init] autorelease];
    //[self.moviePlayerController.view removeFromSuperview];
    [playerView setView:self.moviePlayerController.view];
    
    self.moviePlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.moviePlayViewController = playerView;
    
//    NSLog(@"=====  autoresize superview class frame is %@",[NSValue valueWithCGRect:self.moviePlayerController.view.frame]);
    //[self.moviePlayerController.view removeFromSuperview];
    [[self.currentViewController bcTabBarController] presentModalViewController:playerView animated:NO];
}

- (void)enteredFullscreen:(NSNotification*)notification {
//    NSLog(@"enteredFullscreen");
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRotateIndicate];
//    NSLog(@"======= superview class is %@",[[self.moviePlayerController.view superview] class]);
//    NSLog(@"===== superview class frame is %@",[NSValue valueWithCGRect:self.moviePlayerController.view.frame]);
//    
//    [self performSelector:@selector(showPlayer) withObject:nil afterDelay:0.5];
//    [self showPlayer];
}

- (void)willExitFullscreen:(NSNotification*)notification {
//    NSLog(@"willExitFullscreen");
//    [self closeMovieAction];
    if (![GlobalUtils checkIOS_6]) {
        if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePlaying) {
            [self.moviePlayerController pause];
        }
        
        [self.moviePlayViewController dismissModalViewControllerAnimated:YES];
        self.moviePlayViewController = nil;
        self.moviePlayerController = nil;
        isEnterFullScreen = NO;
        [self closeMovieAction];
    } else
    {
        isEnterFullScreen = NO;
//        [self closeMovieAction];
    }
    
}

- (void)exitedFullscreen:(NSNotification*)notification {
//    NSLog(@"exitedFullscreen");
    //    [self stopVideo:notification];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRotateIndicate];
    [self closeMovieAction];
    
}

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

/*  Notification called when the movie finished playing. */
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
//    NSLog(@"moviePlayBackDidFinish");
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
            //[self closeMovieAction];
            if (self.moviePlayerController.isFullscreen) {
                [self.moviePlayerController setFullscreen:NO animated:NO];
            } else {
                [self closeMovieAction];
            }            
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
            //[self closeMovieAction];
            [self.moviePlayerController setFullscreen:NO animated:NO];
			break;
            
		default:
			break;
	}
    
}

/* Handle movie load state changes. */
- (void)loadStateDidChange:(NSNotification *)notification 
{   
//    NSLog(@"loadstate did change");
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;	
    
	/* The load state is not known at this time. */
	if (loadState & MPMovieLoadStateUnknown)
	{
//        [self.overlayController setLoadStateDisplayString:@"n/a"];
//        
//        [overlayController setLoadStateDisplayString:@"unknown"];
        //        NSLog(@"loadstate is unknown");
        [self closeMovieAction];
	}
	
	/* The buffer has enough data that playback can begin, but it 
	 may run out of data before playback finishes. */
	if (loadState & MPMovieLoadStatePlayable)
	{
//        [overlayController setLoadStateDisplayString:@"playable"];
//                NSLog(@"loadstate is playable");
//        if (self.isClose) {
////            [self closeMovieAction];
//            [self.moviePlayerController stop];
//            [self.moviePlayerController.view removeFromSuperview];
//            self.isClose = NO;
//            return;
//        }
        if (self.cellView && !self.moviePlayerController.isFullscreen) {
            FloggerViewAdpater *videoplay = [self.cellView.mainview getAdpaterByName:@"photo"];
            FloggerImageView * playView = (FloggerImageView *) videoplay.view;
            if (![playView viewWithTag:kTableViewVideoTag]) {
                self.moviePlayerController.view.tag = kTableViewVideoTag;
                [playView addSubview:self.moviePlayerController.view];
                [self.cellView restoreNormalState];
            }
            
        }
        
        //        [self activityIndicatorAnimate:0];
	}
	
	/* Enough data has been buffered for playback to continue uninterrupted. */
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
        // Add an overlay view on top of the movie view
//        [self addOverlayView];
        //        NSLog(@"loadstate is playthrough");
        
//        [overlayController setLoadStateDisplayString:@"playthrough ok"];
	}
	
	/* The buffering of data has stalled. */
	if (loadState & MPMovieLoadStateStalled)
	{
        //        NSLog(@"loadstate is StateStalled");
//        [overlayController setLoadStateDisplayString:@"stalled"];
        
	}
}

/* Called when the movie playback state has changed. */
- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
//     NSLog(@"moviePlayBackStateDidChange");
	MPMoviePlayerController *player = notification.object;
    
	/* Playback is currently stopped. */
	if (player.playbackState == MPMoviePlaybackStateStopped) 
	{
        //        NSLog(@"play back is stop");
//        [overlayController setPlaybackStateDisplayString:@"stopped"];
	}
	/*  Playback is currently under way. */
	else if (player.playbackState == MPMoviePlaybackStatePlaying) 
	{
        //        NSLog(@"play back is playing");
//        [overlayController setPlaybackStateDisplayString:@"playing"];
//        _isFailToLoad = NO;
	}
	/* Playback is currently paused. */
	else if (player.playbackState == MPMoviePlaybackStatePaused) 
	{
        //        NSLog(@"play back is paused");
//        [overlayController setPlaybackStateDisplayString:@"paused"];
//        NSLog(@"=====  pause superview class is %@",[[self.moviePlayerController.view superview] class]);
//        NSLog(@"=====  pause superview class frame is %@",[NSValue valueWithCGRect:self.moviePlayerController.view.frame]);
	}
	/* Playback is temporarily interrupted, perhaps because the buffer 
	 ran out of content. */
	else if (player.playbackState == MPMoviePlaybackStateInterrupted) 
	{
        //        NSLog(@"play back is interrupted");
        
//        [overlayController setPlaybackStateDisplayString:@"interrupted"];
	}
}

/* Notifies observers of a change in the prepared-to-play state of an object 
 conforming to the MPMediaPlayback protocol. */
- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
	// Add an overlay view on top of the movie view
//       NSLog(@"media is prepared");
    
}


@end
