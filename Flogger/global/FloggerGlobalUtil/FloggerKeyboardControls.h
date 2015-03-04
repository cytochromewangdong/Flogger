//
//  IPKeyboardControls.h
//  Simon Støvring
//
//  Created by Simon Støvring on 09/01/12.
//  Copyright (c) 2012 Simon Støvring. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FloggerKeyboardControlsDelegate;

/* Used to tell whether the user pressed the "Previous" or the "Next" button */
typedef enum {
    KeyboardControlsDirectionPrevious,
    KeyboardControlsDirectionNext
} KeyboardControlsDirection;

@interface FloggerKeyboardControls : UIView

/* The delegate (BSKeyboardControlsDelegate, see below) */
@property (nonatomic, retain) id <FloggerKeyboardControlsDelegate> delegate;

/* The text fields the BSKeyboardControls will handle */
@property (nonatomic, retain) NSArray *textFields;

/* The currently active text field */
@property (nonatomic, retain) id activeTextField;

/* The style of the UIToolbar */
@property (nonatomic, assign) UIBarStyle barStyle;

/* The tint color of the "Previous" and the "Next" button */
@property (nonatomic, retain) UIColor *previousNextTintColor;

/* The tint color of the done button */
@property (nonatomic, retain) UIColor *doneTintColor;

/* The title of the "Previous" button */
@property (nonatomic, retain) NSString *previousTitle;

/* The title of the "Next" button */
@property (nonatomic, retain) NSString *nextTitle;

@end

@protocol FloggerKeyboardControlsDelegate <NSObject>
@required
/* Called when the user presses either the "Previous" or the "Next" button */
- (void)keyboardControlsPreviousNextPressed:(FloggerKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField;

/* Called when the user pressed the "Done" button */
- (void)keyboardControlsDonePressed:(FloggerKeyboardControls *)controls;
@end
