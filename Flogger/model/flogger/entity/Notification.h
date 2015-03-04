#import "BaseEntity.h"
@interface Notification : BaseEntity
	@property (retain)NSNumber* useruid;
	@property (retain)NSString* username;
	@property (retain)NSString* nickname;
	@property (retain)NSString* imageurl;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSNumber* targetuseruid;
	@property (retain)NSString* targetusername;
	@property (retain)NSString* targetnickname;
	@property (retain)NSString* targetimageurl;
	@property (retain)NSNumber* actiontype;
	@property (retain)NSNumber* getstatus;
	@property (retain)NSNumber* readstatus;
	@property (retain)NSString* mediaurl;
	@property (retain)NSString* targeturl;
	@property (retain)NSNumber* id;
	@property (retain)NSNumber* source;
@end
