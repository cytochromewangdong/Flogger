//
//  SuggestionUserViewController.h
//  Flogger
//
//  Created by jwchen on 12-3-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClPageViewController.h"
#import "IssueInfoComServerProxy.h"
#import "AccountServerProxy.h"
#import "FollowComServerProxy.h"

typedef enum 
{
    USER_POPULAR = 1,
    USER_FEATURED
}UserType;

@interface SuggestionUserViewController : ClPageViewController
@property(nonatomic, assign) UserType userType;

@property(nonatomic, retain) UIButton *popularBtn, *featuredBtn;

@property(nonatomic, retain) IssueInfoComServerProxy *issueSp;
@property(nonatomic, retain) AccountServerProxy *accountSp;
@property(nonatomic, assign) BOOL loading2;
@property(nonatomic, assign) BOOL loadingFeature;
@property(nonatomic, retain) FollowComServerProxy *followSp;
@property(nonatomic, assign) BOOL isFirstScreen;
@property(nonatomic, retain) IssueInfoCom *currentIssueInfoCom;
@property(nonatomic, retain) AccountCom *currentAccountCom;

-(void)btnClicked:(id)sender;

@end
