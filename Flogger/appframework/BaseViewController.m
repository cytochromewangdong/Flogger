//
//  BaseViewController.m
//  Flogger
//
//  Created by jwchen on 11-12-8.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "BaseViewController.h"
#import "FloggerAppDelegate.h"
#import "GlobalData.h"
#import "PhotoDisplayViewController.h"
#import "FeedViewerViewController.h"
#import "SuggestionUserViewController.h"
#import "AlbumViewController.h"
#import "CommentPostViewController.h"
#import "SettingViewController.h"
#import "FindFriendSelectionViewController.h"
#import "FavortiesViewController.h"
#import "CameraNaviViewController.h"
#import "UIViewController+iconImage.h"
#import "ThirdPartyLoginViewController.h"
#import "ExternalBindViewController.h"
#import "FloggerInstructionView.h"

//NSInteger const K_TAG_RIGHT_BAR_BTN = 100;
@implementation BaseViewController
@synthesize keyboardRect, isHiddenNavigationBar;//, fullImageView;
@synthesize helpImageURL;

@dynamic isRightBarSelected;
-(BOOL)isRightBarSelected
{
    UIView *btnView = self.navigationItem.rightBarButtonItem.customView;
    return btnView? [(UIButton *)btnView isSelected]: NO;
}

-(void)setIsRightBarSelected:(BOOL)isRightBarSelected
{
    UIView *btnView = self.navigationItem.rightBarButtonItem.customView;
    if(btnView)
    {
        [(UIButton *)btnView setSelected:isRightBarSelected];
    }
}

-(void)leftAction:(id)sender;
{
//    NSLog(@"leftAction");
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [[GlobalData sharedInstance].menuView show];
    }
}

-(void)backAction:(id)sender;
{
//    NSLog(@"backAction");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightAction:(id)sender
{
//    NSLog(@"rightAction");
    if (![GlobalUtils checkIsLogin] && ![self isKindOfClass: [ExternalBindViewController class]]) {
        [self go2Login];
    }
    
}


-(UIBarButtonItem *) barButtonItemWithImage:(NSString *)str image:(NSString *)imageName pressimage:(NSString*)pressimageName withAciton:(SEL)action
{
    UIBarButtonItem *item = nil;
    if (imageName) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:imageName];
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        
        if(pressimageName)
        {
            [btn setBackgroundImage:[UIImage imageNamed:pressimageName] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:pressimageName] forState:UIControlStateSelected];
        }
        
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        if(str){
            [btn setTitle:str forState:UIControlStateNormal];
            UIFont *famFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
            btn.titleLabel.shadowOffset = CGSizeMake(0, 1);
            [btn setTitleColor: [[[UIColor alloc] initWithRed:64/255.0 green:64/255.0 blue:62/255.0 alpha:1.0] autorelease]forState:UIControlStateNormal];
            [btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = famFont;
//            btn.titleLabel.font = [FloggerUIFactory uiFactory] createHeadButton:<#(UIImage *)#> withSelImage:<#(UIImage *)#>//[UIFont boldSystemFontOfSize:12];//[[FloggerUIFactory uiFactory] createSmallBoldFont];//[GlobalUtils getFontByStyle:FONT_MIDDLE];
            btn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;//lgy 20120223
            if ([str isEqualToString:NSLocalizedString(@"Back", @"Back")]) {
//                btn.ti
                UIEdgeInsets titleInset = UIEdgeInsetsMake(0, 5, 0, 0);
                btn.titleEdgeInsets = titleInset;
            }
        }
        item = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
        
        
    }
    else if(str)
    {
        item = [[[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:action] autorelease];
    }

    return item;

}

-(UIBarButtonItem *) barButtonItem:(NSString *)str image:(NSString *)imageName withAciton:(SEL)action
{
    /*UIBarButtonItem *item = nil;
    if (imageName) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:imageName];
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        if(str){
            [btn setTitle:str forState:UIControlStateNormal];
            btn.titleLabel.font = [GlobalUtils getFontByStyle:FONT_MIDDLE];
        }
        item = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
        

    }
    else if(str)
    {
         item = [[[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:action] autorelease];
    }
    
//    if (imageName) {
//        [item setImage:[UIImage imageNamed:imageName]];
//    }
    return item;*/
    
    if (str == NSLocalizedString(@"Back",@"Back")) {
        imageName = SNS_BACK_BUTTON;
    } else if (!imageName && str) {
        imageName = SNS_BUTTON;
    }
    
    return [self barButtonItemWithImage:str image:imageName pressimage:nil withAciton:action];
}

-(void)setRightNavigationBarWithTitleAndImage:(NSString *)text image:(NSString *)imageName pressimage:(NSString*)pressimgname
{
    self.navigationItem.rightBarButtonItem = [self barButtonItemWithImage:text image:imageName pressimage:pressimgname withAciton:@selector(rightAction:)];
}

-(void)setRightNavigationBarWithTitle:(NSString *)text image:(NSString *)imageName
{
    self.navigationItem.rightBarButtonItem = [self barButtonItem:text image:imageName withAciton:@selector(rightAction:)];
}

-(void)setLeftNavigationBarWithTitle:(NSString *)text image:(NSString *)imageName
{
    self.navigationItem.leftBarButtonItem = [self barButtonItem:text image:imageName withAciton:@selector(leftAction:)];
}


-(void)setBackNavigation
{
    self.navigationItem.leftBarButtonItem = [self barButtonItem: NSLocalizedString(@"Back", @"Back") image:nil withAciton:@selector(backAction:)];
}

-(void) titleAction : (id) sender
{
//    NSLog(@"class %@", self.navigationController);
    if(![self.navigationController isKindOfClass:[CameraNaviViewController class]])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) setNavigationTitleView : (NSString *) titleStr
{
    if ([self.navigationController.navigationBar viewWithTag:123]) {
        UIView *view = [self.navigationController.navigationBar viewWithTag:123];
        [view removeFromSuperview];
    }
    if ([self.navigationController.navigationBar viewWithTag:1234]) {
        UIView *temp = [self.navigationController.navigationBar viewWithTag:1234];
        for (UIView *sub in [temp subviews]){
            [sub removeFromSuperview];
        }
        [temp removeFromSuperview];
    }
    // menuicon
    if ([self.navigationController.navigationBar viewWithTag:3000]) {
        UIView *view = [self.navigationController.navigationBar viewWithTag:3000];
        [view removeFromSuperview];
    }
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.tag = 123;
    //actionBtn.frame = CGRectMake(60, 0, 200, 44);
    [actionBtn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[FloggerUIFactory uiFactory] createLable];
    titleLabel.text = titleStr;
    //[actionBtn setTitle:titleStr forState:UIControlStateNormal];
    titleLabel.textAlignment = UITextAlignmentCenter;
    //actionBtn.titleLabel.textAlignment = UITextAlignmentCenter; 
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    //actionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = [[[UIColor alloc] initWithRed:64/255.0 green:63/255.0 blue:62/255.0 alpha:1.0] autorelease];
    //actionBtn.titleLabel.textColor = [[[UIColor alloc] initWithRed:64/255.0 green:63/255.0 blue:62/255.0 alpha:1.0] autorelease];
    titleLabel.userInteractionEnabled = NO;
	//[actionBtn setTitleColor:actionBtn.titleLabel.textColor forState:UIControlStateNormal];
    //actionBtn.titleLabel.shadowOffset = CGSizeMake(0, 0.8);
    titleLabel.shadowOffset = CGSizeMake(0, 0.8);
    //actionBtn.titleLabel.shadowColor =  [UIColor whiteColor];
    titleLabel.shadowColor = [UIColor whiteColor];
    //titleLabel.frame = CGRectMake(0, 0, 200, 44);
    CGSize bestSize = [titleLabel sizeThatFits:CGSizeZero];
    if (bestSize.width > 220) {
        bestSize.width = 200;
    }
    titleLabel.frame = CGRectMake(0, 0, bestSize.width,bestSize.height);
    CGSize parentSize = self.navigationController.navigationBar.frame.size;
    CGRect frame = CGRectMake((parentSize.width - bestSize.width)/2.0,(parentSize.height - bestSize.height)/2.0,bestSize.width,bestSize.height);
    //actionBtn.backgroundColor = [UIColor blueColor];
    actionBtn.frame = frame;
    [actionBtn addSubview:titleLabel];
    [self.navigationController.navigationBar addSubview:actionBtn];
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
}





/*-(void) setNavigationTitleView : (NSString *) titleStr
{
    for (UIView *view in self.navigationItem.titleView.subviews) {
        [view removeFromSuperview];
    } 
    //    if (self.navigationItem.titleView) {
    //        self
    //    }
    
    UIView *titleView = [[FloggerUIFactory uiFactory] createView];
    titleView.frame = CGRectMake(0, 0, 320, 44);
    //    titleView.backgroundColor = [UIColor redColor];
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    actionBtn.bounds = titleView.bounds;
    actionBtn.frame = CGRectMake(0, 0, titleView.frame.size.width, titleView.frame.size.height);//titleView.frame;
    actionBtn.backgroundColor = [UIColor blueColor];
    [actionBtn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[FloggerUIFactory uiFactory] createLable];
    //    titleLabel.backgroundColor = [UIColor greenColor];
    titleLabel.text = titleStr;
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [[[UIColor alloc] initWithRed:64/255.0 green:63/255.0 blue:62/255.0 alpha:1.0] autorelease];
    titleLabel.userInteractionEnabled = NO;    
    //    [titleView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(0, 0, 320, 44);
    //    titleLabel.bounds = actionBtn.bounds;
    //    titleLabel.frame = CGRectMake(0, 0, titleView.frame.size.width, titleView.frame.size.height);
    
    //    [titleView addSubview:actionBtn];
    //    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleLabel;
}*/


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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setNavigationTitleView:@"title"];
    
    if([self.navigationController viewControllers].count > 1)
    {
        [self setBackNavigation];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
//    NSLog(@"viewDidUnload ---- %@", [[self class] description]);
}

-(BOOL) checkIsShowHelpView {
    
    return NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self checkIsShowHelpView] && self.helpImageURL) {
        FloggerInstructionView *instructionView = [[[FloggerInstructionView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withImageURL:self.helpImageURL] autorelease];
        if (self.bcTabBarController && ![self.bcTabBarController.view.window viewWithTag:VIEWIMAGEVIEWTAG]) {
            [self.bcTabBarController.view.window addSubview:instructionView];
        } else if (self.navigationController && ![self.navigationController.view.window viewWithTag:VIEWIMAGEVIEWTAG]) {
            [self.navigationController.view.window addSubview:instructionView];
        }
        
    }

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //set titleView
    [self setNavigationTitleView:@""];
    //set login
    if (![GlobalUtils checkIsLogin] && ![self isKindOfClass: [ExternalBindViewController class]]) {
         [self setRightNavigationBarWithTitle:NSLocalizedString(@"Connect", @"Connect") image:nil];
    }
    
//    NSLog(@"")
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResign:)
                                                name:UIApplicationWillResignActiveNotification object:NULL];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    
    if ([self.navigationController isKindOfClass:[CameraNaviViewController class]])
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if (!self.isHiddenNavigationBar) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    }
    
    //    });
    if (![GlobalUtils checkIsLogin]) {
        return;
    }
    if ([self checkIsFullScreen]) 
    {
        if (self.bcTabBarController) 
        {
            //UIView *barView = self.bcTabBarController;
            //CGRect tFrame = barView.frame;
            //barView.frame = CGRectMake(tFrame.origin.x, 20, 320, 460 + 49);//tFrame.origin.y
            //CGRect tFrame = self.bcTabBarController.tabBar.frame;
            //self.bcTabBarController.tabBar.frame = CGRectMake(0, 460 - 51, tFrame.size.width, tFrame.size.height);
            self.bcTabBarController.tabBarVisible = NO;
            //[self.bcTabBarController.tabBar setHidden:YES];
            //        [self.tabBarController.tabBar setHidden:NO]
        }
    } 
    else 
    {
//        if ([GlobalUtils checkIsLogin])
        if (self.bcTabBarController) 
        {
            //self.navigationController.view.frame = CGRectMake(0, 20, 320, 411);
//            dispatch_async(dispatch_get_main_queue(), ^{
            //[self.bcTabBarController.tabBar setHidden:NO];
            self.bcTabBarController.tabBarVisible = YES;
            //CGRect tFrame = self.bcTabBarController.tabBar.frame;
            //self.bcTabBarController.tabBar.frame = CGRectMake(0, 470, tFrame.size.width, tFrame.size.height);
            //UIView *barView = self.bcTabBarController.view;
            //CGRect tFrame = barView.frame;
                //barView.frame = CGRectMake(tFrame.origin.x, 20, 320, 460);//tFrame.origin.y
//            });
            //self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
        } 
    }


}

-(void)go2Login
{
    ThirdPartyLoginViewController *thirdControl = [[[ThirdPartyLoginViewController alloc] init] autorelease];
//    if (![GlobalUtils checkIsLogin]) {
        if (self.navigationController) {
            [self.navigationController pushViewController:thirdControl animated:YES];
        }
//    }    
}

-(BOOL) checkIsFullScreen
{
    return NO;
}

-(void) applicationWillResign: (NSNotification *) notification
{
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    NSLog(@"viewDidAppear baseviewcontrol nsstring %@",self.view.class);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    if (self.isHiddenNavigationBar) 
    {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)doubleFingerTapped:(id)sender
{
//    NSLog(@"doubleFingerTapped");
//    [[[GlobalData sharedInstance] menuView] show];
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    self.keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"keyboard size: %f, %f", self.keyboardRect.size.width, self.keyboardRect.size.height);
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
}

-(void)registerForTextFieldTextChangedNotification
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(textChanged:) name: UITextFieldTextDidChangeNotification object:nil];
}

-(void)unregisterForTextFieldTextChangedNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(UIView *)getRootView
{
    UIView *rootView = self.view;
    while ([rootView superview]) {
        rootView = [rootView superview];
    }
    return rootView;
}

-(void)showFullImageViewWithImageUrl:(NSString *)imageUrl placeHolderImage:(UIImage *)image
{
//    if (!self.fullImageView) {
//        UIView *rootView = [self getRootView];
//        self.fullImageView = [[[ScaleableImageView alloc] initWithFrame:CGRectMake(0, rootView.frame.origin.y, rootView.frame.size.width, rootView.frame.size.height)] autorelease];
//        [rootView addSubview:fullImageView];
//    }
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    self.fullImageView.hidden = NO;
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:500];
    
//    self.fullImageView.transform =  CGAffineTransformMakeScale(1, 1);
//    [UIView commitAnimations];
    
    PhotoDisplayViewController *pvc = [[[PhotoDisplayViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    pvc.image = image;
    pvc.imageUrl = imageUrl;
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void)dealloc
{
//    self.fullImageView = nil;
//    NSLog(@"dealloc --- %@", [[self class] description]);
    self.helpImageURL = nil;
    [super dealloc];
}

@end
