//
//  FeedGridTableViewCell.m
//  Flogger
//
//  Created by dong wang on 12-4-26.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FeedGridTableViewCell.h"
#import "FloggerButtonView.h"
static UIImage *cellPlaceHolder;
static UIImage *playImage;
@implementation FeedGridTableViewCell
@synthesize imageCount,imageViews,delegate;
+(void)initialize
{
    cellPlaceHolder = [[[FloggerUIFactory uiFactory] createImage:SNS_THUMBNAIL_PLACEHOLDER]retain];
    playImage = [[[FloggerUIFactory uiFactory] createImage:SNS_FEED_THUMBNAIL_PLAY]retain];
}
-(void)setup
{
    
    
    /* UIImage *playImage = [[FloggerUIFactory uiFactory] createImage:SNS_PLAY];
     int width = 75;
     int height = 75;
     
     UIButton *imageV1 = [[FloggerUIFactory uiFactory] createButton:nil];
     imageV1.frame = CGRectMake(4, 2, width, height);
     imageV1.tag = 100;
     [imageV1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     UIImageView *imageV1p = [[FloggerUIFactory uiFactory] createImageView:playImage];
     imageV1p.frame = CGRectMake(width/2-playImage.size.width/2, height/2 - playImage.size.height/2, playImage.size.width, playImage.size.height);
     [imageV1 addSubview:imageV1p];
     
     
     [self addSubview:imageV1];*/
    self.imageViews = [[[NSMutableArray alloc]init]autorelease];
    //    [se]
    self.backgroundColor = [UIColor redColor]; //[[FloggerUIFactory uiFactory] createBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void) setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}
-(void) addImageToView:(BOOL) isPlay subIndex:(int) subindex X:(float) x Y:(float)y W:(float)w H:(float)h TheIssue:(MyIssueInfo *)info
{
    
    static float corRadius = 3;
    UIView *floggerContainer = [[[UIView alloc]init]autorelease];
    floggerContainer.backgroundColor = RGBCOLOR(0x3d, 0x43, 0x4b);//3d434b
    FloggerButtonView *imageV1 = [[[FloggerButtonView alloc]init] autorelease];//[[FloggerUIFactory uiFactory] createButton:nil];
    //UIView *container = [[FloggerUIFactory uiFactory] createView];
    //container.frame =  CGRectMake(x, y, w, h);
    imageV1.frame = CGRectMake(0, 0, w, h);
    floggerContainer.frame = CGRectMake(x, y, w, h);
    imageV1.applyAnimation=YES;
    //[container addSubview:imageV1];
    //container.layer.shadowColor = [[UIColor grayColor] CGColor];
    //container.layer.shadowOffset = CGSizeMake(0, 3);
    //container.layer.shadowRadius = 3;
    //container.layer.shadowOpacity = 0.5;
    //    container.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:imageV1.frame cornerRadius:corRadius]CGPath];
    //imageV1.backgroundColor = [UIColor blueColor];
    imageV1.tag = subindex;
    imageV1.backgroundColor = RGBCOLOR(61, 67, 75);
    /*imageV1.layer.shadowColor = [[UIColor grayColor] CGColor];
     imageV1.layer.shadowOffset = CGSizeMake(0, 0);
     imageV1.layer.shadowRadius = 3;
     imageV1.layer.shadowOpacity = 0.8;
     imageV1.layer.shadowPath = [[UIBezierPath bezierPathWithRect:imageV1.bounds]CGPath];*/
    //    NSLog(@"-------:%@",info.thumbnailurl);
    dispatch_async(dispatch_get_main_queue(), ^{
        if(isPlay)
        {
            [imageV1 setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:info.scalethumbnailurl]] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_VIDEO]];
        }else{
            [imageV1 setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:info.scalethumbnailurl]] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PHOTO]];
        }
    });
    [imageV1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    imageV1.contentScaleFactor = [[UIScreen mainScreen] scale];
    imageV1.layer.masksToBounds =NO;
    //    imageV1.layer.cornerRadius = corRadius;
    imageV1.layer.borderColor=[[UIColor whiteColor] CGColor];
    imageV1.layer.borderWidth=2;
    imageV1.layer.shadowColor = [[UIColor grayColor] CGColor];
    imageV1.layer.shadowOffset = CGSizeMake(0, 1);
    imageV1.layer.shadowRadius = 1;
    imageV1.layer.shadowOpacity = 0.5;
    imageV1.layer.shadowPath = [[UIBezierPath bezierPathWithRect:imageV1.bounds]CGPath];
    if(isPlay)
    {
        //[GlobalUtils displayableStrFromVideoduration:[info.videoduration intValue]]
        UILabel *videoTimeLable=[[FloggerUIFactory uiFactory] createLable];
        videoTimeLable.text=[GlobalUtils displayableStrFromVideoduration:[info.videoduration intValue]];
        videoTimeLable.textColor=[UIColor whiteColor];//[[FloggerUIFactory uiFactory] createNumFontColor];
        videoTimeLable.textAlignment = UITextAlignmentRight;
        videoTimeLable.frame = CGRectMake(0, h - 20, w-3, 18);
        videoTimeLable.font=[[FloggerUIFactory uiFactory] createVideoTimeFont];
        videoTimeLable.backgroundColor=[UIColor clearColor];
        
        UIView *viewPlay = [[FloggerUIFactory uiFactory] createView];
        viewPlay.frame = CGRectMake(0, h - 20, w, 20);
        viewPlay.backgroundColor=[UIColor blackColor];
        viewPlay.alpha=0.5;
        
        UIImageView *imageV1p = [[FloggerUIFactory uiFactory] createImageView:playImage];
        imageV1p.frame = CGRectMake(4, h - 16, playImage.size.width, playImage.size.height);
        
        
        [imageV1 addSubview:viewPlay];
        [imageV1 addSubview:videoTimeLable];
        [imageV1 addSubview:imageV1p];
        
    }
    
    
    [self addSubview:floggerContainer];
    [floggerContainer addSubview:imageV1];
    [self.imageViews addObject:floggerContainer];
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
    self.imageViews = nil;
    [super dealloc];
}

-(void)btnClicked:(id)sender
{
    NSInteger index = [(UIButton *)sender tag];// - kBtnTag;
    if(delegate && [delegate respondsToSelector:@selector(selectGridTableViewCell:atIndex:)])
    {
        [delegate selectGridTableViewCell:self atIndex:index];
    }
}

-(void)clear
{
    /*self.imageView1.hidden = YES;
     self.imageView2.hidden = YES;
     self.imageView3.hidden = YES;
     self.imageView4.hidden = YES;
     
     self.imageView1P.hidden = YES;
     self.imageView2P.hidden = YES;
     self.imageView3P.hidden = YES;
     self.imageView4P.hidden = YES;*/
    for (UIView *view in self.imageViews) {
        [view removeFromSuperview];
    }
    self.imageCount = 0;
    [self.imageViews removeAllObjects];
}

@end
