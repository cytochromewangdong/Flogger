//
//  RegisterViewControl.h
//  Flogger
//
//  Created by wyf on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetworkViewController.h"
#import "ImageConst.h"
#import "FloggerTableView.h"

//@interface MyTableViewDelegate : TTTableViewDelegate 

//@end
@interface RegisterViewControl : BaseNetworkViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextField *_email;
    UITextField *_username;
    UITextField *_password;
    UITextField *_firstName;
    UITextField *_lastName;
    UITextField *_phone;
    UIButton *_profileBtn;
}

@property(nonatomic,retain) UITextField * email;
@property(nonatomic,retain) UITextField * username;
@property(nonatomic,retain) UITextField * password;
@property(nonatomic,retain) UITextField * firstName;
@property(nonatomic,retain) UITextField * lastName;
@property(nonatomic,retain) UITextField * phone;
@property (nonatomic, retain) NSArray *dataSourceArray;
@property (nonatomic, retain) UIButton *maleBtn, *femaleBtn, *profileBtn;
@property (nonatomic,retain) TTButton *chooseBtn;
@property (nonatomic, retain) UIImage *profileImage;

@end
