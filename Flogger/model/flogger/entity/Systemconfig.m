#import "Systemconfig.h"
@implementation Systemconfig
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
	@dynamic countperiod;
	-(NSNumber*) countperiod
	{
		return [self.dataDict valueForKey:@"countperiod"];
	}
	-(void) setCountperiod:(NSNumber*) paramCountperiod
	{
		[self.dataDict setValue: paramCountperiod forKey:@"countperiod"];
	}
	@dynamic sharemode;
	-(NSNumber*) sharemode
	{
		return [self.dataDict valueForKey:@"sharemode"];
	}
	-(void) setSharemode:(NSNumber*) paramSharemode
	{
		[self.dataDict setValue: paramSharemode forKey:@"sharemode"];
	}
	@dynamic loguploadmode;
	-(NSNumber*) loguploadmode
	{
		return [self.dataDict valueForKey:@"loguploadmode"];
	}
	-(void) setLoguploadmode:(NSNumber*) paramLoguploadmode
	{
		[self.dataDict setValue: paramLoguploadmode forKey:@"loguploadmode"];
	}
	@dynamic loguploadinterval;
	-(NSNumber*) loguploadinterval
	{
		return [self.dataDict valueForKey:@"loguploadinterval"];
	}
	-(void) setLoguploadinterval:(NSNumber*) paramLoguploadinterval
	{
		[self.dataDict setValue: paramLoguploadinterval forKey:@"loguploadinterval"];
	}
	@dynamic maxuploadsize;
	-(NSNumber*) maxuploadsize
	{
		return [self.dataDict valueForKey:@"maxuploadsize"];
	}
	-(void) setMaxuploadsize:(NSNumber*) paramMaxuploadsize
	{
		[self.dataDict setValue: paramMaxuploadsize forKey:@"maxuploadsize"];
	}
	@dynamic thumbnailmode;
	-(NSNumber*) thumbnailmode
	{
		return [self.dataDict valueForKey:@"thumbnailmode"];
	}
	-(void) setThumbnailmode:(NSNumber*) paramThumbnailmode
	{
		[self.dataDict setValue: paramThumbnailmode forKey:@"thumbnailmode"];
	}
	@dynamic thumbnailsize;
	-(NSString*) thumbnailsize
	{
		return [self.dataDict valueForKey:@"thumbnailsize"];
	}
	-(void) setThumbnailsize:(NSString*) paramThumbnailsize
	{
		[self.dataDict setValue: paramThumbnailsize forKey:@"thumbnailsize"];
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
@end
