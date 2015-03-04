#import "BaseModel.h"
@interface GeographicalInfo : BaseModel
	@property (retain)NSString* name;
	@property (retain)NSString* visinity;
	@property (retain)NSNumber* lon;
	@property (retain)NSNumber* lat;
@end
