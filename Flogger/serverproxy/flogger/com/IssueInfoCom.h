#import "MyAccount.h"
#import "IssueinfoBean.h"
#import "Issueinfo.h"
#import "MyIssueInfo.h"
#import "BasePageParameter.h"
@interface IssueInfoCom : BasePageParameter
	@property (retain)NSNumber* type;
	@property (retain)NSNumber* count;
	@property (retain)NSNumber* userMediaCnt;
	@property (retain)NSString* guid;
	@property (retain)NSNumber* userUID;
	@property (retain)MyAccount* account;
	@property (retain)NSNumber* uploadType;
	@property (retain)NSNumber* uploadFileSize;
	@property (retain)NSNumber* mediaType;
	@property (retain)NSString* uploadFileID;
	@property (retain)NSNumber* startSize;
	@property (retain)IssueinfoBean* issueinfo;
	@property (retain)NSNumber* issueId;
	@property (retain)NSMutableArray* issueInfoList;
	@property (retain)NSMutableArray* myIssueInfoList;
	@property (retain)NSMutableArray* issueIdList;
	@property (retain)NSMutableArray* usersourceList;
	@property (retain)NSNumber* singleShare;
	@property (retain)NSMutableArray* myAccountList;
	@property (retain)NSNumber* groupID;
	@property (retain)NSString* originalUrl;
	@property (retain)MyIssueInfo* threadHead;
	@property (retain)NSString* middleUrl;
@end
