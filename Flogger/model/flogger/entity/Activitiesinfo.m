#import "Activitiesinfo.h"
@implementation Activitiesinfo
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
	}
	@dynamic actiontype;
	-(NSNumber*) actiontype
	{
		return [self.dataDict valueForKey:@"actiontype"];
	}
	-(void) setActiontype:(NSNumber*) paramActiontype
	{
		[self.dataDict setValue: paramActiontype forKey:@"actiontype"];
	}
	@dynamic actionid;
	-(NSNumber*) actionid
	{
		return [self.dataDict valueForKey:@"actionid"];
	}
	-(void) setActionid:(NSNumber*) paramActionid
	{
		[self.dataDict setValue: paramActionid forKey:@"actionid"];
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
	@dynamic targetuseruid;
	-(NSNumber*) targetuseruid
	{
		return [self.dataDict valueForKey:@"targetuseruid"];
	}
	-(void) setTargetuseruid:(NSNumber*) paramTargetuseruid
	{
		[self.dataDict setValue: paramTargetuseruid forKey:@"targetuseruid"];
	}
	@dynamic targetusername;
	-(NSString*) targetusername
	{
		return [self.dataDict valueForKey:@"targetusername"];
	}
	-(void) setTargetusername:(NSString*) paramTargetusername
	{
		[self.dataDict setValue: paramTargetusername forKey:@"targetusername"];
	}
	@dynamic targetnickname;
	-(NSString*) targetnickname
	{
		return [self.dataDict valueForKey:@"targetnickname"];
	}
	-(void) setTargetnickname:(NSString*) paramTargetnickname
	{
		[self.dataDict setValue: paramTargetnickname forKey:@"targetnickname"];
	}
	@dynamic targetimageurl;
	-(NSString*) targetimageurl
	{
		return [self.dataDict valueForKey:@"targetimageurl"];
	}
	-(void) setTargetimageurl:(NSString*) paramTargetimageurl
	{
		[self.dataDict setValue: paramTargetimageurl forKey:@"targetimageurl"];
	}
	@dynamic status;
	-(NSNumber*) status
	{
		return [self.dataDict valueForKey:@"status"];
	}
	-(void) setStatus:(NSNumber*) paramStatus
	{
		[self.dataDict setValue: paramStatus forKey:@"status"];
	}
	@dynamic parenttype;
	-(NSNumber*) parenttype
	{
		return [self.dataDict valueForKey:@"parenttype"];
	}
	-(void) setParenttype:(NSNumber*) paramParenttype
	{
		[self.dataDict setValue: paramParenttype forKey:@"parenttype"];
	}
	@dynamic parentid;
	-(NSNumber*) parentid
	{
		return [self.dataDict valueForKey:@"parentid"];
	}
	-(void) setParentid:(NSNumber*) paramParentid
	{
		[self.dataDict setValue: paramParentid forKey:@"parentid"];
	}
	@dynamic parentmediaheight;
	-(NSNumber*) parentmediaheight
	{
		return [self.dataDict valueForKey:@"parentmediaheight"];
	}
	-(void) setParentmediaheight:(NSNumber*) paramParentmediaheight
	{
		[self.dataDict setValue: paramParentmediaheight forKey:@"parentmediaheight"];
	}
	@dynamic parentmediawidth;
	-(NSNumber*) parentmediawidth
	{
		return [self.dataDict valueForKey:@"parentmediawidth"];
	}
	-(void) setParentmediawidth:(NSNumber*) paramParentmediawidth
	{
		[self.dataDict setValue: paramParentmediawidth forKey:@"parentmediawidth"];
	}
	@dynamic mediaheight;
	-(NSNumber*) mediaheight
	{
		return [self.dataDict valueForKey:@"mediaheight"];
	}
	-(void) setMediaheight:(NSNumber*) paramMediaheight
	{
		[self.dataDict setValue: paramMediaheight forKey:@"mediaheight"];
	}
	@dynamic mediawidth;
	-(NSNumber*) mediawidth
	{
		return [self.dataDict valueForKey:@"mediawidth"];
	}
	-(void) setMediawidth:(NSNumber*) paramMediawidth
	{
		[self.dataDict setValue: paramMediawidth forKey:@"mediawidth"];
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
	@dynamic text;
	-(NSString*) text
	{
		return [self.dataDict valueForKey:@"text"];
	}
	-(void) setText:(NSString*) paramText
	{
		[self.dataDict setValue: paramText forKey:@"text"];
	}
@end
