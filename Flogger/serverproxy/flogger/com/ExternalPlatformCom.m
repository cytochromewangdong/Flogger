#import "ExternalPlatformCom.h"
@implementation ExternalPlatformCom
	@dynamic version;
	-(NSString*) version
	{
		return [self.dataDict valueForKey:@"version"];
	}
	-(void) setVersion:(NSString*) paramVersion
	{
		[self.dataDict setValue: paramVersion forKey:@"version"];
	}
	@dynamic externalplatforms;
	-(NSMutableArray*) externalplatforms
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"externalplatforms"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyExternalPlatform* objMyExternalPlatform=[[[MyExternalPlatform alloc]init]autorelease];
					objMyExternalPlatform.dataDict=row;
					[ret addObject:objMyExternalPlatform];
				}
			}
		return ret;
	}
	-(void) setExternalplatforms:(NSMutableArray*) paramExternalplatforms
	{
		if(paramExternalplatforms){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyExternalPlatform *row in paramExternalplatforms) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"externalplatforms"];
		} else
			[self.dataDict setValue: nil forKey:@"externalplatforms"];
	}
@end
