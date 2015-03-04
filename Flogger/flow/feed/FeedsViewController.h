//
//  FeedsViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "FeedTableView.h"
#import "FeedGridPageView.h"
#import "IssueInfoComServerProxy.h"
#import "FloggerPopMenuView.h"
#import "EntityEnumHeader.h"

@interface FeedsViewController : BaseNetworkViewController <FloggerPopMenuViewDelegate>
{
    @private
    FeedTableView *_followView;
    FeedGridPageView *_popularView;
    FeedGridPageView *_featureView;
    
//    UIActivityIndicatorView *_followIndicatorView;
//    UIActivityIndicatorView *_popularIndicatorView;
//    UIActivityIndicatorView *_featureIndicatorView;
    
    IssueInfoComServerProxy *_followSp;
    IssueInfoComServerProxy *_popularSp;
    IssueInfoComServerProxy *_featurePhotoSp;
    IssueInfoComServerProxy *_featureVideoSp;
    
    BOOL _isLoadingFollow, _isLoadingPopular, _isLoadingFeaturePhoto, _isLoadingFeatureVideo;
    
    FloggerPopMenuView *_popMenuView;
    
    BOOL _isDataChange;
    BOOL _isScrollTop;
    int currentDataRow;
//    NSIndexPath
//    int _currentRow;
}

//@property(nonatomic, retain) UtilityServerProxy *utilitySp;
@property(nonatomic, retain) UIView *contentView;
@property(nonatomic, assign) IssueInfoCategory issueinfoCategory;
@property(nonatomic, assign) BOOL isLoadingFollow, isLoadingPopular, isLoadingFeaturePhoto, isLoadingFeatureVideo;
-(void)btnTapped:(id)sender;
-(void) viewScrollToTop;
-(void) tabBarClickScrollToTop;
@end
