#import "BaseEntity.h"
@interface Userlogin : BaseEntity
	@property (retain)NSNumber* useruid;
	@property (retain)NSString* username;
	@property (retain)NSString* nickname;
	@property (retain)NSString* imageurl;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSString* token;
	@property (retain)NSNumber* lon;
	@property (retain)NSNumber* lat;
	@property (retain)NSNumber* lastlogintime;
	@property (retain)NSString* ip;
@end
