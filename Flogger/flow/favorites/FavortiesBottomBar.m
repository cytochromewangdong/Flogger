//
//  FavortiesBottomBar.m
//  Flogger
//
//  Created by steveli on 08/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "FavortiesBottomBar.h"

#define HSPACE  16
#define LEFT_X  6
#define RIGHT_X 6
#define TOP_X   5
#define WIDTH   65
#define HEIGHT  35 
#define UN_ALPHA 0.7

@implementation FavortiesBottomBar

@synthesize sharebtn,unlikebtn,bgview,bottombardelegate;

-(void)dealloc
{
    self.sharebtn  = nil;
    self.unlikebtn = nil;
    self.bgview    = nil;
    self.bottombardelegate = nil;
    [super dealloc];
}


-(void)btnPressed:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    switch(tag)
    {
        case BOTTOM_SHARE:
            if(self.bottombardelegate)
                [self.bottombardelegate sharecommand];
            break;
        case BOTTOM_UNLIKE:
            if(self.bottombardelegate)
                [self.bottombardelegate unlikecommand];
            break;
    }
}


-(UIButton*)createButton:(NSString*)name rect:(CGRect)frame img:(UIImage*)img tag:(NSInteger)tag
{
    UIButton* btn = [[[UIButton alloc]initWithFrame:frame]autorelease];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    if(name != nil){
//        NSLog(@"createbutton name = %@",name);
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font =[UIFont fontWithName:@"HelveticaNeue-Bold" size:12];//[GlobalUtils getFontByStyle:FONT_MIDDLE];
        [btn setTitleColor: [[[UIColor alloc] initWithRed:64/255.0 green:64/255.0 blue:62/255.0 alpha:1.0] autorelease]forState:UIControlStateNormal];
        btn.titleLabel.shadowOffset = CGSizeMake(0, 1);
        [btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)] ;
       btn.titleLabel.alpha=UN_ALPHA;
    }
    [self addSubview:btn];
    return btn;
    
  
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.bgview = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)]autorelease];
        [self.bgview setBackgroundColor:[UIColor blackColor]];
        
        self.bgview.alpha = 0.7;
        [self addSubview:self.bgview];
        
        self.sharebtn = [self createButton: NSLocalizedString(@"Share",@"Share") rect:CGRectMake(LEFT_X , TOP_X, WIDTH, HEIGHT) img:[UIImage imageNamed: SNS_BUTTON] tag:BOTTOM_SHARE];
        
        self.unlikebtn = [self createButton:NSLocalizedString(@"Unlike",@"Unlike") rect:CGRectMake(LEFT_X + 3*(WIDTH +HSPACE), TOP_X, WIDTH, HEIGHT) img:[UIImage imageNamed: SNS_ALBUM_DELETE_BUTTON] tag:BOTTOM_UNLIKE];
    }
    return self;
}

@end
