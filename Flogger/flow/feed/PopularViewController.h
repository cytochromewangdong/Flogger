//
//  PopularViewController.h
//  Flogger
//
//  Created by wyf on 12-4-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
#import "FeedTableView.h"
#import "FeedGridPageView.h"
#import "IssueInfoComServerProxy.h"

@interface PopularViewController: BaseNetworkViewController    
{
    UIButton *popularBtn;
    UIButton *featurebtn;
@private
    FeedGridPageView *_popularView;
    FeedGridPageView *_featureView;
    FeedTableView *_shoutView;
    
//    UIActivityIndicatorView *_popularIndicatorView;
//    UIActivityIndicatorView *_featureIndicatorView;
    
    IssueInfoComServerProxy *_popularSp;
    IssueInfoComServerProxy *_featurePhotoSp;
    IssueInfoComServerProxy *_featureVideoSp;
    BOOL _isLoadingPopular, _isLoadingFeaturePhoto, _isLoadingFeatureVideo;
}

//@property(nonatomic, retain) UtilityServerProxy *utilitySp;
@property(nonatomic, retain) UIView *contentView;
@property(nonatomic, assign) IssueInfoCategory issueinfoCategory;
@property(nonatomic, assign) BOOL isLoadingPopular, isLoadingFeaturePhoto, isLoadingFeatureVideo;
@property(nonatomic, retain) UIButton *popularBtn;
@property(nonatomic, retain) UIButton *featurebtn;
-(void)btnTapped:(id)sender;
-(void) viewScrollToTop;

@end
