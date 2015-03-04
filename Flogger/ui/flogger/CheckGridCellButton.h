//
//  CheckGridCellButton.h
//  Flogger
//
//  Created by steveli on 12/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issueinfo.h"
#import "MyAlbumInfo.h"
#import "EntityEnumHeader.h"

@interface CheckGridCellButton : UIButton

@property(nonatomic,retain) UIImageView*  checkview;
@property(nonatomic,retain) UIImageView*  selectview;
@property(nonatomic,retain) UIImageView*  playview;
@property(nonatomic,retain) UIView*       playBgView;
@property(nonatomic,retain) UILabel*      videoTimeLable;
@property(nonatomic,assign) BOOL          ischeck;
@property(nonatomic,retain) Issueinfo  *  issueinfo;
@property(nonatomic,retain) MyAlbumInfo  *  albuminfo;
@property (nonatomic, assign) BOOL applyAnimation;

-(BOOL)IsChecked;
-(void)setChecked:(BOOL)flag;
-(NSInteger)getType;
-(void)isVideo:(BOOL)flag;


@end
