//
//  FeedServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-1-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
//#import "FeedList.h"

@class IssueInfoCom;
@interface IssueInfoComServerProxy : BaseServerProxy

-(void)getPopularMedia:(IssueInfoCom *)issueInfoCom;
-(void)getResponseIssueList:(IssueInfoCom *)issueInfoCom;
-(void)getThread:(IssueInfoCom *)issueInfoCom;
-(void)getIssueList:(IssueInfoCom *)issueInfoCom;
-(void)getLikeList:(IssueInfoCom *)issueInfoCom;
-(void)getPopularUserMedia:(IssueInfoCom *)issueInfoCom;
-(void)getAccountProfile:(IssueInfoCom *)issueInfoCom;
-(void)deleteIssueInfo : (IssueInfoCom *)issueInfoCom;
-(void)viewLikersList:(IssueInfoCom*)com;
@end
