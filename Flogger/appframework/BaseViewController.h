//
//  BaseViewController.h
//  Flogger
//
//  Created by jwchen on 11-12-8.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ScaleableImageView.h"

@interface BaseViewController : UIViewController

@property(nonatomic, assign) BOOL isHiddenNavigationBar;
@property(nonatomic, assign) BOOL isRightBarSelected;
@property(nonatomic, retain) NSString *helpImageURL;

//@property(nonatomic, retain) ScaleableImageView *fullImageView;

-(void)setRightNavigationBarWithTitleAndImage:(NSString *)text image:(NSString *)imageName pressimage:(NSString*)pressimgname;
-(void)setRightNavigationBarWithTitle:(NSString *)text image:(NSString *)imageName;
-(void)setLeftNavigationBarWithTitle:(NSString *)text image:(NSString *)imageName;
-(void)setBackNavigation;
//-(void)setNavigationTitleView;


-(void)leftAction:(id)sender;
-(void)rightAction:(id)sender;
-(void)backAction:(id)sender;

@property (nonatomic, assign) CGRect keyboardRect;
- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)keyboardWillBeShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;

-(void)registerForTextFieldTextChangedNotification;
-(void)unregisterForTextFieldTextChangedNotification;

-(void) applicationWillResign: (NSNotification *) notification;

-(void)showFullImageViewWithImageUrl:(NSString *)imageUrl placeHolderImage:(UIImage *)image;

-(BOOL) checkIsFullScreen;
-(void) setNavigationTitleView : (NSString *) titleStr;
-(void)go2Login;
-(BOOL) checkIsShowHelpView;


@end
