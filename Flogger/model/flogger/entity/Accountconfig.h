#import "BaseEntity.h"
@interface Accountconfig : BaseEntity
	@property (retain)NSString* groupid;
	@property (retain)NSNumber* useruid;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSString* hostid;
	@property (retain)NSString* fileserverid;
@end
