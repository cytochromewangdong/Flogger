//
//  FloggerLayoutAdapter.m
//  Flogger
//
//  Created by dong wang on 12-4-13.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerLayoutAdapter.h"
#import "FloggerWebAdapter.h"
#import "FloggerButtonView.h"
#import "TBXML.h"
#define kLayoutName @"id"
#define kActionType @"actionType"
#define kFillDataKey @"fill-data"
//#define kStyle @"class"
#define kImage @"src"
#define kContentMode @"contentMode"
#define kXType @"x-type"
#define kPureText @"pureText"
#define kPlaceholder @"placeholder"
#define kPressImage @"pressedImage"
#define kLoopMore @"loopMore"
#define SPLITOR_HYPHONE @"_"
#define CONVERT_POS(strVal) (strVal)?([(strVal) hasPrefix:@"auto"]?AUTO_DIMENTION:[(strVal) floatValue]):0
#define CONVERT_SIZE(strVal) ((!strVal)||[(strVal) isEqualToString:@"auto"])?AUTO_DIMENTION:[(strVal) floatValue]

@implementation UIColor(HexString)

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    if([hexString hasPrefix:@"#"])
    {
        NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
        CGFloat alpha, red, blue, green;
        switch ([colorString length]) {
            case 3: // #RGB
                alpha = 1.0f;
                red   = [self colorComponentFrom: colorString start: 0 length: 1];
                green = [self colorComponentFrom: colorString start: 1 length: 1];
                blue  = [self colorComponentFrom: colorString start: 2 length: 1];
                break;
            case 4: // #ARGB
                alpha = [self colorComponentFrom: colorString start: 0 length: 1];
                red   = [self colorComponentFrom: colorString start: 1 length: 1];
                green = [self colorComponentFrom: colorString start: 2 length: 1];
                blue  = [self colorComponentFrom: colorString start: 3 length: 1];          
                break;
            case 6: // #RRGGBB
                alpha = 1.0f;
                red   = [self colorComponentFrom: colorString start: 0 length: 2];
                green = [self colorComponentFrom: colorString start: 2 length: 2];
                blue  = [self colorComponentFrom: colorString start: 4 length: 2];                      
                break;
            case 8: // #AARRGGBB
                alpha = [self colorComponentFrom: colorString start: 0 length: 2];
                red   = [self colorComponentFrom: colorString start: 2 length: 2];
                green = [self colorComponentFrom: colorString start: 4 length: 2];
                blue  = [self colorComponentFrom: colorString start: 6 length: 2];                      
                break;
            default:
                [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
                break;
        }
        return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    } else {
        NSString* colorSelStr = [NSString stringWithFormat:@"%@Color",hexString];
        SEL colMethod = NSSelectorFromString(colorSelStr);
        if([self respondsToSelector:colMethod])
        {
            return [self performSelector:colMethod withObject:nil];
        } else {
            return nil;
        }
        //if([sel)
    }
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end 

@implementation FloggerLayoutParam
@synthesize width,height,actionType,image,userEnabled,pressedImage;//,imgSrc
-(void)dealloc
{
    self.actionType = nil;
    self.image = nil;
    self.userEnabled = nil;
    self.pressedImage=nil;
    [super dealloc];
}
@end
@implementation FloggerViewAdpater
@synthesize layout,subviews,parentView,view,name,actionType;
@synthesize actionDeletgate;
-(FloggerViewAdpater*) getPreviousSibling:(NSDictionary*)invisibleViews
{
    NSUInteger index = [self.parentView.subviews indexOfObject:self];
    if(index>0 && index <[self.parentView.subviews count])
    {
       int i = index - 1;
        for(;i>=0;i--){
            FloggerViewAdpater* oldBrother =  [self.parentView.subviews objectAtIndex:i];
            if(![invisibleViews objectForKey:oldBrother.name] && !oldBrother.layout.style.outOfFlow)
            {
                return oldBrother;
            }
        }
    }
        
    return nil;
}
-(BOOL)handleTap:(id)param
{
    
    if([[[param objectForKey:@"url"] lowercaseString] hasPrefix:@"http:"])
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[param objectForKey:@"url"]]];
        return YES;
    }
    if([NONE_ACTION isEqualToString:self.actionType])
    {
        return NO;
    }
    if(self.layout.actionType || self.actionType)
    {
        NSString *tActionType = self.actionType?self.actionType:self.layout.actionType;
        NSMutableDictionary *data = [[[NSMutableDictionary alloc]initWithDictionary:param]autorelease];
        [data setObject:tActionType forKey:KEY_WEB_ACTION];
        NSString *urlStr = [param objectForKey:@"url"];
        if(urlStr)
        {
            NSURL *targetURL = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSString* scheme = [targetURL scheme];
            NSString *myQuery = [targetURL.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [data setValue:myQuery forKey:kKeyword];
            [data setValue:scheme forKey:kScheme];
        }
        NSNotification* notifcate = [NSNotification notificationWithName:tActionType object:data];
        [actionDeletgate handleAction:notifcate];
        
        return YES;
    }
    return NO;
}
-(FloggerViewAdpater*) internalGetAdapterByName:(FloggerViewAdpater*) currentAdapter Name:(NSString*)fName
{
    FloggerViewAdpater * ret = nil; 
    if([currentAdapter.name isEqualToString:fName])
    {
        return currentAdapter;
    }
    for (FloggerViewAdpater *adapter in currentAdapter.subviews) {
        ret = [self internalGetAdapterByName:adapter Name:fName];
        if(ret)
        {
            return ret;
        }
    }
    return ret;
}
-(FloggerViewAdpater*) getAdpaterByName:(NSString*)fName;
{
    FloggerViewAdpater *rootAdapter = self;
    while(rootAdapter.parentView)
    {
        rootAdapter = rootAdapter.parentView;
    }
    return  [self internalGetAdapterByName:rootAdapter Name:fName];
}

-(void) dealloc
{
    self.layout = nil;
    for (FloggerViewAdpater *subview in subviews) {
        subview.parentView = nil;
    }
    self.subviews = nil;
    self.parentView = nil;
    self.view = nil;
    self.name = nil;
    self.actionType = nil;
    self.actionDeletgate = nil;
    [super dealloc];
}
@end

@implementation FloggerStyle
@synthesize rawContentMode,rawPosition,rawX,rawY,rawWidth,rawHeight,name,rawHPadding,rawVPadding,rawHMargin,rawVMargin;
@synthesize rawBorder,rawColor,rawBackgroundColor,rawFilter,rawFont,rawSysfont,rawEffect,rawTextAlignment,rawUserEnable,rawMiny,rawAnimation,rawProgressable,rawMaxiumH,rawMaxiumW,rawThreePatches,rawOutOfFlow;
@synthesize x=_x,y=_y,width=_width,height=_height,color=_color,font=_font,backgroundColor=_backgroundColor;
@synthesize filter = _filter,effect=_effect;
@synthesize textAlignment=_textAlignment;
@synthesize adjustX=_adjustX,adjustY =_adjustY,userEnable = _userEnable, minY=_minY, animation=_animation,progressable=_progressable,maxiumH=_maxiumH,maxiumW=_maxiumW,outOfFlow=_outOfFlow;
-(void)presetX
{
    //@"dd" hasPrefix:(NSString *)
    /*if([self.rawX isEqualToString:@"center"])
    {
        _x = 0;
    }
    else */
    if(self.rawX)
    {
        NSArray * xArray = [self.rawX componentsSeparatedByString:@" "];
        //_x = CONVERT_POS(([xArray objectAtIndex:0]));
        if([xArray count]>=2)
        {
            _x = AUTO_DIMENTION;
            //if([xArray count]>1)
            {
                _adjustX = [[xArray objectAtIndex:1] floatValue];
            }
        } 
        else 
        {
            if([self.rawX hasPrefix:@"auto"] || [self.rawX hasPrefix:@"center"] ||[self.rawX hasPrefix:@"right"])
            {
                _x = AUTO_DIMENTION;
            } else {
                _x = [[xArray objectAtIndex:0] floatValue];
            }
        }
    }
}
-(void)presetY
{
    /*if([self.rawY isEqualToString:@"center"])
    {
        _y = 0;
    }
    else */
    if(self.rawY)
    {
        NSArray * yArray = [self.rawY componentsSeparatedByString:@" "];
        if([yArray count]>=2)
        {
            _y = AUTO_DIMENTION;//CONVERT_POS(([yArray objectAtIndex:0]));
            //if([yArray count]>1)
            {
                _adjustY = [[yArray objectAtIndex:1] floatValue];
            }
        }  else {

            if([self.rawY hasPrefix:@"auto"] || [self.rawY hasPrefix:@"center"] ||[self.rawY hasPrefix:@"bottom"])
            {
                _y = AUTO_DIMENTION;
            } else {
                _y = [[yArray objectAtIndex:0] floatValue]; 
            }
        }
    }
}
-(void)presetWidth
{
    _width = CONVERT_SIZE(self.rawWidth);
    if(_width<=0.000001)
    {
        _width = AUTO_DIMENTION;
    }
}
-(void)presetHeight
{
    _height =  CONVERT_SIZE(self.rawHeight);
    if(_height<=0.000001)
    {
        _height = AUTO_DIMENTION;
    }
}
-(void)presetColor{
    if(self.rawColor)
    {
        _color = [[UIColor colorWithHexString:self.rawColor] retain];
    }
}
-(void)presetBackgroundColor
{
    if(self.rawBackgroundColor)
    {
        _backgroundColor =  [[UIColor colorWithHexString:self.rawBackgroundColor] retain];
    } 
}
-(void) presetFont
{
    if(self.rawSysfont)
    {
        NSArray * fontArray = [self.rawSysfont componentsSeparatedByString:@" "];
        if([fontArray count]==1)
        {
            _font = [UIFont systemFontOfSize:[[fontArray objectAtIndex:0] floatValue]];
        } else {
            if([@"bold" isEqualToString:[fontArray objectAtIndex:1]])
            {
                _font = [UIFont boldSystemFontOfSize:[[fontArray objectAtIndex:0] floatValue]];
            } 
            else if([@"i" isEqualToString:[fontArray objectAtIndex:1]])
            {
                _font = [UIFont italicSystemFontOfSize:[[fontArray objectAtIndex:0] floatValue]];   
            } else {
                _font = [UIFont systemFontOfSize:[[fontArray objectAtIndex:0] floatValue]];
            }
            
        }
    }
    
    if(self.rawFont)
    {
        NSArray * fontArray = [self.rawFont componentsSeparatedByString:@" "];
        if([fontArray count]==1)
        {
            _font = [UIFont fontWithName:[fontArray objectAtIndex:0] size:15];
        } else {
            
            _font = [UIFont fontWithName:[fontArray objectAtIndex:0] size:[[fontArray objectAtIndex:1]floatValue]];
        }
    }
    [_font retain];
}
-(void) presetFilter
{
    if(!self.rawFilter) return;
    NSArray *filters = [self.rawFilter componentsSeparatedByString:@","];
    TTStyle *style = nil;
    for (int i=[filters count] - 1;i>=0;i--) 
    {
        NSString *filter = [filters objectAtIndex:i];
        NSArray *filterParams = [filter componentsSeparatedByString:@" "];
        if([[filterParams objectAtIndex:0]isEqualToString:@"rounded"])
        {
            NSString *radius = [filterParams objectAtIndex:1];
            style =  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:[radius floatValue]] next:style];
            //[TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
            // [TTSolidBorderStyle styleWithColor:black width:1 next:nil]]]
        } else if([[filterParams objectAtIndex:0]isEqualToString:@"border"])
        {
            NSString *color = [filterParams objectAtIndex:1];
            NSString *bwidth = [filterParams objectAtIndex:2];
            style =  [TTSolidBorderStyle styleWithColor:[UIColor colorWithHexString:color] width:[bwidth floatValue] next:style]; 
        } else if([[filterParams objectAtIndex:0]isEqualToString:@"fill"])
        {
            NSString *color = [filterParams objectAtIndex:1];
            style =  [TTSolidFillStyle styleWithColor:[UIColor colorWithHexString:color] next:style]; 
        }
        else if([[filterParams objectAtIndex:0]isEqualToString:@"shadow"])
        {
            NSString *color = [filterParams objectAtIndex:1];
            CGSize offset = CGSizeMake([[filterParams objectAtIndex:2] floatValue], [[filterParams objectAtIndex:3] floatValue]);
            float blur = 0;
            if([filterParams count]>4)
            {
               blur = [[filterParams objectAtIndex:4] floatValue];
            }
            float radius = 0;
            if([filterParams count]>5)
            {
                radius = [[filterParams objectAtIndex:5] floatValue];
            }
            UIColor *fillColor = self.backgroundColor;
            if([filterParams count]>6)
            {
                fillColor = [UIColor colorWithHexString:[filterParams objectAtIndex:6]];
            }
            if(!fillColor)
            {
                fillColor = [UIColor clearColor];
            }
            style=[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:radius] next:
             [TTShadowStyle styleWithColor:[UIColor colorWithHexString:color] blur:blur offset:offset next:
              [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 0, 0) next:
               [TTSolidFillStyle styleWithColor:fillColor next:style]]]];
            //style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:0] next:
            // [TTShadowStyle styleWithColor:[UIColor colorWithHexString:color] blur:blur offset:offset next:
            //  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:0] next:
            //  [TTSolidFillStyle styleWithColor:fillColor next:style]]]];  
        }
        
    } 
    _filter = [style retain];
}
-(void) presetEffect
{
    if(self.rawEffect)
    {
        _effect = [[TTImageEffect alloc]init];
        
        NSArray *filters = [self.rawEffect componentsSeparatedByString:@","];
        for (int i=[filters count] - 1;i>=0;i--) 
        {
            NSString *filter = [filters objectAtIndex:i];
            NSArray *filterParams = [filter componentsSeparatedByString:@" "];
            if([[filterParams objectAtIndex:0]isEqualToString:@"radius"])
            {
                _effect.cornerRadius =  [[filterParams objectAtIndex:1] floatValue];
            } else if([[filterParams objectAtIndex:0]isEqualToString:@"border"])
            {
                NSString *color = [filterParams objectAtIndex:1];
                NSString *bwidth = [filterParams objectAtIndex:2];
                _effect.borderColor = [UIColor colorWithHexString:color];
                _effect.borderWidth = [bwidth floatValue];
            } else if([[filterParams objectAtIndex:0]isEqualToString:@"shadow"])
            {
                NSString *color = [filterParams objectAtIndex:1];
                _effect.shadowColor  = [UIColor colorWithHexString:color];
                _effect.shadowOffset = CGSizeMake([[filterParams objectAtIndex:2] floatValue], [[filterParams objectAtIndex:3] floatValue]);
                _effect.shadowRadius = 3;
                if([filterParams count]>4)
                {
                    _effect.shadowRadius = [[filterParams objectAtIndex:4] floatValue];
                }
                _effect.shadowOpacity = 0.5;
                if([filterParams count]>5)
                {
                    _effect.shadowOpacity = [[filterParams objectAtIndex:5] floatValue];
                }
            }
            
        } 
    }
    
}
-(void) presetUserEnable
{
    _userEnable = YES;
    if(self.rawUserEnable)
    {
        if([@"NO" isEqualToString:self.rawUserEnable] 
            || [@"no" isEqualToString:self.rawUserEnable]
            || [@"0" isEqualToString:self.rawUserEnable])
        {
            _userEnable = NO;
        } 
    }
}
-(void) presetAnimation
{
    _animation = NO;
    if(self.rawAnimation)
    {
        if([@"YES" isEqualToString:self.rawAnimation] 
           || [@"yes" isEqualToString:self.rawAnimation]
           || [@"1" isEqualToString:self.rawAnimation])
        {
            _animation = YES;
        } 
    }
}
-(void) presetTextAlignment
{
    _textAlignment = UITextAlignmentLeft;
    if(self.rawTextAlignment)
    {
        if([@"right" isEqualToString:self.rawTextAlignment])
        {
            _textAlignment = UITextAlignmentRight;
        }
        if([@"center" isEqualToString:self.rawTextAlignment])
        {
            _textAlignment = UITextAlignmentCenter;
        }
    }
}
-(void)presetMinY
{
    /*if([self.rawY isEqualToString:@"center"])
     {
     _y = 0;
     }
     else */
    if(self.rawMiny)
    {
        _minY = [self.rawMiny floatValue];
    }
}

-(void)presetMaxiumW
{
    /*if([self.rawY isEqualToString:@"center"])
     {
     _y = 0;
     }
     else */
    if(self.rawMaxiumW)
    {
        _maxiumW = [self.rawMaxiumW floatValue];
    }
}
-(void)presetMaxiumH
{
    /*if([self.rawY isEqualToString:@"center"])
     {
     _y = 0;
     }
     else */
    if(self.rawMaxiumH)
    {
        _maxiumH = [self.rawMaxiumH floatValue];
    }
}
-(void)presetProgressable
{
    _progressable = NO;
    if(self.rawProgressable)
    {
        if([@"YES" isEqualToString:self.rawProgressable] 
           || [@"yes" isEqualToString:self.rawProgressable]
           || [@"1" isEqualToString:self.rawProgressable])
        {
            _progressable = YES;
        } 
    }
}
-(void)presetOutOfFlow
{
    _outOfFlow = NO;
    if(self.rawOutOfFlow)
    {
        if([@"YES" isEqualToString:self.rawOutOfFlow] 
           || [@"yes" isEqualToString:self.rawOutOfFlow]
           || [@"1" isEqualToString:self.rawOutOfFlow])
        {
            _outOfFlow = YES;
        }  
    }
}
-(void) dealloc
{
    self.rawContentMode = nil;
    self.rawPosition = nil;
    self.rawX = nil;
    self.rawY = nil;
    self.rawHeight = nil;
    self.rawHeight = nil;
    self.name = nil;
    self.rawHPadding = nil;
    self.rawVPadding = nil;
    self.rawHMargin = nil;
    self.rawVMargin = nil;
    self.rawBorder = nil;
    self.rawColor = nil;
    self.rawBackgroundColor = nil;
    self.rawFilter = nil;
    self.rawFont = nil;
    self.rawSysfont = nil;
    self.rawEffect = nil;
    self.rawTextAlignment = nil;
    self.rawMiny = nil;
    self.rawMaxiumH = nil;
    self.rawMaxiumW = nil;
    self.rawProgressable = nil;
    self.rawThreePatches = nil;
    self.rawOutOfFlow =nil;
    TT_RELEASE_SAFELY(_color);
    TT_RELEASE_SAFELY(_backgroundColor);
    TT_RELEASE_SAFELY(_font);
    TT_RELEASE_SAFELY(_filter);
    TT_RELEASE_SAFELY(_effect);
    [super dealloc];
}
@end

@implementation FloggerLayout
-(id)init
{
    self = [super init];
    if(self)
    {
        self.subviews = [[[NSMutableArray alloc]init]autorelease];
    }
    return self;
}
@synthesize name,actionType,fillDataKey,style,imageSrc,subviews,parentView,viewType,label,placeholder,pressedImage,loopMore,pureText;
@synthesize image =_image, placeHolderImage=_placeHolderImage, pressedImageSingle=_pressedImageSingle;
-(void)dealloc
{
    self.name = nil;
    self.actionType = nil;
    self.fillDataKey = nil;
    self.style = nil;
    self.imageSrc = nil;
    for (FloggerLayout *subview in subviews) {
        subview.parentView = nil;
    }
    self.image = nil;
    self.pressedImage = nil;
    self.pressedImageSingle = nil;
    self.placeHolderImage = nil;
    self.subviews = nil;
    self.parentView = nil;
    self.viewType = nil;
    self.label = nil;
    self.loopMore = nil;
    self.pureText = nil;
    [super dealloc];
}
-(FloggerLayout*)createClone
{
    FloggerLayout *clone = [[FloggerLayout alloc]init];
    
    clone.actionType  = self.actionType;
    clone.fillDataKey = self.fillDataKey; 
    clone.style       = self.style;
    clone.imageSrc    = self.imageSrc;
    clone.placeholder = self.placeholder;
    clone.viewType = self.viewType;
    clone.pressedImage = self.pressedImage;
    clone.label = self.label;
    clone.image = self.image;
    clone.placeHolderImage = self.placeHolderImage;
    clone.pureText = self.pureText;
    return clone;
}
@end

static FloggerLayoutAdapter * instance;
//static NSMutableDictionary * filters;
@implementation FloggerLayoutAdapter

+(FloggerLayoutAdapter *)sharedInstance
{
    if (!instance) {
        instance = [[FloggerLayoutAdapter alloc] init];
    }
    
    return instance;
}

+(void)purgeSharedInstance
{
    [instance release];
    instance = nil;
}
-(void) fillLayoutProperty:(FloggerLayout *)layout XMLElement:(TBXMLElement *)element
{
    layout.name = [TBXML valueOfAttributeNamed:kLayoutName forElement:element];
    layout.actionType = [TBXML valueOfAttributeNamed:kActionType forElement:element];
    layout.fillDataKey =  [TBXML valueOfAttributeNamed:kFillDataKey forElement:element];
    //layout.style = [TBXML valueOfAttributeNamed:kStyle forElement:element];
    layout.imageSrc = [TBXML valueOfAttributeNamed:kImage forElement:element];
    if(layout.imageSrc)
    {
        layout.image = [UIImage imageNamed:layout.imageSrc];
    }
    //layout.contentMode =  [TBXML valueOfAttributeNamed:kContentMode forElement:element];
    layout.viewType = [TBXML valueOfAttributeNamed:kXType forElement:element];
    layout.pureText = [TBXML valueOfAttributeNamed:kPureText forElement:element];
    layout.label = [TBXML textForElement:element];
    layout.placeholder =[TBXML valueOfAttributeNamed:kPlaceholder forElement:element];
    layout.pressedImage = [TBXML valueOfAttributeNamed:kPressImage forElement:element];
    layout.loopMore = [TBXML valueOfAttributeNamed:kLoopMore forElement:element];
    if(layout.placeholder)
    {
        layout.placeHolderImage = [UIImage imageNamed:layout.placeholder];
    }
    if(layout.pressedImage)
    {
        layout.pressedImageSingle = [UIImage imageNamed:layout.pressedImage];
    }
    //NSLog(@"%@,%@,%@,%@,%@,%@,%@",layout.name,layout.actionType,layout.fillDataKey,layout.style,layout.imageSrc,layout.viewType,layout.label);
}
-(void) parseSubViews:(FloggerLayout*) currentView XMLElement:(TBXMLElement *)element StyleDict:(NSDictionary*)styleDict
{
    [self fillLayoutProperty:currentView XMLElement:element];
    TBXMLElement * eachFilterEl = [TBXML childElementNamed:@"div" parentElement:element];
    
    // if an element was found
    while (eachFilterEl != nil)
    {
        FloggerLayout *subview = [[[FloggerLayout alloc]init]autorelease];
        subview.parentView = currentView;
        [self parseSubViews:subview XMLElement:eachFilterEl StyleDict:styleDict];
        subview.style = [styleDict objectForKey:subview.name];
        [currentView.subviews addObject:subview]; 
        
        eachFilterEl = [TBXML nextSiblingNamed:@"div"  searchFromElement:eachFilterEl];
    }

}
-(NSMutableDictionary *) createStyle:(NSString*) stylePath
{
    static NSString * propertyList[] = {@"x",@"y",@"width",@"height",@"position",@"contentMode",@"hPadding",@"vPadding",@"hMargin",@"vMargin",@"border",@"color",@"backgroundColor",@"filter",@"font",@"sysfont" ,@"effect",@"textAlignment",@"userEnable",@"miny",@"animation",@"progressable",@"maxiumW",@"maxiumH",@"threePatches",@"outOfFlow",nil};
    // Load and parse the script xml file
    NSString *xml = [NSString stringWithContentsOfFile:stylePath encoding:NSUTF8StringEncoding error:nil];
    TBXML* tbxml = [[TBXML tbxmlWithXMLString:xml] retain];
    NSMutableDictionary *styleDict  = [[NSMutableDictionary alloc]init];
    // Obtain root element
    TBXMLElement * root = tbxml.rootXMLElement;
    // if root element is valid
    if (root) {
        TBXMLElement * eachFilterEl = [TBXML childElementNamed:@"element" parentElement:root];
        
        // if an element was found
        while (eachFilterEl != nil)
        {
            FloggerStyle *style = [[[FloggerStyle alloc]init]autorelease];
            NSString* name = [TBXML valueOfAttributeNamed:@"name" forElement:eachFilterEl];
//            NSLog(@"===name %@",name);
            style.name = name;
            for(int i=0;propertyList[i];i++)
            {
                TBXMLElement *property = [TBXML childElementNamed:propertyList[i] parentElement:eachFilterEl];
                if(property)
                {
                    NSString *val = [TBXML textForElement:property];
                    NSString *firstC = [[propertyList[i] substringToIndex:1]uppercaseString];
                    NSString *secondPart = [propertyList[i] substringFromIndex:1];
                    NSString* selString = [NSString stringWithFormat:@"setRaw%@%@:",firstC,secondPart];
//                    NSLog(@"%@====%@",selString,val);
                    SEL pSel = NSSelectorFromString(selString);
                    [style performSelector:pSel withObject:val];
                }
            }
            [style presetX];
            [style presetY];
            [style presetWidth];
            [style presetHeight];
            [style presetFont];
            [style presetColor];
            [style presetBackgroundColor];
            [style presetFilter];
            [style presetEffect];
            [style presetTextAlignment];
            [style presetUserEnable];
            [style presetMinY];
            [style presetMaxiumW];
            [style presetMaxiumH];
            [style presetAnimation];
            [style presetProgressable];
            [style presetOutOfFlow];
            [styleDict setObject:style forKey:name];
            eachFilterEl = [TBXML nextSiblingNamed:@"element"  searchFromElement:eachFilterEl];
        }
    }
    // release resources
    [tbxml release]; 
    return styleDict;
}
-(void) expandLoopMore:(FloggerLayout*) currentLayout NewLayout:(FloggerLayout*) newLayout index:(int)index
{
    //NSLog(@"=========%@",newLayout.name);
    for (FloggerLayout *subLayout in currentLayout.subviews) {
        NSArray *nameParts = [subLayout.name componentsSeparatedByString:SPLITOR_HYPHONE];
        if([nameParts count]< 2)
        {
            continue;
        }
        
        NSString *firstPart = [nameParts objectAtIndex:0];
        FloggerLayout *newSubLayout = [[subLayout createClone]autorelease];
        newSubLayout.name = [NSString stringWithFormat:@"%@%@%d",firstPart,SPLITOR_HYPHONE,index];
        
        
        NSArray *fillParts = [subLayout.fillDataKey componentsSeparatedByString:SPLITOR_HYPHONE];
        if([fillParts count]>1)
        {
            firstPart = [fillParts objectAtIndex:0];
            newSubLayout.fillDataKey = [NSString stringWithFormat:@"%@%@%d",firstPart,SPLITOR_HYPHONE,index];
        }
        [newLayout.subviews addObject:newSubLayout];
        newSubLayout.parentView = newLayout;
        
        [self expandLoopMore:subLayout NewLayout:newSubLayout index:index];
    }
}
-(void) gatherLoopInfor:(FloggerLayout *)rootLayout LoopList:(NSMutableArray *)loopList
{
    if(rootLayout.loopMore)
    {
        [loopList addObject:rootLayout];
    }
    for (FloggerLayout *currentLayout in rootLayout.subviews) {
        [self gatherLoopInfor:currentLayout LoopList:loopList];
    }
}
-(void) postProcess:(FloggerLayout *)rootLayout
{
    NSMutableArray *loopList = [[[NSMutableArray alloc]init]autorelease];
    [self gatherLoopInfor:rootLayout LoopList:loopList];
    for (FloggerLayout* currentLayout in loopList)
    {
        NSArray *nameParts = [currentLayout.name componentsSeparatedByString:SPLITOR_HYPHONE];
        NSString *firstPart = [nameParts objectAtIndex:0];
        int startIndex = [[nameParts objectAtIndex:1] intValue];
        int moreCount = [currentLayout.loopMore intValue]+startIndex;
        int post = [currentLayout.parentView.subviews indexOfObject:currentLayout];
        for(int i=1+startIndex; i <= moreCount;i++) 
        {
            
            FloggerLayout* newLayout = [[currentLayout createClone]autorelease];
            newLayout.name = [NSString stringWithFormat:@"%@%@%d",firstPart,SPLITOR_HYPHONE,i];
            [currentLayout.parentView.subviews insertObject:newLayout atIndex:++post];
            newLayout.parentView = currentLayout.parentView;
            [self expandLoopMore:currentLayout NewLayout:newLayout index:i];
        }

    }
}
-(FloggerLayout *) createLayout:(NSString*)layoutPath StylePath:(NSString*) stylePath
{
    NSMutableDictionary *style =[[self createStyle:stylePath]autorelease];
    // Load and parse the script xml file
    NSString *xml = [NSString stringWithContentsOfFile:layoutPath encoding:NSUTF8StringEncoding error:nil];
    TBXML* tbxml = [[TBXML tbxmlWithXMLString:xml] retain];
    FloggerLayout *rootLayout = [[FloggerLayout alloc]init];
    // Obtain root element
    TBXMLElement * root = tbxml.rootXMLElement;
    // if root element is valid
    if (root) {
        [self parseSubViews:rootLayout XMLElement:root StyleDict:style];
    }
    rootLayout.name = @"main";
    rootLayout.style = [style objectForKey:@"main"];
//    NSLog(@"root infor:%@,%@,%@",rootLayout.style.name, rootLayout.style.rawHMargin,rootLayout.style.rawVMargin);
    // release resources
    [self postProcess:rootLayout];
    [tbxml release]; 
    return rootLayout;
}
-(FloggerViewAdpater*) createViewSet:(FloggerLayout*)currentLayout ParentAapter:(FloggerViewAdpater*)parent ActionHandler:(id<FloggerActionHandler>)actionHandler;
{
    FloggerViewAdpater *adapter = [[FloggerViewAdpater alloc]init];
    adapter.layout = currentLayout;
    adapter.subviews = [[[NSMutableArray alloc]init]autorelease];
    adapter.parentView = parent;
    adapter.name = currentLayout.name;
    //NSLog(@"===========name:%@  --------- %@" ,adapter.name,parent.name);
    //img
    //html
    if([adapter.layout.viewType isEqualToString:@"btn"])
    {
        FloggerButtonView *imageView = [[[FloggerButtonView alloc]init]autorelease];
        //UIImageView *imageView = [[[UIImageView alloc]init]autorelease];
        //imageView.urlPath = adapter.layout.imageSrc;
        //imageView.image = adapter.layout.image;
        [imageView setImage:adapter.layout.image forState:UIControlStateNormal];
        imageView.userInteractionEnabled = adapter.layout.style.userEnable;
        adapter.view = imageView;
        // ==================
        //TTStyle *imgStyle = [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
        //  [TTSolidBorderStyle styleWithColor:[UIColor redColor] width:1 next:nil]];
        //[imageView setStyle:imgStyle];
        // ==================
        imageView.backgroundColor = [UIColor clearColor];
        
        imageView.effect = adapter.layout.style.effect;
    } else if([adapter.layout.viewType isEqualToString:@"img"])
    {
        FloggerImageView *imageView = [[[FloggerImageView alloc]init]autorelease];
        //UIImageView *imageView = [[[UIImageView alloc]init]autorelease];
        //imageView.urlPath = adapter.layout.imageSrc;
        imageView.image = adapter.layout.image;
        imageView.userInteractionEnabled = adapter.layout.style.userEnable;
        imageView.progressable = adapter.layout.style.progressable;
        imageView.applyAnimation = adapter.layout.style.animation;
        adapter.view = imageView;
        // ==================
        //TTStyle *imgStyle = [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
        //  [TTSolidBorderStyle styleWithColor:[UIColor redColor] width:1 next:nil]];
        //[imageView setStyle:imgStyle];
        // ==================
        imageView.backgroundColor = [UIColor clearColor];
        
        imageView.effect = adapter.layout.style.effect;
    } else if([adapter.layout.viewType isEqualToString:@"html"]){
        // placeholder frame
        CGRect frame = CGRectMake(0, 0, [currentLayout.style width], 2);
        TTStyledTextLabel *htmlLable = [[[TTStyledTextLabel alloc]initWithFrame:frame]autorelease];
        htmlLable.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];//[UIColor blackColor];
        htmlLable.highlightedTextColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
        htmlLable.backgroundColor = [UIColor clearColor];
        if([@"1" isEqualToString:currentLayout.pureText] || [@"yes" isEqualToString:currentLayout.pureText])
        {
            htmlLable.pureTextNode = YES;
        }
        adapter.view = htmlLable; 
    } else if([adapter.layout.viewType isEqualToString:@"label"])
    {
        FloggerLabel *container = [[[FloggerLabel alloc] init]autorelease];
        container.text = NSLocalizedString(adapter.layout.label,@"");
        //if()
        container.textColor = adapter.layout.style.color;
        adapter.view = container;  
        container.userInteractionEnabled = adapter.layout.style.userEnable;
        container.backgroundColor = [UIColor clearColor];
        container.font = adapter.layout.style.font;
        container.textAlignment = adapter.layout.style.textAlignment;
        container.effect = adapter.layout.style.effect;
    } else if([adapter.layout.viewType isEqualToString:@"scroll"])
    {
        UIScrollView *container = [[[UIScrollView alloc] init]autorelease];
        adapter.view = container;  
        container.userInteractionEnabled = adapter.layout.style.userEnable;
        container.backgroundColor = [UIColor clearColor];
        //container.effect = adapter.layout.style.effect;
    }
    else if([adapter.layout.viewType isEqualToString:@"9patch"])
    {
        TTLabel *container = [[[TTLabel alloc] initWithText:@""]autorelease];
        container.text = NSLocalizedString(adapter.layout.label,@"");
        //if()
        container.userInteractionEnabled = adapter.layout.style.userEnable;
        container.textColor = adapter.layout.style.color;
        adapter.view = container;
        container.backgroundColor = [UIColor clearColor];
        container.font = adapter.layout.style.font;
        container.textAlignment = adapter.layout.style.textAlignment;
        container.ninePatch = YES;
    }
    else
    {
        TTLabel *container = [[[TTLabel alloc] initWithText:@""]autorelease];
        container.text = NSLocalizedString(adapter.layout.label,@"");
        //if()
        container.userInteractionEnabled = adapter.layout.style.userEnable;
        container.textColor = adapter.layout.style.color;
        adapter.view = container;
        container.backgroundColor = [UIColor clearColor];
        container.font = adapter.layout.style.font;
        container.threePatches = adapter.layout.style.rawThreePatches;
        container.textAlignment = adapter.layout.style.textAlignment;
    }
    if(adapter.layout.placeholder)
    {
        /*UIImage *img = [UIImage imageNamed:adapter.layout.placeholder];
        if(!img)
        {
            img = [UIImage imageWithContentsOfFile:adapter.layout.placeholder];
        }
        ((TTImageView *)adapter.view).defaultImage = img;*/
        //((TTImageView *)adapter.view).defaultImage = adapter.layout.placeHolderImage;
        //((FloggerImageView *)adapter.view).defaultImage = adapter.layout.placeHolderImage;
        if([adapter.view respondsToSelector:@selector(setDefaultImage:)])
        {
            [adapter.view performSelector:@selector(setDefaultImage:) withObject:adapter.layout.placeHolderImage];
        }
        
    }
    if(adapter.layout.pressedImage)
    {
        if([adapter.view isKindOfClass:[FloggerButtonView class]])
        {
            [((FloggerButtonView*)adapter.view) setImage:adapter.layout.pressedImageSingle forState:UIControlStateHighlighted];
        }
    }
    if(adapter.layout.style.rawFilter)
    {
        // it is a stupid way to implement it.
        ((TTView *)adapter.view).style = adapter.layout.style.filter;
        
    }
    if(adapter.layout.style.backgroundColor)
    {
        adapter.view.backgroundColor = adapter.layout.style.backgroundColor;
    }
    //((TTView*)adapter.view).actionDelegate = adapter;
    if([adapter.view respondsToSelector:@selector(setActionDelegate:)])
    {
        [adapter.view performSelector:@selector(setActionDelegate:) withObject:adapter];
    }
    //((TTView*)adapter.view).clipsToBounds = YES;
    //((TTView*)adapter.view).opaque = YES;
    adapter.actionDeletgate = actionHandler;
    if(adapter.layout.style.rawBorder)
    {
        NSArray* coms = [adapter.layout.style.rawBorder componentsSeparatedByString:@" "];
        GLfloat bw = [(NSString*)[coms objectAtIndex:0]floatValue];
        /*int r = [(NSString*)[coms objectAtIndex:1]intValue];
        int g = [(NSString*)[coms objectAtIndex:2]intValue];
        int b = [(NSString*)[coms objectAtIndex:3]intValue];
        int a = [coms count]>=5?[(NSString*)[coms objectAtIndex:4]intValue]:255;*/
        UIColor *color = [UIColor colorWithHexString:[coms objectAtIndex:1]];
        
        TTStyle *imgStyle = [TTSolidBorderStyle styleWithColor:color width:bw next:nil];
        ((TTView*)adapter.view).style = imgStyle;
    }
    for (FloggerLayout* subview in currentLayout.subviews) {
        [adapter.subviews addObject:[[self createViewSet:subview ParentAapter:adapter ActionHandler:actionHandler]autorelease]];
    }
    adapter.view.contentScaleFactor = [[UIScreen mainScreen] scale];
    return adapter;
}

- (CGRect)fillAndLayoutSubviews:(FloggerViewAdpater*) currentView ViewDisplayParameters:(NSDictionary*)displayParameter DataFillParameters:(NSDictionary *)data InvisibleViews:(NSDictionary*)invisibleViews
{
    if([invisibleViews objectForKey:currentView.name])
    {
        [currentView.view removeFromSuperview];
        return CGRectZero;
    }
    GLfloat x = currentView.layout.style.x;
    GLfloat y = currentView.layout.style.y;
    GLfloat w = currentView.layout.style.width;
    GLfloat h = currentView.layout.style.height;
    currentView.view.userInteractionEnabled = currentView.layout.style.userEnable;
    //NSLog(@"-----%d",currentView.layout.style.userEnable);
    FloggerLayoutParam* layoutParam = [displayParameter objectForKey:currentView.name];
    currentView.actionType = nil;
    if(currentView.layout.image)
    {
        //((FloggerImageView *)currentView.view).image =currentView.layout.image;
        /*if([currentView.view isKindOfClass:FloggerImageView.class])
        {
            ((FloggerImageView *)currentView.view).image =currentView.layout.image; 
        } else
        */
        {
            if([currentView.view respondsToSelector:@selector(setImage:)])
            {
                [currentView.view performSelector:@selector(setImage:) withObject:currentView.layout.image];
            }
        }
    }
    /*if([currentView.view isKindOfClass:[UIScrollView class]])
    {
        int i = 0;
    }*/
    if(layoutParam)
    {
        if(layoutParam.width) w = layoutParam.width;
        if(layoutParam.height) h = layoutParam.height;
        /*if(layoutParam.imgSrc)
        {
            dispatch_async(dispatch_get_main_queue(), 
                           ^{
            ((TTImageView *)currentView.view).urlPath = layoutParam.imgSrc;
                           });
        }*/
        if(layoutParam.image)
        {
            /*if([currentView.view isKindOfClass:FloggerImageView.class])
            {
                ((FloggerImageView *)currentView.view).image = layoutParam.image;
            } else 
             */
            {
                if([currentView.view respondsToSelector:@selector(setImage:)])
                {
                    //NSLog(@"mmd%@",currentView.view.class);
                    [currentView.view performSelector:@selector(setImage:) withObject:layoutParam.image];
                }
            }
        }
        //修改button按下状态后的图片
        if(layoutParam.pressedImage)
        {
            {
                if([currentView.view respondsToSelector:@selector(setImage:)])
                {
                    [currentView.view performSelector:@selector(setImage:forState:) withObject:layoutParam.pressedImage withObject:UIControlStateHighlighted];
                }
            }
        }
        // NSString *test = layoutParam.actionType;
        // NSString *name = currentView.name;
        if(layoutParam.actionType)
        {
            currentView.actionType = layoutParam.actionType;
        }
        if([USER_INTERACTION_DISABLED isEqualToString:layoutParam.userEnabled])
        {
            currentView.view.userInteractionEnabled = NO;
        }
    }
    // ============
    //==========
    //TODO center
    if(currentView.layout.fillDataKey)
    {
        if([currentView.view isKindOfClass:[TTStyledTextLabel class]])
        {
            NSString *htmlText = [data objectForKey:currentView.layout.fillDataKey];
            if(!htmlText)
            {
                ((TTStyledTextLabel*)currentView.view).text = nil;//htmlText =@"";
            } else {
                ((TTStyledTextLabel*)currentView.view).text  = [TTStyledText textFromXHTML:htmlText lineBreaks:YES URLs:YES];
            }
        }
        else if([currentView.view respondsToSelector:@selector(setText:)])
        {
            id obj = [data objectForKey:currentView.layout.fillDataKey];
            if([obj isKindOfClass:[NSString class]])
            {
                [currentView.view performSelector:@selector(setText:) withObject:obj];//((TTLabel*)currentView.view).text = obj;
            } else 
            {
                [currentView.view performSelector:@selector(setText:) withObject:[obj stringValue]];
                //((TTLabel*)currentView.view).text = [obj stringValue];
            }
            //NSLog(@"key===%@, value==%@", currentView.layout.fillDataKey, [data objectForKey:currentView.layout.fillDataKey]);
        }
    }
    BOOL reCaculateCenterX = NO, reCaculateCenterY = NO;
    if([currentView.layout.style.rawX hasPrefix:@"center"] || [currentView.layout.style.rawY hasPrefix:@"center"])
    {
        CGSize size = [currentView.view sizeThatFits:CGSizeMake(w==AUTO_DIMENTION?0:w, h==AUTO_DIMENTION?0:h)];
        if(w==AUTO_DIMENTION||!w)
        {
            w = size.width;
        }
        if(h==AUTO_DIMENTION||!h)
        {
            h = size.height;
        }
        if([currentView.layout.style.rawX hasPrefix:@"center"])
        {
            if(w>0)
            {
                x = ((currentView.parentView.layout.style.width>0?currentView.parentView.layout.style.width:currentView.parentView.view.frame.size.width) - w)/2 - [currentView.parentView.layout.style.rawHPadding floatValue];
                if(x<0)
                {
                    x=0;
                }
                x+=currentView.layout.style.adjustX;
            } else {
                reCaculateCenterX = YES; 
            }
        }
        
        if([currentView.layout.style.rawY hasPrefix:@"center"])
        {
            if(h>0)
            {
                
                y = ((currentView.parentView.layout.style.height>0?currentView.parentView.layout.style.height:currentView.parentView.view.frame.size.height) - h)/2 - [currentView.parentView.layout.style.rawVPadding floatValue];
                
                if(y<0)
                {
                    y=0;
                }
                y+=currentView.layout.style.adjustY;
            } else{
                reCaculateCenterY = YES;            
            }
        }
    }
    if([currentView.layout.style.rawPosition isEqualToString:@"center"])
    {
        if(w == AUTO_DIMENTION)
        {
            CGSize size = [currentView.view sizeThatFits:CGSizeMake(w==AUTO_DIMENTION?0:w, h==AUTO_DIMENTION?0:h)];
            w = size.width;
        }
        if(h == AUTO_DIMENTION)
        {
            CGSize size = [currentView.view sizeThatFits:CGSizeMake(w==AUTO_DIMENTION?0:w, h==AUTO_DIMENTION?0:h)];
            h = size.height;
        }
        if(w>0)
        {
            x = ((currentView.parentView.layout.style.width>0?currentView.parentView.layout.style.width:currentView.parentView.view.frame.size.width) - w)/2 - [currentView.parentView.layout.style.rawHPadding floatValue];
            if(x<0)
            {
                x=0;
            }
        }else {
            reCaculateCenterX = YES; 
        }
        //x = (currentView.parentView.view.frame.size.width - w)/2 - [currentView.parentView.layout.style.rawHPadding floatValue];
        //y = (currentView.parentView.view.frame.size.height - h)/2 - [currentView.parentView.layout.style.rawVPadding floatValue];
        if(h>0)
        {
            y = ((currentView.parentView.layout.style.height>0?currentView.parentView.layout.style.height:currentView.parentView.view.frame.size.height) - h)/2 - [currentView.parentView.layout.style.rawVPadding floatValue];
            
            if(y<0)
            {
                y=0;
            }
        }else {
            reCaculateCenterY = YES; 
        }
    }
    FloggerViewAdpater * preView = [currentView getPreviousSibling:invisibleViews];
    if(x==AUTO_DIMENTION)
    {
        if(preView)
        {
            x = preView.view.frame.origin.x + preView.view.frame.size.width +[preView.layout.style.rawHPadding floatValue] + currentView.layout.style.adjustX;
        } else 
        {
            x = [preView.layout.style.rawHPadding floatValue] + currentView.layout.style.adjustX;
        }
    }
    if(y==AUTO_DIMENTION)
    {
        if(preView)
        {
            //NSLog(@"------%f,%f,%f,%f",preView.view.frame.origin.y,preView.view.frame.size.height,[preView.layout.style.rawVPadding floatValue],currentView.layout.style.adjustY);
            y = preView.view.frame.origin.y + preView.view.frame.size.height +[preView.layout.style.rawVPadding floatValue] + currentView.layout.style.adjustY;
        } else {
            y = [preView.layout.style.rawVPadding floatValue] + currentView.layout.style.adjustY;
        }
    }

    GLfloat maxWidth = 0;
    GLfloat maxHeight = 0;
    if(x!=AUTO_DIMENTION&&y!=AUTO_DIMENTION&&w!=AUTO_DIMENTION&&h!=AUTO_DIMENTION)
    {
        currentView.view.frame = CGRectMake(x+[currentView.parentView.layout.style.rawHPadding floatValue], y+[currentView.parentView.layout.style.rawVPadding floatValue], w, h);
    }/* else {
        // 
        currentView.view.frame = CGRectMake(x<0?0:x+[currentView.parentView.layout.style.rawHPadding floatValue], y<0?0:y+[currentView.parentView.layout.style.rawVPadding floatValue], w<0, h);
    }*/
    for (FloggerViewAdpater *subAdapter in currentView.subviews) {
        if([invisibleViews objectForKey:subAdapter.name])
        {
            [subAdapter.view removeFromSuperview];
            continue;
        }
        CGRect rect = [self fillAndLayoutSubviews:subAdapter ViewDisplayParameters:displayParameter DataFillParameters:data InvisibleViews:invisibleViews];
        [currentView.view addSubview:subAdapter.view];
        if(subAdapter.layout.style.outOfFlow)
        {
            continue;
        }
        maxWidth = MAX(rect.origin.x + rect.size.width,maxWidth);
        maxHeight = MAX(rect.origin.y + rect.size.height , maxHeight);
    }
    if(w == AUTO_DIMENTION || w == 0)
    {
        CGSize inferSize = [currentView.view sizeThatFits:CGSizeZero];
       if(maxWidth)
       {
           w = maxWidth;
       } else {
           w = [currentView.view sizeThatFits:CGSizeMake(0, h==AUTO_DIMENTION?0:h)].width;
       }
        if(w<inferSize.width)
        {
            w = inferSize.width;
        }
         w+=[currentView.layout.style.rawHMargin floatValue];
    }
    if(h == AUTO_DIMENTION || h == 0 )
    {
        CGSize inferSize = [currentView.view sizeThatFits:CGSizeZero];
        if(maxHeight)
        {
            h = maxHeight;
        } else {
            h = [currentView.view sizeThatFits:CGSizeMake(0, w)].height;
        }
        if(h<inferSize.height)
        {
            h = inferSize.height;
        }
        h+=[currentView.layout.style.rawVMargin floatValue];
    }
    if(w < maxWidth)
    {
        w = maxWidth;
    }
    if(h < maxHeight)
    {
        h = maxHeight;
    }
    if(reCaculateCenterX)
    {
        x = ((currentView.parentView.layout.style.width>0?currentView.parentView.layout.style.width:currentView.parentView.view.frame.size.width) - w)/2 - [currentView.parentView.layout.style.rawHPadding floatValue];
        if(x<0)
        {
            x=0;
        }
        x+=currentView.layout.style.adjustX;
    }
    if(reCaculateCenterY)
    {
        y = ((currentView.parentView.layout.style.height>0?currentView.parentView.layout.style.height:currentView.parentView.view.frame.size.height) - h)/2 - [currentView.parentView.layout.style.rawVPadding floatValue];
        
        if(y<0)
        {
            y=0;
        }
        y+=currentView.layout.style.adjustY;
    }
    if(currentView.layout.style.minY&&currentView.layout.style.minY>y)
    {
        y = currentView.layout.style.minY;
    }

    if(currentView.layout.style.maxiumW&&currentView.layout.style.maxiumW<w)
    {
        w = currentView.layout.style.maxiumW;
    }
    if(currentView.layout.style.maxiumH&&currentView.layout.style.maxiumH<h)
    {
        h = currentView.layout.style.maxiumH;
    }
    
    if([currentView.layout.style.rawX hasPrefix:@"right"] || [currentView.layout.style.rawY hasPrefix:@"bottom"])
    {
        if([currentView.layout.style.rawX hasPrefix:@"right"])
        {
            x = ((currentView.parentView.layout.style.width>0?currentView.parentView.layout.style.width:currentView.parentView.view.frame.size.width) - w) - [currentView.parentView.layout.style.rawHPadding floatValue];
            if(x<0)
            {
                x=0;
            }
            x+=currentView.layout.style.adjustX;
        }
        
        if([currentView.layout.style.rawY hasPrefix:@"bottom"])
        {
            
            y = ((currentView.parentView.layout.style.height>0?currentView.parentView.layout.style.height:currentView.parentView.view.frame.size.height) - h) - [currentView.parentView.layout.style.rawVPadding floatValue];
            
            if(y<0)
            {
                y=0;
            }
            y+=currentView.layout.style.adjustY;
        }
    }
    //NSLog(@"name:%@,%@, %@", currentView.name,currentView.parentView.name, currentView.parentView.layout.style.rawHMargin);
    currentView.view.frame = CGRectMake(x+[currentView.parentView.layout.style.rawHPadding floatValue], y+[currentView.parentView.layout.style.rawVPadding floatValue], w, h);
    return currentView.view.frame;
}

@end
