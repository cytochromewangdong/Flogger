#import "Loginlog.h"
@implementation Loginlog
	@dynamic useruid;
	-(NSNumber*) useruid
	{
		return [self.dataDict valueForKey:@"useruid"];
	}
	-(void) setUseruid:(NSNumber*) paramUseruid
	{
		[self.dataDict setValue: paramUseruid forKey:@"useruid"];
	}
	@dynamic delflg;
	-(NSNumber*) delflg
	{
		return [self.dataDict valueForKey:@"delflg"];
	}
	-(void) setDelflg:(NSNumber*) paramDelflg
	{
		[self.dataDict setValue: paramDelflg forKey:@"delflg"];
	}
	@dynamic platform;
	-(NSString*) platform
	{
		return [self.dataDict valueForKey:@"platform"];
	}
	-(void) setPlatform:(NSString*) paramPlatform
	{
		[self.dataDict setValue: paramPlatform forKey:@"platform"];
	}
	@dynamic token;
	-(NSString*) token
	{
		return [self.dataDict valueForKey:@"token"];
	}
	-(void) setToken:(NSString*) paramToken
	{
		[self.dataDict setValue: paramToken forKey:@"token"];
	}
	@dynamic loginip;
	-(NSString*) loginip
	{
		return [self.dataDict valueForKey:@"loginip"];
	}
	-(void) setLoginip:(NSString*) paramLoginip
	{
		[self.dataDict setValue: paramLoginip forKey:@"loginip"];
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
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
	}
	@dynamic type;
	-(NSNumber*) type
	{
		return [self.dataDict valueForKey:@"type"];
	}
	-(void) setType:(NSNumber*) paramType
	{
		[self.dataDict setValue: paramType forKey:@"type"];
	}
@end
