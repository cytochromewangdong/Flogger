#import "GeoInfoCom.h"
@implementation GeoInfoCom
	@dynamic name;
	-(NSString*) name
	{
		return [self.dataDict valueForKey:@"name"];
	}
	-(void) setName:(NSString*) paramName
	{
		[self.dataDict setValue: paramName forKey:@"name"];
	}
	@dynamic geoInfoList;
	-(NSMutableArray*) geoInfoList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"geoInfoList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					GeographicalInfo* objGeographicalInfo=[[[GeographicalInfo alloc]init]autorelease];
					objGeographicalInfo.dataDict=row;
					[ret addObject:objGeographicalInfo];
				}
			}
		return ret;
	}
	-(void) setGeoInfoList:(NSMutableArray*) paramGeoInfoList
	{
		if(paramGeoInfoList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(GeographicalInfo *row in paramGeoInfoList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"geoInfoList"];
		} else
			[self.dataDict setValue: nil forKey:@"geoInfoList"];
	}
@end
