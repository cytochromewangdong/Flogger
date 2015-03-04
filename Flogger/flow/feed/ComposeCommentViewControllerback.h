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

typedef enum 
{
    MEDIA_PHOTO,
    MEDIA_VIDEO
}MediaType;


@protocol ComposeResultDelegate<NSObject>
    
-(void)composeResultDoneWithIssueInfo:(Issueinfo*)info;
-(void)composeResultDoneWithIssueInfoCom:(IssueInfoCom*)infocom;

@end

@interface ComposeCommentViewController : BaseNetworkViewController<UIActionSheetDelegate, FloatViewControllerProtocol, UITextViewDelegate>

@property(nonatomic, retain) Issueinfo *issueinfo;
@property(nonatomic) NSInteger groupid;
@property(nonatomic, assign) id<ComposeResultDelegate> delegate;

@property (nonatomic, retain) FloggerWebView *composeView;

-(void)showCaptureMedia:(MediaType)mediaType;;

-(void)cameraTapped:(id)sender;
-(void)atBtnTapped:(id)sender;
-(void)topicBtnTapped:(id)sender;
-(void)geoBtnTapped:(id)sender;

@end
