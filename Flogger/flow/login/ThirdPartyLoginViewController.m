//
//  ThirdPartyLoginViewController.m
//  Flogger
//
//  Created by wyf on 12-6-5.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ThirdPartyLoginViewController.h"
#import "ExternalShareView.h"
#import "GlobalData.h"
#import "FloggerPrefetch.h"
#import "ExternalBindViewController.h"
#import "LoginViewController.h"
#import "RegisterViewControl.h"

@interface ThirdPartyLoginViewController ()

@end

@implementation ThirdPartyLoginViewController

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
    view.frame = CGRectMake(0, 0, 320, 460);
    self.view = view;
    
    UILabel *label = [[FloggerUIFactory uiFactory] createLable];
    label.frame = CGRectMake(0, 25, 320, 25);
    label.text = NSLocalizedString(@"Connect to sign up or login:",@"Connect to sign up or login:");
    label.textColor = [[FloggerUIFactory uiFactory] createLoginFontColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    
    NSArray *platformArray =[[FloggerPrefetch getSingleton] platformArray];
    ExternalShareView *eShareView = [[ExternalShareView alloc] initWithFrame:CGRectMake(0, 60, 320, 400)];
    eShareView.userInteractionEnabled = YES;
    eShareView.platformArray = platformArray;
    eShareView.delegate = self;
    
    [self.view addSubview:label];
    [self.view addSubview:eShareView];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:NSLocalizedString(@"Login", @"Login")];
//    [self se]
    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Sign up", @"Sign up") image:nil];
}

-(void) rightAction:(id)sender
{
    RegisterViewControl *registerControl = [[[RegisterViewControl alloc] init] autorelease];
    [self.navigationController pushViewController:registerControl animated:YES];
}

-(void)externalShareView:(ExternalShareView *)externalShareView didSelectedAtIndex:(NSInteger)index
{

    if (index == 8) {
//        login
        LoginViewController *loginViewControl = [[[LoginViewController alloc] init] autorelease];
        [self.navigationController pushViewController:loginViewControl animated:YES];
    } else {
        ExternalBindViewController *vc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        vc.platform = [externalShareView.platformArray objectAtIndex:index];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
