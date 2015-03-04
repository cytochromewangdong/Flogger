@class BCTab;

@protocol BCTabBarDelegate;

@interface BCTabBar : UIView
{
    NSArray * _tabs;
    BCTab *_selectedTab;
    UIImageView *_arrow;
    
}
- (id)initWithFrame:(CGRect)aFrame;
- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated;
-(void) showBadge;

@property (nonatomic, retain) NSArray *tabs;
@property (nonatomic, retain) BCTab *selectedTab;
@property (nonatomic, assign) id <BCTabBarDelegate> delegate;
@property (nonatomic, retain) UIImageView *arrow;
@property (nonatomic, assign) float contentHeight;
@property (nonatomic, assign) uint lablePosition;
@property (nonatomic, assign) uint lableNum;
@end

@protocol BCTabBarDelegate
- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index;
@end