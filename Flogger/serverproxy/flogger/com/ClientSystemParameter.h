#import "BaseModel.h"
@interface ClientSystemParameter : BaseModel
	@property (retain)NSString* sharemode;
	@property (retain)NSString* loguploadmode;
	@property (retain)NSString* loguploadinterval;
	@property (retain)NSString* maxuploadsize;
	@property (retain)NSString* thumbnailmode;
	@property (retain)NSString* thumbnaisize;
	@property (retain)NSString* imagesize;
	@property (retain)NSString* imagequality;
	@property (retain)NSString* forgetPasswordUrl;
	@property (retain)NSNumber* shareExpireTime;
	@property (retain)NSNumber* maxVideoDuration;
@end
