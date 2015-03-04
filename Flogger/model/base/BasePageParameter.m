#import "BasePageParameter.h"
@implementation BasePageParameter
	@dynamic currentPage;
	-(NSNumber*) currentPage
	{
		return [self.dataDict valueForKey:@"currentPage"];
	}
	-(void) setCurrentPage:(NSNumber*) paramCurrentPage
	{
		[self.dataDict setValue: paramCurrentPage forKey:@"currentPage"];
	}
	@dynamic endTime;
	-(NSNumber*) endTime
	{
		return [self.dataDict valueForKey:@"endTime"];
	}
	-(void) setEndTime:(NSNumber*) paramEndTime
	{
		[self.dataDict setValue: paramEndTime forKey:@"endTime"];
	}
	@dynamic itemNumberOfPage;
	-(NSNumber*) itemNumberOfPage
	{
		return [self.dataDict valueForKey:@"itemNumberOfPage"];
	}
	-(void) setItemNumberOfPage:(NSNumber*) paramItemNumberOfPage
	{
		[self.dataDict setValue: paramItemNumberOfPage forKey:@"itemNumberOfPage"];
	}
	@dynamic realItemNumberOfPage;
	-(NSNumber*) realItemNumberOfPage
	{
		return [self.dataDict valueForKey:@"realItemNumberOfPage"];
	}
	-(void) setRealItemNumberOfPage:(NSNumber*) paramRealItemNumberOfPage
	{
		[self.dataDict setValue: paramRealItemNumberOfPage forKey:@"realItemNumberOfPage"];
	}
	@dynamic searchEndID;
	-(NSNumber*) searchEndID
	{
		return [self.dataDict valueForKey:@"searchEndID"];
	}
	-(void) setSearchEndID:(NSNumber*) paramSearchEndID
	{
		[self.dataDict setValue: paramSearchEndID forKey:@"searchEndID"];
	}
	@dynamic searchStartID;
	-(NSNumber*) searchStartID
	{
		return [self.dataDict valueForKey:@"searchStartID"];
	}
	-(void) setSearchStartID:(NSNumber*) paramSearchStartID
	{
		[self.dataDict setValue: paramSearchStartID forKey:@"searchStartID"];
	}
	@dynamic totalPage;
	-(NSNumber*) totalPage
	{
		return [self.dataDict valueForKey:@"totalPage"];
	}
	-(void) setTotalPage:(NSNumber*) paramTotalPage
	{
		[self.dataDict setValue: paramTotalPage forKey:@"totalPage"];
	}
	@dynamic standardOffset;
	-(NSNumber*) standardOffset
	{
		return [self.dataDict valueForKey:@"standardOffset"];
	}
	-(void) setStandardOffset:(NSNumber*) paramStandardOffset
	{
		[self.dataDict setValue: paramStandardOffset forKey:@"standardOffset"];
	}
	@dynamic offset;
	-(NSNumber*) offset
	{
		return [self.dataDict valueForKey:@"offset"];
	}
	-(void) setOffset:(NSNumber*) paramOffset
	{
		[self.dataDict setValue: paramOffset forKey:@"offset"];
	}
	@dynamic startTime;
	-(NSNumber*) startTime
	{
		return [self.dataDict valueForKey:@"startTime"];
	}
	-(void) setStartTime:(NSNumber*) paramStartTime
	{
		[self.dataDict setValue: paramStartTime forKey:@"startTime"];
	}
@end
