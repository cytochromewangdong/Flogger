    //
    //  SettingAboutViewController.m
    //  Flogger
    //
    //  Created by jwchen on 12-2-4.
    //  Copyright (c) 2012年 jwchen. All rights reserved.
    //

#import "SettingPushNotification.h"
#import "SingleShareCell.h"
#import "FloggerTableView.h"
#import "GlobalData.h"
#import "AccountServerProxy.h"
#import "GlobalData.h"
#import <Three20UICommon/Three20UICommon+Additions.h>

@implementation SettingPushNotification
@synthesize tableV;
BOOL _status_1,_status_2,_status_3,_status_4,_status_5;

-(void) dealloc
{
    self.tableV.delegate = nil;
    self.tableV.dataSource = nil;
    self.tableV = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
}
-(BOOL) checkIsFullScreen
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
        // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
        // Release any cached data, images, etc that aren't in use.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kPushInfo]) {
        Pushinfo *push = [[[Pushinfo alloc] init] autorelease];//(Pushinfo *) [[NSUserDefaults standardUserDefaults] objectForKey:kPushInfo];
        push.dataDict = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kPushInfo]];
        _status_1 = [push.likeflg intValue] == 0 ? YES:NO;
        _status_2 = [push.commentflg intValue] == 0 ? YES:NO;
        _status_3 = [push.followflg intValue] == 0 ? YES: NO;
        _status_4 = [push.tagflg intValue] == 0 ? YES:NO;
        _status_5 = [push.uploadflg intValue] == 0 ? YES:NO;
        
    } else {
        _status_1 = YES;
        _status_2 = YES;
        _status_3 = YES;
        _status_4 = YES;
        _status_5 = YES;
    }

    [self setNavigationTitleView:NSLocalizedString(@"Push Notification", @"Push Notification")];
}

-(void) adjustSettingAboutView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
    self.view = view;
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped] autorelease];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    if ([GlobalUtils checkIOS_6]) {
        tableView.backgroundView = nil;
    }
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView]; 
    
    self.tableV = tableView;
    
    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Done", @"Done") image:nil];
}
-(void) rightAction:(id)sender
{
    AccountCom *account = [[[AccountCom alloc] init] autorelease];
    account.pushtoken = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken];
//    account.pushinfo;
    Pushinfo *pushInfo = [[[Pushinfo alloc] init] autorelease];
    //New Likes
    //New Comments
    //New Followers
    //Tagged
    // 0 : on 1:off 
    pushInfo.likeflg =  [NSNumber numberWithInt:(_status_1 ? 0 : 1)];
    pushInfo.commentflg = [NSNumber numberWithInt:(_status_2 ? 0 : 1)];
    pushInfo.followflg = [NSNumber numberWithInt:(_status_3 ? 0 : 1)];
    pushInfo.tagflg = [NSNumber numberWithInt:(_status_4 ? 0 : 1)];
    pushInfo.uploadflg = [NSNumber numberWithInt:(_status_5 ? 0 :1)];
    account.pushinfo = pushInfo;
    
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    AccountServerProxy *accountServerPro = (AccountServerProxy *)self.serverProxy;
    [accountServerPro updatePushStatus:account];
    
    //save push info
    [[NSUserDefaults standardUserDefaults] setValue:pushInfo.dataDict forKey:kPushInfo];

}

//-(void)rightAction:(id)sender
//{
//   [self doRequest];
//    
//}

#pragma mark - View lifecycle
-(void) loadView
{
    [self adjustSettingAboutView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void) myReleaseSource
{
//    self.tableV = nil;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
    [self myReleaseSource];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    NSUInteger row = [indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [[cell viewWithTag:row + 100] removeFromSuperview];
    
    UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width-100, cell.frame.size.height/4, 80, cell.frame.size.height*3/4)]
                            autorelease];
    switchView.tag = row + 100;
    [switchView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //New Likes
    //New Comments
    //New Followers
    //Tagged
    //Video Uploaded
    
    switch(row)
    {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"New Likes", @"New Likes");//NSLocalizedString(@"关注信息", @"关注信息") ; 
            [switchView setOn:_status_1];
            [cell addSubview:switchView];
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"New Comments", @"New Comments");
            //NSLocalizedString(@"like信息",@"like信息");
            [switchView setOn:_status_2];
            [cell addSubview:switchView];
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"New Followers", @"New Followers");//NSLocalizedString(@"评论信息", @"评论信息") ;
            [switchView setOn:_status_3];
            [cell addSubview:switchView];
            break;
        case 3:
            cell.textLabel.text = NSLocalizedString(@"Tagged", @"Tagged");//NSLocalizedString(@"@信息",@"@信息");
            [switchView setOn:_status_4];
            [cell addSubview:switchView];
            break;
        case 4:
            cell.textLabel.text = NSLocalizedString(@"Video uploaded", @"Video uploaded");
            [switchView setOn:_status_5];
            [cell addSubview:switchView];
        default:
            
            break;
    }
    
    return cell;
}


-(void)valueChanged:(id)sender 
{
//    BOOL status=((UISwitch *)sender).isOn;
    int row=((UISwitch *)sender).tag - 100;
    switch (row) {
        case 0:
            _status_1 = !_status_1;
            break;
        case 1:
            _status_2 = !_status_2;
            break;
        case 2:
            _status_3 = !_status_3;
            break;
        case 3:
            _status_4 = !_status_4;
            break;    
        case 4:
            _status_5 = !_status_5;
        default:
            break;
    }
    [self.tableV reloadData];
    
    

//    if (row==0 && !status) {
////        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
//        _status_1=status;
//    }
//    else if (row==0 && status) {
////        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
////         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//        _status_1=status;
//    }
//    else if (row==1 && status) {
//        _status_2=status;
//    }
//    else if (row==1 && !status){
//        _status_2=status;
//    }
//    else if (row==2 && status) {
//        _status_3=status;
//    }
//    else if (row==2 && !status){
//        _status_3=status;
//    }
//    else if (row==3 && status) {
//        _status_4=status;
//    }
//    else if (row==3 && !status){
//        _status_4=status;
//    }
}

#pragma mark - Table view delegate


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 50;
}

//-(void)doRequest
//{
//    [[self.view.window findFirstResponder] resignFirstResponder];
//    
//    
//    AccountCom *com = [[[AccountCom alloc] init] autorelease];
//
//    
//    if (self.loading) {
//        return;
//    }
//    
//    self.loading = YES;
//    
//    if (!self.serverProxy) {
//        self.serverProxy = [[[AccountServerProxy alloc] init] autorelease];
//        self.serverProxy.delegate = self;
//    }
//    
//    [((AccountServerProxy *)self.serverProxy) resetPassword:com];
//    
//}


-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    
//    AccountCom *myAccountCom = [GlobalData sharedInstance].myAccount;
//    AccountCom *com = (AccountCom *)serverproxy.response;
//    [[GlobalData sharedInstance]saveLoginAccount];
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
