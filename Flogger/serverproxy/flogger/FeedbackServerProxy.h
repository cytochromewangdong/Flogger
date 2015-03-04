//
//  FeedbackServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-3-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "FeedbackCom.h"

@interface FeedbackServerProxy : BaseServerProxy
-(void)addFeedback:(FeedbackCom *)com;
@end
