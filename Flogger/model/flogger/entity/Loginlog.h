#import "BaseEntity.h"
@interface Loginlog : BaseEntity
	@property (retain)NSNumber* useruid;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSString* token;
	@property (retain)NSString* loginip;
	@property (retain)NSNumber* lon;
	@property (retain)NSNumber* lat;
	@property (retain)NSNumber* id;
	@property (retain)NSNumber* type;
@end
