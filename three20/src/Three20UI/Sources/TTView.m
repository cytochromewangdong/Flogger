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

#import "Three20UI/TTView.h"

// Style
#import "Three20Style/TTStyleContext.h"
#import "Three20Style/TTStyle.h"
#import "Three20Style/TTLayout.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTView

@synthesize style   = _style;
@synthesize layout  = _layout;
@dynamic margin;
@synthesize marginBottom;
@synthesize marginTop;
@synthesize marginLeft;
@synthesize marginRight;
@synthesize actionDelegate;
- (void) setMargin:(GLfloat)margin
{
    _margin = margin;
    self.marginBottom = _margin;
    self.marginTop =_margin;
    self.marginLeft = _margin;
    self.marginRight = _margin;
}
- (GLfloat) margin
{
    return _margin;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
  if (self) {
    self.contentMode = UIViewContentModeRedraw;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_style);
  TT_RELEASE_SAFELY(_layout);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
  TTStyle* style = self.style;
  CGRect drawArea = CGRectMake(marginLeft, marginTop,
                               self.bounds.size.width - marginLeft - marginRight,
                               self.bounds.size.height - marginTop - marginBottom);
  if (nil != style) {
    TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
    context.delegate = self;
    context.frame = self.bounds;
    context.contentFrame = context.frame;
    [style draw:context];
    if (!context.didDrawContent) 
    {
        [self drawContent:drawArea];
    }
  } else {
    [self drawContent:drawArea];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
  TTLayout* layout = self.layout;
  if (nil != layout) {
    [layout layoutSubviews:self.subviews forView:self];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)sizeThatFits:(CGSize)size {
  TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
  context.delegate = self;
  context.font = nil;
  return [_style addToSize:CGSizeZero context:context];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStyle:(TTStyle*)style {
  if (style != _style) {
    [_style release];
    _style = [style retain];

    [self setNeedsDisplay];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawContent:(CGRect)rect {
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    if([touches count]==1)
    {
        if([actionDelegate handleTap:nil])
        {
            return;
        }
    }
    // We definitely don't want to call this if the label is inside a TTTableView, because
    // it winds up calling touchesEnded on the table twice, triggering the link twice
    [super touchesEnded:touches withEvent:event];
}

@end
