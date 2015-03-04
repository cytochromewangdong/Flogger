#import "UtilityCom.h"
@implementation UtilityCom
	@dynamic type;
	-(NSNumber*) type
	{
		return [self.dataDict valueForKey:@"type"];
	}
	-(void) setType:(NSNumber*) paramType
	{
		[self.dataDict setValue: paramType forKey:@"type"];
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
	@dynamic latestActivities;
	-(NSMutableArray*) latestActivities
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"latestActivities"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					ActivityResultEntity* objActivityResultEntity=[[[ActivityResultEntity alloc]init]autorelease];
					objActivityResultEntity.dataDict=row;
					[ret addObject:objActivityResultEntity];
				}
			}
		return ret;
	}
	-(void) setLatestActivities:(NSMutableArray*) paramLatestActivities
	{
		if(paramLatestActivities){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(ActivityResultEntity *row in paramLatestActivities) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"latestActivities"];
		} else
			[self.dataDict setValue: nil forKey:@"latestActivities"];
	}
@end
