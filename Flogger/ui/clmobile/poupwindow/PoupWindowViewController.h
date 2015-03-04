//
//  PoupWindowViewController.h
//  Flogger
//
//  Created by steveli on 09/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PoupWindowViewController;
@protocol PoupWindowDelegate <NSObject>

-(void)poupwindowRightAction;
-(void)poupwindowLeftAction;

@end

@interface PoupWindowViewController : UIView{
    CGRect               _frame;
}

@property(nonatomic, retain) UIImageView * bgview;
@property(nonatomic, retain) UIImageView * poupbgview;
@property(nonatomic, retain) UIButton    * cancelbtn;
@property(nonatomic, retain) UIButton    * donebtn;
@property(nonatomic, retain) UITextView  * textview;
@property(nonatomic, assign) id /*<PoupWindowDelegate>*/ delegate;

-(void)setleftbtn:(NSString*)title bgimg:(UIImage*)img;
-(void)setrightbtn:(NSString*)title bgimg:(UIImage*)img;
-(void)settTitle:(NSString*)title;


-(void)show;
-(void)hide;
@end
