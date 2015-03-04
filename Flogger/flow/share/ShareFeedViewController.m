//
//  ShareViewController.m
//  Flogger
//
//  Created by jwchen on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ShareFeedViewController.h"
#import "ShareConfigurationView.h"
#import "GlobalData.h"
#import "ExternalBindViewController.h"
#import "ShareServerProxy.h"
#import "UploadServerProxy.h"
#import "AsyncTaskManager.h"
#import "DataCache.h"
#import "UIViewController+iconImage.h"
#import "FloggerAppDelegate.h"
#import "ContactsViewController.h"
#import "FloggerAppDelegate.h"

#define C_WIDTH 260
#define C_HEIGHT 390

@interface ShareFeedViewController()
@property(nonatomic, retain) NSMutableArray *recipients;
@end
@implementation ShareFeedViewController
@synthesize descriptionStr, issueList;
@synthesize tableV;
@synthesize shareType;
@synthesize uploadDic;
@synthesize preUploadProxy;
@synthesize recipients;
@synthesize shareComeFrom;
@synthesize tokenServerProxy;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if ([GlobalUtils checkExpiredToken]) {
            [self doTokenRequest];
        }         
    }
    return self;
}
-(void) doTokenRequest
{
    if(!self.tokenServerProxy)
    {
        self.tokenServerProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.tokenServerProxy.delegate = self;
    }
    AccountCom *com = [[[AccountCom alloc] init] autorelease];
    
    [self.tokenServerProxy getExternalAccountList:com];
    
       
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
#define kVGap 10

-(void)setupView
{
    CGFloat y = 0;
    
    if (descriptionStr) {
        CGSize size = [descriptionStr sizeWithFont:[UIFont systemFontOfSize:15.f] constrainedToSize:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)lineBreakMode:UILineBreakModeWordWrap];
        UILabel *descriptionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, size.height + (kVGap * 2))] autorelease];
        descriptionLabel.text = descriptionStr;
        descriptionLabel.textAlignment = UITextAlignmentCenter;
//        descriptionLabel.font = [UIFont systemFontOfSize:15.f];
        descriptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
        descriptionLabel.textColor=[UIColor grayColor];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:descriptionLabel];
        y += size.height + (kVGap * 2);
    }
    
    

    UITableView *tableView;
    
    if (self.bcTabBarController) {
        tableView =  [[[UITableView alloc] initWithFrame:CGRectMake(0, y, 320, 416-49-y) style:UITableViewStyleGrouped]autorelease];
    } else {
        tableView =  [[[UITableView alloc] initWithFrame:CGRectMake(0, y, 320, 416-y) style:UITableViewStyleGrouped]autorelease];
    }

    
    tableView.backgroundColor = [UIColor clearColor];
    if ([GlobalUtils checkIOS_6]) {
        tableView.backgroundView = nil;
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 45;
    [self.view addSubview:tableView];
    
    self.tableV = tableView;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];

}

-(void) cancelAction
{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"count is %d",[GlobalData sharedInstance].exPlatform.externalplatforms.count);
    if(self.shareComeFrom && self.shareComeFrom == FROM_CAMERA_SHARE){
        return [GlobalData sharedInstance].exPlatform.externalplatforms.count;
    }else{
        return ([GlobalData sharedInstance].exPlatform.externalplatforms.count+2);
    }
}



-(UITableViewCell*) createSharedRow:(NSIndexPath *)indexPath offset:(int)offset
{
    SingleShareCell *cell = nil;
    static NSString *kSourceCellID = @"SourceCellID";
    //cell = [self.tableV dequeueReusableCellWithIdentifier:kSourceCellID];
    MyExternalPlatform *externalPlatform = [[GlobalData sharedInstance].exPlatform.externalplatforms objectAtIndex:indexPath.row + offset];
    MyExternalaccount *myAccount = [GlobalUtils getExternalAccount:externalPlatform.id];
//    if (cell == nil)
    {
        cell = [[SingleShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID platform:externalPlatform account:myAccount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
    }
    if (myAccount) {
        if ([myAccount.expired boolValue]) {
            [cell.configButton setTitle: NSLocalizedString(@"Reconfigure   ",@"Reconfigure   ") forState:UIControlStateNormal];
            cell.unBindButton.hidden = YES;
            cell.configButton.hidden = NO;
            cell.switchButton.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.unBindButton.hidden = YES;
            cell.configButton.hidden = YES;
            cell.switchButton.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell.unBindButton.hidden = YES;
        cell.configButton.hidden = NO;
        cell.switchButton.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleShareCell *cell = nil;
    static NSString *kSourceCellID = @"SourceCellIDShare";
    if(self.shareComeFrom && self.shareComeFrom == FROM_CAMERA_SHARE)
    {
        return [self createSharedRow:indexPath offset:0];
    }else{
        if (indexPath.row == 0 || indexPath.row == 1) {
            if (!cell) {
                cell = [[[SingleShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row == 0) {
                cell.stringLabel.text = NSLocalizedString(@"SMS", @"SMS");
                cell.unBindButton.hidden = YES;
                cell.configButton.hidden = YES;
                cell.switchButton.hidden = YES;
                [cell.iconImage setImage:[[FloggerUIFactory uiFactory]createImage:SNS_SMS]  ];
            } else {
                cell.stringLabel.text = NSLocalizedString(@"Email", @"Email");
                cell.unBindButton.hidden = YES;
                cell.configButton.hidden = YES;
                cell.switchButton.hidden = YES;
                [cell.iconImage setImage:[[FloggerUIFactory uiFactory]createImage:SNS_EMAIL]  ];
            }
            
        }        
        else
        {
            return [self createSharedRow:indexPath offset:-2];
            
        }
    }
    return cell;
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
    [super viewWillAppear:animated];
    [self.tableV reloadData];
    //title view
    [self setNavigationTitleView:NSLocalizedString(@"Sharing", @"Sharing")];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[controller dismissModalViewControllerAnimated:YES];
}


// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the 
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result {
	
	[controller dismissModalViewControllerAnimated:YES];
}

-(void)shareByEmail:(id)sender
{

    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    //            picker.mailComposeDelegate = self;
    picker.mailComposeDelegate = self;
    
    //TODO
    [picker setSubject:@"%@ subject"];
    
    // Fill out the email body text
    NSString *emailBody = NSLocalizedString(@"message", @"message");
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)shareBySms:(id)sender
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    //TODO
    picker.body = NSLocalizedString(@"message", @"message");
    picker.messageComposeDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];

}
-(void)loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Do any additional setup after loading the view from its nib.
    [self setupView];
//    [self setRightNavigationBarWithTitle:[GlobalUtils getLocalizedString:@"Done"] image:nil];
    [self setRightNavigationBarWithTitle: NSLocalizedString(@"Done", @"Done") image:nil];
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

-(void)dealloc
{
//    self.descriptionStr = nil;
    [self myReleaseSource];
    [super dealloc];
}

-(void) myReleaseSource
{
    self.descriptionStr = nil;
    self.issueList = nil;
    self.tableV.delegate =nil;
    self.tableV.dataSource = nil;
    self.tableV = nil;
    self.uploadDic = nil;
    
    self.preUploadProxy.delegate = nil;
    self.preUploadProxy = nil;
    
     self.recipients = nil;
    self.tokenServerProxy=nil;    
    self.delegate=nil;
}

-(void)shareConfigurationView:(ShareConfigurationView *)shareView platform:(Externalplatform *)platform
{
    ExternalBindViewController *vc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    vc.platform = platform;
    vc.isBind = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSMutableArray *)getShareSourceList
{
    NSMutableArray *souceList = [[[NSMutableArray alloc] init] autorelease];
    for (MyExternalaccount *eaccount in [GlobalData sharedInstance].myAccount.externalaccounts) {
        if ([eaccount.sharestatus boolValue] && ![eaccount.expired boolValue]) {
            [souceList addObject:eaccount.usersource];
        }
    }
    
    return souceList;
}

-(void)doRequest
{
    if ([self getShareSourceList].count==0) {
        //to do
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[ShareServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    ShareCom *com = [[[ShareCom alloc] init] autorelease];
    NSMutableArray *issueIdList = [[[NSMutableArray alloc] initWithCapacity:com.issueIdList.count] autorelease];
    for (Issueinfo *info in self.issueList) {
        [issueIdList addObject:info.id];
    }
    com.issueIdList = issueIdList;
    com.sourceList = [self getShareSourceList];
//    NSLog(@"com.issueList : %d", com.issueIdList.count);
    [((ShareServerProxy *)self.serverProxy) share:com];
}

-(void)rightAction:(id)sender
{
    self.isNeedProgress = YES;
    UIButton *barButton = (UIButton *) sender;
    barButton.userInteractionEnabled = NO;
    if (self.shareType == SHAREISSUE) {
        [self doRequest];
    } else {
        [self doRequestMedia];
        
    }
    
}

-(void) doRequestMedia
{
    if (self.loading) {
        return;
    }
    self.isNeedProgress = NO;
    self.loading = YES;
//    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    //if (!self.preUploadProxy) {
    UploadServerProxy* currentPreUploadProxy = [[[UploadServerProxy alloc] init] autorelease];
        //self.preUploadProxy.delegate = [AsyncTaskManager sharedInstance];//self;
    //}
    
    NSMutableDictionary *paraDic = self.uploadDic;
    IssueInfoCom *com = [paraDic valueForKey:kPostIssueInfoCom];
    com.usersourceList = [self getShareSourceList];
    NSString* newPath  = [paraDic valueForKey:kUploadFilePATHKey];
    [[AsyncTaskManager sharedInstance] addTask:currentPreUploadProxy];
//    NSLog(@"==== share time is %f",CFAbsoluteTimeGetCurrent() -startTime);
//    startTime = CFAbsoluteTimeGetCurrent();

    [currentPreUploadProxy preUploadIssue:com withData:newPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissModalViewControllerAnimated:YES];
        //            [FloggerUIFactory uiFactory]
        [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showFeedScreen];
    });
    /*dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [currentPreUploadProxy preUploadIssue:com withData:newPath];
    });
    [self performSelectorOnMainThread:@selector(closeShareFeed) withObject:nil waitUntilDone:1.5];*/
}

-(void) closeShareFeed
{
    [self dismissModalViewControllerAnimated:YES];
    //            [FloggerUIFactory uiFactory]
    [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showFeedScreen];
}


-(void) doRequestMediaUpload : (IssueInfoCom *) resCom withPath: (NSString *) newDataPath
{
    if (self.loading) {
        return;
    }
    
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[UploadServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    NSMutableDictionary *paraDic = self.uploadDic;
    IssueInfoCom *com = [paraDic valueForKey:kPostIssueInfoCom];
    
    com.issueId = resCom.issueId;
    com.usersourceList = [self getShareSourceList];
    com.guid = resCom.guid;
    
    [[AsyncTaskManager sharedInstance] addTask:self.serverProxy];
    [(UploadServerProxy *)self.serverProxy uploadFileIssue:com withData:newDataPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissModalViewControllerAnimated:NO];
        //            [FloggerUIFactory uiFactory]
        [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showFeedScreen];
    });
}

-(void) networkError:(BaseServerProxy *)serverproxy
{
    [super networkError:serverproxy];
    UIButton *btn = (UIButton *)  self.navigationItem.rightBarButtonItem.customView;
    btn.userInteractionEnabled = YES;
}

-(void) transactionFailed:(BaseServerProxy *)serverproxy
{
    [super transactionFailed:serverproxy];
    UIButton *btn = (UIButton *)  self.navigationItem.rightBarButtonItem.customView;
    btn.userInteractionEnabled = YES;
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];
    
    if ([serverproxy isKindOfClass:[ShareServerProxy class]]) {
//        [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showAlertMessage:@"share success"];
        [GlobalUtils showPostMessageAlert: NSLocalizedString(@"Share success", @"Share success")];
    }
    
    if (serverproxy == self.preUploadProxy) {
        
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        
        IssueInfoCom *com = (IssueInfoCom *)serverproxy.response;
        self.loading = NO;
        if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_PICTURE || [com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO) { 
//            NSLog(@"[com.issueinfo.issuecategory intValue] is %d",[com.issueinfo.issuecategory intValue]);
            NSString *newPath = nil;            
            if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_PICTURE) {
                newPath = [[DataCache sharedInstance] cachePathForKey:com.threadHead.bmiddleurl andCategory:nil];
                NSError * error = nil;
                [[NSFileManager defaultManager] copyItemAtPath:[self.uploadDic objectForKey:kPostImagePath] toPath:newPath error:&error];
                if(error)
                {
//                    NSLog(@"error is %@",error);
                }                
                NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] init] autorelease];
                [dataDic setObject:kNotificationPostAction forKey:kNotificationAction];
                [dataDic setObject:com.threadHead forKey:kNotificationInfoIssueThread];                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
                //save image to photoalbum
               // UIImage *orginalImage =  [self.uploadDic objectForKey:kPostOriginalImage];
                if (![[self.uploadDic objectForKey:kPostIsImportImage] boolValue]) {
//                     UIImageWriteToSavedPhotosAlbum(orginalImage, nil, nil, nil);
                }
               
                
            } else if ([com.issueinfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO)
            {
                UIImage *mediaImage = [self.uploadDic objectForKey:kPostVideoThumbnail];
                [[DataCache sharedInstance] storeImage:mediaImage forKey:com.threadHead.bmiddleurl];
                newPath = [[[DataCache sharedInstance] cachePathForKey:com.threadHead.videourl andCategory:nil] stringByAppendingPathExtension:@"mov"];
                NSError * error = nil;
                [[NSFileManager defaultManager] copyItemAtURL:[self.uploadDic objectForKey:kPostVideoURL] toURL:[NSURL fileURLWithPath:newPath] error:&error];
                if(error)
                {
//                    NSLog(@"error is %@",error);
                }
                NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] init] autorelease];
                [dataDic setObject:kNotificationPostAction forKey:kNotificationAction];
                [dataDic setObject:com.threadHead forKey:kNotificationInfoIssueThread];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
                //save video to album
//                NSString *videoPath = [[self.uploadDic objectForKey:kPostVideoURL] path];
                if (![[self.uploadDic objectForKey:kPostIsImportImage] boolValue]) {
//                    UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
                }
            }
            
            
            
            [self doRequestMediaUpload:com withPath:newPath];
            
        } else {
            //tweet
//            IssueInfoCom *originalIssueInfo = [self.uploadDic objectForKey:kPostIssueInfoCom];
//            com.threadHead.hypertext = originalIssueInfo.issueinfo.text;
            //NSLog(@"hyeo test === is %@",com.threadHead.hypertext);
            NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] init] autorelease];
            [dataDic setObject:kNotificationPostAction forKey:kNotificationAction];
            [dataDic setObject:com.threadHead forKey:kNotificationInfoIssueThread];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
            
        }
        NSLog(@"========= share time is %f",CFAbsoluteTimeGetCurrent() - startTime);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissModalViewControllerAnimated:NO];
//            [FloggerUIFactory uiFactory]
            [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showFeedScreen];
        });
        
        
    }else if(serverproxy ==self.tokenServerProxy){
//        NSLog(@"peizhi");
        AccountCom *com = (AccountCom *)serverproxy.response;
        for (MyExternalPlatform *externalPlatform  in [GlobalData sharedInstance].exPlatform.externalplatforms)
        {
    
            MyExternalaccount *myNewAccount = [GlobalUtils getExternalAccount:externalPlatform.id List:com.externalaccounts];
            MyExternalaccount *myLocalAccount = [GlobalUtils getExternalAccount:externalPlatform.id];
            if (myNewAccount)
            {
                myNewAccount.sharestatus = myLocalAccount.sharestatus;
            }

        }
        [GlobalData sharedInstance].myAccount.externalaccounts = com.externalaccounts;
//        [[GlobalData sharedInstance] saveLoginAccount];
        //save token time
        [GlobalUtils saveTokenTime];
        
        [self.tableV reloadData];
        [self.tableV setNeedsDisplay];
    }else {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    if(self.shareComeFrom && self.shareComeFrom == FROM_GALLERY_SHARE&&self.delegate){
         [self.delegate reloadAlbum];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.shareComeFrom && self.shareComeFrom == FROM_CAMERA_SHARE){
        MyExternalPlatform *externalPlatform = (MyExternalPlatform *)[[GlobalData sharedInstance].exPlatform.externalplatforms objectAtIndex:indexPath.row];
        MyExternalaccount *myAccount = [GlobalUtils getExternalAccount:externalPlatform.id];
        if (myAccount) {
            if ([myAccount.expired boolValue]) {
                //  再配置
                ExternalBindViewController *ebvc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                ebvc.platform = externalPlatform;
                ebvc.isBind = YES;
                [self.navigationController pushViewController:ebvc animated:YES];
            } else {
                //解除绑定
            }
        } else {//配置
            ExternalBindViewController *ebvc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            ebvc.platform = externalPlatform;
            ebvc.isBind = YES;
            [self.navigationController pushViewController:ebvc animated:YES];
        }
        
    }else{
        if ([indexPath row] == 0) {
//            NSLog(@"share address book");
            if ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"]) {
                return;
            }
            ContactsViewController *contactViewControl = [[[ContactsViewController alloc] init] autorelease];
            contactViewControl.contactMode = PHONECONTACT;  
            contactViewControl.shareIssueList = self.issueList;
            
            UINavigationController *naviControl = [[[UINavigationController alloc] initWithRootViewController:contactViewControl] autorelease];
            if (self.bcTabBarController) {
                [self.bcTabBarController presentModalViewController:naviControl animated:YES];
            } else {
                [self presentModalViewController:naviControl animated:YES];
            }
            
//            [self.navigationController pushViewController:contactViewControl animated:YES];
            return;
        } else if ([indexPath row] == 1)
        {
            ContactsViewController *contactViewControl = [[[ContactsViewController alloc] init] autorelease];
            contactViewControl.contactMode = EMAILCONTACT; 
            contactViewControl.shareIssueList = self.issueList;
//            [self.navigationController pushViewController:contactViewControl animated:YES];
            UINavigationController *naviControl = [[[UINavigationController alloc] initWithRootViewController:contactViewControl] autorelease];
//            [self presentModalViewController:naviControl animated:YES];
            if (self.bcTabBarController) {
                [self.bcTabBarController presentModalViewController:naviControl animated:YES];
            } else {
                [self presentModalViewController:naviControl animated:YES];
            }
            
            return;
        } else{
            MyExternalPlatform *externalPlatform = (MyExternalPlatform *)[[GlobalData sharedInstance].exPlatform.externalplatforms objectAtIndex:indexPath.row-2];
            MyExternalaccount *myAccount = [GlobalUtils getExternalAccount:externalPlatform.id];
            if (myAccount) {
                if ([myAccount.expired boolValue]) {
                    //  再配置
                    ExternalBindViewController *ebvc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                    ebvc.platform = externalPlatform;
                    ebvc.isBind = YES;
                    [self.navigationController pushViewController:ebvc animated:YES];
                } else {
                    //解除绑定
                }
            } else {//配置
                ExternalBindViewController *ebvc = [[[ExternalBindViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                ebvc.platform = externalPlatform;
                ebvc.isBind = YES;
                [self.navigationController pushViewController:ebvc animated:YES];
            }
        }
    }
    
}
-(void)showPeoplePickerController
{
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
                               [NSNumber numberWithInt:kABPersonEmailProperty], nil];
	
	picker.displayedProperties = displayedItems;
	// Show the picker 
    if (self.bcTabBarController) {
        [self.bcTabBarController presentModalViewController:picker animated:YES];
    } else {
        [self presentModalViewController:picker animated:YES];
    }
	
    [picker release];	
}


// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	return YES;
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonPhoneProperty) {
        ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSInteger count = ABMultiValueGetCount(multiPhones);
        self.recipients = [[[NSMutableArray alloc] initWithCapacity:count] autorelease]; 
        
        for(CFIndex i = 0; i < count; i++) {
            if(identifier == ABMultiValueGetIdentifierAtIndex (multiPhones, i)) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (NSString *) phoneNumberRef;
                [self.recipients addObject:phoneNumber];
//                NSLog(@"-----%@", phoneNumber);
                CFRelease(phoneNumberRef);
            }
        }
        CFRelease(multiPhones);
        //        [self dismissViewControllerAnimated:YES completion:^(void)
        //         {
        //             [self inviteBySms:self.recipients];
        //         }];
        //[self dismissModalViewControllerAnimated:YES];
        [peoplePicker dismissModalViewControllerAnimated:NO];
        [self inviteBySms:self.recipients];
        
    }
    
    else if (property == kABPersonEmailProperty) {
        ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonEmailProperty);
        NSInteger count = ABMultiValueGetCount(multiPhones);
        self.recipients = [[[NSMutableArray alloc] initWithCapacity:count] autorelease]; 
        for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
            if(identifier == ABMultiValueGetIdentifierAtIndex (multiPhones, i)) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (NSString *) phoneNumberRef;
                [self.recipients addObject:phoneNumber];
//                NSLog(@"-----%@", phoneNumber);
                CFRelease(phoneNumberRef);
            }
        }
        CFRelease(multiPhones);
        //        [self dismissViewControllerAnimated:YES completion:^(void)
        //         {
        //             [self inviteByEmail:self.recipients];
        //         }];
        //        [self performSelector:@selector(dismissModalViewControllerAnimated:) withObject:YES afterDelay:1];
        
        [peoplePicker dismissModalViewControllerAnimated:NO];
        [self inviteByEmail:self.recipients];
    }
    
	return NO;
}
-(void)inviteByEmail:(NSArray *)res
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    //            picker.mailComposeDelegate = self;
    picker.mailComposeDelegate = self;
    
    //TODO    
    [picker setSubject:[NSString stringWithFormat:NSLocalizedString(@"Share from iFlogger by %@",@""), [GlobalData sharedInstance].myAccount.username]];
    // Fill out the email body text
    NSMutableString *emailBody = [[[NSMutableString alloc]initWithCapacity:1000]autorelease];
    
    for (int i = 0; i < [self.issueList count]; i++) {
        if ([[[self.issueList objectAtIndex:i] issuecategory] intValue] == ISSUE_CATEGORY_VIDEO)
        {
            emailBody=[NSString stringWithFormat:NSLocalizedString(@"share vidoe by mail",@""), [[self.issueList objectAtIndex:i] bmiddleurl],[GlobalData sharedInstance].myAccount.username] ;
            
        } else if([[[self.issueList objectAtIndex:i] issuecategory] intValue] == ISSUE_CATEGORY_PICTURE){
            float photoWidth=[[[self.issueList objectAtIndex:i] photowidth] floatValue];
            float photoHeight=[[[self.issueList objectAtIndex:i] photoheight] floatValue];
            if(photoWidth< 0.00001)
            {
                photoWidth=  C_WIDTH;
            }
            if(photoHeight < 0.00001)
            {
                photoHeight =  C_HEIGHT;
            }
            photoHeight = photoHeight* C_WIDTH / photoWidth;
            photoWidth= C_WIDTH;
            
            [emailBody appendFormat:NSLocalizedString(@"share by mail",@""), [[self.issueList objectAtIndex:i] bmiddleurl],(int)photoWidth ,(int)photoHeight,[[self.issueList objectAtIndex:i] bmiddleurl],[GlobalData sharedInstance].myAccount.username] ;
            [emailBody appendString:@"\n"];
            
        }else{
            [emailBody appendFormat:NSLocalizedString(@"share weibo by mail",@""), [[self.issueList objectAtIndex:i] hypertext],[GlobalData sharedInstance].myAccount.username];
            [emailBody appendString:@"\n"];
        }
    }

    [picker setToRecipients:res];
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)inviteBySms:(NSArray *)res
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    //TODO
       NSString *snsBody;
    if ([[[self.issueList objectAtIndex:0] issuecategory] intValue] == ISSUE_CATEGORY_VIDEO)
    {
        snsBody=[NSString stringWithFormat:NSLocalizedString(@"share video by sns",@""), [GlobalData sharedInstance].myAccount.username,[[self.issueList objectAtIndex:0] bmiddleurl]] ;
        
    } else if([[[self.issueList objectAtIndex:0] issuecategory] intValue] == ISSUE_CATEGORY_PICTURE){
               snsBody=[NSString stringWithFormat:NSLocalizedString(@"share by sns",@""), [GlobalData sharedInstance].myAccount.username,[[self.issueList objectAtIndex:0] bmiddleurl]] ;
        
    }else{
        snsBody=[NSString stringWithFormat:NSLocalizedString(@"share weibo by sns",@""), [[self.issueList objectAtIndex:0] hypertext],[GlobalData sharedInstance].myAccount.username];
    }
    
    
    
    picker.body = snsBody;
    [picker setRecipients:res];
    picker.messageComposeDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
    
}

// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[peoplePicker dismissModalViewControllerAnimated:YES];
}


-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    //[self.preUploadProxy cancelAll];
    [self.tokenServerProxy cancelAll];
}

@end
