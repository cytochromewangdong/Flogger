#import "SyncupCom.h"
@implementation SyncupCom
	@dynamic externalaccounts;
	-(NSMutableArray*) externalaccounts
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"externalaccounts"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyExternalaccount* objMyExternalaccount=[[[MyExternalaccount alloc]init]autorelease];
					objMyExternalaccount.dataDict=row;
					[ret addObject:objMyExternalaccount];
				}
			}
		return ret;
	}
	-(void) setExternalaccounts:(NSMutableArray*) paramExternalaccounts
	{
		if(paramExternalaccounts){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyExternalaccount *row in paramExternalaccounts) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"externalaccounts"];
		} else
			[self.dataDict setValue: nil forKey:@"externalaccounts"];
	}
	@dynamic notificationCount;
	-(NSNumber*) notificationCount
	{
		return [self.dataDict valueForKey:@"notificationCount"];
	}
	-(void) setNotificationCount:(NSNumber*) paramNotificationCount
	{
		[self.dataDict setValue: paramNotificationCount forKey:@"notificationCount"];
	}
	@dynamic clientSystemParameter;
	-(ClientSystemParameter*) clientSystemParameter
	{
		ClientSystemParameter* ret=[[[ClientSystemParameter alloc]init]autorelease];
		ret.dataDict=[self.dataDict valueForKey:@"clientSystemParameter"];
		return ret;
	}
	-(void) setClientSystemParameter:(ClientSystemParameter*) paramClientSystemParameter
	{
		[self.dataDict setValue: paramClientSystemParameter.dataDict forKey:@"clientSystemParameter"];
	}
@end
