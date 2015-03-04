//
//  FloggerWebAdapter.h
//  Flogger
//
//  Created by dong wang on 12-3-29.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloggerWebView.h"
#define kShapeWeb @"shape"

#define kScheme @"sheme"
#define kKeyword @"keyword"
#define kMyapp @"myapp"
#define kAtTag @"at"
#define kTagTag @"tag"
#define kListTag @"list"

#define kComposeWebAction @"compose"
@interface FloggerWebAdapter : NSObject<UIWebViewDelegate>
{
    FloggerWebView * _biographyView;
    FloggerWebView * _feedViewHeader;
    //FloggerWebView * _feedShapeView;
    NSMutableArray * _feedRows;
    NSURLRequest *_feedrequest;
    FloggerWebView *_composeView;
}
+(FloggerWebAdapter*) getSingleton;
+(void)purgeSharedInstance;

-(void) refreshBiographyView;
//-(void) refreshFeedView:(FloggerWebView*)feedView action:(NSString*)action;
//-(FloggerWebView*)getFeedView:(NSString*)action;
//-(FloggerWebView*)getShapeReference;
-(FloggerWebView*) getBiographyView;
//-(FloggerWebView*) createNormalWebView:(NSString*)action url:(NSString*) urlstr;
//-(FloggerWebView*) createProfileHeaderView:(NSString*)action;
//-(FloggerWebView*) createViewerHeaderView:(NSString*)action;
//-(FloggerWebView*) createViewerView:(NSString*)action;
//-(FloggerWebView*) createComposeView:(NSString*)action;
//-(FloggerWebView *) getComposeView;
//-(void)initFeedShapeView;
@end
