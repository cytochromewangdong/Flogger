#import "ShareCom.h"
@implementation ShareCom
	@dynamic text;
	-(NSString*) text
	{
		return [self.dataDict valueForKey:@"text"];
	}
	-(void) setText:(NSString*) paramText
	{
		[self.dataDict setValue: paramText forKey:@"text"];
	}
	@dynamic userUID;
	-(NSNumber*) userUID
	{
		return [self.dataDict valueForKey:@"userUID"];
	}
	-(void) setUserUID:(NSNumber*) paramUserUID
	{
		[self.dataDict setValue: paramUserUID forKey:@"userUID"];
	}
	@dynamic issueIdList;
	-(NSMutableArray*) issueIdList
	{
		return [self.dataDict valueForKey:@"issueIdList"];
	}
	-(void) setIssueIdList:(NSMutableArray*) paramIssueIdList
	{
		[self.dataDict setValue: paramIssueIdList forKey:@"issueIdList"];
	}
	@dynamic sourceList;
	-(NSMutableArray*) sourceList
	{
		return [self.dataDict valueForKey:@"sourceList"];
	}
	-(void) setSourceList:(NSMutableArray*) paramSourceList
	{
		[self.dataDict setValue: paramSourceList forKey:@"sourceList"];
	}
@end
