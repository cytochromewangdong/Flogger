#import "MyIssueInfo.h"
#import "Taglist.h"
#import "BasePageParameter.h"
@interface TagInfoCom : BasePageParameter
	@property (retain)NSNumber* type;
	@property (retain)NSString* content;
	@property (retain)NSNumber* userUID;
	@property (retain)NSNumber* mediaType;
	@property (retain)NSMutableArray* issueInfoList;
	@property (retain)NSMutableArray* taglit;
@end
