//
//  FloggerGLView.m
//  FloggerVideo
//
//  Created by wyf on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FloggerGLView.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>

@interface FloggerGLView ()
- (void)handleSingleTap:(id)tapPointValue;
- (void)handleDoubleTap:(id)tapPointValue;
- (void)handleTripleTap;
@end

@implementation FloggerGLView
@synthesize delegate = _delegate;

+ (Class) layerClass 
{
	return [CAEAGLLayer class];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
		// Do OpenGL Core Animation layer setup
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];		
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if ([touches count] == 1) {
//        UITouch *touch = [touches anyObject];
//        CGPoint oldtapPoint = [touch locationInView:self];
//        CGPoint tapPoint = CGPointMake(oldtapPoint.x * 9 /8, oldtapPoint.y * 9 /8);
//        if ([touch tapCount] == 1) {
//            [self performSelector:@selector(handleSingleTap:) withObject:[NSValue valueWithCGPoint:tapPoint] afterDelay:0.3];
//        } else if ([touch tapCount] == 2) {
//            [NSObject cancelPreviousPerformRequestsWithTarget:self];
//            [self performSelector:@selector(handleDoubleTap:) withObject:[NSValue valueWithCGPoint:tapPoint] afterDelay:0.3];
//        } else if ([touch tapCount] == 3) {
//            [NSObject cancelPreviousPerformRequestsWithTarget:self];
//            [self handleTripleTap];
//        }
//    }
}

- (void)handleSingleTap:(id)tapPointValue
{
    id delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(tapToFocus:)]) {
        [delegate tapToFocus:[tapPointValue CGPointValue]];
    }    
}

- (void)handleDoubleTap:(id)tapPointValue
{
    id delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(tapToExpose:)]) {
        [delegate tapToExpose:[tapPointValue CGPointValue]];
    }    
}

- (void)handleTripleTap
{
    id delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(resetFocusAndExpose)]) {
        [delegate resetFocusAndExpose];
    }    
}

-(void) dealloc
{
    [self setDelegate:nil];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
