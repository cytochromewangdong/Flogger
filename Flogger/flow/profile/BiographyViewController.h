//
//  BiographyViewController.h
//  Flogger
//
//  Created by steveli on 17/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagView.h"
#import "BaseNetworkViewController.h"
#import "FloggerWebAdapter.h"
#import "IssueInfoComServerProxy.h"

@class MyAccount;
@interface BiographyViewController : BaseNetworkViewController{

    FloggerWebView *_webview;
}


@property(nonatomic,retain)MyAccount     * account;
@property(nonatomic,retain)FloggerWebView *webview;
@property(nonatomic,assign)BOOL        ismyself;
@property(nonatomic,retain)IssueInfoComServerProxy * profileServerProxy;

- (void) handleAction:(NSNotification *)notification;
-(void)uploadWebSite:(NSDictionary*)data;
@end
