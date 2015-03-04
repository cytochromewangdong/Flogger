#import "FollowerAndFollowCom.h"
@implementation FollowerAndFollowCom
	@dynamic userUID;
	-(NSNumber*) userUID
	{
		return [self.dataDict valueForKey:@"userUID"];
	}
	-(void) setUserUID:(NSNumber*) paramUserUID
	{
		[self.dataDict setValue: paramUserUID forKey:@"userUID"];
	}
	@dynamic accountList;
	-(NSMutableArray*) accountList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"accountList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					AccountEntity* objAccount=[[[AccountEntity alloc]init]autorelease];
					objAccount.dataDict=row;
					[ret addObject:objAccount];
				}
			}
		return ret;
	}
	-(void) setAccountList:(NSMutableArray*) paramAccountList
	{
		if(paramAccountList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(AccountEntity *row in paramAccountList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"accountList"];
		} else
			[self.dataDict setValue: nil forKey:@"accountList"];
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
@end
