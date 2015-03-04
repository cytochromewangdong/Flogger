#import "BCTabBar.h"
#import "BCTab.h"
#import "StyleView.h"
#define kTabMargin 0.0
//2.0

@interface BCTabBar ()
@property (nonatomic, retain) UIImage *backgroundImage;

- (void)positionArrowAnimated:(BOOL)animated;
@end

@implementation BCTabBar
@synthesize tabs=_tabs, selectedTab=_selectedTab, backgroundImage=_backgroundImage, arrow=_arrow, delegate,contentHeight,lablePosition,lableNum;

- (id)initWithFrame:(CGRect)aFrame {

	if (self = [super initWithFrame:aFrame]) {
		self.backgroundImage = [UIImage imageNamed:@"BCTabBarController.bundle/tab-bar-background.png"];
		self.arrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BCTabBarController.bundle/tab-arrow.png"]] autorelease];
		CGRect r = self.arrow.frame;
		r.origin.y = - (r.size.height - 2);
		self.arrow.frame = r;
		//[self addSubview:self.arrow];
		self.userInteractionEnabled = YES;
		//self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
						 
	}
	
	return self;
}
-(void) showBadge
{
    int badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    self.lableNum = badgeNumber;
    /*StyleView *styleV = (StyleView *)[self viewWithTag:2008];
    if (badgeNumber > 0) {
        styleV.hidden = NO;
        if (badgeNumber < 10) {
            styleV.frame = CGRectMake(216, styleV.frame.origin.y, styleV.frame.size.width, styleV.frame.size.height);
            styleV.text = [NSString stringWithFormat:@"%d",self.lableNum];
        } else if (badgeNumber < 100) {
            styleV.frame = CGRectMake(208, styleV.frame.origin.y, styleV.frame.size.width, styleV.frame.size.height);
            styleV.text = [NSString stringWithFormat:@"%d",self.lableNum];
        } else {
            styleV.frame = CGRectMake(201, styleV.frame.origin.y, styleV.frame.size.width, styleV.frame.size.height);
            styleV.text = [NSString stringWithFormat:@"%d",999];
        }
        [styleV setNeedsLayout];
        [styleV setNeedsDisplay];
        //216 1
        //208 2
        //201 3
//        [se]
//        [styleV needdis]
//        []
    } else {
        styleV.hidden = YES;
    }*/
    [self setNeedsLayout];
}

- (StyleView*)badgeTextView:(CGRect)frame
{
    TTStyle* style =[[TTStyleSheet globalStyleSheet] styleWithSelector:@"badge"];
//    self.lableNum = 0;
    NSString *title = [NSString stringWithFormat:@"%d",self.lableNum];
    CGRect textFrame = frame;//TTRectInset(frame, UIEdgeInsetsMake(20, 20, 20, 20));
    StyleView* text = [[[StyleView alloc]
                       initWithFrame:textFrame]autorelease];
    text.text = title;
    text.tag = 2008;
    TTStyleContext* context = [[[TTStyleContext alloc] init]autorelease];
    context.frame = frame;
    context.delegate = text;
    context.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [style addToSize:CGSizeZero context:context];
    
    size.width += 20;
    size.height += 20;
    textFrame.size = size;
    text.frame = textFrame;
    
    text.style = style;
    text.backgroundColor = [UIColor clearColor];//colorWithRed:0.9 green:0.9 blue:1 alpha:1];
    text.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    text.userInteractionEnabled = NO;
//    text.hidden = YES;
    return text;
}
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
//	CGContextRef context = UIGraphicsGetCurrentContext();
	//[self.backgroundImage drawAtPoint:CGPointMake(0, 0)];
	//[[UIColor blackColor] set];
    //CGContextFillRect(context, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
	//[[UIColor redColor] set];
    //CGContextFillRect(context, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
}

- (void)setTabs:(NSArray *)array {
    if (_tabs != array) {
        for (BCTab *tab in _tabs) {
            [tab removeFromSuperview];
        }
        RELEASE_SAFELY(_tabs)
        _tabs = [array retain];        
        
        for (BCTab *tab in _tabs) {
            tab.userInteractionEnabled = YES;
            [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchDown];
        }
        [self setNeedsLayout];

    }
}

- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated {
	if (aTab != _selectedTab) {
        RELEASE_SAFELY(_selectedTab);
		_selectedTab = [aTab retain];
		_selectedTab.selected = YES;
		
		for (BCTab *tab in self.tabs) {
			if (tab == aTab) continue;
			
			tab.selected = NO;
		}
	}
	
	[self positionArrowAnimated:animated];	
}

- (void)setSelectedTab:(BCTab *)aTab {
	[self setSelectedTab:aTab animated:YES];
}

- (void)tabSelected:(BCTab *)sender {
	[self.delegate tabBar:self didSelectTabAtIndex:[self.tabs indexOfObject:sender]];
}

- (void)positionArrowAnimated:(BOOL)animated {
    return;
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
	}
	CGRect f = self.arrow.frame;
	f.origin.x = self.selectedTab.frame.origin.x + ((self.selectedTab.frame.size.width / 2) - (f.size.width / 2));
	self.arrow.frame = f;
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = self.bounds;
	f.size.width /= self.tabs.count;
	f.size.width -= (kTabMargin * (self.tabs.count + 1)) / self.tabs.count;
	for (BCTab *tab in self.tabs) {
		f.origin.x += kTabMargin;
		tab.frame = CGRectMake(floorf(f.origin.x), 0, f.size.width, f.size.height);//		tab.frame = CGRectMake(floorf(f.origin.x),  f.origin.y, floorf(f.size.width), f.size.height);//self.frame.size.height - floorf(contentHeight?contentHeight:f.size.height), floorf(f.size.width)
		f.origin.x += f.size.width;
		[self addSubview:tab];
//        [self addSubview:[self]]
        //create badge
//        if ([self viewWithTag:2008]) {
        //[[self viewWithTag:2008] removeFromSuperview];
//        }
	}
    [[self viewWithTag:2008] removeFromSuperview];
    if (self.lableNum > 0) {
        CGRect frame;
        if (self.lableNum  < 10) {
            frame = CGRectMake(216, -20, 100, 20);
        } else if(self.lableNum < 100) {
            frame = CGRectMake(208, -20, 100, 20);
        } else
        {
            frame = CGRectMake(201, -20, 100, 20);
        }            
        [self addSubview:[self badgeTextView:frame]];
    }
//    NSLog(@"bctabbar === layoutView is %@",[NSValue valueWithCGRect:self.frame]);
    //216 1
    //208 2
    //201 3
	[self positionArrowAnimated:NO];
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}

- (void)dealloc {
    RELEASE_SAFELY(_tabs);
    RELEASE_SAFELY(_selectedTab);
    RELEASE_SAFELY(_backgroundImage);
    RELEASE_SAFELY(_arrow);
    [super dealloc];
}
@end
