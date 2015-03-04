//
//  FloggerPopMenuView.h
//  Flogger
//
//  Created by jwchen on 12-2-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FloggerPopMenuView;
@protocol FloggerPopMenuViewDelegate <NSObject>

-(void)floggerPopMenuView:(FloggerPopMenuView *)popMenuView clickedAtIndex:(NSInteger)index;

@end

@interface FloggerPopMenuView : UIButton
{
    NSInteger _selectedIndex;
}
@property (nonatomic, assign) id<FloggerPopMenuViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) UIButton* allButton, *photoButton, *videoButton, *tweetButton;

-(void)menuTapped:(id)sender;
-(void)backgroundTapped:(id)sender;

-(void)toggleMenu;

@end
