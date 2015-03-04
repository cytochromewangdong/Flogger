#import "Likeinfo.h"
@implementation Likeinfo
	@dynamic parentid;
	-(NSNumber*) parentid
	{
		return [self.dataDict valueForKey:@"parentid"];
	}
	-(void) setParentid:(NSNumber*) paramParentid
	{
		[self.dataDict setValue: paramParentid forKey:@"parentid"];
	}
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
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
	}
@end
