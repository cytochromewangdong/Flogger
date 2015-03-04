//
//  AlbumAddView.h
//  Flogger
//
//  Created by jwchen on 12-2-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumInfoComServerProxy.h"
#import "ClTableViewController.h"
#import "AlbumHeadView.h"


@class AlbumAddView;
@protocol AlbumAddViewDelegate <NSObject>

-(void)albumMove:(BOOL)state srcgroupid:(long long)srcgroupid desgroupid:(long long)desgroupid;

@end


@interface AlbumAddView : BaseNetworkViewController <ClTableViewDataSource,ClTableViewDelegate,UIAlertViewDelegate>{
    long long _desgroupid;
}

@property (nonatomic,retain) AlbumInfoComServerProxy * albumserverproxy;
@property (nonatomic,retain) NSMutableArray          * items;
@property (nonatomic,retain) NSMutableArray          * albumlist;
@property(nonatomic,retain)  AlbumHeadView           * headview;
@property(nonatomic,assign)  long long               groupid;
@property(nonatomic,assign)  id                      delegate;
@property(nonatomic, assign) BOOL isMove;
@property(nonatomic, retain) ClTableView *tableView;

-(void)setAlbum:(NSMutableArray*)albums groupid:(long long)groupid;



@end
