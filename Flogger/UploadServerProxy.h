//
//  UploadServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-2-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "IssueInfoCom.h"

@interface UploadServerProxy : BaseServerProxy
-(void)uploadIssue:(IssueInfoCom *)issueInfoCom withData:(NSData *)data;
@end
