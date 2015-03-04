//
//  CheckGridCellButton.m
//  Flogger
//
//  Created by steveli on 12/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "CheckGridCellButton.h"

#define kPlayWidth 20
#define kPlayHeight 20
#define CELL  74


@implementation CheckGridCellButton
@synthesize checkview,selectview,ischeck,issueinfo,albuminfo,playview,playBgView,applyAnimation,videoTimeLable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        videoTimeLable=[[FloggerUIFactory uiFactory] createLable];
        videoTimeLable.text=[GlobalUtils displayableStrFromVideoduration:[issueinfo.videoduration intValue]];
        videoTimeLable.textColor=[UIColor whiteColor];//[[FloggerUIFactory uiFactory] createNumFontColor];
        videoTimeLable.textAlignment = UITextAlignmentRight;
        videoTimeLable.frame = CGRectMake(0, CELL - 14, CELL, 14);
        videoTimeLable.font=[[FloggerUIFactory uiFactory] createVideoTimeFont];
        videoTimeLable.backgroundColor=[UIColor clearColor];

        
        self.playBgView = [[FloggerUIFactory uiFactory] createView];
        playBgView.frame = CGRectMake(0, CELL - 15, CELL, 15);
        playBgView.backgroundColor=[UIColor blackColor];
        playBgView.alpha=0.5;
        
        UIImage *playImage = [[FloggerUIFactory uiFactory] createImage:SNS_FEED_THUMBNAIL_PLAY]; 
        self.playview = [[[UIImageView alloc]initWithFrame:CGRectMake(2,CELL - 12.5, playImage.size.width, playImage.size.height)] autorelease];
        [self.playview setImage:playImage];
        
        [self addSubview:playBgView];
        [self addSubview:playview];
        [self addSubview:videoTimeLable];
        [self.playview setHidden:YES];
        [self.playBgView setHidden:YES];
        [self.videoTimeLable setHidden:YES];
        
        self.selectview = [[[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)]autorelease];
        [self.selectview setImage:[UIImage imageNamed: SNS_SELECTION]];
        self.selectview.hidden = TRUE;
        [self addSubview:self.selectview];
        
        ischeck = FALSE;
    }
    return self;
}

-(BOOL)IsChecked
{
    return ischeck;
}
-(void)setChecked:(BOOL)flag
{
    ischeck = flag;
    [self.selectview setHidden:!ischeck];
}

-(void)dealloc
{
    self.selectview = nil;
    self.issueinfo  = nil;
    self.albuminfo  = nil;
    self.playview   = nil;
    self.playBgView=nil;
    self.videoTimeLable=nil;
    [super dealloc];

}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    UIImage *currentImage = [[SDImageCache sharedImageCache] imageFromKey:[url absoluteString]];
    if(!currentImage)
    {

        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        // Remove in progress downloader from queue
        [manager cancelForDelegate:self];
        //_oldMode = self.contentMode;
        //[self.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES]];
        /*for (UIView *view in self.subviews) {
            view.hidden = YES;
        }*/
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
- (void)cancelCurrentImageLoad
{
    self.contentMode = UIViewContentModeScaleAspectFill;//_oldMode;
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image  Animation:(BOOL)animation
{
    /*for (UIView *view in self.subviews) {
        view.hidden = NO;
    }*/
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
-(NSInteger)getType
{
    if(self.issueinfo)
        return [self.issueinfo.issuecategory integerValue];
    else if(self.albuminfo)
        return [self.albuminfo.type integerValue];
    else
        return ISSUE_CATEGORY_PICTURE;
}

-(void)isVideo:(BOOL)flag
{

    [self.playview setHidden:!flag];
    [self.playBgView setHidden:!flag];
    [self.videoTimeLable setHidden:!flag];
}
@end
