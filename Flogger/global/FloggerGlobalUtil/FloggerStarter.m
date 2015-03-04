//
//  FloggerStarter.m
//  Flogger
//
//  Created by wyf on 12-3-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerStarter.h"
#import "FloggerDefaultStyleSheet.h"
#import "FloggerPrefetch.h"
#import "FloggerCSSStyleSheet.h"
#import "FloggerFilteredWebCache.h"
#import "FloggerWebAdapter.h"
#import "FloggerLayoutAdapter.h"
#import "UploadServerProxy.h"
#import "LocationManager.h"
@implementation FloggerStarter
+(void) doWorkOnStart:(FloggerAppDelegate*)delegate {
    // initialize the style
    //[TTDefaultStyleSheet setGlobalStyleSheet:[[[FloggerDefaultStyleSheet alloc]init]autorelease]];
    FloggerCSSStyleSheet *styleSheet = [[[FloggerCSSStyleSheet alloc] init] autorelease];
    [styleSheet addStyleSheetFromDisk:TTPathForBundleResource(@"stylesheet.css")];
    [TTStyleSheet setGlobalStyleSheet:styleSheet];
    [[FloggerPrefetch getSingleton] downloadExternalPlatform];
    
    /*FloggerFilteredWebCache *cache =
    [[FloggerFilteredWebCache alloc] initWithMemoryCapacity: [[NSURLCache sharedURLCache] memoryCapacity]//memoryCapacity
                                        diskCapacity: [[NSURLCache sharedURLCache] diskCapacity] diskPath:@"/"];
    [NSURLCache setSharedURLCache:cache];
    [cache release];*/
     /*   NSString *xmlLayoutPath = [[NSBundle mainBundle]pathForResource:@"feed" ofType:@"xml"];
        NSString *xmlCSSLayoutPath = [[NSBundle mainBundle]pathForResource:@"feed.css" ofType:@"xml"];
    [[FloggerLayoutAdapter sharedInstance]createLayout:xmlLayoutPath StylePath:xmlCSSLayoutPath];*/
    [[LocationManager sharedInstance]startGetLocation];
    [[FloggerWebAdapter getSingleton] getBiographyView];
    //[[FloggerWebAdapter getSingleton] initFeedShapeView];
    //[[FloggerWebAdapter getSingleton] getComposeView];
    //[[[FloggerWebAdapter getSingleton] createProfileHeaderView:@"preload"]autorelease];
    //[UploadServerProxy loadFileAndResumeTask];
    
}
@end
