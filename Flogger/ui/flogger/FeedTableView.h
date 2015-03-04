//
//  ClTableView.h
//  Flogger
//
//  Created by jwchen on 12-2-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClPageTableView.h"
#import "Issueinfo.h"
#import "FeedViewCell.h"

#import "LikeInfoComServerProxy.h"
#import "ReportServerProxy.h"
#import "BaseViewController.h"
#import "FloggerLayoutAdapter.h"
#import "IssueInfoComServerProxy.h"
#import "IssueInfoCom.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MyMovieViewController.h"

@protocol FeedTableViewDelegate <NSObject>
-(void) deleteIssueInfo : (Issueinfo *) com;
@end


@interface FeedTableView : ClPageTableView <FeedViewCellDelegate,MyMovieViewControllerDelegate, UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSString* _action;
    FloggerViewAdpater *_heightview;
    //BOOL _isFilling;
}
@property(nonatomic, assign) BaseViewController* feedTableDelegate;
//@property(nonatomic, assign) Fee
@property(nonatomic, assign) BOOL firstLoaded;
@property(nonatomic, retain) ReportServerProxy *reportSp;
@property(nonatomic, retain) LikeInfoComServerProxy *sp;
@property(nonatomic, retain) NSString *action;
@property(nonatomic, retain) FloggerLayout *cellLayout;
@property(nonatomic, readonly) FloggerViewAdpater *heightview;
@property(nonatomic, retain) IssueInfoComServerProxy *deleteInfoSp;
@property(nonatomic, retain) MPMoviePlayerController *videoPlayerViewController;
@property(nonatomic, retain) MyMovieViewController *customMovieController;
@property(nonatomic, retain) FeedViewCell *bufferCell;
@property(nonatomic, assign) BOOL isNeedRotate;
@end
@interface MyMovieHandler : NSObject 
+(MyMovieHandler *)sharedInstance;
+(void)purgeSharedInstance;

@end
