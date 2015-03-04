#import "BaseEntity.h"
@interface Pushinfo : BaseEntity
	@property (retain)NSString* language;
	@property (retain)NSNumber* useruid;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSString* devicetoken;
	@property (retain)NSNumber* badgecnt;
	@property (retain)NSNumber* likeflg;
	@property (retain)NSNumber* tagflg;
	@property (retain)NSNumber* followflg;
	@property (retain)NSNumber* commentflg;
	@property (retain)NSNumber* uploadflg;
@end
