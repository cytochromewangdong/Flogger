#import "NotificationCom.h"
@implementation NotificationCom
	@dynamic userUID;
	-(NSNumber*) userUID
	{
		return [self.dataDict valueForKey:@"userUID"];
	}
	-(void) setUserUID:(NSNumber*) paramUserUID
	{
		[self.dataDict setValue: paramUserUID forKey:@"userUID"];
	}
	@dynamic notificationList;
	-(NSMutableArray*) notificationList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"notificationList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					ActivityResultEntity* objActivityResultEntity=[[[ActivityResultEntity alloc]init]autorelease];
					objActivityResultEntity.dataDict=row;
					[ret addObject:objActivityResultEntity];
				}
			}
		return ret;
	}
	-(void) setNotificationList:(NSMutableArray*) paramNotificationList
	{
		if(paramNotificationList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(ActivityResultEntity *row in paramNotificationList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"notificationList"];
		} else
			[self.dataDict setValue: nil forKey:@"notificationList"];
	}
	@dynamic externalFriendList;
	-(NSMutableArray*) externalFriendList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"externalFriendList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					ExternalFriendGroup* objExternalFriendGroup=[[[ExternalFriendGroup alloc]init]autorelease];
					objExternalFriendGroup.dataDict=row;
					[ret addObject:objExternalFriendGroup];
				}
			}
		return ret;
	}
	-(void) setExternalFriendList:(NSMutableArray*) paramExternalFriendList
	{
		if(paramExternalFriendList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(ExternalFriendGroup *row in paramExternalFriendList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"externalFriendList"];
		} else
			[self.dataDict setValue: nil forKey:@"externalFriendList"];
	}
@end
