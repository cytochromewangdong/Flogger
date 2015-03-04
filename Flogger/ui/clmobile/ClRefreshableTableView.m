//
//  ClRefreshableTableView.m
//  Flogger
//
//  Created by jwchen on 12-2-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClRefreshableTableView.h"

@implementation ClRefreshableTableView
@synthesize refreshHeaderView, lastUpdateDate, refreshableTableDelegate;

-(void)setupRefreshableView:(CGRect)frame
{
    self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, frame.size.width, self.tableView.bounds.size.height)] autorelease];
    self.refreshHeaderView.delegate = self;
    [self.tableView addSubview:self.refreshHeaderView];    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupRefreshableView:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupRefreshableView:self.frame];
    }
    return self;
}

-(void)dealloc
{
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doneLoadingTableViewData) object:nil];
    self.refreshHeaderView = nil;
    self.lastUpdateDate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
	[self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)refreshDataSource
{
    if(self.refreshableTableDelegate && [self.refreshableTableDelegate respondsToSelector:@selector(refreshDataSource:)])
    [self.refreshableTableDelegate refreshDataSource:self];
}

- (void)doneLoadingTableViewData{
	
//    self.lastUpdateDate = [NSDate date];
	//  model should call this when its done loading
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self refreshDataSource];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doneLoadingTableViewData) object:nil];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.5];
}
-(void)cancelAll
{
    self.refreshHeaderView.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doneLoadingTableViewData) object:nil];  
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return self.isLoading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return self.lastUpdateDate;
}

@end
