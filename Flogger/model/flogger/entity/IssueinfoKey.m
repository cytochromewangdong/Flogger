#import "IssueinfoKey.h"
@implementation IssueinfoKey
	@dynamic issuecategory;
	-(NSNumber*) issuecategory
	{
		return [self.dataDict valueForKey:@"issuecategory"];
	}
	-(void) setIssuecategory:(NSNumber*) paramIssuecategory
	{
		[self.dataDict setValue: paramIssuecategory forKey:@"issuecategory"];
	}
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
	}
@end
