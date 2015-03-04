//
//  AlbumViewController.h
//  Flogger
//
//  Created by jwchen on 12-1-8.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"
#import "AlbumHeadView.h"
#import "AlbumBottomBar.h"
#import "AlbumInfoComServerProxy.h"
#import "ClPageViewController.h"
#import "ClCheckGridView.h"
#import "PoupWindowViewController.h"
#import "AlbumAddView.h"
#import "PhotoDisplayView.h"
#import "IssueGroupComServerProxy.h"

typedef enum{
    HTTP_GET_ALBUM,
    HTTP_UPLOAD_ALBUMINFO,
    HTTP_DELETE_ALBUMINFO,
    HTTP_SET_COVER
}ALBUMVIEW_HTTP_TYPE;

@protocol AlbumSelectionDelegate <NSObject>
-(void)didSelectedAlbumn:(Albuminfo *)albuminfo;
@end

@interface AlbumViewController : ClPageViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AlbumBottomBarDelegate,AlbumHeadDelegate,ClCheckGridViewDelegate,PoupWindowDelegate,AlbumAddViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    
    NSInteger _httptype;
    long long _groupid;
    long long _masterGroupId;
    BOOL      _ismyself;
}

@property(nonatomic, assign) id selectionDelegate;
@property(nonatomic, assign) BOOL isSelectionMode;

@property (nonatomic,retain)  AlbumBottomBar            * bottombarview;
@property (nonatomic,retain)  ClCheckGridView           * gridview;
@property (nonatomic,retain)  AlbumHeadView             * headview;
@property (nonatomic,assign)  BOOL orgflag;
@property (nonatomic,retain)  NSMutableArray            * albuminfos;
@property (nonatomic, retain) PoupWindowViewController  * poupwindow;
@property (nonatomic,retain)  AlbumInfoComServerProxy   * albumserverproxy;
@property (nonatomic,retain)  MyAccount                 * account; 
@property (nonatomic,retain)  PhotoDisplayView          * photoview;

@property (nonatomic, retain) IssueGroupComServerProxy *albumListSp;

@property (nonatomic, retain) NSMutableDictionary *moreStatusDict;
 
//-(void)setCheckImage:(NSInteger)num;
//-(void)bottomoperator:(NSInteger)tag;
-(void) showHelpView : (NSString *) helpImageURL;

@end
