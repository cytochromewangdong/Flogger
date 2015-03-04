#import "UIViewController+iconImage.h"


@implementation UIViewController (BCTabBarController)

- (NSString *)iconImageName {
	return nil;
}
-(BCTabBarController*) bcTabBarController
{
    id obj = self.parentViewController;
    do{
        if([obj isKindOfClass:[BCTabBarController class]])
        {
            
            break;
        }
        obj = [obj nextResponder];
    }while(obj);
    return obj;
    //if(self.parentViewController)
}

@end
