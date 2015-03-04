#import "ExternalaccountKey.h"
@implementation ExternalaccountKey
	@dynamic useruid;
	-(NSNumber*) useruid
	{
		return [self.dataDict valueForKey:@"useruid"];
	}
	-(void) setUseruid:(NSNumber*) paramUseruid
	{
		[self.dataDict setValue: paramUseruid forKey:@"useruid"];
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
	@dynamic externaluid;
	-(NSString*) externaluid
	{
		return [self.dataDict valueForKey:@"externaluid"];
	}
	-(void) setExternaluid:(NSString*) paramExternaluid
	{
		[self.dataDict setValue: paramExternaluid forKey:@"externaluid"];
	}
@end
