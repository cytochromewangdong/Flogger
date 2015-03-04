#import "Externalplatform.h"
@implementation Externalplatform
	@dynamic name;
	-(NSString*) name
	{
		return [self.dataDict valueForKey:@"name"];
	}
	-(void) setName:(NSString*) paramName
	{
		[self.dataDict setValue: paramName forKey:@"name"];
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
	@dynamic url;
	-(NSString*) url
	{
		return [self.dataDict valueForKey:@"url"];
	}
	-(void) setUrl:(NSString*) paramUrl
	{
		[self.dataDict setValue: paramUrl forKey:@"url"];
	}
	@dynamic rowno;
	-(NSNumber*) rowno
	{
		return [self.dataDict valueForKey:@"rowno"];
	}
	-(void) setRowno:(NSNumber*) paramRowno
	{
		[self.dataDict setValue: paramRowno forKey:@"rowno"];
	}
	@dynamic columnno;
	-(NSNumber*) columnno
	{
		return [self.dataDict valueForKey:@"columnno"];
	}
	-(void) setColumnno:(NSNumber*) paramColumnno
	{
		[self.dataDict setValue: paramColumnno forKey:@"columnno"];
	}
	@dynamic smallbutton;
	-(NSString*) smallbutton
	{
		return [self.dataDict valueForKey:@"smallbutton"];
	}
	-(void) setSmallbutton:(NSString*) paramSmallbutton
	{
		[self.dataDict setValue: paramSmallbutton forKey:@"smallbutton"];
	}
	@dynamic midbutton;
	-(NSString*) midbutton
	{
		return [self.dataDict valueForKey:@"midbutton"];
	}
	-(void) setMidbutton:(NSString*) paramMidbutton
	{
		[self.dataDict setValue: paramMidbutton forKey:@"midbutton"];
	}
	@dynamic bigbutton;
	-(NSString*) bigbutton
	{
		return [self.dataDict valueForKey:@"bigbutton"];
	}
	-(void) setBigbutton:(NSString*) paramBigbutton
	{
		[self.dataDict setValue: paramBigbutton forKey:@"bigbutton"];
	}
	@dynamic apikey;
	-(NSString*) apikey
	{
		return [self.dataDict valueForKey:@"apikey"];
	}
	-(void) setApikey:(NSString*) paramApikey
	{
		[self.dataDict setValue: paramApikey forKey:@"apikey"];
	}
	@dynamic secretkey;
	-(NSString*) secretkey
	{
		return [self.dataDict valueForKey:@"secretkey"];
	}
	-(void) setSecretkey:(NSString*) paramSecretkey
	{
		[self.dataDict setValue: paramSecretkey forKey:@"secretkey"];
	}
	@dynamic canshare;
	-(NSNumber*) canshare
	{
		return [self.dataDict valueForKey:@"canshare"];
	}
	-(void) setCanshare:(NSNumber*) paramCanshare
	{
		[self.dataDict setValue: paramCanshare forKey:@"canshare"];
	}
	@dynamic matchurl;
	-(NSString*) matchurl
	{
		return [self.dataDict valueForKey:@"matchurl"];
	}
	-(void) setMatchurl:(NSString*) paramMatchurl
	{
		[self.dataDict setValue: paramMatchurl forKey:@"matchurl"];
	}
	@dynamic chineseorder;
	-(NSNumber*) chineseorder
	{
		return [self.dataDict valueForKey:@"chineseorder"];
	}
	-(void) setChineseorder:(NSNumber*) paramChineseorder
	{
		[self.dataDict setValue: paramChineseorder forKey:@"chineseorder"];
	}
	@dynamic otherorder;
	-(NSNumber*) otherorder
	{
		return [self.dataDict valueForKey:@"otherorder"];
	}
	-(void) setOtherorder:(NSNumber*) paramOtherorder
	{
		[self.dataDict setValue: paramOtherorder forKey:@"otherorder"];
	}
@end
