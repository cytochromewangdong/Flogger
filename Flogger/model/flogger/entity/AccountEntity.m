#import "AccountEntity.h"
@implementation AccountEntity
	@dynamic name;
	-(NSString*) name
	{
		return [self.dataDict valueForKey:@"name"];
	}
	-(void) setName:(NSString*) paramName
	{
		[self.dataDict setValue: paramName forKey:@"name"];
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
	@dynamic md5email;
	-(NSString*) md5email
	{
		return [self.dataDict valueForKey:@"md5email"];
	}
	-(void) setMd5email:(NSString*) paramMd5email
	{
		[self.dataDict setValue: paramMd5email forKey:@"md5email"];
	}
	@dynamic password;
	-(NSString*) password
	{
		return [self.dataDict valueForKey:@"password"];
	}
	-(void) setPassword:(NSString*) paramPassword
	{
		[self.dataDict setValue: paramPassword forKey:@"password"];
	}
	@dynamic random;
	-(NSString*) random
	{
		return [self.dataDict valueForKey:@"random"];
	}
	-(void) setRandom:(NSString*) paramRandom
	{
		[self.dataDict setValue: paramRandom forKey:@"random"];
	}
	@dynamic email;
	-(NSString*) email
	{
		return [self.dataDict valueForKey:@"email"];
	}
	-(void) setEmail:(NSString*) paramEmail
	{
		[self.dataDict setValue: paramEmail forKey:@"email"];
	}
	@dynamic logintype;
	-(NSNumber*) logintype
	{
		return [self.dataDict valueForKey:@"logintype"];
	}
	-(void) setLogintype:(NSNumber*) paramLogintype
	{
		[self.dataDict setValue: paramLogintype forKey:@"logintype"];
	}
	@dynamic binding;
	-(NSNumber*) binding
	{
		return [self.dataDict valueForKey:@"binding"];
	}
	-(void) setBinding:(NSNumber*) paramBinding
	{
		[self.dataDict setValue: paramBinding forKey:@"binding"];
	}
	@dynamic serverurl;
	-(NSString*) serverurl
	{
		return [self.dataDict valueForKey:@"serverurl"];
	}
	-(void) setServerurl:(NSString*) paramServerurl
	{
		[self.dataDict setValue: paramServerurl forKey:@"serverurl"];
	}
	@dynamic emailverified;
	-(NSNumber*) emailverified
	{
		return [self.dataDict valueForKey:@"emailverified"];
	}
	-(void) setEmailverified:(NSNumber*) paramEmailverified
	{
		[self.dataDict setValue: paramEmailverified forKey:@"emailverified"];
	}
	@dynamic upperusername;
	-(NSString*) upperusername
	{
		return [self.dataDict valueForKey:@"upperusername"];
	}
	-(void) setUpperusername:(NSString*) paramUpperusername
	{
		[self.dataDict setValue: paramUpperusername forKey:@"upperusername"];
	}
	@dynamic usernamehashcode;
	-(NSNumber*) usernamehashcode
	{
		return [self.dataDict valueForKey:@"usernamehashcode"];
	}
	-(void) setUsernamehashcode:(NSNumber*) paramUsernamehashcode
	{
		[self.dataDict setValue: paramUsernamehashcode forKey:@"usernamehashcode"];
	}
	@dynamic upperemail;
	-(NSString*) upperemail
	{
		return [self.dataDict valueForKey:@"upperemail"];
	}
	-(void) setUpperemail:(NSString*) paramUpperemail
	{
		[self.dataDict setValue: paramUpperemail forKey:@"upperemail"];
	}
	@dynamic emailhashcode;
	-(NSNumber*) emailhashcode
	{
		return [self.dataDict valueForKey:@"emailhashcode"];
	}
	-(void) setEmailhashcode:(NSNumber*) paramEmailhashcode
	{
		[self.dataDict setValue: paramEmailhashcode forKey:@"emailhashcode"];
	}
@end
