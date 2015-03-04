#import "TagInfoCom.h"
@implementation TagInfoCom
	@dynamic type;
	-(NSNumber*) type
	{
		return [self.dataDict valueForKey:@"type"];
	}
	-(void) setType:(NSNumber*) paramType
	{
		[self.dataDict setValue: paramType forKey:@"type"];
	}
	@dynamic content;
	-(NSString*) content
	{
		return [self.dataDict valueForKey:@"content"];
	}
	-(void) setContent:(NSString*) paramContent
	{
		[self.dataDict setValue: paramContent forKey:@"content"];
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
	@dynamic mediaType;
	-(NSNumber*) mediaType
	{
		return [self.dataDict valueForKey:@"mediaType"];
	}
	-(void) setMediaType:(NSNumber*) paramMediaType
	{
		[self.dataDict setValue: paramMediaType forKey:@"mediaType"];
	}
	@dynamic issueInfoList;
	-(NSMutableArray*) issueInfoList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"issueInfoList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyIssueInfo* objMyIssueInfo=[[[MyIssueInfo alloc]init]autorelease];
					objMyIssueInfo.dataDict=row;
					[ret addObject:objMyIssueInfo];
				}
			}
		return ret;
	}
	-(void) setIssueInfoList:(NSMutableArray*) paramIssueInfoList
	{
		if(paramIssueInfoList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyIssueInfo *row in paramIssueInfoList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"issueInfoList"];
		} else
			[self.dataDict setValue: nil forKey:@"issueInfoList"];
	}
	@dynamic taglit;
	-(NSMutableArray*) taglit
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"taglit"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					Taglist* objTaglist=[[[Taglist alloc]init]autorelease];
					objTaglist.dataDict=row;
					[ret addObject:objTaglist];
				}
			}
		return ret;
	}
	-(void) setTaglit:(NSMutableArray*) paramTaglit
	{
		if(paramTaglit){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(Taglist *row in paramTaglit) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"taglit"];
		} else
			[self.dataDict setValue: nil forKey:@"taglit"];
	}
@end
