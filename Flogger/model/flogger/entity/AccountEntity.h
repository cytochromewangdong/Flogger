#import "BaseEntity.h"
@interface AccountEntity : BaseEntity
	@property (retain)NSString* name;
	@property (retain)NSNumber* type;
	@property (retain)NSNumber* useruid;
	@property (retain)NSString* username;
	@property (retain)NSString* nickname;
	@property (retain)NSString* imageurl;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSString* md5email;
	@property (retain)NSString* password;
	@property (retain)NSString* random;
	@property (retain)NSString* email;
	@property (retain)NSNumber* logintype;
	@property (retain)NSNumber* binding;
	@property (retain)NSString* serverurl;
	@property (retain)NSNumber* emailverified;
	@property (retain)NSString* upperusername;
	@property (retain)NSNumber* usernamehashcode;
	@property (retain)NSString* upperemail;
	@property (retain)NSNumber* emailhashcode;
@end
