//
//  ClCheckGridView.h
//  Flogger
//
//  Created by steveli on 09/03/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "ClGridPageTableView.h"
#import "Issueinfo.h"
#import "Albuminfo.h"
#import "CheckGridViewCell.h"


#define kCheckGrid_IssueInfo_Type 1
#define kCheckGrid_AlbumInfo_Type 2


@class ClCheckGridView;
@protocol ClCheckGridViewDelegate <NSObject>

-(void)checkgridSelectItem:(id)item;
-(void)checkgridSelectNull;
-(void)checkgridUnSelectItem:(id)item;

@optional
-(void)checkgridSelectIssueInfo:(id)info;
-(void)checkgridSelectAlbuminfo:(id)info;
@end

@interface ClCheckGridView : ClGridPageTableView<CheckGridViewCellDelegate>{
    NSInteger _selectnum;
    NSInteger _photoselectnum;
    NSInteger _videoselectnum;
    BOOL      _selectflag;
    NSInteger _count;
}


@property(nonatomic,retain) NSMutableArray               *dataarrys, *selectcells;
@property(nonatomic,assign) id/*<ClCheckGridViewDelegate>*/  checkGridDelegate;
@property(nonatomic,assign) NSInteger                    type;
@property(nonatomic,assign) NSInteger bottomOffset;

-(void)addIssueInfo:(NSMutableArray*)dataarrays;
-(void)addAlbumInfo:(NSMutableArray*)dataarrays;

-(void)removeSelect;
-(void)setSelectEnable:(BOOL)flag;
-(NSInteger)getselectnum;
-(NSInteger)getVideoSelectNum;
-(NSInteger)getPhotoSelectNum;

-(Albuminfo*)getSelectAlbumInfo:(NSInteger)index;
-(Issueinfo*)getSelectIssueInfo:(NSInteger)index;

-(void)clear;


@end
