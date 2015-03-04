//
//  UtilityServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-2-27.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "UtilityCom.h"

@interface UtilityServerProxy : BaseServerProxy

-(void)getLatestActivities:(UtilityCom *)com;
@end
