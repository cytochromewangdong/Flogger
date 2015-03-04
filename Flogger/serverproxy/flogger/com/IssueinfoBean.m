#import "IssueinfoBean.h"
@implementation IssueinfoBean
	@dynamic location;
	-(NSString*) location
	{
		return [self.dataDict valueForKey:@"location"];
	}
	-(void) setLocation:(NSString*) paramLocation
	{
		[self.dataDict setValue: paramLocation forKey:@"location"];
	}
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
	}
	@dynamic country;
	-(NSString*) country
	{
		return [self.dataDict valueForKey:@"country"];
	}
	-(void) setCountry:(NSString*) paramCountry
	{
		[self.dataDict setValue: paramCountry forKey:@"country"];
	}
	@dynamic parentid;
	-(NSNumber*) parentid
	{
		return [self.dataDict valueForKey:@"parentid"];
	}
	-(void) setParentid:(NSNumber*) paramParentid
	{
		[self.dataDict setValue: paramParentid forKey:@"parentid"];
	}
	@dynamic city;
	-(NSString*) city
	{
		return [self.dataDict valueForKey:@"city"];
	}
	-(void) setCity:(NSString*) paramCity
	{
		[self.dataDict setValue: paramCity forKey:@"city"];
	}
	@dynamic issuecategory;
	-(NSNumber*) issuecategory
	{
		return [self.dataDict valueForKey:@"issuecategory"];
	}
	-(void) setIssuecategory:(NSNumber*) paramIssuecategory
	{
		[self.dataDict setValue: paramIssuecategory forKey:@"issuecategory"];
	}
	@dynamic text;
	-(NSString*) text
	{
		return [self.dataDict valueForKey:@"text"];
	}
	-(void) setText:(NSString*) paramText
	{
		[self.dataDict setValue: paramText forKey:@"text"];
	}
	@dynamic shoottime;
	-(NSNumber*) shoottime
	{
		return [self.dataDict valueForKey:@"shoottime"];
	}
	-(void) setShoottime:(NSNumber*) paramShoottime
	{
		[self.dataDict setValue: paramShoottime forKey:@"shoottime"];
	}
	@dynamic shootlocation;
	-(NSString*) shootlocation
	{
		return [self.dataDict valueForKey:@"shootlocation"];
	}
	-(void) setShootlocation:(NSString*) paramShootlocation
	{
		[self.dataDict setValue: paramShootlocation forKey:@"shootlocation"];
	}
	@dynamic shootlon;
	-(NSNumber*) shootlon
	{
		return [self.dataDict valueForKey:@"shootlon"];
	}
	-(void) setShootlon:(NSNumber*) paramShootlon
	{
		[self.dataDict setValue: paramShootlon forKey:@"shootlon"];
	}
	@dynamic shootlat;
	-(NSNumber*) shootlat
	{
		return [self.dataDict valueForKey:@"shootlat"];
	}
	-(void) setShootlat:(NSNumber*) paramShootlat
	{
		[self.dataDict setValue: paramShootlat forKey:@"shootlat"];
	}
	@dynamic playcnt;
	-(NSNumber*) playcnt
	{
		return [self.dataDict valueForKey:@"playcnt"];
	}
	-(void) setPlaycnt:(NSNumber*) paramPlaycnt
	{
		[self.dataDict setValue: paramPlaycnt forKey:@"playcnt"];
	}
	@dynamic filtersyntax;
	-(NSString*) filtersyntax
	{
		return [self.dataDict valueForKey:@"filtersyntax"];
	}
	-(void) setFiltersyntax:(NSString*) paramFiltersyntax
	{
		[self.dataDict setValue: paramFiltersyntax forKey:@"filtersyntax"];
	}
	@dynamic photowidth;
	-(NSNumber*) photowidth
	{
		return [self.dataDict valueForKey:@"photowidth"];
	}
	-(void) setPhotowidth:(NSNumber*) paramPhotowidth
	{
		[self.dataDict setValue: paramPhotowidth forKey:@"photowidth"];
	}
	@dynamic photoheight;
	-(NSNumber*) photoheight
	{
		return [self.dataDict valueForKey:@"photoheight"];
	}
	-(void) setPhotoheight:(NSNumber*) paramPhotoheight
	{
		[self.dataDict setValue: paramPhotoheight forKey:@"photoheight"];
	}
	@dynamic videoDirection;
	-(NSString*) videoDirection
	{
		return [self.dataDict valueForKey:@"videoDirection"];
	}
	-(void) setVideoDirection:(NSString*) paramVideoDirection
	{
		[self.dataDict setValue: paramVideoDirection forKey:@"videoDirection"];
	}
	@dynamic videoDuration;
	-(NSNumber*) videoDuration
	{
		return [self.dataDict valueForKey:@"videoDuration"];
	}
	-(void) setVideoDuration:(NSNumber*) paramVideoDuration
	{
		[self.dataDict setValue: paramVideoDuration forKey:@"videoDuration"];
	}
@end
