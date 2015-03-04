#import "BCTabBar.h"
@class BCTabBarView;
@class BCTabBarController;

@protocol BCTabBarControllerDelegate <NSObject>
- (BOOL)bcTabBarController:(BCTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)bcTabBarController:(BCTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

//- (void)bcTabBarController:(BCTabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers;
@end

@interface BCTabBarController : UIViewController <BCTabBarDelegate>
@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) NSArray *itemImages;
@property (nonatomic, retain) BCTabBar *tabBar;
@property (nonatomic, assign) UIViewController *selectedViewController;
@property (nonatomic, retain) BCTabBarView *tabBarView;
@property (nonatomic) NSUInteger selectedIndex;
@property(nonatomic,assign) id<BCTabBarControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL visible;
@property (nonatomic, assign)BOOL tabBarVisible;

@end
