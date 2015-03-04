#import "MyAlbumInfo.h"
@implementation MyAlbumInfo
	@dynamic videoduration;
	-(NSNumber*) videoduration
	{
		return [self.dataDict valueForKey:@"videoduration"];
	}
	-(void) setVideoduration:(NSNumber*) paramVideoduration
	{
		[self.dataDict setValue: paramVideoduration forKey:@"videoduration"];
	}
	@dynamic middleUrl;
	-(NSString*) middleUrl
	{
		return [self.dataDict valueForKey:@"middleUrl"];
	}
	-(void) setMiddleUrl:(NSString*) paramMiddleUrl
	{
		[self.dataDict setValue: paramMiddleUrl forKey:@"middleUrl"];
	}
	@dynamic shareMediaUrl;
	-(NSString*) shareMediaUrl
	{
		return [self.dataDict valueForKey:@"shareMediaUrl"];
	}
	-(void) setShareMediaUrl:(NSString*) paramShareMediaUrl
	{
		[self.dataDict setValue: paramShareMediaUrl forKey:@"shareMediaUrl"];
	}
@end
