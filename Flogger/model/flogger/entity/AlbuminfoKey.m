#import "AlbuminfoKey.h"
@implementation AlbuminfoKey
	@dynamic groupid;
	-(NSNumber*) groupid
	{
		return [self.dataDict valueForKey:@"groupid"];
	}
	-(void) setGroupid:(NSNumber*) paramGroupid
	{
		[self.dataDict setValue: paramGroupid forKey:@"groupid"];
	}
	@dynamic issueid;
	-(NSNumber*) issueid
	{
		return [self.dataDict valueForKey:@"issueid"];
	}
	-(void) setIssueid:(NSNumber*) paramIssueid
	{
		[self.dataDict setValue: paramIssueid forKey:@"issueid"];
	}
@end
