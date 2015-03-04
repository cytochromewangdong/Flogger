//
//  OpenGLRenderCenter.h
//  ColorTracking
//
//  Created by dong wang on 11-12-28.
//  Copyright (c) 2011年 atoato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLManager.h"
#import "NSObject+SBJson.h"
#import "TBXML.h"
#define GLSL_STRENTH                 0x1
#define GLSL_BRIGHT                  0x2
#define GLSL_CONTRAST                0x4
#define GLSL_SATURATE                0x8

#define GLSL_BLUR                    0x10

#define GLSL_BLUR_RADIUS             0x9
#define GLSL_BLUR_PAR                0xA

#define GLSL_TILT_RADIUS             0x5
#define GLSL_TILT_PAR                0x6
//#define IMPORT_FROM_WITHIOS5 IS_SUPPORT_ADVANCECACHE
//YES
extern NSString *const GL_DATA_KEY_COMMON_VSH;
extern NSString *const GL_DATA_KEY_COMMON_FSH;
extern NSString *const GL_DATA_KEY_EXTRA_VSH;
extern NSString *const GL_DATA_KEY_EXTRA_FSH;
extern NSString *const GL_DATA_KEY_VSH;
extern NSString *const GL_DATA_KEY_FSH;
extern NSString *const GL_DATA_KEY_ATTRIBUTE_KEY;
extern NSString *const GL_DATA_KEY_UNIFORM_KEY;

// Attribute index.
enum {
    GLSL_0 = 0,
    GLSL_1,
    GLSL_2,
    GLSL_3,
    GLSL_4,
    GLSL_5,
    GLSL_6,
    GLSL_7,
    /*GLSL_8,
     GLSL_9,*/
    GLSL_ATTRIB_BOUND,
    GLSL_ATTRIB_VERTEX,
    GLSL_ATTRIB_TEXTUREPOSITION,
    GLSL_NUM_ATTRIBUTES,
    GLSL_ATTRIB_VERTEX_DIRECT,
    GLSL_ATTRIB_TEXTUREPOSITION_DIRECT,
    GLSL_ATTRIB_VERTEX_FD,
    GLSL_ATTRIB_TEXTUREPOSITION_FD,
};

enum {
    GLSL_UNIFORM_0 = 0,
    GLSL_UNIFORM_1,
    GLSL_UNIFORM_2,
    GLSL_UNIFORM_3,
    GLSL_UNIFORM_4,
    GLSL_UNIFORM_5,
    GLSL_UNIFORM_6,
    GLSL_UNIFORM_7,
    GLSL_UNIFORM_8,
    GLSL_UNIFORM_9,
    GLSL_UNIFORM_BOUND,
    GLSL_UNIFORM_VIDEOFRAME,
    GLSL_UNIFORM_KERNEL,
    GLSL_UNIFORM_OFFSET,
    GLSL_UNIFORM_WIDTH,
    GLSL_UNIFORM_HEIGHT,
    GLSL_UNIFORM_VERTICAL,
    GLSL_NUM_UNIFORMS
};
typedef enum 
{
    CLGLVsh,
    CLGLFsh
} CLGLSourceType;
typedef enum 
{
    CLGL_ATTRIBUTE,
    CLGL_UNIFORM
} CLGLBeanType;
typedef struct{
    int length;
    int type;
    void* data;
}CLGL_PARAM_DATA;

typedef enum {
    JSON,
    XML
}CLGLFilterSourceType;
typedef enum
{
    TEXTURE_HANDLE_TARGET=0,
    TEXTURE_HANDLE_CONVERTED,
    TEXTURE_HANDLE_BUFFER,
    TEXTURE_BOUND_START
}CLGL_TEXTURE_HANDLE_INDEX;
typedef enum {
    TILT_NONE,
    TILT_RADIUS,
    TILT_PAR,
} CLGL_TILT_MODE;
/*@interface OpenGLAttributeUniform : NSObject {
 @private
 
 }
 @property (retain) NSString *variableName;
 @property (assign) CLGLBeanType type;
 - (void) dealloc;
 @end*/
/*@interface OpenGLStep : NSObject {
 @private
 
 }
 @property (retain)NSArray *textures;
 -(id) init;
 - (void) dealloc;
 @end*/
@protocol ResourceProvider <NSObject>

- (UIImage*) createTextureImageFromName:(NSString*)name;

@end
@class OpenGLEntry;

typedef void (^OpenGLSLFunctionPrepare)(GLuint program);
typedef void (^OpenGLSLEntryPrepare)(OpenGLEntry *entry);
@interface OpenGLRenderCenter : NSObject
{
    //GLint _glslUniforms[GLSL_NUM_UNIFORMS];
    NSMutableString *_commonSource[2];
    //GLuint _program;
    GLuint _directShowProgram;
    
    OpenGLManager *_openGL;
	GLuint _videoFrameTexture;
	GLuint _borderTexture;
    GLint _directShowUniformVideo;
    //GLuint _myTextureStorage[TEXTURE_MAX];
    
    //RENDER_MODE _oldmod;
    
    //int _oldWidth;
    //int _oldHeight;
    //UIImageOrientation _imageOrientation;
    /*GLuint _fd_Program;
     //OpenGLEntry *_fd_entry;
     GLint _fd_UniformVideo;
     GLint _fd_UniformVideo2;
     GLint _fd_flag;
     GLint _fd_degree;
     GLint _fd_center;
     GLint _fd_radius;
     GLint _fd_ratial;*/
    //BOOL _staticMode;
    //GLfloat _filterStrenth;
    //BOOL _isStrenthMode;
    CLGL_TILT_MODE _tiltBlurMode;
    GLfloat _distanceOrRadius;
    GLfloat _tiltX;
    GLfloat _tiltY;
    GLfloat _angle;
    /*GLuint _fd_blur_Program;
     GLint  _fd_blur_videoFrame;
     GLint  _fd_blur_orientation;
     GLint  _fd_blur_width;
     GLint  _fd_blur_height;*/
    //OpenGLEntry *_fd_blur_entry;
    
    //GLint _glslUniforms[99];  
    
    
    //===========
    //GLint  _test1;
    //GLint  _test2;
    //===========
    NSMutableArray *_entries;
    NSMutableArray *_systemEntries;
    
    int _degreeStrenthStandard;
    int _degreeSaturationStandard;
    int _degreeBrightnessStandard;
    int _degreeContrastStandard;
    
    BOOL _systemCompiled;
 
    CVOpenGLESTextureRef _IOS5texture;
    
    float _textureWidthStep;
    float _textureHeightStep;
    BOOL _isLive;
    BOOL _staticPreviewMode;
    float _quality;
}
//@property (retain) OpenGLEntry *entry;
@property (assign) BOOL staticPreviewMode;
@property (assign) float quality;
@property (assign, readonly) uint postFilterMode;
@property (retain,readonly) NSArray* entries;
@property (retain,readonly) NSArray* systemEntries;
@property (retain) OpenGLManager *openGL;
@property (retain,readonly) UIImage *resultImage;
@property (assign,readonly) void *resultData; 
@property (assign) BOOL needOnlyRawData;
@property (assign) id<ResourceProvider> resourceProvider;
//@property (assign) uint globalTextureIndex;
//@property (retain) NSMutableArray
//@property (assign) BOOL staticMode;
@property (assign) BOOL tiltShowMode;
@property (assign) BOOL usingIOS5;
@property (assign) int degreeStrenthStandard;
@property (assign) int degreeSaturationStandard;
@property (assign) int degreeBrightnessStandard;
@property (assign) int degreeContrastStandard;

//@property (assign) GLfloat filterStrenth;
- (BOOL)loadVertexShader:(GLuint *) programPointer VetexSource:(const NSString*)vetexSource FragmentSource:(const NSString*) fragSource attributeSet:(OpenGLSLFunctionPrepare) attributeSet uniformSet:(OpenGLSLFunctionPrepare) uniformSet;
- (NSString *)getCommonGLSL:(CLGLSourceType) type;
-(id) init;

- (void) internInitialize;
- (BOOL) validateProgram:(GLuint *) programPointer;
- (void) setGLLayer:(CAEAGLLayer *) layer;
- (void) setGlMode:(RENDER_MODE) mode;
- (void) setupProgram:(int) width Height:(int) height Data:(NSString*)data StringType:(CLGLFilterSourceType) type preview:(BOOL) preview;
- (void) setupProgram:(int) width Height:(int) height Data:(NSString*)data StringType:(CLGLFilterSourceType) type;
- (void) installProgram:(NSString *)data;// StringType:(CLGLFilterSourceType) type;
- (void) setNewDimention:(int) width Height:(int) height preview:(BOOL) preview;
- (void) processCameraFrame:(CVImageBufferRef)cameraFrame;
//- (void) processRawBytes:(UInt8*)rawData bufferWidth:(int) bufferWidth bufferHeight:(int) bufferHeight;
- (void) processCameraFrame:(CVImageBufferRef)cameraFrame orientation:(UIImageOrientation)orientation;
//- (void) processCameraFrameWithRealSize:(CVImageBufferRef)cameraFrame willKeepTexture:(BOOL)willKeepTexture;
//- (void) processCameraFrameWithRealSize:(CVImageBufferRef)cameraFrame;
//- (void) Restore;
- (void) processImage;
- (void) processImage:(UIImageOrientation)orientation;//:(UIImage *)image;
- (void) registerImage:(UIImage *)image forPreview:(BOOL) forPreview;
//==================
- (CGSize) getImagePreviewSize:(UIImage *)image;
- (UIImage *) prepareImageForRegister:(UIImage *)image forPreview:(BOOL) forPreview;
- (void) registerImageAfterPrepare:(UIImage *)image forPreview:(BOOL) forPreview;
//==================
- (void) registerBorderImage:(UIImage *)image;
- (void) clearBorderImage;
- (void) dealloc;
- (UIImage*) createTextureImageFromName:(NSString*)name;
- (void)setupTextureWithCameraFrame:(CVImageBufferRef)cameraFrame;
- (void)render:(UIImageOrientation) orientation willKeepTexture:(BOOL) willKeepTexture;
- (void)compileTargetProgram;
- (void)compileAllProgram;
- (void)compileDirectShowProgram;
- (void)compileFilterAdjustProgram;
//- (void)compileBlurAdjustProgram;
//- (void)setFilterStrenth:(GLfloat) filterStrenth;
//- (void)clearFilterStrenth;
- (void)setRadiusTiltBlur:(GLfloat) distanceOrRadius X:(GLfloat)x Y:(GLfloat) y;
- (void)setParTiltBlur:(GLfloat) distanceOrRadius X:(GLfloat)x Y:(GLfloat) y angle:(GLfloat) angle;
- (void)clearTiltBlur;
- (void)clearPostFilter;
- (BOOL)supportIOS5;
@end
