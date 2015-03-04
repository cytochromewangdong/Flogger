//
//  GridTableViewCell.m
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "GridTableViewCell.h"
#define kBtnTag 100

@implementation GridTableViewCell
@synthesize imageView1, imageView2, imageView3, imageView4, imageView1P, imageView2P, imageView3P, imageView4P, delegate;
@synthesize imageCount;

-(void)setup
{

    
    UIImage *playImage = [[FloggerUIFactory uiFactory] createImage:SNS_PLAY];
    int width = 75;
    int height = 75;
    
    UIButton *imageV1 = [[FloggerUIFactory uiFactory] createButton:nil];
    imageV1.frame = CGRectMake(4, 2, width, height);
    imageV1.tag = 100;
    [imageV1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageV1p = [[FloggerUIFactory uiFactory] createImageView:playImage];
    imageV1p.frame = CGRectMake(width/2-playImage.size.width/2, height/2 - playImage.size.height/2, playImage.size.width, playImage.size.height);
    [imageV1 addSubview:imageV1p];
    
    UIButton *imageV2 = [[FloggerUIFactory uiFactory] createButton:nil];
    imageV2.frame = CGRectMake(83, 2, width, height);
    imageV2.tag = 101;
    [imageV2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV2p = [[FloggerUIFactory uiFactory] createImageView:playImage];
    imageV2p.frame = CGRectMake(width/2-playImage.size.width/2, height/2 - playImage.size.height/2, playImage.size.width, playImage.size.height);
    [imageV2 addSubview:imageV2p];
    
    UIButton *imageV3 = [[FloggerUIFactory uiFactory] createButton:nil];
    imageV3.frame = CGRectMake(162, 2, width, height);
    imageV3.tag = 102;
    [imageV3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV3p = [[FloggerUIFactory uiFactory] createImageView:playImage];
    imageV3p.frame = CGRectMake(width/2-playImage.size.width/2, height/2 - playImage.size.height/2, playImage.size.width, playImage.size.height);
    [imageV3 addSubview:imageV3p];
    
    UIButton *imageV4 = [[FloggerUIFactory uiFactory] createButton:nil];
    imageV4.frame = CGRectMake(240, 2, width, height);
    imageV4.tag = 103;
    [imageV4 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV4p = [[FloggerUIFactory uiFactory] createImageView:playImage];
    imageV4p.frame = CGRectMake(width/2-playImage.size.width/2, height/2 - playImage.size.height/2, playImage.size.width, playImage.size.height);
    [imageV4 addSubview:imageV4p];
    
    [self addSubview:imageV1];
    [self addSubview:imageV2];
    [self addSubview:imageV3];
    [self addSubview:imageV4];
    
    [self setImageView1:imageV1];
    [self setImageView1P:imageV1p];
    [self setImageView2:imageV2];
    [self setImageView2P:imageV2p];
    [self setImageView3:imageV3];
    [self setImageView3P:imageV3p];
    [self setImageView4:imageV4];
    [self setImageView4P:imageV4p];
    
    
    self.imageCount = 4;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    self.imageView1 = nil;
    self.imageView2 = nil;
    self.imageView3 = nil;
    self.imageView4 = nil;
    
    self.imageView1P = nil;
    self.imageView2P = nil;
    self.imageView3P = nil;
    self.imageView4P = nil;
    [super dealloc];
}

-(void)btnClicked:(id)sender
{
    NSInteger index = [(UIButton *)sender tag] - kBtnTag;
    if(delegate && [delegate respondsToSelector:@selector(selectGridTableViewCell:atIndex:)])
    {
        [delegate selectGridTableViewCell:self atIndex:index];
    }
}

-(void)reset
{
    self.imageView1.hidden = YES;
    self.imageView2.hidden = YES;
    self.imageView3.hidden = YES;
    self.imageView4.hidden = YES;
    
    self.imageView1P.hidden = YES;
    self.imageView2P.hidden = YES;
    self.imageView3P.hidden = YES;
    self.imageView4P.hidden = YES;
}

@end
