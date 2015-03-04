#import "TempIssueinfo.h"
@implementation TempIssueinfo
	@dynamic uploadfileid;
	-(NSString*) uploadfileid
	{
		return [self.dataDict valueForKey:@"uploadfileid"];
	}
	-(void) setUploadfileid:(NSString*) paramUploadfileid
	{
		[self.dataDict setValue: paramUploadfileid forKey:@"uploadfileid"];
	}
	@dynamic uploadsize;
	-(NSNumber*) uploadsize
	{
		return [self.dataDict valueForKey:@"uploadsize"];
	}
	-(void) setUploadsize:(NSNumber*) paramUploadsize
	{
		[self.dataDict setValue: paramUploadsize forKey:@"uploadsize"];
	}
	@dynamic tmpfilepath;
	-(NSString*) tmpfilepath
	{
		return [self.dataDict valueForKey:@"tmpfilepath"];
	}
	-(void) setTmpfilepath:(NSString*) paramTmpfilepath
	{
		[self.dataDict setValue: paramTmpfilepath forKey:@"tmpfilepath"];
	}
	@dynamic endsize;
	-(NSNumber*) endsize
	{
		return [self.dataDict valueForKey:@"endsize"];
	}
	-(void) setEndsize:(NSNumber*) paramEndsize
	{
		[self.dataDict setValue: paramEndsize forKey:@"endsize"];
	}
@end
