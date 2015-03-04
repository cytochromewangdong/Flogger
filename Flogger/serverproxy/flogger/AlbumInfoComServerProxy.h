//
//  AlbumInfoComServerProxy.h
//  Flogger
//
//  Created by steveli on 29/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "AlbuminfoCom.h"

@interface AlbumInfoComServerProxy : BaseServerProxy
-(void)uploadAlbumInfo:(AlbuminfoCom *)albuminfoCom withData:(NSData *)data;
-(void)moveAlbum:(AlbuminfoCom *)albuminfoCom;
-(void)deleteAlbumInfo:(AlbuminfoCom *)albuminfoCom;
@end
