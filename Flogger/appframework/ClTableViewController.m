//
//  JwBaseTableViewController.m
//  TingJing2
//
//  Created by jwchen on 11-9-17.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import "ClTableViewController.h"

@implementation ClTableViewController
@synthesize tableView = _tableView;

-(void)dealloc
{
    self.tableView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.tableView) {
        self.tableView = [[[ClTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)] autorelease];
        [self.view addSubview: self.tableView];
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)setLoading:(BOOL)isLoading
{
    _loading = isLoading;
    self.tableView.isLoading = isLoading;
}

- (void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(ClTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
