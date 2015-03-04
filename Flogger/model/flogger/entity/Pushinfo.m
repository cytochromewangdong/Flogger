#import "Pushinfo.h"
@implementation Pushinfo
	@dynamic language;
	-(NSString*) language
	{
		return [self.dataDict valueForKey:@"language"];
	}
	-(void) setLanguage:(NSString*) paramLanguage
	{
		[self.dataDict setValue: paramLanguage forKey:@"language"];
	}
	@dynamic useruid;
	-(NSNumber*) useruid
	{
		return [self.dataDict valueForKey:@"useruid"];
	}
	-(void) setUseruid:(NSNumber*) paramUseruid
	{
		[self.dataDict setValue: paramUseruid forKey:@"useruid"];
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
	@dynamic devicetoken;
	-(NSString*) devicetoken
	{
		return [self.dataDict valueForKey:@"devicetoken"];
	}
	-(void) setDevicetoken:(NSString*) paramDevicetoken
	{
		[self.dataDict setValue: paramDevicetoken forKey:@"devicetoken"];
	}
	@dynamic badgecnt;
	-(NSNumber*) badgecnt
	{
		return [self.dataDict valueForKey:@"badgecnt"];
	}
	-(void) setBadgecnt:(NSNumber*) paramBadgecnt
	{
		[self.dataDict setValue: paramBadgecnt forKey:@"badgecnt"];
	}
	@dynamic likeflg;
	-(NSNumber*) likeflg
	{
		return [self.dataDict valueForKey:@"likeflg"];
	}
	-(void) setLikeflg:(NSNumber*) paramLikeflg
	{
		[self.dataDict setValue: paramLikeflg forKey:@"likeflg"];
	}
	@dynamic tagflg;
	-(NSNumber*) tagflg
	{
		return [self.dataDict valueForKey:@"tagflg"];
	}
	-(void) setTagflg:(NSNumber*) paramTagflg
	{
		[self.dataDict setValue: paramTagflg forKey:@"tagflg"];
	}
	@dynamic followflg;
	-(NSNumber*) followflg
	{
		return [self.dataDict valueForKey:@"followflg"];
	}
	-(void) setFollowflg:(NSNumber*) paramFollowflg
	{
		[self.dataDict setValue: paramFollowflg forKey:@"followflg"];
	}
	@dynamic commentflg;
	-(NSNumber*) commentflg
	{
		return [self.dataDict valueForKey:@"commentflg"];
	}
	-(void) setCommentflg:(NSNumber*) paramCommentflg
	{
		[self.dataDict setValue: paramCommentflg forKey:@"commentflg"];
	}
	@dynamic uploadflg;
	-(NSNumber*) uploadflg
	{
		return [self.dataDict valueForKey:@"uploadflg"];
	}
	-(void) setUploadflg:(NSNumber*) paramUploadflg
	{
		[self.dataDict setValue: paramUploadflg forKey:@"uploadflg"];
	}
@end
