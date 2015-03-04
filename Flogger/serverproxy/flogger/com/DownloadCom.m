#import "DownloadCom.h"
@implementation DownloadCom
	@dynamic id;
	-(NSString*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSString*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
	}
	@dynamic type;
	-(NSNumber*) type
	{
		return [self.dataDict valueForKey:@"type"];
	}
	-(void) setType:(NSNumber*) paramType
	{
		[self.dataDict setValue: paramType forKey:@"type"];
	}
	@dynamic startPoint;
	-(NSNumber*) startPoint
	{
		return [self.dataDict valueForKey:@"startPoint"];
	}
	-(void) setStartPoint:(NSNumber*) paramStartPoint
	{
		[self.dataDict setValue: paramStartPoint forKey:@"startPoint"];
	}
@end
