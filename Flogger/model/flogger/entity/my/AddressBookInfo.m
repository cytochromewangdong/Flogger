#import "AddressBookInfo.h"
@implementation AddressBookInfo
	@dynamic md5phonenumber;
	-(NSString*) md5phonenumber
	{
		return [self.dataDict valueForKey:@"md5phonenumber"];
	}
	-(void) setMd5phonenumber:(NSString*) paramMd5phonenumber
	{
		[self.dataDict setValue: paramMd5phonenumber forKey:@"md5phonenumber"];
	}
	@dynamic md5email;
	-(NSString*) md5email
	{
		return [self.dataDict valueForKey:@"md5email"];
	}
	-(void) setMd5email:(NSString*) paramMd5email
	{
		[self.dataDict setValue: paramMd5email forKey:@"md5email"];
	}
@end
