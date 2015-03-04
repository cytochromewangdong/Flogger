//
//  ShareServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "ShareCom.h"

@interface ShareServerProxy : BaseServerProxy
-(void)share:(ShareCom *)com;
-(void)inviteFriend:(ShareCom *)com;
@end
