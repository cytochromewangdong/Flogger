#import "MyIssueInfo.h"
#import "Activitiesinfo.h"
@interface ActivityResultEntity : Activitiesinfo
	@property (retain)NSString* mediaUrl;
	@property (retain)NSString* parentMediaUrl;
	@property (retain)NSString* parentShout;
	@property (retain)MyIssueInfo* currentThread;
	@property (retain)MyIssueInfo* parentThread;
@end
