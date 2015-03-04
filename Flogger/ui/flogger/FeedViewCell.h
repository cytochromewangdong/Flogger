//
//  FeedCell.h
//  Flogger
//
//  Created by jwchen on 12-2-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ShareView.h"
#import "ExternalShareView.h"
#import "EntityEnumHeader.h"

#import "Three20/Three20.h"
#import "FloggerWebView.h"
#import "FloggerWebAdapter.h"
#import "FloggerLayoutAdapter.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "FeedTableView.h"
//#import "MyMovieViewController.h"

#ifndef kFeedTag
#define kFeedTag
#define kTagImageBtn 10000
#define kTagLikeBtn 10001
#define kTagCommentBtn 10002
#define kTagFlagBtn 10003
#define kTagShareBtn 10004
#define kTagProfileBtn 10005
#define kTagDeleteLikeBtn 10006
#define kTagPlayVideo 10007
#define kTagDelete 10008
#define kTagCopyFilter 10009
#define kTagInspire 10010
#define kTagPhotoComment 10011
#define kTagPlayVideoComment 10012
#define kTagMap 10013
#define kTagWriteComment 10014
#define kTagShowFullThread 10015
#define kTagShowLikers 10016
#define kTagAtSomebody 10017
#endif

@class Issueinfo;
@class FeedViewCell;
@protocol FeedViewCellDelegate <NSObject>
-(void)handleAction:(NSInteger)actionType withIssueInfo:(Issueinfo *)issueInfo;
-(void)openTag:(NSString*)tag;
-(FloggerLayout*) getMainlayout;
-(void)setBufferCell:(FeedViewCell *)bufferCell;
@end
@interface FeedViewCell : UITableViewCell<FloggerActionHandler>
{
    Issueinfo *_issueInfo;
}
@property(nonatomic, assign) id<FeedViewCellDelegate> delegate;
@property(nonatomic, retain) Issueinfo *issueInfo;
@property(nonatomic, retain) SDImageDelegate *mainImageView;
@property(nonatomic, retain) SDImageDelegate *profileImageView;
@property(nonatomic, retain) NSString *action;
@property(nonatomic, retain) FloggerViewAdpater *mainview;
@property(nonatomic, retain) NSMutableDictionary *extraParam;
@property(nonatomic) BOOL isPlaying;
@property(nonatomic, retain) MPMoviePlayerController *myMoviePlayer;
//@property(nonatomic, retain) MyMovieViewController *myMovieControler;

-(void) fillDataToCell;
-(void) restoreNormalState;
-(void)setIssueInfo:(Issueinfo *)issueInfo Layout:(FloggerLayout*) layout;
+(CGFloat) tableView:(UITableView *)tableView heightForItem:(Issueinfo *)issueInfo;
+(CGFloat) tableView:(UITableView *)tableView heightForItem:(Issueinfo *)issueInfo webview:(FloggerWebView*) floggerWebView;
+(NSMutableDictionary*)createInvisibleList:(Issueinfo *)issueInfo  ExtraParam:(NSMutableDictionary*) param;
+(NSMutableDictionary *)createParamFromIssueInfo:(Issueinfo *)issueInfo  ExtraParam:(NSMutableDictionary*) param;
+(void) getNormalizeWidth:(float*)tw height:(float*)th;
//-(void)downloadFinished:(SDImageDelegate*)downloader;
//-(void) loadWeb;
//-(void) addMoviePlayer : (NSURL *) videoUrl;
-(void) addMoviePlayer : (NSURL *) videoUrl withBufferPath : (NSString *) bufferFilePath withController : (UIViewController *) controller;
-(void) addMoviePlayer : (NSURL *) videoUrl withBufferPath : (NSString *) bufferFilePath;

//-(void) addMoviePlayer : (NSURL *) videoUrl withBufferPath : (NSString *) bufferFilePath withController : (UIViewController *) controller;
-(BOOL) checkPlayView;
-(void) removeMovInCell;

@end
