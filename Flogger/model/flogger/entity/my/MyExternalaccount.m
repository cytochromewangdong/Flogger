#import "MyExternalaccount.h"
@implementation MyExternalaccount
	@dynamic expired;
	-(NSNumber*) expired
	{
		return [self.dataDict valueForKey:@"expired"];
	}
	-(void) setExpired:(NSNumber*) paramExpired
	{
		[self.dataDict setValue: paramExpired forKey:@"expired"];
	}
@end
