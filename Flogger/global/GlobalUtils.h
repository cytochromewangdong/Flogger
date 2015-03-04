//
//  GlobalUtils.h
//  Flogger
//
//  Created by jwchen on 11-12-26.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityEnumHeader.h"
#import "ActivityResultEntity.h"
#import "MyAccount.h"
#import "MyExternalaccount.h"

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

// Release a CoreFoundation object safely.
#define RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }

typedef enum{
    FONT_SMALL = 10,
    FONT_MIDDLE = 13,
    FONT_BIG = 16,
}FontStyle;

@interface GlobalUtils : NSObject

+(NSString *)serverUrl;
+(NSString *)uploadServerUrl;
+(NSString *)uploadServerUrlHTTPS;
+(NSString *)preUploadServerUrl;
+(NSString *)imageServerUrl:(NSString *)imagePath;

+(UIFont*)getFontByStyle:(FontStyle)style;
+(UIFont*)getBoldFontByStyle:(FontStyle)style;

+ (NSString *)getDisplayableStrFromDate:(NSDate *)date;

+ (void)showPostMessageAlert:(NSString*)str;
+ (void)showMessageAlert:(NSString *)str delegate:(id)delegate tag:(NSInteger)itag;
+(UIBarButtonItem*)customBarButton :(NSString *)name normalimg:(UIImage*)img highlightimg:(UIImage*)img1 addTarget:(id)target action:(SEL)action;


+(CGSize)getBoldTextWidth:(NSString*)content fontstyle:(FontStyle)style;
+(CGSize)getTextWidth:(NSString*)content fontstyle:(FontStyle)style;

+(void)showAlert:(NSString*)t message:(NSString*)message;
+(void)closeAlertView : (UIAlertView *) alertView;

//+(NSString *)getActionStrByType:(ActionType)actionType andTargetName:(NSString *)name;
//+(NSString *)getTargetStrByIssueCategory:(IssueInfoCategory)category;
//+(NSString *)getNotificationStr:(ActivityResultEntity *)notification;

//+(NSString *)getActionStrByTypeWithCount:(ActionType)actionType count:(NSInteger)count;
//+(NSString *)getArrayNotificationStr:(ActivityResultEntity *)notification count:(NSInteger)count;


//+(NSString *)getLocalizedString:(NSString *)keyStr;

+(NSMutableArray *)getAllContacts;

+(id)loadFromArchiverByName:(NSString *)fileName;
+(void)save2Archiver:(id)model name:(NSString *)fileName;
+(void)removeFromArchiverByName:(NSString *)fileName;

+(NSString *)getStrByRegex:(NSString *)str;
+(UIImage *) getDefaultImage : (NSNumber *) gender;

+(BOOL) isEmpty:(NSString* )str;

+(BOOL) checkIsOwner: (MyAccount *) account;
+(BOOL) checkIsOwnerByUserUID: (long long) userUID;
+(BOOL) checkIsLogin;

+(void) clearWebCookie;
+(void) clearExternalPlatformCacheAndCookie : (NSString *) url;
+(MyExternalaccount *)getExternalAccount:(NSNumber*)sourceID;
+(MyExternalaccount *)getExternalAccount:(NSNumber*)sourceID List:(NSArray*)externalAccountList;
//+()
+(void) saveTokenTime;
+(BOOL) checkExpiredToken; 
+(NSString *)getModel;
+(BOOL) checkExpiredTime : (NSString *) key; 
+(void) configureShowHelpView : (NSString *) viewImageURLKey;
+(BOOL) checkIsFirstShowHelpView : (NSString *) viewImageURLKey;
//+(NSMutableArray *) retriveEmailArrayFromAddress;
//+(NSMutableArray *) retrivePhoneArrayFromAddress;
+(NSTimeInterval) getCropVideoTime;
+(BOOL)checkIOS_6;
@end
