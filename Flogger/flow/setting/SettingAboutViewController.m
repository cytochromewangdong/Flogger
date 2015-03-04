//
//  SettingAboutViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SettingAboutViewController.h"
#import "ChildViewController.h"

@implementation SettingAboutViewController

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
    [self setNavigationTitleView:NSLocalizedString(@"About", @"About")];
}

-(void) adjustSettingAboutView
{
    //UIImage *backgroundImage = [[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND];
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
//    view.backgroundColor =[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];// [[[UIColor alloc] initWithPatternImage:backgroundImage] autorelease];
    self.view = view;
    
    UITextView *textV = [[FloggerUIFactory uiFactory] createTextView];
    textV.frame = CGRectMake(10, 10, 296, 140);
    textV.text = NSLocalizedString(@"Flogger is a fun way to capture and share beatiful photos and videos to the rest of the world.We are based right in the heart of the booming city of Shanghai,China.Our goal is to constantly add new features and ideas to enhance your user experience!", @"Flogger is a fun way to capture and share beatiful photos and videos to the rest of the world.We are based right in the heart of the booming city of Shanghai,China.Our goal is to constantly add new features and ideas to enhance your user experience!");
    textV.textAlignment = UITextAlignmentCenter;
    textV.backgroundColor = [UIColor clearColor];
    textV.font = [[FloggerUIFactory uiFactory] createSmallBoldFont];
//    textV.editable = NO;
//    textV.scrollEnabled = NO;
    textV.userInteractionEnabled = NO;
//    UILabel *textV = [[FloggerUIFactory uiFactory] createLable];
//    textV.frame = CGRectMake(10, 10, 296, 140);
//    textV.text = NSLocalizedString(@"Flogger is a fun way to capture and share beatiful photos and videos to the rest of the world.We are based right in the heart of the booming city of Shanghai,China.Our goal is to constantly add new features and ideas to enhance your user experience!", @"Flogger is a fun way to capture and share beatiful photos and videos to the rest of the world.We are based right in the heart of the booming city of Shanghai,China.Our goal is to constantly add new features and ideas to enhance your user experience!");
//    textV.textAlignment = UITextAlignmentCenter;
//    textV.backgroundColor = [UIColor clearColor];
//    textV.font = [[FloggerUIFactory uiFactory] createSmallBoldFont];
//    [textV sizeToFit];
    
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 5, 320, 150) style:UITableViewStyleGrouped] autorelease];//[[FloggerUIFactory uiFactory] createTableView];
//    tableView sets
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    if ([GlobalUtils checkIOS_6]) {
        tableView.backgroundView = nil;
    }
    tableView.scrollEnabled = NO;
//    tableView.frame = CGRectMake(10, 158, 300, 208);
    
//    [self.view addSubview:textV];
    [self.view addSubview:tableView];
    
//    [self sett]
//    self.navigationItem.leftBarButtonItem = []
    
//    UIImage *backImage = [[FloggerUIFactory uiFactory] createImage:SNS_BACK_BUTTON];
//    UIBarButtonItem *backBarItem = [[[UIBarButtonItem alloc] init] autorelease];
//    [backBarItem setBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [backBarItem setTitle:NSLocalizedString(@"Back", @"Back")];
//    self.navigationItem.leftBarButtonItem = backBarItem;
    
}

#pragma mark - View lifecycle
-(void) loadView
{
    [self adjustSettingAboutView];
}

- (void)viewDidLoad
{
    self.title = @"";
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
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


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        NSLog(@"cell == nil");
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
    }
//    cell.textLabel.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
    NSUInteger row = [indexPath row];
    switch(row)
    {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Terms and Conditions", @"Terms and Conditions") ;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"Privacy Policy",@"Privacy Policy");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    ChildViewController *childControl = [[[ChildViewController alloc] init] autorelease];
    NSMutableDictionary *webInfo = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    switch(row)
    {
        case 0://条款
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.iflogger.com/Flogger/terms.html"]];
        {
            [webInfo setObject:@"http://www.folo.mobi/Flogger/terms.html" forKey:kWebURLPath];
            [webInfo setObject:NSLocalizedString(@"Terms and Conditions", @"Terms and Conditions") forKey:kWebTitle];
            
        }
            break;
        case 1://隐私政策
//          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.iflogger.com/Flogger/privacy.html"]];
        {
            [webInfo setObject:@"http://www.folo.mobi/Flogger/privacy.html" forKey:kWebURLPath];
            [webInfo setObject:NSLocalizedString(@"Privacy Policy",@"Privacy Policy") forKey:kWebTitle];
        }
            break;
        default:
            break;
    }
    childControl.webInfoDic = webInfo;
    [self.navigationController pushViewController:childControl animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 50;
}


@end
