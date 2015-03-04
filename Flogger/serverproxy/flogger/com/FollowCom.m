#import "FollowCom.h"
@implementation FollowCom
	@dynamic requestUserUID;
	-(NSNumber*) requestUserUID
	{
		return [self.dataDict valueForKey:@"requestUserUID"];
	}
	-(void) setRequestUserUID:(NSNumber*) paramRequestUserUID
	{
		[self.dataDict setValue: paramRequestUserUID forKey:@"requestUserUID"];
	}
	@dynamic requestedUserUID;
	-(NSNumber*) requestedUserUID
	{
		return [self.dataDict valueForKey:@"requestedUserUID"];
	}
	-(void) setRequestedUserUID:(NSNumber*) paramRequestedUserUID
	{
		[self.dataDict setValue: paramRequestedUserUID forKey:@"requestedUserUID"];
	}
	@dynamic requestID;
	-(NSNumber*) requestID
	{
		return [self.dataDict valueForKey:@"requestID"];
	}
	-(void) setRequestID:(NSNumber*) paramRequestID
	{
		[self.dataDict setValue: paramRequestID forKey:@"requestID"];
	}
	@dynamic friendrequestList;
	-(NSMutableArray*) friendrequestList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"friendrequestList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					Friendrequest* objFriendrequest=[[[Friendrequest alloc]init]autorelease];
					objFriendrequest.dataDict=row;
					[ret addObject:objFriendrequest];
				}
			}
		return ret;
	}
	-(void) setFriendrequestList:(NSMutableArray*) paramFriendrequestList
	{
		if(paramFriendrequestList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(Friendrequest *row in paramFriendrequestList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"friendrequestList"];
		} else
			[self.dataDict setValue: nil forKey:@"friendrequestList"];
	}
	@dynamic description;
	-(NSString*) description
	{
		return [self.dataDict valueForKey:@"description"];
	}
	-(void) setDescription:(NSString*) paramDescription
	{
		[self.dataDict setValue: paramDescription forKey:@"description"];
	}
@end
