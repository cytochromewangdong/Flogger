#import "AccountEntity.h"
#import "BasePageParameter.h"
@interface FollowerAndFollowCom : BasePageParameter
	@property (retain)NSNumber* userUID;
	@property (retain)NSMutableArray* accountList;
	@property (retain)NSNumber* type;
@end
