//
//  SettingViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


static NSString* VERSION = @"1.0.0";

@interface SettingViewController : BaseNetworkViewController <UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>{
    //NSArray *_controllers;
    //NSMutableData * _data;
}

@end
