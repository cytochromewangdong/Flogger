#import "FriendshipKey.h"
@implementation FriendshipKey
	@dynamic useruid;
	-(NSNumber*) useruid
	{
		return [self.dataDict valueForKey:@"useruid"];
	}
	-(void) setUseruid:(NSNumber*) paramUseruid
	{
		[self.dataDict setValue: paramUseruid forKey:@"useruid"];
	}
	@dynamic followuseruid;
	-(NSNumber*) followuseruid
	{
		return [self.dataDict valueForKey:@"followuseruid"];
	}
	-(void) setFollowuseruid:(NSNumber*) paramFollowuseruid
	{
		[self.dataDict setValue: paramFollowuseruid forKey:@"followuseruid"];
	}
@end
