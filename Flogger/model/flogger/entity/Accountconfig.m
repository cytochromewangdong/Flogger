#import "Accountconfig.h"
@implementation Accountconfig
	@dynamic groupid;
	-(NSString*) groupid
	{
		return [self.dataDict valueForKey:@"groupid"];
	}
	-(void) setGroupid:(NSString*) paramGroupid
	{
		[self.dataDict setValue: paramGroupid forKey:@"groupid"];
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
	@dynamic hostid;
	-(NSString*) hostid
	{
		return [self.dataDict valueForKey:@"hostid"];
	}
	-(void) setHostid:(NSString*) paramHostid
	{
		[self.dataDict setValue: paramHostid forKey:@"hostid"];
	}
	@dynamic fileserverid;
	-(NSString*) fileserverid
	{
		return [self.dataDict valueForKey:@"fileserverid"];
	}
	-(void) setFileserverid:(NSString*) paramFileserverid
	{
		[self.dataDict setValue: paramFileserverid forKey:@"fileserverid"];
	}
@end
