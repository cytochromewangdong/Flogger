//
//  MyWebView.h
//  WdaTest
//
//  Created by dong wang on 11-11-22.
//  Copyright (c) 2011年 atoato. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KEY_WEB_SUCCESS @"success"
#define KEY_WEB_ACTION @"cmd"
#define KEY_ISOWN @"isOwn"
#define KEY_ISLOGIN @"islogin"
@interface FloggerWebView : UIWebView
@property(nonatomic,retain) NSString *action;
@property(assign) BOOL isUsing; 
@property(assign) BOOL isLoaded;
@property(assign) id actionDelegate;
-(NSString*)fillData:(NSString*)jsonData;
-(NSString*)clearData;
-(NSString*)hostCallBack:(NSString*)jsonData;
- (UIScrollView*) getMainScrollView;
- (CGRect)frameOfElement:(NSString*)query;
- (CGFloat)getHeight;
@end
