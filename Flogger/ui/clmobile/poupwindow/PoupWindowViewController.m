//
//  PoupWindowViewController.m
//  Flogger
//
//  Created by steveli on 09/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "PoupWindowViewController.h"

#define POUPWIDTH 242
#define POUPHEIGHT 101

@implementation PoupWindowViewController

@synthesize bgview,poupbgview,cancelbtn,donebtn,delegate,textview;

-(void)dealloc
{
    self.bgview = nil;
    self.poupbgview = nil;
    self.cancelbtn = nil;
    self.donebtn = nil;
    self.delegate = nil;
    [super dealloc];
}

-(void)rightbtnpress
{
    if(self.delegate)
        [self.delegate poupwindowRightAction];
    
}

-(void)leftbtnpress
{
    if(self.delegate)
        [self.delegate poupwindowLeftAction];
}

-(void)setupview:(CGRect)frame
{
    self.bgview = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)]autorelease];
    [self.bgview setImage:[UIImage imageNamed:SNS_HOME_BACKGROUND]];
    [self.bgview setAlpha:0.7];
    [self addSubview:self.bgview];
    
    self.poupbgview = [[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width - POUPWIDTH )/2, (frame.size.height - POUPHEIGHT )/2, POUPWIDTH , POUPHEIGHT)]autorelease];
    [self.poupbgview setImage:[UIImage imageNamed: SNS_FAVORITEPOPUP_BACKGROUND]];
    [self addSubview:self.poupbgview];
    
    self.donebtn  = [[[UIButton alloc]initWithFrame:CGRectMake(poupbgview.frame.origin.x + 39, poupbgview.frame.origin.y + 60, 65, 34)]autorelease];
    [self.donebtn setBackgroundImage:[UIImage imageNamed: SNS_GALLARY_BUTTON] forState:UIControlStateNormal];
    self.donebtn.titleLabel.font = [GlobalUtils getFontByStyle:FONT_MIDDLE];
    [self.donebtn setTitle: NSLocalizedString(@"Done",@"Done") forState:UIControlStateNormal];
    [self.donebtn addTarget:self action:@selector(leftbtnpress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.donebtn];
    
    self.cancelbtn  = [[[UIButton alloc]initWithFrame:CGRectMake(poupbgview.frame.origin.x + 138, poupbgview.frame.origin.y + 60, 65, 34)]autorelease];
    [self.cancelbtn setBackgroundImage:[UIImage imageNamed:SNS_GALLARY_BUTTON] forState:UIControlStateNormal];
    [self.cancelbtn setTitle: NSLocalizedString(@"Cancel",@"Cancel") forState:UIControlStateNormal];
    self.cancelbtn.titleLabel.font = [GlobalUtils getFontByStyle:FONT_MIDDLE];
    [self.cancelbtn addTarget:self action:@selector(rightbtnpress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelbtn];
    
    self.textview = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, POUPWIDTH, 55)]autorelease];
    self.textview.backgroundColor = [UIColor clearColor];
//    self.textview.text = @"test test test test";
    self.textview.font = [GlobalUtils getBoldFontByStyle:FONT_BIG];
    self.textview.textAlignment = UITextAlignmentCenter;
    [self.poupbgview addSubview:self.textview];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupview:frame];
        _frame = frame;
    }
    return self;
}

-(void)show
{
    [UIView beginAnimations:nil context:nil];
    self.frame = _frame;
    self.alpha = 1.0;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:1000];
    [UIView commitAnimations];
}
-(void)hide
{
    [UIView beginAnimations:nil context:nil];
    self.frame = CGRectMake(_frame.origin.x + _frame.size.width/2, _frame.origin.y + _frame.size.height/2, 0, 0);
    self.alpha = 0.0;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:1000];
    [UIView commitAnimations];
}

-(void)setleftbtn:(NSString*)title bgimg:(UIImage*)img
{
    [self.donebtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.donebtn setTitle:title forState:UIControlStateNormal];
}
-(void)setrightbtn:(NSString*)title bgimg:(UIImage*)img
{
    [self.cancelbtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.cancelbtn setTitle:title forState:UIControlStateNormal];
}

-(void)settTitle:(NSString*)title
{
    self.textview.text = title;
}
@end
