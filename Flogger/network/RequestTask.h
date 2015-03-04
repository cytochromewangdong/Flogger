//
//  RequestTask.h
//  Flogger
//
//  Created by jwchen on 12-1-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HTTP_POST @"POST"
#define HTTP_GET @"GET"
typedef enum
{
    normalLevel,
    backgroundLevel,
    blockLevel
} RequestLevel;

@interface RequestTask : NSObject
{
    @private
    NSString *_action;
    NSMutableDictionary *_headerParameters;
    NSMutableArray *_bodyData;
    NSString *_requestType;
}

@property(nonatomic, copy) NSString *action, *requestType, *requestId;
@property(nonatomic, readonly) NSMutableDictionary *headerParameters;
@property(nonatomic, readonly) NSMutableArray *bodyData;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, retain) NSString *dataFile;
@property(nonatomic, retain)NSString *fileID;

@property(nonatomic, assign) RequestLevel requestLevel;
@property(nonatomic, assign) id networkDelegate;
@property(nonatomic, assign) BOOL shouldStreamPostDataFromDisk;

@end
