#import "ClientSystemParameter.h"
#import "Externalplatform.h"
#import "BaseParameter.h"
@interface SystemConfigCom : BaseParameter
	@property (retain)ClientSystemParameter* clientSystemParameter;
	@property (retain)NSMutableArray* externalplatformList;
@end
