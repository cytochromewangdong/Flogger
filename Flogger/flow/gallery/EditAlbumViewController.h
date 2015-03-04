//
//  EditAlbumViewController.h
//  Flogger
//
//  Created by steveli on 06/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "AlbumHeadView.h"
#import "MyIssueGroup.h"


@interface EditAlbumObject : NSObject

@property(nonatomic,retain)MyIssueGroup* myissuegroup;
@property(nonatomic,assign)BOOL          deleteflag;
@property(nonatomic,assign)NSString    * coverurl;
@property(nonatomic, assign) BOOL isFocused;

-(id)init:(MyIssueGroup*)myissuegroup flag:(BOOL)flag;
@end


@interface EditAlbumViewController : BaseTableViewController<UITextFieldDelegate>{
    BOOL      _showkeyboard;
    NSInteger _type;
    NSInteger _deleteindex;
    NSInteger _updateindex;
}


//@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,retain)NSMutableArray  * items_delflag;
@property(nonatomic,retain)AlbumHeadView   * headview;
@property(nonatomic,assign)BOOL            ischange;
@property(nonatomic,retain)NSString        * tempname; 

-(void)setAlbumHeadView:(AlbumHeadView *)hview;
-(void)setAlbum:(NSMutableArray*)albums;

@end
