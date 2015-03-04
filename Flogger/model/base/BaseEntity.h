#import "BaseModel.h"
@interface BaseEntity : BaseModel
	@property (retain)NSString* platform;
	@property (retain)NSNumber* createdate;
	@property (retain)NSString* createuser;
	@property (retain)NSNumber* modifydate;
	@property (retain)NSString* modifyuser;
	@property (retain)NSString* sqlOrderBy;
@end
