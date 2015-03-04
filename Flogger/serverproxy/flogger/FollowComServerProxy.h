//
//  FollowComServerProxy.h
//  Flogger
//
//  Created by steveli on 27/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"


@class FollowCom;
@interface FollowComServerProxy : BaseServerProxy

-(void) follow:(FollowCom *)com;
-(void) unfollow:(FollowCom *)com;
@end
