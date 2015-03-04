#import "ActivityResultEntity.h"
@implementation ActivityResultEntity
	@dynamic mediaUrl;
	-(NSString*) mediaUrl
	{
		return [self.dataDict valueForKey:@"mediaUrl"];
	}
	-(void) setMediaUrl:(NSString*) paramMediaUrl
	{
		[self.dataDict setValue: paramMediaUrl forKey:@"mediaUrl"];
	}
	@dynamic parentMediaUrl;
	-(NSString*) parentMediaUrl
	{
		return [self.dataDict valueForKey:@"parentMediaUrl"];
	}
	-(void) setParentMediaUrl:(NSString*) paramParentMediaUrl
	{
		[self.dataDict setValue: paramParentMediaUrl forKey:@"parentMediaUrl"];
	}
	@dynamic parentShout;
	-(NSString*) parentShout
	{
		return [self.dataDict valueForKey:@"parentShout"];
	}
	-(void) setParentShout:(NSString*) paramParentShout
	{
		[self.dataDict setValue: paramParentShout forKey:@"parentShout"];
	}
	@dynamic currentThread;
	-(MyIssueInfo*) currentThread
	{
		MyIssueInfo* ret=[[[MyIssueInfo alloc]init]autorelease];
		ret.dataDict=[self.dataDict valueForKey:@"currentThread"];
		return ret;
	}
	-(void) setCurrentThread:(MyIssueInfo*) paramCurrentThread
	{
		[self.dataDict setValue: paramCurrentThread.dataDict forKey:@"currentThread"];
	}
	@dynamic parentThread;
	-(MyIssueInfo*) parentThread
	{
		MyIssueInfo* ret=[[[MyIssueInfo alloc]init]autorelease];
		ret.dataDict=[self.dataDict valueForKey:@"parentThread"];
		return ret;
	}
	-(void) setParentThread:(MyIssueInfo*) paramParentThread
	{
		[self.dataDict setValue: paramParentThread.dataDict forKey:@"parentThread"];
	}
@end
