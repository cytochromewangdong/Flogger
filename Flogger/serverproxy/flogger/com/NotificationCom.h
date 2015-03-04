#import "ActivityResultEntity.h"
#import "ExternalFriendGroup.h"
#import "BasePageParameter.h"
@interface NotificationCom : BasePageParameter
	@property (retain)NSNumber* userUID;
	@property (retain)NSMutableArray* notificationList;
	@property (retain)NSMutableArray* externalFriendList;
@end
