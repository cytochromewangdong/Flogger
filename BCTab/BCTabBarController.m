#import "BCTabBarController.h"
#import "BCTabBar.h"
#import "BCTab.h"
#import "UIViewController+iconImage.h"
#import "BCTabBarView.h"

#define BCTABHEIGHT 50

@interface BCTabBarController ()

- (void)loadTabs;

@property (nonatomic, retain) UIImageView *selectedTab;
@property (nonatomic, readwrite) BOOL visible;

@end


@implementation BCTabBarController
@synthesize viewControllers, tabBar, selectedTab, selectedViewController, tabBarView, visible,delegate,itemImages,tabBarVisible;

- (void)loadView {
	tabBarView = [[BCTabBarView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = self.tabBarView;
    CGRect tabRect = CGRectMake(0, 0, 320, 460);
    //tabBarView.frame.size.height = 460;
    tabBarView.frame = tabRect;
	CGFloat tabBarHeight = BCTABHEIGHT;//51; //+ 6; // tabbar + arrow
	CGFloat adjust = 0;//(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 1 : 0;
	tabBar = [[BCTabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - tabBarHeight, self.view.bounds.size.width, tabBarHeight + adjust)];
//    NSLog(@"====loadview tabBar frame is %@",[NSValue valueWithCGRect:tabBar.frame]);
	self.tabBar.delegate = self;
	self.tabBar.contentHeight = BCTABHEIGHT;//51;
	self.tabBarView.backgroundColor = [UIColor clearColor];
    //self.tabBarView.backgroundColor = [UIColor greenColor];
	self.tabBarView.tabBar = self.tabBar;
	[self loadTabs];
	
	UIViewController *tmp = selectedViewController;
	selectedViewController = nil;
	[self setSelectedViewController:tmp];
}
-(void)setTabBarVisible:(BOOL)valVisible
{
    if(tabBarVisible == valVisible)
    {
        return;
    }
    tabBarVisible = valVisible;
    if(tabBarVisible)
    {
        CGFloat tabBarHeight = BCTABHEIGHT;//51;// + 6; // tabbar + arrow
        CGFloat adjust = 0;//(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 1 : 0;
        self.tabBar.frame =CGRectMake(0, self.view.bounds.size.height - tabBarHeight - adjust, self.view.bounds.size.width, tabBarHeight + adjust);
//        NSLog(@"====visible tabBar frame is %@",[NSValue valueWithCGRect:tabBar.frame]);
        self.tabBarView.tabBar.hidden = NO;
    } else 
    {
        CGRect tFrame =  self.tabBarView.tabBar.frame;
        self.tabBarView.tabBar.frame = CGRectMake(0, self.tabBarView.frame.size.height, tFrame.size.width, tFrame.size.height);
        self.tabBarView.tabBar.hidden = YES;
//        NSLog(@"====tabBarVisible visible tabBar frame is %@",[NSValue valueWithCGRect:tabBar.frame]);
    }
	CGRect f = self.tabBarView.contentView.frame;
	f.size.height = self.tabBar.frame.origin.y;
	self.tabBarView.contentView.frame = f;
    //[self.tabBarView setNeedsLayout];
}
- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index {
	UIViewController *vc = [self.viewControllers objectAtIndex:index];
	if (self.selectedViewController == vc) {
        if(![self.delegate bcTabBarController:self shouldSelectViewController:vc])
        {
            return;
        }
		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
		}

        if(self.delegate&&[self.delegate respondsToSelector:@selector(bcTabBarController:didSelectViewController:)])
        {
            [self.delegate bcTabBarController:self didSelectViewController:vc];
        }
	} else {
		self.selectedViewController = vc;
	}
	
}

- (void)setSelectedViewController:(UIViewController *)vc {
	UIViewController *oldVC = selectedViewController;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(bcTabBarController:shouldSelectViewController:)])
    {
        if(![self.delegate bcTabBarController:self shouldSelectViewController:vc])
        {
            return;
        }
    }
	if (selectedViewController != vc) {
		selectedViewController = vc;
        //if (!self.childViewControllers && visible) 
        if(![self.childViewControllers count]&&visible)
        {
			[oldVC viewWillDisappear:NO];
			[selectedViewController viewWillAppear:NO];
		}
		self.tabBarView.contentView = vc.view;
        //if (!self.childViewControllers && visible) 
        //NSLog(@"======%@ || %d", self.childViewControllers, [self.childViewControllers count]);
        if(![self.childViewControllers count]&&visible)
        {
			[oldVC viewDidDisappear:NO];
			[selectedViewController viewDidAppear:NO];
		}
		
		[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:(oldVC != nil)];
	}
    //[self.view setNeedsLayout];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(bcTabBarController:didSelectViewController:)])
    {
        [self.delegate bcTabBarController:self didSelectViewController:vc];
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (![self.childViewControllers count])
        [self.selectedViewController viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
//    [se]
    self.view.frame = CGRectMake(0, 20, 320, 460);
    if (![self.childViewControllers count])
        [self.selectedViewController viewDidAppear:animated];
    
	visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    if (![self.childViewControllers count])
        [self.selectedViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
	visible = NO;
}



- (NSUInteger)selectedIndex {
	return [self.viewControllers indexOfObject:self.selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex {
	if (self.viewControllers.count > aSelectedIndex)
		self.selectedViewController = [self.viewControllers objectAtIndex:aSelectedIndex];
}

- (void)loadTabs {
	for (UIViewController *vc in self.viewControllers) {
        vc.wantsFullScreenLayout = NO;
	}
	NSMutableArray *tabs = [[[NSMutableArray alloc]init]autorelease];
	for (int i=0; i<self.viewControllers.count;i++) {
		[tabs addObject:[[[BCTab alloc] initWithIconImageName:[self.itemImages objectAtIndex:i*2] SelectedImage:[self.itemImages objectAtIndex:i*2+1]]autorelease]];
	}
	self.tabBar.tabs = tabs;
//    self.tabBar.backgroundColor = [UIColor greenColor];
	[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:NO];
}

- (void)viewDidUnload {
	self.tabBar = nil;
	self.selectedTab = nil;
}

- (void)setViewControllers:(NSArray *)array {
	if (array != viewControllers) {
        RELEASE_SAFELY(viewControllers);
		viewControllers = [array retain];
		
		if (viewControllers != nil) {
			[self loadTabs];
		}
	}
	
	self.selectedIndex = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
- (void)dealloc {
    RELEASE_SAFELY(viewControllers);
    RELEASE_SAFELY(itemImages);
    RELEASE_SAFELY(tabBar);
    //RELEASE_SAFELY(selectedViewController);
    RELEASE_SAFELY(tabBarView);
    RELEASE_SAFELY(selectedTab);
    [super dealloc];
}

//for 6.0+
- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
