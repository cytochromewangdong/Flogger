#import "FeedbackCom.h"
@implementation FeedbackCom
	@dynamic subject;
	-(NSString*) subject
	{
		return [self.dataDict valueForKey:@"subject"];
	}
	-(void) setSubject:(NSString*) paramSubject
	{
		[self.dataDict setValue: paramSubject forKey:@"subject"];
	}
	@dynamic feedback;
	-(NSString*) feedback
	{
		return [self.dataDict valueForKey:@"feedback"];
	}
	-(void) setFeedback:(NSString*) paramFeedback
	{
		[self.dataDict setValue: paramFeedback forKey:@"feedback"];
	}
@end
