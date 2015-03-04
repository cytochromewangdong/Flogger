//
//  NetworkData.m
//  Flogger
//
//  Created by jwchen on 12-1-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "NetworkData.h"
#import "GTMBase64.h"
#import "SBJson.h"
#import "LocationManager.h"

static NetworkData *sharedInstance = nil;

@implementation NetworkData
@synthesize mandantoryDict = _mandantoryDict, commonHeaderDict = _commonHeaderDict;

+(NetworkData *)sharedInstance
{
   if (!sharedInstance) {
        sharedInstance = [[NetworkData alloc] init];
      }
  
    return sharedInstance;
}

+(void)purgeSharedInstance
{
    [sharedInstance release];
    sharedInstance = nil;
}

-(NSMutableDictionary *)mandantoryDict
{
    if (!_mandantoryDict) {
        _mandantoryDict = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setObject:@"13712312312" forKey:@"phoneNumber"];
        [dict setObject:@"900232" forKey:@"buildNumber"];
        [dict setObject:@"IOS" forKey:@"platform"];
        [_mandantoryDict setObject:dict forKey:@"Mandantory"];
    }
    
    NSMutableDictionary *tmpDict = [_mandantoryDict objectForKey:@"Mandantory"];
    
    [tmpDict setObject:[NSString stringWithFormat:@"%f", [LocationManager sharedInstance].currentLocation.coordinate.latitude] forKey:@"lat"];
    [tmpDict setObject:[NSString stringWithFormat:@"%f", [LocationManager sharedInstance].currentLocation.coordinate.longitude] forKey:@"lon"];
//    NSLog(@"current location: %@, %@", [tmpDict objectForKey:@"lat"], [tmpDict objectForKey:@"lon"]);
    [_mandantoryDict setObject:tmpDict forKey:@"Mandantory"];
    
    return _mandantoryDict;
}

-(NSMutableDictionary*) commonHeaderDict
{
    if (!_commonHeaderDict) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"application/json" forKey:@"Content-Type"];
        
        [dict setObject:@"flogger" forKey:@"x-content-json-type"];
        _commonHeaderDict = dict;
    }
    
    NSMutableDictionary *mandantory = [self mandantoryDict];
    SBJsonWriter* writer = [[SBJsonWriter alloc] init];
    NSLog(@"mandantory -- %@", [writer stringWithObject:mandantory]);
    NSData *mandantoryData = [writer dataWithObject: mandantory];
    [writer release];
    
    NSData *base64Data = [GTMBase64 encodeData: mandantoryData];
    NSString *base64Str = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    [_commonHeaderDict setObject:base64Str forKey:@"mandantory-in-header"];
    [_commonHeaderDict setObject:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"locale"];
    [base64Str release];
    
    return _commonHeaderDict;
}

-(void)dealloc
{
    self.mandantoryDict = nil;
    self.commonHeaderDict = nil;
    [super dealloc];
}

@end
