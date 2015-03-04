#import "Friendship.h"
@implementation Friendship
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
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
	@dynamic followuseruid;
	-(NSNumber*) followuseruid
	{
		return [self.dataDict valueForKey:@"followuseruid"];
	}
	-(void) setFollowuseruid:(NSNumber*) paramFollowuseruid
	{
		[self.dataDict setValue: paramFollowuseruid forKey:@"followuseruid"];
	}
	@dynamic followtime;
	-(NSNumber*) followtime
	{
		return [self.dataDict valueForKey:@"followtime"];
	}
	-(void) setFollowtime:(NSNumber*) paramFollowtime
	{
		[self.dataDict setValue: paramFollowtime forKey:@"followtime"];
	}
@end
