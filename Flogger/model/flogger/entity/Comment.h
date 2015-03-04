#import "BaseEntity.h"
@interface Comment : BaseEntity
	@property (retain)NSString* parentid;
	@property (retain)NSString* targetid;
	@property (retain)NSNumber* delflg;
	@property (retain)NSNumber* replycatagory;
	@property (retain)NSNumber* respondcatagory;
	@property (retain)NSString* commentid;
	@property (retain)NSNumber* likeit;
	@property (retain)NSString* id;
	@property (retain)NSString* text;
@end
