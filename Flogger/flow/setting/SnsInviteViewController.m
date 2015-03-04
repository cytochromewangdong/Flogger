//
//  SnsInviteViewController.m
//  Flogger
//
//  Created by wyf on 12-6-26.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SnsInviteViewController.h"
#import "ShareCom.h"
#import "ShareServerProxy.h"
#import "GlobalData.h"

#define kMaxLength 140
@interface SnsInviteViewController ()

@end

@implementation SnsInviteViewController
@synthesize messageTextV,platform,countLabel;
@synthesize isFromLogin;

-(void) dealloc
{
    self.messageTextV.delegate = nil;
    self.messageTextV = nil;
    self.countLabel = nil;
    self.platform = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeShown:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//}
//
//- (void)unregisterForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter]
//     removeObserver:self
//     name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter]
//     removeObserver:self
//     name:UIKeyboardWillHideNotification object:nil];
//}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Send", @"Send") image:nil];
    if (self.platform) {
        [self setNavigationTitleView:[NSString stringWithFormat:@"%@ %@",self.platform.name, NSLocalizedString(@"Invite", @"Invite")]];
    }
    
//    [self setNavigationTitleView:<#(NSString *)#>]
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterForKeyboardNotifications];
}


-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
    self.view = view;
    
    
    
    
    UITextView *messageText = [[FloggerUIFactory uiFactory] createTextView];
    messageText.frame = CGRectMake(8, 10, 302, 145);
    messageText.layer.shadowColor = [[UIColor grayColor] CGColor];
    messageText.layer.shadowOffset = CGSizeMake(0, 1);
    messageText.layer.shadowRadius = 1;
    messageText.layer.shadowOpacity = 0.5;
    messageText.layer.masksToBounds = NO;
    messageText.layer.cornerRadius = 6;
    UITextView *messageTextView = [[FloggerUIFactory uiFactory] createTextView];
    messageTextView.frame = CGRectMake(1, 1, 301, 143);
    messageTextView.layer.cornerRadius = 6;
    messageTextView.textColor = [[[UIColor alloc] initWithRed:64/255.0 green:63/255.0 blue:62/255.0 alpha:1.0] autorelease];
    messageTextView.font = [[FloggerUIFactory uiFactory] createSmallBoldFont];
    messageTextView.delegate = self;
    [messageTextView becomeFirstResponder];
    messageTextView.text = [GlobalData sharedInstance].myAccount.inviteFriendContent;//NSLocalizedString(@"invite message", @"invite message");
    
    UILabel *countLab = [[FloggerUIFactory uiFactory] createLable];
    countLab.frame = CGRectMake(262, 168, 45, 25);
    countLab.font = [UIFont boldSystemFontOfSize:14];
    countLab.text = [NSString stringWithFormat:@"%d", kMaxLength - (messageTextView.text.length)];
    [self.view addSubview:countLab]; 
    [messageText addSubview:messageTextView];
    [self.view addSubview:messageText];  
    [self setMessageTextV:messageTextView];
    [self setCountLabel:countLab];
    
}

-(void) doRequest
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[ShareServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    ShareCom *com = [[[ShareCom alloc] init] autorelease];
    com.text = self.messageTextV.text;
    NSMutableArray *souceList = [[[NSMutableArray alloc] init] autorelease];
    [souceList addObject:self.platform.id];
    com.sourceList = souceList;
    [((ShareServerProxy *)self.serverProxy) inviteFriend:com];
}

-(void) rightAction:(id)sender
{
    [self doRequest];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger avaibleLength = kMaxLength - (textView.text.length);
    if (avaibleLength < 0) {
        avaibleLength = 0;
        self.messageTextV.text = [self.messageTextV.text substringToIndex:kMaxLength];
    }
    else
        {
        self.countLabel.textColor = [UIColor blackColor];
        }
    self.countLabel.text = [NSString stringWithFormat:@"%d", avaibleLength];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) transactionFinished:(BaseServerProxy *)serverproxy
{
    if (self.navigationController) {
//        if (isFromLogin) {
////            [self dismissModalViewControllerAnimated:NO];
//            [self.navigationController popViewControllerAnimated:NO];
//        }
        [self.navigationController popViewControllerAnimated:YES];
//        dispatch_async(dispatch_get_main_queue(), ^{
//             [self.navigationController popViewControllerAnimated:YES];
//        });
       
    }
    
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
