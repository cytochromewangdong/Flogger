#import "IssueInfoCom.h"
@implementation IssueInfoCom
	@dynamic type;
	-(NSNumber*) type
	{
		return [self.dataDict valueForKey:@"type"];
	}
	-(void) setType:(NSNumber*) paramType
	{
		[self.dataDict setValue: paramType forKey:@"type"];
	}
	@dynamic count;
	-(NSNumber*) count
	{
		return [self.dataDict valueForKey:@"count"];
	}
	-(void) setCount:(NSNumber*) paramCount
	{
		[self.dataDict setValue: paramCount forKey:@"count"];
	}
	@dynamic userMediaCnt;
	-(NSNumber*) userMediaCnt
	{
		return [self.dataDict valueForKey:@"userMediaCnt"];
	}
	-(void) setUserMediaCnt:(NSNumber*) paramUserMediaCnt
	{
		[self.dataDict setValue: paramUserMediaCnt forKey:@"userMediaCnt"];
	}
	@dynamic guid;
	-(NSString*) guid
	{
		return [self.dataDict valueForKey:@"guid"];
	}
	-(void) setGuid:(NSString*) paramGuid
	{
		[self.dataDict setValue: paramGuid forKey:@"guid"];
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
	@dynamic account;
	-(MyAccount*) account
	{
		MyAccount* ret=[[[MyAccount alloc]init]autorelease];
		ret.dataDict=[self.dataDict valueForKey:@"account"];
		return ret;
	}
	-(void) setAccount:(MyAccount*) paramAccount
	{
		[self.dataDict setValue: paramAccount.dataDict forKey:@"account"];
	}
	@dynamic uploadType;
	-(NSNumber*) uploadType
	{
		return [self.dataDict valueForKey:@"uploadType"];
	}
	-(void) setUploadType:(NSNumber*) paramUploadType
	{
		[self.dataDict setValue: paramUploadType forKey:@"uploadType"];
	}
	@dynamic uploadFileSize;
	-(NSNumber*) uploadFileSize
	{
		return [self.dataDict valueForKey:@"uploadFileSize"];
	}
	-(void) setUploadFileSize:(NSNumber*) paramUploadFileSize
	{
		[self.dataDict setValue: paramUploadFileSize forKey:@"uploadFileSize"];
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
	@dynamic uploadFileID;
	-(NSString*) uploadFileID
	{
		return [self.dataDict valueForKey:@"uploadFileID"];
	}
	-(void) setUploadFileID:(NSString*) paramUploadFileID
	{
		[self.dataDict setValue: paramUploadFileID forKey:@"uploadFileID"];
	}
	@dynamic startSize;
	-(NSNumber*) startSize
	{
		return [self.dataDict valueForKey:@"startSize"];
	}
	-(void) setStartSize:(NSNumber*) paramStartSize
	{
		[self.dataDict setValue: paramStartSize forKey:@"startSize"];
	}
	@dynamic issueinfo;
	-(IssueinfoBean*) issueinfo
	{
		IssueinfoBean* ret=[[[IssueinfoBean alloc]init]autorelease];
		ret.dataDict=[self.dataDict valueForKey:@"issueinfo"];
		return ret;
	}
	-(void) setIssueinfo:(IssueinfoBean*) paramIssueinfo
	{
		[self.dataDict setValue: paramIssueinfo.dataDict forKey:@"issueinfo"];
	}
	@dynamic issueId;
	-(NSNumber*) issueId
	{
		return [self.dataDict valueForKey:@"issueId"];
	}
	-(void) setIssueId:(NSNumber*) paramIssueId
	{
		[self.dataDict setValue: paramIssueId forKey:@"issueId"];
	}
	@dynamic issueInfoList;
	-(NSMutableArray*) issueInfoList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"issueInfoList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					Issueinfo* objIssueinfo=[[[Issueinfo alloc]init]autorelease];
					objIssueinfo.dataDict=row;
					[ret addObject:objIssueinfo];
				}
			}
		return ret;
	}
	-(void) setIssueInfoList:(NSMutableArray*) paramIssueInfoList
	{
		if(paramIssueInfoList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(Issueinfo *row in paramIssueInfoList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"issueInfoList"];
		} else
			[self.dataDict setValue: nil forKey:@"issueInfoList"];
	}
	@dynamic myIssueInfoList;
	-(NSMutableArray*) myIssueInfoList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"myIssueInfoList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyIssueInfo* objMyIssueInfo=[[[MyIssueInfo alloc]init]autorelease];
					objMyIssueInfo.dataDict=row;
					[ret addObject:objMyIssueInfo];
				}
			}
		return ret;
	}
	-(void) setMyIssueInfoList:(NSMutableArray*) paramMyIssueInfoList
	{
		if(paramMyIssueInfoList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyIssueInfo *row in paramMyIssueInfoList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"myIssueInfoList"];
		} else
			[self.dataDict setValue: nil forKey:@"myIssueInfoList"];
	}
	@dynamic issueIdList;
	-(NSMutableArray*) issueIdList
	{
		return [self.dataDict valueForKey:@"issueIdList"];
	}
	-(void) setIssueIdList:(NSMutableArray*) paramIssueIdList
	{
		[self.dataDict setValue: paramIssueIdList forKey:@"issueIdList"];
	}
	@dynamic usersourceList;
	-(NSMutableArray*) usersourceList
	{
		return [self.dataDict valueForKey:@"usersourceList"];
	}
	-(void) setUsersourceList:(NSMutableArray*) paramUsersourceList
	{
		[self.dataDict setValue: paramUsersourceList forKey:@"usersourceList"];
	}
	@dynamic singleShare;
	-(NSNumber*) singleShare
	{
		return [self.dataDict valueForKey:@"singleShare"];
	}
	-(void) setSingleShare:(NSNumber*) paramSingleShare
	{
		[self.dataDict setValue: paramSingleShare forKey:@"singleShare"];
	}
	@dynamic myAccountList;
	-(NSMutableArray*) myAccountList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"myAccountList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyAccount* objMyAccount=[[[MyAccount alloc]init]autorelease];
					objMyAccount.dataDict=row;
					[ret addObject:objMyAccount];
				}
			}
		return ret;
	}
	-(void) setMyAccountList:(NSMutableArray*) paramMyAccountList
	{
		if(paramMyAccountList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyAccount *row in paramMyAccountList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"myAccountList"];
		} else
			[self.dataDict setValue: nil forKey:@"myAccountList"];
	}
	@dynamic groupID;
	-(NSNumber*) groupID
	{
		return [self.dataDict valueForKey:@"groupID"];
	}
	-(void) setGroupID:(NSNumber*) paramGroupID
	{
		[self.dataDict setValue: paramGroupID forKey:@"groupID"];
	}
	@dynamic originalUrl;
	-(NSString*) originalUrl
	{
		return [self.dataDict valueForKey:@"originalUrl"];
	}
	-(void) setOriginalUrl:(NSString*) paramOriginalUrl
	{
		[self.dataDict setValue: paramOriginalUrl forKey:@"originalUrl"];
	}
	@dynamic threadHead;
	-(MyIssueInfo*) threadHead
	{
		MyIssueInfo* ret=[[[MyIssueInfo alloc]init]autorelease];
		ret.dataDict=[self.dataDict valueForKey:@"threadHead"];
		return ret;
	}
	-(void) setThreadHead:(MyIssueInfo*) paramThreadHead
	{
		[self.dataDict setValue: paramThreadHead.dataDict forKey:@"threadHead"];
	}
	@dynamic middleUrl;
	-(NSString*) middleUrl
	{
		return [self.dataDict valueForKey:@"middleUrl"];
	}
	-(void) setMiddleUrl:(NSString*) paramMiddleUrl
	{
		[self.dataDict setValue: paramMiddleUrl forKey:@"middleUrl"];
	}
@end
