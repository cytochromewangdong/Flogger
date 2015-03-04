#import "BaseEntity.h"
@interface Externalaccount : BaseEntity
	@property (retain)NSNumber* useruid;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSNumber* usersource;
	@property (retain)NSString* usersourcename;
	@property (retain)NSString* externaluid;
	@property (retain)NSString* accesstoken;
	@property (retain)NSString* tokensecret;
	@property (retain)NSString* refreshtoken;
	@property (retain)NSNumber* sharestatus;
	@property (retain)NSNumber* expiretime;
@end
