#import "BaseEntity.h"
@interface Systemconfig : BaseEntity
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSNumber* countperiod;
	@property (retain)NSNumber* sharemode;
	@property (retain)NSNumber* loguploadmode;
	@property (retain)NSNumber* loguploadinterval;
	@property (retain)NSNumber* maxuploadsize;
	@property (retain)NSNumber* thumbnailmode;
	@property (retain)NSString* thumbnailsize;
	@property (retain)NSString* imagesize;
@end
