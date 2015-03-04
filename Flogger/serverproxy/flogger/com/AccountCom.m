#import "AccountCom.h"
@implementation AccountCom
	@dynamic name;
	-(NSString*) name
	{
		return [self.dataDict valueForKey:@"name"];
	}
	-(void) setName:(NSString*) paramName
	{
		[self.dataDict setValue: paramName forKey:@"name"];
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
	@dynamic status;
	-(NSString*) status
	{
		return [self.dataDict valueForKey:@"status"];
	}
	-(void) setStatus:(NSString*) paramStatus
	{
		[self.dataDict setValue: paramStatus forKey:@"status"];
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
	@dynamic usersource;
	-(NSNumber*) usersource
	{
		return [self.dataDict valueForKey:@"usersource"];
	}
	-(void) setUsersource:(NSNumber*) paramUsersource
	{
		[self.dataDict setValue: paramUsersource forKey:@"usersource"];
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
	@dynamic email;
	-(NSString*) email
	{
		return [self.dataDict valueForKey:@"email"];
	}
	-(void) setEmail:(NSString*) paramEmail
	{
		[self.dataDict setValue: paramEmail forKey:@"email"];
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
	@dynamic biography;
	-(NSString*) biography
	{
		return [self.dataDict valueForKey:@"biography"];
	}
	-(void) setBiography:(NSString*) paramBiography
	{
		[self.dataDict setValue: paramBiography forKey:@"biography"];
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
	@dynamic userMediaCnt;
	-(NSNumber*) userMediaCnt
	{
		return [self.dataDict valueForKey:@"userMediaCnt"];
	}
	-(void) setUserMediaCnt:(NSNumber*) paramUserMediaCnt
	{
		[self.dataDict setValue: paramUserMediaCnt forKey:@"userMediaCnt"];
	}
	@dynamic description;
	-(NSString*) description
	{
		return [self.dataDict valueForKey:@"description"];
	}
	-(void) setDescription:(NSString*) paramDescription
	{
		[self.dataDict setValue: paramDescription forKey:@"description"];
	}
	@dynamic token;
	-(NSString*) token
	{
		return [self.dataDict valueForKey:@"token"];
	}
	-(void) setToken:(NSString*) paramToken
	{
		[self.dataDict setValue: paramToken forKey:@"token"];
	}
	@dynamic keyword;
	-(NSString*) keyword
	{
		return [self.dataDict valueForKey:@"keyword"];
	}
	-(void) setKeyword:(NSString*) paramKeyword
	{
		[self.dataDict setValue: paramKeyword forKey:@"keyword"];
	}
	@dynamic pushinfo;
	-(Pushinfo*) pushinfo
	{
		Pushinfo* ret=[[[Pushinfo alloc]init]autorelease];
		ret.dataDict=[self.dataDict valueForKey:@"pushinfo"];
		return ret;
	}
	-(void) setPushinfo:(Pushinfo*) paramPushinfo
	{
		[self.dataDict setValue: paramPushinfo.dataDict forKey:@"pushinfo"];
	}
	@dynamic userUID;
	-(NSNumber*) userUID
	{
		return [self.dataDict valueForKey:@"userUID"];
	}
	-(void) setUserUID:(NSNumber*) paramUserUID
	{
		[self.dataDict setValue: paramUserUID forKey:@"userUID"];
	}
	@dynamic externalUID;
	-(NSString*) externalUID
	{
		return [self.dataDict valueForKey:@"externalUID"];
	}
	-(void) setExternalUID:(NSString*) paramExternalUID
	{
		[self.dataDict setValue: paramExternalUID forKey:@"externalUID"];
	}
	@dynamic externalUser;
	-(NSString*) externalUser
	{
		return [self.dataDict valueForKey:@"externalUser"];
	}
	-(void) setExternalUser:(NSString*) paramExternalUser
	{
		[self.dataDict setValue: paramExternalUser forKey:@"externalUser"];
	}
	@dynamic firstname;
	-(NSString*) firstname
	{
		return [self.dataDict valueForKey:@"firstname"];
	}
	-(void) setFirstname:(NSString*) paramFirstname
	{
		[self.dataDict setValue: paramFirstname forKey:@"firstname"];
	}
	@dynamic lastname;
	-(NSString*) lastname
	{
		return [self.dataDict valueForKey:@"lastname"];
	}
	-(void) setLastname:(NSString*) paramLastname
	{
		[self.dataDict setValue: paramLastname forKey:@"lastname"];
	}
	@dynamic refreshToken;
	-(NSString*) refreshToken
	{
		return [self.dataDict valueForKey:@"refreshToken"];
	}
	-(void) setRefreshToken:(NSString*) paramRefreshToken
	{
		[self.dataDict setValue: paramRefreshToken forKey:@"refreshToken"];
	}
	@dynamic imageUrl;
	-(NSString*) imageUrl
	{
		return [self.dataDict valueForKey:@"imageUrl"];
	}
	-(void) setImageUrl:(NSString*) paramImageUrl
	{
		[self.dataDict setValue: paramImageUrl forKey:@"imageUrl"];
	}
	@dynamic oldPassword;
	-(NSString*) oldPassword
	{
		return [self.dataDict valueForKey:@"oldPassword"];
	}
	-(void) setOldPassword:(NSString*) paramOldPassword
	{
		[self.dataDict setValue: paramOldPassword forKey:@"oldPassword"];
	}
	@dynamic account;
	-(MyAccount*) account
	{
		MyAccount* ret=[[[MyAccount alloc]init]autorelease];
		ret.dataDict=[self.dataDict valueForKey:@"account"];
		return ret;
	}
	-(void) setAccount:(MyAccount*) paramAccount
	{
		[self.dataDict setValue: paramAccount.dataDict forKey:@"account"];
	}
	@dynamic nickName;
	-(NSString*) nickName
	{
		return [self.dataDict valueForKey:@"nickName"];
	}
	-(void) setNickName:(NSString*) paramNickName
	{
		[self.dataDict setValue: paramNickName forKey:@"nickName"];
	}
	@dynamic interests;
	-(NSString*) interests
	{
		return [self.dataDict valueForKey:@"interests"];
	}
	-(void) setInterests:(NSString*) paramInterests
	{
		[self.dataDict setValue: paramInterests forKey:@"interests"];
	}
	@dynamic galleryCount;
	-(NSNumber*) galleryCount
	{
		return [self.dataDict valueForKey:@"galleryCount"];
	}
	-(void) setGalleryCount:(NSNumber*) paramGalleryCount
	{
		[self.dataDict setValue: paramGalleryCount forKey:@"galleryCount"];
	}
	@dynamic hasImage;
	-(NSNumber*) hasImage
	{
		return [self.dataDict valueForKey:@"hasImage"];
	}
	-(void) setHasImage:(NSNumber*) paramHasImage
	{
		[self.dataDict setValue: paramHasImage forKey:@"hasImage"];
	}
	@dynamic expires;
	-(NSNumber*) expires
	{
		return [self.dataDict valueForKey:@"expires"];
	}
	-(void) setExpires:(NSNumber*) paramExpires
	{
		[self.dataDict setValue: paramExpires forKey:@"expires"];
	}
	@dynamic externalType;
	-(NSNumber*) externalType
	{
		return [self.dataDict valueForKey:@"externalType"];
	}
	-(void) setExternalType:(NSNumber*) paramExternalType
	{
		[self.dataDict setValue: paramExternalType forKey:@"externalType"];
	}
	@dynamic uploadType;
	-(NSNumber*) uploadType
	{
		return [self.dataDict valueForKey:@"uploadType"];
	}
	-(void) setUploadType:(NSNumber*) paramUploadType
	{
		[self.dataDict setValue: paramUploadType forKey:@"uploadType"];
	}
	@dynamic requestUrl;
	-(NSString*) requestUrl
	{
		return [self.dataDict valueForKey:@"requestUrl"];
	}
	-(void) setRequestUrl:(NSString*) paramRequestUrl
	{
		[self.dataDict setValue: paramRequestUrl forKey:@"requestUrl"];
	}
	@dynamic authorise;
	-(NSNumber*) authorise
	{
		return [self.dataDict valueForKey:@"authorise"];
	}
	-(void) setAuthorise:(NSNumber*) paramAuthorise
	{
		[self.dataDict setValue: paramAuthorise forKey:@"authorise"];
	}
	@dynamic requestToken;
	-(NSString*) requestToken
	{
		return [self.dataDict valueForKey:@"requestToken"];
	}
	-(void) setRequestToken:(NSString*) paramRequestToken
	{
		[self.dataDict setValue: paramRequestToken forKey:@"requestToken"];
	}
	@dynamic tokenSecret;
	-(NSString*) tokenSecret
	{
		return [self.dataDict valueForKey:@"tokenSecret"];
	}
	-(void) setTokenSecret:(NSString*) paramTokenSecret
	{
		[self.dataDict setValue: paramTokenSecret forKey:@"tokenSecret"];
	}
	@dynamic verifier;
	-(NSString*) verifier
	{
		return [self.dataDict valueForKey:@"verifier"];
	}
	-(void) setVerifier:(NSString*) paramVerifier
	{
		[self.dataDict setValue: paramVerifier forKey:@"verifier"];
	}
	@dynamic openid;
	-(NSString*) openid
	{
		return [self.dataDict valueForKey:@"openid"];
	}
	-(void) setOpenid:(NSString*) paramOpenid
	{
		[self.dataDict setValue: paramOpenid forKey:@"openid"];
	}
	@dynamic cursor;
	-(NSNumber*) cursor
	{
		return [self.dataDict valueForKey:@"cursor"];
	}
	-(void) setCursor:(NSNumber*) paramCursor
	{
		[self.dataDict setValue: paramCursor forKey:@"cursor"];
	}
	@dynamic externalFriendsPage;
	-(NSNumber*) externalFriendsPage
	{
		return [self.dataDict valueForKey:@"externalFriendsPage"];
	}
	-(void) setExternalFriendsPage:(NSNumber*) paramExternalFriendsPage
	{
		[self.dataDict setValue: paramExternalFriendsPage forKey:@"externalFriendsPage"];
	}
	@dynamic accountList;
	-(NSMutableArray*) accountList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"accountList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyAccount* objMyAccount=[[[MyAccount alloc]init]autorelease];
					objMyAccount.dataDict=row;
					[ret addObject:objMyAccount];
				}
			}
		return ret;
	}
	-(void) setAccountList:(NSMutableArray*) paramAccountList
	{
		if(paramAccountList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyAccount *row in paramAccountList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"accountList"];
		} else
			[self.dataDict setValue: nil forKey:@"accountList"];
	}
	@dynamic externalaccounts;
	-(NSMutableArray*) externalaccounts
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"externalaccounts"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyExternalaccount* objMyExternalaccount=[[[MyExternalaccount alloc]init]autorelease];
					objMyExternalaccount.dataDict=row;
					[ret addObject:objMyExternalaccount];
				}
			}
		return ret;
	}
	-(void) setExternalaccounts:(NSMutableArray*) paramExternalaccounts
	{
		if(paramExternalaccounts){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyExternalaccount *row in paramExternalaccounts) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"externalaccounts"];
		} else
			[self.dataDict setValue: nil forKey:@"externalaccounts"];
	}
	@dynamic shareSettingList;
	-(NSMutableArray*) shareSettingList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"shareSettingList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					ShareSettingBean* objShareSettingBean=[[[ShareSettingBean alloc]init]autorelease];
					objShareSettingBean.dataDict=row;
					[ret addObject:objShareSettingBean];
				}
			}
		return ret;
	}
	-(void) setShareSettingList:(NSMutableArray*) paramShareSettingList
	{
		if(paramShareSettingList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(ShareSettingBean *row in paramShareSettingList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"shareSettingList"];
		} else
			[self.dataDict setValue: nil forKey:@"shareSettingList"];
	}
	@dynamic notificationCount;
	-(NSNumber*) notificationCount
	{
		return [self.dataDict valueForKey:@"notificationCount"];
	}
	-(void) setNotificationCount:(NSNumber*) paramNotificationCount
	{
		[self.dataDict setValue: paramNotificationCount forKey:@"notificationCount"];
	}
	@dynamic albumID;
	-(NSNumber*) albumID
	{
		return [self.dataDict valueForKey:@"albumID"];
	}
	-(void) setAlbumID:(NSNumber*) paramAlbumID
	{
		[self.dataDict setValue: paramAlbumID forKey:@"albumID"];
	}
	@dynamic uploadFileSize;
	-(NSNumber*) uploadFileSize
	{
		return [self.dataDict valueForKey:@"uploadFileSize"];
	}
	-(void) setUploadFileSize:(NSNumber*) paramUploadFileSize
	{
		[self.dataDict setValue: paramUploadFileSize forKey:@"uploadFileSize"];
	}
	@dynamic pushtoken;
	-(NSString*) pushtoken
	{
		return [self.dataDict valueForKey:@"pushtoken"];
	}
	-(void) setPushtoken:(NSString*) paramPushtoken
	{
		[self.dataDict setValue: paramPushtoken forKey:@"pushtoken"];
	}
	@dynamic contactList;
	-(NSMutableArray*) contactList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"contactList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					AddressBookInfo* objAddressBookInfo=[[[AddressBookInfo alloc]init]autorelease];
					objAddressBookInfo.dataDict=row;
					[ret addObject:objAddressBookInfo];
				}
			}
		return ret;
	}
	-(void) setContactList:(NSMutableArray*) paramContactList
	{
		if(paramContactList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(AddressBookInfo *row in paramContactList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"contactList"];
		} else
			[self.dataDict setValue: nil forKey:@"contactList"];
	}
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
	@dynamic firstLogin;
	-(NSNumber*) firstLogin
	{
		return [self.dataDict valueForKey:@"firstLogin"];
	}
	-(void) setFirstLogin:(NSNumber*) paramFirstLogin
	{
		[self.dataDict setValue: paramFirstLogin forKey:@"firstLogin"];
	}
	@dynamic phoneNo;
	-(NSString*) phoneNo
	{
		return [self.dataDict valueForKey:@"phoneNo"];
	}
	-(void) setPhoneNo:(NSString*) paramPhoneNo
	{
		[self.dataDict setValue: paramPhoneNo forKey:@"phoneNo"];
	}
	@dynamic inviteFriendContent;
	-(NSString*) inviteFriendContent
	{
		return [self.dataDict valueForKey:@"inviteFriendContent"];
	}
	-(void) setInviteFriendContent:(NSString*) paramInviteFriendContent
	{
		[self.dataDict setValue: paramInviteFriendContent forKey:@"inviteFriendContent"];
	}
	@dynamic smsMessage;
	-(NSString*) smsMessage
	{
		return [self.dataDict valueForKey:@"smsMessage"];
	}
	-(void) setSmsMessage:(NSString*) paramSmsMessage
	{
		[self.dataDict setValue: paramSmsMessage forKey:@"smsMessage"];
	}
	@dynamic emailMessage;
	-(NSString*) emailMessage
	{
		return [self.dataDict valueForKey:@"emailMessage"];
	}
	-(void) setEmailMessage:(NSString*) paramEmailMessage
	{
		[self.dataDict setValue: paramEmailMessage forKey:@"emailMessage"];
	}
@end
