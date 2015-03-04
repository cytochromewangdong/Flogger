//
//  ExternalShareView.m
//  Flogger
//
//  Created by jwchen on 12-2-25.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ExternalShareView.h"
#import "Externalplatform.h"

@implementation ExternalShareView
@synthesize platformArray = _platformArray, delegate;

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

-(void)btnClicked:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(externalShareView:didSelectedAtIndex:)]) {
        [self.delegate externalShareView:self didSelectedAtIndex:sender.tag];
    }
}

/*-(void)setPlatformArray:(NSArray *)platformArray
{
    if (_platformArray != platformArray) {
        [_platformArray release];
        _platformArray = [platformArray retain];
    }
    
    
    CGFloat x = 10;
    CGFloat y = 10;
    
    NSInteger index = 1;
    
    for (Externalplatform *platform in self.platformArray) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImageWithURL:[NSURL URLWithString: platform.midbutton]];
//        btn.frame = CGRectMake(x, y, 145, 38);
        btn.frame = CGRectMake(x, y, 143, 34);
        UIEdgeInsets titleInset = UIEdgeInsetsMake(0, 33, 0, 0);        
        btn.titleEdgeInsets = titleInset;
        [btn setTitle:platform.name forState:UIControlStateNormal];
        btn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleBoldFont];
        btn.titleLabel.textAlignment = UITextAlignmentCenter;
//        btn.titleLabel.shadowOffset
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setTitle:platform.name forState:UIControlStateNormal];
        btn.tag = index - 1;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (index % 2 != 0) {
            x += 155;
        }
        
        else
        {
            x = 10;
            y += 34+10;
        }
        
        index ++;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, y + 34 + 10);
    [self setNeedsLayout];
}*/


-(void)setPlatformArray:(NSArray *)platformArray
{
    if (_platformArray != platformArray) {
        [_platformArray release];
        _platformArray = [platformArray retain];
    }
        
    CGFloat x = 34;
    CGFloat y = 10;
    
    CGFloat imageWidth = 61;
    CGFloat imageHeight = 61;
    
    CGFloat widthPading = 34;
    CGFloat heightPading = 36;
    
    CGFloat titleWidth = 80;
    CGFloat titleHeight = 20;
    CGFloat titleHeigthtPading = 5;
    
    UIColor *fontColor = [[FloggerUIFactory uiFactory] createLoginFontColor];
    
    NSInteger index = 1;
    
    for (Externalplatform *platform in self.platformArray) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImageWithURL:[NSURL URLWithString: platform.midbutton]];
        btn.frame = CGRectMake(x, y, imageWidth, imageHeight);
//        UIEdgeInsets titleInset = UIEdgeInsetsMake(imageWidth + 10, 0, 0, 0);        
//        btn.titleEdgeInsets = titleInset;
//        [btn setTitle:platform.name forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//        btn.titleLabel.textAlignment = UITextAlignmentCenter;
//        [btn setTitleColor:fontColor forState:UIControlStateNormal];
        UILabel *titleLable = [[FloggerUIFactory uiFactory] createLable];
        titleLable.frame = CGRectMake(x + imageWidth/2 - titleWidth/2, y + imageHeight + titleHeigthtPading , titleWidth, titleHeight);
        titleLable.font = [UIFont boldSystemFontOfSize:12];
        titleLable.textAlignment = UITextAlignmentCenter;
        titleLable.shadowOffset = CGSizeMake(0, 1);
        titleLable.shadowColor = [UIColor whiteColor];
        titleLable.textColor = fontColor;
        titleLable.text = platform.name;
        
        
        btn.tag = index - 1;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self addSubview:titleLable];
        
        if (index % 3 != 0) {
//            int mod = index % 3;
            x += imageWidth + widthPading;
        }        
        else
        {
            x = 34;
            y += imageHeight + heightPading;
        }
        
        index ++;
    }
    //folo
    UIImage *foloImage = [UIImage imageNamed:SNS_SNS_FOLO];
    UIButton *btn = [[FloggerUIFactory uiFactory] createButton:foloImage];
    btn.frame = CGRectMake(x, y, imageWidth, imageHeight);
    btn.tag = index - 1;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLable = [[FloggerUIFactory uiFactory] createLable];
    titleLable.frame = CGRectMake(x + imageWidth/2 - titleWidth/2, y + imageHeight + titleHeigthtPading , titleWidth, titleHeight);
    titleLable.font = [UIFont boldSystemFontOfSize:12];
    titleLable.textAlignment = UITextAlignmentCenter;
    titleLable.textColor = fontColor;
    titleLable.text = NSLocalizedString(@"Folo", @"Folo");
    titleLable.shadowOffset = CGSizeMake(0, 1);
    titleLable.shadowColor = [UIColor whiteColor];
    [self addSubview:btn];
    [self addSubview:titleLable];
    
    [self setNeedsLayout];
}

//-(void)

-(void)dealloc
{
    self.platformArray = nil;
    [super dealloc];
}

@end
