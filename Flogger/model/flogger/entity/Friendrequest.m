#import "Friendrequest.h"
@implementation Friendrequest
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
	@dynamic requestuseruid;
	-(NSNumber*) requestuseruid
	{
		return [self.dataDict valueForKey:@"requestuseruid"];
	}
	-(void) setRequestuseruid:(NSNumber*) paramRequestuseruid
	{
		[self.dataDict setValue: paramRequestuseruid forKey:@"requestuseruid"];
	}
	@dynamic requestusername;
	-(NSString*) requestusername
	{
		return [self.dataDict valueForKey:@"requestusername"];
	}
	-(void) setRequestusername:(NSString*) paramRequestusername
	{
		[self.dataDict setValue: paramRequestusername forKey:@"requestusername"];
	}
	@dynamic requestnickname;
	-(NSString*) requestnickname
	{
		return [self.dataDict valueForKey:@"requestnickname"];
	}
	-(void) setRequestnickname:(NSString*) paramRequestnickname
	{
		[self.dataDict setValue: paramRequestnickname forKey:@"requestnickname"];
	}
	@dynamic requestimageurl;
	-(NSString*) requestimageurl
	{
		return [self.dataDict valueForKey:@"requestimageurl"];
	}
	-(void) setRequestimageurl:(NSString*) paramRequestimageurl
	{
		[self.dataDict setValue: paramRequestimageurl forKey:@"requestimageurl"];
	}
	@dynamic requesteduseruid;
	-(NSNumber*) requesteduseruid
	{
		return [self.dataDict valueForKey:@"requesteduseruid"];
	}
	-(void) setRequesteduseruid:(NSNumber*) paramRequesteduseruid
	{
		[self.dataDict setValue: paramRequesteduseruid forKey:@"requesteduseruid"];
	}
	@dynamic requestedusername;
	-(NSString*) requestedusername
	{
		return [self.dataDict valueForKey:@"requestedusername"];
	}
	-(void) setRequestedusername:(NSString*) paramRequestedusername
	{
		[self.dataDict setValue: paramRequestedusername forKey:@"requestedusername"];
	}
	@dynamic requestednickname;
	-(NSString*) requestednickname
	{
		return [self.dataDict valueForKey:@"requestednickname"];
	}
	-(void) setRequestednickname:(NSString*) paramRequestednickname
	{
		[self.dataDict setValue: paramRequestednickname forKey:@"requestednickname"];
	}
	@dynamic requestedimageurl;
	-(NSString*) requestedimageurl
	{
		return [self.dataDict valueForKey:@"requestedimageurl"];
	}
	-(void) setRequestedimageurl:(NSString*) paramRequestedimageurl
	{
		[self.dataDict setValue: paramRequestedimageurl forKey:@"requestedimageurl"];
	}
	@dynamic requestdate;
	-(NSNumber*) requestdate
	{
		return [self.dataDict valueForKey:@"requestdate"];
	}
	-(void) setRequestdate:(NSNumber*) paramRequestdate
	{
		[self.dataDict setValue: paramRequestdate forKey:@"requestdate"];
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
	@dynamic description;
	-(NSString*) description
	{
		return [self.dataDict valueForKey:@"description"];
	}
	-(void) setDescription:(NSString*) paramDescription
	{
		[self.dataDict setValue: paramDescription forKey:@"description"];
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
@end
