//
//  AccountServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-1-10.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "AccountEntity.h"
#import "AccountCom.h"

@interface AccountServerProxy : BaseServerProxy
{
    @private
//    Account *_account;
}

-(void)login:(AccountCom *)account;
-(void)resiger:(AccountCom *)account  withPhoto:(UIImage *)image;
-(void)getUserList:(AccountCom *)account;
-(void)updateBiography:(AccountCom*)account;
-(void)updateStatus:(AccountCom*)account withStatus:(NSString*)status;
-(void)updateImage:(AccountCom*)account withPhoto:(UIImage*)image;

-(void) externalLogin:(AccountCom *)com;

-(void) getRequestUrl:(AccountCom *)com;
-(void) getExternalFriends:(AccountCom *)com;
-(void) bind:(AccountCom *)com;
-(void) unBind:(AccountCom *)com;
-(void) resetPassword:(AccountCom *)com;
-(void)getExternalAccountList:(AccountCom *)account;

-(void)getDevicePushInfo;
-(void)updatePushStatus:(AccountCom *)account;
-(void)logout;
-(void) getSyncupInfo;
@end
