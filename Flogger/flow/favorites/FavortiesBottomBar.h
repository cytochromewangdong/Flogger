//
//  FavortiesBottomBar.h
//  Flogger
//
//  Created by steveli on 08/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    BOTTOM_SHARE = 1,
    BOTTOM_UNLIKE
    
}FavottiesBottomBarType;


@class FavortiesBottomBar;
@protocol FavoritesBottomBarDelegate <NSObject>

-(void)sharecommand;
-(void)unlikecommand;

@end


@interface FavortiesBottomBar : UIView{
}

@property(nonatomic, retain) UIButton* sharebtn;
@property(nonatomic, retain) UIButton* unlikebtn;
@property(nonatomic, retain) UIImageView*  bgview;
@property(nonatomic, assign) id/*<FavoritesBottomBarDelegate>*/ bottombardelegate;

@end
