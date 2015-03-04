#import "MyAccount.h"
#import "BaseModel.h"
@interface ExternalFriendGroup : BaseModel
	@property (retain)NSString* usersourcename;
	@property (retain)NSNumber* usersource;
	@property (retain)NSMutableArray* externalfriendsList;
@end
