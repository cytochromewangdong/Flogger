//
//  ClPageTableView.m
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClPageTableView.h"
#import "BaseEntity.h"

#define kPAGE_SIZE 20

@implementation ClPageTableView
@synthesize currentPage, pageSize, isLoadingMore = _isLoadingMore, pageDelegate, startId, endId, hasMore = _hasMore, idKey;
@synthesize currentIndexPath;

-(void)setupPageView:(CGRect)frame
{
    self.currentPage = 1;
    self.pageSize = kPAGE_SIZE;
    self.idKey = @"id";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupPageView:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupPageView:self.frame];
    }
    return self;
}

-(BOOL)isHasMore:(NSArray *)dataArray;
{
    return dataArray.count >= self.pageSize;
}

-(void) loadingMore
{
    self.isLoadingMore = YES;
    
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageTableViewRequestLoadingMore:)]) {
        [self.pageDelegate pageTableViewRequestLoadingMore:self];
    }
}

-(void) checkMore:(NSArray *)dataArray
{
    _hasMore = [self isHasMore:dataArray];
}

-(BOOL) isCellForMore:(NSUInteger)index
{
    return index == self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _hasMore? [super tableView:tableView numberOfRowsInSection:section] + 1 : 
    [super tableView:tableView numberOfRowsInSection:section];
}

-(NSInteger)heightForMore
{
    return 60;
}

-(UITableViewCell *) cellForMore:(UITableView *)tableView
{
    _moreViewCell = [tableView dequeueReusableCellWithIdentifier:@"MoreItem"];
    if (_moreViewCell == nil)
    {
        _moreViewCell = [[[ClMoreViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreItem"] autorelease];
        _moreViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _moreViewCell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _moreViewCell;
}

-(BOOL) canLoading
{
    return self.isLoading && !_isLoadingMore;
}

-(void) setIsLoadingMore:(BOOL)isLoadingMore
{
    if (isLoadingMore) {
        _isLoadingMore = YES;
        _moreViewCell.animating = YES;
    }
    else
    {
        _isLoadingMore = NO;
        _moreViewCell.animating = NO;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isCellForMore:[indexPath row]]) {
        return [self cellForMore:tableView];
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isCellForMore:[indexPath row]]) {
        return [self heightForMore];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isCellForMore:[indexPath row]]) {
//        [self loadingMore];
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void)dealloc
{
    self.idKey = nil;
    self.currentIndexPath = nil;
    [super dealloc];
}

-(NSNumber *)startId
{
    NSNumber *ret = [NSNumber numberWithLongLong:-1];
    for (BaseEntity * entity in self.dataArr) {
        NSNumber *currID = [entity objectForKey:idKey];
        if(!currID)
        {
            continue;
        }
        NSComparisonResult result = [currID compare:ret];
        if (result>0)
        {
            ret = currID;
        }
        //[((BaseEntity *)[self.dataArr objectAtIndex:0]) objectForKey:idKey]
    }
    return ret;
    //return (self.dataArr && self.dataArr.count > 0)? [((BaseEntity *)[self.dataArr objectAtIndex:0]) objectForKey:idKey] : [NSNumber numberWithInt:-1];
}

-(NSNumber *)endId
{
    if(self.dataArr.count <= 0)
    {
        return [NSNumber numberWithInt:-1];
    }
    NSNumber *ret = nil;//[[self.dataArr objectAtIndex:0]objectForKey:idKey];
    for (BaseEntity * entity in self.dataArr) {
        NSNumber *currID = [entity objectForKey:idKey];
        if(!currID)
        {
            continue;
        }
        if(!ret)
        {
           ret = currID;
        }
        NSComparisonResult result = [currID compare:ret];
        if (result<0)
        {
            ret = currID;
        }
        //[((BaseEntity *)[self.dataArr objectAtIndex:0]) objectForKey:idKey]
    }
    if(!ret)
    {
        return [NSNumber numberWithInt:-1];
    }
    return ret;
    //NSLog(@"==== idkey is %@",idKey);
    //return (self.dataArr && self.dataArr.count > 0)? [((BaseEntity *)[self.dataArr objectAtIndex:self.dataArr.count - 1]) objectForKey:idKey] : [NSNumber numberWithInt:-1];
}

//static NSIndexPath *tablePath;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{   
//    NSArray *visibleRows = [self.tableView visibleCells];
//    UITableViewCell *lastVisibleCell = [visibleRows lastObject];
//    NSIndexPath *path = [self.tableView indexPathForCell:lastVisibleCell];
//    if (path.section == self.currentIndexPath.section && path.row == self.currentIndexPath.row) {
//        if ([self isCellForMore:[path row]]) {
//            [self loadingMore];
//        }
//    }
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSArray *visibleRows = [self.tableView visibleCells];
    UITableViewCell *lastVisibleCell = [visibleRows lastObject];
    NSIndexPath *path = [self.tableView indexPathForCell:lastVisibleCell];
    if (path.section == self.currentIndexPath.section && path.row == self.currentIndexPath.row) {
        if ([self isCellForMore:[path row]]) {
            [self loadingMore];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{   
    CGFloat height = scrollView.frame.size.height;
    
    CGFloat contentYoffset = scrollView.contentOffset.y;
    
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if(distanceFromBottom < height) 
    {
//        NSLog(@"end of the table");
        NSArray *visibleRows = [self.tableView visibleCells];
        UITableViewCell *lastVisibleCell = [visibleRows lastObject];
        NSIndexPath *path = [self.tableView indexPathForCell:lastVisibleCell];
        self.currentIndexPath = path;
    }else {
        [super scrollViewDidScroll:scrollView];
    }
}

@end
