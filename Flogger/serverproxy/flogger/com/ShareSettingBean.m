#import "ShareSettingBean.h"
@implementation ShareSettingBean
	@dynamic usersource;
	-(NSNumber*) usersource
	{
		return [self.dataDict valueForKey:@"usersource"];
	}
	-(void) setUsersource:(NSNumber*) paramUsersource
	{
		[self.dataDict setValue: paramUsersource forKey:@"usersource"];
	}
	@dynamic shareswitch;
	-(NSNumber*) shareswitch
	{
		return [self.dataDict valueForKey:@"shareswitch"];
	}
	-(void) setShareswitch:(NSNumber*) paramShareswitch
	{
		[self.dataDict setValue: paramShareswitch forKey:@"shareswitch"];
	}
@end
