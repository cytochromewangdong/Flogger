//
//  VideoPlayViewController.m
//  Flogger
//
//  Created by jwchen on 12-3-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "VideoPlayViewController.h"

@implementation VideoPlayViewController
@synthesize videoUrl, webView;

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

#pragma mark - View lifecycle
-(void) loadView
{   
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
    self.view = view;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    // Do any additional setup after loading the view from its nib.
    self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.videoUrl]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    self.videoUrl = nil;
    self.webView = nil;
    [super dealloc];
}

@end
