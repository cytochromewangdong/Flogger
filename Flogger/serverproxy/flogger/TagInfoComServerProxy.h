//
//  TagInfoComServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-2-22.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "TagInfoCom.h"
@interface TagInfoComServerProxy : BaseServerProxy

-(void)getTaglist:(TagInfoCom *)tagcom;
-(void)getIssueListByTag:(TagInfoCom *)tagcom;
@end
