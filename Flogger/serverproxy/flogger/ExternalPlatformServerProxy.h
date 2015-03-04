//
//  ExternalPlatformServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-2-25.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "ExternalPlatformCom.h"

@interface ExternalPlatformServerProxy : BaseServerProxy

-(void)getExternalPlatform:(ExternalPlatformCom *)com;
@end
