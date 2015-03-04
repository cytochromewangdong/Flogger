//
//  FloggerMenuView.h
//  Flogger
//
//  Created by jwchen on 12-1-20.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "MenuView.h"
#define kMenuBaseTag 10000

#define kFloggerMenuTag 100000

typedef enum
{
    Menu_Search = kMenuBaseTag,
    Menu_Notification,
    Menu_Tweet,
    Menu_Profile,
    Menu_Feed,
    Menu_Find_People,
    Menu_Gallery,
    Menu_Favorites,
    Menu_Setting,
    Menu_Photo,
    Menu_Video
}MenuType;

@class FloggerMenuView;
@protocol FlogMenuViewDelegate <NSObject>
-(void)btnTapped:(MenuType)menuType;
@end

@interface FloggerMenuView : MenuView
{
    NSInteger _count;
}
@property(nonatomic, assign)NSInteger count;
@property(nonatomic, assign) id<FlogMenuViewDelegate> delegate;
@end
