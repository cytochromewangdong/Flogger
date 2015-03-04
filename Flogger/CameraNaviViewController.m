//
//  CameraNaviViewController.m
//  Flogger
//
//  Created by wyf on 12-5-5.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "CameraNaviViewController.h"

@interface CameraNaviViewController ()

@end

@implementation CameraNaviViewController

/*-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationBar.frame = CGRectMake(0, 0, 320, 44);
}*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
