@class BCTabBar;

@interface BCTabBarView : UIView
{
    UIView *_contentView;
    BCTabBar *_tabBar;
}

@property (nonatomic, assign) UIView *contentView;
@property (nonatomic, assign) BCTabBar *tabBar;


@end
