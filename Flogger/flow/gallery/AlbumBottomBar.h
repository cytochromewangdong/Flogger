//
//  AlbumBottomBar.h
//  Flogger
//
//  Created by jwchen on 12-2-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    ALBUM_BOTTOM_COVER = 1,
    ALBUM_BOTTOM_SHARE,
    ALBUM_BOTTOM_ADDTO,
    ALBUM_BOTTOM_DELETE,
    ALBUM_BOTTOM_IMPORT,
    ALBUM_BOTTOM_EDIT
}AlbumBottomBarType;


@class AlbumBottomBar;
@protocol AlbumBottomBarDelegate <NSObject>
-(void)albumBottomBarCommand:(NSInteger)command;
@end


@interface AlbumBottomBar : UIView

@property (nonatomic,retain) UIImageView* backview;
@property (nonatomic,retain) UIButton* coverbtn;
@property (nonatomic,retain) UIButton* sharebtn;
@property (nonatomic,retain) UIButton* addbtn;
@property (nonatomic,retain) UIButton* deletebtn;
@property (nonatomic,retain) UIButton* editbtn;
@property (nonatomic,retain) UIButton* importbtn;
@property (nonatomic,retain) id/*<AlbumBottomBarDelegate>*/ delegate;
@property (nonatomic,assign) BOOL      mflag;

-(void)CheckImage:(BOOL)flag;
-(void)EnableCoverBtn:(BOOL)flag;
-(void)EnableAllBtn:(BOOL)flag;

@end
