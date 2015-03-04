#import "LikeInfoCom.h"
@implementation LikeInfoCom
	@dynamic userUID;
	-(NSNumber*) userUID
	{
		return [self.dataDict valueForKey:@"userUID"];
	}
	-(void) setUserUID:(NSNumber*) paramUserUID
	{
		[self.dataDict setValue: paramUserUID forKey:@"userUID"];
	}
	@dynamic parentID;
	-(NSNumber*) parentID
	{
		return [self.dataDict valueForKey:@"parentID"];
	}
	-(void) setParentID:(NSNumber*) paramParentID
	{
		[self.dataDict setValue: paramParentID forKey:@"parentID"];
	}
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
	}

@dynamic issueIdList;
-(NSMutableArray*) issueIdList
{
//    NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
    NSMutableArray* rawData = [self.dataDict valueForKey:@"issueIdList"];
//    if(rawData) {
//        for(NSMutableDictionary *row in rawData) {
//            NSNumber* objMyIssueInfo=[[[MyIssueInfo alloc]init]autorelease];
//            objMyIssueInfo.dataDict=row;
//            [ret addObject:objMyIssueInfo];
//        }
//    }
    return rawData;
}
-(void) setIssueIdList:(NSMutableArray *)issueIdList
{
    if(issueIdList){
        NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
        for(NSNumber *row in issueIdList) {
            [rawDataRows addObject:row];
        }
        [self.dataDict setValue: rawDataRows forKey:@"issueIdList"];
    } else
        [self.dataDict setValue: nil forKey:@"issueIdList"];
}
@end
