#import "Albuminfo.h"
@implementation Albuminfo
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
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
	@dynamic sortno;
	-(NSNumber*) sortno
	{
		return [self.dataDict valueForKey:@"sortno"];
	}
	-(void) setSortno:(NSNumber*) paramSortno
	{
		[self.dataDict setValue: paramSortno forKey:@"sortno"];
	}
	@dynamic originalurl;
	-(NSString*) originalurl
	{
		return [self.dataDict valueForKey:@"originalurl"];
	}
	-(void) setOriginalurl:(NSString*) paramOriginalurl
	{
		[self.dataDict setValue: paramOriginalurl forKey:@"originalurl"];
	}
	@dynamic thumbnailurl;
	-(NSString*) thumbnailurl
	{
		return [self.dataDict valueForKey:@"thumbnailurl"];
	}
	-(void) setThumbnailurl:(NSString*) paramThumbnailurl
	{
		[self.dataDict setValue: paramThumbnailurl forKey:@"thumbnailurl"];
	}
	@dynamic privacylevel;
	-(NSNumber*) privacylevel
	{
		return [self.dataDict valueForKey:@"privacylevel"];
	}
	-(void) setPrivacylevel:(NSNumber*) paramPrivacylevel
	{
		[self.dataDict setValue: paramPrivacylevel forKey:@"privacylevel"];
	}
	@dynamic issueid;
	-(NSNumber*) issueid
	{
		return [self.dataDict valueForKey:@"issueid"];
	}
	-(void) setIssueid:(NSNumber*) paramIssueid
	{
		[self.dataDict setValue: paramIssueid forKey:@"issueid"];
	}
	@dynamic groupid;
	-(NSNumber*) groupid
	{
		return [self.dataDict valueForKey:@"groupid"];
	}
	-(void) setGroupid:(NSNumber*) paramGroupid
	{
		[self.dataDict setValue: paramGroupid forKey:@"groupid"];
	}
	@dynamic fileurl;
	-(NSString*) fileurl
	{
		return [self.dataDict valueForKey:@"fileurl"];
	}
	-(void) setFileurl:(NSString*) paramFileurl
	{
		[self.dataDict setValue: paramFileurl forKey:@"fileurl"];
	}
	@dynamic birthdate;
	-(NSNumber*) birthdate
	{
		return [self.dataDict valueForKey:@"birthdate"];
	}
	-(void) setBirthdate:(NSNumber*) paramBirthdate
	{
		[self.dataDict setValue: paramBirthdate forKey:@"birthdate"];
	}
@end
