#include "BCTabBarController.h"

@interface UIViewController (BCTabBarController)

- (NSString *)iconImageName;
@property(nonatomic,readonly,retain) BCTabBarController *bcTabBarController;
@end
