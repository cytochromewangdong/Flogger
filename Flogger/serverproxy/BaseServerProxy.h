//
//  BaseServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-1-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestTask.h"
#import "BaseParameter.h"

@class BaseServerProxy;

@protocol NetworkRequestDelegate <NSObject>
@required
-(void)transactionFinished:(BaseServerProxy *)serverproxy;
-(void)transactionFailed:(BaseServerProxy *)serverproxy;
-(void)networkError:(BaseServerProxy *)serverproxy;
-(void)networkFinished:(BaseServerProxy *)serverproxy;
@end

@interface BaseServerProxy : NSObject
{
    @private
    NSMutableArray *_taskList;
    
    BaseParameter *_response;
    
    NSString *_errorMessage;
}
@property(nonatomic, assign)id delegate;
@property(nonatomic, retain)BaseParameter *response;
@property(nonatomic, copy)NSString *keyCom;
@property(retain) NSString *errorMessage;

-(NSString *)urlByAction:(NSString *)action;

-(void)doRequest:(RequestTask *)task;

-(void)cancelAll;
+(void)cancelAllOnEarth:(RequestLevel) level;
-(void)cancelTask:(RequestTask *)task;

-(NSMutableDictionary *)generateBodyDict:(id)value forKey:(NSString *)key;

-(RequestTask *)generateRequestTaskWithBody:(id)bodyData bodyKey:(NSString *)bodyKey header:(id)headerData headerKey:(NSString *)headerKey forAction:(NSString *)action;

-(RequestTask *)generateRequestTaskWithBody:(NSString*)dataFile header:(id)headerData headerKey:(NSString *)headerKey forAction:(NSString *)action;

-(RequestTask *)generateRequestTask:(id)value key:(NSString *)key forAction:(NSString *)action;

-(void)parseResponse:(id)responseData;

-(void)notifyNetworkError;
-(void)notifyTransactionFinished;
-(void)notifyTransactionFailed;


@end
