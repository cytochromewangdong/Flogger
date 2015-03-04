#import "Friendaccept.h"
@implementation Friendaccept
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
	@dynamic acceptuseruid;
	-(NSNumber*) acceptuseruid
	{
		return [self.dataDict valueForKey:@"acceptuseruid"];
	}
	-(void) setAcceptuseruid:(NSNumber*) paramAcceptuseruid
	{
		[self.dataDict setValue: paramAcceptuseruid forKey:@"acceptuseruid"];
	}
	@dynamic acceptusername;
	-(NSString*) acceptusername
	{
		return [self.dataDict valueForKey:@"acceptusername"];
	}
	-(void) setAcceptusername:(NSString*) paramAcceptusername
	{
		[self.dataDict setValue: paramAcceptusername forKey:@"acceptusername"];
	}
	@dynamic acceptnickname;
	-(NSString*) acceptnickname
	{
		return [self.dataDict valueForKey:@"acceptnickname"];
	}
	-(void) setAcceptnickname:(NSString*) paramAcceptnickname
	{
		[self.dataDict setValue: paramAcceptnickname forKey:@"acceptnickname"];
	}
	@dynamic acceptimageurl;
	-(NSString*) acceptimageurl
	{
		return [self.dataDict valueForKey:@"acceptimageurl"];
	}
	-(void) setAcceptimageurl:(NSString*) paramAcceptimageurl
	{
		[self.dataDict setValue: paramAcceptimageurl forKey:@"acceptimageurl"];
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
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
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
