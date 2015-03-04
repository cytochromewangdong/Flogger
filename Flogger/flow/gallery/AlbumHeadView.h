//
//  AlbumHeadView.h
//  Flogger
//
//  Created by jwchen on 12-1-8.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyIssueGroup.h"

@class AlbumHeadView;
@protocol AlbumHeadDelegate <NSObject>
-(void)albumHeadDidSelectItem:(id)item index:(NSInteger)index;
@end

@interface AlbumHeadView : UIView{
    //NSMutableArray* items;
    NSInteger       _count;
    //UIImageView*  backview;
    //UIScrollView* mainview;
    NSInteger       _x, _y;
    CGRect          _cellframe;
    NSInteger       _width;
    NSInteger count;
    NSInteger       _lastid;
}

@property(nonatomic, retain) NSMutableArray  * items;
//@property(nonatomic, retain) NSMutableArray  * coverurlitems;
@property(nonatomic, retain) UIImageView     * backview;
@property(nonatomic, retain) UIScrollView    * mainview;
@property(nonatomic, retain) UIButton        * lastbtn;
@property(nonatomic, assign) NSInteger lastid;
@property(nonatomic, retain) id              delegate;
@property (nonatomic,retain) NSMutableArray  * albuminfos;
@property(nonatomic, assign) NSInteger selectedId;


-(void)setItemCoverImg:(MyIssueGroup*)group imgurl:(NSString*)imgurl;
-(void)addItem:(UIImage*)img name:(NSString*)name;
-(void)addItem:(MyIssueGroup*)group imgurl:(NSString*)imgurl;
-(void)addAlbumList:(NSMutableArray*)array;
-(void)deleteAlbumList:(NSInteger)index;
-(void)deleteAlbumInfo:(Albuminfo*)info groupid:(long long)groupid;

-(NSMutableArray*)getItems;
-(void)reloadData;
@end
