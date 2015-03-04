//
//  AlbumCellButton.m
//  Flogger
//
//  Created by jwchen on 12-2-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "AlbumCellButton.h"

@interface AlbumCellButton(){
@private
    UIImageView*  checkview;
    UIImageView*  selectview;
    BOOL          ischeck;
}
@end



@implementation AlbumCellButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selectview = [[[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)]autorelease];
        
        [selectview setImage:[UIImage imageNamed: SNS_GALLERY_SELECTION]];
        selectview.hidden = TRUE;
        [self addSubview:selectview];
        
        checkview = [[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 17,frame.size.height - 17,17,17)]autorelease];
        [checkview setImage:[UIImage imageNamed: SNS_GALLERY_SELECTION_CHECK]];
        checkview.hidden = TRUE;

        [self addSubview:checkview];
        
        ischeck = FALSE;
    }
    return self;
}

-(BOOL)IsChecked
{
    return ischeck;
}
-(void)setChecked:(BOOL)flag
{
    ischeck = flag;
    [checkview setHidden:!ischeck];
    [selectview setHidden:!ischeck];
}

-(void)dealloc
{
    RELEASE_SAFELY(checkview);
    RELEASE_SAFELY(selectview);
}

@end
