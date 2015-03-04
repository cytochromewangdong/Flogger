//
//  FloggerGlobal.m
//  Flogger
//
//  Created by wyf on 12-3-6.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerUIFactory.h"

static FloggerUIFactory* globalFactory; 
@implementation FloggerUIFactory
+(FloggerUIFactory*) uiFactory
{
    if(!globalFactory)
    {
        globalFactory =  [[FloggerUIFactory alloc]init];
    }
    return globalFactory;
}
-(UIButton *) createButton : (UIImage *) normalImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (normalImage) {
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    }    
    return btn;    
    
//    UITableView *table = [UITableView alloc] initWithFrame:<#(CGRect)#> style:<#(UITableViewStyle)#>
}

-(UILabel *) createLable
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
//    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    return label;
}

-(UIView *) createView
{
    UIView *view = [[[UIView alloc] init] autorelease];
//    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(UIImageView *) createImageView : (UIImage *) image;
{
    UIImageView *imageView;
    if (image) {
        imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    } else {
        imageView = [[[UIImageView alloc] init] autorelease];
    }
     
    return imageView;
}

-(UIScrollView *) createScrollView
{
    UIScrollView *scrollView = [[[UIScrollView alloc] init] autorelease];
    return scrollView;
}

-(UITextField *) createTextField
{
    UITextField *field = [[[UITextField alloc] init] autorelease];
    field.frame = CGRectMake(kLeftMargin, kTopMargin, kTextFieldWidth, kTextFieldHeight);
    field.borderStyle = UITextBorderStyleNone;
    field.textColor = [UIColor blackColor];
    field.font = [UIFont boldSystemFontOfSize:14];
    field.backgroundColor = [UIColor clearColor];
    field.autocorrectionType = UITextAutocorrectionTypeNo;
//    field.backgroundColor = [UIColor redColor];
//    field.textAlignment = UITextAlignmentCenter;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    field.keyboardType = UIKeyboardTypeDefault;
    field.returnKeyType = UIReturnKeyDone;
    
    field.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    return field;
}

-(UISlider *) createSlider
{
    UISlider *slider = [[[UISlider alloc] init] autorelease];
    return slider;
}

-(UIWebView *) createWebView
{
    UIWebView *webView = [[[UIWebView alloc] init] autorelease];
    return webView;
}

-(CALayer *) createLayer
{
    CALayer *layer = [[[CALayer alloc] init] autorelease];
    return layer;
//    barItem setImage:<#(UIImage *)#>
}

-(UITableView *) createTableView
{
    UITableView *tableView = [[[UITableView alloc] init] autorelease];
    return tableView;
};

-(UIToolbar *) createToolBar
{
    UIToolbar *toolBar = [[[UIToolbar alloc] init] autorelease];
    return toolBar;
}

-(TTButton *) createFloggerButton : (NSString *) style title:(NSString*) title;
{
    TTButton *ttBtn = [TTButton buttonWithStyle:style title:title];
    //ttBtn.canBecomeFirstResponder
    //[ttBtn sizeToFit];
    return ttBtn;
}

-(TTButton *) createFlatButton:(NSString*) title;
{
    return [self createFloggerButton:@"flatButton:" title:title];
}
-(UITableViewCell*)createTableCell:(NSString*)identifier
{
    return  [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identifier] autorelease];
}
-(UIImage *) createImage : (NSString *) imagePath
{
    UIImage *image = [UIImage imageNamed:imagePath];
    return image;
}

-(UITextView *) createTextView
{
    UITextView *text = [[[UITextView alloc] init] autorelease];
    return text;
}

-(TTStyledTextLabel *) createTTStyledTextLable
{
    TTStyledTextLabel* ttstyleLable = [[[TTStyledTextLabel alloc] init] autorelease];
    return ttstyleLable;
}


//font
-(UIFont *) createMiddleFont
{
    UIFont *font = [UIFont systemFontOfSize:15];
    return font;
}

-(UIFont *) createSmallFont
{
    UIFont *font = [UIFont systemFontOfSize:14];
    return font;
}

-(UIFont *) createMiddleBoldFont
{
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    return font;
}

-(UIFont *) createSmallBoldFont
{
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    return font;
}


-(UIFont *) createBigFont
{    
    UIFont *font = [UIFont systemFontOfSize:16];
    return font;
    
}

-(UIFont *) createBigBoldFont
{
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    return font;
    
}

-(UIFont *) createVideoTimeFont
{
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    return font;
}

-(UIFont *) createSamllVideoTimeFont
{
    UIFont *font = [UIFont boldSystemFontOfSize:11];
    return font;
}

-(void)dealloc
{
    [super dealloc];
//    UIActivityIndicatorView
}
-(UIButton *) createHeadButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[[[UIColor alloc] initWithRed:63/255.0 green:154/255.0 blue:213/255.0 alpha:1.0] autorelease] forState:UIControlStateSelected];
    [btn setTitleColor: [[[UIColor alloc] initWithRed:64/255.0 green:63/255.0 blue:62/255.0 alpha:1.0] autorelease]forState:UIControlStateNormal];
    
    UIFont *famFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    btn.titleLabel.shadowOffset = CGSizeMake(0, 1);
//    btn.titleLabel.shadowColor=[UIColor whiteColor];
    [btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = famFont;
    return btn;
}

-(UIButton *) createHeadButton:(UIImage *)norImage withSelImage: (UIImage *) selImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:norImage forState:UIControlStateNormal];
    [btn setBackgroundImage:selImage forState:UIControlStateSelected];
//    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitleColor:[[[UIColor alloc] initWithRed:63/255.0 green:154/255.0 blue:213/255.0 alpha:1.0] autorelease] forState:UIControlStateSelected];
    [btn setTitleColor: [[[UIColor alloc] initWithRed:64/255.0 green:63/255.0 blue:62/255.0 alpha:1.0] autorelease]forState:UIControlStateNormal];
//    btn.titleLabel.font = [self createMiddleBoldFont];
//    btn.titleLabel.font.familyName = @"Helvetica Neue";
    UIFont *famFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
//    btn.titleLabel.shadowOffset = CGSizeMake(0, -1);
     btn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    famFont = [self createMiddleFont];
//    [famFont ]
    btn.titleLabel.font = famFont;
    return btn;
}

-(UITextField *) createSearchTextField
{
    UITextField *txtF = [[[UITextField alloc] init] autorelease];
    UIImage *searchImage = [self createImage:SNS_SEARCH_ICON];    
    UIImageView *searchImageView = [self createImageView:searchImage];
    txtF.leftView = searchImageView;
    txtF.leftViewMode = UITextFieldViewModeAlways;
    txtF.textAlignment = UITextAlignmentLeft;
    txtF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtF.borderStyle = UITextBorderStyleRoundedRect;
    txtF.font = [self createMiddleFont];
    txtF.keyboardType = UIKeyboardTypeDefault;
    txtF.returnKeyType = UIReturnKeySearch;

    return txtF;
}

-(UIView *) createBackgroundView
{
    UIView *view = [[[UIView alloc] init] autorelease];
//    view.backgroundColor = [[[UIColor alloc] initWithRed:241/255.0 green:241/255.0 blue:238/255.0 alpha:1.0] autorelease];
    view.backgroundColor = [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    return view;
}

-(UIView *) createButtonsBackgroundView
{
    UIView *view = [[[UIView alloc] init] autorelease];
    //    view.backgroundColor = [[[UIColor alloc] initWithRed:241/255.0 green:241/255.0 blue:238/255.0 alpha:1.0] autorelease];
    view.backgroundColor = [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BUTTON_BACKGROUND]];
    return view;
}

-(UIColor *) createBackgroundColor
{
    UIColor *color = [[[UIColor alloc] initWithRed:241/255.0 green:241/255.0 blue:238/255.0 alpha:1.0]autorelease];
    return color;
}

-(UIColor *) createViewFontColor
{
    UIColor *color = [[[UIColor alloc] initWithRed:240/255.0 green:240/255.0 blue:233/255.0 alpha:1.0] autorelease];
    return color;
}

-(UIColor *) createTableViewFontColor
{
    UIColor *color = [[[UIColor alloc] initWithRed:65/255.0 green:64/255.0 blue:63/255.0 alpha:1.0] autorelease];
    return color;
}

-(UIColor *) createDescFontColor
{
    UIColor *color =  [[[UIColor alloc] initWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0] autorelease];
    return color;
}

-(UIColor *) createNumFontColor
{
    UIColor *color =  [[[UIColor alloc] initWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0] autorelease];
    return color;
}

-(UIColor *) createSelectFontColor
{
    UIColor *color = [[[UIColor alloc] initWithRed:17/255.0 green:193/255.0 blue:244/255.0 alpha:1.0] autorelease];
    return color;
}

-(UIColor *) createLoginFontColor
{
    UIColor *color = [[[UIColor alloc] initWithRed:66/255.0 green:66/255.0 blue:62/255.0 alpha:1.0] autorelease];
    return color;
}


@end
