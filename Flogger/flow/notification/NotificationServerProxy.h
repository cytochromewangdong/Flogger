//
//  NotificationServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"

@class NotificationCom;
@interface NotificationServerProxy : BaseServerProxy

-(void)getNotification:(NotificationCom *)notificationCom;
@end
