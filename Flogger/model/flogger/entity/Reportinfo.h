#import "BaseEntity.h"
@interface Reportinfo : BaseEntity
	@property (retain)NSNumber* id;
	@property (retain)NSNumber* type;
	@property (retain)NSString* content;
	@property (retain)NSNumber* useruid;
	@property (retain)NSString* username;
	@property (retain)NSString* nickname;
	@property (retain)NSString* imageurl;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSNumber* issueid;
@end
