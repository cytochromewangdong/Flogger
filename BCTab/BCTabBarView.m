#import "BCTabBarView.h"
#import "BCTabBar.h"

@implementation BCTabBarView
@synthesize tabBar=_tabBar, contentView=_contentView;

- (void)setTabBar:(BCTabBar *)aTabBar {
    if (_tabBar != aTabBar) {
        [_tabBar removeFromSuperview];
        RELEASE_SAFELY(_tabBar);
        _tabBar = [aTabBar retain];
        [self addSubview:_tabBar];
    }
}

- (void)setContentView:(UIView *)aContentView {
	[_contentView removeFromSuperview];
    RELEASE_SAFELY(_contentView);
	_contentView = [aContentView retain];
	_contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.tabBar.frame.origin.y);

	[self addSubview:_contentView];
	[self sendSubviewToBack:_contentView];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = _contentView.frame;
    //TODO 
    //_contentView.backgroundColor = [UIColor greenColor];
    //self.backgroundColor = [UIColor redColor];
	f.size.height = self.tabBar.frame.origin.y;
	_contentView.frame = f;
	[_contentView layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	[RGBCOLOR(230, 230, 230) set];
//    [[UIColor yellowColor]set];
	CGContextFillRect(c, self.bounds);
}
- (void)dealloc {
    RELEASE_SAFELY(_contentView);
    RELEASE_SAFELY(_tabBar);
    [super dealloc];
}

@end
