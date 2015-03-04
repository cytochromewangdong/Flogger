#import "MyIssueInfo.h"
#import "Likeinfo.h"
#import "Issueinfo.h"
@interface MyIssueInfo : Issueinfo
	@property (retain)NSNumber* count;
	@property (retain)NSString* shareMediaUrl;
	@property (retain)NSNumber* liked;
	@property (retain)NSNumber* likeid;
	@property (retain)NSNumber* middleWidth;
	@property (retain)NSNumber* middleHeight;
	@property (retain)NSNumber* thumbnailWidth;
	@property (retain)NSNumber* thumbnailHeight;
	@property (retain)NSString* scalethumbnailurl;
	@property (retain)NSMutableArray* commentList;
	@property (retain)NSString* likers;
	@property (retain)NSMutableArray* likerList;
@end
