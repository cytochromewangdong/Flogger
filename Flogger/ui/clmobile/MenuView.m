//
//  MenuView.m
//  Flogger
//
//  Created by jwchen on 11-12-8.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "MenuView.h"

#define kAlpha 1

@implementation MenuView

@synthesize topView, bottomView, leftView, rightView;

-(void)setUpView:(CGRect)frame
{
    topFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    topBeginFrame = CGRectMake(0, -topFrame.size.height, topFrame.size.width, topFrame.size.height);
    topView = [[UIControl alloc] initWithFrame:topBeginFrame];
    [self addSubview:topView];
    
    bottomFrame = CGRectZero;//CGRectMake(0, frame.size.height - frame.size.height/3, frame.size.width, frame.size.height/3 );
    bottomBeginFrame = CGRectZero;//CGRectMake(0, frame.size.height + bottomFrame.size.height, bottomFrame.size.width, bottomFrame.size.height);
//    bottomView = [[UIView alloc] initWithFrame:bottomBeginFrame];
//    [self addSubview:bottomView];
    
    leftFrame = CGRectZero;//CGRectMake(0, topView.frame.size.height, frame.size.width/2, frame.size.height - topView.frame.size.height - bottomView.frame.size.height);
    leftBeginFrame = CGRectZero;//CGRectMake(-leftFrame.size.width, leftFrame.origin.y, leftFrame.size.width, leftFrame.size.height);
//    leftView = [[UIView alloc] initWithFrame:leftBeginFrame];
//    [self addSubview:leftView];
    
    rightFrame = CGRectZero;//CGRectMake(frame.size.width/2, topView.frame.size.height, frame.size.width/2, leftFrame.size.height);
    rightBeginFrame = CGRectZero;//CGRectMake(rightFrame.origin.x + rightFrame.size.width, rightFrame.origin.y, rightFrame.size.width, rightFrame.size.height);
//    rightView = [[UIView alloc] initWithFrame:rightBeginFrame];
//    [self addSubview:rightView];
    self.alpha = 0;
    
    topView.backgroundColor = [UIColor clearColor];
//    bottomView.backgroundColor = [UIColor clearColor];
//    leftView.backgroundColor = [UIColor clearColor];
//    rightView.backgroundColor = [UIColor clearColor];
}

-(void)setupTapEvent
{
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleFingerTapped:)];
//    tapGestureRecognizer.numberOfTouchesRequired = 1;
//    tapGestureRecognizer.numberOfTapsRequired = 2;
//    //    self.view.multipleTouchEnabled = YES;
//    [self addGestureRecognizer:tapGestureRecognizer];
//    [tapGestureRecognizer release];
    
//    UIControl *uiCon = [[[UIControl alloc] initWithFrame:self.bounds] autorelease];
//    uiCon.backgroundColor = [UIColor clearColor];
    [self setUserInteractionEnabled:YES];
    [(UIControl *)self.topView addTarget:self action:@selector(doubleFingerTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:uiCon];
}

-(void)doubleFingerTapped:(id)sender
{
//    NSLog(@"doubleFingerTapped");
    [self hide];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        [self setUpView:frame];
         [self setupTapEvent];
    }
    return self;
}

-(void)animationViewWithTop:(CGRect)tFrame left:(CGRect)lFrame right:(CGRect)rFrame bottom:(CGRect)bFrame alpha:(CGFloat)alpha
{
    [UIView beginAnimations:nil context:nil];
    topView.frame = tFrame;
//    bottomView.frame = bFrame;
//    leftView.frame = lFrame;
//    rightView.frame = rFrame;
    self.alpha = alpha;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:1000];
    [UIView commitAnimations];
}

-(void)show
{
    if (self.alpha != kAlpha)
    {
        [self animationViewWithTop:topFrame left:leftFrame right:rightFrame bottom:bottomFrame alpha:kAlpha];
    }
    
}

-(void)hide
{
    if (self.alpha == kAlpha)
    {
        [self animationViewWithTop:topBeginFrame left:leftBeginFrame right:rightBeginFrame bottom:bottomBeginFrame alpha:0];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    RELEASE_SAFELY(topView);
    RELEASE_SAFELY(bottomView);
    RELEASE_SAFELY(rightView);
    RELEASE_SAFELY(leftView);
    [super dealloc];
}

@end
