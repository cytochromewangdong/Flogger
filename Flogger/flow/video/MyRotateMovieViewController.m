//
//  MyRotateMovieViewController.m
//  Flogger
//
//  Created by wyf on 12-8-3.
//  Copyright (c) 2012年 atoato. All rights reserved.
//

#import "MyRotateMovieViewController.h"

@interface MyRotateMovieViewController ()

@end

@implementation MyRotateMovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

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
//        self.moviePlayer.view.frame = newRect;
        self.view.frame = newRect;
//        self.activityIndicator.center = self.moviePlayerController.view.center;
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


@end
