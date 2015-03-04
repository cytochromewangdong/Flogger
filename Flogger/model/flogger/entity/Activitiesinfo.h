#import "BaseEntity.h"
@interface Activitiesinfo : BaseEntity
	@property (retain)NSNumber* id;
	@property (retain)NSNumber* actiontype;
	@property (retain)NSNumber* actionid;
	@property (retain)NSNumber* useruid;
	@property (retain)NSString* username;
	@property (retain)NSString* nickname;
	@property (retain)NSString* imageurl;
	@property (retain)NSNumber* targetuseruid;
	@property (retain)NSString* targetusername;
	@property (retain)NSString* targetnickname;
	@property (retain)NSString* targetimageurl;
	@property (retain)NSNumber* status;
	@property (retain)NSNumber* parenttype;
	@property (retain)NSNumber* parentid;
	@property (retain)NSNumber* parentmediaheight;
	@property (retain)NSNumber* parentmediawidth;
	@property (retain)NSNumber* mediaheight;
	@property (retain)NSNumber* mediawidth;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSString* text;
@end
