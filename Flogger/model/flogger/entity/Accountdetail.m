#import "Accountdetail.h"
@implementation Accountdetail
	@dynamic location;
	-(NSString*) location
	{
		return [self.dataDict valueForKey:@"location"];
	}
	-(void) setLocation:(NSString*) paramLocation
	{
		[self.dataDict setValue: paramLocation forKey:@"location"];
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
	@dynamic status;
	-(NSString*) status
	{
		return [self.dataDict valueForKey:@"status"];
	}
	-(void) setStatus:(NSString*) paramStatus
	{
		[self.dataDict setValue: paramStatus forKey:@"status"];
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
	@dynamic lname;
	-(NSString*) lname
	{
		return [self.dataDict valueForKey:@"lname"];
	}
	-(void) setLname:(NSString*) paramLname
	{
		[self.dataDict setValue: paramLname forKey:@"lname"];
	}
	@dynamic fname;
	-(NSString*) fname
	{
		return [self.dataDict valueForKey:@"fname"];
	}
	-(void) setFname:(NSString*) paramFname
	{
		[self.dataDict setValue: paramFname forKey:@"fname"];
	}
	@dynamic gender;
	-(NSNumber*) gender
	{
		return [self.dataDict valueForKey:@"gender"];
	}
	-(void) setGender:(NSNumber*) paramGender
	{
		[self.dataDict setValue: paramGender forKey:@"gender"];
	}
	@dynamic birthday;
	-(NSNumber*) birthday
	{
		return [self.dataDict valueForKey:@"birthday"];
	}
	-(void) setBirthday:(NSNumber*) paramBirthday
	{
		[self.dataDict setValue: paramBirthday forKey:@"birthday"];
	}
	@dynamic age;
	-(NSNumber*) age
	{
		return [self.dataDict valueForKey:@"age"];
	}
	-(void) setAge:(NSNumber*) paramAge
	{
		[self.dataDict setValue: paramAge forKey:@"age"];
	}
	@dynamic mobile;
	-(NSString*) mobile
	{
		return [self.dataDict valueForKey:@"mobile"];
	}
	-(void) setMobile:(NSString*) paramMobile
	{
		[self.dataDict setValue: paramMobile forKey:@"mobile"];
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
	@dynamic biography;
	-(NSString*) biography
	{
		return [self.dataDict valueForKey:@"biography"];
	}
	-(void) setBiography:(NSString*) paramBiography
	{
		[self.dataDict setValue: paramBiography forKey:@"biography"];
	}
	@dynamic interest;
	-(NSString*) interest
	{
		return [self.dataDict valueForKey:@"interest"];
	}
	-(void) setInterest:(NSString*) paramInterest
	{
		[self.dataDict setValue: paramInterest forKey:@"interest"];
	}
	@dynamic usersource;
	-(NSNumber*) usersource
	{
		return [self.dataDict valueForKey:@"usersource"];
	}
	-(void) setUsersource:(NSNumber*) paramUsersource
	{
		[self.dataDict setValue: paramUsersource forKey:@"usersource"];
	}
	@dynamic usersourcename;
	-(NSString*) usersourcename
	{
		return [self.dataDict valueForKey:@"usersourcename"];
	}
	-(void) setUsersourcename:(NSString*) paramUsersourcename
	{
		[self.dataDict setValue: paramUsersourcename forKey:@"usersourcename"];
	}
	@dynamic externaluid;
	-(NSString*) externaluid
	{
		return [self.dataDict valueForKey:@"externaluid"];
	}
	-(void) setExternaluid:(NSString*) paramExternaluid
	{
		[self.dataDict setValue: paramExternaluid forKey:@"externaluid"];
	}
	@dynamic externalusername;
	-(NSString*) externalusername
	{
		return [self.dataDict valueForKey:@"externalusername"];
	}
	-(void) setExternalusername:(NSString*) paramExternalusername
	{
		[self.dataDict setValue: paramExternalusername forKey:@"externalusername"];
	}
	@dynamic website;
	-(NSString*) website
	{
		return [self.dataDict valueForKey:@"website"];
	}
	-(void) setWebsite:(NSString*) paramWebsite
	{
		[self.dataDict setValue: paramWebsite forKey:@"website"];
	}
	@dynamic url;
	-(NSString*) url
	{
		return [self.dataDict valueForKey:@"url"];
	}
	-(void) setUrl:(NSString*) paramUrl
	{
		[self.dataDict setValue: paramUrl forKey:@"url"];
	}
	@dynamic bifollowerscnt;
	-(NSNumber*) bifollowerscnt
	{
		return [self.dataDict valueForKey:@"bifollowerscnt"];
	}
	-(void) setBifollowerscnt:(NSNumber*) paramBifollowerscnt
	{
		[self.dataDict setValue: paramBifollowerscnt forKey:@"bifollowerscnt"];
	}
	@dynamic md5mobile;
	-(NSString*) md5mobile
	{
		return [self.dataDict valueForKey:@"md5mobile"];
	}
	-(void) setMd5mobile:(NSString*) paramMd5mobile
	{
		[self.dataDict setValue: paramMd5mobile forKey:@"md5mobile"];
	}
	@dynamic domain;
	-(NSString*) domain
	{
		return [self.dataDict valueForKey:@"domain"];
	}
	-(void) setDomain:(NSString*) paramDomain
	{
		[self.dataDict setValue: paramDomain forKey:@"domain"];
	}
	@dynamic following;
	-(NSNumber*) following
	{
		return [self.dataDict valueForKey:@"following"];
	}
	-(void) setFollowing:(NSNumber*) paramFollowing
	{
		[self.dataDict setValue: paramFollowing forKey:@"following"];
	}
	@dynamic allowallactmsg;
	-(NSNumber*) allowallactmsg
	{
		return [self.dataDict valueForKey:@"allowallactmsg"];
	}
	-(void) setAllowallactmsg:(NSNumber*) paramAllowallactmsg
	{
		[self.dataDict setValue: paramAllowallactmsg forKey:@"allowallactmsg"];
	}
	@dynamic geoenabled;
	-(NSNumber*) geoenabled
	{
		return [self.dataDict valueForKey:@"geoenabled"];
	}
	-(void) setGeoenabled:(NSNumber*) paramGeoenabled
	{
		[self.dataDict setValue: paramGeoenabled forKey:@"geoenabled"];
	}
	@dynamic allowallcomment;
	-(NSNumber*) allowallcomment
	{
		return [self.dataDict valueForKey:@"allowallcomment"];
	}
	-(void) setAllowallcomment:(NSNumber*) paramAllowallcomment
	{
		[self.dataDict setValue: paramAllowallcomment forKey:@"allowallcomment"];
	}
	@dynamic avatarlarge;
	-(NSString*) avatarlarge
	{
		return [self.dataDict valueForKey:@"avatarlarge"];
	}
	-(void) setAvatarlarge:(NSString*) paramAvatarlarge
	{
		[self.dataDict setValue: paramAvatarlarge forKey:@"avatarlarge"];
	}
	@dynamic followme;
	-(NSNumber*) followme
	{
		return [self.dataDict valueForKey:@"followme"];
	}
	-(void) setFollowme:(NSNumber*) paramFollowme
	{
		[self.dataDict setValue: paramFollowme forKey:@"followme"];
	}
	@dynamic onlinestatus;
	-(NSNumber*) onlinestatus
	{
		return [self.dataDict valueForKey:@"onlinestatus"];
	}
	-(void) setOnlinestatus:(NSNumber*) paramOnlinestatus
	{
		[self.dataDict setValue: paramOnlinestatus forKey:@"onlinestatus"];
	}
@end
