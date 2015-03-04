#import "IssueinfoT.h"
@implementation IssueinfoT
	@dynamic issuecategory;
	-(NSNumber*) issuecategory
	{
		return [self.dataDict valueForKey:@"issuecategory"];
	}
	-(void) setIssuecategory:(NSNumber*) paramIssuecategory
	{
		[self.dataDict setValue: paramIssuecategory forKey:@"issuecategory"];
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
	@dynamic targetid;
	-(NSNumber*) targetid
	{
		return [self.dataDict valueForKey:@"targetid"];
	}
	-(void) setTargetid:(NSNumber*) paramTargetid
	{
		[self.dataDict setValue: paramTargetid forKey:@"targetid"];
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
	@dynamic issuetype;
	-(NSNumber*) issuetype
	{
		return [self.dataDict valueForKey:@"issuetype"];
	}
	-(void) setIssuetype:(NSNumber*) paramIssuetype
	{
		[self.dataDict setValue: paramIssuetype forKey:@"issuetype"];
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
	@dynamic uploadfileid;
	-(NSString*) uploadfileid
	{
		return [self.dataDict valueForKey:@"uploadfileid"];
	}
	-(void) setUploadfileid:(NSString*) paramUploadfileid
	{
		[self.dataDict setValue: paramUploadfileid forKey:@"uploadfileid"];
	}
	@dynamic uploadsize;
	-(NSNumber*) uploadsize
	{
		return [self.dataDict valueForKey:@"uploadsize"];
	}
	-(void) setUploadsize:(NSNumber*) paramUploadsize
	{
		[self.dataDict setValue: paramUploadsize forKey:@"uploadsize"];
	}
	@dynamic tmpfilepath;
	-(NSString*) tmpfilepath
	{
		return [self.dataDict valueForKey:@"tmpfilepath"];
	}
	-(void) setTmpfilepath:(NSString*) paramTmpfilepath
	{
		[self.dataDict setValue: paramTmpfilepath forKey:@"tmpfilepath"];
	}
	@dynamic endsize;
	-(NSNumber*) endsize
	{
		return [self.dataDict valueForKey:@"endsize"];
	}
	-(void) setEndsize:(NSNumber*) paramEndsize
	{
		[self.dataDict setValue: paramEndsize forKey:@"endsize"];
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
	@dynamic text;
	-(NSString*) text
	{
		return [self.dataDict valueForKey:@"text"];
	}
	-(void) setText:(NSString*) paramText
	{
		[self.dataDict setValue: paramText forKey:@"text"];
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
@end
