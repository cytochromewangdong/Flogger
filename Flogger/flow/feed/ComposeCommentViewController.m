//
//  ComposeCommentViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ComposeCommentViewController.h"
#import "UploadServerProxy.h"
#import "IssueInfoCom.h"
#import "GlobalData.h"
#import "IssueinfoBean.h"
#import "FloggerCameraControl.h"
#import "TagViewController.h"
#import "TopicViewController.h"
#import "EntityEnumHeader.h"
#import "GeoViewController.h"
#import "AsyncTaskManager.h"
#import "ShareConfigurationView.h"
#import "SingleShareCell.h"
#import "ExternalBindViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"

@interface ComposeCommentViewController(){
@private
}
@property(nonatomic, retain) UIImage *image;
//@property(nonatomic, retain) NSData *videoData;
@property(nonatomic, retain) NSString *videoPath;
@property(nonatomic, retain) NSString *photoPath;
@property(nonatomic, retain) NSDictionary *cameraInfo;
@end

@implementation ComposeCommentViewController
@synthesize image;
//@synthesize videoData;
@synthesize videoPath,photoPath;
@synthesize delegate;
@synthesize countLabel, geoLabel, actionView, issueinfo,groupid;
@synthesize cameraInfo;
@synthesize composeView;
@synthesize tableV;
@synthesize reverseGeocoder;
@synthesize isCamera;


-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:kComposeWebAction object:nil];
    [self registerForKeyboardNotifications];
}

-(void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kComposeWebAction object:nil];
    [self unregisterForKeyboardNotifications];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        groupid = -1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void) adjustComposeLayout
{

    
//    UITextView *messageTextView = [[FloggerUIFactory uiFactory] createTextView];
//    messageTextView.frame = CGRectMake(0, 0, 320, 145);
//    messageTextView.delegate = self;
//    [self.view addSubview:messageTextView];
    
    //action view
    UIImage *tagImage = [[FloggerUIFactory uiFactory] createImage:SNS_INSERT_TAG];
    UIImage *atImage = [[FloggerUIFactory uiFactory] createImage:SNS_INSERT_AT];
    UIImage *locationImage = [[FloggerUIFactory uiFactory] createImage:SNS_GEOTAG_ICON];
    
    UIView *actionV = [[FloggerUIFactory uiFactory] createView];
    actionV.frame = CGRectMake(0, 145, 320, 30);
    int actionHeight = 0;
    
    UIButton *tagBtn = [[FloggerUIFactory uiFactory] createButton:tagImage];
    tagBtn.frame = CGRectMake(15, actionHeight, tagImage.size.width, tagImage.size.height);
    [tagBtn addTarget:self action:@selector(topicBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *atBtn = [[FloggerUIFactory uiFactory] createButton:atImage];
    atBtn.frame = CGRectMake(62, actionHeight, atImage.size.width, atImage.size.height);
    [atBtn addTarget:self action:@selector(atBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *geoBtn = [[FloggerUIFactory uiFactory] createButton:locationImage];
    geoBtn.frame = CGRectMake(105, actionHeight, locationImage.size.width, locationImage.size.height);
    [geoBtn addTarget:self action:@selector(geoBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *locationLab = [[FloggerUIFactory uiFactory] createLable];
    locationLab.font = [UIFont systemFontOfSize:14];
    locationLab.frame = CGRectMake(geoBtn.frame.origin.x + geoBtn.frame.size.width + 10, actionHeight, 130, 25);
    locationLab.textAlignment = UITextAlignmentCenter;
    
    UILabel *countLab = [[FloggerUIFactory uiFactory] createLable];
    countLab.frame = CGRectMake(276, actionHeight, 45, 25);
    countLab.font = [UIFont boldSystemFontOfSize:14];
    countLab.text = @"140";
    
    [actionV addSubview:tagBtn];
    [actionV addSubview:atBtn];
    [actionV addSubview:geoBtn];
    [actionV addSubview:locationLab];
    [actionV addSubview:countLab];
    
    [self.view addSubview:actionV];
    
    [self setActionView:actionV];
    [self setCountLabel:countLab];
    [self setGeoLabel:locationLab];
    
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, actionV.frame.origin.y + actionV.frame.size.height+5, 320, 226) style:UITableViewStyleGrouped]autorelease];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 45;
    [self.view addSubview:tableView];
    
    self.tableV = tableView;
    
}
#pragma mark - View lifecycle
- (void) handleAction:(NSNotification *)notification
{
    if(notification.object)
    {
        if([@"countLen" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
        {
            NSString *length = [notification.object objectForKey:@"length"];
            self.countLabel.text = length;
            //objectForKey 
            return;
        } 
        
    } else {
        [self fillDataToWebView];
    }
}



-(void) fillDataToWebView
{
    
}

-(void) loadView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    self.navigationController.view.backgroundColor = [UIColor blueColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.composeView = [[FloggerWebAdapter getSingleton]getComposeView]; 
    self.composeView.frame = CGRectMake(0, 0, 320, 140);
    [self registerNotification];
    if([self.composeView isLoaded])
    {
        [self fillDataToWebView];
    }
    [self.view addSubview:self.composeView];
    
    [self adjustComposeLayout];
    
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.na
    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Post", @"Post") image:nil];
    if (!isCamera) {
        [self setLeftNavigationBarWithTitle:NSLocalizedString(@"Cancel", @"Cancel") image:nil];
    }
        
    [self requestGeoByGeoCoder];

}

-(void)requestGeoByGeoCoder
{
    self.loading = YES;
    CLLocation *currentLocation = [LocationManager sharedInstance].currentLocation;
    
    if (currentLocation) {
        CLLocationCoordinate2D coord = currentLocation.coordinate;
        MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coord];
        geocoder.delegate = self;
        self.reverseGeocoder = geocoder;
        [geocoder start];
        [geocoder release];
        
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"获取地址失败");
    self.loading = NO;
//    self.geoLabel.text = @"ShangHai China";
    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    
    //获取到地址 
//    NSString *tmpPro = placemark.administrativeArea;
    NSString *tmpPro = [NSString stringWithFormat:@"%@ %@",placemark.administrativeArea,placemark.country];
    self.geoLabel.text = tmpPro;
    self.loading = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count is %d",[GlobalData sharedInstance].exPlatform.externalplatforms.count);
    return [GlobalData sharedInstance].exPlatform.externalplatforms.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
-(Externalaccount *)getExternalAccount:(Externalplatform *)platform
{
    for (Externalaccount *eaccount in [GlobalData sharedInstance].myAccount.externalaccounts) {
        if ([eaccount.usersource intValue] == [platform.id intValue]) {
            return eaccount;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleShareCell *cell = nil;
    static NSString *kSourceCellID = @"SourceCellID";
    cell = [self.tableV dequeueReusableCellWithIdentifier:kSourceCellID];
    Externalplatform *externalPlatform = (Externalplatform *)[[GlobalData sharedInstance].exPlatform.externalplatforms objectAtIndex:indexPath.row];
    if (cell == nil)
    {
        cell = [[SingleShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID platform:externalPlatform account:[self getExternalAccount:externalPlatform]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
                
    }
    [cell.iconImage setImageWithURL:[NSURL URLWithString:externalPlatform.bigbutton]];
    cell.stringLabel.text = externalPlatform.name;
    
    if ([self getExternalAccount:externalPlatform]) {
        cell.unBindButton.hidden = YES;
        cell.configButton.hidden = YES;
        cell.switchButton.hidden = NO;
    } else {
        cell.unBindButton.hidden = YES;
        cell.configButton.hidden = NO;
        cell.switchButton.hidden = YES;
    }
    
    
    return cell;
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

-(void)singleShareView:(SingleShareCell *)singleShareView platform:(MyExternalPlatform *)platform
{
    ExternalBindViewController *vc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.platform = platform;
    vc.isBind = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)singleShareViewUnBind:(SingleShareCell *)singleShareView platform:(MyExternalPlatform *)platform
{
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init]  autorelease];
        self.serverProxy.delegate = self;
    }
    
    AccountCom *com = [[[AccountCom alloc] init] autorelease];
    com.usersource = platform.id;
    [((AccountServerProxy *)(self.serverProxy)) unBind:com];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.tableV reloadData];
}

//-(void)transactionFinished:(BaseServerProxy *)serverproxy
//{
//    [super transactionFinished:serverproxy];
//    AccountCom *com = (AccountCom *)serverproxy.response;
//    [GlobalData sharedInstance].myAccount.externalaccounts = com.externalaccounts;
//    [self.tableV reloadData];
//    [self.tableV setNeedsDisplay];
//    
//}

//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

-(void)keyboardWillBeShown:(NSNotification *)aNotification
{
    [super keyboardWillBeShown:aNotification];
    
    [UIView beginAnimations:nil context:nil];
    CGRect viewFrame = self.view.frame;
    CGRect actionFrame = self.actionView.frame;
    
    CGRect tmpFrame = CGRectMake(actionFrame.origin.x, viewFrame.size.height - actionFrame.size.height - self.keyboardRect.size.height, actionFrame.size.width, actionFrame.size.height);
    actionView.frame = tmpFrame;
 
    [UIView setAnimationDelay:100];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:200];
    [UIView commitAnimations];
}


-(void)doRequest
{
    if (self.loading) {
        return;
    }
    
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[UploadServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    IssueInfoCom *com = [[[IssueInfoCom alloc] init] autorelease];
    IssueinfoBean *tmpIssueinfo = [[[IssueinfoBean alloc] init] autorelease];
    com.issueinfo = tmpIssueinfo;
    tmpIssueinfo.location = self.geoLabel.text;
    
    if (self.issueinfo) {
        com.issueinfo.parentid = self.issueinfo.id;
    }
//    com.issueinfo.text = [messageTV text];
    com.issueinfo.text = [self.composeView stringByEvaluatingJavaScriptFromString:@"getText()"];
    NSLog(@"text is %@",com.issueinfo.text);
   
    NSInteger category = ISSUE_CATEGORY_TWEET;
    //NSData *data = nil;
    NSString *dataFile = nil;
    if (self.image) {
        //data = UIImageJPEGRepresentation(self.image, JPEGQUAILTY);
        dataFile = self.photoPath;
        category = ISSUE_CATEGORY_PICTURE;
        if ([self.cameraInfo objectForKey:fCameraInfoImageSize]) {
            NSValue *imageSizeValue = [self.cameraInfo objectForKey:fCameraInfoImageSize];
            CGSize imageSize = [imageSizeValue CGSizeValue];
            com.issueinfo.photowidth = [NSNumber numberWithFloat:imageSize.width];
            com.issueinfo.photoheight = [NSNumber numberWithFloat:imageSize.height];

        }
        com.issueinfo.filtersyntax = [self.cameraInfo objectForKey:fCameraInfoSyntax];
    } else if(self.videoPath){
        dataFile = self.videoPath;
        category = ISSUE_CATEGORY_VIDEO;        
    }
    
    
    
    com.issueinfo.issuecategory = [NSNumber numberWithInt:category];
    
    if(groupid != -1)    
    {
        NSLog(@"upload album groupid = %d",groupid);  
        com.groupID = [NSNumber numberWithInt:groupid] ;
        com.uploadType = [NSNumber numberWithInt:2];
    }
    com.usersourceList = [self getShareSourceList];
    
    [[AsyncTaskManager sharedInstance] addTask:self.serverProxy];
    
    [(UploadServerProxy *)self.serverProxy uploadFileIssue:com withData:dataFile];
    
//    [self backAction:nil];
    [self dismissModalViewControllerAnimated:YES];
}

-(NSMutableArray *)getShareSourceList
{
    NSMutableArray *souceList = [[[NSMutableArray alloc] init] autorelease];
    for (Externalaccount *eaccount in [GlobalData sharedInstance].myAccount.externalaccounts) {
        if ([eaccount.sharestatus boolValue]) {
            [souceList addObject:eaccount.usersource];
        }
    }
    
    return souceList;
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
//    [GlobalUtils showPostMessageAlert:@""];
    [super transactionFinished:serverproxy];
    
    
//    AccountCom *com = (AccountCom *)serverproxy.response;
//    [GlobalData sharedInstance].myAccount.externalaccounts = com.externalaccounts;
//    [self.tableV reloadData];
//    [self.tableV setNeedsDisplay];
    
    
    IssueInfoCom *com = (IssueInfoCom *)serverproxy.response;
    if (self.delegate) {
        [self.delegate composeResultDoneWithIssueInfoCom:com];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftAction:(id)sender
{
//    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
////    [self.messageTV resignFirstResponder];
//    if (!vc) {
//        [[GlobalData sharedInstance].menuView show];
//    }
    [self dismissModalViewControllerAnimated:YES];
}
-(BOOL) isEmpty:(NSString*) text
{
    return ![text length];
}

-(BOOL) checkInputValid
{
    NSString *string = [self.composeView stringByEvaluatingJavaScriptFromString:@"getText()"];
    
    if([self isEmpty:string])
    {        
        [GlobalUtils showAlert:NSLocalizedString(@"", @"") message:NSLocalizedString(@"Please write a message",@"Please write a message")];
        return NO;
    }
    return YES;
    
}

-(void)rightAction:(id)sender
{
    if (![self checkInputValid]) {
        return;
    }
        
    [self doRequest];
}

-(void)hideModeView
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)floggerCameraControlDidCancelledPickingMedia:(FloggerCameraControl *)cameraControl
{
    [self hideModeView];
    [self.navigationController popViewControllerAnimated:YES];    
}

-(void)cleanCamera
{
//    self.cameraControl = nil;
}

-(void)showCaptureMedia:(MediaType)mediaType
{
    FloggerCameraControl *cc = [[[FloggerCameraControl alloc] init] autorelease];
    cc.delegate = self;
    [self presentModalViewController:cc animated:NO];
//    self.cameraControl = cc;

    //[carmeraControl release];
}

-(void)atBtnTapped:(id)sender
{
    TagViewController *tagvc = [[TagViewController alloc] initWithNibName:nil bundle:nil];
    tagvc.delegate = self;
    [self.navigationController pushViewController:tagvc animated:YES];
    [tagvc release];
}

-(void)topicBtnTapped:(id)sender
{
    TopicViewController *tvc = [[TopicViewController alloc] initWithNibName:nil bundle:nil];
    tvc.delegate = self;
    [self.navigationController pushViewController:tvc animated:YES];
    [tvc release];
}

-(void)cameraTapped:(id)sender
{
//    [self showCaptureMedia];
    
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"Take Photo", @"Take Photo"), NSLocalizedString(@"Take Video", @"Take Video"), NSLocalizedString(@"Import from Gallery", @"Import from Gallery"), NSLocalizedString(@"Import from phone", @"Import from phone"), nil];
	
	ac.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[ac showInView:self.view];
	[ac release];
}

-(void)geoBtnTapped:(id)sender
{
    GeoViewController *gvc = [[[GeoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    gvc.delegate = self;
    [self.navigationController pushViewController:gvc animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self showCaptureMedia:MEDIA_PHOTO];
            break;
            
        default:
            break;
    }
}
-(void) setInfoFromCamera :(NSDictionary *) info 
{
    self.cameraInfo = info;
    self.image = [info objectForKey:fImage];
    self.videoPath = [info objectForKey:fVideoURL];
    self.photoPath = [info objectForKey:fImagePath];
//    self.videoData = [info objectForKey:fVideo];    
}

-(void)floggerCameraControl:(FloggerCameraControl *)cameraControl didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //self.image = [info objectForKey:fImage];
//    self.videoData = [info objectForKey:fVideo];
    //self.cameraInfo = info;
    [self setInfoFromCamera:info];
    [self dismissModalViewControllerAnimated:YES];
//    [messageTV becomeFirstResponder];
}

-(void)didSelectedTopic:(NSString *)topic
{
    if (topic && topic.length > 0) {
       
        //self.messageTV.text = [NSString stringWithFormat:@"%@#%@#", preStr, topic];
        [self.composeView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"appendContext('#%@#')",topic]];
        //[self textViewDidChange:self.messageTV];
    }
}

-(void)geoLocationSelected:(NSString *)location
{
    self.geoLabel.text = location;
}

-(void)didAtSelection:(NSString *)username
{
    if (username && username.length > 0) {
        //NSString *preStr = self.messageTV.text;
        [self.composeView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"appendContext('%@ ')",username]];
        //self.messageTV.text = [NSString stringWithFormat:@"%@%@", preStr, username];
        //[self textViewDidChange:self.messageTV];
    }

}
-(void) myReleaseSource
{
    [self unregisterNotification];
    RELEASE_SAFELY(countLabel);
    RELEASE_SAFELY(actionView);
    RELEASE_SAFELY(issueinfo);
    [self.composeView stringByEvaluatingJavaScriptFromString:@"clearData()"];  
    self.composeView = nil;
    self.image = nil;
    self.videoPath = nil;
    self.tableV.delegate = nil;
    self.tableV.dataSource = nil;
    self.tableV = nil;
    self.geoLabel = nil;
    self.reverseGeocoder.delegate = nil;
    self.reverseGeocoder = nil;
    self.cameraInfo = nil;
    self.photoPath = nil;
}

-(void)dealloc
{
    [self myReleaseSource];
    [super dealloc];
}

@end
