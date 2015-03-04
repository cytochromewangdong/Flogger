#import "FindFriendCom.h"
@implementation FindFriendCom
	@dynamic accountList;
	-(NSMutableArray*) accountList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"accountList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyAccount* objMyAccount=[[[MyAccount alloc]init]autorelease];
					objMyAccount.dataDict=row;
					[ret addObject:objMyAccount];
				}
			}
		return ret;
	}
	-(void) setAccountList:(NSMutableArray*) paramAccountList
	{
		if(paramAccountList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyAccount *row in paramAccountList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"accountList"];
		} else
			[self.dataDict setValue: nil forKey:@"accountList"];
	}
	@dynamic addressBookInfoList;
	-(NSMutableArray*) addressBookInfoList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"addressBookInfoList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					AddressBookInfo* objAddressBookInfo=[[[AddressBookInfo alloc]init]autorelease];
					objAddressBookInfo.dataDict=row;
					[ret addObject:objAddressBookInfo];
				}
			}
		return ret;
	}
	-(void) setAddressBookInfoList:(NSMutableArray*) paramAddressBookInfoList
	{
		if(paramAddressBookInfoList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(AddressBookInfo *row in paramAddressBookInfoList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"addressBookInfoList"];
		} else
			[self.dataDict setValue: nil forKey:@"addressBookInfoList"];
	}
@end
