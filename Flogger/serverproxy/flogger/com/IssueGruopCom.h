#import "MyAlbumInfo.h"
#import "MyIssueGroup.h"
#import "BasePageParameter.h"
@interface IssueGruopCom : BasePageParameter
	@property (retain)NSNumber* id;
	@property (retain)NSNumber* type;
	@property (retain)NSMutableArray* albuminfoList;
	@property (retain)NSNumber* userUID;
	@property (retain)NSNumber* target;
	@property (retain)NSNumber* issueID;
	@property (retain)NSString* coverUrl;
	@property (retain)NSString* groupname;
	@property (retain)NSMutableArray* issuegroupList;
@end
