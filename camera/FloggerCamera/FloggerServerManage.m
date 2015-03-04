//
//  FloggerServerManage.m
//  FloggerVideo
//
//  Created by wyf on 12-1-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FloggerServerManage.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "GTMBase64.h"
#import "ZipArchive.h"


@interface FloggerServerManage()

- (void) saveImage:(ASIHTTPRequest *)request imageName:(NSString*)imageName;
@end
static NSString *imageSavePath;
static NSString *mediaSavePath;
static NSString* const MEDIAPATH = @"DCIM";
@implementation FloggerServerManage
@synthesize serverDelegate = _serverDelegate;
//@synthesize imageArray = _imageArray;
@synthesize finishLoad;
@synthesize filterDic;
+(NSString*) getImageSavePath
{
    return imageSavePath;
}

+(NSString*) getMediaSavePath
{
    return mediaSavePath;
}
+(void)initialize
{
    NSString* docRoot = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"docRoot is %@",docRoot);
    NSString* imagePath = [docRoot stringByAppendingPathComponent:@"fimgPath"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:imagePath])
    {
        if ([fileManager isWritableFileAtPath:docRoot]) {
            [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
    }
    imageSavePath = imagePath.retain;
    
    //media path
    NSString *mediaPath = [docRoot stringByAppendingPathComponent:MEDIAPATH];
    if (![fileManager fileExistsAtPath:mediaPath]) {
        if ([fileManager isWritableFileAtPath:docRoot]) {
            [fileManager createDirectoryAtPath:mediaPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    mediaSavePath = mediaPath.retain;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    //    if (self) {
    //        // Custom initialization
    //    }
    return self;
}


-(void) retrieveFilter
{
    self.finishLoad  = NO;
    NSURL *url = [NSURL URLWithString:@"http://58.221.42.241:8080/Flogger/services/ws/retrieveFilters"];
//                NSURL *url = [NSURL URLWithString:@"http://192.168.1.202:8080/Flogger/services/ws/retrieveFilters"];
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.151:8080/Flogger/services/ws/retrieveFilters"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.numberOfTimesToRetryOnTimeout = 5;
    request.delegate = self;
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
//    [request addRequestHeader:@"x-token-in-head" value:@"59cfb60f-794d-43a4-bb9b-437cf6d0fb0b"];
//     [request addRequestHeader:@"x-token-in-head" value:@"8b39fd69-0d8f-4a4a-9cf6-78ced5b7c2bf"];
    [request addRequestHeader:@"x-token-in-head" value:@"0803ae19-2237-4e5f-a12d-073d739fa30d"];
    
    [request appendPostData:[@"{\"FilterCom\":{}}" dataUsingEncoding:NSUTF8StringEncoding]];

    [request startAsynchronous];
}

-(void) retrieveImage:(NSString*) imageName
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://58.221.42.241:8080/Flogger/%@",imageName]];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    request.delegate = self;
    //[request addRequestHeader:@"Content-Type" value:@"application/json"];
    //    [request addRequestHeader:@"x-token-in-head" value:@"59cfb60f-794d-43a4-bb9b-437cf6d0fb0b"];
    //[request addRequestHeader:@"x-token-in-head" value:@"8b39fd69-0d8f-4a4a-9cf6-78ced5b7c2bf"];
    
    //[request appendPostData:[@"{\"FilterCom\":{}}" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request startSynchronous];
    [self saveImage:request imageName:imageName];
}

-(void)uploadData:(NSData *)data withType: (int) type
{
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.202:8080/Flogger/fast/upload"];
    NSURL *url = [NSURL URLWithString:@"http://58.221.42.241:8080/Flogger/fast/upload"];
//        NSURL *url = [NSURL URLWithString:@"http://192.168.1.151:8080/Flogger/fast/upload"];
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.4:8080/Flogger/fast/upload"];
    

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    //[ASIHTTPRequest setDefaultTimeOutSeconds:30];
    request.timeOutSeconds=40;
    request.numberOfTimesToRetryOnTimeout = 1;
    NSMutableDictionary *issueInfor = [[[NSMutableDictionary alloc] init] autorelease];
    //    [issueInfor setObject:@"1" forKey:@"id"];
//    [issueInfor setObject:@"0" forKey:@"parentid"];
//    [issueInfor setObject:@"0" forKey:@"targetid"];
//    [issueInfor setObject:@"123" forKey:@"useruid"];
    if (type == 1) {
        [issueInfor setObject:@"1" forKey:@"issuecategory"];
    } else if (type == 2)
    {
        [issueInfor setObject:@"2" forKey:@"issuecategory"];
    }
//    [issueInfor setObject:@"1" forKey:@"issuecategory"];
    [issueInfor setObject:@"fefe" forKey:@"text"];
    
    NSMutableDictionary *d1 = [[[NSMutableDictionary alloc] init] autorelease];
    [d1 setObject:issueInfor forKey:@"issueinfo"];
    
    //    NSString *str = [issueInfo JSONRepresentation];
    
    //    UIImage *image = [UIImage imageNamed:@"photo_bg.png"];
    
    NSData *fileData = data;//UIImageJPEGRepresentation(image, 1.0);
    //    NSLog(@"data size is %f", fileData )
    
    [d1 setObject:[NSString stringWithFormat:@"%d", fileData.length] forKey:@"uploadFileSize"];
    
    NSMutableDictionary *dataDict = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
    [dataDict setObject:d1 forKey:@"IssueInfoCom"];
    
    //    [dataDict setObject:str forKey:@"IssueInfoCom"];
    SBJsonWriter* writer = [[[SBJsonWriter alloc] init] autorelease];
    NSData *d = [writer dataWithObject:dataDict];
    NSMutableDictionary *allDict = [[[NSMutableDictionary alloc] init] autorelease];
    [allDict setObject:[GTMBase64 stringByEncodingData:d] forKey:@"data-in-header"];
    [request setRequestHeaders:allDict];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
//         [request addRequestHeader:@"x-token-in-head" value:@"59cfb60f-794d-43a4-bb9b-437cf6d0fb0b"];  
//         [request addRequestHeader:@"x-token-in-head" value:@"8b39fd69-0d8f-4a4a-9cf6-78ced5b7c2bf"];
    [request addRequestHeader:@"x-token-in-head" value:@"0803ae19-2237-4e5f-a12d-073d739fa30d"];
    
    [request appendPostData:fileData];
    
//    [request res]
    
    [request startAsynchronous];
}

- (void)requestReceivedResponseHeaders:(ASIHTTPRequest *)request
{
//    NSLog(@"ppppp:%@",[request responseHeaders]);
    
}

- (void) saveImage:(ASIHTTPRequest *)request imageName:(NSString*)imageName;
{
    NSData *responseData = [request responseData];
    //NSString *imageName = [request.originalURL lastPathComponent];
//    NSLog(@"request originalurl is %@",request.originalURL);
//    NSLog(@"ImageName is %@",imageName);
    //        NSHomeDirectory()
    /*NSString* docRoot = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"docRoot is %@",docRoot);
    NSString* imagePath = [docRoot stringByAppendingPathComponent:@"fimgPath"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:imagePath])
    {
        if ([fileManager isWritableFileAtPath:imagePath]) {
            [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
    }*/
   NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imagePath = [FloggerServerManage getImageSavePath];
    NSString *imageFullFileName = [imagePath stringByAppendingPathComponent:imageName];
//    NSLog(@"imageFullFileName is %@",imageFullFileName);
    if ([fileManager isWritableFileAtPath:imagePath]) {
        [fileManager createFileAtPath:imageFullFileName contents:responseData attributes:nil];
    }
    
    if ([[imageFullFileName lowercaseString] hasSuffix:@"zip"]) {
        ZipArchive *zip = [[[ZipArchive alloc] init] autorelease];
        if ([zip UnzipOpenFile:imageFullFileName]) {
            //        []
            if ([zip UnzipFileTo:imagePath overWrite:YES]) {
//                NSLog(@"success unzipfile");
            }
        }
    } 
    
    

    
    //UIImage *img = [UIImage imageWithContentsOfFile:imageFullFileName];
}
#pragma mark asihttp request delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{

//    NSLog(@"requestFinished: %@", request.originalURL.absoluteString);
    NSData *responseData = [request responseData];
    
//    NSLog(@"responseData: %d", responseData.length);
//    NSLog(@"responseData is : %@",responseData);
//    NSLog(@"responseData is %d",responseData);
    
    if([request.originalURL.absoluteString hasSuffix:@"retrieveFilters"]){
        NSString * str = [[[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding: NSUTF8StringEncoding] autorelease];
        //    NSLog(@"requestFinished: %@", str);
        //result = str;
        NSDictionary *mydic = [[str JSONValue] valueForKey:@"FilterCom"];
        NSArray *nameList = [mydic valueForKey:@"nameList"];
        NSMutableArray *contentList = [mydic valueForKey:@"contentList"];
        NSArray *imageList = [mydic valueForKey:@"imageList"];
        NSMutableDictionary *filterDicTest = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
        [filterDicTest setValue:nameList forKey:@"nameList"];
        [filterDicTest setValue:contentList forKey:@"contentList"];
        [self setFilterDic:filterDicTest];
        
        //test
        //NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:10];
        //self.imageArray = imageArray;
        //test
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSString* imageName in imageList) {
//                NSLog(@"imageName is %@",imageName);
                [self retrieveImage:imageName];
            }
            self.finishLoad = YES;

            //set scrollow
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self serverDelegate] setFilterButtonFromServer:self.filterDic];
            });
        });
  
        //    NSLog(@"contentList is %@",[contentList objectAtIndex:0]);
        //    NSData *data =  [GTMBase64 decodeString:[contentList objectAtIndex:0]];
        //    //    NSString *string = [NSString stringWithUTF8String:[data bytes]];
        //    
        //    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //    NSLog(@"string is %@",string);
        //set filterDic
//        NSMutableDictionary *filterDic = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
//        [filterDic setValue:nameList forKey:@"nameList"];
//        [filterDic setValue:contentList forKey:@"contentList"];
//        //set scrollow
//        [[self serverDelegate] setFilterButtonFromServer:filterDic];
        
        //test
        //[self.serverDelegate setTextureImage:self.imageArray];
    } else if([request.originalURL.absoluteString hasSuffix:@"upload"])
    {
        
    } else {

//        [self.imageArray addObject:img];
        //UIImage *resultImage = [UIImage imageWithData:responseData];
        
        //NSData *data = [fileManager contentsAtPath:imageFullFileName];
        //UIImage *dataImage = [UIImage imageWithData:data];
        
        //NSURL *imageUrl = [NSURL fileURLWithPath:imageFullFileName];
        //NSLog(@"imageUrl is %@",imageUrl);
        
        //NSData *data = [fileManager contentsAtPath:imageFullFileName];
        
        //UIImage *resultImage = [UIImage imageWithData:responseData]; 
        //UIImage *image = [UIImage imageWithData:data];
        
//        NSLog(@"resultimage size is %@",resultImage.size);
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
//    [self setFilterDic:filterDic];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
//    NSLog(@"requestFailed: %@", error.localizedDescription);
}

-(void) dealloc
{
    [self setServerDelegate:nil];
    //[self setImageArray:nil];
    [super dealloc];
}


@end
