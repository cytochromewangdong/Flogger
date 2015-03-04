#import "Mandantory.h"
@implementation Mandantory
	@dynamic platform;
	-(NSString*) platform
	{
		return [self.dataDict valueForKey:@"platform"];
	}
	-(void) setPlatform:(NSString*) paramPlatform
	{
		[self.dataDict setValue: paramPlatform forKey:@"platform"];
	}
	@dynamic lon;
	-(NSString*) lon
	{
		return [self.dataDict valueForKey:@"lon"];
	}
	-(void) setLon:(NSString*) paramLon
	{
		[self.dataDict setValue: paramLon forKey:@"lon"];
	}
	@dynamic lat;
	-(NSString*) lat
	{
		return [self.dataDict valueForKey:@"lat"];
	}
	-(void) setLat:(NSString*) paramLat
	{
		[self.dataDict setValue: paramLat forKey:@"lat"];
	}
	@dynamic phoneNumber;
	-(NSString*) phoneNumber
	{
		return [self.dataDict valueForKey:@"phoneNumber"];
	}
	-(void) setPhoneNumber:(NSString*) paramPhoneNumber
	{
		[self.dataDict setValue: paramPhoneNumber forKey:@"phoneNumber"];
	}
	@dynamic buildNumber;
	-(NSString*) buildNumber
	{
		return [self.dataDict valueForKey:@"buildNumber"];
	}
	-(void) setBuildNumber:(NSString*) paramBuildNumber
	{
		[self.dataDict setValue: paramBuildNumber forKey:@"buildNumber"];
	}
	@dynamic gpsTpye;
	-(NSString*) gpsTpye
	{
		return [self.dataDict valueForKey:@"gpsTpye"];
	}
	-(void) setGpsTpye:(NSString*) paramGpsTpye
	{
		[self.dataDict setValue: paramGpsTpye forKey:@"gpsTpye"];
	}
	@dynamic audioFormat;
	-(NSString*) audioFormat
	{
		return [self.dataDict valueForKey:@"audioFormat"];
	}
	-(void) setAudioFormat:(NSString*) paramAudioFormat
	{
		[self.dataDict setValue: paramAudioFormat forKey:@"audioFormat"];
	}
	@dynamic device;
	-(NSString*) device
	{
		return [self.dataDict valueForKey:@"device"];
	}
	-(void) setDevice:(NSString*) paramDevice
	{
		[self.dataDict setValue: paramDevice forKey:@"device"];
	}
	@dynamic screenHeight;
	-(NSString*) screenHeight
	{
		return [self.dataDict valueForKey:@"screenHeight"];
	}
	-(void) setScreenHeight:(NSString*) paramScreenHeight
	{
		[self.dataDict setValue: paramScreenHeight forKey:@"screenHeight"];
	}
	@dynamic screenWidth;
	-(NSString*) screenWidth
	{
		return [self.dataDict valueForKey:@"screenWidth"];
	}
	-(void) setScreenWidth:(NSString*) paramScreenWidth
	{
		[self.dataDict setValue: paramScreenWidth forKey:@"screenWidth"];
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
