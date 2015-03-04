//
//  RegisterViewControl.m
//  Flogger
//
//  Created by wyf on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "RegisterViewControl.h"
#import "FloggerUIFactory.h"
#import "AccountServerProxy.h"
#import "AccountCom.h"
#import "GlobalData.h"
#import "FloggerAppDelegate.h"
#import <Three20UICommon/Three20UICommon+Additions.h>
#import "FriendListViewController.h"

@interface RegisterViewControl()
- (void) chooseAction;
-(void) registerAction;

@end

@implementation RegisterViewControl 

@synthesize email = _email;
@synthesize username = _username;
@synthesize password = _password;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize phone = _phone;
@synthesize dataSourceArray;
@synthesize maleBtn,femaleBtn,chooseBtn;
@synthesize profileBtn = _profileBtn;
@synthesize profileImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:NSLocalizedString(@"Register", @"Register")];
    [self setRightNavigationBarWithTitle:NSLocalizedString(@"Done",@"Done") image:nil];
}

-(void) clickBtn : (id) sender
{
    UIButton *btn = (UIButton *) sender;
    switch (btn.tag) {
        case 0:
            [self chooseAction];
            break;
        case 1:
            self.maleBtn.selected = true;
            self.femaleBtn.selected = false;
            break;
        case 2:
            self.maleBtn.selected = false;
            self.femaleBtn.selected = true;
            break;            
        default:
            break;
    }
}


-(void)showAlert:(NSString*)title message:(NSString*)message
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self 
                                         cancelButtonTitle:NSLocalizedString(@"OK",@"OK") 
                                         otherButtonTitles:nil];
    [alert show];
    [alert release];
}
-(BOOL) isEmpty:(NSString*) text
{
    return ![text length];
}
-(BOOL) checkInputValid:(AccountCom *)accountCom
{
    if([self isEmpty: accountCom.email])
    {        
        [GlobalUtils showAlert:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Email is required",@"Email is required")];
        return NO;
    }
    if([self isEmpty: accountCom.username]){
        [GlobalUtils showAlert:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"UserName is required",@"UserName is required")];
        return NO;
    }
    if([self isEmpty: accountCom.password]){
        [GlobalUtils showAlert:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Password is required",@"Password is required")];
        return NO;
    }
    return YES;
    
}

-(void) registerAction
{
    [[self.view.window findFirstResponder] resignFirstResponder];
    
    AccountCom *accountCom = [[[AccountCom alloc] init] autorelease];
    accountCom.contactList = [GlobalUtils getAllContacts];
    
    accountCom.username = self.username.text;
    accountCom.email    = self.email.text;
    accountCom.password = self.password.text;
    accountCom.firstname = self.firstName.text;
    accountCom.lastname =  self.lastName.text;  
    accountCom.phoneNo = self.phone.text;
    if (self.femaleBtn.selected) {
        //female
        accountCom.gender = [NSNumber numberWithInt:1];
    } else {
        //male
        accountCom.gender = [NSNumber numberWithInt:2];
    }
     
    
    accountCom.uploadType = [NSNumber numberWithInt:1];
    
    if(![self checkInputValid:accountCom])
    {
        return;
    }
    if (!self.serverProxy)
    {
        self.serverProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    AccountServerProxy *accountProxy = (AccountServerProxy *)self.serverProxy;
    // TODO should post video
   [accountProxy resiger:accountCom withPhoto:self.profileImage];
    
}

- (void) chooseAction
{
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Set a profile picture",@"Set a profile picture")
                                                             delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Take picture", @"Take picture"), NSLocalizedString(@"Choose from Library",@"Choose from Library"), nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.destructiveButtonIndex = 3;	// make the second button red (destructive)
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

-(void) setUpField
{
    UITextField *email = [[FloggerUIFactory uiFactory] createTextField];
    email.delegate = self; 
    email.placeholder = NSLocalizedString(@"Email Address",@"Email Address");
    email.keyboardType = UIKeyboardTypeEmailAddress;
    
    UITextField *username = [[FloggerUIFactory uiFactory] createTextField];
    username.delegate = self;
    username.placeholder = NSLocalizedString(@"Username",@"Username");
    
    UITextField *password = [[FloggerUIFactory uiFactory] createTextField];
    password.delegate = self;
    password.secureTextEntry = YES;
    password.placeholder = NSLocalizedString(@"Password",@"Password");
    
    UITextField *firstName =[[FloggerUIFactory uiFactory] createTextField];
    firstName.delegate = self;
    firstName.placeholder = NSLocalizedString(@"Name",@"Name");
    
    UITextField *phone = [[FloggerUIFactory uiFactory] createTextField];
    phone.keyboardType = UIKeyboardTypePhonePad;
    phone.placeholder = NSLocalizedString(@"Phone", @"Phone");
    
//    UITextField *lastName = [[FloggerUIFactory uiFactory] createTextField];
//    lastName.delegate = self;
//    lastName.placeholder = NSLocalizedString(@"Last Name (Optional)",@"Last Name (Optional)");
    
    [self setEmail:email];
    [self setUsername:username];
    [self setPassword:password];
    [self setFirstName:firstName];
    [self setPhone:phone];
//    [self setLastName:lastName];
    
}
-(void) loadView
{    
    UIImage *backgroundImage = [UIImage imageNamed:SNS_BACKGROUND];
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView]; //[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
    view.frame = CGRectMake(0, 0, 320, 460);
    view.backgroundColor = [[[UIColor alloc] initWithPatternImage:backgroundImage] autorelease];
    self.view = view;
    
    FloggerTableView *tableView = [[[FloggerTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped] autorelease];
    tableView.dataSource = self;
    tableView.delegate = self; 
    
    tableView.rowHeight = 45;
    tableView.backgroundColor = [UIColor clearColor];
    if ([GlobalUtils checkIOS_6]) {
        tableView.backgroundView = nil;
    }    
    tableView.editing = NO;
//    tableView.
    
    [self setUpField];
    
    self.dataSourceArray = [NSArray arrayWithObjects:
                            [NSArray arrayWithObjects:self.email,self.username,self.password,nil],
//                            [NSArray arrayWithObjects:self.firstName,self.lastName,nil],
                             [NSArray arrayWithObjects:self.firstName,self.phone,nil],
                            nil];
    [self.view addSubview:tableView];

}
-(void) rightAction:(id)sender
{
    [self registerAction];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0? 20:0 ;
};


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 0? 75:61 ;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.dataSourceArray count];
}

//UITableView dataSource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((NSDictionary*)[self.dataSourceArray objectAtIndex:section]) count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *kCellTextField_ID = @"CellTextField_ID";
    cell = [tableView dequeueReusableCellWithIdentifier:kCellTextField_ID];
    if (cell == nil) {
        cell = [[FloggerUIFactory uiFactory] createTableCell:kCellTextField_ID];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UITextField *textField = [[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.contentView addSubview:textField];
    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *middleView = [[[UIView alloc] init] autorelease];

    if (section == 0) {
        UIImage *pictureImage = [UIImage imageNamed:SNS_PROFILE_PICTURE_BUTTON];
        
        UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        profileBtn.frame = CGRectMake(10, 15, 45, 45);
        [profileBtn setImage:pictureImage forState:UIControlStateNormal];
        profileBtn.userInteractionEnabled = NO;
        profileBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        
        //UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        TTButton * chooseButton = [[FloggerUIFactory uiFactory]createFlatButton:NSLocalizedString(@"Choose Profile Picture",@"Choose Profile Picture")];
        
        chooseButton.frame = CGRectMake(68, 15, 242, 45);
        chooseButton.tag = 0;
        
        [chooseButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//        UILabel *label = [[FloggerUIFactory uiFactory] createLable];
//        label.frame = CGRectMake(10, 10, chooseButton.frame.size.width-20, chooseButton.frame.size.height-20);
//        label.text = NSLocalizedString(@"Choose Profile Picture",@"Choose Profile Picture");
//        label.font = [UIFont boldSystemFontOfSize:12];
//        label.textAlignment = UITextAlignmentCenter;
        
        [middleView addSubview:profileBtn];
        [middleView addSubview:chooseButton];
        
        [self setChooseBtn:chooseButton];
        [self setProfileBtn:profileBtn];
        
    } else if (section == 1) 
    {
        UIImage *maleImage = [UIImage imageNamed:SNS_MALE_PLACEHOLDER];
        UIImage *femaleImage = [UIImage imageNamed:SNS_FEMALE_PLACEHOLDER];
        UIImage *radioImage = [UIImage imageNamed:SNS_RADIO];
        UIImage *radioPressImage = [UIImage imageNamed:SNS_RADIO_PRESSED];
        
        UIImageView *maleImageView = [[FloggerUIFactory uiFactory] createImageView:maleImage];
        maleImageView.frame = CGRectMake(30, 15, maleImage.size.width, maleImage.size.height);
        
        UIButton *maleRadioBtn = [[FloggerUIFactory uiFactory] createButton:radioImage];
        maleRadioBtn.frame = CGRectMake(80, 20, radioImage.size.width, radioImage.size.height);
        [maleRadioBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        maleRadioBtn.tag = 1;
        maleRadioBtn.selected = false;
        [maleRadioBtn setImage:radioPressImage forState:UIControlStateSelected];
        
        UIImageView *femaleImageView = [[FloggerUIFactory uiFactory] createImageView:femaleImage];
        femaleImageView.frame = CGRectMake(208, 15, femaleImage.size.width, femaleImage.size.height);
        
        UIButton *femaleRadioBtn = [[FloggerUIFactory uiFactory] createButton:radioImage];
        femaleRadioBtn.frame = CGRectMake(258, 20, radioImage.size.width, radioImage.size.height);
        [femaleRadioBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
         femaleRadioBtn.tag = 2;
        femaleRadioBtn.selected = true;
        [femaleRadioBtn setImage:radioPressImage forState:UIControlStateSelected];
        
        [middleView addSubview:maleImageView];
        [middleView addSubview:maleRadioBtn];
        [middleView addSubview:femaleImageView];
        [middleView addSubview:femaleRadioBtn];
        
        [self setMaleBtn:maleRadioBtn];
        [self setFemaleBtn:femaleRadioBtn];
 
    }
    return middleView;

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:NO];
    } else if(buttonIndex == 1)
    {
        UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:NO];        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    if ([[info valueForKey:UIImagePickerControllerMediaType]isEqualToString: @"public.image"])
    {
        UIImage *retImage = [info valueForKey:UIImagePickerControllerEditedImage]; 
        self.profileImage = retImage;
        [self.profileBtn setImage:retImage forState:UIControlStateNormal];
    }

}
//-(void) showFirstRegisterScreen : (NSMutableArray *) contactList
//{
//    FriendListViewController *friendListViewControl = [[[FriendListViewController alloc] init] autorelease];
//    friendListViewControl.type = FriendListView_FirstScreen;
//    friendListViewControl.accountList = contactList;
//    [self]
//    
//}
#pragma net finished
-(void)transactionFinished:(BaseServerProxy *)sp
{
    [super transactionFinished:sp];
    AccountCom *accountCom = (AccountCom *)sp.response;
    [GlobalData sharedInstance].myAccount = accountCom;
    [[GlobalData sharedInstance] saveLoginAccount];
//    [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showTabViewControl];
    [((FloggerAppDelegate *)[UIApplication sharedApplication].delegate) showFirstRegisterScreen:accountCom.accountList];
    
    
}

-(void) myReleaseSource
{
    [self setEmail:nil];
    [self setUsername:nil];
    [self setPassword:nil];
    [self setFirstName:nil];
    [self setLastName:nil];
    [self setPhone:nil];
    [self setDataSourceArray:nil];
    [self setMaleBtn:nil];
    [self setFemaleBtn:nil];
    [self setProfileBtn:nil];
    [self setProfileImage:nil];
}

-(void) viewDidUnload
{
    [super viewDidUnload];
    [self myReleaseSource];
    
}

-(void) dealloc
{
    [self myReleaseSource];
    [super dealloc];
}

@end
