#import "SystemConfigCom.h"
@implementation SystemConfigCom
	@dynamic clientSystemParameter;
	-(ClientSystemParameter*) clientSystemParameter
	{
		ClientSystemParameter* ret=[[[ClientSystemParameter alloc]init]autorelease];
		ret.dataDict=[self.dataDict valueForKey:@"clientSystemParameter"];
		return ret;
	}
	-(void) setClientSystemParameter:(ClientSystemParameter*) paramClientSystemParameter
	{
		[self.dataDict setValue: paramClientSystemParameter.dataDict forKey:@"clientSystemParameter"];
	}
	@dynamic externalplatformList;
	-(NSMutableArray*) externalplatformList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"externalplatformList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					Externalplatform* objExternalplatform=[[[Externalplatform alloc]init]autorelease];
					objExternalplatform.dataDict=row;
					[ret addObject:objExternalplatform];
				}
			}
		return ret;
	}
	-(void) setExternalplatformList:(NSMutableArray*) paramExternalplatformList
	{
		if(paramExternalplatformList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(Externalplatform *row in paramExternalplatformList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"externalplatformList"];
		} else
			[self.dataDict setValue: nil forKey:@"externalplatformList"];
	}
@end
