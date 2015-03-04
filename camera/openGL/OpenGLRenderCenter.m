//
//  OpenGLRenderCenter.m
//  ColorTracking
//
//  Created by dong wang on 11-12-28.
//  Copyright (c) 2011年 atoato. All rights reserved.
//
#import "OpenGLRenderCenter.h"
NSString *const GL_DATA_KEY_COMMON_VSH=@"commonvsh";
NSString *const GL_DATA_KEY_COMMON_FSH=@"commonfsh";
NSString *const GL_DATA_KEY_EXTRA_VSH=@"extravsh";
NSString *const GL_DATA_KEY_EXTRA_FSH=@"extrafsh";
NSString *const GL_DATA_KEY_VSH=@"vsh";
NSString *const GL_DATA_KEY_FSH=@"fsh";
NSString *const GL_DATA_KEY_ATTRIBUTE_KEY=@"attributes";
NSString *const GL_DATA_KEY_UNIFORM_KEY=@"uniforms";
NSString *const GL_DATA_KEY_ELEMENT_KEY=@"element";
NSString *const GL_DATA_KEY_TEXTURES=@"textures";
NSString *const GL_DATA_KEY_NAME=@"name";
const GLchar* ATTRIBUTE_KEY_LIST[]={"BOUND","position","inputTextureCoordinate"};
const GLchar* UNIFORM_KEY_LIST[]={"BOUND","videoFrame","kernel","offset","stepwidth","stepheight","vertical"};


const NSString * directVetexSource = @"attribute lowp vec4 positionSecond;\
attribute lowp vec4 inputTextureCoordinateSecond;\
varying lowp vec2 textureCoordinateSecond;\
void main()\
{\
gl_Position = positionSecond;\
textureCoordinateSecond = inputTextureCoordinateSecond.xy;\
}";

const NSString * directFragmentSource = @"\
varying lowp vec2 textureCoordinateSecond;\
uniform sampler2D videoFrameSecond;\
void main()\
{\
lowp vec4 pixelColor;\
pixelColor = texture2D(videoFrameSecond, textureCoordinateSecond);\
gl_FragColor =  pixelColor;\
}\
";
static GLfloat MAX_DIMENTION;
// first step
static const GLfloat squareVertices[] = {
    -1.0f, -1.0f,
    1.0f, -1.0f,
    -1.0f,  1.0f,
    1.0f,  1.0f,
};
static const GLfloat textureVerticesUp[] = {
    0.0f, 0.0f,
    1.0f, 0.0f,
    0.0f,  1.0f,
    1.0f,  1.0f,
};
static const GLfloat textureVerticesDown[] = {
    1.0f,  1.0f,
    0.0f,  1.0f,
    1.0f, 0.0f,
    0.0f, 0.0f,
    
};

static const GLfloat textureVerticesLeft[] = {
    1.0f,0.0f,
    1.0f,1.0f,
    0.0f,0.0f,
    0.0f,1.0f,
};

static const GLfloat textureVerticesRight[] = {
    0.0f,1.0f,
    0.0f,0.0f,
    1.0f,1.0f,
    1.0f,0.0f,
};

static const GLfloat textureVerticesRightMirrored[] =
{
    0.0f,0.0f,
    0.0f,1.0f,
    1.0f,0.0f,
    1.0f,1.0f,
};/*{
    1.0f,1.0f,
    1.0f,0.0f,
    0.0f,1.0f,
    0.0f,0.0f,
};*/

/*static const GLfloat textureVerticesGLlayer[] = {
 1.0f, 1.0f,
 1.0f, 0.0f,
 0.0f, 1.0f,
 0.0f, 0.0f,
 };*/
static const GLfloat textureVerticesGLlayer[] = {
    0.0f, 1.0f,
    1.0f, 1.0f,
    0.0f, 0.0f,
    1.0f, 0.0f,
};
UInt8 * CopyDataFromImage (UIImage* inImage,BOOL autoAdjustImage)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = inImage.size.width;//CGImageGetWidth(inImage);
    size_t pixelsHigh = inImage.size.height;//CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) 
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
    // per component. Regardless of what the source image format is 
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
    
    if (context == NULL)
    {
        free (bitmapData);
        bitmapData = NULL;
//        NSLog(@"Context not created!");
    }
    CGRect rect = {{0,0},{pixelsWide,pixelsHigh}};
    dispatch_block_t block =  ^{
        UIGraphicsPushContext(context);
        
        CGContextSaveGState(context); 
        CGContextTranslateCTM(context, 0, pixelsHigh);
        CGContextScaleCTM(context, 1.0, -1.0);
        [inImage drawInRect:rect];
        CGContextRestoreGState(context);
        //[originImage drawAtPoint:CGPointMake(0, 0)];
        
        UIGraphicsPopContext();
    };
    if(autoAdjustImage) {
        if([NSThread currentThread].isMainThread) 
        {
            block();
            
        } 
        else
        {
            dispatch_sync(dispatch_get_main_queue(),block);
        }
    } else {
        CGContextDrawImage(context, rect, inImage.CGImage); 
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    CGContextRelease(context); 
    return bitmapData;//CGBitmapContextGetData (context);
}

UIImage * NormalizeImage (UIImage* inImage)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    //int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = inImage.size.width;//CGImageGetWidth(inImage);
    size_t pixelsHigh = inImage.size.height;//CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    //bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
    // per component. Regardless of what the source image format is 
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (NULL,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
    
    CGRect rect = {{0,0},{pixelsWide,pixelsHigh}};
    dispatch_block_t block =  ^{
        UIGraphicsPushContext(context);
        
        CGContextSaveGState(context); 
        CGContextTranslateCTM(context, 0, pixelsHigh);
        CGContextScaleCTM(context, 1.0, -1.0);
        [inImage drawInRect:rect];
        CGContextRestoreGState(context);
        //[originImage drawAtPoint:CGPointMake(0, 0)];
        
        UIGraphicsPopContext();
    };
    if([NSThread currentThread].isMainThread) 
    {
        block();
        
    } 
    else
    {
        dispatch_sync(dispatch_get_main_queue(),block);
    }
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    UIImage * retImage = [UIImage imageWithCGImage:newImage];
    CGImageRelease(newImage);
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    CGContextRelease(context); 
    return retImage;//CGBitmapContextGetData (context);
}


/*@implementation OpenGLAttributeUniform
 
 @synthesize variableName;
 @synthesize type;
 - (void) dealloc
 {
 self.variableName = nil;
 [super dealloc];
 }
 @end*/
/*@implementation OpenGLStep
 @synthesize textures;
 -(id) init{
 if(!(self=[super init]))
 {
 return nil;
 }
 // default gaussion blur radius
 return self;  
 }
 - (void) dealloc{
 
 [super dealloc];
 }
 @end*/
@interface OpenGLRenderCenter()
@property (retain) UIImage *resultImage;
@property (assign) void *resultData; 
@property (retain) NSArray* entries;
@property (assign) uint postFilterMode;
@property (assign,readonly) GLfloat degreeStrenth;
@property (assign,readonly) GLfloat degreeSaturation;
@property (assign,readonly) GLfloat degreeBrightness;
@property (assign,readonly) GLfloat degreeContrast;
//@property (retain) NSString* systemContent;
- (void)createEntryFromXML:(NSString *)data entryCollector:(NSMutableArray*) entryCollector independnt:(BOOL) independent;
- (void)deleteRawTexture;
- (void)deleteBorderTexture;
-(NSString*) appendCommonToVetexSource:(NSString*) source;
-(NSString*) appendCommonToShadeSource:(NSString*) source;
- (void)openGLHookImage:(UIImage *)image autoAdjust:(BOOL) autoAdjust;
- (void)openGLHookImage:(UIImage *)image;
- (void) fetechImage;//:(BOOL)needRotate;
//- (void)setupAttForCustPro:(NSNumber *)program;
//- (void)setupUniformsForCustPro:(NSNumber *)program;
//- (void) processCameraFrame:(CVImageBufferRef)cameraFrame needRotate:(BOOL)needRotate useTheBufferSize:(BOOL)useBufferSize;
- (OpenGLEntry*) getSystemFilterEntryByName:(NSString*) name;
@end
@interface OpenGLEntry : NSObject
{
    NSDictionary* _data;
    GLint *_intStore;
    GLfloat *_floatStore;
    NSArray *_steps;
    
    GLint _glslUniforms[GLSL_NUM_UNIFORMS];
    GLuint _program;
    
    GLuint _myTextureStorage[TEXTURE_MAX];
    GLfloat *_pointersAttributes[20];
    uint _attrIndex;
}
//@property int radiusForConvlution;
@property (retain) NSArray *steps;
@property (assign) BOOL independent;
@property (retain,readonly)NSString* vetexSource;
@property (retain,readonly)NSString* shadeSource;
@property (retain,readonly)NSArray *globalTextures;
@property (assign) OpenGLRenderCenter *parentRender;
@property (assign) uint globalTextureIndex;
@property (retain,readonly) NSString *name;
//@property int radius;
-(id) initWithFilter:(NSString*) filterScript StringType:(CLGLFilterSourceType) type;
-(id) initWithXMLEL:(TBXMLElement *)proRootEle;
-(void) internalInitWithXMLEL:(TBXMLElement *)proRootEle;
-(NSString *) getCommonCLGL:(CLGLSourceType) type;
-(NSString *) getExtraCLGL:(CLGLSourceType) type;
-(NSArray *) getUniformKeyList;
-(NSArray *) getAttributeKeyList;
-(void) setDefaultUniformValues:(BOOL) includeOnce;
-(void) compile;
-(void) applyTexture;
-(void) applyProgram;
-(void) applyExtraAttribute;
-(void) renderEntry:(OpenGLSLEntryPrepare) prepareBlock backupBufferIndex:(int) backupBufferIndex;
-(void) releaseAttributeMem;
-(GLint) getUniformPosByKey:(NSString*)key;
- (void) dealloc;
@end

@implementation OpenGLEntry
//@synthesize radiusForConvlution;
@synthesize steps=_steps;
@synthesize independent;
@synthesize parentRender;
@synthesize globalTextures;
@synthesize globalTextureIndex;
@dynamic shadeSource,vetexSource;
@dynamic name;
-(NSString *) name
{
    return [_data valueForKey:GL_DATA_KEY_NAME];
}
-(NSArray *) globalTextures
{
    return [_data valueForKey:GL_DATA_KEY_TEXTURES];  
}
-(void) gatherVariableInfor:(NSString*) key parentElement:(TBXMLElement*) parent collecter:(NSMutableDictionary*)data
{
    TBXMLElement * varsEl = [TBXML childElementNamed:key parentElement:parent];
    
    if(varsEl) 
    {
        NSMutableArray *attribList =  [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
        [data setObject:attribList forKey:key];
        
        TBXMLElement * eachEl = [TBXML childElementNamed:GL_DATA_KEY_ELEMENT_KEY parentElement:varsEl];
        
        // if an element was found
        while (eachEl != nil) {
            
            NSMutableDictionary *dataEl =  [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
            [attribList addObject:dataEl];
            // get the variableName attribute from the element
            [dataEl setObject:[TBXML valueOfAttributeNamed:@"variableName" forElement:eachEl] forKey:@"variableName"] ;
            NSString *varType = [TBXML valueOfAttributeNamed:@"vartype" forElement:eachEl];
            if(varType)
            {
                [dataEl setObject:varType forKey:@"vartype"];
            }
            NSString *once = [TBXML valueOfAttributeNamed:@"once" forElement:eachEl];
            if(once)
            {
                [dataEl setObject:once forKey:@"once"];     
            }
            NSString *val = [TBXML textForElement:eachEl];
            NSArray *valList = [[val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@","];
            NSMutableArray *convertedValList = [[[NSMutableArray alloc]init]autorelease];
            [dataEl setObject:convertedValList forKey:@"defaultValue"];
            /*if([@"int" isEqualToString:varType]) 
             {
             for (NSString *singleVal in valList) {
             [convertedValList addObject:[NSNumber numberWithInt:[singleVal intValue]]];
             }
             }
             else */
            {
                for (NSString *singleVal in valList) {
                    [convertedValList addObject:[NSNumber numberWithFloat:[singleVal floatValue]]];
                }    
            }
            eachEl = [TBXML nextSiblingNamed:GL_DATA_KEY_ELEMENT_KEY searchFromElement:eachEl];
        }
    }
    
}
- (void)gatherTexture:(TBXMLElement *)parent data:(NSMutableDictionary *)dataDict
{
    //textures
    TBXMLElement * textureEl = [TBXML childElementNamed:@"texture" parentElement:parent];
    NSMutableArray *textureList = [[[NSMutableArray alloc]init]autorelease];
    [dataDict setObject:textureList forKey:@"textures"];
    while (textureEl != nil)
    {
        NSMutableDictionary *textStepData =  [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
        [textureList addObject:textStepData];
        [textStepData setObject:[TBXML valueOfAttributeNamed:@"name" forElement:textureEl] forKey:@"name"];
        NSString *standardTexture = [TBXML valueOfAttributeNamed:@"standard" forElement:textureEl];
        [textStepData setObject:[NSNumber numberWithBool:NO] forKey:@"standard"];
        if(standardTexture && [@"1" isEqualToString:standardTexture])
        {
            [textStepData setObject:[NSNumber numberWithBool:YES] forKey:@"standard"];
        }
        //==================
        NSString *val = [TBXML textForElement:textureEl];
        if(val && [[val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]>0) {
            NSArray *valList = [[val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@","];
            NSMutableArray *convertedValList = [[[NSMutableArray alloc]init]autorelease];
            [textStepData setObject:convertedValList forKey:@"pixels"];
            {
                for (NSString *singleVal in valList) {
                    [convertedValList addObject:[NSNumber numberWithFloat:[singleVal floatValue]]];
                }    
            }
        }
        //=============
        textureEl = [TBXML nextSiblingNamed:@"texture" searchFromElement:textureEl];
    }
}

- (void)internalInitWithXMLEL:(TBXMLElement *)proRootEle
{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] initWithCapacity:10]; 
    _data = data;
    // instantiate an array to hold step objects
    NSMutableArray* steps  = [[NSMutableArray alloc] initWithCapacity:10];
    _steps = steps;
    [data setObject:steps forKey:@"steps"];  
    
    // if root element is valid
    if (proRootEle) {
        // search for the first author element within the root element's children
        NSString *filterName = [TBXML valueOfAttributeNamed:GL_DATA_KEY_NAME forElement:proRootEle];
        if(filterName)
        {
            [data setObject:filterName forKey:GL_DATA_KEY_NAME];
        }
        NSArray *singleValueEntryList =[[[NSArray alloc]initWithObjects:GL_DATA_KEY_COMMON_VSH,GL_DATA_KEY_COMMON_FSH,GL_DATA_KEY_EXTRA_VSH,GL_DATA_KEY_EXTRA_FSH,GL_DATA_KEY_VSH,GL_DATA_KEY_FSH, nil] autorelease];
        for (NSString *key in singleValueEntryList)
        {
            TBXMLElement * el= [TBXML childElementNamed:key parentElement:proRootEle];
            if(el)
            {
                [data setObject:[TBXML textForElement:el] forKey:key];
            }
            
        }
        [self gatherVariableInfor:GL_DATA_KEY_ATTRIBUTE_KEY parentElement:proRootEle collecter:data];
        [self gatherVariableInfor:GL_DATA_KEY_UNIFORM_KEY parentElement:proRootEle collecter:data];
        [self gatherTexture:proRootEle data:data];
        TBXMLElement * elSteps= [TBXML childElementNamed:@"steps" parentElement:proRootEle];
        if(elSteps)
        {
            TBXMLElement * eachStepEl = [TBXML childElementNamed:GL_DATA_KEY_ELEMENT_KEY parentElement:elSteps];
            
            // if an element was found
            while (eachStepEl != nil)
            {
                NSMutableDictionary *dataStepEl =  [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
                // ============= get the value
                [steps addObject:dataStepEl];
                {
                    TBXMLElement * valuesEl = [TBXML childElementNamed:@"value" parentElement:eachStepEl];
                    // if an element was found
                    while (valuesEl != nil)
                    {
                        NSString *val = [TBXML textForElement:valuesEl];
                        NSArray *valList = [[val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]componentsSeparatedByString:@","];
                        NSMutableArray *convertedValList = [[[NSMutableArray alloc]init]autorelease];
                        for (NSString *singleVal in valList) 
                        {
                            [convertedValList addObject:[NSNumber numberWithFloat:[singleVal floatValue]]];
                        }    
                        NSString *key = [TBXML valueOfAttributeNamed:@"name" forElement:valuesEl];
                        if(key)
                        {
                            [dataStepEl setObject:convertedValList forKey:key];
                        }
                        valuesEl = [TBXML nextSiblingNamed:@"value" searchFromElement:valuesEl];
                    }
                }
                // ===========get the texture
                {
                    [self gatherTexture:eachStepEl data:dataStepEl];
                }
                // ===========get the attribute
                [dataStepEl setValue:[NSNumber numberWithBool:NO] forKey:@"blend"];
                NSString* blend = [TBXML valueOfAttributeNamed:@"blend" forElement:eachStepEl];
                if(blend)
                {
                    if([blend isEqualToString:@"yes"] || [blend isEqualToString:@"1"] || [blend isEqualToString:@"true"])
                    {
                        [dataStepEl setValue:[NSNumber numberWithBool:YES] forKey:@"blend"];
                    }
                    NSString* sfactor = [TBXML valueOfAttributeNamed:@"sfactor" forElement:eachStepEl];
                    NSString* dfactor = [TBXML valueOfAttributeNamed:@"dfactor" forElement:eachStepEl];
                    [dataStepEl setValue:[NSNumber numberWithUnsignedInt:GL_SRC_ALPHA] forKey:@"sfactor"]; 
                    [dataStepEl setValue:[NSNumber numberWithUnsignedInt:GL_ONE_MINUS_SRC_ALPHA] forKey:@"dfactor"];
                    if(sfactor)
                    {
                        int value = [sfactor intValue];
                        if(!value)
                        {
                            sscanf([sfactor UTF8String], "%x", &value);
                        }
                        [dataStepEl setValue:[NSNumber numberWithUnsignedInt:value] forKey:@"sfactor"]; 
                    } 
                    if(dfactor)
                    {
                        int value = [dfactor intValue];
                        if(!value)
                        {
                            sscanf([dfactor UTF8String], "%x", &value);
                        }
                        [dataStepEl setValue:[NSNumber numberWithUnsignedInt:value] forKey:@"dfactor"];
                    }
                    
                }
                
                eachStepEl = [TBXML nextSiblingNamed:GL_DATA_KEY_ELEMENT_KEY searchFromElement:eachStepEl];
            }
        }
    }
}
-(id) initWithXMLEL:(TBXMLElement *)proRootEle
{
    if(!(self=[super init]))
    {
        return nil;
    }
    [self internalInitWithXMLEL:proRootEle];
    return self;
}
-(id) initWithFilter:(NSString*) filterScript  StringType:(CLGLFilterSourceType) type
{
    if(!(self=[super init]))
    {
        return nil;
    }
    if (type == JSON) {
        _data = [[filterScript JSONValue] retain];
        self.steps = [_data valueForKey:@"steps"];
    } else {
        
        // Load and parse the script xml file
        TBXML* tbxml = [[TBXML tbxmlWithXMLString:filterScript] retain];
        
        // Obtain root element
        TBXMLElement * root = tbxml.rootXMLElement;
        
        [self internalInitWithXMLEL:root];
        
        // release resources
        [tbxml release];
    }
    // default gaussion blur radius
    //self.radius = 5;
    return self;
}
//@synthesize radius;
-(NSString *) getCommonCLGL:(CLGLSourceType) type
{
    return [_data valueForKey:(type==CLGLVsh?GL_DATA_KEY_COMMON_VSH:GL_DATA_KEY_COMMON_FSH)];
}
-(NSString *) getExtraCLGL:(CLGLSourceType) type
{
    return [_data valueForKey:(type==CLGLVsh?GL_DATA_KEY_EXTRA_VSH:GL_DATA_KEY_EXTRA_FSH)];
}
-(NSString *) shadeSource
{
    return [_data valueForKey:GL_DATA_KEY_FSH];  
}

-(NSString *) vetexSource 
{
    return [_data valueForKey:GL_DATA_KEY_VSH];
}
-(NSArray *) getAttributeKeyList
{
    return [_data valueForKey:GL_DATA_KEY_ATTRIBUTE_KEY];
}
-(NSArray *) getUniformKeyList
{
    return [_data valueForKey:GL_DATA_KEY_UNIFORM_KEY];
}
-(void) compile
{
    OpenGLSLFunctionPrepare setupAtt = ^(GLuint program){
        // Bind attribute locations.
        // This needs to be done prior to linking.
        glBindAttribLocation(program, GLSL_ATTRIB_VERTEX, ATTRIBUTE_KEY_LIST[GLSL_ATTRIB_VERTEX -  GLSL_ATTRIB_BOUND]);
        glBindAttribLocation(program, GLSL_ATTRIB_TEXTUREPOSITION, ATTRIBUTE_KEY_LIST[GLSL_ATTRIB_TEXTUREPOSITION -  GLSL_ATTRIB_BOUND]);
        //customized attibute
        NSArray *attributeList = [self getAttributeKeyList];
        if(attributeList)
        {
            for (int i=0; i<GLSL_ATTRIB_BOUND && i<attributeList.count; i++) 
            {
                glBindAttribLocation(program, i, [[[attributeList objectAtIndex:i] valueForKey: @"variableName"]UTF8String]);
            }
        }
    };
    
    OpenGLSLFunctionPrepare setupUniform = ^(GLuint program)
    {
        // Get uniform locations.
        _glslUniforms[GLSL_UNIFORM_VIDEOFRAME] = glGetUniformLocation(program, "videoFrame");//UNIFORM_KEY_LIST[GLSL_UNIFORM_VIDEOFRAME-GLSL_UNIFORM_BOUND]);
        //_glslUniforms[GLSL_UNIFORM_KERNEL] = glGetUniformLocation(program, UNIFORM_KEY_LIST[GLSL_UNIFORM_KERNEL-GLSL_UNIFORM_BOUND]);
        //_glslUniforms[GLSL_UNIFORM_OFFSET] = glGetUniformLocation(program, UNIFORM_KEY_LIST[GLSL_UNIFORM_OFFSET-GLSL_UNIFORM_BOUND]);
        
        _glslUniforms[GLSL_UNIFORM_WIDTH] = glGetUniformLocation(program, UNIFORM_KEY_LIST[GLSL_UNIFORM_WIDTH-GLSL_UNIFORM_BOUND]);
        _glslUniforms[GLSL_UNIFORM_HEIGHT] = glGetUniformLocation(program, UNIFORM_KEY_LIST[GLSL_UNIFORM_HEIGHT-GLSL_UNIFORM_BOUND]);
        //_glslUniforms[GLSL_UNIFORM_VERTICAL] = glGetUniformLocation(program, UNIFORM_KEY_LIST[GLSL_UNIFORM_VERTICAL-GLSL_UNIFORM_BOUND]);
        
        //add customized uniforms
        NSArray *uniformList = [self getUniformKeyList];
        if(uniformList)
        {
            for (int i=0; i<GLSL_UNIFORM_BOUND && i<uniformList.count; i++) 
            {
                _glslUniforms[i] = glGetUniformLocation(program, [[[uniformList objectAtIndex:i] valueForKey:@"variableName"]UTF8String]);
            }
        }
        
    };
    
    if(![self.parentRender loadVertexShader:&_program VetexSource:independent?self.vetexSource:[parentRender appendCommonToVetexSource:self.vetexSource]  FragmentSource:independent?self.shadeSource:[parentRender appendCommonToShadeSource:self.shadeSource] attributeSet:setupAtt uniformSet:setupUniform])
    {
        //exit(1);
    }
    if(![self.parentRender validateProgram:&_program])
    {
        //exit(1);
    }
    
    
    if(self.globalTextureIndex>TEXTURE_BOUND_START)
    {
        glDeleteTextures(self.globalTextureIndex - TEXTURE_BOUND_START, &_myTextureStorage[TEXTURE_BOUND_START]);
    }
    if(self.globalTextures)
    {
        //=============================
        int textureIndex = TEXTURE_BOUND_START;
        for (NSDictionary *texture in self.globalTextures) {
            [self.parentRender.openGL selectTextureUnit:textureIndex];
            glGenTextures(1, &_myTextureStorage[textureIndex]);
            NSArray* pixels = [texture objectForKey:@"pixels"];
            glBindTexture(GL_TEXTURE_2D, _myTextureStorage[textureIndex]);
            if(!pixels) {
                BOOL standard = [[texture objectForKey:@"standard"] boolValue];
                if(standard) {
                    [self.parentRender.openGL setTextureStandard];
                } else {
                    [self.parentRender.openGL setTextureDefault];
                }
                NSString *imageName = [texture valueForKey:@"name"];
                UIImage *image = [self.parentRender createTextureImageFromName:imageName];
                [self.parentRender openGLHookImage:image];
                [image release];
            } else {
                [self.parentRender.openGL setTextureForParameters];
                GLubyte *valArr = malloc(pixels.count*sizeof(GLubyte));
                for (int j=0; j<[pixels count]; j++) {
                    valArr[j] = [[pixels objectAtIndex:j] integerValue];
                }
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  pixels.count/4, 1, 0, GL_RGBA, GL_UNSIGNED_INT, valArr);
                free(valArr);
            }
            textureIndex++;
        }
        self.globalTextureIndex = textureIndex;
    } else
    {
        self.globalTextureIndex = TEXTURE_BOUND_START;
    }
    glUseProgram(_program);
    [self setDefaultUniformValues:YES];
    
    // when the new dimension is set, the parameter should be changed
    // current implementation is once the new dimension is set, the program will be recompiled
    //glUseProgram(_program);
    glUniform1i(_glslUniforms[GLSL_UNIFORM_VIDEOFRAME], TEXTURE_0);	
    glUniform1f(_glslUniforms[GLSL_UNIFORM_WIDTH], 1.0/[self.parentRender.openGL imageWidth]);
    glUniform1f(_glslUniforms[GLSL_UNIFORM_HEIGHT], 1.0/[self.parentRender.openGL imageHeight]);
    
}
-(void) setDefaultUniformValues:(BOOL) includeOnce
{
    NSArray *uniformList = [self getUniformKeyList];
    if(uniformList)
    {
        for (int i=0; i<GLSL_UNIFORM_BOUND && i<uniformList.count; i++) 
        {
            NSDictionary *currentUniform = [uniformList objectAtIndex:i];
            if(!includeOnce && [currentUniform objectForKey:@"once"])
            {
                continue;
            }
            id val = [currentUniform valueForKey: @"defaultValue"];
            if(val) 
            {
                if([val isKindOfClass: [NSArray class]]) 
                {
                    if([@"int" isEqualToString:[currentUniform valueForKey: @"vartype"]])
                    {
                        
                        GLint *valArr = malloc([val count]*sizeof(GLint));
                        for (int j=0; j<[val count]; j++) {
                            valArr[j] = [[val objectAtIndex:j] intValue];
                        }
                        glUniform1iv(_glslUniforms[i], [val count], valArr);
                        free(valArr);
                    } else 
                    {
                        GLfloat *valArr = malloc([val count]*sizeof(GLfloat));
                        for (int j=0; j<[val count]; j++) {
                            valArr[j] = [[val objectAtIndex:j] floatValue];
                        }
                        glUniform1fv(_glslUniforms[i], [val count], valArr);
                        free(valArr);
                    }
                } else {
                    if([@"int" isEqualToString:[currentUniform valueForKey: @"vartype"]])
                    {
                        glUniform1i(_glslUniforms[i], [val intValue]); 
                    } else {
                        glUniform1f(_glslUniforms[i], [val floatValue]);
                    }
                }
            }
        }
    } 
}
-(void)applyTexture
{
    if(self.globalTextures)
    {
        int textureIndex = TEXTURE_BOUND_START;
        //GLuint myOne;
        for (NSDictionary *texture in self.globalTextures) {
            [self.parentRender.openGL selectTextureUnit:textureIndex];
            glBindTexture(GL_TEXTURE_2D, _myTextureStorage[textureIndex]);
            textureIndex++;
        }
        self.globalTextureIndex = textureIndex;
    }
}
- (void)setAttribute:(NSNumber *)paramSize value:(NSArray *)vals varposition:(int)pos memoryaddress:(GLfloat **) currentMemeory
{
    int size = 2;
    if(paramSize)
    {
        size = [paramSize intValue];
    }
    GLfloat *valArr = malloc(vals.count*sizeof(GLfloat));
    *currentMemeory = valArr;
    for (int j=0; j<[vals count]; j++) {
        valArr[j] = [[vals objectAtIndex:j] floatValue];
    }
    //glVertexAttribPointer(GLSL_ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glVertexAttribPointer(pos, size, GL_FLOAT, 0, 0, valArr);
    //glEnableVertexAttribArray(pos);
    //==================.....
    //free(valArr);
}

- (void)setUniformValue:(id)val varpos:(GLint)varpos vartype:(NSString *)vartype
{
    if([val isKindOfClass: [NSArray class]]) 
    {
        if([@"int" isEqualToString:vartype])
        {
            
            GLint *valArr = malloc([val count]*sizeof(GLint));
            for (int i=0; i<[val count]; i++) {
                valArr[i] = [[val objectAtIndex:i] intValue];
            }
            glUniform1iv(varpos, [val count], valArr);
            free(valArr);
        } else 
        {
            GLfloat *valArr = malloc([val count]*sizeof(GLfloat));
            for (int i=0; i<[val count]; i++) {
                valArr[i] = [[val objectAtIndex:i] floatValue];
            }
            glUniform1fv(varpos, [val count], valArr);
            free(valArr);
        }
    } else {
        if([@"int" isEqualToString:vartype])
        {
            glUniform1i(varpos, [val intValue]); 
        } else {
            glUniform1f(varpos, [val floatValue]);
        }
    }
}
- (void) applyProgram
{
    glUseProgram(_program);
}
-(void) applyExtraAttribute
{
    NSArray *attributeList = [self getAttributeKeyList];
    memset(_pointersAttributes, 0x0, 20);
    _attrIndex = 0;
    if(attributeList)
    {
        for (int i=0; i<GLSL_ATTRIB_BOUND && i<attributeList.count; i++) 
        {
            NSArray* vals = [[attributeList objectAtIndex:i] valueForKey: @"defaultValue"];
            if(vals)
            {
                int size = 2;
                NSNumber* pSize = [[attributeList objectAtIndex:i] valueForKey: @"size"];
                if(pSize)
                {
                    size = [pSize intValue];
                }
                GLfloat *valArr = malloc(vals.count*sizeof(GLfloat));
                //============================== save pointer
                _pointersAttributes[_attrIndex++] = valArr;
                //==============================
                for (int j=0; j<[vals count]; j++) {
                    valArr[j] = [[vals objectAtIndex:j] floatValue];
                }
                glVertexAttribPointer(i, size, GL_FLOAT, 0, 0, valArr);
                //free(valArr);
                glEnableVertexAttribArray(i);
                //free(valArr);
            }
        }
    }
}
-(void) renderEntry:(OpenGLSLEntryPrepare) prepareBlock backupBufferIndex:(int) backupBufferIndex
{
    for (int i=0; i<self.steps.count; i++) {
        //
        //if(i>0)
        {
            //start = CFAbsoluteTimeGetCurrent();
            [self.parentRender.openGL activeRenderTextureStepByStep];
            
        }
        NSDictionary *currentStep = [self.steps objectAtIndex:i];
        NSNumber* blend = [currentStep valueForKey:@"blend"];
        if([blend boolValue])
        {
            glEnable(GL_BLEND);
            //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            GLenum sfactor = [[currentStep valueForKey:@"sfactor"] intValue];
            GLenum dfactor = [[currentStep valueForKey:@"dfactor"] intValue];
            glBlendFunc(sfactor, dfactor);
        } else {
            glDisable(GL_BLEND);
        }
        //OpenGLStep
        // 1. create texture for opengl
        // 2. load texture from memory deprecated 
        //int startIndex = textureIndex;
        //  [_openGL setTextureDefault];
        
        // 4. Update attribute values.
        NSArray *attributeList = [self getAttributeKeyList];
        if(attributeList)
        {
            for (int j=0; j<GLSL_ATTRIB_BOUND && j<attributeList.count; j++) 
            {
                NSString* key = [[attributeList objectAtIndex:j] valueForKey: @"variableName"];
                NSArray *vals = [currentStep objectForKey:key];
                NSNumber* pSize = [[attributeList objectAtIndex:j] valueForKey: @"size"];
                if(vals) {
                    [self setAttribute:pSize value:vals varposition:j memoryaddress:&_pointersAttributes[_attrIndex++]];
                }
                
            }
        }
        for (int j=GLSL_ATTRIB_BOUND+1; j<GLSL_NUM_ATTRIBUTES; j++) 
        {
            NSString* key = [NSString stringWithCString:ATTRIBUTE_KEY_LIST[j -  GLSL_ATTRIB_BOUND] encoding:NSASCIIStringEncoding] ;
            NSArray *vals = [currentStep objectForKey:key];
            NSNumber* pSize = nil;
            if(vals) {
                //============================== save pointer
                //pointersAttributes[++attrIndex] = valArr;
                //==============================
                [self setAttribute:pSize value:vals varposition:j memoryaddress:&_pointersAttributes[_attrIndex++]];
            }
            
        }
        NSArray *uniformList = [self getUniformKeyList];
        if(uniformList)
        {
            for (int j=0; j<GLSL_UNIFORM_BOUND && j<uniformList.count; j++) 
            {
                NSDictionary *currentUniform = [uniformList objectAtIndex:j];
                NSString* key = [currentUniform valueForKey: @"variableName"];
                GLint pos = _glslUniforms[j];
                NSString* vartype = [currentUniform valueForKey: @"vartype"];
                id val = [currentStep objectForKey:key];
                if(val) 
                {
                    [self setUniformValue:val varpos:pos vartype:vartype];
                }
            }
        }
        for (int j=GLSL_UNIFORM_BOUND+1; j<GLSL_NUM_UNIFORMS; j++) 
        {
            NSString* key = [NSString stringWithCString:UNIFORM_KEY_LIST[j -  GLSL_UNIFORM_BOUND] encoding:NSASCIIStringEncoding] ;
            NSArray *vals = [currentStep objectForKey:key];
            if(vals)
            {
                GLint pos = _glslUniforms[j];
                [self setUniformValue:vals varpos:pos vartype:nil];
            }
            
        }
        // 
        if(prepareBlock)
        {
            prepareBlock(self);
        }
        // call uniformset
        //uniformValueBlock(self);
        //[_openGL setTextureDefault];
        if(backupBufferIndex==2)
        {
            [self.parentRender.openGL saveToOutputBufferTexture];
        }
        else if(backupBufferIndex==1)
        {
            [self.parentRender.openGL saveBlurMiddleProductToBuffer];
        } 
        else if(backupBufferIndex==0)
        {
            [self.parentRender.openGL saveFrameToFrameTextureStepByStep];
        }
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        // 6. should release the current textures
    }
}
-(GLint) getUniformPosByKey:(NSString*)key
{
    GLint pos = -1;
    NSArray *uniformList = [self getUniformKeyList];
    if(uniformList)
    {
        for (int j=0; j<GLSL_UNIFORM_BOUND && j<uniformList.count; j++) 
        {
            NSDictionary *currentUniform = [uniformList objectAtIndex:j];
            NSString* currKey = [currentUniform valueForKey: @"variableName"];
            if([currKey isEqualToString:key])
            {
                return _glslUniforms[j];
            }
        }
    }
    for (int j=GLSL_UNIFORM_BOUND+1; j<GLSL_NUM_UNIFORMS; j++) 
    {
        NSString* currKey = [NSString stringWithCString:UNIFORM_KEY_LIST[j -  GLSL_UNIFORM_BOUND] encoding:NSASCIIStringEncoding] ;
        if([currKey isEqualToString:key])
        {
            return _glslUniforms[j];
        }
        
    }
    return pos;
}
-(void) releaseAttributeMem
{
    for(int i=0;i<_attrIndex;i++)
    {
        free(_pointersAttributes[i]);
    }
}
- (void) dealloc
{
    glDeleteProgram(_program);
    if(self.globalTextureIndex>TEXTURE_BOUND_START)
    {
        glDeleteTextures(self.globalTextureIndex - TEXTURE_BOUND_START, &_myTextureStorage[TEXTURE_BOUND_START]);
    }
    self.parentRender = nil;
    [_data release];
    self.steps = nil;
    [super dealloc];
}
@end



@implementation OpenGLRenderCenter
//@synthesize entry;
@synthesize quality = _quality;
@synthesize entries=_entries;
@synthesize systemEntries=_systemEntries;
@synthesize openGL=_openGL;
@synthesize staticPreviewMode = _staticPreviewMode;
@synthesize resultImage;
@synthesize needOnlyRawData;
@synthesize resultData;
//@synthesize globalTextureIndex;
@synthesize tiltShowMode;
@synthesize postFilterMode;
@synthesize usingIOS5;
@synthesize resourceProvider;
@dynamic degreeStrenthStandard;
@dynamic degreeSaturationStandard;
@dynamic degreeBrightnessStandard;
@dynamic degreeContrastStandard;

@dynamic degreeBrightness;
@dynamic degreeContrast;
@dynamic degreeSaturation;
@dynamic degreeStrenth;
+(void)initialize
{
    MAX_DIMENTION = 2048;
    //    if ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone 3g"]) {
    //           MAX_DIMENTION = 1024;
    //    }
    if ([[GlobalUtils getModel] isEqualToString:@"iPhone3GS"]) {
        MAX_DIMENTION = 1024;
    } else if([[GlobalUtils getModel] isEqualToString: @"iPod4thGen"])
    {
        MAX_DIMENTION = 1024;//1536; 
    }

}
- (void)clearPostFilter
{
    self.degreeBrightnessStandard = 0;
    self.degreeSaturationStandard = 0;
    self.degreeContrastStandard = 0;
    self.degreeStrenthStandard = 100;
}
#define CONVERT_STAND_VALUE(value,min,middle,max) (value>0?(value*(max-middle)/100.0+middle):(value*(middle-min)/100.0+middle))
-(GLfloat) degreeBrightness
{
    //return CONVERT_STAND_VALUE(self.degreeBrightnessStandard,-0.6,0,0.6);
    //return CONVERT_STAND_VALUE(self.degreeBrightnessStandard,-0.5,0,2);
    return CONVERT_STAND_VALUE(self.degreeBrightnessStandard,0.3,1,1.7);
}

-(GLfloat) degreeContrast
{
    //return CONVERT_STAND_VALUE(self.degreeContrastStandard,0.3,1,2);
    return CONVERT_STAND_VALUE(self.degreeContrastStandard,1,1,2);
    /*if(self.degreeContrastStandard>-5) {
       return CONVERT_STAND_VALUE(self.degreeContrastStandard,1,1,3.5); 
    } else {
       return CONVERT_STAND_VALUE(self.degreeContrastStandard,-2,-2,0); 
    }*/
}

-(GLfloat) degreeSaturation
{
    //(self.degreeSaturationStandard+100.0) * (5 - 0) / 200 + 0;
    //return CONVERT_STAND_VALUE(self.degreeSaturationStandard,0,1,5);
    return CONVERT_STAND_VALUE(self.degreeSaturationStandard,0,1,2);
}
-(GLfloat) degreeStrenth
{
    return CONVERT_STAND_VALUE((self.degreeStrenthStandard - 100),0,1,2);
}
-(int) degreeStrenthStandard
{
    return _degreeStrenthStandard;
}
#define SET_POSTFILTER_MODE(mode, smode,value) mode = value?mode|((uint)smode):mode&(~(uint)smode)
#define CLAMP(val) MIN(MAX(-100,val),100)
-(void) setDegreeStrenthStandard:(int)degreeStrenthStandard
{
    //_degreeStrenthStandard = CLAMP(degreeStrenthStandard);
    _degreeStrenthStandard = MIN(MAX(0,degreeStrenthStandard),200);
    /*if(_degreeStrenthStandard==0)
     {
     self.postFilterMode&=~((uint)GLSL_STRENTH);
     } else 
     {
     self.postFilterMode|=(uint)GLSL_STRENTH;
     }*/
    SET_POSTFILTER_MODE(self.postFilterMode, GLSL_STRENTH, (_degreeStrenthStandard-100));
}
-(int) degreeSaturationStandard
{
    return _degreeSaturationStandard;
}
-(void) setDegreeSaturationStandard:(int)degreeSaturationStandard
{
    _degreeSaturationStandard = CLAMP(degreeSaturationStandard);
    SET_POSTFILTER_MODE(self.postFilterMode, GLSL_SATURATE, _degreeSaturationStandard);
}
-(int) degreeBrightnessStandard
{
    return _degreeBrightnessStandard;
}
-(void) setDegreeBrightnessStandard:(int)degreeBrightnessStandard
{
    _degreeBrightnessStandard = CLAMP(degreeBrightnessStandard);
    SET_POSTFILTER_MODE(self.postFilterMode, GLSL_BRIGHT, _degreeBrightnessStandard);
}
-(int) degreeContrastStandard
{
    return _degreeContrastStandard;
}
-(void) setDegreeContrastStandard:(int)degreeContrastStandard
{
    //NSLog(@"==============%d", _degreeContrastStandard);
    //_degreeContrastStandard = MIN(MAX(-5,degreeContrastStandard),100);//CLAMP(degreeContrastStandard);
    _degreeContrastStandard = MIN(MAX(0,degreeContrastStandard),100);//CLAMP
    //NSLog(@"dsfsdfsfdsdf iiiiiii %d", _degreeContrastStandard);
    SET_POSTFILTER_MODE(self.postFilterMode, GLSL_CONTRAST, _degreeContrastStandard);
}
//@synthesize systemContent;
- (void)setRadiusTiltBlur:(GLfloat) distanceOrRadius X:(GLfloat)x Y:(GLfloat) y
{
    _distanceOrRadius = distanceOrRadius;
    _tiltX = x;
    _tiltY = y;
    _tiltBlurMode = TILT_RADIUS;
}
- (void)setParTiltBlur:(GLfloat) distanceOrRadius X:(GLfloat)x Y:(GLfloat) y angle:(GLfloat) angle
{
    _distanceOrRadius = distanceOrRadius;
    _tiltX = x;
    _tiltY = y;
    _angle = angle;
    _tiltBlurMode = TILT_PAR;
}
- (void)clearTiltBlur
{
    _tiltBlurMode = TILT_NONE;
    
    _distanceOrRadius = 0.0;
    _tiltX = 0.0;
    _tiltY = 0.0;
    _angle = 0.0;
}
//@synthesize filterStrenth;
/*@dynamic staticMode;
 -(BOOL) staticMode
 {
 return _staticMode;
 }
 -(void) setStaticMode:(BOOL)staticMode
 {
 _staticMode = staticMode;
 }*/
/*- (void)setFilterStrenth:(GLfloat) filterStrenth
 {
 _filterStrenth = filterStrenth;
 if(_filterStrenth - 1.0 > 0.0001 || _filterStrenth - 1.0 < -0.0001)
 {
 _isStrenthMode = YES; 
 } else {
 _isStrenthMode = NO;
 }
 }
 - (void)clearFilterStrenth
 {
 _filterStrenth = 1.0;
 _isStrenthMode = NO;
 }*/
-(NSString*) appendCommonToVetexSource:(NSString*) source
{
    return [NSString stringWithFormat:@"%@\n%@",[self getCommonGLSL:CLGLVsh],source];//self.entry.vetexSource];
}
-(NSString*) appendCommonToShadeSource:(NSString*) source
{
    return [NSString stringWithFormat:@"%@\n%@",[self getCommonGLSL:CLGLFsh],source];//self.entry.shadeSource];
}
-(void) internInitialize 
{
    
    //
    _entries = [[NSMutableArray alloc]init];
    _systemEntries = [[NSMutableArray alloc]init]; 
    _commonSource[CLGLVsh]= [[NSMutableString alloc]init];
    _commonSource[CLGLFsh]= [[NSMutableString alloc]init];
    _quality = 2.0;
    _openGL = [[OpenGLManager alloc]init];
    _degreeStrenthStandard = 100;
    //[self compileDirectShowProgram];
    _tiltBlurMode = TILT_NONE;
    NSString *fdPath = [[NSBundle mainBundle] pathForResource:@"filterAdjust.xml" ofType:nil]; //
    NSString *fdContent=[NSString stringWithContentsOfFile:fdPath encoding:NSUTF8StringEncoding error:nil];
    self.usingIOS5 = YES;
    //self.systemContent = fdContent;
    
    [self createEntryFromXML:fdContent entryCollector:_systemEntries independnt:YES];
    //_fd_entry = [[OpenGLEntry alloc]initWithFilter:fdContent StringType:XML];
    
    //NSString *blurPath = [[NSBundle mainBundle] pathForResource:@"blurAdjust.xml" ofType:nil]; //
    //NSString *fdBlurContent=[NSString stringWithContentsOfFile:blurPath encoding:NSUTF8StringEncoding error:nil];    
    //_fd_blur_entry =  [[OpenGLEntry alloc]initWithFilter:fdBlurContent StringType:XML];
}
-(id) init
{
    if(!(self=[super init]))
    {
        return nil;
    }
    [self internInitialize];
    return self;
}


- (BOOL)loadVertexShader:(GLuint *) programPointer VetexSource:(const NSString*)vetexSource FragmentSource:(const NSString*) fragSource  attributeSet:(OpenGLSLFunctionPrepare) attributeSet uniformSet:(OpenGLSLFunctionPrepare) uniformSet
{
    //NSString *vertexSource;
    //NSString *fragmentSource;
    
    GLuint vertexShader, fragShader;
	
    if(*programPointer > 0)
    {
        glDeleteProgram(*programPointer);
    }
    // Create shader program.
    *programPointer = glCreateProgram();
    
    
    // Create and compile vertex shader.
    if (![_openGL compileShader:&vertexShader type:GL_VERTEX_SHADER source:vetexSource])//[self getVetexSource]
    {
//        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    // Create and compile fragment shader.
    if (![_openGL compileShader:&fragShader type:GL_FRAGMENT_SHADER source:fragSource])//[self getShadeSource]
    {
//        NSLog(@"Failed to compile fragment shader\n%@",fragSource);
        return FALSE;
    }
    
    // Attach vertex shader to program.
    glAttachShader(*programPointer, vertexShader);
    
    // Attach fragment shader to program.
    glAttachShader(*programPointer, fragShader);
    
    //[self setupAttForCustPro:programPointer];
    //[self performSelector:attributeSet withObject:[NSNumber numberWithUnsignedInt:*programPointer]];
    attributeSet(*programPointer);
    //glBindAttribLocation(_program, ATTRIB_TEXTUREPOSITON2, "inputTextureCoordinate2");
    // Link program.
    if (![_openGL linkProgram:*programPointer])
    {
//        NSLog(@"Failed to link program: %d", *programPointer);
        
        if (vertexShader)
        {
            glDeleteShader(vertexShader);
            vertexShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (*programPointer)
        {
            glDeleteProgram(*programPointer);
            *programPointer = 0;
        }
        
        return FALSE;
    }
    
    //[self setupUniformsForCustPro:programPointer];
    //[self performSelector:uniformSet withObject:[NSNumber numberWithUnsignedInt:*programPointer]];
    uniformSet(*programPointer);
    
    // Release vertex and fragment shaders.
    if (vertexShader)
	{
        glDeleteShader(vertexShader);
	}
    if (fragShader)
	{
        glDeleteShader(fragShader);		
	}
    
    return TRUE;
}
-(NSString *)getCommonGLSL:(CLGLSourceType) type
{
    // clear current file
    [_commonSource[type] setString:@""];
    NSString *commonPath = [[NSBundle mainBundle] pathForResource:(type==CLGLVsh?@"Commonvsh":@"Commonfsh") ofType:nil];
    [_commonSource[type] appendString:[NSString stringWithContentsOfFile:commonPath encoding:NSUTF8StringEncoding error:nil]]; 
    return _commonSource[type];
}
- (BOOL)validateProgram:(GLuint *) programPointer 
{
    return [_openGL validateProgram:*programPointer];
}

- (void)createEntryFromXML:(NSString *)data entryCollector:(NSMutableArray*) entryCollector independnt:(BOOL)independent
{
    [entryCollector removeAllObjects];
    // Load and parse the script xml file
    TBXML* tbxml = [[TBXML tbxmlWithXMLString:data] retain];
    
    // Obtain root element
    TBXMLElement * root = tbxml.rootXMLElement;
    NSString *eleName = [TBXML elementName:root];
    if([eleName isEqualToString:@"filter"])
    {
        OpenGLEntry *entry = [[[OpenGLEntry alloc] initWithXMLEL:root]autorelease];
        entry.independent = independent;
        entry.parentRender = self;
        [entryCollector addObject:entry];
    } else {
        TBXMLElement * filterEl = [TBXML childElementNamed:@"filter" parentElement:root];
        
        // if an element was found
        while (filterEl != nil) {
            OpenGLEntry *entry = [[[OpenGLEntry alloc] initWithXMLEL:filterEl]autorelease];
            entry.independent = independent;
            entry.parentRender = self;
            [entryCollector addObject:entry];
            filterEl = [TBXML nextSiblingNamed:@"filter" searchFromElement:filterEl];
        }
    }
    //TBXMLElement * textureEl = [TBXML childElementNamed:@"texture" parentElement:parent];
    // release resources
    [tbxml release];
}

- (void) installProgram:(NSString *)data;//  StringType:(CLGLFilterSourceType) type
{
    [self createEntryFromXML:data entryCollector:_entries independnt:NO];
    
    [self compileAllProgram];
    
}
- (void)compileAllProgram
{
    [self compileTargetProgram];
    
    [self compileDirectShowProgram];
    
    [self compileFilterAdjustProgram]; 
}
- (void)compileTargetProgram
{
    for (OpenGLEntry *entry in _entries)
    {
        [entry compile];
    }
    
    //[self compileBlurAdjustProgram];
    //self.needOnlyRawData = YES;
}

- (void) setNewDimention:(int) width Height:(int) height  preview:(BOOL) preview;
{
    [_openGL setSize:width Height:height preview:preview];
    
    //[self compileTargetProgram];
    //[self compileAllProgram];
}
- (void) setupProgram:(int) width Height:(int) height Data:(NSString*)data StringType:(CLGLFilterSourceType) type;
{
    [self setupProgram:width Height:height Data:data StringType:type preview:NO];
}
-(void) setupProgram:(int) width Height:(int) height Data:(NSString *)data  StringType:(CLGLFilterSourceType) type preview:(BOOL)preview
{
    //[_openGL setSize:width Height:height preview:preview];
    
    if(preview)
    {
        
        //float maxDimention = MAX(width, height);
        float widthfinal = width;
        float heightfinal = height;
        _openGL.glMode = VIEW_MODE;
        if(widthfinal>_openGL.origionlFrame.size.width * _quality || heightfinal>_openGL.origionlFrame.size.height * _quality)
        {
            float rate = MAX(widthfinal/(_openGL.origionlFrame.size.width * _quality), heightfinal/(_openGL.origionlFrame.size.height * _quality));
            widthfinal = (int)(widthfinal /rate);
            heightfinal = (int)(heightfinal/rate);
        }
        [_openGL setSize:widthfinal Height:heightfinal preview:preview];
    } 
    else 
    {
        [_openGL setSize:width Height:height preview:preview];
    }
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    [self installProgram:data];
//    NSLog(@"time consuming:%f",  CFAbsoluteTimeGetCurrent() - start);
}
- (void) processCameraFrame:(CVImageBufferRef)cameraFrame 
{
    [self processCameraFrame:cameraFrame orientation:UIImageOrientationRight];
}
- (void)setupTextureCameraFrameOldVersion:(CVImageBufferRef)cameraFrame
{
    int bufferHeight = CVPixelBufferGetHeight(cameraFrame);
	int bufferWidth = CVPixelBufferGetWidth(cameraFrame);
    // Width and height should be reversed
    _textureWidthStep = 1.0 / bufferHeight;
    _textureHeightStep= 1.0 / bufferWidth;
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(cameraFrame);
    
    if((bufferWidth<<2) < bytesPerRow)
    {
        bufferWidth = bytesPerRow/4;
    }
    if(bufferWidth*4 > bytesPerRow && bufferWidth*3 < bytesPerRow)
    {
        bufferWidth = bytesPerRow/3; 
    }
    if(bufferWidth*3 > bytesPerRow && bufferWidth*2 < bytesPerRow)
    {
        bufferWidth = bytesPerRow/2; 
    }
    if(bufferWidth*2 > bytesPerRow && bufferWidth < bytesPerRow)
    {
        bufferWidth = bytesPerRow; 
    }
    //NSLog(@"width %d,height %d",bufferWidth,bufferHeight);
    //[_openGL switchToSecondFrameBuffer];
    
    [self deleteRawTexture];
    [_openGL selectTextureUnit:TEXTURE_0];
    if(!_videoFrameTexture) 
    {
        glGenTextures(1, &_videoFrameTexture);
    }
	glBindTexture(GL_TEXTURE_2D, _videoFrameTexture);
    
    
    [_openGL setTextureDefault];
    
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bufferWidth, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(cameraFrame));
}
- (void)setupTextureCameraFrameIOS5:(CVImageBufferRef)cameraFrame
{
    [self deleteRawTexture];
    // Create a CVOpenGLESTexture from the CVImageBuffer
	size_t frameWidth = CVPixelBufferGetWidth(cameraFrame);
	size_t frameHeight = CVPixelBufferGetHeight(cameraFrame);
    // Width and height should be reversed
    _textureWidthStep = 1.0 / frameHeight;
    _textureHeightStep= 1.0 / frameWidth;
    CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, 
                                                                _openGL.videoTextureCacheIOS5,
                                                                cameraFrame,
                                                                NULL,
                                                                GL_TEXTURE_2D,
                                                                GL_RGBA,
                                                                frameWidth,
                                                                frameHeight,
                                                                GL_BGRA,
                                                                GL_UNSIGNED_BYTE,
                                                                0,
                                                                &_IOS5texture);
    if (!_IOS5texture || err) {
        NSLog(@"CVOpenGLESTextureCacheCreateTextureFromImage failed (error: %d)", err);  
        return;
    }
    [_openGL selectTextureUnit:TEXTURE_0];
    glBindTexture(CVOpenGLESTextureGetTarget(_IOS5texture), CVOpenGLESTextureGetName(_IOS5texture));
    [_openGL setTextureDefault];
    
}
- (void) removeIOS5Texture
{
    if(_IOS5texture)
    {
        glBindTexture(CVOpenGLESTextureGetTarget(_IOS5texture), 0);
        
        // Flush the CVOpenGLESTexture cache and release the texture
        CVOpenGLESTextureCacheFlush(_openGL.videoTextureCacheIOS5, 0);
        CFRelease(_IOS5texture);   
        _IOS5texture = NULL;
    }
}
- (void)setupTextureWithCameraFrame:(CVImageBufferRef)cameraFrame
{
    _isLive = YES;
    if([self supportIOS5])
    {
        [self setupTextureCameraFrameIOS5:cameraFrame];
    } else {
        [self setupTextureCameraFrameOldVersion:cameraFrame];//GL_RGBA
    }
}
- (void) processCameraFrame:(CVImageBufferRef)cameraFrame orientation:(UIImageOrientation)orientation
{
    /*    [self processCameraFrame:cameraFrame needRotate:needRotate useTheBufferSize:NO];
     }
     - (void) processCameraFrame:(CVImageBufferRef)cameraFrame needRotate:(BOOL)needRotate useTheBufferSize:(BOOL)useBufferSize
     {*/
    [self setupTextureWithCameraFrame:cameraFrame];
    
	[self render:orientation willKeepTexture:YES];
    //CVPixelBufferUnlockBaseAddress(cameraFrame, 0);    
    //NSLog(@"dddddd:%f", CFAbsoluteTimeGetCurrent() - start);
    
	//glDeleteTextures(1, &_videoFrameTexture);
    
    
}
/*- (void) processRawBytes:(UInt8*)rawData bufferWidth:(int)bufferWidth bufferHeight:(int)bufferHeight
 {
 [self deleteRawTexture];
 [_openGL selectTextureUnit:TEXTURE_0];
 glGenTextures(1, &_videoFrameTexture);
 glBindTexture(GL_TEXTURE_2D, _videoFrameTexture);
 [_openGL setTextureDefault];
 
 glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bufferWidth, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, rawData);//GL_RGBA
 
 
 //CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
 [self render:UIImageOrientationRight willKeepTexture:NO];
 }*/
/*- (void) processCameraFrameWithRealSize:(CVImageBufferRef)cameraFrame
 {
 [self processCameraFrameWithRealSize:cameraFrame willKeepTexture:YES];
 }
 - (void) processCameraFrameWithRealSize:(CVImageBufferRef)cameraFrame willKeepTexture:(BOOL)willKeepTexture
 {
 _oldmod = _openGL.glMode;
 _openGL.glMode =OFFSCREEN_MODE;
 _oldWidth = _openGL.width;
 _oldHeight = _openGL.height;
 //[_openGL setSize:image.size.width Height:image.size.height];
 [self processCameraFrame:cameraFrame willKeepTexture:willKeepTexture useTheBufferSize:YES];//YES
 //[_openGL setSizeReenter:oldWidth Height:oldHeight];
 //_openGL.glMode = oldmod;
 //[self Restore];
 } */
- (void)openGLHookImage:(UIImage *)image
{
    [self openGLHookImage:image autoAdjust:NO];
}
- (void)openGLHookImage:(UIImage *)image  autoAdjust:(BOOL) autoAdjust
{
	//==================================
    UInt8 * m_PixelBuf = CopyDataFromImage(image, autoAdjust); 
    //int width = CGImageGetWidth(image.CGImage);
    //int height = CGImageGetHeight(image.CGImage);
    int width = image.size.width;
    int height = image.size.height;
	// Using BGRA extension to pull in image data directly
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_BGRA, GL_UNSIGNED_BYTE, m_PixelBuf);
    free(m_PixelBuf);
}
- (void) setGLLayer:(CAEAGLLayer *) layer
{
    [_openGL setEaglLayer:layer];
}
-(void) setGlMode:(RENDER_MODE)mode
{
    [_openGL setGlMode:mode];
}
- (void) processImage
{
    [self processImage:UIImageOrientationUp];
}
- (void) processImage:(UIImageOrientation)orientation//:(UIImage *)image
{
    /*
     
     // Parse CGImage info
     info       = CGImageGetBitmapInfo(CGImage);        // CGImage may return pixels in RGBA, BGRA, or ARGB order
     colormodel = CGColorSpaceGetModel(CGImageGetColorSpace(CGImage));
     size_t bpp = CGImageGetBitsPerPixel(CGImage);
     
     components = bpp>>3;
     rowBytes   = CGImageGetBytesPerRow(CGImage);    // CGImage may pad rows
     imgWide = CGImageGetWidth(CGImage);
     imgHigh = CGImageGetHeight(CGImage);
     
     
     // Choose OpenGL format
     switch(info & kCGBitmapAlphaInfoMask)
     {
     case kCGImageAlphaPremultipliedFirst:
     case kCGImageAlphaFirst:
     case kCGImageAlphaNoneSkipFirst:
     format = GL_BGRA;
     break;
     default:
     format = GL_RGBA;
     }
     */
    [_openGL selectTextureUnit:TEXTURE_0];
	glBindTexture(GL_TEXTURE_2D, _videoFrameTexture);
	//[self render:_imageOrientation!=0 willKeepTexture:YES];
    [self render:orientation willKeepTexture:YES];
	//glDeleteTextures(1, &_videoFrameTexture);
    //CFRelease(m_DataRef);
}
//#define MAX_DIMENTION 2048
- (void) registerImage:(UIImage *)image forPreview:(BOOL) forPreview
{
    float maxDimention = MAX(image.size.width, image.size.height);
    float width = image.size.width;
    float height = image.size.height;
    if(forPreview)
    {
        _openGL.glMode = VIEW_MODE;
        if([_openGL supportFastOpenGL]||self.staticPreviewMode)
        {
            if(width>_openGL.origionlFrame.size.width*_quality || height>_openGL.origionlFrame.size.height*_quality)//width>420 || height>428
            {
                float rate = MAX(width/(_openGL.origionlFrame.size.width*_quality), height/(_openGL.origionlFrame.size.height*_quality));
                width = width /rate;
                height = height/rate;
            }
        } else {
            if(width>_openGL.origionlFrame.size.width || height>_openGL.origionlFrame.size.height)//width>420 || height>428
            {
                float rate = MAX(width/_openGL.origionlFrame.size.width, height/_openGL.origionlFrame.size.height);
                width = width /rate;
                height = height/rate;
            }
        }
    } 
    else
    {
        _openGL.glMode = OFFSCREEN_MODE;
        if(maxDimention > MAX_DIMENTION)
        {
            width = width * MAX_DIMENTION /maxDimention;
            height = height * MAX_DIMENTION/ maxDimention;
        }
    }
    UIImage *adjustSizedImage = [UIImage imageWithCGImage:image.CGImage scale:image.size.height/height orientation:image.imageOrientation];
    [_openGL setSize:(int)width  Height:(int)height preview:forPreview];
    
    //_imageOrientation = [image imageOrientation];

    _textureWidthStep = 1.0 /adjustSizedImage.size.width;
    _textureHeightStep = 1.0 / adjustSizedImage.size.height;
    [self deleteRawTexture];
    [_openGL selectTextureUnit:TEXTURE_0];
	glGenTextures(1, &_videoFrameTexture);
	glBindTexture(GL_TEXTURE_2D, _videoFrameTexture);
    [_openGL setTextureDefault];
    [self openGLHookImage:adjustSizedImage autoAdjust:YES];
}
//===================
- (CGSize) getImagePreviewSize:(UIImage *)image
{
    float width = image.size.width;
    float height = image.size.height;

    if(width>_openGL.origionlFrame.size.width || height>_openGL.origionlFrame.size.height)//width>420 || height>428
    {
        float rate = MAX(width/_openGL.origionlFrame.size.width, height/_openGL.origionlFrame.size.height);
//        width = width /rate;
        height = height/rate;
    }
    UIImage *adjustSizedImage = [UIImage imageWithCGImage:image.CGImage scale:image.size.height/height orientation:image.imageOrientation];
    return adjustSizedImage.size;
}
- (UIImage *) prepareImageForRegister:(UIImage *)image forPreview:(BOOL) forPreview
{
    float maxDimention = MAX(image.size.width, image.size.height);
    float width = image.size.width;
    float height = image.size.height;
    if(forPreview)
    {
        if([_openGL supportFastOpenGL]||self.staticPreviewMode)
        {
            if(width>_openGL.origionlFrame.size.width*_quality || height>_openGL.origionlFrame.size.height*_quality)//width>420 || height>428
            {
                float rate = MAX(width/(_openGL.origionlFrame.size.width*_quality), height/(_openGL.origionlFrame.size.height*_quality));
//                width = width /rate;
                height = height/rate;
            }
        } else {
            if(width>_openGL.origionlFrame.size.width || height>_openGL.origionlFrame.size.height)//width>420 || height>428
            {
                float rate = MAX(width/_openGL.origionlFrame.size.width, height/_openGL.origionlFrame.size.height);
//                width = width /rate;
                height = height/rate;
            }
        }
    } 
    else
    {
        if(maxDimention > MAX_DIMENTION)
        {
            height = height * MAX_DIMENTION/ maxDimention;
        }
    }
    UIImage *adjustSizedImage = [UIImage imageWithCGImage:image.CGImage scale:image.size.height/height orientation:image.imageOrientation];
    
    return NormalizeImage(adjustSizedImage);
}
- (void) registerImageAfterPrepare:(UIImage *)image forPreview:(BOOL) forPreview
{
    float width = image.size.width;
    float height = image.size.height;
    if(forPreview)
    {
        _openGL.glMode = VIEW_MODE;
    } 
    else
    {
        _openGL.glMode = OFFSCREEN_MODE;
    }
    [_openGL setSize:(int)width  Height:(int)height preview:forPreview];
    
    _textureWidthStep = 1.0 /image.size.width;
    _textureHeightStep = 1.0 / image.size.height;
    [self deleteRawTexture];
    [_openGL selectTextureUnit:TEXTURE_0];
	glGenTextures(1, &_videoFrameTexture);
	glBindTexture(GL_TEXTURE_2D, _videoFrameTexture);
    [_openGL setTextureDefault];
    [self openGLHookImage:image autoAdjust:NO]; 
}
- (void) registerBorderImage:(UIImage *)image
{
    [self deleteBorderTexture];
    if(image)
    {
        [_openGL selectTextureUnit:TEXTURE_7];
        glGenTextures(1, &_borderTexture);
        glBindTexture(GL_TEXTURE_2D, _borderTexture);
        [_openGL setTextureDefault];
        [self openGLHookImage:image autoAdjust:NO]; 
    }
}
- (void) clearBorderImage
{
    [self deleteBorderTexture];
}
//============

- (OpenGLEntry*) getSystemFilterEntryByName:(NSString*) name
{
    for(OpenGLEntry *entry in _systemEntries)
    {
        if([name isEqualToString:entry.name ])
        {
            return entry;
        }
    }
    return nil;
}
- (void)setDefaultAttribute
{
    // 4. Update attribute values.
    glVertexAttribPointer(GLSL_ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(GLSL_ATTRIB_VERTEX);
    glVertexAttribPointer(GLSL_ATTRIB_TEXTUREPOSITION, 2, GL_FLOAT, 0, 0, textureVerticesUp); 
    glEnableVertexAttribArray(GLSL_ATTRIB_TEXTUREPOSITION);
}

- (void)deleteRawTexture
{
    if(_videoFrameTexture)
    {
        glDeleteTextures(1, &_videoFrameTexture);
        _videoFrameTexture = 0;
    }
    //if(_IOS5texture)
    {
        // internal evaluate
        [self removeIOS5Texture];
    }
}
- (void)deleteBorderTexture
{
    if(_borderTexture)
    {
        glDeleteTextures(1, &_borderTexture);
        _borderTexture = 0;
    }
}
- (void)tiltShiftBlur
{
    /*if(_isLive)
    {
        OpenGLEntry *blurEntry = [self getSystemFilterEntryByName:@"liveblurnew"];
        [blurEntry applyProgram];
        [self setDefaultAttribute];
        OpenGLSLEntryPrepare prepareBlock = ^(OpenGLEntry *entry){
            glUniform1f([entry getUniformPosByKey:@"stepwidth"], _textureWidthStep);
            glUniform1f([entry getUniformPosByKey:@"stepheight"], _textureHeightStep);
            [entry.parentRender.openGL activeRenderTextureStepByStep]; 
        };
        [blurEntry  renderEntry:prepareBlock backupBufferIndex:1];
        
        [blurEntry applyProgram];
    } else */
    {
        // just kindof backup
        //||self.staticPreviewMode ?
        NSString *blurFilterName =nil;
        if(_isLive || self.staticPreviewMode)
        {
            blurFilterName = _isLive?@"blur4low":@"blur8low";//_textureHeightStep>1.0/876.0?@"blur8low":@"blur12";
        } else {
            blurFilterName = _textureHeightStep>1.0/876.0?@"blur8":(_textureHeightStep>1.0/1024.0?@"blur12":@"blur16"); 
        }
        OpenGLEntry *blurEntry = [self getSystemFilterEntryByName:blurFilterName];
        
        [blurEntry applyProgram];
        [self setDefaultAttribute];
        OpenGLSLEntryPrepare prepareBlock = ^(OpenGLEntry *entry){
            /*if(!_isLive) {//&& !self.staticPreviewMode
                glUniform1f([entry getUniformPosByKey:@"stepwidth"], _textureWidthStep);
                glUniform1f([entry getUniformPosByKey:@"stepheight"], _textureHeightStep);
            } else*/
            {
                float stepWidth = 1.7*_textureWidthStep;
                float stepHeight= 1.7*_textureHeightStep;
                //1.2/[_openGL imageWidth]
                glUniform1f([entry getUniformPosByKey:@"stepwidth"], stepWidth);
                //1.2/[_openGL imageHeight]
                glUniform1f([entry getUniformPosByKey:@"stepheight"], stepHeight);
            }
            GLint blurOrientPos = [entry getUniformPosByKey:@"fd_blur_orientation"];
            glUniform2f(blurOrientPos,1.0,0.0);
            [entry.parentRender.openGL activeRenderTextureStepByStep]; 
        };
        [blurEntry  renderEntry:prepareBlock backupBufferIndex:1];
        
        [blurEntry applyProgram];
        
        prepareBlock = ^(OpenGLEntry *entry){
            GLint blurOrientPos = [entry getUniformPosByKey:@"fd_blur_orientation"];
            glUniform2f(blurOrientPos,0.0,1.0);
            [entry.parentRender.openGL activeBufferTextureForBlur:TEXTURE_1]; 
        };
        [blurEntry  renderEntry:prepareBlock backupBufferIndex:1];    
    }
}

-(void) render:(UIImageOrientation)orientation willKeepTexture:(BOOL) willKeepTexture
{
    //NSLog(@"%d,%d",[_openGL imageWidth], [_openGL imageHeight]);
    [_openGL preRender];
    //[self.openGL clearSave];   
    {
        //====================
        //[_openGL switchToMainFrameBuffer];
        //====================
        glUseProgram(_directShowProgram);
        [_openGL selectTextureUnit:TEXTURE_0];
        if([self supportIOS5]) 
        {
            glBindTexture(CVOpenGLESTextureGetTarget(_IOS5texture), CVOpenGLESTextureGetName(_IOS5texture)); 
        } 
        else
        {
            glBindTexture(GL_TEXTURE_2D, _videoFrameTexture);
        }
        glVertexAttribPointer(GLSL_ATTRIB_VERTEX_DIRECT, 2, GL_FLOAT, 0, 0, squareVertices);
        glEnableVertexAttribArray(GLSL_ATTRIB_VERTEX_DIRECT);
        //if(_openGL.glMode == VIEW_MODE)
        {
            //    glVertexAttribPointer(GLSL_ATTRIB_TEXTUREPOSITION_DIRECT, 2, GL_FLOAT, 0, 0, textureVerticesGLlayer);  
            //} else {
            const GLfloat * const vetexRefection[]={textureVerticesUp,textureVerticesDown, textureVerticesLeft,textureVerticesRight,textureVerticesUp,textureVerticesUp,textureVerticesUp,textureVerticesRightMirrored};
            glVertexAttribPointer(GLSL_ATTRIB_TEXTUREPOSITION_DIRECT, 2, GL_FLOAT, 0, 0, vetexRefection[orientation]); 
            /*if(orientation) {
             
             glVertexAttribPointer(GLSL_ATTRIB_TEXTUREPOSITION_DIRECT, 2, GL_FLOAT, 0, 0, textureVerticesRight);  
             } else {
             glVertexAttribPointer(GLSL_ATTRIB_TEXTUREPOSITION_DIRECT, 2, GL_FLOAT, 0, 0, textureVerticesImage);     
             }*/
        }
        glEnableVertexAttribArray(GLSL_ATTRIB_TEXTUREPOSITION_DIRECT);
        glUniform1i(_directShowUniformVideo, TEXTURE_0);
        //[_openGL saveFrameToFrameTexture];
        [_openGL saveRawTextureToBuffer];
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    }
    //==========================
    if(!willKeepTexture)
    {
        [self deleteRawTexture];
    }
    for (OpenGLEntry *currentEntry in _entries) {
        
        [currentEntry applyProgram];
        {
            
            [_openGL activeTextureSaveRawPictureAsMainTexture];
        } 
        
        //==================
        [currentEntry applyTexture];
        
        [self setDefaultAttribute];
        
        [currentEntry applyExtraAttribute];
        [currentEntry setDefaultUniformValues:NO];
        //int globalTextureIndex = textureIndex;
        //BOOL alreadyRemovedMain =NO;
        //CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
        //glDisable(GL_BLEND);; //TODO
        
        //for(int i=0;i<attrIndex;i++)
        //{
        //    free(pointersAttributes[i]);
        //}
        OpenGLSLEntryPrepare prepareBlock = ^(OpenGLEntry *entry){
            //NSLog(@"%d, width",[entry getUniformPosByKey:@"stepwidth"]);
            //NSLog(@"%d, height",[entry getUniformPosByKey:@"stepheight"]);
            glUniform1f([entry getUniformPosByKey:@"stepwidth"], _textureWidthStep);
            glUniform1f([entry getUniformPosByKey:@"stepheight"], _textureHeightStep);
        };
        [currentEntry renderEntry:prepareBlock backupBufferIndex:0];
        glDisable(GL_BLEND);
    }
    //return;
    uint currentMode = self.postFilterMode;
    if(currentMode||(_tiltBlurMode != TILT_NONE))// || _isStrenthMode (_tiltBlurMode != TILT_NONE && self.tiltShowMode)
    {
        
        if((currentMode&0x1))
        {
            OpenGLEntry *filterStrenthEntry = [self getSystemFilterEntryByName:@"filterstrenth"];
            //glUseProgram(_fd_Program);
            [filterStrenthEntry applyProgram];
            [self setDefaultAttribute];
            //glUniform1i(_fd_flag, 0x1);
            //glUniform1f(_fd_degree, self.degreeStrenth);
            //GLfloat self.degreeStrenth;
            OpenGLSLEntryPrepare prepareBlock = ^(OpenGLEntry *entry){
                GLint degreePos = [entry getUniformPosByKey:@"fd_degree"];
                glUniform1f(degreePos, entry.parentRender.degreeStrenth);
                //[_openGL activeFrameTextureAsMainTexture];
                
                [entry.parentRender.openGL activeRenderTextureStepByStep]; 
            };
            [filterStrenthEntry  renderEntry:prepareBlock backupBufferIndex:0];   
            //[_openGL activeFrameTexture]; 
            //[_openGL saveFrameToFrameTexture];
            //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);    
        } 
        
        if(_tiltBlurMode != TILT_NONE&&!self.tiltShowMode)
        {
            [self tiltShiftBlur];
            
            
            if(_tiltBlurMode == TILT_RADIUS)
            {
                
                OpenGLEntry *radiusMergeEntry = [self getSystemFilterEntryByName:@"radiusmerge"];
                [radiusMergeEntry applyProgram];
                
                OpenGLSLEntryPrepare prepareBlock = ^(OpenGLEntry *entry){
                    
                    GLint radiusPos = [entry getUniformPosByKey:@"fd_radius"];
                    glUniform1f(radiusPos, _distanceOrRadius);
                    
                    GLint centerPos = [entry getUniformPosByKey:@"fd_center"];
                    glUniform2f(centerPos, _tiltX,_tiltY);
                    GLint ratialPos = [entry getUniformPosByKey:@"fd_ratial"];
                    glUniform1f(ratialPos, [_openGL imageWidth]/(float)[_openGL imageHeight]);
                    [_openGL activeBufferTextureForBlur:TEXTURE_2];
                    GLint videoFrame2Pos = [entry getUniformPosByKey:@"videoFrame2"];
                    glUniform1i(videoFrame2Pos, TEXTURE_2);
                    
                    [_openGL activeRenderTextureStepByStep]; 
                    GLint videoFramePos = [entry getUniformPosByKey:@"videoFrame"];
                    glUniform1i(videoFramePos, TEXTURE_1);
                };
                [radiusMergeEntry  renderEntry:prepareBlock backupBufferIndex:0];
            } 
            else
            {
                GLfloat topX = _tiltX;
                GLfloat bottomX = _tiltX;
                GLfloat topY = _tiltY;
                GLfloat bottomY = _tiltY;
                GLfloat tanOfLine = 0;
                GLfloat fd_dy1 = 0.0;
                GLfloat fd_dy2 = 0.0;
                BOOL isHorizon = YES;
                //if((_angle>=135 && _angle<=180) || (_angle>=0&&_angle<=45))
                {
                    topY = _tiltY + _distanceOrRadius/cosf(_angle*M_PI/180);
                    bottomY = _tiltY - _distanceOrRadius/cosf(_angle*M_PI/180);
                    
                    tanOfLine =  tanf(_angle*M_PI/180);
                    fd_dy1 = topY - tanOfLine * topX;
                    fd_dy2 = bottomY - tanOfLine * bottomX;
                    //NSLog(@"ddddd %f",1/tanf(2*45*M_PI/180));
                }
                
                OpenGLEntry *tiltEntry = [self getSystemFilterEntryByName:isHorizon?@"titlparmerge":@"titlparHorizonmerge"];
                [tiltEntry applyProgram]; 
                OpenGLSLEntryPrepare prepareBlock = ^(OpenGLEntry *entry){
                    
                    GLint fd_tan_pos = [entry getUniformPosByKey:@"fd_tan"];
                    glUniform1f(fd_tan_pos, tanOfLine);
                    
                    GLint fd_dy1_pos = [entry getUniformPosByKey:isHorizon?@"fd_dy1":@"fd_dx1"];
                    glUniform1f(fd_dy1_pos, fd_dy1);
                    
                    GLint fd_dy2_pos = [entry getUniformPosByKey:isHorizon?@"fd_dy2":@"fd_dx2"];
                    glUniform1f(fd_dy2_pos, fd_dy2);
                    
                    GLint ratialPos = [entry getUniformPosByKey:@"fd_ratial"];
                    glUniform1f(ratialPos, isHorizon?[_openGL imageWidth]/(float)[_openGL imageHeight]:[_openGL imageHeight]/(float)[_openGL imageWidth]);
                    
                    [_openGL activeBufferTextureForBlur:TEXTURE_2];
                    GLint videoFrame2Pos = [entry getUniformPosByKey:@"videoFrame2"];
                    glUniform1i(videoFrame2Pos, TEXTURE_2);
                    
                    [_openGL activeRenderTextureStepByStep]; 
                    GLint videoFramePos = [entry getUniformPosByKey:@"videoFrame"];
                    glUniform1i(videoFramePos, TEXTURE_1);
                };
                [tiltEntry  renderEntry:prepareBlock backupBufferIndex:0];   
            }
            
            // restore the texture
            
        }
        
        //self.degreeStrenth placeholder
        /*GLfloat degrees[]={self.degreeStrenth,self.degreeBrightness,self.degreeContrast, self.degreeSaturation,};
        //NSLog(@"value======:%f",self.degreeStrenth);
        NSString *nameList[] = {nil,@"bright",@"contrast",@"saturate"};
        for (uint i=1; i<4; i++)
        {
            uint loopMode = (1<<i);
            if((currentMode&loopMode))
            {
                
                OpenGLEntry *entry = [self getSystemFilterEntryByName:nameList[i]];
                [entry applyProgram];
                [self setDefaultAttribute];
                GLfloat currDegree = degrees[i];
                OpenGLSLEntryPrepare prepareBlock = ^(OpenGLEntry *entry){
                    GLint degreePos = [entry getUniformPosByKey:@"fd_degree"];
                    glUniform1f(degreePos, currDegree);
                    [_openGL activeRenderTextureStepByStep]; 
                    GLint videoFramePos = [entry getUniformPosByKey:@"videoFrame"];
                    glUniform1i(videoFramePos, TEXTURE_1);
                };
                [entry  renderEntry:prepareBlock backupBufferIndex:0];
                //glUniform1f(_fd_degree, degrees[i]);
                //[_openGL activeFrameTexture]; 
                //[_openGL saveFrameToFrameTexture];
                
                //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
                
            }     
        }*/
        //=====================
        if(currentMode&0xE)
        {
            OpenGLEntry *entry = [self getSystemFilterEntryByName:@"brightsatcontrast"];
            [entry applyProgram];
            [self setDefaultAttribute];
            OpenGLSLEntryPrepare prepareBlock = ^(OpenGLEntry *entry){
                glUniform1f([entry getUniformPosByKey:@"fd_bright"], self.degreeBrightness);
                glUniform1f([entry getUniformPosByKey:@"fd_sat"], self.degreeSaturation);
                glUniform1f([entry getUniformPosByKey:@"fd_contrast"], self.degreeContrast);
                [_openGL activeRenderTextureStepByStep]; 
                GLint videoFramePos = [entry getUniformPosByKey:@"videoFrame"];
                glUniform1i(videoFramePos, TEXTURE_1);
            };
            [entry  renderEntry:prepareBlock backupBufferIndex:0];
        }
        //====================
        
    }
    // if there is a border
    if(_borderTexture)
    {
        OpenGLEntry *entry = [self getSystemFilterEntryByName:_textureWidthStep>_textureHeightStep?@"border":@"border2"];
        //NSLog(@"============%d",_textureWidthStep>_textureHeightStep);
        [entry applyProgram];
        [self setDefaultAttribute];
        OpenGLSLEntryPrepare prepareBlock = ^(OpenGLEntry *entry){
            [_openGL selectTextureUnit:TEXTURE_7];//TODO
            glBindTexture(GL_TEXTURE_2D, _borderTexture);
            GLint borderPos = [entry getUniformPosByKey:@"myBorder"];
            //NSLog(@"myBorder=======%d",borderPos);
            glUniform1i(borderPos, TEXTURE_7);
            [_openGL activeRenderTextureStepByStep];
            GLint videoFramePos = [entry getUniformPosByKey:@"videoFrame"];
            glUniform1i(videoFramePos, TEXTURE_1);
            //NSLog(@"compare:=======%f, %f",_textureWidthStep,_textureHeightStep);
            //glUniform1f([entry getUniformPosByKey:@"myflag"], _textureWidthStep - _textureHeightStep<0?0.0:1.0);
            //glUniform1f([entry getUniformPosByKey:@"myheight"], ); 
        };
        [entry  renderEntry:prepareBlock backupBufferIndex:0];
    }
    
    if([_openGL glMode]==OFFSCREEN_MODE)
    {
        [self.openGL clearSave];
        [self.openGL prepareContent];
        glDisable(GL_BLEND);
        OpenGLEntry *swizzleEntry = [self getSystemFilterEntryByName:([_openGL supportFastOpenGL]?@"swizzleIOS5":@"swizzle")];//swizzle
        [swizzleEntry applyProgram];
        [self setDefaultAttribute];
        OpenGLSLEntryPrepare prepareBlock = prepareBlock = ^(OpenGLEntry *entry){
            [_openGL activeRenderTextureStepByStep]; 
            GLint videoFramePos = [entry getUniformPosByKey:@"videoFrame"];
            glUniform1i(videoFramePos, TEXTURE_1);
        };
        [swizzleEntry renderEntry:prepareBlock backupBufferIndex:2];//
        [self.openGL flushContent];
        [self fetechImage];
        [self.openGL clearSave];
        //CVOpenGLESTextureCacheFlush(_openGL.videoTextureCacheIOS5, 0);

    }
    if(_tiltBlurMode != TILT_NONE && self.tiltShowMode)
    {
        
        if(_tiltBlurMode==TILT_RADIUS) {
            OpenGLEntry *tiltEntry = [self getSystemFilterEntryByName:@"titlradius"];
            [tiltEntry applyProgram];
            [self setDefaultAttribute];
            OpenGLSLEntryPrepare prepareBlock = prepareBlock = ^(OpenGLEntry *entry){
                //glEnable(GL_BLEND);
                //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
                //glUniform1f(_fd_radius, _distanceOrRadius);
                GLint radiusPos = [entry getUniformPosByKey:@"fd_radius"];
                glUniform1f(radiusPos, _distanceOrRadius);
                
                GLint centerPos = [entry getUniformPosByKey:@"fd_center"];
                glUniform2f(centerPos, _tiltX,_tiltY);
                //glUniform1f([entry getUniformPosByKey:@"fd_factor"], self.tiltShowMode?0.0:1.0);
                
                GLint ratialPos = [entry getUniformPosByKey:@"fd_ratial"];
                glUniform1f(ratialPos, [_openGL imageWidth]/(float)[_openGL imageHeight]);
                //NSLog(@"======w: %d,h: %d, ratio:%f",[_openGL imageWidth],[_openGL imageHeight],[_openGL imageWidth]/(float)[_openGL imageHeight]);
                //glUniform2f(_fd_center, _tiltX,_tiltY);
                //glUniform1i(_fd_flag, _tiltBlurMode == TILT_RADIUS? GLSL_TILT_RADIUS:GLSL_TILT_PAR); 
                [_openGL activeRenderTextureStepByStep]; 
                GLint videoFramePos = [entry getUniformPosByKey:@"videoFrame"];
                glUniform1i(videoFramePos, TEXTURE_1);
            };
            //glUseProgram(_fd_Program);
            [tiltEntry renderEntry:prepareBlock backupBufferIndex:0];
            //[_openGL saveFrameToFrameTexture];
            //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        } 
        else
        {
            GLfloat topX = _tiltX;
            GLfloat bottomX = _tiltX;
            GLfloat topY = _tiltY;
            GLfloat bottomY = _tiltY;
            GLfloat tanOfLine = 0;
            GLfloat fd_dy1 = 0.0;
            GLfloat fd_dy2 = 0.0;
            BOOL isHorizon = YES;
            //if((_angle>=135 && _angle<=180) || (_angle>=0&&_angle<=45))
            {
                topY = _tiltY + _distanceOrRadius/cosf(_angle*M_PI/180);
                bottomY = _tiltY - _distanceOrRadius/cosf(_angle*M_PI/180);
                
                tanOfLine =  tanf(_angle*M_PI/180);
                fd_dy1 = topY - tanOfLine * topX;
                fd_dy2 = bottomY - tanOfLine * bottomX;
                //NSLog(@"ddddd %f",1/tanf(2*45*M_PI/180));
            } 
  
            
            OpenGLEntry *tiltEntry = [self getSystemFilterEntryByName:isHorizon?@"titlpar":@"titlparHorizon"];
            [tiltEntry applyProgram];
            [self setDefaultAttribute];
            OpenGLSLEntryPrepare prepareBlock = ^(OpenGLEntry *entry){
                //glEnable(GL_BLEND);
                //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
                //glUniform1f(_fd_radius, _distanceOrRadius);
                //GLint radiusPos = [entry getUniformPosByKey:@"fd_radius"];
                //glUniform1f(radiusPos, _distanceOrRadius);
                
                // GLint centerPos = [entry getUniformPosByKey:@"fd_center"];
                // glUniform2f(centerPos, _tiltX,_tiltY);
                
                GLint fd_tan_pos = [entry getUniformPosByKey:@"fd_tan"];
                glUniform1f(fd_tan_pos, tanOfLine);
                
                GLint fd_dy1_pos = [entry getUniformPosByKey:isHorizon?@"fd_dy1":@"fd_dx1"];
                glUniform1f(fd_dy1_pos, fd_dy1);
                
                GLint fd_dy2_pos = [entry getUniformPosByKey:isHorizon?@"fd_dy2":@"fd_dx2"];
                glUniform1f(fd_dy2_pos, fd_dy2);
                
                
                GLint ratialPos = [entry getUniformPosByKey:@"fd_ratial"];
                glUniform1f(ratialPos, isHorizon?[_openGL imageWidth]/(float)[_openGL imageHeight]:[_openGL imageHeight]/(float)[_openGL imageWidth]);
                //glUniform2f(_fd_center, _tiltX,_tiltY);
                //glUniform1i(_fd_flag, _tiltBlurMode == TILT_RADIUS? GLSL_TILT_RADIUS:GLSL_TILT_PAR); 
                //[_openGL activeFrameTexture]; 
                //GLint videoFramePos = [entry getUniformPosByKey:@"videoFrame"];
                //glUniform1i(videoFramePos, TEXTURE_1);
            };
            [tiltEntry renderEntry:prepareBlock backupBufferIndex:0];
        }
        glDisable(GL_BLEND);
    }
    //[self fetechImage:needRotate];
    //return;
    if(_openGL.eaglLayer) 
    {
        //[_openGL saveFrameToFrameTexture];
        {
            [_openGL switchToMainFrameBuffer];
        }
        glUseProgram(_directShowProgram);
        glVertexAttribPointer(GLSL_ATTRIB_VERTEX_DIRECT, 2, GL_FLOAT, 0, 0, squareVertices);
        glEnableVertexAttribArray(GLSL_ATTRIB_VERTEX_DIRECT);
        glVertexAttribPointer(GLSL_ATTRIB_TEXTUREPOSITION_DIRECT, 2, GL_FLOAT, 0, 0, textureVerticesGLlayer);//textureVerticesImage);
        glEnableVertexAttribArray(GLSL_ATTRIB_TEXTUREPOSITION_DIRECT);
        [_openGL activeRenderTextureStepByStep];
        glUniform1i(_directShowUniformVideo, TEXTURE_1);
        //glClear(GL_COLOR_BUFFER_BIT);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    //return;
    //[self.openGL clearSave];
    // 7. release all the textures
    //glFlush();
    if(_openGL.eaglLayer) //[_openGL glMode]==VIEW_MODE && 
    {
        [_openGL presentFramebuffer];
        //do nothing
    } 
    for (OpenGLEntry *currentEntry in _entries) {
        [currentEntry releaseAttributeMem];
    }
    _isLive = NO;
    //for(int i=0;i<attrIndex;i++)
    //{
    //    free(pointersAttributes[i]);
    //}
    //=============
    /*if(self.globalTextureIndex>TEXTURE_BOUND_START)
     {
     glDeleteTextures(self.globalTextureIndex - TEXTURE_BOUND_START, &_myTextureStorage[TEXTURE_BOUND_START]);
     }*/
    //=============
    //if(!alreadyRemovedMain) 
    {
        //    glDeleteTextures(1, &_videoFrameTexture);
    }
    [_openGL discard];
}


- (void) fetechImage//:(BOOL)needRotate
{
    // CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    if([self needOnlyRawData])
    {
        self.resultData = [_openGL getOnlyImageRawData];
    }
    else 
    {
        self.resultImage = [_openGL getImageFromGL];//:needRotate];
        self.resultData = [_openGL rawdata];
    } 
    //NSLog(@"timewwwwwww:%f", CFAbsoluteTimeGetCurrent() - start);
}
-(void) dealloc 
{
    self.resultImage=nil;
    //self.entry = nil;
    self.entries = nil;
    //    self.systemContent = nil;
    //[_fd_entry release];
    //[_fd_blur_entry release];
    [self deleteRawTexture];
    [_openGL release];
    [_commonSource[CLGLVsh] release];
    [_commonSource[CLGLFsh] release];
    [super dealloc];
}
- (UIImage*) createTextureImageFromName:(NSString*)name
{
    if(resourceProvider)
    {
        return [resourceProvider createTextureImageFromName:name];
    } else {
        return [[UIImage imageNamed:name]retain];
    }
}
- (void)compileFilterAdjustProgram
{
    if(!_systemCompiled)
    {
        for (OpenGLEntry *entry in _systemEntries)
        {
            [entry compile];
        }
        _systemCompiled = YES;
    }
    /*OpenGLSLFunctionPrepare setupAtt = ^(GLuint program){
     glBindAttribLocation(program, GLSL_ATTRIB_VERTEX_FD,"positionThird");
     glBindAttribLocation(program, GLSL_ATTRIB_TEXTUREPOSITION_FD, "inputTextureCoordinateThird");
     
     };
     
     OpenGLSLFunctionPrepare setupUniform = ^(GLuint program)
     {
     // Get uniform locations.
     _fd_UniformVideo = glGetUniformLocation(program,"fd_videoFrame");
     _fd_UniformVideo2 = glGetUniformLocation(program,"fd_videoFrame2");
     _fd_flag =  glGetUniformLocation(program,"fd_flag");
     _fd_degree =  glGetUniformLocation(program,"fd_degree");
     //_fd_orientation =  glGetUniformLocation(program,"fd_orientation");
     //_fd_width =  glGetUniformLocation(program,"fd_width");
     //_fd_height =  glGetUniformLocation(program,"fd_height");
     
     _fd_center =  glGetUniformLocation(program,"fd_center");
     _fd_radius =  glGetUniformLocation(program,"fd_radius"); 
     _fd_ratial =  glGetUniformLocation(program,"fd_ratial"); 
     
     };
     if(![self loadVertexShader:&_fd_Program VetexSource:_fd_entry.vetexSource  FragmentSource:_fd_entry.shadeSource attributeSet:setupAtt uniformSet:setupUniform])
     {
     exit(1);
     }
     if(![self validateProgram:&_fd_Program])
     {
     exit(1);
     }
     
     glUseProgram(_fd_Program);
     glVertexAttribPointer(GLSL_ATTRIB_VERTEX_FD, 2, GL_FLOAT, 0, 0, squareVertices);
     glEnableVertexAttribArray(GLSL_ATTRIB_VERTEX_FD);
     glVertexAttribPointer(GLSL_ATTRIB_TEXTUREPOSITION_FD, 2, GL_FLOAT, 0, 0, textureVerticesImage);
     glEnableVertexAttribArray(GLSL_ATTRIB_TEXTUREPOSITION_FD);
     glUniform1i(_fd_UniformVideo, TEXTURE_1);
     glUniform1i(_fd_UniformVideo2, TEXTURE_0);*/
}
/*- (void)compileBlurAdjustProgram
 {
 
 OpenGLSLFunctionPrepare setupAtt = ^(GLuint program){
 glBindAttribLocation(program, GLSL_ATTRIB_VERTEX_FD,"positionThird");
 glBindAttribLocation(program, GLSL_ATTRIB_TEXTUREPOSITION_FD, "inputTextureCoordinateThird");
 
 };
 
 OpenGLSLFunctionPrepare setupUniform = ^(GLuint program)
 {
 // Get uniform locations.
 _fd_blur_videoFrame  = glGetUniformLocation(program,"fd_blur_videoFrame");
 //_fd_UniformVideo2 = glGetUniformLocation(program,"fd_videoFrame2");
 //_fd_flag =  glGetUniformLocation(program,"fd_flag");
 //_fd_degree =  glGetUniformLocation(program,"fd_degree");
 _fd_blur_orientation =  glGetUniformLocation(program,"fd_blur_orientation");
 _fd_blur_width =  glGetUniformLocation(program,"fd_blur_width");
 _fd_blur_height =  glGetUniformLocation(program,"fd_blur_height");
 
 //_fd_center =  glGetUniformLocation(program,"fd_center1");
 //_fd_radius =  glGetUniformLocation(program,"fd_radius"); 
 //_fd_ratial =  glGetUniformLocation(program,"fd_ratial"); 
 
 };
 if(![self loadVertexShader:&_fd_blur_Program VetexSource:_fd_blur_entry.vetexSource  FragmentSource:_fd_blur_entry.shadeSource attributeSet:setupAtt uniformSet:setupUniform])
 {
 exit(1);
 }
 if(![self validateProgram:&_fd_blur_Program])
 {
 exit(1);
 }
 glUseProgram(_fd_blur_Program);
 glUniform1f(_fd_blur_width, 1.0/[_openGL imageWidth]);
 glUniform1i(_fd_blur_videoFrame, TEXTURE_1);
 glUniform1f(_fd_blur_height, 1.0/[_openGL imageHeight]);
 }*/
- (void)compileDirectShowProgram
{
    if(_systemCompiled)
    {
        return;
    }
    
    OpenGLSLFunctionPrepare setupAtt = ^(GLuint program){
        glBindAttribLocation(program, GLSL_ATTRIB_VERTEX_DIRECT,"positionSecond");
        glBindAttribLocation(program, GLSL_ATTRIB_TEXTUREPOSITION_DIRECT, "inputTextureCoordinateSecond");
        
    };
    
    OpenGLSLFunctionPrepare setupUniform = ^(GLuint program)
    {
        // Get uniform locations.
        _directShowUniformVideo = glGetUniformLocation(program,"videoFrameSecond");
    };
    if(![self loadVertexShader:&_directShowProgram VetexSource:directVetexSource  FragmentSource:directFragmentSource attributeSet:setupAtt uniformSet:setupUniform])
    {
        //exit(1);
    }
    if(![self validateProgram:&_directShowProgram])
    {
     //   exit(1);
    }
    
}
- (BOOL)supportIOS5
{
    return usingIOS5&&[self.openGL supportFastOpenGL];
}
@end
