#import "ExternalplatformKey.h"
@implementation ExternalplatformKey
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
	}
	@dynamic version;
	-(NSString*) version
	{
		return [self.dataDict valueForKey:@"version"];
	}
	-(void) setVersion:(NSString*) paramVersion
	{
		[self.dataDict setValue: paramVersion forKey:@"version"];
	}
@end
