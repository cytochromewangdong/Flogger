#import "Uifilter.h"
@implementation Uifilter
	@dynamic commonvsh;
	-(NSString*) commonvsh
	{
		return [self.dataDict valueForKey:@"commonvsh"];
	}
	-(void) setCommonvsh:(NSString*) paramCommonvsh
	{
		[self.dataDict setValue: paramCommonvsh forKey:@"commonvsh"];
	}
	@dynamic commonfsh;
	-(NSString*) commonfsh
	{
		return [self.dataDict valueForKey:@"commonfsh"];
	}
	-(void) setCommonfsh:(NSString*) paramCommonfsh
	{
		[self.dataDict setValue: paramCommonfsh forKey:@"commonfsh"];
	}
	@dynamic extravsh;
	-(NSString*) extravsh
	{
		return [self.dataDict valueForKey:@"extravsh"];
	}
	-(void) setExtravsh:(NSString*) paramExtravsh
	{
		[self.dataDict setValue: paramExtravsh forKey:@"extravsh"];
	}
	@dynamic extrafsh;
	-(NSString*) extrafsh
	{
		return [self.dataDict valueForKey:@"extrafsh"];
	}
	-(void) setExtrafsh:(NSString*) paramExtrafsh
	{
		[self.dataDict setValue: paramExtrafsh forKey:@"extrafsh"];
	}
	@dynamic vsh;
	-(NSString*) vsh
	{
		return [self.dataDict valueForKey:@"vsh"];
	}
	-(void) setVsh:(NSString*) paramVsh
	{
		[self.dataDict setValue: paramVsh forKey:@"vsh"];
	}
	@dynamic fsh;
	-(NSString*) fsh
	{
		return [self.dataDict valueForKey:@"fsh"];
	}
	-(void) setFsh:(NSString*) paramFsh
	{
		[self.dataDict setValue: paramFsh forKey:@"fsh"];
	}
	@dynamic steps;
	-(NSString*) steps
	{
		return [self.dataDict valueForKey:@"steps"];
	}
	-(void) setSteps:(NSString*) paramSteps
	{
		[self.dataDict setValue: paramSteps forKey:@"steps"];
	}
	@dynamic uniforms;
	-(NSString*) uniforms
	{
		return [self.dataDict valueForKey:@"uniforms"];
	}
	-(void) setUniforms:(NSString*) paramUniforms
	{
		[self.dataDict setValue: paramUniforms forKey:@"uniforms"];
	}
	@dynamic name;
	-(NSString*) name
	{
		return [self.dataDict valueForKey:@"name"];
	}
	-(void) setName:(NSString*) paramName
	{
		[self.dataDict setValue: paramName forKey:@"name"];
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
	@dynamic attributes;
	-(NSString*) attributes
	{
		return [self.dataDict valueForKey:@"attributes"];
	}
	-(void) setAttributes:(NSString*) paramAttributes
	{
		[self.dataDict setValue: paramAttributes forKey:@"attributes"];
	}
@end
