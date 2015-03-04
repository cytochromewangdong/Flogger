//
//  FloggerGlobal.h
//  Flogger
//
//  Created by wyf on 12-3-6.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#define kLeftMargin				15.0
#define kTopMargin				10.0
#define kRightMargin			20.0

#define kTextFieldHeight		25.0
#define kTextFieldWidth	285

@interface FloggerUIFactory : NSObject
+(FloggerUIFactory*) uiFactory;
-(UIButton *) createButton : (UIImage *) normalImage;
-(UILabel *) createLable ;
-(UIView *) createView;
-(UIImageView *) createImageView : (UIImage *) image;
-(UIScrollView *) createScrollView;
-(UITextField *) createTextField;
-(UISlider *) createSlider;
-(UIWebView *) createWebView;
-(UITableView *) createTableView;
-(UIToolbar *) createToolBar;

-(TTButton *) createFloggerButton : (NSString *) style title:(NSString*) title;
-(TTButton *) createFlatButton:(NSString*) title;

-(CALayer *) createLayer;


-(UITableViewCell *)createTableCell:(NSString*)identifier;


-(UIImage *) createImage : (NSString *) imagePath;

-(UITextView *) createTextView;

-(TTStyledTextLabel *) createTTStyledTextLable;

-(UIFont *) createBigFont;

-(UIFont *) createBigBoldFont;

-(UIFont *) createMiddleFont;

-(UIFont *) createSmallFont;

-(UIFont *) createMiddleBoldFont;

-(UIFont *) createSmallBoldFont;
-(UIButton *) createHeadButton;
-(UIButton *) createHeadButton:(UIImage *)norImage withSelImage: (UIImage *) selImage;
-(UITextField *) createSearchTextField;

-(UIView *) createBackgroundView;

-(UIColor *) createTableViewFontColor;
-(UIColor *) createViewFontColor;
-(UIColor *) createBackgroundColor;
-(UIColor *) createDescFontColor;
-(UIColor *) createSelectFontColor;
-(UIColor *) createLoginFontColor;

//+ (NSString *)getModel;
@end
