#import "IssueGruopCom.h"
@implementation IssueGruopCom
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
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
	@dynamic albuminfoList;
	-(NSMutableArray*) albuminfoList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"albuminfoList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyAlbumInfo* objMyAlbumInfo=[[[MyAlbumInfo alloc]init]autorelease];
					objMyAlbumInfo.dataDict=row;
					[ret addObject:objMyAlbumInfo];
				}
			}
		return ret;
	}
	-(void) setAlbuminfoList:(NSMutableArray*) paramAlbuminfoList
	{
		if(paramAlbuminfoList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyAlbumInfo *row in paramAlbuminfoList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"albuminfoList"];
		} else
			[self.dataDict setValue: nil forKey:@"albuminfoList"];
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
	@dynamic target;
	-(NSNumber*) target
	{
		return [self.dataDict valueForKey:@"target"];
	}
	-(void) setTarget:(NSNumber*) paramTarget
	{
		[self.dataDict setValue: paramTarget forKey:@"target"];
	}
	@dynamic issueID;
	-(NSNumber*) issueID
	{
		return [self.dataDict valueForKey:@"issueID"];
	}
	-(void) setIssueID:(NSNumber*) paramIssueID
	{
		[self.dataDict setValue: paramIssueID forKey:@"issueID"];
	}
	@dynamic coverUrl;
	-(NSString*) coverUrl
	{
		return [self.dataDict valueForKey:@"coverUrl"];
	}
	-(void) setCoverUrl:(NSString*) paramCoverUrl
	{
		[self.dataDict setValue: paramCoverUrl forKey:@"coverUrl"];
	}
	@dynamic groupname;
	-(NSString*) groupname
	{
		return [self.dataDict valueForKey:@"groupname"];
	}
	-(void) setGroupname:(NSString*) paramGroupname
	{
		[self.dataDict setValue: paramGroupname forKey:@"groupname"];
	}
	@dynamic issuegroupList;
	-(NSMutableArray*) issuegroupList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"issuegroupList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyIssueGroup* objMyIssueGroup=[[[MyIssueGroup alloc]init]autorelease];
					objMyIssueGroup.dataDict=row;
					[ret addObject:objMyIssueGroup];
				}
			}
		return ret;
	}
	-(void) setIssuegroupList:(NSMutableArray*) paramIssuegroupList
	{
		if(paramIssuegroupList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyIssueGroup *row in paramIssuegroupList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"issuegroupList"];
		} else
			[self.dataDict setValue: nil forKey:@"issuegroupList"];
	}
@end
