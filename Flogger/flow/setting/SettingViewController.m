//
//  SettingViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingAboutViewController.h"
#import "SettingAccountViewController.h"
#import "SettingFeedBackViewController.h"
#import "ShareSettingViewController.h"
#import "FloggerAppDelegate.h"
#import "FavortiesViewController.h"
#import "FindFriendSelectionViewController.h"
#import "SuggestionUserViewController.h"
#import "GlobalData.h"
#import "InviteFriendViewController.h"
#import "SettingPushNotification.h"
#import "NewFriendListViewController.h"

@interface SettingViewController()
@property (retain)NSArray *controllers;
@property (retain)NSMutableArray *data;
@property (retain)NSMutableArray *headTitleArray;
@property(nonatomic, retain) NSMutableArray *recipients;
-(void) myReleaseSource;
@end
@implementation SettingViewController
@synthesize controllers;
@synthesize data;
@synthesize headTitleArray;
@synthesize recipients;


-(void)dealloc
{
    [self myReleaseSource];
    [super dealloc];
}

-(void) myReleaseSource
{
    self.controllers = nil;
    self.data = nil;
    self.headTitleArray = nil;
    self.recipients = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:NSLocalizedString(@"Settings", @"Settings")];
    
}
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

#pragma mark - View lifecycle
-(void) loadView
{
//    UIImage *backgroundImage = [[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND];
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
//    view.backgroundColor = [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];//[[[UIColor alloc] initWithPatternImage:backgroundImage] autorelease];
    self.view = view;  
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped] autorelease];
    tableView.backgroundColor = [UIColor clearColor];
    if ([GlobalUtils checkIOS_6]) {
        tableView.backgroundView = nil;
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    
    [self.view addSubview:tableView];
}


- (void)viewDidLoad
{ 
    [super viewDidLoad];
    
    self.data =[[[NSMutableArray alloc]init]autorelease];
    
    NSMutableArray *friendsArray = [[[NSMutableArray alloc] init] autorelease];
    [friendsArray addObject: NSLocalizedString(@"Find friends",@"Find Friends")];
    [friendsArray addObject: NSLocalizedString(@"Invite friends",@"Invite Friends")];
    [friendsArray addObject: NSLocalizedString(@"Suggested users",@"Suggested Users")];
    
    NSMutableArray *accountArray = [[[NSMutableArray alloc] init] autorelease];
//    if ([GlobalData sharedInstance].myAccount.account.usersource.intValue<1) {
         [accountArray addObject: NSLocalizedString(@"Edit Account",@"Edit Account")];
//    }
    [accountArray addObject: NSLocalizedString(@"Edit Sharing Settings",@"Edit Sharing Settings")];
    [accountArray addObject: NSLocalizedString(@"Edit Favorites",@"Edit Favorites")];
    [accountArray addObject: NSLocalizedString(@"Push Notification",@"Push Notification")];
    
    
    NSMutableArray *iFloggerArray = [[[NSMutableArray alloc] init] autorelease];
    [iFloggerArray addObject:NSLocalizedString(@"Feedback",@"Feedback")];
    [iFloggerArray addObject: NSLocalizedString(@"About Flogger",@"About Flogger")];
    [iFloggerArray addObject:NSLocalizedString(@"Version",@"Version")];
    [iFloggerArray addObject:NSLocalizedString(@"Logout",@"Logout")];    
    
    [self.data addObject:friendsArray];
    [self.data addObject:accountArray];
    [self.data addObject:iFloggerArray];
    
    self.headTitleArray = [[[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Friends",@"Friends"),NSLocalizedString(@"Accounts",@"Accounts"),NSLocalizedString(@"Folo",@"Folo"), nil] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self myReleaseSource];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.headTitleArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    NSArray* array = [self.data objectAtIndex:section];
    return array.count;
}


- (void)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

-(NSString *) getBundleVersion
{			
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *appVersion = nil;
    NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (marketingVersionNumber && developmentVersionNumber) {
        if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
            appVersion = marketingVersionNumber;
        } else {
            appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
        }
    } else {
        appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
    }
    return appVersion;
}

/**
 note:没有使用重用
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"joincell";
    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath]; 
//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        NSLog(@"cell == nil");
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];//
    }
    
    NSArray* array = [data objectAtIndex:indexPath.section];
    NSUInteger row = [indexPath row];
    if(indexPath.section == 2)
    {
        if(row == 2){
            NSString* content = (NSString*)[array objectAtIndex:row];
            cell.textLabel.text = content;
//            UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(270, 0, 120, 45)];
//            lable.backgroundColor=[UIColor clearColor];
            UILabel *lable=[[FloggerUIFactory uiFactory] createLable];
            lable.frame=CGRectMake(225, 0, 120, 45);
            lable.text= [self getBundleVersion];//VERSION;
            lable.textColor= [[FloggerUIFactory uiFactory] createTableViewFontColor];
            [lable setNumberOfLines:0];
            [cell addSubview:lable];
//            [lable release];
        }else if(row == 3){
            NSString* content = (NSString*)[array objectAtIndex:row];
            cell.textLabel.text = content;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }else{
            cell.textLabel.text = [array objectAtIndex:row];//controller.title;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }else{
        cell.textLabel.text = [array objectAtIndex:row];//controller.title;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
//   cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)doLogout
{
    FloggerAppDelegate *delegate = (FloggerAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate logout];
}

// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the 
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result {
	
	[controller dismissModalViewControllerAnimated:YES];
}

-(void)inviteByEmail:(NSArray *)res
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    //            picker.mailComposeDelegate = self;
    picker.mailComposeDelegate = self;
    
    //TODO
//    [picker setSubject:@"Check out my photos and videos on iFlogger!"];
    [picker setSubject:NSLocalizedString(@"Check out my photos and videos on iFlogger!",@"")];
    // Fill out the email body text
//    NSString *emailBody = @"<html>iFlogger is fun way to blog, capture, and share beautiful photos and videos to the rest of the world!<br>You can  <A href='http://www.iflogger.com/getapp'/>download</A> the free iPhone app or learn more.</html>";
    NSString *emailBody=NSLocalizedString(@"emailmesssage",@"emailmesssage");
    [picker setToRecipients:res];
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

-(void)inviteBySms:(NSArray *)res
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    //TODO
    picker.body = NSLocalizedString(@"imessage",@"imessage");
    [picker setRecipients:res];
    picker.messageComposeDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
    
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
	[self presentModalViewController:picker animated:YES];
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


// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[peoplePicker dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray* array = [data objectAtIndex:indexPath.section];
//    NSUInteger row = [indexPath row];
    
    UIViewController *vc = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            vc = [[[FindFriendSelectionViewController alloc] init] autorelease];
        }else if(indexPath.row == 1)
        {
//            [self showPeoplePickerController];
            vc = [[[InviteFriendViewController alloc] init] autorelease];
        } else if (indexPath.row == 2)
        {
            vc = [[[SuggestionUserViewController alloc] init] autorelease];
        }
        
    } else 
    if(indexPath.section == 1)
    {    
//        if ([GlobalData sharedInstance].myAccount.account.usersource.intValue<1) {
            if(indexPath.row == 0){
                vc = [[[SettingAccountViewController alloc] init] autorelease];
            }else if(indexPath.row == 1){
                vc = [[[ShareSettingViewController alloc] init] autorelease];
            }else if(indexPath.row == 2)
            {
                vc = [[[FavortiesViewController alloc]init]autorelease];
            }else if(indexPath.row == 3)
            {
            vc = [[[SettingPushNotification alloc]init]autorelease];
            }
//        }else{
//            if(indexPath.row == 0){
//                vc = [[[ShareSettingViewController alloc] init] autorelease];
//            }else if(indexPath.row == 1)
//            {
//            vc = [[[FavortiesViewController alloc]init]autorelease];
//            }else if(indexPath.row == 2)
//                {
//            vc = [[[SettingPushNotification alloc]init]autorelease];
//            }
//        }
    
    }else {
        if ([indexPath row] == 0) {
            vc = [[[SettingFeedBackViewController alloc] init] autorelease];
        }
        else if ([indexPath row] == 1) {
            vc = [[[SettingAboutViewController alloc] init] autorelease];
        }
        else if ([indexPath row] == 3) {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure?",@"Are you sure?") 
                                                           message:nil
                                                          delegate:self 
                                                 cancelButtonTitle:NSLocalizedString(@"Log out",@"Log out")
                                                 otherButtonTitles:NSLocalizedString(@"Cancel",@"Cancel"),nil ];
            [alert show];
            [alert release];
        }
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void) alertView:(UIAlertView *)alertview
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==alertview.cancelButtonIndex) {
        [self doLogout];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 50;
}

@end
