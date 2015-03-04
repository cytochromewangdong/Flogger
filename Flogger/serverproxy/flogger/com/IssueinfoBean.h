#import "BaseModel.h"
@interface IssueinfoBean : BaseModel
	@property (retain)NSString* location;
	@property (retain)NSNumber* id;
	@property (retain)NSString* country;
	@property (retain)NSNumber* parentid;
	@property (retain)NSString* city;
	@property (retain)NSNumber* issuecategory;
	@property (retain)NSString* text;
	@property (retain)NSNumber* shoottime;
	@property (retain)NSString* shootlocation;
	@property (retain)NSNumber* shootlon;
	@property (retain)NSNumber* shootlat;
	@property (retain)NSNumber* playcnt;
	@property (retain)NSString* filtersyntax;
	@property (retain)NSNumber* photowidth;
	@property (retain)NSNumber* photoheight;
	@property (retain)NSString* videoDirection;
	@property (retain)NSNumber* videoDuration;
@end
