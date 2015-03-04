#import "BaseEntity.h"
@interface Externalplatform : BaseEntity
	@property (retain)NSString* name;
	@property (retain)NSNumber* id;
	@property (retain)NSNumber* delflg;
	@property (retain)NSString* platform;
	@property (retain)NSString* url;
	@property (retain)NSNumber* rowno;
	@property (retain)NSNumber* columnno;
	@property (retain)NSString* smallbutton;
	@property (retain)NSString* midbutton;
	@property (retain)NSString* bigbutton;
	@property (retain)NSString* apikey;
	@property (retain)NSString* secretkey;
	@property (retain)NSNumber* canshare;
	@property (retain)NSString* matchurl;
	@property (retain)NSNumber* chineseorder;
	@property (retain)NSNumber* otherorder;
@end
