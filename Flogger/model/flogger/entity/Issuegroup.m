#import "Issuegroup.h"
@implementation Issuegroup
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
	@dynamic url;
	-(NSString*) url
	{
		return [self.dataDict valueForKey:@"url"];
	}
	-(void) setUrl:(NSString*) paramUrl
	{
		[self.dataDict setValue: paramUrl forKey:@"url"];
	}
	@dynamic coverid;
	-(NSNumber*) coverid
	{
		return [self.dataDict valueForKey:@"coverid"];
	}
	-(void) setCoverid:(NSNumber*) paramCoverid
	{
		[self.dataDict setValue: paramCoverid forKey:@"coverid"];
	}
	@dynamic sortno;
	-(NSNumber*) sortno
	{
		return [self.dataDict valueForKey:@"sortno"];
	}
	-(void) setSortno:(NSNumber*) paramSortno
	{
		[self.dataDict setValue: paramSortno forKey:@"sortno"];
	}
	@dynamic name;
	-(NSString*) name
	{
		return [self.dataDict valueForKey:@"name"];
	}
	-(void) setName:(NSString*) paramName
	{
		[self.dataDict setValue: paramName forKey:@"name"];
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
