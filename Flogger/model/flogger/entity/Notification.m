#import "Notification.h"
@implementation Notification
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
	@dynamic actiontype;
	-(NSNumber*) actiontype
	{
		return [self.dataDict valueForKey:@"actiontype"];
	}
	-(void) setActiontype:(NSNumber*) paramActiontype
	{
		[self.dataDict setValue: paramActiontype forKey:@"actiontype"];
	}
	@dynamic getstatus;
	-(NSNumber*) getstatus
	{
		return [self.dataDict valueForKey:@"getstatus"];
	}
	-(void) setGetstatus:(NSNumber*) paramGetstatus
	{
		[self.dataDict setValue: paramGetstatus forKey:@"getstatus"];
	}
	@dynamic readstatus;
	-(NSNumber*) readstatus
	{
		return [self.dataDict valueForKey:@"readstatus"];
	}
	-(void) setReadstatus:(NSNumber*) paramReadstatus
	{
		[self.dataDict setValue: paramReadstatus forKey:@"readstatus"];
	}
	@dynamic mediaurl;
	-(NSString*) mediaurl
	{
		return [self.dataDict valueForKey:@"mediaurl"];
	}
	-(void) setMediaurl:(NSString*) paramMediaurl
	{
		[self.dataDict setValue: paramMediaurl forKey:@"mediaurl"];
	}
	@dynamic targeturl;
	-(NSString*) targeturl
	{
		return [self.dataDict valueForKey:@"targeturl"];
	}
	-(void) setTargeturl:(NSString*) paramTargeturl
	{
		[self.dataDict setValue: paramTargeturl forKey:@"targeturl"];
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
	@dynamic source;
	-(NSNumber*) source
	{
		return [self.dataDict valueForKey:@"source"];
	}
	-(void) setSource:(NSNumber*) paramSource
	{
		[self.dataDict setValue: paramSource forKey:@"source"];
	}
@end
