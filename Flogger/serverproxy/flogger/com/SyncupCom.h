#import "MyExternalaccount.h"
#import "ClientSystemParameter.h"
#import "BasePageParameter.h"
@interface SyncupCom : BasePageParameter
	@property (retain)NSMutableArray* externalaccounts;
	@property (retain)NSNumber* notificationCount;
	@property (retain)ClientSystemParameter* clientSystemParameter;
@end
