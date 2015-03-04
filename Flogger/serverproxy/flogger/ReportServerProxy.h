//
//  ReportServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-2-27.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "ReportCom.h"

@interface ReportServerProxy : BaseServerProxy

-(void)addReport:(ReportCom *)com;
@end
