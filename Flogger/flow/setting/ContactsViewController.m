//
//  ContactsViewController.m
//  Flogger
//
//  Created by wyf on 12-6-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ContactsViewController.h"
#import "UDTableView.h"
#import "NameIndex.h"
#import <AddressBook/AddressBook.h>
#import "GlobalData.h"
#import "pinyin.h"

#define C_WIDTH 260
#define C_HEIGHT 390

//static NSString *kSendPartialTitle = @"Send (%d) Invite";

@interface ContactsViewController ()
@property (nonatomic, retain) NSMutableArray *sectionsArray;
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;
@property (nonatomic, retain) NSString *nameString;
- (void)configureSections;
@end

@implementation ContactsViewController
@synthesize tableV,filteredListContent,listContent;
@synthesize sectionsArray,collation;
@synthesize nameString,contactMode,shareIssueList,searchDisplayControl;
@synthesize selectItem,sendItem,deSelectItem,cancelItem;
@synthesize bottomToolBar;

-(void) dealloc
{
    self.selectItem = nil;
    self.deSelectItem = nil;
    self.cancelItem = nil;
    self.sendItem = nil;
    self.bottomToolBar = nil;
    self.searchDisplayControl.delegate = nil;
    self.searchDisplayControl.searchResultsDataSource = nil;
    self.searchDisplayControl.searchResultsDelegate = nil;
    self.searchDisplayControl = nil;
    self.shareIssueList = nil;
    self.tableV.dataSource = nil;
    self.tableV.delegate = nil;
    self.tableV = nil;
    self.filteredListContent = nil;
    self.listContent = nil;
    self.sectionsArray = nil;
    self.collation = nil;
    self.nameString = nil;
    [super dealloc];
}

-(BOOL) checkIsFullScreen
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) cancelAction : (id) sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) go2Setting
{
    NSURL*url=[NSURL URLWithString:@"prefs:root=ACCOUNT_SETTINGS&path=ADD_ACCOUNT"];
//    prefs:root=NOTES
    [[UIApplication sharedApplication] openURL:url];
}

-(void) sendAction : (id) sender
{
    NSMutableArray *recipeArray = [[[NSMutableArray alloc] init] autorelease];  
    
    for (int i = 0; i < self.listContent.count; i++) {
        NameIndex *contactInfo = [self.listContent objectAtIndex:i];
        if (contactInfo.isSelect) {
            if (self.contactMode == PHONECONTACT) {
                [recipeArray addObject:contactInfo.phone];
            } else {
                [recipeArray addObject:contactInfo.email];
            }
        }
    }
    if (recipeArray.count > 0 ) {
        if (self.contactMode == PHONECONTACT) {
//            [self inviteBySms:recipeArray];
            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));            
            if (messageClass != nil) { 			
                // Check whether the current device is configured for sending SMS messages
                if ([messageClass canSendText]) {
                    [self inviteBySms:recipeArray];
                }
                else {	
//                    [self go2Setting];
                }
            }
            else {
//                [self go2Setting];
            }

        } else {
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));            
            if (mailClass != nil) {
                if ([mailClass canSendMail]) {
                    [self inviteByEmail:recipeArray];
                }
                else {
                    [self go2Setting];
                }
            }
            else	{
                [self go2Setting];
            }
            
        }
    }

    /*NSArray *selectedRows = [self.tableV indexPathsForSelectedRows];
    if (selectedRows.count > 0)
    {
        for (NSIndexPath *selectionIndex in selectedRows)
        {
            NameIndex *contactInfo = (NameIndex *) [[_allFriends objectAtIndex:selectionIndex.section] objectAtIndex:selectionIndex.row];
            if (self.contactMode == PHONECONTACT) {
                [recipeArray addObject:contactInfo.phone];
            } else {
                [recipeArray addObject:contactInfo.email];
            }
        }
        if (self.contactMode == PHONECONTACT) {
            [self inviteBySms:recipeArray];
        } else {
            [self inviteByEmail:recipeArray];
        }
    }*/
}

-(void) selectAction : (id) sender
{
    for (int i = 0; i < self.listContent.count; i++) {
        NameIndex *contactInfo = [self.listContent objectAtIndex:i];
        contactInfo.isSelect = YES;
    }
    self.navigationItem.rightBarButtonItem = self.deSelectItem;
    [self.tableV reloadData];
    [self changeSendTitle];
}
-(void) deSelectAction : (id) sender
{
    for (int i = 0; i < self.listContent.count; i++) {
        NameIndex *contactInfo = [self.listContent objectAtIndex:i];
        contactInfo.isSelect = NO;
    }
    self.navigationItem.rightBarButtonItem = self.selectItem;
    [self.tableV reloadData];
    [self changeSendTitle];
}

-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
//    UINavigationBar *navigationBar = [[[UINavigationBar alloc] init] autorelease];
//    navigationBar.frame = CGRectMake(0, 0, 320, 44);
////    navigationBar.
//    navigationBar.tintColor = [UIColor yellowColor];
//    [self.view addSubview:navigationBar];
    
    UISearchBar *searchBar = [[[UISearchBar alloc] init] autorelease];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, 0, 320, 44);

    UDTableView *tableView = [[[UDTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416-44) style:UITableViewStylePlain]autorelease];
    tableView.backgroundColor = [UIColor clearColor];
    if ([GlobalUtils checkIOS_6]) {
        tableView.backgroundView = nil;
    }    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 45;
    tableView.tableHeaderView = searchBar;

    [tableView setAllowsMultipleSelection: YES];
    [tableView setAllowsMultipleSelectionDuringEditing: YES];
    
    UISearchDisplayController *searchControl = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchControl.delegate = self;
	searchControl.searchResultsDataSource = self;
	searchControl.searchResultsDelegate = self;
//    searchControl.searchResultsTableView.editing = YES;
    searchControl.searchResultsTableView.allowsMultipleSelection = YES;
    searchControl.searchResultsTableView.allowsMultipleSelectionDuringEditing = YES;
//    searchControl.searchBar.ca
    
    [self.view addSubview:tableView];    
    self.tableV = tableView;
    self.searchDisplayControl = searchControl;
    
    
    UIToolbar *toolBar = [[FloggerUIFactory uiFactory] createToolBar];//[UIToolbar alloc]
    toolBar.frame = CGRectMake(0, 416-44, 320, 44);
    UIBarButtonItem *spaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction:)] autorelease];
    cancelButton.width = 120;
    UIBarButtonItem *sendButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send", @"Send") style:UIBarButtonItemStyleDone target:self action:@selector(sendAction:)] autorelease];
    sendButton.width = 120;
    toolBar.items = [NSArray arrayWithObjects:spaceItem,cancelButton,sendButton,spaceItem, nil];
    
    
    [self.view addSubview:toolBar];
    
    
    UIBarButtonItem *selectButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Select All", @"Select All") style:UIBarButtonItemStyleBordered target:self action:@selector(selectAction:)] autorelease];
    
    UIBarButtonItem *deSelectButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Deselect All", @"Deselect All") style:UIBarButtonItemStyleBordered target:self action:@selector(deSelectAction:)] autorelease];
    self.selectItem = selectButton;
    self.deSelectItem = deSelectButton;
    self.sendItem = sendButton;
    self.cancelItem = cancelButton;
    self.bottomToolBar = toolBar;
    
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self getAllFriend:self.listContent];
    for (int i = 0; i < [self.tableV numberOfSections]; i++) {
        for (int j = 0; j < [self.tableV numberOfRowsInSection:i]; j++) {
            NSUInteger ints[2] = {i,j};
            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
            NameIndex *contactInfo = [[_allFriends objectAtIndex:i] objectAtIndex:j];            
            if (contactInfo.isSelect) {
                //Here is your code
                [self.tableV selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
    
    [self.tableV reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
//    NSArray *selectedRows = [self.searchDisplayControl.searchResultsTableView indexPathsForSelectedRows];
//    if (selectedRows.count > 0)
//    {
//        for (NSIndexPath *selectionIndex in selectedRows)
//        {
//            NameIndex *contactInfo = (NameIndex *) [[_allFriends objectAtIndex:selectionIndex.section] objectAtIndex:selectionIndex.row];
//            
//            for (int i = 0; i < self.listContent.count; i ++) {
//                NameIndex *orignalInfo = [self.listContent objectAtIndex:i];
//                orignalInfo.isSelect = YES;
//            }
////            contactInfo.isSelect = YES;
//        }
//    }
    
    [self getAllFriend:self.listContent];
    
    for (int i = 0; i < [self.tableV numberOfSections]; i++) {
        for (int j = 0; j < [self.tableV numberOfRowsInSection:i]; j++) {
            NSUInteger ints[2] = {i,j};
            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
            NameIndex *contactInfo = [[_allFriends objectAtIndex:i] objectAtIndex:j];            
            if (contactInfo.isSelect) {
                //Here is your code
                [self.tableV selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
    
    [self.tableV reloadData];
    [self.searchDisplayController setActive:NO animated:YES];
}
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//   
//}

//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
//{
//    return YES;
//}

-(void) testDisplay : (NSString *) searchText
{
    [self.filteredListContent removeAllObjects];
//    NSString *searchText = searchBar.text;
    if (!searchText || searchText.length == 0) {
        [self getAllFriend:self.listContent];
        [self.tableV reloadData];
        return;
    }
    for (NameIndex *contactInfo in self.listContent) {
        NSString *name; //= [contactInfo getName];
        NSComparisonResult result;
        if ([searchText canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英语  
            name = [contactInfo getName];
//            result = [name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        }  
        else { //如果是非英语  
             name = [contactInfo getHanzeName];
//            NSString *nameTemp = @"";
//            for (int i =0; i < searchText.length; i++) {
//                nameTemp = [NSString stringWithFormat:@"%@%c",nameTemp,pinyinFirstLetter([searchText characterAtIndex:i])];
//            }
//            searchText = nameTemp; 
        }
        result = [name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        
//        NSComparisonResult result = [name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:contactInfo];
        }
    }
    if (self.filteredListContent) {
        [self getAllFriend:self.filteredListContent];
    } else {
        [_allFriends removeAllObjects];
    }
    
    [self.tableV reloadData];
    
//    for (int i = 0; i < [self.searchDisplayControl.searchResultsTableView numberOfSections]; i++) {
//        for (int j = 0; j < [self.searchDisplayControl.searchResultsTableView numberOfRowsInSection:i]; j++) {
//            NSUInteger ints[2] = {i,j};
//            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
//            NameIndex *contactInfo = [[_allFriends objectAtIndex:i] objectAtIndex:j];            
//            if (contactInfo.isSelect) {
//                //Here is your code
//                [self.searchDisplayControl.searchResultsTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            }
//        }
//    }
//    [self.searchDisplayControl.searchResultsTableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    /*[self.filteredListContent removeAllObjects];
    NSString *searchText = searchBar.text;
    if (!searchText || searchText.length == 0) {
        [self getAllFriend:self.listContent];
        [self.tableV reloadData];
        return;
    }
    for (NameIndex *contactInfo in self.listContent) {
        NSString *name = [contactInfo getName];
        
        NSComparisonResult result = [name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:contactInfo];
        }
    }
    if (self.filteredListContent) {
        [self getAllFriend:self.filteredListContent];
    } else {
        [_allFriends removeAllObjects];
    }
    
    [self.tableV reloadData];*/
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.contactMode == PHONECONTACT) {
        [self setNavigationTitleView:NSLocalizedString(@"SMS", @"SMS")];
    } else {
        [self setNavigationTitleView:NSLocalizedString(@"Email", @"Email")];
    }
    if (self.contactMode == EMAILCONTACT) {
//        [self setRightNavigationBarWithTitle:NSLocalizedString(@"Deselect All", @"Deselect All") image:nil];
//        self.selectItem = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem = self.deSelectItem;
    }
    
    
}

-(void)inviteBySms:(NSArray *)res
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    //TODO
    if (self.shareIssueList) {
        NSString *snsBody;
        if ([[[self.shareIssueList objectAtIndex:0] issuecategory] intValue] == ISSUE_CATEGORY_VIDEO)
        {
            snsBody=[NSString stringWithFormat:NSLocalizedString(@"share video by sns",@""), [GlobalData sharedInstance].myAccount.username,[[self.shareIssueList objectAtIndex:0] shareMediaUrl]] ;
            
        } else if([[[self.shareIssueList objectAtIndex:0] issuecategory] intValue] == ISSUE_CATEGORY_PICTURE){
            snsBody=[NSString stringWithFormat:NSLocalizedString(@"share by sns",@""), [GlobalData sharedInstance].myAccount.username,[[self.shareIssueList objectAtIndex:0] bmiddleurl]] ;
            
        }else{
            snsBody=[NSString stringWithFormat:NSLocalizedString(@"share weibo by sns",@""), [[self.shareIssueList objectAtIndex:0] hypertext],[GlobalData sharedInstance].myAccount.username];
        }
        picker.body = snsBody;
    } else {
//        picker.body = NSLocalizedString(@"imessage",@"imessage");
        picker.body = [GlobalData sharedInstance].myAccount.smsMessage;
    }
    
    [picker setRecipients:res];
    picker.messageComposeDelegate = self;
    
    //dis
//    [self dismissModalViewControllerAnimated:NO];    
//    UINavigationController *navigationControl = self.navigationController;
//    [navigationControl popViewControllerAnimated:NO];
    
    [self presentModalViewController:picker animated:YES];
    
    [picker release];
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result {
	
    controller.messageComposeDelegate = nil;
    dispatch_async(dispatch_get_main_queue(),^{
        [controller dismissModalViewControllerAnimated:NO];
        [self dismissModalViewControllerAnimated:YES];
    });
}

-(void)inviteByEmail:(NSArray *)res
{
    
//    if (mailClass != nil) {
//        //[self displayMailComposerSheet];
//		// We must always check whether the current device is configured for sending emails
//		if ([mailClass canSendMail]) {
//			[self displayMailComposerSheet];
//		}
//		else {
//			feedbackMsg.hidden = NO;
//			feedbackMsg.text = @"Device not configured to send mail.";
//		}
//	}
//	else	{
//		feedbackMsg.hidden = NO;
//		feedbackMsg.text = @"Device not configured to send mail.";
//	}
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    //            picker.mailComposeDelegate = self;
    picker.mailComposeDelegate = self;
    
     NSMutableString *emailBody = [[[NSMutableString alloc]initWithCapacity:1000]autorelease];
    if (self.shareIssueList) {
        //TODO    
        [picker setSubject:[NSString stringWithFormat:NSLocalizedString(@"Share from iFlogger by %@",@""), [GlobalData sharedInstance].myAccount.username]];
        // Fill out the email body text
       
        
        for (int i = 0; i < [self.shareIssueList count]; i++) {
            if ([[[self.shareIssueList objectAtIndex:i] issuecategory] intValue] == ISSUE_CATEGORY_VIDEO)
            {
//                emailBody=[NSString stringWithFormat:NSLocalizedString(@"share vidoe by mail",@""), [[self.shareIssueList objectAtIndex:i] shareMediaUrl] ? [[self.shareIssueList objectAtIndex:i] shareMediaUrl]:[[self.shareIssueList objectAtIndex:i] bmiddleurl],[GlobalData sharedInstance].myAccount.username] ;
                
                [emailBody appendFormat:NSLocalizedString(@"share vidoe by mail",@""), [[self.shareIssueList objectAtIndex:i] shareMediaUrl] ? [[self.shareIssueList objectAtIndex:i] shareMediaUrl]:[[self.shareIssueList objectAtIndex:i] bmiddleurl],[GlobalData sharedInstance].myAccount.username] ;
                [emailBody appendString:@"\n"];
                
            } else if([[[self.shareIssueList objectAtIndex:i] issuecategory] intValue] == ISSUE_CATEGORY_PICTURE){
                float photoWidth=[[[self.shareIssueList objectAtIndex:i] photowidth] floatValue];
                float photoHeight=[[[self.shareIssueList objectAtIndex:i] photoheight] floatValue];
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
                
                [emailBody appendFormat:NSLocalizedString(@"share by mail",@""), [[self.shareIssueList objectAtIndex:i] shareMediaUrl],(int)photoWidth ,(int)photoHeight,[[self.shareIssueList objectAtIndex:i] bmiddleurl],[GlobalData sharedInstance].myAccount.username] ;
                [emailBody appendString:@"\n"];
                
            }else{
                [emailBody appendFormat:NSLocalizedString(@"share weibo by mail",@""), [[self.shareIssueList objectAtIndex:i] hypertext],[GlobalData sharedInstance].myAccount.username];
                [emailBody appendString:@"\n"];
            }
        }
    } else {
        //TODO
        //    [picker setSubject:@"Check out my photos and videos on iFlogger!"];
        [picker setSubject:NSLocalizedString(@"Check out my photos and videos on iFlogger!",@"")];
        // Fill out the email body text
        //    NSString *emailBody = @"<html>iFlogger is fun way to blog, capture, and share beautiful photos and videos to the rest of the world!<br>You can  <A href='http://www.iflogger.com/getapp'/>download</A> the free iPhone app or learn more.</html>";
//       emailBody = NSLocalizedString(@"emailmesssage",@"emailmesssage");
//        emailBody = [NSMutableString stringWithString:NSLocalizedString(@"emailmesssage", @"emailmesssage")];
        if ([GlobalData sharedInstance].myAccount.emailMessage) {
            emailBody = [NSMutableString stringWithString:[GlobalData sharedInstance].myAccount.emailMessage];
        } else{
            emailBody = [NSMutableString stringWithString:[GlobalData sharedInstance].myAccount.inviteFriendContent];
        }
        //[GlobalData sharedInstance].myAccount.inviteFriendContent;
        //NSLocalizedString(@"emailmesssage", @"emailmesssage")
    }
    

    [picker setToRecipients:res];
    [picker setMessageBody:emailBody isHTML:YES];
    //dis
//    [self dismissModalViewControllerAnimated:NO];
//    UINavigationController *navigationControl = self.navigationController;
//    [navigationControl popViewControllerAnimated:NO];
//    
//    [navigationControl presentModalViewController:picker animated:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{    
    controller.mailComposeDelegate = nil;
    dispatch_async(dispatch_get_main_queue(),^{
        [controller dismissModalViewControllerAnimated:NO];
        [self dismissModalViewControllerAnimated:YES];
    });
}

-(void) rightAction:(id)sender
{
    if (self.contactMode == PHONECONTACT) {
        return;
    }
//    
//    if ([self.selectItem.title isEqualToString:NSLocalizedString(@"Deselect All", @"Deselect All")]) {
//        for (int i = 0; i < self.listContent.count; i++) {
//            NameIndex *contactInfo = [self.listContent objectAtIndex:i];
//            contactInfo.isSelect = NO;
//        }
//        self.selectItem.title = NSLocalizedString(@"Select All", @"Select All");
//    } else {
//        for (int i = 0; i < self.listContent.count; i++) {
//            NameIndex *contactInfo = [self.listContent objectAtIndex:i];
//            contactInfo.isSelect = NO;
//        }
//        self.selectItem.title = NSLocalizedString(@"Deselect All", @"Deselect All");
//    }    
//    [self.tableV reloadData];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//    NSMutableArray *array = [GlobalUtils retriveEmailArrayFromAddress];
//    self.sectionsArray = array;
//    [self configureSections];
//}

//-(void) getData
//{
//    
//}
-(void) getOriginalFriend
{
    ABAddressBookRef addressBook = ABAddressBookCreate();  
    CFArrayRef friendList = ABAddressBookCopyArrayOfAllPeople(addressBook);
    int friendsCount = CFArrayGetCount(friendList);  
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0]; 
    NSInteger ik = 0;
    for (int i = 0; i<friendsCount; i++) {          
        //        NameIndex *item = [[NameIndex alloc] init];//NameIndex是一个用于给UILocalizedIndexedCollation类对象做索引的类，代码见下个代码块  
        ABRecordRef record = CFArrayGetValueAtIndex(friendList, i);  
        CFStringRef firstName = ABRecordCopyValue(record, kABPersonFirstNameProperty);  
        CFStringRef lastName =  ABRecordCopyValue(record, kABPersonLastNameProperty);
        
        //        item._originIndex = ik;  
 
        
        if (self.contactMode == PHONECONTACT) {
            //phone
            ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
            for (int k = 0; k<ABMultiValueGetCount(phone); k++)
            {
                NameIndex *item = [[NameIndex alloc] init];
                item._lastName = (NSString*)lastName;  
                item._firstName = (NSString*)firstName;  
                
                //Label
                CFStringRef firstPhone = ABMultiValueCopyLabelAtIndex(phone, k);
                
                NSString * personPhoneLabel = (NSString*)ABAddressBookCopyLocalizedLabel(firstPhone);
                CFRelease(firstPhone);
                //Label phone
                NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                item.phone = personPhone;
                [personPhone release];
                item.phoneLabel = personPhoneLabel;
                [personPhoneLabel release];
                //            item._originIndex = i * k + i + k;
                item._originIndex = ik;
                ik++;
                [temp addObject:item];
                [item release]; 
                
            }
            CFRelease(phone);
            
        } else {
            //获取email 
            ABMultiValueRef email = ABRecordCopyValue(record, kABPersonEmailProperty);
            int emailcount = ABMultiValueGetCount(email);    
            for (int x = 0; x < emailcount; x++)
            {
                NameIndex *item = [[NameIndex alloc] init];
                item._lastName = (NSString*)lastName;  
                item._firstName = (NSString*)firstName;  
                
                //获取email Label
                //                NSString* emailLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
                //获取email值
                NSString* emailContent = (NSString*)ABMultiValueCopyValueAtIndex(email, x);
                
                item.email = emailContent;
                [emailContent release];
                //                item.ema = personPhoneLabel;
                //            item._originIndex = i * k + i + k;
                item._originIndex = ik;
                ik++;
                [temp addObject:item];
                [item release]; 
            }
            CFRelease(email);
        }
        (lastName==NULL)?:CFRelease(lastName);  
        (firstName==NULL)?:CFRelease(firstName); 
        
    }  
    self.listContent = temp;
    
    CFRelease(friendList);
    CFRelease(addressBook);
    
    
}

-(void) getAllFriend : (NSMutableArray *) temp
{
//    [self getOriginalFriend];
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];//这个是建立索引的核心  
    _allFriends = [[NSMutableArray arrayWithCapacity:1] retain];//_allFriends 是一个NSMutableArray型的成员变量  
//    NSMutableArray *temp = self.listContent;
    for (NameIndex *item in temp) {   
        NSInteger sect = [theCollation sectionForObject:item collationStringSelector:@selector(getLastName)];//getLastName是实现中文安拼音检索的核心，见NameIndex类   
        item._sectionNum = sect; //设定姓的索引编号  
    }   
    NSInteger highSection = [[theCollation sectionTitles] count]; //返回的应该是27，是a－z和＃  
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection]; //tableView 会被分成27个section  
    for (int i=0; i<=highSection; i++) {   
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];   
        [sectionArrays addObject:sectionArray];   
    }   
    for (NameIndex *item in temp) {   
        [(NSMutableArray *)[sectionArrays objectAtIndex:item._sectionNum] addObject:item];   
    }   
    for (NSMutableArray *sectionArray in sectionArrays) {   
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(getLastName)]; //同  
        [_allFriends addObject:sortedSection];   
    }   
    
    
}

- (void)viewDidLoad {  
    [super viewDidLoad];
    
    self.filteredListContent = [[[NSMutableArray alloc] init] autorelease];
    
    [self getOriginalFriend];
    [self getAllFriend: self.listContent];
    
    //[self.tableV selectAllRows];
    //NSMutableArray
    self.tableV.editing = YES;
//    self.searchDisplayControl.searchResultsTableView.editing = YES;
    
    if (self.contactMode != PHONECONTACT) {
        for (int i = 0; i < [self.tableV numberOfSections]; i++) {
            for (int j = 0; j < [self.tableV numberOfRowsInSection:i]; j++) {
                NSUInteger ints[2] = {i,j};
                NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
                //Here is your code
                [self.tableV selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        
        for (int i = 0; i < self.listContent.count; i++) {
            NameIndex *contactInfo = [self.listContent objectAtIndex:i];
            contactInfo.isSelect = YES;
        }
        [self changeSendTitle];
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(NSString *) setNameFromDic : (NSMutableDictionary *) dic
{
    NSString *string = @"No Name";
    NSString *firstName = [dic valueForKey:kContactInfoFirstName];
    NSString *lastName = [dic valueForKey:kContactInfoLastName];
    
    if(lastName) {
        string = lastName;
    } else if (firstName) {
        string = firstName;
    }  
    return string;
}

//- (NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector
//{
////    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
//    NSInteger sectionCount = [[collation sectionTitles] count];
//    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
//    for(int i = 0; i < sectionCount; i++)
//    {
//        [unsortedSections addObject:[NSMutableArray array]];
//    }
//    for (id object in array)
//    {
//        NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
//        [[unsortedSections objectAtIndex:index] addObject:object];
//    }
//    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
//    for (NSMutableArray *section in unsortedSections)
//    {
//        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
//    }
//    return sections;
//}

- (void)configureSections {
	
	// Get the current collation and keep a reference to it.
	self.collation = [UILocalizedIndexedCollation currentCollation];
	
	NSInteger index, sectionTitlesCount = [[collation sectionTitles] count];
	
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
	
	// Set up the sections array: elements are mutable arrays that will contain the time zones for that section.
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
		[array release];
	}
	
	// Segregate the time zones into the appropriate arrays.
//	for (TimeZoneWrapper *timeZone in timeZonesArray) {
//		
//		// Ask the collation which section number the time zone belongs in, based on its locale name.
//		NSInteger sectionNumber = [collation sectionForObject:timeZone collationStringSelector:@selector(localeName)];
//		
//		// Get the array for the section.
//		NSMutableArray *sectionTimeZones = [newSectionsArray objectAtIndex:sectionNumber];
//		
//		//  Add the time zone to the section.
//		[sectionTimeZones addObject:timeZone];
//	}
    
//    NSMutableDictionary *dict =
    
    for (NSMutableDictionary *dict in self.sectionsArray) {
        self.nameString = [self setNameFromDic:dict];
        // Ask the collation which section number the time zone belongs in, based on its locale name.
		NSInteger sectionNumber = [collation sectionForObject:dict collationStringSelector:@selector(nameString)];
		
		// Get the array for the section.
		NSMutableArray *sectionTimeZones = [newSectionsArray objectAtIndex:sectionNumber];
		
		//  Add the time zone to the section.
		[sectionTimeZones addObject:dict];
    }
	
//	// Now that all the data's in place, each section array needs to be sorted.
//	for (index = 0; index < sectionTitlesCount; index++) {
//		
//		NSMutableArray *timeZonesArrayForSection = [newSectionsArray objectAtIndex:index];
//		
//		// If the table view or its contents were editable, you would make a mutable copy here.
//		NSArray *sortedTimeZonesArrayForSection = [collation sortedArrayFromArray:timeZonesArrayForSection collationStringSelector:@selector(nameString)];
//		
//		// Replace the existing array with the sorted array.
//		[newSectionsArray replaceObjectAtIndex:index withObject:sortedTimeZonesArrayForSection];
//	}
	
	self.sectionsArray = newSectionsArray;
	[newSectionsArray release];	
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	// The number of sections is the same as the number of titles in the collation.
//    return self.sectionsArray.count;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	
//	// The number of time zones in the section is the count of the array associated with the section in the sections array.
//    //	NSArray *timeZonesInSection = [sectionsArray objectAtIndex:section];
//    //	
//    //    return [timeZonesInSection count];
//    return 1;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//	// Get the time zone from the array associated with the section index in the sections array.
//	NSArray *timeZonesInSection = [sectionsArray objectAtIndex:indexPath.section];
//    NSMutableDictionary *dict = [timeZonesInSection objectAtIndex:indexPath.row];
//    cell.textLabel.text = [dict objectForKey:kContactInfoFirstName];
//    cell.detailTextLabel.text = [dict objectForKey:kContactInfoLastName];
//	
//    return cell;
//}
//
///*
// Section-related methods: Retrieve the section titles and section index titles from the collation.
// */
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [[collation sectionTitles] objectAtIndex:section];
//}
//
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [collation sectionIndexTitles];
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [collation sectionForSectionIndexTitleAtIndex:index];
//}

-(void) changeSendTitle
{
    //send item
    UIBarButtonItem *spaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    //    NSArray *selectedRows = [self.tableV indexPathsForSelectedRows];
    NSMutableArray *selectedRows = [[[NSMutableArray alloc] init ] autorelease];
    for (int i = 0; i < self.listContent.count; i++) {
        NameIndex *contactInfo = [self.listContent objectAtIndex:i];
        if (contactInfo.isSelect) {
            [selectedRows addObject:contactInfo];
        }
    }
//    self.sendItem.title = (selectedRows.count == 0) ?
//    NSLocalizedString(@"Send", @"Send") : [NSString stringWithFormat:NSLocalizedString(@"Send Invite", @"Send Invite"), selectedRows.count];
//    
    NSString *titleString;
    switch (selectedRows.count) {
        case 0:
            titleString = NSLocalizedString(@"Send", @"Send");
            break;
        case 1:
            titleString = [NSString stringWithFormat:NSLocalizedString(@"Send Invite", @"Send Invite"), selectedRows.count];
            break;
        default:
            titleString = [NSString stringWithFormat:NSLocalizedString(@"Send Invites", @"Send Invites"), selectedRows.count];
            break;
    }
    self.sendItem.title = titleString;
    self.bottomToolBar.items = [NSArray arrayWithObjects:spaceItem,self.cancelItem,self.sendItem, spaceItem,nil];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameIndex *contactInfo = (NameIndex *) [[_allFriends objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    for (int i = 0; i < self.listContent.count; i ++) {
        NameIndex *originalContact = [self.listContent objectAtIndex:i];
        if (originalContact._originIndex == contactInfo._originIndex) {
            originalContact.isSelect = NO;
            break;
        }
    }
    [self changeSendTitle];
    if (self.contactMode == EMAILCONTACT) {
        self.navigationItem.rightBarButtonItem = self.selectItem;       
    }    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameIndex *contactInfo = (NameIndex *) [[_allFriends objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    for (int i = 0; i < self.listContent.count; i ++) {
        NameIndex *originalContact = [self.listContent objectAtIndex:i];
        if (originalContact._originIndex == contactInfo._originIndex) {
            originalContact.isSelect = YES;
            break;
        }
    }
    [self changeSendTitle];
    
    //check select item
    if (self.contactMode == EMAILCONTACT)
    {
        for (int j = 0; j < self.listContent.count; j++) {
            NameIndex *contactInfo = [self.listContent objectAtIndex:j];
            if (!contactInfo.isSelect) {
                return;
            }
        }
        self.navigationItem.rightBarButtonItem = self.deSelectItem;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {   
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];   
}   

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {   
    if ([[_allFriends objectAtIndex:section] count] > 0) {   
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];   
    }   
    return nil;   
}   

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index   
{   
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];   
}   

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {  
    return [_allFriends count];  
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {   
    return [(NSArray*)[_allFriends objectAtIndex:section] count];   
}   

// Customize the appearance of table view cells.  
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
    
    static NSString *CellIdentifier = @"Cell";  
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
    if (cell == nil) {  
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];  
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }  
    
    // Set up the cell...  
    
    NameIndex *contact = [[_allFriends objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSString *firstName = contact._firstName ;
    if (!firstName) {
        firstName = @"";
    }
    NSString *lastName = contact._lastName;
    if (!lastName) {
        lastName = @"";
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",lastName,firstName];
    if (self.contactMode == PHONECONTACT) {
        cell.detailTextLabel.text = [contact.phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    } else {
        cell.detailTextLabel.text = contact.email;//[contact.email stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
//    if (self.searchDisplayController.searchResultsTableView == tableView) {
        if (contact.isSelect) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
//    }
    
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    cell.selected = YES;
//    if (contact.isSelect) {
//        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    }
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    return cell;  
}  
//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
//{
//    
//}

-(void) searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    controller.searchResultsTableView.allowsMultipleSelectionDuringEditing = YES;
    controller.searchResultsTableView.allowsSelectionDuringEditing = YES;
    controller.searchResultsTableView.editing = YES;
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        for (int i = 0; i < [self.searchDisplayControl.searchResultsTableView numberOfSections]; i++) {
//            for (int j = 0; j < [self.searchDisplayControl.searchResultsTableView numberOfRowsInSection:i]; j++) {
//                NSUInteger ints[2] = {i,j};
//                NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
//                NameIndex *contactInfo = [[_allFriends objectAtIndex:i] objectAtIndex:j];            
//                if (contactInfo.isSelect) {
//                    //Here is your code
//                    [self.searchDisplayControl.searchResultsTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//                }
//            }
//        }
//        [self.searchDisplayControl.searchResultsTableView reloadData];
//    });


}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self testDisplay:searchString];
    // Return YES to cause the search result table view to be reloaded.
    
//    for (int i = 0; i < [self.searchDisplayControl.searchResultsTableView numberOfSections]; i++) {
//        for (int j = 0; j < [self.searchDisplayControl.searchResultsTableView numberOfRowsInSection:i]; j++) {
//            NSUInteger ints[2] = {i,j};
//            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
//            NameIndex *contactInfo = [[_allFriends objectAtIndex:i] objectAtIndex:j];            
//            if (contactInfo.isSelect) {
//                //Here is your code
//                [self.searchDisplayControl.searchResultsTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            }
//        }
//    }
//    [self.searchDisplayControl.searchResultsTableView reloadData];
    
    
    return YES;
}

//-(void) searchdisplay


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
//    for (int i = 0; i < [self.searchDisplayControl.searchResultsTableView numberOfSections]; i++) {
//        for (int j = 0; j < [self.searchDisplayControl.searchResultsTableView numberOfRowsInSection:i]; j++) {
//            NSUInteger ints[2] = {i,j};
//            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
//            NameIndex *contactInfo = [[_allFriends objectAtIndex:i] objectAtIndex:j];            
//            if (contactInfo.isSelect) {
//                //Here is your code
//                [self.searchDisplayControl.searchResultsTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            }
//        }
//    }
//    [self.searchDisplayControl.searchResultsTableView reloadData];

    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
