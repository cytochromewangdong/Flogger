//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Three20UI/TTImageView.h"

// UI
#import "Three20UI/TTImageViewDelegate.h"

// UI (private)
#import "Three20UI/private/TTImageLayer.h"
#import "Three20UI/private/TTImageViewInternal.h"

// Style
#import "Three20Style/TTShape.h"
#import "Three20Style/TTStyleContext.h"
#import "Three20Style/TTContentStyle.h"
#import "Three20Style/UIImageAdditions.h"

// Network
#import "Three20Network/TTURLCache.h"
#import "Three20Network/TTURLImageResponse.h"
#import "Three20Network/TTURLRequest.h"

@implementation TTImageEffect

@synthesize cornerRadius,borderColor,borderWidth,shadowOffset,shadowColor,shadowOpacity,shadowRadius;

@end
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTImageView

@synthesize urlPath             = _urlPath;
@synthesize image               = _image;
@synthesize defaultImage        = _defaultImage;
@synthesize autoresizesToImage  = _autoresizesToImage;
@synthesize request				= _request;
@synthesize effect;
@synthesize delegate = _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)internalInit
{
    self.contentMode = UIViewContentModeScaleAspectFit;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
  if (self) {
    _autoresizesToImage = NO;
        [self internalInit];
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)init
{
    self = [super init];
    if (self)
    {
        [self internalInit];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  _delegate = nil;
  _request.delegate = nil;
    self.effect = nil;
  TT_RELEASE_SAFELY(_request);
  TT_RELEASE_SAFELY(_urlPath);
  TT_RELEASE_SAFELY(_image);
  TT_RELEASE_SAFELY(_defaultImage);
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (Class)layerClass {
  return [TTImageLayer class];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
  /*if (self.style)
  {
    [super drawRect:rect];
  }*/
    
if (self.style)
{
    TTStyle* style = self.style;
    CGRect drawArea = CGRectMake(self.marginLeft, self.marginTop,
                                 self.bounds.size.width - self.marginLeft - self.marginRight,
                                 self.bounds.size.height - self.marginTop - self.marginBottom);
    if (nil != style) {
        TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
        context.delegate = self;
        context.frame = self.bounds;
        context.contentFrame = context.frame;
        [style draw:context];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        //CGRect rect = [image convertRect:context.contentFrame withContentMode:_contentMode];
        [context.shape addToPath:context.frame];
        CGContextClip(ctx);
        
        [self drawContent:drawArea];
        
        CGContextRestoreGState(ctx);
        //[style draw:context];
    } else {
        [self drawContent:drawArea];
    }
}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawContent:(CGRect)rect {
  if (nil != _image) {
      [_image drawInRect:rect contentMode:self.contentMode];

  } else {
      [_defaultImage drawInRect:rect contentMode:UIViewContentModeCenter];//self.contentMode];
  }
}



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTStyleDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawLayer:(TTStyleContext*)context withStyle:(TTStyle*)style {
  if ([style isKindOfClass:[TTContentStyle class]]) {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGRect rect = context.frame;
      
    [self drawContent:rect];
    [context.shape addToPath:rect];
    CGContextClip(ctx);

    CGContextRestoreGState(ctx);
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
  return !!_request.image;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
  return nil != _image && _image != _defaultImage;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reload {
  if (nil != _urlPath) {
      if (!_request)
      {
          _request = [[SDImageDelegate alloc]init];
          _request.delegate = self;
      }
    BOOL ret = [_request loadImageWithURL:_urlPath];

      UIImage* image = ret?_request.image:nil;

    if (nil != image) {
      self.image = image;

    } else {
        // Put the default image in place while waiting for the request to load
        /*if (_defaultImage && nil == self.image) {
          self.image = _defaultImage;
      }*/
    }
      //[self setNeedsDisplay];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stopLoading {

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidStartLoad {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidLoadImage:(UIImage*)image {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidFailLoadWithError:(NSError*)error {
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark imagedownload finished


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)downloadFinished:(SDImageDelegate*)downloader
{
    if ([downloader.lastKey isEqualToString:self.urlPath]) {
        self.image = downloader.image;
        [self setNeedsDisplay];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)unsetImage {
  [self stopLoading];
  self.image = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDefaultImage:(UIImage*)theDefaultImage {
  if (_defaultImage != theDefaultImage) {
    [_defaultImage release];
    _defaultImage = [theDefaultImage retain];
  }
  if (nil == _urlPath || 0 == _urlPath.length) {
    //no url path set yet, so use it as the current image
    self.image = _defaultImage;
  }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if(self.image)
    {
        return self.image.size;
    } else {
        TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
        context.delegate = self;
        context.font = nil;
        return [_style addToSize:CGSizeZero context:context];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUrlPath:(NSString*)urlPath {
  // Check for no changes.
  //if (nil != _image && nil != _urlPath && [urlPath isEqualToString:_urlPath]) 
  {
//    return;
  }
    self.image  = nil;
  [self stopLoading];

  {
    NSString* urlPathCopy = [urlPath copy];
    [_urlPath release];
    _urlPath = urlPathCopy;
  }

   // dispatch_async(dispatch_get_main_queue(), ^{
        if (nil == _urlPath || 0 == _urlPath.length) {
            // Setting the url path to an empty/nil path, so let's restore the default image.
            self.image = _defaultImage;
            
        } else {
            [self reload];
        }
        
        //[self setNeedsDisplay];
   // });
}


@end
