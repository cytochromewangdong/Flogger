//
//  FavortiesViewController.h
//  Flogger
//
//  Created by steveli on 08/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FavortiesBottomBar.h"
#import "PoupWindowViewController.h"
#import "LikeInfoComServerProxy.h"
#import "ClCheckGridView.h"
#import "ClPageViewController.h"




@interface FavortiesViewController : ClPageViewController<ClCheckGridViewDelegate,FavoritesBottomBarDelegate,PoupWindowDelegate,UIAlertViewDelegate>{
    
    BOOL      _orgflag;
    NSInteger _type;
}
 
@property(nonatomic, assign) ClCheckGridView           *gridview;
@property(nonatomic, retain) PoupWindowViewController  *poupwindow;
//@property(nonatomic, retain) NSMutableArray            *myIssueInfoList;
@property(nonatomic, retain) LikeInfoComServerProxy *dislikeSp;
@property(nonatomic, retain) FavortiesBottomBar        *bottombar;

@end
