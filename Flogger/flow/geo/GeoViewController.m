//
//  GeoViewController.m
//  Flogger
//
//  Created by jwchen on 12-3-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "GeoViewController.h"
#import "GeoInfoServerProxy.h"
#import "GeographicalInfo.h"
#import "LocationManager.h"

@implementation GeoViewController

@synthesize keyTf;
@synthesize delegate, timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(BOOL) checkIsFullScreen
{
    return YES;
}

-(void)doRequest
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    
    if (![LocationManager sharedInstance].currentLocation) {
        
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
        [[LocationManager sharedInstance] startUpdatingLocationWithDelegate:self];
        return;
    }
    
    if (!self.serverProxy) {
        self.serverProxy = [[[GeoInfoServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    GeoInfoCom *com = [[[GeoInfoCom alloc] init] autorelease];
    [((GeoInfoServerProxy *)self.serverProxy) getGeoInfo:com];
}


-(void) adjustGeoViewLayout
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
    self.view = view;
    
    UITextField *searchField = [[FloggerUIFactory uiFactory] createSearchTextField];
    searchField.frame = CGRectMake(28, 9, 265, 31);
    searchField.placeholder = NSLocalizedString(@"Where are you?", @"Where are you?");
    searchField.delegate = self;
    searchField.returnKeyType = UIReturnKeyDone;
    ClPageTableView *clTableView = [[[ClPageTableView alloc] initWithFrame:CGRectMake(0, 48, 320, 368)] autorelease];
    clTableView.dataSource = self;
    clTableView.delegate = self;
    
    UIImage *gIcon = [[FloggerUIFactory uiFactory] createImage:SNS_POWERED_BY_GOOGLE];
    UIImageView *gIconImageV = [[FloggerUIFactory uiFactory] createImageView:gIcon];
    gIconImageV.frame = CGRectMake(310-gIcon.size.width, 400-gIcon.size.height, gIcon.size.width, gIcon.size.height);
    gIconImageV.userInteractionEnabled = NO;
    
    
    [self.view addSubview:searchField];
    [self.view addSubview:clTableView];
    [self.view addSubview:gIconImageV];
    
    [self setKeyTf:searchField];
    [self setTableView:clTableView];
}

-(void)timeOut
{
//    NSLog(@"get gps time out!");
    [self.timer invalidate];
    self.timer = nil;
    [LocationManager sharedInstance].delegate = nil;
    if (![LocationManager sharedInstance].currentLocation) {
        
        [GlobalUtils showAlert: NSLocalizedString(@"Hint", @"Hint") message:NSLocalizedString(@"Can't get your location, please try later!",@"Can't get your location, please try later!")];
        self.loading = NO;
    }
}

-(void)locationManager:(LocationManager *)locationManager didUpdateToLocation:(CLLocation *)location
{
    [self.timer invalidate];
    self.timer = nil;
    locationManager.delegate = nil;
    self.loading = NO;
    [self doRequest];
}

#pragma mark - View lifecycle
-(void) loadView
{
    [self adjustGeoViewLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setLeftNavigationBarWithTitle:NSLocalizedString(@"Back", @"Back") image:nil];
    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Done", @"Done") image:nil];
    [self doRequest];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    self.keyTf = nil;
    [self.timer invalidate];
    self.timer = nil;
    [LocationManager sharedInstance].delegate = nil;
    [super dealloc];
}

-(void) refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    [self doRequest];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    [self.tableView.dataArr addObjectsFromArray:((GeoInfoCom *)serverproxy.response).geoInfoList];
    [self.tableView.tableView reloadData];
    
}

-(UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [self.tableView.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    GeographicalInfo *info = [self.tableView.dataArr objectAtIndex:[indexPath row]];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = info.visinity;
    UILabel *lineLab = [[FloggerUIFactory uiFactory] createLable];
    lineLab.frame = CGRectMake(0, 50, 320, 1);
    lineLab.backgroundColor =  [UIColor colorWithRed:181/255.0  green:180/255.0 blue:174/255.0 alpha:1.0];
    
    UILabel *lineLab2 = [[FloggerUIFactory uiFactory] createLable];
    lineLab2.frame = CGRectMake(0, 51, 320, 1);
    lineLab2.backgroundColor =  [UIColor whiteColor];
    [cell addSubview:lineLab];
    [cell addSubview:lineLab2];
    return cell;
}

-(void)didSelectionLocation:(NSString *)location
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(geoLocationSelected:)]) {
        [self.delegate geoLocationSelected:location];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView: NSLocalizedString(@"Places",@"Places")];
    //    [self registerForTextFieldTextChangedNotification];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.keyTf resignFirstResponder];
}

-(void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GeographicalInfo *info = [self.tableView.dataArr objectAtIndex:[indexPath row]];
//    [self didSelectionLocation:[NSString stringWithFormat:@"%@, %@", info.name, info.visinity]];
    [self didSelectionLocation:info.name];
}

-(void)rightAction:(id)sender
{
    [self didSelectionLocation:self.keyTf.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
