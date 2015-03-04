#import "Externalaccount.h"
@implementation Externalaccount
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
	@dynamic usersource;
	-(NSNumber*) usersource
	{
		return [self.dataDict valueForKey:@"usersource"];
	}
	-(void) setUsersource:(NSNumber*) paramUsersource
	{
		[self.dataDict setValue: paramUsersource forKey:@"usersource"];
	}
	@dynamic usersourcename;
	-(NSString*) usersourcename
	{
		return [self.dataDict valueForKey:@"usersourcename"];
	}
	-(void) setUsersourcename:(NSString*) paramUsersourcename
	{
		[self.dataDict setValue: paramUsersourcename forKey:@"usersourcename"];
	}
	@dynamic externaluid;
	-(NSString*) externaluid
	{
		return [self.dataDict valueForKey:@"externaluid"];
	}
	-(void) setExternaluid:(NSString*) paramExternaluid
	{
		[self.dataDict setValue: paramExternaluid forKey:@"externaluid"];
	}
	@dynamic accesstoken;
	-(NSString*) accesstoken
	{
		return [self.dataDict valueForKey:@"accesstoken"];
	}
	-(void) setAccesstoken:(NSString*) paramAccesstoken
	{
		[self.dataDict setValue: paramAccesstoken forKey:@"accesstoken"];
	}
	@dynamic tokensecret;
	-(NSString*) tokensecret
	{
		return [self.dataDict valueForKey:@"tokensecret"];
	}
	-(void) setTokensecret:(NSString*) paramTokensecret
	{
		[self.dataDict setValue: paramTokensecret forKey:@"tokensecret"];
	}
	@dynamic refreshtoken;
	-(NSString*) refreshtoken
	{
		return [self.dataDict valueForKey:@"refreshtoken"];
	}
	-(void) setRefreshtoken:(NSString*) paramRefreshtoken
	{
		[self.dataDict setValue: paramRefreshtoken forKey:@"refreshtoken"];
	}
	@dynamic sharestatus;
	-(NSNumber*) sharestatus
	{
		return [self.dataDict valueForKey:@"sharestatus"];
	}
	-(void) setSharestatus:(NSNumber*) paramSharestatus
	{
		[self.dataDict setValue: paramSharestatus forKey:@"sharestatus"];
	}
	@dynamic expiretime;
	-(NSNumber*) expiretime
	{
		return [self.dataDict valueForKey:@"expiretime"];
	}
	-(void) setExpiretime:(NSNumber*) paramExpiretime
	{
		[self.dataDict setValue: paramExpiretime forKey:@"expiretime"];
	}
@end
