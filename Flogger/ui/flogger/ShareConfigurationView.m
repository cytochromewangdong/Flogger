//
//  ShareConfigurationView.m
//  Flogger
//
//  Created by jwchen on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ShareConfigurationView.h"
#import "Externalplatform.h"
#import "Externalaccount.h"
#import "GlobalData.h"
#import "SingleShareView.h"


@implementation ShareConfigurationView
@synthesize platformArray, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc
{
    self.platformArray = nil;
    [super dealloc];
}

-(Externalaccount *)getExternalAccount:(Externalplatform *)platform
{
    for (Externalaccount *eaccount in [GlobalData sharedInstance].myAccount.externalaccounts) {
        if ([eaccount.usersource intValue] == [platform.id intValue]) {
            return eaccount;
        }
    }
    return nil;
}

#define kVGap 10
#define kHMargin 10
#define kImageHeight 50

#define kExternalAccount @"kExternalAccount"
-(void)setPlatformArray:(NSArray *)pArray
{
    if (_platformArray != pArray) {
        [_platformArray release];
        _platformArray = [pArray retain];
    }
    
    CGFloat x = kHMargin;
    CGFloat y = kVGap;
    CGFloat width = self.frame.size.width - (2 * kHMargin);
    CGFloat height = kImageHeight;
    
    NSInteger index = 0;
    
    for (Externalplatform *platform in pArray) {
        SingleShareView *shareView = [[[SingleShareView alloc] initWithFrameShare:CGRectMake(x, y, width, height) platform:platform account:[self getExternalAccount:platform]] autorelease];
        shareView.delegate = self;
        [self addSubview:shareView];
        shareView.tag = index;
        index ++;
        
        y += kImageHeight + kVGap;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, y);
    [self setNeedsLayout];
    
}

-(void)singleShareView:(SingleShareView *)singleShareView platform:(Externalplatform *)platform
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareConfigurationView:platform:)]) {
        [self.delegate shareConfigurationView:self platform:platform];
    }
}

@end
