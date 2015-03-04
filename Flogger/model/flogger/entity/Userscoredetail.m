#import "Userscoredetail.h"
@implementation Userscoredetail
	@dynamic useruid;
	-(NSNumber*) useruid
	{
		return [self.dataDict valueForKey:@"useruid"];
	}
	-(void) setUseruid:(NSNumber*) paramUseruid
	{
		[self.dataDict setValue: paramUseruid forKey:@"useruid"];
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
	@dynamic scoretype;
	-(NSNumber*) scoretype
	{
		return [self.dataDict valueForKey:@"scoretype"];
	}
	-(void) setScoretype:(NSNumber*) paramScoretype
	{
		[self.dataDict setValue: paramScoretype forKey:@"scoretype"];
	}
	@dynamic score;
	-(NSNumber*) score
	{
		return [self.dataDict valueForKey:@"score"];
	}
	-(void) setScore:(NSNumber*) paramScore
	{
		[self.dataDict setValue: paramScore forKey:@"score"];
	}
	@dynamic scoresourceid;
	-(NSNumber*) scoresourceid
	{
		return [self.dataDict valueForKey:@"scoresourceid"];
	}
	-(void) setScoresourceid:(NSNumber*) paramScoresourceid
	{
		[self.dataDict setValue: paramScoresourceid forKey:@"scoresourceid"];
	}
	@dynamic id;
	-(NSNumber*) id
	{
		return [self.dataDict valueForKey:@"id"];
	}
	-(void) setId:(NSNumber*) paramId
	{
		[self.dataDict setValue: paramId forKey:@"id"];
	}
@end
