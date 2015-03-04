//
//  NotificationViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClPageViewController.h"
#import "UtilityServerProxy.h"
#import "NotificationArrayTableViewCell.h"
#import "FloggerLayoutAdapter.h"
#import "NotificationCom.h"
#import "UtilityCom.h"

typedef enum 
{
    NOTIFICATION_YOU = 1,
    NOTIFICATION_FOLLOWING,
}NotificationType;

@interface NotificationViewController : ClPageViewController<NotificationArrayTableViewCellDelegate>
{
    FloggerViewAdpater *_heightview;
    BOOL _isFirst;
}
@property(nonatomic, retain) UIButton *youBtn, *followingBtn;

@property(nonatomic, retain) NSNumber *startId, *endId;

@property(nonatomic, retain) UtilityServerProxy *usp;

@property(nonatomic, assign) NotificationType notificationType;

@property(nonatomic, assign) BOOL activityLoading;

@property(nonatomic, assign) BOOL notifyLoading;

@property(nonatomic, retain) FloggerLayout *cellLayout;

@property(nonatomic, retain) FloggerViewAdpater * heightview;

@property(nonatomic,assign)BOOL isFollowedChanged;

@property(nonatomic, retain) NSMutableDictionary *currentNotificationCom;

@property(nonatomic, retain) NSMutableDictionary *currentUtilityCom;


-(FloggerLayout*) getMainlayout;

-(void)btnClicked:(id)sender;

-(void)goCurrentProfile:(ActivityResultEntity *)entity;

-(void) viewScrollToTop;
@end
