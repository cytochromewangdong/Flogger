//
//  VideoPlayViewController.h
//  Flogger
//
//  Created by jwchen on 12-3-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoPlayViewController : BaseViewController

@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, copy) NSString *videoUrl;

@end
