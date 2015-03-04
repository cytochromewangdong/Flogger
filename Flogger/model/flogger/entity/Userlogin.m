#import "Userlogin.h"
@implementation Userlogin
	@dynamic useruid;
	-(NSNumber*) useruid
	{
		return [self.dataDict valueForKey:@"useruid"];
	}
	-(void) setUseruid:(NSNumber*) paramUseruid
	{
		[self.dataDict setValue: paramUseruid forKey:@"useruid"];
	}
	@dynamic username;
	-(NSString*) username
	{
		return [self.dataDict valueForKey:@"username"];
	}
	-(void) setUsername:(NSString*) paramUsername
	{
		[self.dataDict setValue: paramUsername forKey:@"username"];
	}
	@dynamic nickname;
	-(NSString*) nickname
	{
		return [self.dataDict valueForKey:@"nickname"];
	}
	-(void) setNickname:(NSString*) paramNickname
	{
		[self.dataDict setValue: paramNickname forKey:@"nickname"];
	}
	@dynamic imageurl;
	-(NSString*) imageurl
	{
		return [self.dataDict valueForKey:@"imageurl"];
	}
	-(void) setImageurl:(NSString*) paramImageurl
	{
		[self.dataDict setValue: paramImageurl forKey:@"imageurl"];
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
	@dynamic lastlogintime;
	-(NSNumber*) lastlogintime
	{
		return [self.dataDict valueForKey:@"lastlogintime"];
	}
	-(void) setLastlogintime:(NSNumber*) paramLastlogintime
	{
		[self.dataDict setValue: paramLastlogintime forKey:@"lastlogintime"];
	}
	@dynamic ip;
	-(NSString*) ip
	{
		return [self.dataDict valueForKey:@"ip"];
	}
	-(void) setIp:(NSString*) paramIp
	{
		[self.dataDict setValue: paramIp forKey:@"ip"];
	}
@end
