#import "ClientSystemParameter.h"
@implementation ClientSystemParameter
	@dynamic sharemode;
	-(NSString*) sharemode
	{
		return [self.dataDict valueForKey:@"sharemode"];
	}
	-(void) setSharemode:(NSString*) paramSharemode
	{
		[self.dataDict setValue: paramSharemode forKey:@"sharemode"];
	}
	@dynamic loguploadmode;
	-(NSString*) loguploadmode
	{
		return [self.dataDict valueForKey:@"loguploadmode"];
	}
	-(void) setLoguploadmode:(NSString*) paramLoguploadmode
	{
		[self.dataDict setValue: paramLoguploadmode forKey:@"loguploadmode"];
	}
	@dynamic loguploadinterval;
	-(NSString*) loguploadinterval
	{
		return [self.dataDict valueForKey:@"loguploadinterval"];
	}
	-(void) setLoguploadinterval:(NSString*) paramLoguploadinterval
	{
		[self.dataDict setValue: paramLoguploadinterval forKey:@"loguploadinterval"];
	}
	@dynamic maxuploadsize;
	-(NSString*) maxuploadsize
	{
		return [self.dataDict valueForKey:@"maxuploadsize"];
	}
	-(void) setMaxuploadsize:(NSString*) paramMaxuploadsize
	{
		[self.dataDict setValue: paramMaxuploadsize forKey:@"maxuploadsize"];
	}
	@dynamic thumbnailmode;
	-(NSString*) thumbnailmode
	{
		return [self.dataDict valueForKey:@"thumbnailmode"];
	}
	-(void) setThumbnailmode:(NSString*) paramThumbnailmode
	{
		[self.dataDict setValue: paramThumbnailmode forKey:@"thumbnailmode"];
	}
	@dynamic thumbnaisize;
	-(NSString*) thumbnaisize
	{
		return [self.dataDict valueForKey:@"thumbnaisize"];
	}
	-(void) setThumbnaisize:(NSString*) paramThumbnaisize
	{
		[self.dataDict setValue: paramThumbnaisize forKey:@"thumbnaisize"];
	}
	@dynamic imagesize;
	-(NSString*) imagesize
	{
		return [self.dataDict valueForKey:@"imagesize"];
	}
	-(void) setImagesize:(NSString*) paramImagesize
	{
		[self.dataDict setValue: paramImagesize forKey:@"imagesize"];
	}
	@dynamic imagequality;
	-(NSString*) imagequality
	{
		return [self.dataDict valueForKey:@"imagequality"];
	}
	-(void) setImagequality:(NSString*) paramImagequality
	{
		[self.dataDict setValue: paramImagequality forKey:@"imagequality"];
	}
	@dynamic forgetPasswordUrl;
	-(NSString*) forgetPasswordUrl
	{
		return [self.dataDict valueForKey:@"forgetPasswordUrl"];
	}
	-(void) setForgetPasswordUrl:(NSString*) paramForgetPasswordUrl
	{
		[self.dataDict setValue: paramForgetPasswordUrl forKey:@"forgetPasswordUrl"];
	}
	@dynamic shareExpireTime;
	-(NSNumber*) shareExpireTime
	{
		return [self.dataDict valueForKey:@"shareExpireTime"];
	}
	-(void) setShareExpireTime:(NSNumber*) paramShareExpireTime
	{
		[self.dataDict setValue: paramShareExpireTime forKey:@"shareExpireTime"];
	}
	@dynamic maxVideoDuration;
	-(NSNumber*) maxVideoDuration
	{
		return [self.dataDict valueForKey:@"maxVideoDuration"];
	}
	-(void) setMaxVideoDuration:(NSNumber*) paramMaxVideoDuration
	{
		[self.dataDict setValue: paramMaxVideoDuration forKey:@"maxVideoDuration"];
	}
@end
