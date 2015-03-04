//
//  OpenGLManager.h
//  ColorTracking
//
//  Created by dong wang on 11-12-28.
//  Copyright (c) 2011年 atoato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
//#define IS_SUPPORT_ADVANCECACHE 
//CVOpenGLESTextureCacheCreate
typedef enum 
{
    TEXTURE_0 = 0,
    TEXTURE_1,
    TEXTURE_2,
    TEXTURE_3,
    TEXTURE_4,
    TEXTURE_5,
    TEXTURE_6,
    TEXTURE_7,
    TEXTURE_8,
    TEXTURE_9,
    TEXTURE_10,
    TEXTURE_11,
    TEXTURE_12,
    TEXTURE_13,
    TEXTURE_14,
    TEXTURE_15,
    TEXTURE_16,
    TEXTURE_17,
    TEXTURE_18,
    TEXTURE_19,
    TEXTURE_20,
    TEXTURE_21,
    TEXTURE_22,
    TEXTURE_23,
    TEXTURE_24,
    TEXTURE_25,
    TEXTURE_26,
    TEXTURE_27,
    TEXTURE_28,
    TEXTURE_29,
    TEXTURE_30,
    TEXTURE_31,
    TEXTURE_MAX,
} TEXTURE_POSITION_TYPE;
typedef enum {
    OFFSCREEN_MODE,
    VIEW_MODE,
} RENDER_MODE;
typedef enum
{
    BUFFER_FIRST,
    BUFFER_SECOND
}BUFFER_INDEX;
@interface OpenGLManager : NSObject
{
    // The buffer for the bitmap;
    void *_rawBitmapPixels;
    int _height,_width;
    NSDictionary *_glConfig;
    EAGLContext* _context;
    
    /* The pixel dimensions of the backbuffer */
	GLint _backingWidth, _backingHeight;
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
    GLuint _framebuffer;
    
    GLuint _secondColorRenderBuffer;
    GLuint _secondFramebuffer;
    
    GLuint _msaaFrameBuffer;
    GLuint _msaaColorBuffer;
	GLuint _viewRenderbuffer, _viewFramebuffer;
    
	GLuint _sampleFramebuffer, _sampleColorRenderbuffer;
    BOOL _enableDepth,_enableDecoration;
    uint _buffersize;
    CAEAGLLayer *_eaglLayer;
    CGRect _origionlFrame;
    RENDER_MODE _glMode;
    GLuint _frameRenderTextureStepByStep;
    
    GLuint _bufferTextureSaveRawPicture;
    GLuint _bufferRenderTextureForBlur;
    //GLuint _frameBackupTexture;
    //CVOpenGLESTextureCacheRef _videoInputTextureCache;
    GLuint _samples;
    
    
    CFMutableDictionaryRef _attrsIOS5;
    CVPixelBufferRef _renderTargetBufferIOS5;
    CVOpenGLESTextureCacheRef _videoTextureCacheIOS5;
    CVOpenGLESTextureRef _renderTextureIOS5;
    BOOL _isGreatThanOrEqualIOS5;
}
@property int height,width;
@property GLuint samples;
@property BOOL enableDepth,enableDecoration;
@property (retain) NSDictionary *glConfig;
@property (readonly) GLuint secondFramebuffer;
@property (readonly) GLuint viewFramebuffer;
@property (readonly) GLuint msaaFrameBuffer;
@property (readonly) void *rawdata;
@property (retain) CAEAGLLayer *eaglLayer;
@property (readonly) EAGLContext *context;
@property (readonly) CVOpenGLESTextureCacheRef videoTextureCacheIOS5;
//@property (readonly) CVOpenGLESTextureCacheRef videoInputTextureCache;
@property (assign,readonly) CGRect origionlFrame; 
@property (assign) BUFFER_INDEX currentBuffer;
@property RENDER_MODE glMode;
-(id) init;
-(id) initWithSize:(int) width Height:(int) height;
-(void) dealloc;
-(void) setSize:(int) width Height:(int) height  preview:(BOOL) preview;;
//-(void) setSizeReenter:(int) width Height:(int) height;
-(void) setupRenderBuffer;
-(void) setupDepthBuffer;
-(int) imageHeight;
-(int) imageWidth;
-(void) clearOpenGL1;
-(void) clearOpenGL2;
-(void) clearViewFrameBuffer;
-(void) preRender;
-(void) setupFrameBuffer;
-(void) setTextureDefault;
-(void) setTextureStandard;
-(void) selectTextureUnit:(TEXTURE_POSITION_TYPE) textureUnit;
- (BOOL)presentFramebuffer;
-(UIImage *) getImageFromGL;//:(BOOL)needRotate;
-(void *) getOnlyImageRawData; 
-(void) startUp;
//-(void) startUp:(BOOL) recreateGlBuffer;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(const NSString *) source;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
- (void)discard;
- (void)setupFrameTexture;
- (void)setupBufferTexture;
- (void)activeRenderTextureStepByStep;
- (void)setupSecondFrameBuffer:(int) width height:(int)height;
- (void)switchToMainFrameBuffer;
- (void)switchToSecondFrameBuffer;
- (void)switchFrameBuffer;
- (void)saveFrameToFrameTextureStepByStep;
- (void)setupBlurBufferTexture;
//===
- (void)saveRawTextureToBuffer;
- (void)saveBlurMiddleProductToBuffer;
- (void)saveToOutputBufferTexture;
- (void)clearSave;
//====
-(void)setTextureForParameters;
- (void)activeTextureSaveRawPictureAsMainTexture;
- (void)activeBufferTextureForBlur:(TEXTURE_POSITION_TYPE)texturePos;
- (BOOL) supportFastOpenGL;
- (void) prepareContent;
- (void) flushContent;
- (void) setAllTexture;
- (void) removeAllTexture;
- (void) createSaveTexture;
- (void) deleteSaveTexture;
- (void) switchContext;
- (void) clearContext;
@end

