//
//  FeedViewerViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "ViewerFeedTableView.h"
#import "Issueinfo.h"

typedef enum
{
    FROMFEED = 1,
    FROMPROFILE = 2,
    FROMOTHER = 3
    
} FloggerViewerMode;

@interface FeedViewerViewController : BaseNetworkViewController
{
    BOOL _isDataChange;
}
@property(nonatomic, retain) ViewerFeedTableView *feedView;
@property(nonatomic, retain) Issueinfo *issueInfo;
@property(nonatomic, assign) FloggerViewerMode viewerMode;
@property(nonatomic, assign) BOOL showHeader;
@property(nonatomic, retain) NSMutableArray *issueListArray;
-(void)comBtnClicked:(id)sender;
@end
