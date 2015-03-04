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

#import "Three20UI/TTLabel.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"
#import "Three20Style/TTStyleContext.h"
#import "Three20Style/TTStyle.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
static UIImage* _leftTopImage;
static UIImage* _topMiddleImage;
static UIImage* _topRightImage;
static UIImage* _leftMiddleImage;
static UIImage* _leftBottomImage;
static UIImage* _bottomMiddleImage;
static UIImage* _bottomRightImage;
static UIImage* _rightMiddleImage;
@implementation TTLabel

@synthesize textColor             = _textColor;
@synthesize font = _font;
@synthesize text = _text;

@synthesize textAlignment         = _textAlignment;
@synthesize ninePatch;
@dynamic threePatches;
///////////////////////////////////////////////////////////////////////////////////////////////////
+(void)initialize
{
    _leftTopImage=[[UIImage imageNamed:@"sns_Bubble_TopLeft.png"]retain];
    _topMiddleImage=[[UIImage imageNamed:@"sns_Bubble_TopMiddle.png"]retain];
    _topRightImage=[[UIImage imageNamed:@"sns_Bubble_TopRight.png"]retain];
    _leftMiddleImage=[[UIImage imageNamed:@"sns_Bubble_LeftMiddle.png"]retain];
    _leftBottomImage=[[UIImage imageNamed:@"sns_Bubble_BottomLeft.png"]retain];
    _bottomMiddleImage=[[UIImage imageNamed:@"sns_Bubble_BottomMiddle.png"]retain];
    _bottomRightImage=[[UIImage imageNamed:@"sns_Bubble_BottomRight.png"]retain];
    _rightMiddleImage=[[UIImage imageNamed:@"sns_Bubble_RightMiddle.png"]retain];
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)internalInit
{
    // Initialization code
    /*_leftTopImage=[[UIImage imageNamed:@"Bubble_TopLeft.png"]retain];
    _topMiddleImage=[[UIImage imageNamed:@"Bubble_TopMiddle.png"]retain];
    _topRightImage=[[UIImage imageNamed:@"Bubble_TopRight.png"]retain];
    _leftMiddleImage=[[UIImage imageNamed:@"Bubble_LeftMiddle.png"]retain];
    _leftBottomImage=[[UIImage imageNamed:@"Bubble_BottomLeft.png"]retain];
    _bottomMiddleImage=[[UIImage imageNamed:@"Bubble_BottomMiddle.png"]retain];
    _bottomRightImage=[[UIImage imageNamed:@"Bubble_BottomRight.png"]retain];
    _rightMiddleImage=[[UIImage imageNamed:@"Bubble_RightMiddle.png"]retain];*/
    self.contentScaleFactor = 2.0;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithText:(NSString*)text {
	self = [self init];
  if (self) {
      _textAlignment  = UITextAlignmentLeft;
    self.text = text;
        [self internalInit];
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	self = [super init];
    if (self) {
        _textAlignment  = UITextAlignmentLeft;
        [self internalInit];
        _text = nil;
        _font = nil;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
  if (self) {
      _textAlignment  = UITextAlignmentLeft;
        [self internalInit];
    _text = nil;
    _font = nil;
  }
  return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setThreePatches:(NSString *)threePatches
{
    if([_threePatches isEqualToString:threePatches])
    {
        return;
    }
    TT_RELEASE_SAFELY(_threePatches);
    _threePatches = [threePatches retain];
    TT_RELEASE_SAFELY(_topImage);
    TT_RELEASE_SAFELY(_middleImage);
    TT_RELEASE_SAFELY(_bottomImage); 
    if(_threePatches)
    {
        NSArray *threePs = [_threePatches componentsSeparatedByString:@","];
        _topImage = [[UIImage imageNamed:[threePs objectAtIndex:0]]retain];
        _middleImage = [[UIImage imageNamed:[threePs objectAtIndex:1]]retain];
       
        if([threePs count]<3)
        {
            _bottomImage = [_middleImage retain];
        } 
        else
        {
            _bottomImage = [[UIImage imageNamed:[threePs objectAtIndex:2]]retain]; 
        }
    }
}
-(NSString*) threePatches
{
    return _threePatches;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_text);
    TT_RELEASE_SAFELY(_font);
    TT_RELEASE_SAFELY(_textColor);
    self.threePatches = nil;
    TT_RELEASE_SAFELY(_topImage);
    TT_RELEASE_SAFELY(_middleImage);
    TT_RELEASE_SAFELY(_bottomImage);
    
    /*TT_RELEASE_SAFELY(_leftTopImage);
    TT_RELEASE_SAFELY(_topMiddleImage);
    TT_RELEASE_SAFELY(_topRightImage);
    TT_RELEASE_SAFELY(_leftMiddleImage);
    TT_RELEASE_SAFELY(_leftBottomImage);
    TT_RELEASE_SAFELY(_bottomMiddleImage);
    TT_RELEASE_SAFELY(_bottomRightImage);
    TT_RELEASE_SAFELY(_rightMiddleImage);*/
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
    //ninePatch = NO;
    if (self.threePatches)
    {
        [_topImage drawInRect:CGRectMake(0, 0, _topImage.size.width, _topImage.size.height)];
        
        [_middleImage drawInRect:
         CGRectMake(0, _topImage.size.height,
                    _middleImage.size.width,
                    self.frame.size.height - _topImage.size.height - _bottomImage.size.height)];
        
        [_bottomImage drawInRect:CGRectMake(0, self.frame.size.height - _bottomImage.size.height, _bottomImage.size.width, _bottomImage.size.height)];
    } 
    else if(ninePatch)
    {
        [_leftTopImage drawAtPoint:CGPointMake(0, 0)];
        [_topMiddleImage drawInRect:
            CGRectMake(_leftTopImage.size.width, 0, 
                       self.frame.size.width - _leftTopImage.size.width - _topRightImage.size.width,
                       _topMiddleImage.size.height)];
         
        [_leftMiddleImage drawInRect:
         CGRectMake(0, _leftTopImage.size.height,
                    _leftMiddleImage.size.width,
                    self.frame.size.height - _leftTopImage.size.height - _leftBottomImage.size.height)];
        CGRect newRect = CGRectMake(
                                    self.frame.size.width - _rightMiddleImage.size.width,
                                    _topRightImage.size.height,
                                    _rightMiddleImage.size.width,
                                    self.frame.size.height - _topRightImage.size.height - _bottomRightImage.size.height);
        [_rightMiddleImage drawInRect:newRect];
        
        [_bottomMiddleImage drawInRect:
         CGRectMake(_leftBottomImage.size.width, self.frame.size.height - _bottomMiddleImage.size.height,
                    self.frame.size.width - _leftBottomImage.size.width - _bottomRightImage.size.width,_bottomMiddleImage.size.height)];
        
        [_topRightImage drawAtPoint:
            CGPointMake(self.frame.size.width - _topRightImage.size.width, 0)];
        [_leftBottomImage drawAtPoint:
            CGPointMake(0, self.frame.size.height - _leftBottomImage.size.height)];
        [_bottomRightImage drawAtPoint:CGPointMake(self.frame.size.width - _topRightImage.size.width,
                                        self.frame.size.height - _topRightImage.size.height)];
        CGContextRef context = UIGraphicsGetCurrentContext();
         UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds,3,3) cornerRadius:2];
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        //CGContextBeginPath(context);
        CGContextAddPath(context, [path CGPath]);
        
        //[[UIColor greenColor]set];
        [RGBCOLOR(241, 241, 238) set];
        CGContextDrawPath(context, kCGPathFill);
        //CGContextClosePath(context);
        CGContextRestoreGState(context);
    } else {
        
        TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
        context.delegate = self;
        context.frame = self.bounds;
        context.contentFrame = context.frame;
        context.font = _font;
        
        [self.style draw:context];
        //NSLog(@"context:%@",self.text);
        if (self.text)
        {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            [self.textColor set];
            [self.text drawInRect:self.bounds withFont:self.font
                    lineBreakMode:UILineBreakModeTailTruncation alignment:_textAlignment];
            CGContextRestoreGState(ctx);
        }
        if (!context.didDrawContent) {
            [self drawContent:self.bounds];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)sizeThatFits:(CGSize)size {
  TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
  context.delegate = self;
  context.font = _font;
  context.frame = CGRectMake(0, 0, size.width, size.height);
  context.contentFrame = context.frame;
  CGSize newSize = [_style addToSize:CGSizeZero context:context];
  if(newSize.height == 0 || newSize .width ==0)
  {
      newSize = [self.text sizeWithFont:self.font];
  }
    return newSize;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIAccessibility


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isAccessibilityElement {
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)accessibilityLabel {
  return _text;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIAccessibilityTraits)accessibilityTraits {
  return [super accessibilityTraits] | UIAccessibilityTraitStaticText;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTStyleDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)textForLayerWithStyle:(TTStyle*)style {
  return self.text;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)font {
  if (!_font) {
    _font = [TTSTYLEVAR(font) retain];
  }
  return _font;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFont:(UIFont*)font {
  if (font != _font) {
    [_font release];
    _font = [font retain];
    [self setNeedsDisplay];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)textColor {
    if (!_textColor) {
        _textColor = [TTSTYLEVAR(textColor) retain];
    }
    return _textColor;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextColor:(UIColor*)textColor {
    if (textColor != _textColor) {
        [_textColor release];
        _textColor = [textColor retain];
        [self setNeedsDisplay];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setText:(NSString*)text {
  if (text != _text) {
    [_text release];
    _text = [text copy];
    [self setNeedsDisplay];
  }
}


@end
