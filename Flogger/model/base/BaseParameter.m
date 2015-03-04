#import "BaseParameter.h"
@implementation BaseParameter

	@dynamic token;
	-(NSString*) token
	{
		return [self.dataDict valueForKey:@"token"];
	}
	-(void) setToken:(NSString*) paramToken
	{
		[self.dataDict setValue: paramToken forKey:@"token"];
	}
	@dynamic mandantory;
	-(NSString*) mandantory
	{
		return [self.dataDict valueForKey:@"mandantory"];
	}
	-(void) setMandantory:(NSString*) paramMandantory
	{
		[self.dataDict setValue: paramMandantory forKey:@"mandantory"];
	}
	@dynamic payload;
	-(NSString*) payload
	{
		return [self.dataDict valueForKey:@"payload"];
	}
	-(void) setPayload:(NSString*) paramPayload
	{
		[self.dataDict setValue: paramPayload forKey:@"payload"];
	}
	@dynamic ret;
	-(NSNumber*) ret
	{
		return [self.dataDict valueForKey:@"ret"];
	}
	-(void) setRet:(NSNumber*) paramRet
	{
		[self.dataDict setValue: paramRet forKey:@"ret"];
	}
	@dynamic errorMessage;
	-(NSString*) errorMessage
	{
		return [self.dataDict valueForKey:@"errorMessage"];
	}
	-(void) setErrorMessage:(NSString*) paramErrorMessage
	{
		[self.dataDict setValue: paramErrorMessage forKey:@"errorMessage"];
	}
	@dynamic destination;
	-(NSString*) destination
	{
		return [self.dataDict valueForKey:@"destination"];
	}
	-(void) setDestination:(NSString*) paramDestination
	{
		[self.dataDict setValue: paramDestination forKey:@"destination"];
	}
	@dynamic extra;
	-(NSString*) extra
	{
		return [self.dataDict valueForKey:@"extra"];
	}
	-(void) setExtra:(NSString*) paramExtra
	{
		[self.dataDict setValue: paramExtra forKey:@"extra"];
	}

-(BOOL)succeed
{
    return [self.ret intValue] == 0;
}

@end
