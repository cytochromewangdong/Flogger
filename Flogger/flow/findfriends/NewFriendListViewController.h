//
//  NewListViewController.h
//  Flogger
//
//  Created by jwchen on 12-3-8.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FollowComServerProxy.h"
#import "SuggestUserViewCell.h"




@interface NewFriendListViewController : BaseNetworkViewController <UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>{

}
@property(nonatomic, retain) FollowComServerProxy *followSp;
@property (retain)NSMutableArray *data;
@end

