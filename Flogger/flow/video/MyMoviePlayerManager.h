//
//  MyMoviePlayerManager.h
//  Flogger
//
//  Created by wyf on 12-8-3.
//  Copyright (c) 2012年 atoato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FeedViewCell.h"

@interface MyMoviePlayerManager : NSObject  <UIAlertViewDelegate>
{
    CGRect viewFrame;
//    BOOL _isClose;
}
@property (nonatomic, retain) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, retain) FeedViewCell *cellView;
//@property (nonatomic, retain) FeedTableView *feedTable;
@property (nonatomic, retain) UIViewController *currentViewController;
//@property (nonatomic, retain) MPMoviePlayerViewController *moviePlayViewController;
@property (nonatomic, retain) UIViewController *moviePlayViewController;

@property (nonatomic) BOOL isEnterFullScreen;
//@property (nonatomic) BOOL isClose;

+(MyMoviePlayerManager *) getMyMoviePlayerManager;
+(void) restoreMyMoviePlayerManager;

//-(void) getMoviePlayer : (CGRect ) playFrame WithURL :(NSURL *) videoURL;
- (void)playMovieFile:(NSURL *)movieFileURL;
- (void)playMovieStream:(NSURL *)movieFileURL;
//- (void)playVideo:(NSURL *) videoURL;
-(void) iniViewFrame : (CGRect) viewFrame;
-(void) closeMovieAction;

@end
