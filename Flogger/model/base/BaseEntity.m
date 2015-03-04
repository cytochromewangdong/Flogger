#import "BaseEntity.h"
@implementation BaseEntity
	@dynamic platform;
	-(NSString*) platform
	{
		return [self.dataDict valueForKey:@"platform"];
	}
	-(void) setPlatform:(NSString*) paramPlatform
	{
		[self.dataDict setValue: paramPlatform forKey:@"platform"];
	}
	@dynamic createdate;
	-(NSNumber*) createdate
	{
		return [self.dataDict valueForKey:@"createdate"];
	}
	-(void) setCreatedate:(NSNumber*) paramCreatedate
	{
		[self.dataDict setValue: paramCreatedate forKey:@"createdate"];
	}
	@dynamic createuser;
	-(NSString*) createuser
	{
		return [self.dataDict valueForKey:@"createuser"];
	}
	-(void) setCreateuser:(NSString*) paramCreateuser
	{
		[self.dataDict setValue: paramCreateuser forKey:@"createuser"];
	}
	@dynamic modifydate;
	-(NSNumber*) modifydate
	{
		return [self.dataDict valueForKey:@"modifydate"];
	}
	-(void) setModifydate:(NSNumber*) paramModifydate
	{
		[self.dataDict setValue: paramModifydate forKey:@"modifydate"];
	}
	@dynamic modifyuser;
	-(NSString*) modifyuser
	{
		return [self.dataDict valueForKey:@"modifyuser"];
	}
	-(void) setModifyuser:(NSString*) paramModifyuser
	{
		[self.dataDict setValue: paramModifyuser forKey:@"modifyuser"];
	}
	@dynamic sqlOrderBy;
	-(NSString*) sqlOrderBy
	{
		return [self.dataDict valueForKey:@"sqlOrderBy"];
	}
	-(void) setSqlOrderBy:(NSString*) paramSqlOrderBy
	{
		[self.dataDict setValue: paramSqlOrderBy forKey:@"sqlOrderBy"];
	}
@end
