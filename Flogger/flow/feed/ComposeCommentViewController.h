//
//  ComposeCommentViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "Issueinfo.h"
#import "IssueInfoCom.h"
#import "FloatViewControllerProtocol.h"
#import "FloggerWebAdapter.h"
#import "SingleShareCell.h"
#import <MapKit/MapKit.h>

typedef enum 
{
    MEDIA_PHOTO,
    MEDIA_VIDEO
}MediaType;


@protocol ComposeResultDelegate<NSObject>
    
-(void)composeResultDoneWithIssueInfo:(Issueinfo*)info;
-(void)composeResultDoneWithIssueInfoCom:(IssueInfoCom*)infocom;

@end

@interface ComposeCommentViewController : BaseNetworkViewController<UIActionSheetDelegate, FloatViewControllerProtocol, UITextViewDelegate,SingleShareCellDelegate,UITableViewDataSource,UITableViewDelegate,MKReverseGeocoderDelegate>

@property(nonatomic, retain) UIView *actionView;
@property(nonatomic, retain) UILabel *countLabel, *geoLabel;
@property(nonatomic, retain) Issueinfo *issueinfo;
@property(nonatomic) NSInteger groupid;
@property(nonatomic, assign) id<ComposeResultDelegate> delegate;

@property (nonatomic, retain) FloggerWebView *composeView;

@property (nonatomic, retain) UITableView *tableV;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;

@property (nonatomic, assign) BOOL isCamera;
//todo adjust
-(void) setInfoFromCamera :(NSDictionary *) info;


-(void)showCaptureMedia:(MediaType)mediaType;;

-(void)cameraTapped:(id)sender;
-(void)atBtnTapped:(id)sender;
-(void)topicBtnTapped:(id)sender;
-(void)geoBtnTapped:(id)sender;

@end
