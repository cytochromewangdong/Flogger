#import "Taglist.h"
@implementation Taglist
	@dynamic delflg;
	-(NSNumber*) delflg
	{
		return [self.dataDict valueForKey:@"delflg"];
	}
	-(void) setDelflg:(NSNumber*) paramDelflg
	{
		[self.dataDict setValue: paramDelflg forKey:@"delflg"];
	}
	@dynamic platform;
	-(NSString*) platform
	{
		return [self.dataDict valueForKey:@"platform"];
	}
	-(void) setPlatform:(NSString*) paramPlatform
	{
		[self.dataDict setValue: paramPlatform forKey:@"platform"];
	}
	@dynamic hashcode;
	-(NSNumber*) hashcode
	{
		return [self.dataDict valueForKey:@"hashcode"];
	}
	-(void) setHashcode:(NSNumber*) paramHashcode
	{
		[self.dataDict setValue: paramHashcode forKey:@"hashcode"];
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
	@dynamic content;
	-(NSString*) content
	{
		return [self.dataDict valueForKey:@"content"];
	}
	-(void) setContent:(NSString*) paramContent
	{
		[self.dataDict setValue: paramContent forKey:@"content"];
	}
@end
