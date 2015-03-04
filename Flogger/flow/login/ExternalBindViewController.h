//
//  ExternalBindViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-25.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "Externalplatform.h"
#import "AccountServerProxy.h"
#import "NoLoginProtocol.h"

typedef enum{
    BINDMODE = 1,
    INVITEMODE    
} LOGINMODE;

@interface ExternalBindViewController : BaseNetworkViewController<UIWebViewDelegate, NoLoginProtocol>
@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) Externalplatform *platform;
@property(nonatomic, retain) AccountServerProxy *aServerProxy;
@property(nonatomic, retain) NSString *tokenSecret;
@property(nonatomic, assign) BOOL isBind;
@property(nonatomic, assign) BOOL doingLogin;
@property(nonatomic, assign) BOOL isInvite;
@property (nonatomic, assign) LOGINMODE loginMode;
@end
