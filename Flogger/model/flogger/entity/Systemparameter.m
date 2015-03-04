#import "Systemparameter.h"
@implementation Systemparameter
	@dynamic property;
	-(NSNumber*) property
	{
		return [self.dataDict valueForKey:@"property"];
	}
	-(void) setProperty:(NSNumber*) paramProperty
	{
		[self.dataDict setValue: paramProperty forKey:@"property"];
	}
	@dynamic value;
	-(NSString*) value
	{
		return [self.dataDict valueForKey:@"value"];
	}
	-(void) setValue:(NSString*) paramValue
	{
		[self.dataDict setValue: paramValue forKey:@"value"];
	}
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
	}
	@dynamic keyword;
	-(NSString*) keyword
	{
		return [self.dataDict valueForKey:@"keyword"];
	}
	-(void) setKeyword:(NSString*) paramKeyword
	{
		[self.dataDict setValue: paramKeyword forKey:@"keyword"];
	}
@end
