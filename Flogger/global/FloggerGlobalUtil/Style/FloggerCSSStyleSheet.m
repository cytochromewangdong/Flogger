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

#import "FloggerCSSStyleSheet.h"

@implementation FloggerCSSStyleSheet


- (TTStyle *)h4:(UIControlState)state {
  return
  [TTSolidFillStyle styleWithColor:TTCSSSTATE(@"h4text", backgroundColor, state) next:
   [TTShadowStyle styleWithCssSelector:@"h4shadow" forState:state next:
    [TTTextStyle styleWithCssSelector:@"h4text" forState:state next:
     nil]]];
}

- (TTStyle*)feedTime {
    //[TTSolidFillStyle styleWithColor:TTCSS(@"feedTime2", backgroundColor) next:
    return 
            [TTShadowStyle styleWithCssSelector:@"feedTime1" next: [TTTextStyle styleWithCssSelector:@"feedTime" next:nil]];
}

- (TTStyle*)feedName {
    return [TTTextStyle styleWithCssSelector:@"feedName" next:nil];
}

- (TTStyle*)blueText {
    return [TTTextStyle styleWithColor:[UIColor blueColor] next:nil];
}

- (TTStyle*)largeText {
    return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:32] next:nil];
}

- (TTStyle*)smallText {
    return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] next:nil];
}

- (TTStyle*)floated {
    return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(0, 0, 5, 5)
                               padding:UIEdgeInsetsMake(0, 0, 0, 0)
                               minSize:CGSizeZero position:TTPositionFloatLeft next:nil];
}

- (TTStyle*)blueBox {
    return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:6] next:
     [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, -10, -5, -20) next:
      [TTShadowStyle styleWithColor:[UIColor grayColor] blur:2 offset:CGSizeMake(1,1) next:
       [TTSolidFillStyle styleWithColor:[UIColor cyanColor] next:
        [TTSolidBorderStyle styleWithColor:[UIColor grayColor] width:1 next:nil]]]]];
}

- (TTStyle*)inlineBox {
    return
    [TTSolidFillStyle styleWithColor:[UIColor blueColor] next:
     [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(5,13,5,13) next:
      [TTSolidBorderStyle styleWithColor:[UIColor blackColor] width:1 next:nil]]];
}

- (TTStyle*)inlineBox2 {
    return
    [TTSolidFillStyle styleWithColor:[UIColor cyanColor] next:
     [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(5,50,0,50)
                         padding:UIEdgeInsetsMake(0,13,0,13) next:nil]];
}


-(TTStyle *) flatButton : (UIControlState ) state
{
    return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4] next:
     [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
      [TTSolidBorderStyle styleWithColor:RGBCOLOR(175, 175, 175) width:1 
                                    next:[TTTextStyle styleWithFont:nil color:RGBCOLOR(0, 0, 0) textAlignment:UITextAlignmentCenter next:nil]]]];
}

-(UIFont*) buttonFont
{
    return [UIFont boldSystemFontOfSize:14];
}

- (TTStyle*)userFormat {
    return
        [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14] color:[[FloggerUIFactory uiFactory] createTableViewFontColor] next:nil];
}
- (TTStyle *)nameBold
{
    return
    [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14] color:[[FloggerUIFactory uiFactory] createTableViewFontColor] next:nil];
}
- (TTStyle *)importantBold
{
    return
    [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14] color:[[FloggerUIFactory uiFactory] createTableViewFontColor] next:nil];
}
- (UIColor*)linkTextColor {
    return RGBCOLOR(8, 124, 165);
}

@end
