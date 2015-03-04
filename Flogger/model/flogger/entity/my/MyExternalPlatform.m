#import "MyExternalPlatform.h"
@implementation MyExternalPlatform
	@dynamic findfriendsName;
	-(NSString*) findfriendsName
	{
		return [self.dataDict valueForKey:@"findfriendsName"];
	}
	-(void) setFindfriendsName:(NSString*) paramFindfriendsName
	{
		[self.dataDict setValue: paramFindfriendsName forKey:@"findfriendsName"];
	}
@end
