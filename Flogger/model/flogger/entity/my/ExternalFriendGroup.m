#import "ExternalFriendGroup.h"
@implementation ExternalFriendGroup
	@dynamic usersourcename;
	-(NSString*) usersourcename
	{
		return [self.dataDict valueForKey:@"usersourcename"];
	}
	-(void) setUsersourcename:(NSString*) paramUsersourcename
	{
		[self.dataDict setValue: paramUsersourcename forKey:@"usersourcename"];
	}
	@dynamic usersource;
	-(NSNumber*) usersource
	{
		return [self.dataDict valueForKey:@"usersource"];
	}
	-(void) setUsersource:(NSNumber*) paramUsersource
	{
		[self.dataDict setValue: paramUsersource forKey:@"usersource"];
	}
	@dynamic externalfriendsList;
	-(NSMutableArray*) externalfriendsList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"externalfriendsList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyAccount* objMyAccount=[[[MyAccount alloc]init]autorelease];
					objMyAccount.dataDict=row;
					[ret addObject:objMyAccount];
				}
			}
		return ret;
	}
	-(void) setExternalfriendsList:(NSMutableArray*) paramExternalfriendsList
	{
		if(paramExternalfriendsList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyAccount *row in paramExternalfriendsList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"externalfriendsList"];
		} else
			[self.dataDict setValue: nil forKey:@"externalfriendsList"];
	}
@end
