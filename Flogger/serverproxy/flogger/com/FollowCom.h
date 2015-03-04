#import "Friendrequest.h"
#import "BasePageParameter.h"
@interface FollowCom : BasePageParameter
	@property (retain)NSNumber* requestUserUID;
	@property (retain)NSNumber* requestedUserUID;
	@property (retain)NSNumber* requestID;
	@property (retain)NSMutableArray* friendrequestList;
	@property (retain)NSString* description;
@end
