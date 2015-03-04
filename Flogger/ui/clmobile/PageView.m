//
//  PageView.m
//  Flogger
//
//  Created by jwchen on 12-1-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "PageView.h"

@implementation PageView
@synthesize scrollview, pagecontrol;

-(void)setUpView
{
    self.scrollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    self.scrollview.scrollEnabled = YES;
    self.scrollview.delegate = self;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.showsVerticalScrollIndicator = NO;
//    self.scrollview.pagingEnabled = YES;
//    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width * 2, self.scrollview.frame.size.height)];
     self.scrollview.pagingEnabled = NO;
        [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, self.scrollview.frame.size.height)];
    [self addSubview:self.scrollview];
    
    self.pagecontrol = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    self.pagecontrol.hidden = YES;
//    [self.pagecontrol addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pagecontrol];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpView];
    }
    return self;

}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (_pageControlIsChangingPage) {
        return;
    }
//    CGFloat pageWidth = _scrollView.frame.size.width;
//    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    self.pagecontrol.currentPage = page;
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex: %d", buttonIndex);
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    _pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark PageControl stuff
- (void)changePage:(NSNumber *)sender 
{
	/*
	 *	Change the scroll view
	 */
    CGRect frame = self.scrollview.frame;
    frame.origin.x = frame.size.width * [sender intValue];//self.pagecontrol.currentPage;
        
    frame.origin.y = 0;
//	NSLog(@"self.pagecontrol.currentPage is %d",[sender intValue]);
    [self.scrollview scrollRectToVisible:frame animated:YES];
    _pageControlIsChangingPage = YES;
}


-(void)dealloc{
    self.scrollview = nil;
    self.pagecontrol = nil;
    [super dealloc];
}

@end
