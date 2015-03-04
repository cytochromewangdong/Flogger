//
//  FloggerImageView.m
//  Flogger
//
//  Created by dong wang on 12-5-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerImageView.h"
#import "TKProgressBarView.h"
#define TAG_PROGRESS 301
@implementation FloggerImageView
@synthesize actionDelegate,effect=_effect,defaultImage,data,action,applyAnimation,progressable;
- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
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
            if(view.tag == TAG_PROGRESS)
            {
                continue;
            }
            view.hidden = YES;
        }
        //self.progressable = YES;
        if(self.progressable)
        {
            TKProgressBarView *progressBar = (TKProgressBarView *)[self viewWithTag:TAG_PROGRESS];
            [progressBar removeFromSuperview];
            if(!progressBar)
            {
                progressBar = [[[TKProgressBarView alloc]initWithStyle:TKProgressBarViewStyleLong]autorelease];
                CGSize mySize = self.frame.size;
                progressBar.tag = TAG_PROGRESS;
                progressBar.frame = CGRectMake(mySize.width * 0.1, mySize.height * 0.65, mySize.width * 0.8, 12);
                [self addSubview:progressBar];
            }
            //progressBar.progress = 1.0;
            
            [progressBar setProgress:1.0 animated:YES];
            [self setNeedsDisplay];
        }
        //self.savedSubviews = [NSArray arrayWithArray:self.subviews];
        //self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)
        //[self.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
        self.contentMode = UIViewContentModeCenter;
        self.image = placeholder;
        
        if (url)
        {
            [manager downloadWithURL:url delegate:self retryFailed:YES];
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
    [super setBackgroundColor:backgroundColor];
}
-(UIColor*) backgroundColor
{
    return _backColor;
}
- (void)cancelCurrentImageLoad
{
    self.contentMode = UIViewContentModeScaleAspectFit;//_oldMode;
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image  Animation:(BOOL)animation
{
    if(self.progressable)
    {
        TKProgressBarView *progressBar = (TKProgressBarView *)[self viewWithTag:TAG_PROGRESS];
        //progressBar.progress = 1.0;
        [progressBar stop];
        [progressBar setNeedsDisplay];
        [progressBar removeFromSuperview];
        //[progressBar performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.01];
    } else {
       // [[self viewWithTag:TAG_PROGRESS] removeFromSuperview];
    }
    //dispatch_async(dispatch_get_main_queue(), ^{
    
        for (UIView *view in self.subviews) {
            view.hidden = NO;
        }
        //[self.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
        self.contentMode = UIViewContentModeScaleAspectFit;//_oldMode;
        
        if(animation)
        {
            self.alpha = 0.0;
            [UIView beginAnimations:nil context:nil];
        }
        //
        self.image = image;
        //[UIView setAnimationDuration:0.5];
        if(animation)
        {
            self.alpha = 1.0;
            [UIView commitAnimations];
        }
    //});
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    //[GlobalUtils showAlert:@"fail" message:@"fail"];
    if(self.progressable)
    {
        TKProgressBarView *progressBar = (TKProgressBarView *)[self viewWithTag:TAG_PROGRESS];
        [progressBar fail];
    }
    
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self webImageManager:imageManager didFinishWithImage:image Animation:self.applyAnimation];
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
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
            return;
        }
    }
    // We definitely don't want to call this if the label is inside a TTTableView, because
    // it winds up calling touchesEnded on the table twice, triggering the link twice
    [super touchesEnded:touches withEvent:event];
}
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
            //self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
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
    self.data = nil;
    [super dealloc];
}
@end
