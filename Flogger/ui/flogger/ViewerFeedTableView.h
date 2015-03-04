//
//  ViewerFeedTableView.h
//  Flogger
//
//  Created by dong wang on 12-4-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FeedTableView.h"

@interface ViewerFeedTableView : FeedTableView
{
    //NSString *_action;
    FloggerViewAdpater *_headerView;
}
//@property(nonatomic,retain)FloggerWebView *viewerHeaderWebView;
//@property(nonatomic,retain)FloggerWebView *viewerShapeWebView;
@property(nonatomic, retain)SDImageDelegate *mainImageView;
@property(nonatomic, retain) FloggerLayout *headerLayout;
@property(nonatomic, retain) FloggerViewAdpater *headerView;
@property(nonatomic, retain)SDImageDelegate *profileImageView;
@property(nonatomic, assign) BOOL showHeader;
@end
