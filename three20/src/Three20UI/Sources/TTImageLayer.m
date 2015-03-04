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

#import "Three20UI/private/TTImageLayer.h"

// UI
#import "Three20UI/TTImageView.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTImageLayer

@synthesize override = _override;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)display {
  if (nil != _override) {
      if(_override.image)
      {
    self.contents = (id)_override.image.CGImage;
      } else {
    self.contents = (id)_override.defaultImage.CGImage;
      }
      if (_override.effect)
      {
          self.masksToBounds =YES;

          self.borderColor = [_override.effect.borderColor CGColor];
          self.borderWidth = _override.effect.borderWidth;
          //self.shadowColor = [_override.effect.shadowColor CGColor];
          //self.shadowOffset = _override.effect.shadowOffset;
          //self.shadowRadius = _override.effect.shadowRadius;
          //self.shadowOpacity = _override.effect.shadowOpacity;
          //self.shouldRasterize = YES;
          //self.bounds = CGRectMake(5, 5, _override.frame.size.width -10, _override.frame.size.height -10);
          self.contentsScale = [[UIScreen mainScreen]scale];
          self.cornerRadius = _override.effect.cornerRadius;
          /*if (self.cornerRadius >0) {
              self.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self bounds] 
                                cornerRadius:self.cornerRadius]CGPath];
          }*/
      }
  } 
  else {
    return [super display];
  }
}


@end
