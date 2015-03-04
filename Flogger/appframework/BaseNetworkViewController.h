//
//  BaseNetworkViewController.h
//  Flogger
//
//  Created by jwchen on 12-1-20.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseServerProxy.h"

@interface BaseNetworkViewController : BaseViewController
{
//    UIActivityIndicatorView *_indecatorView;
    BOOL _loading;
    
    BaseServerProxy *_serverProxy;
}
@property(nonatomic, assign) BOOL loading;
@property(nonatomic, assign) BOOL loadingThread;
@property(nonatomic, assign) BOOL isNeedProgress;
@property(nonatomic, retain) BaseServerProxy *serverProxy;
@property(nonatomic, retain) UIActivityIndicatorView *firstActivityIndicatorView;
@property(nonatomic, assign) CGFloat firstActivityOriginalY;

- (void)networkFinished:(BaseServerProxy *)serverproxy;
-(void)transactionFinished:(BaseServerProxy *)serverproxy;
-(void)transactionFailed:(BaseServerProxy *)serverproxy;
-(void)networkError:(BaseServerProxy *)serverproxy;

-(void)reloading;

-(void)cancelNetworkRequests;

-(BOOL) showFirstActivityView;

-(void) showFirstActivity;

@end
