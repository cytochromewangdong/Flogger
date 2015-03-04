#import "BaseEntity.h"
@interface Friendship : BaseEntity
	@property (retain)NSNumber* id;
	@property (retain)NSNumber* useruid;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSNumber* followuseruid;
	@property (retain)NSNumber* followtime;
@end
