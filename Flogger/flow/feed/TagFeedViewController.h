//
//  TagFeedViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-26.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "FeedGridPageTableView.h"
#import "FeedTableView.h"
#import "TagInfoComServerProxy.h"
#import "Taglist.h"

@interface TagFeedViewController : BaseNetworkViewController
{
    BOOL _isDataChange;
}

@property(nonatomic, retain) TagInfoComServerProxy *photoSp, *videoSp, *tweetSp;

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) FeedGridPageTableView *photoView, *videoView;
@property (nonatomic, retain) FeedTableView *tweetView;

@property (nonatomic, retain) Taglist *taginfo;

-(void)btnTapped:(id)sender;
-(void)addResultlableToTableView:(UITableView *) tableView;
@end
