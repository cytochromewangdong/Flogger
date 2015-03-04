//
//  CommentPostViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "Issueinfo.h"
#import "IssueInfoCom.h"
#import "FloatViewControllerProtocol.h"
#import <MapKit/MapKit.h>
#import "UploadServerProxy.h"
#import "PhotoDisplayViewController.h"
//#import "Uifilter.h"

typedef enum 
{
    MEDIA_PHOTO_COM,
    MEDIA_VIDEO_COM
}MediaTypeCOM;

typedef enum 
{
    TWEETMODE,
    POSTMODE,
    COMMENTMODE
    
}COMPOSEMODE;


@protocol ComposePostResultDelegate<NSObject>

-(void)composePostResultDoneWithIssueInfo:(Issueinfo*)info;
-(void)composePostResultDoneWithIssueInfoCom:(IssueInfoCom*)infocom;

@end

@interface CommentPostViewController : BaseNetworkViewController<UIActionSheetDelegate, FloatViewControllerProtocol,MKReverseGeocoderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    BOOL isImportMedia;
}

@property(nonatomic, retain)  UITextView *messageTV;
@property(nonatomic, retain)  UIView *actionView;
@property(nonatomic, retain)  UILabel *countLabel, *geoLabel;
@property(nonatomic, retain) Issueinfo *issueinfo;
@property(nonatomic) NSInteger groupid;
@property(nonatomic, retain) NSString* uploadFileID;
@property(nonatomic, assign) id<ComposePostResultDelegate> delegate;
#ifdef __IPHONE_5_0

#else
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
#endif
@property(nonatomic, assign) COMPOSEMODE composeMode;
@property(nonatomic, retain) UIButton *mediaContent;
@property(nonatomic, retain) UIButton *cameraBtn;
@property(nonatomic, retain) UIView *composeView;

@property(nonatomic, retain) NSDictionary *cameraInfo;
@property(nonatomic, retain) AVPlayerLayer *playerLayer;
@property(nonatomic, retain) UIButton *playBtn;
@property(nonatomic, retain) NSDictionary *paraDictonary;

@property(nonatomic, retain) UploadServerProxy *preUploadProxy;

@property(nonatomic, retain) PhotoDisplayViewController *displayVc;

-(void)showCaptureMedia:(MediaTypeCOM)mediaType;



//-(void) setInfoFromCamera :(NSDictionary *) info;

-(void)cameraTapped:(id)sender;
-(void)atBtnTapped:(id)sender;
-(void)topicBtnTapped:(id)sender;
-(void)geoBtnTapped:(id)sender;

@end
