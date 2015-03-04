#import "ReportCom.h"
@implementation ReportCom
	@dynamic type;
	-(NSNumber*) type
	{
		return [self.dataDict valueForKey:@"type"];
	}
	-(void) setType:(NSNumber*) paramType
	{
		[self.dataDict setValue: paramType forKey:@"type"];
	}
	@dynamic content;
	-(NSString*) content
	{
		return [self.dataDict valueForKey:@"content"];
	}
	-(void) setContent:(NSString*) paramContent
	{
		[self.dataDict setValue: paramContent forKey:@"content"];
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
	@dynamic issueID;
	-(NSNumber*) issueID
	{
		return [self.dataDict valueForKey:@"issueID"];
	}
	-(void) setIssueID:(NSNumber*) paramIssueID
	{
		[self.dataDict setValue: paramIssueID forKey:@"issueID"];
	}
@end
