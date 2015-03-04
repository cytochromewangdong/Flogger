#import "MyIssueInfo.h"
#import "Pushinfo.h"
#import "MyAccount.h"
#import "MyExternalaccount.h"
#import "ShareSettingBean.h"
#import "AddressBookInfo.h"
#import "ClientSystemParameter.h"
#import "BasePageParameter.h"
@interface AccountCom : BasePageParameter
	@property (retain)NSString* name;
	@property (retain)NSNumber* type;
	@property (retain)NSString* username;
	@property (retain)NSString* status;
	@property (retain)NSString* usersourcename;
	@property (retain)NSNumber* usersource;
	@property (retain)NSString* password;
	@property (retain)NSString* email;
	@property (retain)NSNumber* gender;
	@property (retain)NSString* biography;
	@property (retain)NSString* website;
	@property (retain)NSMutableArray* issueList;
	@property (retain)NSNumber* userMediaCnt;
	@property (retain)NSString* description;
	@property (retain)NSString* token;
	@property (retain)NSString* keyword;
	@property (retain)Pushinfo* pushinfo;
	@property (retain)NSNumber* userUID;
	@property (retain)NSString* externalUID;
	@property (retain)NSString* externalUser;
	@property (retain)NSString* firstname;
	@property (retain)NSString* lastname;
	@property (retain)NSString* refreshToken;
	@property (retain)NSString* imageUrl;
	@property (retain)NSString* oldPassword;
	@property (retain)MyAccount* account;
	@property (retain)NSString* nickName;
	@property (retain)NSString* interests;
	@property (retain)NSNumber* galleryCount;
	@property (retain)NSNumber* hasImage;
	@property (retain)NSNumber* expires;
	@property (retain)NSNumber* externalType;
	@property (retain)NSNumber* uploadType;
	@property (retain)NSString* requestUrl;
	@property (retain)NSNumber* authorise;
	@property (retain)NSString* requestToken;
	@property (retain)NSString* tokenSecret;
	@property (retain)NSString* verifier;
	@property (retain)NSString* openid;
	@property (retain)NSNumber* cursor;
	@property (retain)NSNumber* externalFriendsPage;
	@property (retain)NSMutableArray* accountList;
	@property (retain)NSMutableArray* externalaccounts;
	@property (retain)NSMutableArray* shareSettingList;
	@property (retain)NSNumber* notificationCount;
	@property (retain)NSNumber* albumID;
	@property (retain)NSNumber* uploadFileSize;
	@property (retain)NSString* pushtoken;
	@property (retain)NSMutableArray* contactList;
	@property (retain)ClientSystemParameter* clientSystemParameter;
	@property (retain)NSNumber* firstLogin;
	@property (retain)NSString* phoneNo;
	@property (retain)NSString* inviteFriendContent;
	@property (retain)NSString* smsMessage;
	@property (retain)NSString* emailMessage;
@end
