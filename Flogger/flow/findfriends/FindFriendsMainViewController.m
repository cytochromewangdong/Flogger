//
//  FindFriendsMainViewController.m
//  Flogger
//
//  Created by jwchen on 12-3-8.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FindFriendsMainViewController.h"
#import "SuggestionUserViewController.h"
#import "FindFriendSelectionViewController.h"

@interface FindFriendsMainViewController()
@property(nonatomic, retain) NSMutableArray *recipients;
@end

@implementation FindFriendsMainViewController
@synthesize recipients;

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


#pragma mark - View lifecycle

-(void)setupTableData
{
    NSMutableArray *dataArray = [NSMutableArray arrayWithObjects: NSLocalizedString(@"Find friends", @"Find friends"), NSLocalizedString(@"Invite friends",@"Invite friends"), NSLocalizedString(@"Suggested users",@"Suggested users"), nil];
//    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dataArray, @" ", nil];
    self.tableView.dataArr = dataArray;
}
-(void) loadView
{
    UIImage *backgroundImage = [[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND];
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
    view.backgroundColor = [[[UIColor alloc] initWithPatternImage:backgroundImage] autorelease];
    self.view = view;
    
    
}

- (void)viewDidLoad
{
    self.tableView = [[[ClTableView alloc] initWithFrame:self.view.bounds withStyle:UITableViewStyleGrouped] autorelease];
    self.tableView.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableView.allowsSelection = YES;
    [self.view addSubview:self.tableView];
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    // Do any additional setup after loading the view from its nib.
    [self setupTableData];
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
    self.recipients = nil;
    [super dealloc];
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
    [picker setSubject:@"Check out my photos and videos on iFlogger!"];
    
    // Fill out the email body text
    NSString *emailBody = @"<html>iFlogger is fun way to blog, capture, and share beautiful photos and videos to the rest of the world!<br>You can  <A href='http://www.iflogger.com/getapp'/>download</A> the free iPhone app or learn more.</html>";
    [picker setToRecipients:res];
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)inviteBySms:(NSArray *)res
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    //TODO
    picker.body = @"Check out my photos and videos with iFlogger on your iPhone! http://www.iflogger.com/getapp/";
    [picker setRecipients:res];
    picker.messageComposeDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
    
}

#pragma mark Show all contacts


// Called when users tap "Display Picker" in the application. Displays a list of contacts and allows users to select a contact from that list.
// The application only shows the phone, email, and birthdate information of the selected contact.
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






#pragma mark ABPeoplePickerNavigationControllerDelegate methods
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
        [self dismissViewControllerAnimated:YES completion:^(void)
         {
             [self inviteBySms:self.recipients];
         }];
        
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
    }
    
//    [self dismissModalViewControllerAnimated:YES];
	return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[peoplePicker dismissModalViewControllerAnimated:YES];
}


-(UITableViewCell *)tableView:(ClTableView *)cltableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [cltableView.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.textLabel.textColor = [UIColor]
    }
//    
//    NSArray *valueArr = [[self.tableView.dataDictionary allValues] objectAtIndex:0];
    cell.textLabel.text = [self.tableView.dataArr objectAtIndex:[indexPath row]];
    return cell;
}

-(void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *vc = nil;
    switch ([indexPath row]) {
        case 0:
            vc = [[[FindFriendSelectionViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            break;
        case 1:
            [self showPeoplePickerController];
            break;
            
        case 2:
            vc = [[[SuggestionUserViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            break;
        default:
            break;
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
