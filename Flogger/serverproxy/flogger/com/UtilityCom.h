#import "ActivityResultEntity.h"
#import "BasePageParameter.h"
@interface UtilityCom : BasePageParameter
	@property (retain)NSNumber* type;
	@property (retain)NSNumber* userUID;
	@property (retain)NSMutableArray* latestActivities;
@end
