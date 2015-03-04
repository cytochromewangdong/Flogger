//
//  GridPageView.m
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FeedGridPageView.h"

@implementation FeedGridPageView
@synthesize leftPageView, rightPageView, delegate;

-(void)setupGridPageViewWithFrame:(CGRect)frame
{
    self.leftPageView = [[[FeedGridPageTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
    self.leftPageView.tag = 0;
    self.leftPageView.feedGridTableViewDelegate = self;
    self.leftPageView.tableView.separatorColor = [UIColor clearColor];
    [self.scrollview addSubview:self.leftPageView];
    
    self.rightPageView = [[[FeedGridPageTableView alloc] initWithFrame:CGRectMake(leftPageView.frame.size.width, 0, frame.size.width, frame.size.height)] autorelease];
    self.rightPageView.feedGridTableViewDelegate = self;
    self.rightPageView.tag = self.leftPageView.tag + 1;
    self.rightPageView.tableView.separatorColor = [UIColor clearColor];
    [self.scrollview addSubview:self.rightPageView];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGridPageViewWithFrame:frame];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupGridPageViewWithFrame:self.frame];
    }
    
    return self;
}

-(void)dealloc
{
    self.leftPageView = nil;
    self.rightPageView = nil;
    [super dealloc];
}

-(void)feedGridPageTableView:(FeedGridPageTableView *)feedGridPageTableView atRow:(NSInteger)row withIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectFeedGridPageView:atPage:index:)]) {
        [self.delegate selectFeedGridPageView:self atPage:feedGridPageTableView.tag index:index];
    }
}

@end
