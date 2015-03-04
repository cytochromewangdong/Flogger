#import "BaseEntity.h"
@interface Albuminfo : BaseEntity
	@property (retain)NSNumber* id;
	@property (retain)NSNumber* type;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSNumber* sortno;
	@property (retain)NSString* originalurl;
	@property (retain)NSString* thumbnailurl;
	@property (retain)NSNumber* privacylevel;
	@property (retain)NSNumber* issueid;
	@property (retain)NSNumber* groupid;
	@property (retain)NSString* fileurl;
	@property (retain)NSNumber* birthdate;
@end
