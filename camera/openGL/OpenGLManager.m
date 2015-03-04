//
//  OpenGLManager.m
//  ColorTracking
//
//  Created by dong wang on 11-12-28.
//  Copyright (c) 2011年 atoato. All rights reserved.
//
//#define DEBUG
#import "OpenGLManager.h"
#define COMPONENT_COUNT_OF_PIXEL 4
GLenum TEXTURE_POSITIONS[] = {
    GL_TEXTURE0,
    GL_TEXTURE1,
    GL_TEXTURE2,
    GL_TEXTURE3,
    GL_TEXTURE4,
    GL_TEXTURE5,
    GL_TEXTURE6,
    GL_TEXTURE7,
    GL_TEXTURE8,
    GL_TEXTURE9,
    GL_TEXTURE10,
    GL_TEXTURE11,
    GL_TEXTURE12,
    GL_TEXTURE13,
    GL_TEXTURE14,
    GL_TEXTURE15,
    GL_TEXTURE16,
    GL_TEXTURE17,
    GL_TEXTURE18,
    GL_TEXTURE19,
    GL_TEXTURE20,
    GL_TEXTURE21,
    GL_TEXTURE22,
    GL_TEXTURE23,
    GL_TEXTURE24,
    GL_TEXTURE25,
    GL_TEXTURE26,
    GL_TEXTURE27,
    GL_TEXTURE28,
    GL_TEXTURE29,
    GL_TEXTURE30,
    GL_TEXTURE31
};

// placeholder

@interface OpenGLManager(internal)

- (void) internInitialize;

-(void) setupContext;

-(void) allocBuffer;

-(void) repositionGLView;
-(void) createAttributeIOS5;

-(void) destroyIOS5;
-(void) destroyTextureIOS5;
-(void) createTextureIOS5;
@end
@implementation OpenGLManager(internal)

-(void) createAttributeIOS5 
{
    CFDictionaryRef empty;
    empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL,0, & kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    _attrsIOS5 = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(_attrsIOS5, kCVPixelBufferIOSurfacePropertiesKey, empty);
    CFRelease(empty);
}
-(void) createTextureIOS5
{
    [self destroyTextureIOS5];
    //_renderTargetBuffer
    CVPixelBufferCreate(kCFAllocatorDefault, [self imageWidth], [self imageHeight], kCVPixelFormatType_32BGRA, _attrsIOS5, &_renderTargetBufferIOS5);
    //[self createSaveTexture];

}
- (void) createSaveTexture
{
    [self deleteSaveTexture];
    CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, _videoTextureCacheIOS5, _renderTargetBufferIOS5, NULL, GL_TEXTURE_2D, GL_RGBA, [self imageWidth], [self imageHeight], GL_RGBA, GL_UNSIGNED_BYTE, 0, &_renderTextureIOS5);
    
    glBindTexture(CVOpenGLESTextureGetTarget(_renderTextureIOS5), CVOpenGLESTextureGetName(_renderTextureIOS5));
    [self setTextureDefault];
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(_renderTextureIOS5), 0);
    CVOpenGLESTextureCacheFlush(_videoTextureCacheIOS5, 0);
}
-(void) destroyTextureIOS5
{
    if(_renderTargetBufferIOS5) 
    {
        CVPixelBufferRelease(_renderTargetBufferIOS5);
        _renderTargetBufferIOS5 = NULL;
    }
    [self deleteSaveTexture];
}
- (void) deleteSaveTexture
{
    if(_renderTextureIOS5)
    {
        glBindTexture(CVOpenGLESTextureGetTarget(_renderTextureIOS5), 0);
        CVOpenGLESTextureCacheFlush(_videoTextureCacheIOS5, 0);
        CFRelease(_renderTextureIOS5);
        _renderTextureIOS5= NULL;
    }  
}
-(void) destroyIOS5
{
    if(_attrsIOS5) 
    {
        CFRelease(_attrsIOS5);
        _attrsIOS5 = NULL;
    }
    [self destroyTextureIOS5];
}
-(void) internInitialize 
{
    _rawBitmapPixels = NULL;
    _glConfig = nil;
    _enableDecoration = YES;
    _enableDepth = NO;
    //
    _origionlFrame = CGRectMake(0, 0, 320, 428);
    
    _samples = 2;
    
    _isGreatThanOrEqualIOS5 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0); 
    [self setupContext];
}
- (void)setupContext {   
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
//        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        //exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
//        NSLog(@"Failed to set current OpenGL context");
        //exit(1);
    }
    //  Create a new CVOpenGLESTexture cache
    if([self supportFastOpenGL]) {
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _context, NULL, &_videoTextureCacheIOS5);
        if (err) {
//            NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
        }
        //err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _context, NULL, &_videoInputTextureCache);
        //if (err) {
        //    NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
        //}
        [self createAttributeIOS5];
    }
}
-(void) allocBuffer
{
    // if ios5 we are using the cvpixelbuffer
    if([self supportFastOpenGL]) 
    {
        return;
    }
    uint buffersize = 0;
    buffersize = [self imageWidth] * [self imageHeight];
    if(buffersize>_buffersize || _buffersize/buffersize > 2)
    {
        if(_rawBitmapPixels) 
        {
            free(_rawBitmapPixels);
        }
        // buffer used to save the bitmap from the openGL.
        _rawBitmapPixels = (GLubyte *) calloc(buffersize* COMPONENT_COUNT_OF_PIXEL, sizeof(GLubyte));
        _buffersize = buffersize;
    }
    
}
#define RESIZE_THRESHHOLDE 5
-(void) repositionGLView
{
    if(!_eaglLayer)
    {
        return;
    }
    if(!self.width||!self.height)
    {
        return;
    }
    int width = self.width;
    int height = self.height;
    if(self.width>_origionlFrame.size.width || self.height>_origionlFrame.size.height)
    {
        float rate = MAX(self.width/_origionlFrame.size.width, self.height/_origionlFrame.size.height);
        width = self.width /rate;
        height = self.height/rate;
    }
    int differenceW = _origionlFrame.size.width - width;
    int differenceH = _origionlFrame.size.height - height;
    
    CGRect newFrame;// = _origionlFrame;
    //if(differenceW>RESIZE_THRESHHOLDE || differenceH>RESIZE_THRESHHOLDE)
    {
        int left = differenceW/2 + _origionlFrame.origin.x;
        int top = differenceH/2+_origionlFrame.origin.y;
        newFrame = CGRectMake(left, top, width, height);
    }
    if([[NSThread currentThread]isMainThread])
    {
        //[UIView beginAnimations:nil context:nil];
        //[UIView setAnimationCurve:UIViewAnimationCurveLinear];
        //[UIView setAnimationDuration:0.2];
        _eaglLayer.frame = newFrame;
        //[UIView commitAnimations];
    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
        //    [UIView beginAnimations:nil context:nil];
        //    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        //    [UIView setAnimationDuration:0.2];
            _eaglLayer.frame = newFrame;
        //    [UIView commitAnimations];
        });
    }
}

@end
@implementation OpenGLManager
@synthesize height =_height,width=_width;
@synthesize glConfig=_glConfig;
//@dynamic eaglLayer;
@dynamic rawdata;
@synthesize enableDepth = _enableDepth, enableDecoration = _enableDecoration;
@synthesize glMode=_glMode;
@synthesize context=_context;
@synthesize currentBuffer;
@synthesize origionlFrame=_origionlFrame;
@synthesize samples = _samples;
@synthesize secondFramebuffer =_secondFramebuffer;
@synthesize viewFramebuffer = _viewFramebuffer;
@synthesize msaaFrameBuffer = _msaaFrameBuffer;
@synthesize videoTextureCacheIOS5 = _videoTextureCacheIOS5;
//@synthesize videoInputTextureCache = _videoInputTextureCache;
/*-(RENDER_MODE) glMode
 {
 return _glMode;
 }*/
-(void *) rawdata
{
    if([self supportFastOpenGL])
    {
        return _renderTargetBufferIOS5;
    } 
    else
    {
        return _rawBitmapPixels;
    }
}
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(const NSString *) source
{
    GLint status;
    const GLchar *charSource;
    charSource = (GLchar *)[source UTF8String];
    if (!charSource)
    {
//        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &charSource, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
//        NSLog(@"Shader compile log:\n%s", log);
//        NSLog(@"%@", source);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}
- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
//        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}
- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
//        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}
-(void) selectTextureUnit:(TEXTURE_POSITION_TYPE) textureUnit
{
    glActiveTexture(TEXTURE_POSITIONS[textureUnit]);
}

-(id) init{
    if(!(self=[super init]))
    {
        return nil;
    }
    [self internInitialize];
    return self;
}
-(id) initWithSize:(int) width Height:(int) height
{
    if(!(self=[super init]))
    {
        return nil;
    }
    
    [self internInitialize];
    
    [self setSize:width Height:height preview:NO];
    return self;
}
-(void)deleteFrameTexture
{
    if(_frameRenderTextureStepByStep)
    {
        glDeleteTextures(1, &_frameRenderTextureStepByStep);
        _frameRenderTextureStepByStep = 0;
    }
}
-(void)setTextureDefault
{
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,  GL_LINEAR);//GL_LINEAR);GL_LINEAR_MIPMAP_LINEAR
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,  GL_LINEAR);//GL_LINEAR);
	// This is necessary for non-power-of-two textures
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glHint(GL_GENERATE_MIPMAP_HINT, GL_NICEST);
}
-(void) setTextureStandard
{
   	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,  GL_NEAREST);//GL_LINEAR);GL_LINEAR_MIPMAP_LINEAR
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,  GL_NEAREST);//GL_LINEAR);
	// This is necessary for non-power-of-two textures
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glHint(GL_GENERATE_MIPMAP_HINT, GL_NICEST); 
}
-(void)setTextureForParameters
{
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
}
-(void)setSize:(int)width Height:(int)height  preview:(BOOL) preview
{
    /*if(self.height == height && self.width == width)
    {
        return;
    }*/
    self.height = height;
    self.width = width;
    [self allocBuffer];
    [self clearOpenGL2];
    if(preview) 
    {
        [self repositionGLView];
    }
    [self startUp];

}
/*-(void) setSizeReenter:(int) width Height:(int) height
 {
 if(self.height == height && self.width == width)
 {
 return;
 }
 self.height = height;
 self.width = width;
 [self allocBuffer];
 //[self clearOpenGL2];
 glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);        
 glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, [self width], [self height]);
 //glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);   
 ///glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _framebuffer);
 
 glBindRenderbuffer(GL_RENDERBUFFER, _secondColorRenderBuffer);        
 glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, [self width], [self height]);
 glBindFramebuffer(GL_FRAMEBUFFER, _secondFramebuffer);   
 //glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _secondFramebuffer);
 glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [self imageWidth], [self imageHeight], 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
 
 //[self setupFrameTexture];
 //[self startUp];
 }*/
- (void)setupRenderBuffer {
    /*glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);        
    //[_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];  
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, [self width], [self height]); */ //GL_RGBA8_OES TODO
}
- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, [self width], [self height]);    
}
- (void)setupFrameBuffer {    
    /*glGenFramebuffers(1, &_framebuffer );
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);   
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    if(_enableDepth)
    {
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
    }*/
}
-(void) setupSecondFrameBuffer:(int) width height:(int)height;
{
    /*glGenFramebuffers(1, &_msaaFrameBuffer);
     glBindFramebuffer(GL_FRAMEBUFFER, _msaaFrameBuffer);
     
     // Multisample  Color Render Buffer
     glGenRenderbuffers(1, &_msaaColorBuffer);
     glBindRenderbuffer(GL_RENDERBUFFER, _msaaColorBuffer);
     glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, _samples, GL_RGBA8_OES, width, height);
     glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _msaaColorBuffer);*/
    
    //glGenRenderbuffers(1, &_secondColorRenderBuffer);
    //glBindRenderbuffer(GL_RENDERBUFFER, _secondColorRenderBuffer);         
    //glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, width, height);
    glGenFramebuffers(1, &_secondFramebuffer );
    glBindFramebuffer(GL_FRAMEBUFFER, _secondFramebuffer);   
    //NSLog(@"_secondFramebuffer,%d",_secondFramebuffer);
    //glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _secondFramebuffer);
    
    // Multisample Depth Render Buffer
    /*glGenRenderbuffers(1, &_msaaDepthBuffer);
     glBindRenderbuffer(GL_RENDERBUFFER, _msaaDepthBuffer);
     glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, _samples, GL_DEPTH_COMPONENT16, _width, _height);
     glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _msaaDepthBuffer);*/
    // Multisample Frame Buffer
    //[self setupFrameTexture];
    
    if([self supportFastOpenGL]) 
    {
        [self createTextureIOS5];
    } 
    [self setupFrameTexture];
    [self setupBufferTexture];
    [self setupBlurBufferTexture];
    
    // prepare texture for _secondFrameBuffer;
    [self saveFrameToFrameTextureStepByStep];
}
- (void) setAllTexture
{
    [self setupFrameTexture];
    [self setupBufferTexture];
    [self setupBlurBufferTexture];
}
- (void) removeAllTexture
{
    if(_frameRenderTextureStepByStep)
    {
        glDeleteTextures(1, &_frameRenderTextureStepByStep);
        _frameRenderTextureStepByStep = 0;
    }
    if(_bufferTextureSaveRawPicture)
    {
        glDeleteTextures(1, &_bufferTextureSaveRawPicture);
        _bufferTextureSaveRawPicture = 0;
    }
    if(_bufferRenderTextureForBlur)
    {
        glDeleteTextures(1, &_bufferRenderTextureForBlur);
        _bufferRenderTextureForBlur = 0;
    }
}
- (void) setupViewBuffer
{
    glGenFramebuffers(1, &_viewFramebuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, _viewFramebuffer);
	
	glGenRenderbuffers(1, &_viewRenderbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _viewRenderbuffer);
	
    //glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, FBO_WIDTH, FBO_HEIGHT);
    if([NSThread currentThread].isMainThread) 
    {
        [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable: _eaglLayer];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable: _eaglLayer];
        });
    }

    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
//    NSLog(@"Backing width: %d, height: %d", _backingWidth, _backingHeight);
	

	
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _viewRenderbuffer);
    
    //===========================================
     glGenFramebuffers(1, &_sampleFramebuffer);
     glBindFramebuffer(GL_FRAMEBUFFER, _sampleFramebuffer);
     
     glGenRenderbuffers(1, &_sampleColorRenderbuffer);
     glBindRenderbuffer(GL_RENDERBUFFER, _sampleColorRenderbuffer);
     glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGBA8_OES, _backingWidth, _backingHeight);
     glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _sampleColorRenderbuffer);
    //============================================
    
}

-(void) startUp
{
    glEnable(GL_TEXTURE_2D);
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    //if(recreateGlBuffer) {
    
    //}
    [self setupSecondFrameBuffer:[self imageWidth] height:[self imageHeight]];
    if(_eaglLayer)
    {
        [self setupViewBuffer];
    }
    //[self setTextureDefault];
}
-(void)setEaglLayer:(CAEAGLLayer *)eaglLayer
{
    if(_eaglLayer)
    {
        [self clearViewFrameBuffer];
        [_eaglLayer release];
    }
    _eaglLayer = eaglLayer;	
    [_eaglLayer retain];
    if(_eaglLayer)
    {
        _eaglLayer.opaque = YES;
        _origionlFrame = _eaglLayer.frame;
        _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        [self setupViewBuffer];
        [self allocBuffer];
        
        [self repositionGLView];
    }
}

-(CAEAGLLayer*) eaglLayer
{
    return _eaglLayer;  
}
- (BOOL)presentFramebuffer
{
    
    
    //-------------------------
    //  Render
    //-------------------------
    // Resolving Multisample Frame Buffer.
    //glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, _viewFramebuffer);
    //glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, _msaaFrameBuffer);
    //glResolveMultisampleFramebufferAPPLE();
    
    // Apple (and the khronos group) encourages you to discard
    // render buffer contents whenever is possible.
    //GLenum attachments[] = {GL_COLOR_ATTACHMENT0};
    //glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 1, attachments);
    //==============================================================
    // =========================================
    if([self width]>_backingWidth*0.6)
    {
        
        glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, _viewFramebuffer);
        glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, _sampleFramebuffer);
        glResolveMultisampleFramebufferAPPLE();
        const GLenum discards[]  = {GL_COLOR_ATTACHMENT0};
        glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE,1,discards);
    }
    // ======================================
    glBindRenderbuffer(GL_RENDERBUFFER, _viewRenderbuffer);
    
    return [_context presentRenderbuffer:GL_RENDERBUFFER]; 
}
-(void) preRender
{
    //CVOpenGLESTextureCacheFlush(_videoTextureCacheIOS5, 0);
    if(_enableDecoration)
    {
        //glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        //glEnable(GL_BLEND);
    }
    //glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    //glEnable(GL_BLEND);
    //glEnable(GL_BLEND);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    //glEnable(GL_BLEND);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(0, 0, 0, 1.0);
    //[self switchToMainFrameBuffer];//TODOsdfsfsdf
    //if(_glMode == VIEW_MODE && _eaglLayer) 
    //{
    [self switchToSecondFrameBuffer];
    //[self setAllTexture];
    /*[self setupFrameTexture];
    [self setupBufferTexture];
    [self setupBlurBufferTexture];*/
    
    // prepare texture for _secondFrameBuffer;
    //[self saveFrameToFrameTextureStepByStep];
    if([self supportFastOpenGL]) 
    {
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(_renderTextureIOS5), 0);
    }
    //} else {
    //    [self switchToMainFrameBuffer];
    //}
    glClear(GL_COLOR_BUFFER_BIT);
    //[self setupFrameTexture];
}
-(int) imageHeight
{
    /*if(_glMode == VIEW_MODE && _eaglLayer) 
     {
     return _backingHeight;
     }
     else */
    {
        return _height;
    }
}
-(int) imageWidth
{
    /*if(_glMode == VIEW_MODE && _eaglLayer) 
     {
     return _backingWidth;
     }
     else */
    {
        return _width;
    }
}
-(void)clearOpenGL1
{
    // Delete Buffer Objects.
	//glDeleteBuffers(1, &_boStructure);
	//glDeleteBuffers(1, &_boIndices);
	
	// Delete Programs, remember which the shaders was already deleted before.
	//glDeleteProgram(_program);
	
	// Disable the previously enabled attributes to work with dynamic values.
	//glDisableVertexAttribArray(_attributes[0]);
	//glDisableVertexAttribArray(_attributes[1]);
    
    glActiveTexture(GL_TEXTURE0);
}

-(void)clearOpenGL2
{
    // Delete the Frame and Render buffers
    [self removeAllTexture];
    [self destroyTextureIOS5];
    if(_sampleFramebuffer)
    {
        glDeleteFramebuffers(1, &_sampleFramebuffer);
        _sampleFramebuffer=0;    
    }
    if(_sampleColorRenderbuffer)
    {
        glDeleteRenderbuffers(1, &_sampleColorRenderbuffer);
        _sampleColorRenderbuffer=0;    
    }
    if(_depthRenderBuffer)
    {
        glDeleteRenderbuffers(1, &_depthRenderBuffer);
        _depthRenderBuffer=0;
    }
    if(_colorRenderBuffer)
    {
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer=0;
    }
    if(_framebuffer)
    {
        glDeleteFramebuffers(1, &_framebuffer);
        _framebuffer=0;
    }
    if(_secondColorRenderBuffer)
    {
        glDeleteRenderbuffers(1, &_secondColorRenderBuffer);
        _secondColorRenderBuffer=0;
    }
    if(_secondFramebuffer)
    {
        glDeleteFramebuffers(1, &_secondFramebuffer);
        _secondFramebuffer=0;
    }
    [self clearViewFrameBuffer];
    
}
-(void) clearViewFrameBuffer
{
    if (_viewFramebuffer)
	{
		glDeleteFramebuffers(1, &_viewFramebuffer);
		_viewFramebuffer = 0;
	}
	
	if (_viewRenderbuffer)
	{
		glDeleteRenderbuffers(1, &_viewRenderbuffer);
		_viewRenderbuffer = 0;
	}
}


-(void) dealloc 
{
    [self clearOpenGL2];
    //[self clearViewFrameBuffer];
    self.glConfig=nil;
    if(_rawBitmapPixels)
    {
        free(_rawBitmapPixels);
    }
    [self destroyIOS5];
    if (_videoTextureCacheIOS5) {
        CFRelease(_videoTextureCacheIOS5);
        _videoTextureCacheIOS5 = NULL;
    }
    //if(_videoInputTextureCache)
    //{
     //   CFRelease(_videoInputTextureCache);
     //   _videoInputTextureCache = NULL;
    //}
    self.eaglLayer=nil;
    [_context release];
    _context = nil;
    [super dealloc];
}
-(void *) getOnlyImageRawData
{
    if([self supportFastOpenGL]){
        return _renderTargetBufferIOS5;
    } 
    else
    {
        glReadPixels(0, 0, [self imageWidth], [self imageHeight], GL_RGBA, GL_UNSIGNED_BYTE, _rawBitmapPixels);
        return _rawBitmapPixels;
    }
}
// This assumes color matching is disabled on the iPhone OS
- (UIImage *)getImageFromGLOlderVersion
{
    // allocate array and read pixels into it.
    // gl renders "upside down" so swap top to bottom into new array.
    
    int height = [self imageHeight];
    int width = [self imageWidth];
    // transfer image from frame buffer
    //glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, _rawBitmapPixels);
    // there's gotta be a better way, but this works.
    //GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    /*for(int y = 0; y <height; y++)
     {
     for(int x = 0; x <width * 4; x++)
     {s
     buffer2[(height -1 - y) * width * 4 + x] = buffer[y * 4 * width + x];
     }
     }*/
    // make data provider with data.
    NSInteger myDataLength = width *  height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, _rawBitmapPixels, myDataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedFirst;//kCGImageAlphaPremultipliedFirst;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width , height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    UIImage *glImage = nil;
    /*if(needRotate) {
     CGImageRef newImageRef = CreateRotatedImage(imageRef,-90,nil);
     // then make the uiimage from that
     glImage = [UIImage imageWithCGImage:newImageRef];
     CGImageRelease(newImageRef);
     } else {*/
    glImage = [UIImage imageWithCGImage:imageRef];
    //}
    CGImageRelease( imageRef );
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpaceRef);
    
    return glImage;
}

-(UIImage *) getImageFromAdvanceGL
{
    CVPixelBufferLockBaseAddress(_renderTargetBufferIOS5, kCVPixelBufferLock_ReadOnly);
    uint8_t *baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(_renderTargetBufferIOS5);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(_renderTargetBufferIOS5);
    size_t width = CVPixelBufferGetWidth(_renderTargetBufferIOS5);
    size_t height= CVPixelBufferGetHeight(_renderTargetBufferIOS5);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    UIImage* imageRet = [UIImage imageWithCGImage:newImage];
    CGImageRelease(newImage);
    CVPixelBufferUnlockBaseAddress(_renderTargetBufferIOS5, kCVPixelBufferLock_ReadOnly);
    return imageRet;
}
-(UIImage *) getImageFromGL//:(BOOL)needRotate
{
    if([self supportFastOpenGL]) 
    {
        return [self getImageFromAdvanceGL];
    } else {
        return [self getImageFromGLOlderVersion];
    }
}
- (void) discard{
    /*const GLenum discards[] = {GL_COLOR_ATTACHMENT0};
     if(_glMode != VIEW_MODE || !_eaglLayer) 
     {
     glDiscardFramebufferEXT(GL_FRAMEBUFFER, 1, discards);
     }*/
    //[self removeAllTexture];
}
- (void)setupBufferTexture
{
    if(_bufferTextureSaveRawPicture)
    {
        glDeleteTextures(1, &_bufferTextureSaveRawPicture);
        _bufferTextureSaveRawPicture = 0;
    }
    //[self selectTextureUnit:TEXTURE_1];
    glGenTextures(1, &_bufferTextureSaveRawPicture);
    glBindTexture(GL_TEXTURE_2D, _bufferTextureSaveRawPicture);
    [self setTextureDefault];
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [self imageWidth], [self imageHeight], 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    
}
- (void)setupBlurBufferTexture
{
    if(_bufferRenderTextureForBlur)
    {
        glDeleteTextures(1, &_bufferRenderTextureForBlur);
        _bufferRenderTextureForBlur = 0;
    }
    //[self selectTextureUnit:TEXTURE_1];
    glGenTextures(1, &_bufferRenderTextureForBlur);
    glBindTexture(GL_TEXTURE_2D, _bufferRenderTextureForBlur);
    [self setTextureDefault];
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [self imageWidth], [self imageHeight], 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    
}
- (void) setupFrameTexture
{
    if(_frameRenderTextureStepByStep)
    {
        glDeleteTextures(1, &_frameRenderTextureStepByStep);
        _frameRenderTextureStepByStep = 0;
    }
    //[self selectTextureUnit:TEXTURE_1];
    glGenTextures(1, &_frameRenderTextureStepByStep);
    //NSLog(@"_secondFramebuffer,%d",_frameRenderTextureStepByStep);
    glBindTexture(GL_TEXTURE_2D, _frameRenderTextureStepByStep);
    [self setTextureDefault];
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [self imageWidth], [self imageHeight], 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
}
- (void)activeRenderTextureStepByStep
{
    [self selectTextureUnit:TEXTURE_1];//TODO
    glBindTexture(GL_TEXTURE_2D, _frameRenderTextureStepByStep);  
}
- (void)activeTextureSaveRawPictureAsMainTexture
{
    [self selectTextureUnit:TEXTURE_0];//TODO
    glBindTexture(GL_TEXTURE_2D, _bufferTextureSaveRawPicture);
}
- (void)activeBufferTextureForBlur:(TEXTURE_POSITION_TYPE)texturePos
{
    [self selectTextureUnit:texturePos];//TODO
    glBindTexture(GL_TEXTURE_2D, _bufferRenderTextureForBlur); 
}
- (void)switchToMainFrameBuffer
{
    if(_eaglLayer) //if(_glMode == VIEW_MODE && _eaglLayer) 
    {
        glBindFramebuffer(GL_FRAMEBUFFER, _viewFramebuffer);
        glViewport(0, 0, _backingWidth, _backingHeight); 
        //===================================
        if([self width]>_backingWidth*0.6)
        {
             glBindFramebuffer(GL_FRAMEBUFFER, _sampleFramebuffer);
             glViewport(0, 0, _backingWidth, _backingHeight);
             glClear(GL_COLOR_BUFFER_BIT);
        }
        //=================================
    }
    else 
    {
        /*glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);*/
        glBindFramebuffer(GL_FRAMEBUFFER, _secondFramebuffer);
        glViewport(0, 0, self.width, self.height);
    }
    //glViewport(0, 0, [self imageWidth], [self imageHeight]);
    //glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _frameRenderTexture, 0);
    self.currentBuffer = BUFFER_FIRST;
}
- (void)switchToSecondFrameBuffer
{
    glBindFramebuffer(GL_FRAMEBUFFER, _secondFramebuffer);
    glViewport(0, 0, [self imageWidth], [self imageHeight]);
    self.currentBuffer=BUFFER_SECOND;
    //glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _frameRenderTexture, 0);
}
- (void)switchFrameBuffer
{
    if(self.currentBuffer == BUFFER_SECOND)
        [self switchToMainFrameBuffer];
    else [self switchToSecondFrameBuffer];  
}
- (void)saveFrameToFrameTextureStepByStep
{
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _frameRenderTextureStepByStep, 0);  
}

- (void)saveRawTextureToBuffer
{
 
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _bufferTextureSaveRawPicture, 0); 

}
- (void)saveBlurMiddleProductToBuffer
{
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _bufferRenderTextureForBlur, 0);     
}

- (void)saveToOutputBufferTexture
{
    // only for IOS5
    if([self supportFastOpenGL])
    {
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(_renderTextureIOS5), 0); 
    }  else {
        [self saveBlurMiddleProductToBuffer];
    }
}
-(void) flushContent
{
    if([self supportFastOpenGL])
    {
        [self deleteSaveTexture];
    }
}
- (void) prepareContent
{
    if([self supportFastOpenGL])
    {
        [self createSaveTexture];
    } 
}
- (void)clearSave
{
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, 0, 0);  
}
- (BOOL) supportFastOpenGL
{
    return _isGreatThanOrEqualIOS5;
    //!!IS_SUPPORT_ADVANCECACHE;
}
- (void) switchContext
{
    [EAGLContext setCurrentContext:self.context];
}
- (void) clearContext
{
    [EAGLContext setCurrentContext:nil];
}
@end
