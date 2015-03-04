//
//  FloggerLabel.m
//  Flogger
//
//  Created by dong wang on 12-5-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerLabel.h"

@implementation FloggerLabel
@synthesize actionDelegate,effect=_effect,data,action;
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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
            //self.layer.borderColor = [_effect.borderColor CGColor];
            //self.layer.borderWidth = _effect.borderWidth;
            self.shadowColor = _effect.shadowColor; 
            //self.layer.shadowColor = [_effect.shadowColor CGColor];
            self.shadowOffset = _effect.shadowOffset;
            //self.layer.shadowRadius = _effect.shadowRadius;
            //self.layer.shadowOpacity = _effect.shadowOpacity;
            //self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
        }
    }
}
-(void) dealloc
{
    self.actionDelegate = nil;
    self.data = nil;
    self.action = nil;
    RELEASE_SAFELY(_effect);
    [super dealloc];
}
@end
