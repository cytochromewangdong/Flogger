//
//  ProfileViewController.h
//  Flogger
//
//  Created by steveli on 09/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
#import "FollowComServerProxy.h"
#import "AccountServerProxy.h"
#import "FloggerLayoutAdapter.h"
#import "IssueInfoComServerProxy.h"


typedef enum{
    HTTP_GET_ACCOUNT_PROFILE,
    HTTP_GET_ACTIVITY,
    HTTP_GET_MORE_ACTIVITY,
    HTTP_UPDATE_IMAGE,
    HTTP_UPDATE_DESCRIPTION,
    HTTP_FOLLOW_SET
}Profile_Http_Type;

@class AccountCom;
@class MyAccount;
@class FeedTableView;
@class ProfileTableView;

@interface ProfileViewController : BaseNetworkViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    BOOL _isUpdateingStatus;
    BOOL _isUpdateingImage;
    BOOL _isProfileRetrieving;
    BOOL _isFollowing;

    BOOL _isFollow;
    BOOL _isDataChange;
    BOOL _isScrollTop;
    BOOL _isFirst;
    int currentDataRow;
}

@property(nonatomic,retain)MyAccount* account;   //   AccountCom*  accountcom;
@property(nonatomic, assign) BOOL isFollowedChanged;
@property (nonatomic,retain)UIImagePickerController* pickercontroller;
@property(nonatomic,retain)ProfileTableView* feedtableview;
@property(nonatomic,assign)BOOL ismyself;
@property(nonatomic,assign)BOOL isFromProfile;
@property(nonatomic,retain)AccountServerProxy      * accountStatusProxy;
@property(nonatomic,retain)AccountServerProxy      * accountImageProxy;
@property(nonatomic,retain)FollowComServerProxy    * followComServerProxy;
@property(nonatomic,retain)IssueInfoComServerProxy * profileServerProxy;

@property (nonatomic,retain) UIButton *galleryButton, *biograButton;

-(void)btnpressed:(id)sender;
-(void) viewScrollToTop;



@end
