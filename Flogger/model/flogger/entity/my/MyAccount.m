#import "MyAccount.h"
@implementation MyAccount
	@dynamic location;
	-(NSString*) location
	{
		return [self.dataDict valueForKey:@"location"];
	}
	-(void) setLocation:(NSString*) paramLocation
	{
		[self.dataDict setValue: paramLocation forKey:@"location"];
	}
	@dynamic type;
	-(NSNumber*) type
	{
		return [self.dataDict valueForKey:@"type"];
	}
	-(void) setType:(NSNumber*) paramType
	{
		[self.dataDict setValue: paramType forKey:@"type"];
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
	-(NSString*) status
	{
		return [self.dataDict valueForKey:@"status"];
	}
	-(void) setStatus:(NSString*) paramStatus
	{
		[self.dataDict setValue: paramStatus forKey:@"status"];
	}
	@dynamic followed;
	-(NSNumber*) followed
	{
		return [self.dataDict valueForKey:@"followed"];
	}
	-(void) setFollowed:(NSNumber*) paramFollowed
	{
		[self.dataDict setValue: paramFollowed forKey:@"followed"];
	}
	@dynamic password;
	-(NSString*) password
	{
		return [self.dataDict valueForKey:@"password"];
	}
	-(void) setPassword:(NSString*) paramPassword
	{
		[self.dataDict setValue: paramPassword forKey:@"password"];
	}
	@dynamic random;
	-(NSString*) random
	{
		return [self.dataDict valueForKey:@"random"];
	}
	-(void) setRandom:(NSString*) paramRandom
	{
		[self.dataDict setValue: paramRandom forKey:@"random"];
	}
	@dynamic email;
	-(NSString*) email
	{
		return [self.dataDict valueForKey:@"email"];
	}
	-(void) setEmail:(NSString*) paramEmail
	{
		[self.dataDict setValue: paramEmail forKey:@"email"];
	}
	@dynamic logintype;
	-(NSNumber*) logintype
	{
		return [self.dataDict valueForKey:@"logintype"];
	}
	-(void) setLogintype:(NSNumber*) paramLogintype
	{
		[self.dataDict setValue: paramLogintype forKey:@"logintype"];
	}
	@dynamic binding;
	-(NSNumber*) binding
	{
		return [self.dataDict valueForKey:@"binding"];
	}
	-(void) setBinding:(NSNumber*) paramBinding
	{
		[self.dataDict setValue: paramBinding forKey:@"binding"];
	}
	@dynamic serverurl;
	-(NSString*) serverurl
	{
		return [self.dataDict valueForKey:@"serverurl"];
	}
	-(void) setServerurl:(NSString*) paramServerurl
	{
		[self.dataDict setValue: paramServerurl forKey:@"serverurl"];
	}
	@dynamic emailverified;
	-(NSNumber*) emailverified
	{
		return [self.dataDict valueForKey:@"emailverified"];
	}
	-(void) setEmailverified:(NSNumber*) paramEmailverified
	{
		[self.dataDict setValue: paramEmailverified forKey:@"emailverified"];
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
	@dynamic issueList;
	-(NSMutableArray*) issueList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"issueList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyIssueInfo* objMyIssueInfo=[[[MyIssueInfo alloc]init]autorelease];
					objMyIssueInfo.dataDict=row;
					[ret addObject:objMyIssueInfo];
				}
			}
		return ret;
	}
	-(void) setIssueList:(NSMutableArray*) paramIssueList
	{
		if(paramIssueList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyIssueInfo *row in paramIssueList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"issueList"];
		} else
			[self.dataDict setValue: nil forKey:@"issueList"];
	}
	@dynamic friendshipid;
	-(NSNumber*) friendshipid
	{
		return [self.dataDict valueForKey:@"friendshipid"];
	}
	-(void) setFriendshipid:(NSNumber*) paramFriendshipid
	{
		[self.dataDict setValue: paramFriendshipid forKey:@"friendshipid"];
	}
@end
