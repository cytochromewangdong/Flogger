//
//  ClTableView.m
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClTableView.h"
#import "MBProgressHUD.h"

@implementation ClTableView
@synthesize tableView, isLoading = _isLoading, indicatorView, dataArr, dataSource, delegate, dataDictionary, hideSectionHeader,custHeight;

-(void)setupTableViewWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style
{
    self.dataArr = [[[NSMutableArray alloc] init] autorelease];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:style] autorelease];
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor =[UIColor clearColor];
//    self.tableView.allowsSelection =NO
    
    self.indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    self.indicatorView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    [self addSubview:self.indicatorView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupTableViewWithFrame:frame withStyle:UITableViewStylePlain];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupTableViewWithFrame:frame withStyle:style];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupTableViewWithFrame:self.frame withStyle:UITableViewStylePlain];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
//    isLoading? [self.indicatorView startAnimating] : [self.indicatorView stopAnimating];
    return;
    if (isLoading) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *progressHud;
            progressHud = [MBProgressHUD showHUDAddedTo:self animated:NO];
            progressHud.labelText = NSLocalizedString(@"Loading...", @"Loading...") ;
        });
        
    }
    else 
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self animated:NO];
        });
    }
}

-(void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
    self.indicatorView = nil;
    self.dataArr = nil;
    self.dataDictionary = nil;
    [super dealloc];
}

-(NSArray *)key
{
    NSArray *key = [self.dataDictionary allKeys];
    return key;
}

#pragma mark - tableview datesource
//override methods below to custom
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataDictionary) {
        NSString *key = [[self key] objectAtIndex:section];
        
        NSArray *valueArr = (NSArray *)[self.dataDictionary objectForKey:key];
        return valueArr.count;
    }
    else
    {
        NSLog(@"dataarr is %d",self.dataArr.count);
        return self.dataArr.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataDictionary) {
        return [self key].count;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource) {
        return [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
    }
    NSLog(@"cltable view datasource is nil");
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.dataDictionary && !hideSectionHeader) 
    {
        return [[self key] objectAtIndex:section];
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(custHeight)
    {
        return custHeight;
    }
    if (self.delegate) {
        return [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    }
    return 50;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (self.dataDictionary) {
//        return <#expression#>
//    }
//    return 50;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        [self.delegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end
