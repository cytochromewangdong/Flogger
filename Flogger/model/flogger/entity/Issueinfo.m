#import "Issueinfo.h"
@implementation Issueinfo
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
	@dynamic useruid;
	-(NSNumber*) useruid
	{
		return [self.dataDict valueForKey:@"useruid"];
	}
	-(void) setUseruid:(NSNumber*) paramUseruid
	{
		[self.dataDict setValue: paramUseruid forKey:@"useruid"];
	}
	@dynamic username;
	-(NSString*) username
	{
		return [self.dataDict valueForKey:@"username"];
	}
	-(void) setUsername:(NSString*) paramUsername
	{
		[self.dataDict setValue: paramUsername forKey:@"username"];
	}
	@dynamic nickname;
	-(NSString*) nickname
	{
		return [self.dataDict valueForKey:@"nickname"];
	}
	-(void) setNickname:(NSString*) paramNickname
	{
		[self.dataDict setValue: paramNickname forKey:@"nickname"];
	}
	@dynamic imageurl;
	-(NSString*) imageurl
	{
		return [self.dataDict valueForKey:@"imageurl"];
	}
	-(void) setImageurl:(NSString*) paramImageurl
	{
		[self.dataDict setValue: paramImageurl forKey:@"imageurl"];
	}
	@dynamic status;
	-(NSNumber*) status
	{
		return [self.dataDict valueForKey:@"status"];
	}
	-(void) setStatus:(NSNumber*) paramStatus
	{
		[self.dataDict setValue: paramStatus forKey:@"status"];
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
	@dynamic delflg;
	-(NSNumber*) delflg
	{
		return [self.dataDict valueForKey:@"delflg"];
	}
	-(void) setDelflg:(NSNumber*) paramDelflg
	{
		[self.dataDict setValue: paramDelflg forKey:@"delflg"];
	}
	@dynamic platform;
	-(NSString*) platform
	{
		return [self.dataDict valueForKey:@"platform"];
	}
	-(void) setPlatform:(NSString*) paramPlatform
	{
		[self.dataDict setValue: paramPlatform forKey:@"platform"];
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
	@dynamic province;
	-(NSString*) province
	{
		return [self.dataDict valueForKey:@"province"];
	}
	-(void) setProvince:(NSString*) paramProvince
	{
		[self.dataDict setValue: paramProvince forKey:@"province"];
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
	@dynamic targetid;
	-(NSNumber*) targetid
	{
		return [self.dataDict valueForKey:@"targetid"];
	}
	-(void) setTargetid:(NSNumber*) paramTargetid
	{
		[self.dataDict setValue: paramTargetid forKey:@"targetid"];
	}
	@dynamic issuetype;
	-(NSNumber*) issuetype
	{
		return [self.dataDict valueForKey:@"issuetype"];
	}
	-(void) setIssuetype:(NSNumber*) paramIssuetype
	{
		[self.dataDict setValue: paramIssuetype forKey:@"issuetype"];
	}
	@dynamic localurl;
	-(NSString*) localurl
	{
		return [self.dataDict valueForKey:@"localurl"];
	}
	-(void) setLocalurl:(NSString*) paramLocalurl
	{
		[self.dataDict setValue: paramLocalurl forKey:@"localurl"];
	}
	@dynamic hypertext;
	-(NSString*) hypertext
	{
		return [self.dataDict valueForKey:@"hypertext"];
	}
	-(void) setHypertext:(NSString*) paramHypertext
	{
		[self.dataDict setValue: paramHypertext forKey:@"hypertext"];
	}
	@dynamic bmiddleurl;
	-(NSString*) bmiddleurl
	{
		return [self.dataDict valueForKey:@"bmiddleurl"];
	}
	-(void) setBmiddleurl:(NSString*) paramBmiddleurl
	{
		[self.dataDict setValue: paramBmiddleurl forKey:@"bmiddleurl"];
	}
	@dynamic originalurl;
	-(NSString*) originalurl
	{
		return [self.dataDict valueForKey:@"originalurl"];
	}
	-(void) setOriginalurl:(NSString*) paramOriginalurl
	{
		[self.dataDict setValue: paramOriginalurl forKey:@"originalurl"];
	}
	@dynamic thumbnailurl;
	-(NSString*) thumbnailurl
	{
		return [self.dataDict valueForKey:@"thumbnailurl"];
	}
	-(void) setThumbnailurl:(NSString*) paramThumbnailurl
	{
		[self.dataDict setValue: paramThumbnailurl forKey:@"thumbnailurl"];
	}
	@dynamic videourl;
	-(NSString*) videourl
	{
		return [self.dataDict valueForKey:@"videourl"];
	}
	-(void) setVideourl:(NSString*) paramVideourl
	{
		[self.dataDict setValue: paramVideourl forKey:@"videourl"];
	}
	@dynamic postorurl;
	-(NSString*) postorurl
	{
		return [self.dataDict valueForKey:@"postorurl"];
	}
	-(void) setPostorurl:(NSString*) paramPostorurl
	{
		[self.dataDict setValue: paramPostorurl forKey:@"postorurl"];
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
	@dynamic privacylevel;
	-(NSNumber*) privacylevel
	{
		return [self.dataDict valueForKey:@"privacylevel"];
	}
	-(void) setPrivacylevel:(NSNumber*) paramPrivacylevel
	{
		[self.dataDict setValue: paramPrivacylevel forKey:@"privacylevel"];
	}
	@dynamic commentcnt;
	-(NSNumber*) commentcnt
	{
		return [self.dataDict valueForKey:@"commentcnt"];
	}
	-(void) setCommentcnt:(NSNumber*) paramCommentcnt
	{
		[self.dataDict setValue: paramCommentcnt forKey:@"commentcnt"];
	}
	@dynamic responsecnt;
	-(NSNumber*) responsecnt
	{
		return [self.dataDict valueForKey:@"responsecnt"];
	}
	-(void) setResponsecnt:(NSNumber*) paramResponsecnt
	{
		[self.dataDict setValue: paramResponsecnt forKey:@"responsecnt"];
	}
	@dynamic likecnt;
	-(NSNumber*) likecnt
	{
		return [self.dataDict valueForKey:@"likecnt"];
	}
	-(void) setLikecnt:(NSNumber*) paramLikecnt
	{
		[self.dataDict setValue: paramLikecnt forKey:@"likecnt"];
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
	@dynamic inspiredid;
	-(NSNumber*) inspiredid
	{
		return [self.dataDict valueForKey:@"inspiredid"];
	}
	-(void) setInspiredid:(NSNumber*) paramInspiredid
	{
		[self.dataDict setValue: paramInspiredid forKey:@"inspiredid"];
	}
	@dynamic inspiredname;
	-(NSString*) inspiredname
	{
		return [self.dataDict valueForKey:@"inspiredname"];
	}
	-(void) setInspiredname:(NSString*) paramInspiredname
	{
		[self.dataDict setValue: paramInspiredname forKey:@"inspiredname"];
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
	@dynamic videoduration;
	-(NSNumber*) videoduration
	{
		return [self.dataDict valueForKey:@"videoduration"];
	}
	-(void) setVideoduration:(NSNumber*) paramVideoduration
	{
		[self.dataDict setValue: paramVideoduration forKey:@"videoduration"];
	}
@end
