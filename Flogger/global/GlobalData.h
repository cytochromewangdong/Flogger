//
//  GlobalData.h
//  Flogger
//
//  Created by jwchen on 11-12-26.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SynthesizeSingleton.h"
#import "FloggerMenuView.h"
#import "AccountCom.h"
#import "ExternalPlatformCom.h"

typedef enum
{
    Command_Menu = 100,
    Command_Profile,
    Command_Feed,
    Command_Gallery,
    Command_Favorites,
    Command_Tweet,
    Command_VideoCamera,
    Command_PhotoCamera,
}CommandType;

@interface GlobalData : NSObject
{
    @private 
    FloggerMenuView *menuView;
}
@property(nonatomic, retain) AccountCom *myAccount;

-(FloggerMenuView *) menuView;

-(void) setUpMenuView:(CGRect)frame;
//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(GlobalData);

+ (GlobalData*) sharedInstance;
+ (void) purgeSharedInstance;

@property(nonatomic, retain) ExternalPlatformCom *exPlatform;

-(void)saveLoginAccount;
//-(void)loadLoginAccount;
-(void)removeAccount;

-(void)saveExternalPlatform;
-(void)removeExternalPlatform;

@end
