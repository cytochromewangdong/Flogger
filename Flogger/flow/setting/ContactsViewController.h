//
//  ContactsViewController.h
//  Flogger
//
//  Created by wyf on 12-6-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UDTableView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

typedef enum
{
    PHONECONTACT = 0,
    EMAILCONTACT
} CONTACTMODE;


@interface ContactsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate, UISearchBarDelegate,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    NSMutableArray *_allFriends;
}
@property (nonatomic, retain) UDTableView *tableV;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayControl;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic) CONTACTMODE contactMode;
@property (nonatomic, retain) NSMutableArray *shareIssueList;
@property (nonatomic, retain) UIBarButtonItem *selectItem,*deSelectItem, *sendItem,*cancelItem;
@property (nonatomic, retain) UIToolbar *bottomToolBar;

@end
