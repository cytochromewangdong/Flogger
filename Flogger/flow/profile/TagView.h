//
//  TagView.h
//  Flogger
//
//  Created by steveli on 25/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagButton.h"

@class TagView;
@protocol TagViewDelegate <NSObject>
-(void)tagviewCellPressed:(id)sender content:(NSString*)content;
-(void)tagviewCellDelete:(id)sender content:(NSString*)content;
@end


@interface TagView : UIView<TagButtonDelegate>{
    NSInteger   _x,_y;
    CGRect      _cellframe;
    NSInteger   _height;
    NSInteger   _count;
    CGFloat     _lastw;
}
@property(nonatomic,retain)UIScrollView  * mainview;
@property(nonatomic,retain)NSMutableArray* datas;
@property(nonatomic,assign)id/*<TagViewDelegate>*/ delegate;
@property(nonatomic,retain)NSString      * content;
@property(nonatomic,assign)BOOL          isshow;


-(void)setTagContent:(NSString*)str;
-(NSString*)getTagContent;
-(void)setTagData:(NSMutableArray*)d;
-(void)reload;
-(void)showdelete;
-(void)hidedelete;
@end
