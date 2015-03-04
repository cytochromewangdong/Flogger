#import "Comment.h"
@implementation Comment
	@dynamic parentid;
	-(NSString*) parentid
	{
		return [self.dataDict valueForKey:@"parentid"];
	}
	-(void) setParentid:(NSString*) paramParentid
	{
		[self.dataDict setValue: paramParentid forKey:@"parentid"];
	}
	@dynamic targetid;
	-(NSString*) targetid
	{
		return [self.dataDict valueForKey:@"targetid"];
	}
	-(void) setTargetid:(NSString*) paramTargetid
	{
		[self.dataDict setValue: paramTargetid forKey:@"targetid"];
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
	@dynamic replycatagory;
	-(NSNumber*) replycatagory
	{
		return [self.dataDict valueForKey:@"replycatagory"];
	}
	-(void) setReplycatagory:(NSNumber*) paramReplycatagory
	{
		[self.dataDict setValue: paramReplycatagory forKey:@"replycatagory"];
	}
	@dynamic respondcatagory;
	-(NSNumber*) respondcatagory
	{
		return [self.dataDict valueForKey:@"respondcatagory"];
	}
	-(void) setRespondcatagory:(NSNumber*) paramRespondcatagory
	{
		[self.dataDict setValue: paramRespondcatagory forKey:@"respondcatagory"];
	}
	@dynamic commentid;
	-(NSString*) commentid
	{
		return [self.dataDict valueForKey:@"commentid"];
	}
	-(void) setCommentid:(NSString*) paramCommentid
	{
		[self.dataDict setValue: paramCommentid forKey:@"commentid"];
	}
	@dynamic likeit;
	-(NSNumber*) likeit
	{
		return [self.dataDict valueForKey:@"likeit"];
	}
	-(void) setLikeit:(NSNumber*) paramLikeit
	{
		[self.dataDict setValue: paramLikeit forKey:@"likeit"];
	}
	@dynamic id;
	-(NSString*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSString*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
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
@end
