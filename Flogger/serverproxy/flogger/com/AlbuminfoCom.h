#import "Albuminfo.h"
#import "BasePageParameter.h"
@interface AlbuminfoCom : BasePageParameter
	@property (retain)NSNumber* type;
	@property (retain)NSMutableArray* albuminfoList;
	@property (retain)NSString* description;
	@property (retain)NSNumber* srcGroupID;
	@property (retain)NSNumber* destGroupID;
	@property (retain)NSNumber* mediaType;
	@property (retain)NSNumber* uploadFileSize;
	@property (retain)NSString* uploadFileID;
	@property (retain)NSNumber* startSize;
@end
