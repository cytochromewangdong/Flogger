//
//  GeoInfoServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-3-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "GeoInfoCom.h"

@interface GeoInfoServerProxy : BaseServerProxy
-(void)getGeoInfo:(GeoInfoCom *)com;
@end
