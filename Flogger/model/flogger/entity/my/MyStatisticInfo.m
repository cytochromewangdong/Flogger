#import "MyStatisticInfo.h"
@implementation MyStatisticInfo
	@dynamic count;
	-(NSNumber*) count
	{
		return [self.dataDict valueForKey:@"count"];
	}
	-(void) setCount:(NSNumber*) paramCount
	{
		[self.dataDict setValue: paramCount forKey:@"count"];
	}
@end
