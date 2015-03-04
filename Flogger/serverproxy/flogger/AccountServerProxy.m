//
//  AccountServerProxy.m
//  Flogger
//
//  Created by jwchen on 12-1-10.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "AccountServerProxy.h"
#import "AccountCom.h"
#import "SyncupCom.h"

#define kLoginAction @"AccountCom-LoginAction"
#define kGetUserListAction @"AccountCom-GetUserListAction"
#define kExternalLoginAction @"AccountCom-ExternalLoginAction"
#define kGetRequestUrlAction @"AccountCom-GetRequestUrlAction"
#define kRegisterAction @"AccountCom-RegisterAction"
#define kUpdateAction   @"AccountCom-UpdateAction"
#define kExternalFriendsAction   @"AccountCom-ExternalUser"
#define kBindAction   @"AccountCom-BindAction"
#define kResetPasswordAction   @"AccountCom-ResetPasswordAction"
#define kAccountCom @"AccountCom"
#define kUpdateStatusAction @"AccountCom-UpdateStatusAction"
#define kUnBindAction   @"AccountCom-UnBindAction"
#define kExternalAccountList @"AccountCom-ExternalAccountList"
#define kGetDevicePushInfo @"getDevicePushInfo"
#define kUpdatePushStatus @"updatePushStatus"
#define kLogout @"logout"
#define kSyncup @"syncup"
#define kSyncupCom @"SyncupCom"

@implementation AccountServerProxy

-(id)init
{
    self = [super init];
    if (self) {
        self.keyCom = kAccountCom;
    }
    return self;
}

-(NSString *)urlByAction:(NSString *)action
{
    NSString *url = nil;
    if ([kLoginAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@login", [GlobalUtils serverUrl]];
    }
    else if ([kRegisterAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@UserInfo", [GlobalUtils uploadServerUrlHTTPS]];
    }
    else if([kUpdateAction isEqualToString:action]){
        url = [NSString stringWithFormat:@"%@UserInfo", [GlobalUtils uploadServerUrlHTTPS]];
    }
    else if ([kGetUserListAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getUserList", [GlobalUtils serverUrl]];
    }
    else if ([kExternalLoginAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@externalLogin", [GlobalUtils serverUrl]];
    }
    else if ([kGetRequestUrlAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getRequestUrl", [GlobalUtils serverUrl]];
    }
    else if([kExternalFriendsAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getExternalFriends", [GlobalUtils serverUrl]];
    }
    else if([kBindAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@bind", [GlobalUtils serverUrl]];
    }
    else if([kResetPasswordAction isEqualToString:action]) {
//        url = [NSString stringWithFormat:@"%@resetPassword", [GlobalUtils serverUrl]];
        url = [NSString stringWithFormat:@"%@resetPassword120", [GlobalUtils serverUrl]];
    } 
    else if([kUpdateStatusAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@updateStatus", [GlobalUtils serverUrl]];
    }
    else if([kUnBindAction isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@unBind", [GlobalUtils serverUrl]];
    } else if([kExternalAccountList isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getExternalAccountList",[GlobalUtils serverUrl]];
    } else if([kGetDevicePushInfo isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@getDevicePushInfo",[GlobalUtils serverUrl]];
    } else if([kUpdatePushStatus isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@updatePushStatus",[GlobalUtils serverUrl]];
    } else if([kLogout isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@logout",[GlobalUtils serverUrl]];
    } else if([kSyncup isEqualToString:action]) {
        url = [NSString stringWithFormat:@"%@syncup",[GlobalUtils serverUrl]];
    }
    return url;
}

-(void) getSyncupInfo
{
    SyncupCom *sysCom = [[[SyncupCom alloc] init] autorelease];
    RequestTask *task = [self generateRequestTask:sysCom.dataDict key:kSyncupCom forAction:kSyncup];
    [self doRequest:task];
}

-(void)getDevicePushInfo
{
    AccountCom *account = [[[AccountCom alloc] init] autorelease];
    account.pushtoken = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken];
    RequestTask *task = [self generateRequestTask:account.dataDict key:kAccountCom forAction:kGetDevicePushInfo];
    [self doRequest:task];
}

-(void)updatePushStatus:(AccountCom *)account
{
    RequestTask *task = [self generateRequestTask:account.dataDict key:kAccountCom forAction:kUpdatePushStatus];
    [self doRequest:task];
}


-(void)logout
{
    AccountCom *account = [[[AccountCom alloc] init] autorelease];
//    if ([[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]) {
        account.pushtoken = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken];
//    }    
    RequestTask *task = [self generateRequestTask:account.dataDict key:kAccountCom forAction:kLogout];
//    task.requestLevel = backgroundLevel;
    [self doRequest:task];
}

-(void)login:(AccountCom *)account
{
    //device token
    account.pushtoken = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken];
    RequestTask *task = [self generateRequestTask:account.dataDict key:kAccountCom forAction:kLoginAction];
    [self doRequest:task];
}

-(void)resiger:(AccountCom *)account withPhoto:(UIImage *)image
{
    //device token
    account.pushtoken = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken];
    
    NSData *data = nil;
    if (image) {
        data = UIImageJPEGRepresentation(image, 1);
        account.hasImage = [NSNumber numberWithBool:YES];
    }
    account.uploadType = [NSNumber numberWithInt:1];
    RequestTask *task = [self generateRequestTaskWithBody:data bodyKey:nil header:account.dataDict headerKey:kAccountCom forAction:kRegisterAction];
    [self doRequest:task];
}

-(void)getUserList:(AccountCom *)account
{
    RequestTask *task = [self generateRequestTask:account.dataDict key:kAccountCom forAction:kGetUserListAction];
    [self doRequest:task];
}

-(void)getExternalAccountList:(AccountCom *)account
{
    RequestTask *task = [self generateRequestTask:account.dataDict key:kExternalAccountList forAction:kExternalAccountList];
    [self doRequest:task];
}


-(void)updateBiography:(AccountCom*)account
{
    RequestTask *task = [self generateRequestTaskWithBody:nil bodyKey:nil header:account.dataDict headerKey:kAccountCom forAction:kRegisterAction];
    [self doRequest:task];
}

-(void)updateStatus:(AccountCom*)account  withStatus:(NSString*)status
{
    account.uploadType = [NSNumber numberWithInt:2];
    account.status = status;
    RequestTask *task = [self generateRequestTask:account.dataDict key:kAccountCom forAction:kUpdateStatusAction];
//    [self generateRequestTaskWithBody:nil bodyKey:nil header:account.dataDict headerKey:kAccountCom forAction:kUpdateStatusAction];
    
        [self doRequest:task];
}
-(void)updateImage:(AccountCom*)account withPhoto:(UIImage*)image
{
    NSData *data = nil;
    if (image) {
        data = UIImageJPEGRepresentation(image, 1);
    }
    //account.
    account.hasImage = [NSNumber numberWithBool:YES];
    account.uploadType = [NSNumber numberWithInt:2];
    RequestTask *task = [self generateRequestTaskWithBody:data bodyKey:nil header:account.dataDict headerKey:kAccountCom forAction:kRegisterAction];
    [self doRequest:task];

}

-(void)externalLogin:(AccountCom *)com
{
    //device token
    com.pushtoken = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken];
    RequestTask *task = [self generateRequestTask:com.dataDict key:kAccountCom forAction:kExternalLoginAction];
    [self doRequest:task];
}

-(void) getRequestUrl:(AccountCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:kAccountCom forAction:kGetRequestUrlAction];
    [self doRequest:task];
}


-(void) getExternalFriends:(AccountCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:kAccountCom forAction:kExternalFriendsAction];
    [self doRequest:task];
}

-(void) bind:(AccountCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:kAccountCom forAction:kBindAction];
    [self doRequest:task];
}

-(void) unBind:(AccountCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:kAccountCom forAction:kUnBindAction];
    [self doRequest:task];
}

-(void) resetPassword:(AccountCom *)com
{
    RequestTask *task = [self generateRequestTask:com.dataDict key:kAccountCom forAction:kResetPasswordAction];
    [self doRequest:task];
}

-(void)parseResponse:(id)responseData
{
    [super parseResponse:responseData];
    self.response = [[[AccountCom alloc] init] autorelease];
//    self.response.dataDict = responseData;
//    self.response.dataDict = [[[responseData objectForKey:kAccountCom] mutableCopy] autorelease];
//    [self.response.dataDict addEntriesFromDictionary:[responseData objectForKey:kAccountCom]];
}
@end
