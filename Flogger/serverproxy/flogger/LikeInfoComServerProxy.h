//
//  LikeInfoComServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-2-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
@class LikeInfoCom;
@interface LikeInfoComServerProxy : BaseServerProxy
-(void)addLike:(LikeInfoCom *)likeInfoCom;
-(void)deleteLikeIssue:(LikeInfoCom *)likeInfoCom;
@end
