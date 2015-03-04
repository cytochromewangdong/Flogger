#import "BaseEntity.h"
@interface Feedbackinfo : BaseEntity
	@property (retain)NSNumber* useruid;
	@property (retain)NSString* username;
	@property (retain)NSString* imageurl;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSString* subject;
	@property (retain)NSString* feedback;
	@property (retain)NSNumber* id;
@end
