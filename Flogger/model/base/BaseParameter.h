#import "BaseModel.h"
@interface BaseParameter : BaseModel
	@property (retain)NSString* token;
	@property (retain)NSString* mandantory;
	@property (retain)NSString* payload;
	@property (retain)NSNumber* ret;
	@property (retain)NSString* errorMessage;
	@property (retain)NSString* destination;
	@property (retain)NSString* extra;

-(BOOL)succeed;
@end
