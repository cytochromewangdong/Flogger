//
//  ShareViewController.h
//  Flogger
//
//  Created by jwchen on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SingleShareCell.h"
#import "UploadServerProxy.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AccountServerProxy.h"

typedef enum 
{
    SHAREISSUE,
    SHAREMEDIA
}ShareType;

typedef enum {
    FROM_FEED_SHAER,
    FROM_CAMERA_SHARE,
    FROM_GALLERY_SHARE
}ShareComeFrom;

@interface ShareFeedViewController : BaseNetworkViewController<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,SingleShareCellDelegate,UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate>
@property(nonatomic, copy) NSString *descriptionStr;
@property(nonatomic, retain) NSMutableArray *issueList;
@property (nonatomic, retain) UITableView *tableV;
@property(nonatomic, assign) ShareType shareType;
@property(nonatomic, retain) NSMutableDictionary *uploadDic;
@property(nonatomic, retain) UploadServerProxy *preUploadProxy;
@property(nonatomic, assign) ShareComeFrom shareComeFrom;
@property (nonatomic, retain) AccountServerProxy *tokenServerProxy;
@property(nonatomic,assign)  id                      delegate;

@end
