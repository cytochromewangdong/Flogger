#import "MyIssueGroup.h"
@implementation MyIssueGroup
	@dynamic albuminfoList;
	-(NSMutableArray*) albuminfoList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"albuminfoList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					Albuminfo* objAlbuminfo=[[[Albuminfo alloc]init]autorelease];
					objAlbuminfo.dataDict=row;
					[ret addObject:objAlbuminfo];
				}
			}
		return ret;
	}
	-(void) setAlbuminfoList:(NSMutableArray*) paramAlbuminfoList
	{
		if(paramAlbuminfoList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(Albuminfo *row in paramAlbuminfoList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"albuminfoList"];
		} else
			[self.dataDict setValue: nil forKey:@"albuminfoList"];
	}
	@dynamic mediaCount;
	-(NSNumber*) mediaCount
	{
		return [self.dataDict valueForKey:@"mediaCount"];
	}
	-(void) setMediaCount:(NSNumber*) paramMediaCount
	{
		[self.dataDict setValue: paramMediaCount forKey:@"mediaCount"];
	}
@end
