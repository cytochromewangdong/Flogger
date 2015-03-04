//
//  FloggerButtonView.m
//  Flogger
//
//  Created by wyf on 12-5-16.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerButtonView.h"

@interface FloggerButtonView ()

@end

@implementation FloggerButtonView
@synthesize actionDelegate,effect=_effect,defaultImage,data,action,applyAnimation;
@dynamic image;
-(void) myClick:(id)sender
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc]init]autorelease];
    if(self.data)
    {
        [dict setObject:self.data forKey:K_EVENT_DATA];
    }
    if(self.action)
    {
        [dict setObject:self.action  forKey:K_EVENT_ACTION];
    }
    if([actionDelegate handleTap:dict])
    {
        return;
    }
}
- (id) init
{
    self = [super init];
    if(self)
    {
        [self addTarget:self action:@selector(myClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

-(void) setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}
-(UIImage*) image
{
    return [self imageForState:UIControlStateNormal];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    UIImage *currentImage = [[SDImageCache sharedImageCache] imageFromKey:[url absoluteString]];
    if(!currentImage)
    {
        [super setBackgroundColor:_backColor];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        // Remove in progress downloader from queue
        [manager cancelForDelegate:self];
        _oldMode = self.contentMode;
        //[self.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES]];
        for (UIView *view in self.subviews) {
            view.hidden = YES;
        }
        self.contentMode = UIViewContentModeCenter;
        //self.image = placeholder;
        [self setImage:placeholder forState:UIControlStateNormal];
        if (url)
        {
            [manager downloadWithURL:url delegate:self];
        }
    } else {
        [super setBackgroundColor:[UIColor clearColor]];
        [self webImageManager:nil didFinishWithImage:currentImage Animation:NO];
    }
}
-(void) setBackgroundColor:(UIColor *)backgroundColor
{
    RELEASE_SAFELY(_backColor);
    _backColor = [backgroundColor retain];
    [super setBackgroundColor:_backColor];
}
-(UIColor*) backgroundColor
{
    return _backColor;
}
- (void)cancelCurrentImageLoad
{
    self.contentMode = UIViewContentModeScaleAspectFill;//_oldMode;
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image  Animation:(BOOL)animation
{
    for (UIView *view in self.subviews) {
        view.hidden = NO;
    }
    //[self.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    self.contentMode = UIViewContentModeScaleAspectFill;//_oldMode;
    //[self setBackgroundImage:image forState:UIControlStateNormal];
    //[self setImage:image forState:UIControlStateNormal];
    if(animation)
    {
        self.alpha = 0.0;
        [UIView beginAnimations:nil context:nil];
    }
    //
    [self setImage:image forState:UIControlStateNormal];
    //[UIView setAnimationDuration:0.5];
    if(animation)
    {
        self.alpha = 1.0;
        [UIView commitAnimations];
    }
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self webImageManager:imageManager didFinishWithImage:image Animation:self.applyAnimation];
}
/*- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    if([touches count]==1)
    {
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc]init]autorelease];
        if(self.data)
        {
            [dict setObject:self.data forKey:K_EVENT_DATA];
        }
        if(self.action)
        {
            [dict setObject:self.action  forKey:K_EVENT_ACTION];
        }
        if([actionDelegate handleTap:dict])
        {
            [super touchesEnded:touches withEvent:event];
            return;
        }
    }
    // We definitely don't want to call this if the label is inside a TTTableView, because
    // it winds up calling touchesEnded on the table twice, triggering the link twice
    [super touchesEnded:touches withEvent:event];
}*/
-(void) setEffect:(TTImageEffect *)effect
{
    RELEASE_SAFELY(_effect);
    _effect = [effect retain];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if(_effect)
    {
        if(_effect.borderWidth)
        {
            self.layer.borderColor = [_effect.borderColor CGColor];
            self.layer.borderWidth = _effect.borderWidth; 
        }
        if(_effect.cornerRadius)
        {
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = _effect.cornerRadius;
            self.layer.borderColor = [_effect.borderColor CGColor];
            self.layer.borderWidth = _effect.borderWidth;
        } else {
            self.layer.masksToBounds = NO;
            self.layer.borderColor = [_effect.borderColor CGColor];
            self.layer.borderWidth = _effect.borderWidth;
            self.layer.shadowColor = [_effect.shadowColor CGColor];
            self.layer.shadowOffset = _effect.shadowOffset;
            self.layer.shadowRadius = _effect.shadowRadius;
            self.layer.shadowOpacity = _effect.shadowOpacity;
            self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
        }
    }
    
}
-(void) dealloc
{
    self.actionDelegate = nil;
    //self.effect = nil;
    self.defaultImage = nil;
    self.action = nil;
    RELEASE_SAFELY(_effect);
    RELEASE_SAFELY(_backColor);
    [super dealloc];
}
@end
