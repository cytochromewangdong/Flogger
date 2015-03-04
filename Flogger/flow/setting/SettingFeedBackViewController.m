//
//  SettingFeedBackViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SettingFeedBackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FeedbackServerProxy.h"

@implementation SettingFeedBackViewController

@synthesize contentView,subjectView,scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:NSLocalizedString(@"Feedback", @"Feedback")];
}

-(void) adjustSettingFeedBackViewLayout
{
    //UIImage *backgroundImage = [[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND];
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
//    view.backgroundColor = [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];//[[[UIColor alloc] initWithPatternImage:backgroundImage] autorelease];
    self.view = view;

    FloggerScrollView *scrollV = [[[FloggerScrollView alloc] init] autorelease];
    scrollV.frame = CGRectMake(0, 0, 320, 480);
    
    UITextView *label2 = [[FloggerUIFactory uiFactory] createTextView];
    label2.frame = CGRectMake(10, 5, 300, 125);
    UITextView *label = [[FloggerUIFactory uiFactory] createTextView];
    label.frame = CGRectMake(8, 0, 290, 120);
    label.text = NSLocalizedString(@"Please let us konw what you think about Flogger! If you would like to report a bug,have any questions,or just want to send us ideas on how to improve your experience,please just fill out the form below!", @"Please let us konw what you think about Flogger! If you would like to report a bug,have any questions,or just want to send us ideas on how to improve your experience,please just fill out the form below!");
    label.textAlignment = UITextAlignmentLeft;
//    label.backgroundColor = [UIColor clearColor];
    label.font = [[FloggerUIFactory uiFactory] createSmallBoldFont];
//    label.editable = NO;
//    label.scrollEnabled = NO;
    label.userInteractionEnabled = NO;
    label.backgroundColor = [UIColor whiteColor];
    label2.layer.shadowColor = [[UIColor grayColor] CGColor];
    label2.layer.shadowOffset = CGSizeMake(0, 1);
    label2.layer.shadowRadius = 1;
    label2.layer.shadowOpacity = 0.5;
    label2.layer.masksToBounds = NO;
    label.layer.cornerRadius = 6;
    label2.layer.cornerRadius = 6;
    label2.layer.shadowPath = [[UIBezierPath bezierPathWithRect:label2.bounds]CGPath];
    label.textColor = [[[UIColor alloc] initWithRed:64/255.0 green:63/255.0 blue:62/255.0 alpha:1.0] autorelease];
    label2.userInteractionEnabled = NO;
    [label2 addSubview: label];

    UITextField *subjectTextV = [[FloggerUIFactory uiFactory] createTextField];
    subjectTextV.frame = CGRectMake(10, 141, 300, 45);
    subjectTextV.delegate = self;
    subjectTextV.backgroundColor = [UIColor whiteColor];
    subjectTextV.borderStyle = UITextBorderStyleRoundedRect;
    subjectTextV.placeholder = NSLocalizedString(@"Subject", @"Subject");
    subjectTextV.font = [[FloggerUIFactory uiFactory] createMiddleFont];
    
    FloggerTextView *contentV = [[[FloggerTextView alloc] init] autorelease];//[[FloggerUIFactory uiFactory] createTextView];
    contentV.frame = CGRectMake(10, 197, 300, 200);
    contentV.font = [[FloggerUIFactory uiFactory] createMiddleFont];
    contentV.layer.cornerRadius = 6;
    contentV.layer.masksToBounds = YES;
    contentV.delegate = self;
    contentV.placeholder = NSLocalizedString(@"Please enter your feedback", @"Please enter your feedback");
    contentV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentV.layer.borderWidth = 1;
    [scrollV addSubview:label2];
    [scrollV addSubview:subjectTextV];
    [scrollV addSubview:contentV];

    
    [self.view addSubview:scrollV];
    
    [self setSubjectView:subjectTextV];
    [self setContentView:contentV];
    [self setScrollView:scrollV];
    
    [self setRightNavigationBarWithTitle: NSLocalizedString(@"Done",@"Done") image:nil];
    
}
#pragma mark - View lifecycle

-(void) loadView
{
    [self adjustSettingFeedBackViewLayout];
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

}
-(void) myFreeResourse
{
    self.subjectView.delegate = nil;
    self.subjectView = nil;
    self.contentView.delegate = nil;
    self.contentView = nil;
    self.scrollView = nil;
}
-(void) dealloc
{
    [self myFreeResourse];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self myFreeResourse];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [scrollView adjustOffsetToIdealIfNeeded];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView adjustOffsetToIdealIfNeeded];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.contentView becomeFirstResponder];
    return YES;
    
};

-(void)doRequest
{
    if (!self.serverProxy) {
        self.serverProxy = [[[FeedbackServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    FeedbackCom *com = [[[FeedbackCom alloc] init] autorelease];
    com.subject = self.subjectView.text;
    com.feedback = self.contentView.text;
    [(FeedbackServerProxy *)self.serverProxy addFeedback:com];
}

-(void)rightAction:(id)sender{
    [self doRequest];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
