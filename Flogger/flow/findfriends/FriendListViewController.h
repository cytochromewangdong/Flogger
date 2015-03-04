//
//  FriendListViewController.h
//  Flogger
//
//  Created by jwchen on 12-3-8.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClPageViewController.h"
#import "Externalplatform.h"
#import "FollowComServerProxy.h"
#import "FindFriendServerProxy.h"
#import "IssueInfoCom.h"
#import "IssueInfoComServerProxy.h"

typedef enum{
    FriendListView_ExternalPlatform,
    FriendListView_Follows,
    FriendListView_Following,
    FriendListView_Addressbook,
    FriendListView_FirstScreen,
    FriendListVIew_Likes
}FriendListViewType;


@interface FriendListViewController : ClPageViewController <UIAlertViewDelegate>
@property(nonatomic, retain) Externalplatform *platform;
@property(nonatomic, retain) FollowComServerProxy *followSp;
@property(nonatomic, assign) FriendListViewType type;
@property(nonatomic, retain) FindFriendServerProxy *friendSp;
@property(nonatomic, retain) IssueInfoComServerProxy *issueInfoComSp;

@property (nonatomic, retain) MyAccount *account;
@property (nonatomic, retain) IssueInfoCom *issueInfoCom;

//firstScreen
@property (nonatomic, retain) NSMutableArray *accountList;
          
@end
