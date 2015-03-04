#import "GeographicalInfo.h"
@implementation GeographicalInfo
	@dynamic name;
	-(NSString*) name
	{
		return [self.dataDict valueForKey:@"name"];
	}
	-(void) setName:(NSString*) paramName
	{
		[self.dataDict setValue: paramName forKey:@"name"];
	}
	@dynamic visinity;
	-(NSString*) visinity
	{
		return [self.dataDict valueForKey:@"visinity"];
	}
	-(void) setVisinity:(NSString*) paramVisinity
	{
		[self.dataDict setValue: paramVisinity forKey:@"visinity"];
	}
	@dynamic lon;
	-(NSNumber*) lon
	{
		return [self.dataDict valueForKey:@"lon"];
	}
	-(void) setLon:(NSNumber*) paramLon
	{
		[self.dataDict setValue: paramLon forKey:@"lon"];
	}
	@dynamic lat;
	-(NSNumber*) lat
	{
		return [self.dataDict valueForKey:@"lat"];
	}
	-(void) setLat:(NSNumber*) paramLat
	{
		[self.dataDict setValue: paramLat forKey:@"lat"];
	}
@end
