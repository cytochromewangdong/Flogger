//
//  GlobalData.m
//  Flogger
//
//  Created by jwchen on 11-12-26.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "GlobalData.h"
#import "DataCache.h"
#import "AccountCom+nscoding.h"
#import "ExternalPlatformCom+nscoding.h"


static GlobalData *sharedInstance = nil;
static NSString *kLoginAccount = @"loginaccount"; 
static NSString *kExternalCom = @"kExternalCom";

@implementation GlobalData
@synthesize myAccount, exPlatform;

+ (GlobalData*) sharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[GlobalData alloc] init];
    }
    return sharedInstance;
}
+ (void) purgeSharedInstance
{
    RELEASE_SAFELY(sharedInstance);
}

-(id)init
{
    self = [super init];
    if (self) {
        self.myAccount = [GlobalUtils loadFromArchiverByName:kLoginAccount];
        self.exPlatform = [GlobalUtils loadFromArchiverByName:kExternalCom];
    }
    return self;
}

-(FloggerMenuView *) menuView
{    
    return menuView;
}

-(void)setUpMenuView:(CGRect)frame
{
    FloggerMenuView *menu = [[FloggerMenuView alloc] initWithFrame:frame];
    menu.count = [[GlobalData sharedInstance].myAccount.notificationCount intValue];
    menuView = menu;
    menu.tag = 100000;
}

-(void)saveLoginAccount
{
    [GlobalUtils save2Archiver:self.myAccount name:kLoginAccount];
}

-(void)removeAccount
{
    [GlobalUtils removeFromArchiverByName:kLoginAccount];
    self.myAccount = nil;
}

-(void)saveExternalPlatform
{
    if (self.exPlatform) {
        [GlobalUtils save2Archiver:self.exPlatform name:kExternalCom];
    }
    
}
-(void)removeExternalPlatform
{
    if (self.exPlatform) {
        [GlobalUtils removeFromArchiverByName:kExternalCom];
    }
    
    /*self.exPlatform = nil;*/
}

-(void)dealloc
{
    RELEASE_SAFELY(menuView);
    RELEASE_SAFELY(myAccount);
    self.exPlatform = nil;
    [super dealloc];
}

@end
