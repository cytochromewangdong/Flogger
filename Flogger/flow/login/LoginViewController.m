//
//  LoginViewController.m
//  flogger
//
//  Created by jwchen on 11-12-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "GlobalData.h"
#import "FloggerAppDelegate.h"
#import "AccountServerProxy.h"
#import "AccountCom.h"
#import "FloggerAppDelegate.h"
#import "FloggerUIFactory.h"
#import "ImageConst.h"
#import "ExternalShareView.h"
#import "ExternalBindViewController.h"
#import "RegisterViewControl.h"
#import "FloggerTableView.h"
#import "FloggerPrefetch.h"
#import <Three20UICommon/Three20UICommon+Additions.h>

#define kSubmitTag 1000


#define kUsername       0
#define kPassword       1

@implementation LoginViewController
@synthesize userNameField, passwordField, eServerProxy, shareView, createBtn;
@synthesize dataSourceArray;
//@synthesize loginbtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:[NSString stringWithFormat:@"%@ %@",@"FOLO",NSLocalizedString(@"Login", @"Login")]];
    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Submit",@"Submit") image:nil];
}

-(void)getExternalPlatform
{
    /*if (self.loading) {
        return;
    }
    
    self.loading = YES;
    
    if (!self.eServerProxy) {
        self.eServerProxy = [[ExternalPlatformServerProxy alloc] init];
        self.eServerProxy.delegate = self;
    }
    
    ExternalPlatformCom *com = [[[ExternalPlatformCom alloc] init] autorelease];
    [self.eServerProxy getExternalPlatform:com];*/
}

#pragma mark - View lifecycle



-(void) loginAction
{
    [[self.view.window findFirstResponder] resignFirstResponder];
    
    AccountCom *account = [[[AccountCom alloc] init] autorelease];
    account.username = self.userNameField.text;
    account.password = self.passwordField.text;
    
    if (![self checkInputValid:account]) {
        return;
    }
    
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    AccountServerProxy *accountServerPro = (AccountServerProxy *)self.serverProxy;
    [accountServerPro login:account];
    
}

-(void) adjustViewLayout
{
   // UIImage *backgroundImage = [UIImage imageNamed:SNS_BACKGROUND];
    
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
//    view.backgroundColor = [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];//[[[UIColor alloc] initWithPatternImage:backgroundImage] autorelease];
    self.view = view;
    
    UITextField *usernameOrEmailText = [[FloggerUIFactory uiFactory] createTextField];
    usernameOrEmailText.delegate = self;
    usernameOrEmailText.placeholder = NSLocalizedString(@"Username or Email",@"Username or Email");
    
    UITextField *passwordText = [[FloggerUIFactory uiFactory] createTextField];
    passwordText.delegate = self;
    passwordText.placeholder = NSLocalizedString(@"Password",@"Password");
    passwordText.secureTextEntry = YES;
    passwordText.tag=2;
//    passwordText.
    self.dataSourceArray = [NSArray arrayWithObjects:usernameOrEmailText,passwordText,nil];
    
//    UILabel *lab = [[UILabel alloc] init];
//    [lab ]
    
    FloggerTableView *firstTableView = [[[FloggerTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped] autorelease];
    firstTableView.rowHeight = 45;
    firstTableView.dataSource = self;
    firstTableView.delegate = self;
    firstTableView.backgroundColor = [UIColor clearColor];
    if ([GlobalUtils checkIOS_6]) {
        firstTableView.backgroundView = nil;
    }

    
    firstTableView.userInteractionEnabled = YES;
    [self.view addSubview:firstTableView];  
    
    
//    usernameOrEmailText.text = @"flogger001";
//    passwordText.text = @"123456";
    
    [self setUserNameField:usernameOrEmailText];
    [self setPasswordField:passwordText];
    
//    UIBarButtonItem *loginItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done",@"Done")
//                                                                     style:UIBarButtonItemStyleBordered
//                                                                    target:self
//                                                                    action:@selector(loginAction)] autorelease];
//    self.navigationItem.rightBarButtonItem = loginItem;
//    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    forgetBtn.frame = CGRectMake(0, 115, 320, 25);
//    [forgetBtn addTarget:self action:@selector(clickForgetOrCreateBtn:) forControlEvents:UIControlEventTouchUpInside];
//    forgetBtn.tag = 0;
//    [forgetBtn setTitle:NSLocalizedString(@"Forgot Password?",@"Forgot Password?") forState:UIControlStateNormal];
//    forgetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
//    [self.view addSubview:usernameOrEmailText];
//    [self.view addSubview:passwordText];
//    [self.view addSubview:firstTableView];
//    [self.view addSubview:forgetBtn];
    

    
}
-(void) rightAction:(id)sender
{
    [self loginAction];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *kCellTextField_ID = @"CellTextField_ID";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellTextField_ID];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellTextField_ID] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UITextField *textField = [self.dataSourceArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:textField];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 350;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[FloggerUIFactory uiFactory] createView];
    int height = 111;
    
    UIButton *forgetBtn = [[FloggerUIFactory uiFactory] createButton:nil];
    forgetBtn.frame = CGRectMake(0, 120-height, 320, 20);
    [forgetBtn addTarget:self action:@selector(clickForgetOrCreateBtn:) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.tag = 0;
    [forgetBtn setTitle:NSLocalizedString(@"Forgot your password?",@"Forgot your password?") forState:UIControlStateNormal];
    UIColor *titleColor = [[[UIColor alloc] initWithRed:8/255.0 green:124/255.0 blue:165/255.0 alpha:1.0] autorelease];
    forgetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];   
    forgetBtn.titleLabel.shadowColor = [UIColor whiteColor];
    forgetBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    forgetBtn.titleLabel.textAlignment = UITextAlignmentCenter;
    
    [forgetBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [forgetBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [footerView addSubview:forgetBtn];
    
    return footerView;

}

-(void) loadView
{
    [self adjustViewLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      
//    UIView *shareWebView =[[FloggerUIFactory uiFactory] createView];
//    shareWebView.frame = CGRectMake(0, 207-111, 320, 250);
//    self.shareView = shareWebView;
//    
//    NSArray *platformArray =[[FloggerPrefetch getSingleton] platformArray];
//    if(platformArray) 
//    {
//        [self updateShareView:platformArray];
//    } else {
//        [FloggerPrefetch getSingleton].delegate = self;
//    }
    //[self performSelector:@selector(updateShareView:) withObject:platformArray afterDelay:10];
    //[self getExternalPlatform];
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification
//     object:nil];
    

}
//-(void) keyboardDidHide:(NSNotification *) notification{
//    NSLog(@"qqqqq");
//}
-(void) myReleaseResourse
{
    [FloggerPrefetch getSingleton].delegate = nil;
//    @property(nonatomic, retain) UITextField *userNameField, *passwordField;
//    @property(nonatomic, retain) UIButton *createBtn;
//    @property(nonatomic, retain) UIView *shareView;
//    @property(nonatomic, retain) ExternalPlatformServerProxy *eServerProxy;
//    @property(nonatomic, retain) NSArray *dataSourceArray;
    self.userNameField.delegate = nil;
    self.userNameField = nil;
    self.passwordField.delegate = nil;
    self.passwordField = nil;
    self.createBtn = nil;
    self.shareView = nil;
    self.eServerProxy.delegate = nil;
    self.eServerProxy = nil;
    self.dataSourceArray = nil;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self myReleaseResourse];
}

-(void) dealloc
{
    [self myReleaseResourse];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) isEmpty:(NSString*) text
{
    return ![text length];
}

-(BOOL) checkInputValid:(AccountCom *)accountCom
{
    if([self isEmpty: accountCom.username])
    {
        [GlobalUtils showAlert:NSLocalizedString(@"Error",@"Error") message: NSLocalizedString(@"Username or Email is required",@"Username or Email is required")];
        return NO;
    }
    if([self isEmpty: accountCom.password]){
        [GlobalUtils showAlert:NSLocalizedString(@"Error",@"Error") message:NSLocalizedString(@"Password is required",@"Password is required")];
        return NO;
    }
    return YES;
    
}


-(void) goToRegisterViewControl
{
    RegisterViewControl *registerViewControl = [[[RegisterViewControl alloc] init] autorelease];
    [self.navigationController pushViewController:registerViewControl animated:YES];
}

- (void)clickForgetOrCreateBtn:(id)sender
{
    NSUInteger tag = ((UIButton *)sender).tag;
    switch (tag) {
        case 0:
            //TODO forgetbtn
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.folo.mobi/Flogger/forgotPassword.jsp"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.folo.mobi/Flogger/forgotPassword.jsp"]];
//            showPage
            break;
        case 1:
            [self goToRegisterViewControl];
            break;
        default:
            break;
    }
    
//    www.iflogger.com:8080/Flogger/forgotPassword.jsp

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
    if(textField.tag==2){
        [self loginAction];
    }
	return YES;
}

#pragma mark - EditTableViewDelegate

-(void)externalShareView:(ExternalShareView *)externalShareView didSelectedAtIndex:(NSInteger)index
{
    ExternalBindViewController *vc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.platform = [externalShareView.platformArray objectAtIndex:index];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)updateShareView:(NSArray *)platformArray
{
//    UIView *testshareView = [[[UIView alloc] init] autorelease];
//    testshareView.userInteractionEnabled = YES;
//    [self setShareView:testshareView];
    
    ExternalShareView *eShareView = [[ExternalShareView alloc] initWithFrame:CGRectMake(0, 0, self.shareView.frame.size.width, self.shareView.frame.size.height)];
    eShareView.userInteractionEnabled = YES;
    eShareView.platformArray = platformArray;
    eShareView.delegate = self;
    [self.shareView addSubview:eShareView];
    
    self.shareView.frame = CGRectMake(self.shareView.frame.origin.x, self.shareView.frame.origin.y, self.shareView.frame.size.width, eShareView.frame.size.height);

//    ExterinalPlatform *explatform = [[[ExterinalPlatform alloc] init] autorelease];
//    explatform.platformArr = platformArray;
//    explatform.size = self.shareView.frame.size;
//    [GlobalData sharedInstance].exPlatform = explatform;
//    
//    
//    
//    
//    ExternalShareView *eShareView = [[ExternalShareView alloc] initWithFrame:CGRectMake(0, 0, self.shareView.frame.size.width, self.shareView.frame.size.height)];
//    eShareView.platformArray = platformArray;
//    eShareView.delegate = self;
//    [self.shareView addSubview:eShareView];
//    
//    self.shareView.frame = CGRectMake(self.shareView.frame.origin.x, self.shareView.frame.origin.y, self.shareView.frame.size.width, eShareView.frame.size.height);
//    
//    self.createBtn.frame = CGRectMake(self.createBtn.frame.origin.x, self.shareView.frame.origin.y + self.shareView.frame.size.height + 10, self.createBtn.frame.size.width, self.createBtn.frame.size.height);
//    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.createBtn.frame.origin.y + self.createBtn.frame.size.height + 20)];
}

-(void)transactionFinished:(BaseServerProxy *)sp
{
    [super transactionFinished:sp];
    if (self.serverProxy == sp) {
        [GlobalData sharedInstance].myAccount = (AccountCom *)sp.response;
        [[GlobalData sharedInstance] saveLoginAccount];
//        [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showFeed];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//        self.navigationController
        [self dismissModalViewControllerAnimated:NO];
        [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showTabViewControl];
    }
    else
    {
        [self updateShareView:((ExternalPlatformCom *)self.eServerProxy.response).externalplatforms];
    }
}
-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [self.eServerProxy cancelAll];
}

@end
