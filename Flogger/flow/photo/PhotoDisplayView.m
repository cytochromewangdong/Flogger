//
//  PhotoDisplayView.m
//  Flogger
//
//  Created by steveli on 16/03/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "PhotoDisplayView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PhotoView

- (void)dealloc {
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
//		UIImage *img = [UIImage imageNamed:@"test4.png"];
//		image = CGImageRetain(img.CGImage);
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Create a new path
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
	
    // Add circle to path
    CGPathAddEllipseInRect(path, NULL, self.bounds);//这句话就是剪辑作用
    CGContextAddPath(context, path);
    // CGContextClip(context);
	
//	UIImage *img = [UIImage imageNamed:@"test4.png"];
//	CGContextDrawImage(context,self.bounds,img.CGImage);
    
    CFRelease(path);
}
@end


@implementation PhotoDisplayView
@synthesize photoview,bgview;

-(void)dealloc
{
    self.photoview = nil;
    self.bgview = nil;
    [super dealloc];
}


- (void)addGestureRecognizersToPiece:(UIView *)piece
{
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [piece addGestureRecognizer:rotationGesture];
    [rotationGesture release];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [piece addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    [panGesture release];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showResetMenu:)];
    [piece addGestureRecognizer:longPressGesture];
    [longPressGesture release];
    
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [piece addGestureRecognizer:singleRecognizer];
    
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [piece addGestureRecognizer:doubleRecognizer];
    
    // 关键在这一行，如果双击确定偵測失败才會触发单击
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    [singleRecognizer release];
    [doubleRecognizer release];
}


-(void)removeGestureRecognizersToPiece:(UIView*)piece
{
    for(UIGestureRecognizer* ges in [piece gestureRecognizers])
        [piece removeGestureRecognizer:ges];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photoview = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
//        [self.photoview setImage:[UIImage imageNamed:@"test4.png"]];
        [self.photoview sizeToFit];
        self.photoview.center = self.center; 
        self.photoview.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        
        
        self.bgview = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        self.bgview.alpha = 0.7f;
        self.bgview.backgroundColor = [UIColor blackColor];
        [self addSubview:self.bgview];
        [self addSubview:photoview];
        
    }
    return self;
}


- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

-(void)show
{
    [self addGestureRecognizersToPiece:photoview];
    [self setHidden:NO];
    [self shakeToShow:photoview];
    
}

- (void) shakeToHide:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 0.4)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}


-(void)hide
{
    [self removeGestureRecognizersToPiece:photoview];
    
//    [self.photoview setImage:[UIImage imageNamed:@"test4.png"]];
    [self.photoview sizeToFit];
    self.photoview.center = self.center; 
    CGRect f = self.photoview.frame;
//    NSLog(@"frame size x = %f, y = %f,w = %f,h = %f",f.origin.x,f.origin.y,f.size.width,f.size.height);
    //[self shakeToHide:self];
    [self setHidden:YES];
}


-(void)handleSingleTapFrom
{
    self.hidden = YES;
    [self hide];
}

-(void)handleDoubleTapFrom
{
    [UIView beginAnimations:@"present-countdown" context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect frame = self.photoview.frame;
    frame.size.width = self.frame.size.width;
    frame.size.height = self.frame.size.height;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.photoview.frame = frame;
    [UIView commitAnimations];
    //self.photoview 
}


- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
	
	[UIView beginAnimations:@"present-countdown" context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
	[UIView commitAnimations];
	
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    [UIView beginAnimations:@"present-countdown" context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        //[gestureRecognizer view].layer.transform = CATransform3DMakeRotation([gestureRecognizer rotation], 0.0,0.0,1.0);
        CATransform3D rotationTransform = CATransform3DIdentity;
		rotationTransform = CATransform3DRotate([gestureRecognizer view].layer.transform,[gestureRecognizer rotation], 0.0, 0.0, 1.0);		
		[gestureRecognizer view].layer.transform=rotationTransform;	
		[gestureRecognizer setRotation:0];
		//[gestureRecognizer view].frame = UIEdgeInsetsInsetRect([gestureRecognizer view].frame, UIEdgeInsetsMake(-10.0f, -10.0f, -10.0f, -10.0f));
		/*
		 UIGraphicsBeginImageContext([gestureRecognizer view].frame.size); 
		 [[gestureRecognizer view].layer renderInContext:UIGraphicsGetCurrentContext()];
		 UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
		 [image retain];
		 imageViewOne.image = image;
		 UIGraphicsEndImageContext();
		 */
		[[gestureRecognizer view] setNeedsDisplay];
		
    }
	[UIView commitAnimations];
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
	
	[UIView beginAnimations:@"present-countdown" context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
		CATransform3D rotationTransform = CATransform3DIdentity;
		rotationTransform = CATransform3DScale ([gestureRecognizer view].layer.transform, [gestureRecognizer scale],
												[gestureRecognizer scale], 1.0);		
		[gestureRecognizer view].layer.transform=rotationTransform;		
        [gestureRecognizer setScale:1];
		[[gestureRecognizer view] setNeedsDisplay];
    }
	[UIView commitAnimations];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}


@end
