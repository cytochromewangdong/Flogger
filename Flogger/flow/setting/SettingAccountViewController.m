//
//  SettingAccountViewController.m
//  Flogger
//
//  Created by jwchen on 12-3-13.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SettingAccountViewController.h"
#import "AccountServerProxy.h"
#import "GlobalData.h"
#import "FloggerTableView.h"
#import <Three20UICommon/Three20UICommon+Additions.h>
#define katWieth 12
@interface SettingAccountViewController()
@property(nonatomic, retain) UITextField *firstNameCell, *lastNameCell,*oldPwCell, *nPwCell, *confirmCell;
@property (nonatomic, retain) NSArray *dataSourceArray; 
@property (nonatomic, retain) UIButton *maleBtn, *femaleBtn;
-(void) genderAction : (id) sender;
@end

@implementation SettingAccountViewController
@synthesize firstNameCell, lastNameCell, oldPwCell, nPwCell, confirmCell;
@synthesize maleBtn,femaleBtn;
@synthesize dataSourceArray;

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
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:NSLocalizedString(@"Account", @"Account")];
}

-(void) loadView
{
   // UIImage *backgroundImage = [[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND];
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
//    view.backgroundColor =  [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];//[[[UIColor alloc] initWithPatternImage:backgroundImage] autorelease];
    self.view = view;
    
    FloggerTableView *fTableView = [[[FloggerTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped] autorelease];
    fTableView.backgroundColor = [UIColor clearColor];
    if ([GlobalUtils checkIOS_6]) {
        fTableView.backgroundView = nil;
    }
    fTableView.delegate = self;
    fTableView.dataSource = self;
//    fTableView.scrollEnabled = NO;
    fTableView.rowHeight = 45;    
    [self.view addSubview:fTableView];
    
    UITextField *firstName = [[FloggerUIFactory uiFactory] createTextField];
    firstName.delegate = self;
    //firstName.placeholder = NSLocalizedString(@"First Name", @"First Name");
    firstName.placeholder = NSLocalizedString(@"Name", @"Name");
    
   
    UITextField *lastName = [[FloggerUIFactory uiFactory] createTextField];
    lastName.delegate = self;
    lastName.placeholder = NSLocalizedString(@"Username", @"Username");
    UITextField *oldPassword=nil;
    if ([GlobalData sharedInstance].myAccount.account.usersource.intValue<1) {
       oldPassword = [[FloggerUIFactory uiFactory] createTextField];
        oldPassword.delegate = self;
        oldPassword.secureTextEntry = YES;
        oldPassword.placeholder = NSLocalizedString(@"Old Password", @"Old Password");
    }
    
    UITextField *newPassword = [[FloggerUIFactory uiFactory] createTextField];
    newPassword.delegate = self;
    newPassword.secureTextEntry = YES;
    newPassword.placeholder = NSLocalizedString(@"New Password", @"New Password");
    
    UITextField *confirmPassword = [[FloggerUIFactory uiFactory] createTextField];
    confirmPassword.delegate = self;
    confirmPassword.secureTextEntry = YES;
    confirmPassword.placeholder = NSLocalizedString(@"Confirm Password", @"Confirm Password");
    
    
    if ([GlobalData sharedInstance].myAccount.account.usersource.intValue<1) {
        self.dataSourceArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:firstName,lastName,nil],
                                [NSArray arrayWithObjects:oldPassword,newPassword,confirmPassword,nil],nil];
        
        [self setFirstNameCell:firstName];
        [self setLastNameCell:lastName];
        [self setOldPwCell:oldPassword];
        [self setNPwCell:newPassword];
        [self setConfirmCell:confirmPassword]; 
    }else{
        self.dataSourceArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:firstName,lastName,nil],
                                [NSArray arrayWithObjects:newPassword,confirmPassword,nil],nil];
        
        [self setFirstNameCell:firstName];
        [self setLastNameCell:lastName];
//        [self setOldPwCell:oldPassword];
        [self setNPwCell:newPassword];
        [self setConfirmCell:confirmPassword]; 
    }
    
    
    [self setRightNavigationBarWithTitle: NSLocalizedString(@"Done",@"Done") image:nil];
    

}
-(void) genderAction : (id) sender
{
        UIButton *btn = (UIButton *) sender;
        switch (btn.tag) {
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    AccountCom *myAccountCom = [GlobalData sharedInstance].myAccount;
    self.firstNameCell.text = myAccountCom.account.fname;
    self.lastNameCell.text = [NSString stringWithFormat:@"%@",myAccountCom.account.username];//myAccountCom.account.username;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self myReleaseSourse];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
};


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 0 ? 1 : 50;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *genderView = nil;
    if (section == 1) {
        genderView = [[FloggerUIFactory uiFactory] createView];
        genderView.backgroundColor = [UIColor clearColor];        
        //male female
        UIImage *maleImage = [UIImage imageNamed:SNS_MALE_PLACEHOLDER];
        UIImage *femaleImage = [UIImage imageNamed:SNS_FEMALE_PLACEHOLDER];
        UIImage *radioImage = [UIImage imageNamed:SNS_RADIO];
        UIImage *radioPressImage = [UIImage imageNamed:SNS_RADIO_PRESSED];
        
        UIImageView *maleImageView = [[FloggerUIFactory uiFactory] createImageView:maleImage];
        maleImageView.frame = CGRectMake(30, 15, maleImage.size.width, maleImage.size.height);
        
        UIButton *maleRadioBtn = [[FloggerUIFactory uiFactory] createButton:radioImage];
        maleRadioBtn.frame = CGRectMake(80, 20, radioImage.size.width, radioImage.size.height);
        [maleRadioBtn addTarget:self action:@selector(genderAction:) forControlEvents:UIControlEventTouchUpInside];
        maleRadioBtn.tag = 1;
        [maleRadioBtn setImage:radioPressImage forState:UIControlStateSelected];
        
        UIImageView *femaleImageView = [[FloggerUIFactory uiFactory] createImageView:femaleImage];
        femaleImageView.frame = CGRectMake(208, 15, femaleImage.size.width, femaleImage.size.height);
        
        UIButton *femaleRadioBtn = [[FloggerUIFactory uiFactory] createButton:radioImage];
        femaleRadioBtn.frame = CGRectMake(258, 20, radioImage.size.width, radioImage.size.height);
        [femaleRadioBtn addTarget:self action:@selector(genderAction:) forControlEvents:UIControlEventTouchUpInside];
        femaleRadioBtn.tag = 2;
        [femaleRadioBtn setImage:radioPressImage forState:UIControlStateSelected];
        
        [genderView addSubview:maleRadioBtn];
        [genderView addSubview:femaleRadioBtn];
        [genderView addSubview:maleImageView];
        [genderView addSubview:femaleImageView];
        
        [self.view addSubview:genderView];
        
        
        [self setMaleBtn:maleRadioBtn];
        [self setFemaleBtn:femaleRadioBtn];
        AccountCom *myAccountCom = [GlobalData sharedInstance].myAccount;
        if ([myAccountCom.account.gender isEqualToNumber:[NSNumber numberWithInt:1]]) {
            self.maleBtn.selected = false;
            self.femaleBtn.selected = true;
        } else {
            self.maleBtn.selected = true;
            self.femaleBtn.selected = false;
        }
    }
    return genderView;
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
    if (indexPath.section==0&&indexPath.row==1) {
        UILabel *usernameAtLable=[[FloggerUIFactory uiFactory] createLable];
        usernameAtLable.frame=CGRectMake(kLeftMargin, kTopMargin, katWieth, kTextFieldHeight);
        usernameAtLable.textColor = [UIColor blackColor];
        usernameAtLable.font = [UIFont boldSystemFontOfSize:14];
        usernameAtLable.text=@"@";
         UITextField *textField = [[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        textField.frame=CGRectMake(kLeftMargin+katWieth, kTopMargin, kTextFieldWidth-katWieth, kTextFieldHeight);
        [cell.contentView addSubview:textField];
        [cell.contentView addSubview:usernameAtLable];
    }else{
        UITextField *textField = [[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell.contentView addSubview:textField];
    }
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) myReleaseSourse
{
    self.firstNameCell.delegate = nil;
    self.firstNameCell = nil;
    self.lastNameCell.delegate = nil;
    self.lastNameCell = nil;
    self.oldPwCell.delegate = nil;
    self.oldPwCell = nil;
    self.nPwCell.delegate = nil;
    self.nPwCell = nil;
    self.confirmCell.delegate = nil;
    self.confirmCell = nil;
    self.dataSourceArray = nil;
    self.maleBtn = nil;
    self.femaleBtn = nil;
}

-(void)dealloc
{
    [self myReleaseSourse];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) isEmpty:(NSString*) text
{
    return ![text length];
}

-(BOOL) checkUsernameValid
{
    if ([self isEmpty:self.lastNameCell.text]) {
            [GlobalUtils showAlert:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"UserName is required",@"UserName is required")];
            return NO;
    }
    return YES;
    
}

-(BOOL) checkPasswordValid
{
    if (![self isEmpty:self.nPwCell.text] || ![self isEmpty:self.confirmCell.text]) {
        if(![self.nPwCell.text isEqualToString:self.confirmCell.text]){
            [GlobalUtils showAlert:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"The two passwords that you entered do not match",@"The two passwords that you entered do not match")];
            return NO;
        }
    }
    return YES;
    
}

-(void)doRequest
{
    [[self.view.window findFirstResponder] resignFirstResponder];

    
    AccountCom *com = [[[AccountCom alloc] init] autorelease];
    com.firstname = firstNameCell.text;
    com.username = lastNameCell.text;
    com.oldPassword = oldPwCell.text;
    com.password = nPwCell.text;
    if (self.femaleBtn.selected) {
        com.gender = [NSNumber numberWithInt:1];
    } else {
        com.gender = [NSNumber numberWithInt:2];
    }
    
    //check
    if (![self checkUsernameValid]) {
        return;
    }
    if(![self checkPasswordValid])
    {
        return;
    }
    
    if (self.loading) {
        return;
    }
    
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[AccountServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    [((AccountServerProxy *)self.serverProxy) resetPassword:com];
    
}

-(void)rightAction:(id)sender
{
    [self doRequest];
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];

    AccountCom *myAccountCom = [GlobalData sharedInstance].myAccount;
    AccountCom *com = (AccountCom *)serverproxy.response;
    myAccountCom.account.fname = com.firstname;
    myAccountCom.account.username = com.username;
    myAccountCom.account.gender = com.gender;
    myAccountCom.account.usersource=com.usersource;
    myAccountCom.firstname = com.firstname;
    myAccountCom.username = com.username;
    [[GlobalData sharedInstance]saveLoginAccount];
    
//    self.firstNameCell.text = com.firstname;
//    self.lastNameCell.text = com.lastname;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
