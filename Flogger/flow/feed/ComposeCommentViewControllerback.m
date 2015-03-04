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

@interface ComposeCommentViewController(){
@private
}
@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) NSDictionary *cameraInfo;
@end

@implementation ComposeCommentViewController
@synthesize image;
@synthesize delegate;
@synthesize issueinfo,groupid;
@synthesize cameraInfo;
@synthesize composeView;

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:kComposeWebAction object:nil];
}

-(void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kComposeWebAction object:nil];
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


//-(void) adjustComposeLayout
//{
//    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
//    view.frame = CGRectMake(0, 0, 320, 460);
//    self.view = view;
//    
//    UITextView *messageTextView = [[FloggerUIFactory uiFactory] createTextView];
//    messageTextView.frame = CGRectMake(0, 0, 320, 145);
//    messageTextView.delegate = self;
//    [self.view addSubview:messageTextView];
//    
//    //action view
//    UIImage *tagImage = [[FloggerUIFactory uiFactory] createImage:SNS_INSERT_TAG];
//    UIImage *atImage = [[FloggerUIFactory uiFactory] createImage:SNS_INSERT_AT];
//    UIImage *locationImage = [[FloggerUIFactory uiFactory] createImage:SNS_GEOTAG_ICON];
//    
//    UIView *actionV = [[FloggerUIFactory uiFactory] createView];
//    actionV.frame = CGRectMake(0, 145, 320, 30);
//    int actionHeight = 0;
//    
//    UIButton *tagBtn = [[FloggerUIFactory uiFactory] createButton:tagImage];
//    tagBtn.frame = CGRectMake(15, actionHeight, tagImage.size.width, tagImage.size.height);
//    [tagBtn addTarget:self action:@selector(topicBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *atBtn = [[FloggerUIFactory uiFactory] createButton:atImage];
//    atBtn.frame = CGRectMake(62, actionHeight, atImage.size.width, atImage.size.height);
//    [atBtn addTarget:self action:@selector(atBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *geoBtn = [[FloggerUIFactory uiFactory] createButton:locationImage];
//    geoBtn.frame = CGRectMake(105, actionHeight, locationImage.size.width, locationImage.size.height);
//    [geoBtn addTarget:self action:@selector(geoBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *locationLab = [[FloggerUIFactory uiFactory] createLable];
//    locationLab.frame = CGRectMake(145, actionHeight, 100, 25);
//    
//    UILabel *countLab = [[FloggerUIFactory uiFactory] createLable];
//    countLab.frame = CGRectMake(276, actionHeight, 45, 25);
//    countLab.text = @"140";
//    
//    [actionV addSubview:tagBtn];
//    [actionV addSubview:atBtn];
//    [actionV addSubview:geoBtn];
//    [actionV addSubview:locationLab];
//    [actionV addSubview:countLab];
//    
//    [self.view addSubview:actionV];
//    
//    [self setMessageTV:messageTextView];
//    [self setActionView:actionV];
//    [self setCountLabel:countLab];
//    [self setGeoLabel:locationLab];
//}
#pragma mark - View lifecycle
-(void) loadView
{
//    [self adjustComposeLayout];
    
        UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
        view.frame = CGRectMake(0, 0, 320, 460);
        self.view = view;
    
}

- (void) handleAction:(NSNotification *)notification
{
    if(notification.object)
    {

    } else {
        [self fillDataToWebView];
    }
}


- (NSMutableDictionary *)collectDisplayData
{
    NSMutableDictionary *data = [[[NSMutableDictionary alloc]init]autorelease];
    return data;
}

-(void) fillDataToWebView
{
    NSMutableDictionary *data;
    data = [self collectDisplayData];
    
    NSString *ret = [self.composeView fillData:[data JSONRepresentation]];
    CGRect frame = self.composeView.frame;
    frame.size.height = [self.composeView getHeight];
    self.composeView.frame = frame;
    NSLog(@"javascript return value:%@", ret);
    //self.webview
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.composeView = [[FloggerWebAdapter getSingleton]getComposeView]; 
    self.composeView.frame = CGRectMake(0, 0, 320, 416);
    [self registerNotification];
    if([self.composeView isLoaded])
    {
        [self fillDataToWebView];
    }
    [self.view addSubview:self.composeView];
    
    
    // Do any additional setup after loading the view from its nib.
    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Post", @"Post") image:nil];
    [self setLeftNavigationBarWithTitle:NSLocalizedString(@"Cancel", @"Cancel") image:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self myReleaseSourse];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#define kMaxLength 140

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
//    tmpIssueinfo.location = self.geoLabel.text;
   
    if (self.issueinfo) {
        com.issueinfo.parentid = self.issueinfo.id;
    }
//    com.issueinfo.text = [messageTV text];
   
    NSInteger category = ISSUE_CATEGORY_TWEET;
    NSData *data = nil;
    if (self.image) {
        data = UIImageJPEGRepresentation(self.image, 1.0);
        category = ISSUE_CATEGORY_PICTURE;
        if ([self.cameraInfo objectForKey:fCameraInfoImageSize]) {
            NSValue *imageSizeValue = [self.cameraInfo objectForKey:fCameraInfoImageSize];
            CGSize imageSize = [imageSizeValue CGSizeValue];
            com.issueinfo.photowidth = [NSNumber numberWithFloat:imageSize.width];
            com.issueinfo.photoheight = [NSNumber numberWithFloat:imageSize.height];

        }
        com.issueinfo.filtersyntax = [self.cameraInfo objectForKey:fCameraInfoSyntax];
        
        
    }
    
    
    
    com.issueinfo.issuecategory = [NSNumber numberWithInt:category];
    
    if(groupid != -1)    
    {
        NSLog(@"upload album groupid = %d",groupid);  
        com.groupID = [NSNumber numberWithInt:groupid] ;
        com.uploadType = [NSNumber numberWithInt:2];
    }
    
    if (!self.delegate) {
        [[AsyncTaskManager sharedInstance] addTask:self.serverProxy];
        self.serverProxy.isAsync = YES;
    }
    
    [(UploadServerProxy *)self.serverProxy uploadIssue:com withData:data];
    
    if (self.serverProxy.isAsync) {
        [self backAction:nil];
    }
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
//    [GlobalUtils showPostMessageAlert:@""];
    [super transactionFinished:serverproxy];
    
    IssueInfoCom *com = (IssueInfoCom *)serverproxy.response;
    if (self.delegate) {
        [self.delegate composeResultDoneWithIssueInfoCom:com];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftAction:(id)sender
{
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    if (!vc) {
        [[GlobalData sharedInstance].menuView show];
    }
}

-(void)rightAction:(id)sender
{
    [self doRequest];
//    if (!self.delegate) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
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

-(void)floggerCameraControl:(FloggerCameraControl *)cameraControl didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.image = [info objectForKey:@"image"];
    self.cameraInfo = info;
    [self dismissModalViewControllerAnimated:YES];
}

-(void)didSelectedTopic:(NSString *)topic
{
//    if (topic && topic.length > 0) {
//        NSString *preStr = self.messageTV.text;
//        self.messageTV.text = [NSString stringWithFormat:@"%@#%@#", preStr, topic];
//        [self textViewDidChange:self.messageTV];
//    }
}

-(void)geoLocationSelected:(NSString *)location
{
//    self.geoLabel.text = location;
}

-(void)didAtSelection:(NSString *)username
{
//    if (username && username.length > 0) {
//        NSString *preStr = self.messageTV.text;
//        self.messageTV.text = [NSString stringWithFormat:@"%@%@", preStr, username];
//        [self textViewDidChange:self.messageTV];
//    }
}

-(void) myReleaseSourse
{
    RELEASE_SAFELY(issueinfo);
    [self unregisterNotification];
    self.composeView.actionDelegate = nil;
    self.composeView = nil; 
}

-(void)dealloc
{
    [self myReleaseSourse];
    [super dealloc];
}

@end
