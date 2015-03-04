//
//  IssueGroupComServerProxy.h
//  Flogger
//
//  Created by steveli on 17/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "IssueInfoCom.h"
typedef enum
{
    Album_Add = 1,
    Album_Update,
    Album_Delete,
}SetAlbumType;


@class IssueGruopCom; 
@interface IssueGroupComServerProxy : BaseServerProxy

-(void)getAlbumInfo:(IssueGruopCom *)com;
-(void)getAlbumInfoList:(IssueGruopCom *)issueGroupCom;
-(void)addAlbum:(IssueGruopCom*)issueGroupCom;
-(void)deleteAlbum:(IssueGruopCom*)issueGroupCom;
-(void)updateAlbum:(IssueGruopCom*)issueGroupCom;


@end
