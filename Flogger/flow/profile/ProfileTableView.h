//
//  ProfileTableView.h
//  Flogger
//
//  Created by steveli on 20/03/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTableView.h"
@class ProfileViewController;
@interface ProfileTableView : FeedTableView<FloggerActionHandler>
{
    FloggerViewAdpater *_headerView;
    //NSString *_action;
}
//@property(nonatomic,retain)FloggerWebView *profileHeaderWebView; 
@property(nonatomic, retain)SDImageDelegate *profileImageView;

@property(nonatomic, retain) FloggerLayout *headerLayout;
@property(nonatomic, retain) FloggerViewAdpater *headerView;
@property(nonatomic, assign) ProfileViewController *handler; 
@end
