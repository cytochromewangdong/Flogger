//
//  FloggerLayoutAdapter.h
//  Flogger
//
//  Created by dong wang on 12-4-13.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloggerLabel.h"
#import "FloggerImageView.h"
#define AUTO_DIMENTION -99999
#define NONE_ACTION @"none"
#define K_EVENT_DATA @"data"
#define K_EVENT_ACTION @"action"
#define USER_INTERACTION_DISABLED @"0"
@interface UIColor()

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

@end

@protocol FloggerActionHandler <NSObject>
- (void) handleAction:(NSNotification *)notification;
@end
@interface FloggerLayoutParam : NSObject
@property(assign)GLfloat width;
@property(assign)GLfloat height;
@property(retain)UIImage* image;
@property(retain)UIImage* pressedImage;
@property(retain)NSString *userEnabled;
//@property(nonatomic, retain) NSString *imgSrc;

@property(nonatomic, retain) NSString *actionType;
@end
@interface FloggerStyle : NSObject 
{
    GLfloat _x, _y, _width,_height,_adjustX,_adjustY;
    UIColor *_color,*_backgroundColor;
    UIFont  *_font;
    TTStyle *_filter;
    TTImageEffect *_effect;
    UITextAlignment _textAlignment;
    BOOL _userEnable;
    BOOL _animation;
    GLfloat _minY;
    GLfloat _maxiumW;
    GLfloat _maxiumH;
    BOOL _progressable;
    BOOL _outOfFlow;
}
@property (nonatomic, retain)NSString* name;
@property (nonatomic, retain)NSString* rawContentMode;
@property (nonatomic, retain)NSString* rawPosition;
@property (nonatomic, retain)NSString* rawX;
@property (nonatomic, retain)NSString* rawY;
@property (nonatomic, retain)NSString* rawWidth;
@property (nonatomic, retain)NSString* rawHeight;
@property (nonatomic, retain)NSString* rawHPadding;
@property (nonatomic, retain)NSString* rawVPadding;
@property (nonatomic, retain)NSString* rawHMargin;
@property (nonatomic, retain)NSString* rawVMargin;
@property (nonatomic, retain)NSString* rawBorder;
@property (nonatomic, retain)NSString* rawColor;
@property (nonatomic, retain)NSString* rawBackgroundColor;
@property (nonatomic, retain)NSString* rawFilter;
@property (nonatomic, retain)NSString* rawFont;
@property (nonatomic, retain)NSString* rawSysfont;
@property (nonatomic, retain)NSString* rawEffect;
@property (nonatomic, retain)NSString* rawTextAlignment;
@property (nonatomic, retain)NSString* rawUserEnable;
@property (nonatomic, retain)NSString* rawMiny;
@property (nonatomic, retain)NSString* rawAnimation;
@property (nonatomic, retain)NSString* rawProgressable;
@property (nonatomic, retain)NSString* rawMaxiumW;
@property (nonatomic, retain)NSString* rawMaxiumH;
@property (nonatomic, retain)NSString* rawThreePatches;
@property (nonatomic, retain)NSString* rawOutOfFlow;

@property (assign, readonly) GLfloat x;
@property (assign, readonly) GLfloat y;
@property (assign, readonly) GLfloat width;
@property (assign, readonly) GLfloat height;
@property (assign, readonly) UIColor *color;
@property (assign, readonly) UIColor *backgroundColor;
@property (assign, readonly) UIFont *font;
@property (assign, readonly) TTStyle *filter;
@property (assign, readonly) TTImageEffect *effect;
@property (assign, readonly) UITextAlignment textAlignment;
@property (assign, readonly) GLfloat adjustX;
@property (assign, readonly) GLfloat adjustY;
@property (assign, readonly) GLfloat minY;
@property (assign, readonly) GLfloat maxiumW;
@property (assign, readonly) GLfloat maxiumH;
@property (assign, readonly) BOOL userEnable;
@property (assign, readonly) BOOL animation;
@property (assign, readonly) BOOL progressable;
@property (assign, readonly) BOOL outOfFlow;
//@property (assign, readonly)
@end
@interface FloggerLayout : NSObject
{
    UIImage* _image;
    UIImage* _placeHolderImage;
    UIImage* _pressedImageSingle;
}
@property (nonatomic, retain)NSString* name;
@property (nonatomic, retain)NSString* actionType;
@property (nonatomic, retain)NSString* fillDataKey;
@property (nonatomic, retain)FloggerStyle* style;
@property (nonatomic, retain)NSString* imageSrc;
@property (nonatomic, retain)NSString* placeholder;
@property (nonatomic, retain)NSString* pressedImage;
@property (nonatomic, retain)NSMutableArray *subviews;
@property (nonatomic, assign)FloggerLayout *parentView;
@property (nonatomic, retain)NSString* viewType;
@property (nonatomic, retain)NSString* label;
@property (nonatomic, retain)UIImage* image;
@property (nonatomic, retain)UIImage* placeHolderImage;
@property (nonatomic, retain)UIImage* pressedImageSingle;
@property (nonatomic, retain)NSString* pureText;
@property (nonatomic, retain)NSString* loopMore;

@end
@interface FloggerViewAdpater:NSObject<TapDelegate>
@property (nonatomic, retain) FloggerLayout* layout;
@property (nonatomic, retain) NSMutableArray* subviews;
@property (nonatomic, assign) FloggerViewAdpater* parentView;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *actionType;
@property (nonatomic, assign) id<FloggerActionHandler> actionDeletgate;
-(FloggerViewAdpater*) getPreviousSibling:(NSDictionary*)invisibleViews;
-(FloggerViewAdpater*) getAdpaterByName:(NSString*)fName;
@end
@interface FloggerLayoutAdapter : NSObject
+(FloggerLayoutAdapter *)sharedInstance;
+(void)purgeSharedInstance;
-(FloggerLayout *) createLayout:(NSString*)layoutPath StylePath:(NSString*) stylePath;
-(FloggerViewAdpater*) createViewSet:(FloggerLayout*)currentLayout ParentAapter:(FloggerViewAdpater*)parent ActionHandler:(id<FloggerActionHandler>) actionHandler;
- (CGRect)fillAndLayoutSubviews:(FloggerViewAdpater*) currentView ViewDisplayParameters:(NSDictionary*)displayParameter DataFillParameters:(NSDictionary *)data InvisibleViews:(NSDictionary*)invisibleViews;
@end
