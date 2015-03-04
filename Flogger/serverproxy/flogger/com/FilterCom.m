#import "FilterCom.h"
@implementation FilterCom
	@dynamic imageList;
	-(NSMutableArray*) imageList
	{
		return [self.dataDict valueForKey:@"imageList"];
	}
	-(void) setImageList:(NSMutableArray*) paramImageList
	{
		[self.dataDict setValue: paramImageList forKey:@"imageList"];
	}
	@dynamic nameList;
	-(NSMutableArray*) nameList
	{
		return [self.dataDict valueForKey:@"nameList"];
	}
	-(void) setNameList:(NSMutableArray*) paramNameList
	{
		[self.dataDict setValue: paramNameList forKey:@"nameList"];
	}
	@dynamic contentList;
	-(NSMutableArray*) contentList
	{
		return [self.dataDict valueForKey:@"contentList"];
	}
	-(void) setContentList:(NSMutableArray*) paramContentList
	{
		[self.dataDict setValue: paramContentList forKey:@"contentList"];
	}
@end
