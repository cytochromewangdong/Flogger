//
//  RequestTask.m
//  Flogger
//
//  Created by jwchen on 12-1-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "RequestTask.h"
@implementation RequestTask
@synthesize action = _action, requestType = _requestType, headerParameters = _headerParameters, bodyData = _bodyData, url, networkDelegate, requestId, shouldStreamPostDataFromDisk,dataFile,requestLevel,fileID;

- (id)init
{
    self = [super init];
    if (self) {
        _headerParameters = [[NSMutableDictionary alloc] init];
        _bodyData = [[NSMutableArray alloc] init];
        self.requestType = HTTP_POST;
    }
    
    return self;
}

-(void)dealloc
{
    self.dataFile = nil;
    self.fileID = nil;
    RELEASE_SAFELY(_action);
    RELEASE_SAFELY(_headerParameters);
    RELEASE_SAFELY(_bodyData);
    RELEASE_SAFELY(_requestType);
    RELEASE_SAFELY(url);
    RELEASE_SAFELY(requestId);
    [super dealloc];
}

@end
