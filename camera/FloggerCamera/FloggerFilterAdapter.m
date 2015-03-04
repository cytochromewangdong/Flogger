//
//  FloggerFilterAdapter.m
//  Flogger
//
//  Created by dong wang on 12-3-28.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerFilterAdapter.h"
#import "DataCache.h"
#import "TBXML.h"
#import "ZipArchive.h"
#import "zlib.h"
#import "zconf.h"

NSString const*NORMAL_FILTER_NAME=@"normal";
static NSString *filterCategory = @"filter";

#define kPreviewquality @"previewQuality"
#define kTitle @"title"
#define kFilter @"filter"
#define kName @"name"
#define kExtraEffectQuality @"extraEffectQuality"
#define kBorderImageName @"borderImageName"
#define kIconImageName @"iconName"
@interface FilterProperty()
-(void) internalInit;
@property (retain) NSString* name;
@end

@implementation FilterProperty
@dynamic  border;
@synthesize previewQuality;
@dynamic title;
@dynamic filter;
@dynamic icon;
@synthesize name;
@synthesize extraEffectQuality;
@synthesize borderImageName;
@synthesize iconName;
-(void) internalInit
{
    self.previewQuality = 2.0;
    self.extraEffectQuality = 2.0;
}
-(NSString*) title
{
    if(_title)
    {
       return NSLocalizedString(_title, title);
    }
    return nil;
}
-(void)setTitle:(NSString *)title
{
    RELEASE_SAFELY(_title);
    _title = [title retain];
}
-(void)setFilter:(NSString *)filter
{
    [[DataCache sharedInstance] storeString:filter forKey:self.name Category:filterCategory];
}
-(NSString*)filter
{
    //_hasBorder
    NSString* theFilter = [[[[DataCache sharedInstance] stringFromKey:self.name Category:filterCategory]retain]autorelease];
    if(theFilter)
    {
        return theFilter;
    }
    theFilter = [[[[FloggerFilterAdapter sharedInstance]getFilter:self.name]retain]autorelease];
    [self setFilter:theFilter];
    return theFilter;
    
}
-(void) setBorder:(UIImage *)border
{
    if(border)
    {
        [[DataCache sharedInstance] storeImage:border forKey:self.borderImageName Category:filterCategory];
    }
}
-(UIImage*) border
{
    if(self.borderImageName) 
    {
        //UIImage* ret =[[[[DataCache sharedInstance] imageFromKey:self.borderImageName Category:filterCategory]retain]autorelease];
//        if(ret)
//        {
//            return ret;
//        }
        UIImage* ret;
        ret = [[[FloggerFilterAdapter sharedInstance]createTexture:self.borderImageName]autorelease];
        [self setBorder:ret];
        return ret;
    }

     return nil;
}
-(UIImage*) icon
{
    if(self.iconName) 
    {
        return [[[FloggerFilterAdapter sharedInstance]createTexture:self.iconName]autorelease];
    } else{
        return [[[FloggerFilterAdapter sharedInstance]createTexture:@"Filter_Icon.png"]autorelease];
    }
    
    return nil;
}
-(id) init
{
    return [self initWithName:nil];
}
-(id) initWithName:(NSString*) pname
{
    self = [super init];
    if(!pname)
    {
        pname = [[NORMAL_FILTER_NAME copy]autorelease];
    }
    if(self)
    {
        self.name = pname;
        [self internalInit];
    }
    return self;
}
-(float) getQualityPrefered:(float) preferedQuality Mode:(BOOL)hasExtra
{
    float ret = MIN(self.previewQuality, preferedQuality);
    if(hasExtra) ret = MIN(ret,self.extraEffectQuality);
    return ret;
}
@end
static NSString *filterSavePath;

static FloggerFilterAdapter *instance;
@implementation FloggerFilterAdapter


+(FloggerFilterAdapter *)sharedInstance
{
    if (!instance) {
        instance = [[FloggerFilterAdapter alloc] init];
    }
    
    return instance;
}

+(void)purgeSharedInstance
{
    [instance release];
    instance = nil;
}

+(NSString*) getFilterSavePath
{
    return filterSavePath;
}
+(void)initialize
{
    NSString* docRoot = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"docRoot is %@",docRoot);
    NSString* xDataPath = [docRoot stringByAppendingPathComponent:@"XData"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:xDataPath])
    {
        if ([fileManager isWritableFileAtPath:docRoot]) {
            [fileManager createDirectoryAtPath:xDataPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
    }
    filterSavePath = xDataPath.retain;
}
-(NSMutableArray *) internalCreateFilterList:(NSString*)filterPath{
    NSMutableArray *filters = [[NSMutableArray alloc]init];
    // Load and parse the script xml file
    BOOL isHere = [[NSFileManager defaultManager]fileExistsAtPath:filterPath];
//    NSLog(@"exist %d , %@", isHere, filterPath);
    NSString *xml = [NSString stringWithContentsOfFile:filterPath encoding:NSUTF8StringEncoding error:nil];
    TBXML* tbxml = [[TBXML tbxmlWithXMLString:xml] retain];
    
    // Obtain root element
    TBXMLElement * root = tbxml.rootXMLElement;
    
    // if root element is valid
    if (root) {

            TBXMLElement * eachFilterEl = [TBXML childElementNamed:@"filter" parentElement:root];
            
            // if an element was found
            while (eachFilterEl != nil)
            {
                NSString *name = [TBXML valueOfAttributeNamed:kName forElement:eachFilterEl];
                FilterProperty *filter = [[[FilterProperty alloc]initWithName:name]autorelease];
                filter.title = [TBXML valueOfAttributeNamed:kTitle forElement:eachFilterEl];
                filter.borderImageName = [TBXML valueOfAttributeNamed:kBorderImageName forElement:eachFilterEl];
                filter.iconName = [TBXML valueOfAttributeNamed:kIconImageName forElement:eachFilterEl];
                NSString * extraEffectQuality = [TBXML valueOfAttributeNamed:kExtraEffectQuality forElement:eachFilterEl];
                if(extraEffectQuality)
                {
                    filter.extraEffectQuality = [extraEffectQuality floatValue];
                }
                NSString * previewQuality = [TBXML valueOfAttributeNamed:kPreviewquality forElement:eachFilterEl];
                if(previewQuality)
                {
                    filter.previewQuality = [previewQuality floatValue];
                }
                [filters addObject:filter];
                
                eachFilterEl = [TBXML nextSiblingNamed:@"filter"  searchFromElement:eachFilterEl];
            }
    }
    // release resources
    [tbxml release]; 
    return filters;
}

-(NSArray*) createFilterList
{
    
    NSString *downloadedXML = [filterSavePath stringByAppendingPathComponent:@"list.xml"];
    if([[NSFileManager defaultManager] fileExistsAtPath:downloadedXML])
    {
        return  [self internalCreateFilterList:downloadedXML];
    }
    NSString *xmlPath = [[NSBundle mainBundle]pathForResource:@"list" ofType:@"xml"];
    
    return  [self internalCreateFilterList:xmlPath];
    
}
-(NSArray*) createBorderList
{
    
    NSString *downloadedXML = [filterSavePath stringByAppendingPathComponent:@"border.xml"];
    if([[NSFileManager defaultManager] fileExistsAtPath:downloadedXML])
    {
        return  [self internalCreateFilterList:downloadedXML];
    }
    NSString *xmlPath = [[NSBundle mainBundle]pathForResource:@"border" ofType:@"xml"];
    
    return  [self internalCreateFilterList:xmlPath];
    
}
-(UIImage*)createTexture:(NSString*)name
{
    NSString *imgPath = filterSavePath;
    UIImage *image =  [[UIImage imageWithContentsOfFile:[imgPath stringByAppendingPathComponent:name]]retain];
    if(!image) {
        image = [[UIImage imageNamed:name]retain];
    }
    return image;
}
-(NSString*)getFilter:(NSString*)name
{
    NSString *path = [filterSavePath stringByAppendingPathComponent:name];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
       path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
    }
    
    unzFile theUnzFile = unzOpen( (const char*)[path UTF8String] );
	if( theUnzFile )
	{
		unz_global_info  globalInfo = {0};
		if( unzGetGlobalInfo(theUnzFile, &globalInfo )==UNZ_OK )
		{
		}
	}
    
    //NSMutableString *filter = [[NSMutableString alloc]init];
    NSMutableData *rawByte = [[[NSMutableData  alloc]init]autorelease];
	int ret = unzGoToFirstFile( theUnzFile );
	unsigned char		buffer[4096] = {0};
	if( ret!=UNZ_OK )
	{
		return nil;
	}
	NSString *pas = [NSString stringWithFormat:@"%@%@",@"atoato",@"filter"];
    ret = unzOpenCurrentFilePassword( theUnzFile, [pas cStringUsingEncoding:NSASCIIStringEncoding] );
    if( ret!=UNZ_OK )
    {
        return nil;
    }
    // reading data and write to file
    int read ;
    unz_file_info	fileInfo ={0};
    ret = unzGetCurrentFileInfo(theUnzFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
    if( ret!=UNZ_OK )
    {
        unzCloseCurrentFile( theUnzFile );
        return nil;
    }
    while( YES )
    {
        read=unzReadCurrentFile(theUnzFile, buffer, 4096);
        if( read > 0 )
        {
            [rawByte appendBytes:buffer length:read]; 
        }
        else if( read<0 )
        {
            break;
        }
        else 
            break;				
    }
    unzCloseCurrentFile( theUnzFile );
    unzGoToNextFile( theUnzFile );
    NSString *filter = [[[NSString alloc]initWithData:rawByte encoding:NSUTF8StringEncoding]autorelease];
    return filter;
}
@end
