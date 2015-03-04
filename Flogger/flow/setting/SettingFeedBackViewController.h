//
//  SettingFeedBackViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
#import "FloggerScrollView.h"
#import "FloggerTextView.h"

@interface SettingFeedBackViewController : BaseNetworkViewController<UITextViewDelegate,UITextFieldDelegate>{
    
}

@property(nonatomic, retain) UITextField *subjectView;
@property(nonatomic, retain) FloggerTextView *contentView;
@property (nonatomic, retain) FloggerScrollView *scrollView;

@end
