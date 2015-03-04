//
//  TagButton.h
//  Flogger
//
//  Created by steveli on 24/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagButton;
@protocol TagButtonDelegate <NSObject>

-(void)tagButtonPressed:(id)sender content:(NSString*)content;
-(void)tagButtonDelete:(id)sender;

@end


@interface TagButton : UIView{
    BOOL _isshowdeleteicon;
}

@property(nonatomic,retain)UIButton* btn_tag;
@property(nonatomic,retain)UIButton* btn_delete;
@property(nonatomic,assign)id/*<TagButtonDelegate>*/ delegate;
@property(nonatomic,assign)NSString* text;

-(void)setText:(NSString*)str;
-(void)setShowDeleteIcon:(BOOL)flag;



@end
