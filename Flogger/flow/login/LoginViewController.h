//
//  LoginViewController.h
//  flogger
//
//  Created by jwchen on 11-12-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
#import "ExternalPlatformServerProxy.h"
#import "NoMenuProtocol.h"
#import "NoLoginProtocol.h"
#import "AccountCom.h"

@interface LoginViewController : BaseNetworkViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, NoMenuProtocol, NoLoginProtocol>

@property(nonatomic, retain) UITextField *userNameField, *passwordField;
@property(nonatomic, retain) UIButton *createBtn;
@property(nonatomic, retain) UIView *shareView;
@property(nonatomic, retain) ExternalPlatformServerProxy *eServerProxy;
@property(nonatomic, retain) NSArray *dataSourceArray;

- (void)clickForgetOrCreateBtn:(id)sender;
-(BOOL) checkInputValid:(AccountCom *)accountCom;
-(void)updateShareView:(NSArray *)platformArray;
@end
