//
//  FloggerAppDelegate.h
//  Flogger
//
//  Created by jwchen on 11-12-26.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "BCTabBarController.h"
#import "AccountServerProxy.h"

@interface FloggerNavigationControllerForIos6 : UINavigationController

@end

@interface FloggerNavigationController : UINavigationController
@end

@interface FloggerTabBarController : UITabBarController
@end

@interface FloggerAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, BCTabBarControllerDelegate,UIActionSheetDelegate>
{
    BOOL _isScrollAndRefresh;
}

@property (retain, nonatomic) UIWindow *window;

@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic, retain) BCTabBarController *rootTabBarControl;
@property (nonatomic, retain) UIViewController *lastTimeControl;
@property(nonatomic, retain) UIViewController *testViewControl;
@property (nonatomic,retain) AccountServerProxy *accountProxy;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)showMain;

-(void)logout;
-(void)showTabViewControl;
-(void) showFirstRegisterScreen : (NSMutableArray *) contactList;
-(void) showFeedScreen;
-(void) showLogin;
-(void) showAlertMessage: (NSString *) message;

@end
