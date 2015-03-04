//
//  AlbumBottomBar.m
//  Flogger
//
//  Created by jwchen on 12-2-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "AlbumBottomBar.h"

#define HSPACE  16
#define LEFT_X  6
#define RIGHT_X 6
#define TOP_X   5
#define WIDTH   65
#define HEIGHT  35 
#define EN_ALPHA 1
#define UN_ALPHA 0.7
@implementation AlbumBottomBar

@synthesize coverbtn,sharebtn,addbtn,deletebtn,editbtn,importbtn,mflag,delegate,backview;

-(void)dealloc
{
    self.backview=nil;
    self.coverbtn = nil;
    self.sharebtn = nil;
    self.addbtn   = nil;
    self.deletebtn = nil;
    self.editbtn = nil;
    self.importbtn = nil;
    [super dealloc];
}

-(void)btnPressed:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
//    NSLog(@"albumbottombar %d button clicked", tag);
    if(self.delegate)
        [self.delegate albumBottomBarCommand:tag];
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

-(void)showbottom:(BOOL)showflag
{
    [UIView beginAnimations:nil context:nil];    
    if(showflag){
        self.backview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.editbtn.frame= CGRectMake(LEFT_X + 3*(WIDTH +HSPACE), TOP_X, WIDTH, HEIGHT) ;      
        self.coverbtn.frame= CGRectMake(LEFT_X, TOP_X, WIDTH, HEIGHT);
        self.sharebtn.frame= CGRectMake(LEFT_X + WIDTH +HSPACE, TOP_X, WIDTH, HEIGHT) ;
        self.addbtn.frame=CGRectMake(LEFT_X + 2*(WIDTH + HSPACE), TOP_X, WIDTH, HEIGHT);
    }else{
        self.backview.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        self.editbtn.frame= CGRectMake(LEFT_X + 3*(WIDTH +HSPACE), TOP_X+HEIGHT, WIDTH, HEIGHT) ;      
        self.coverbtn.frame= CGRectMake(LEFT_X, TOP_X+HEIGHT, WIDTH, HEIGHT);
        self.sharebtn.frame= CGRectMake(LEFT_X + WIDTH +HSPACE, TOP_X+HEIGHT, WIDTH, HEIGHT) ;
        self.addbtn.frame=CGRectMake(LEFT_X + 2*(WIDTH + HSPACE), TOP_X+HEIGHT, WIDTH, HEIGHT);
    }
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:1000];
    [UIView commitAnimations];    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.backview = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)]autorelease];
        [self.backview setBackgroundColor:[UIColor blackColor]];
        self.backview.alpha = UN_ALPHA;
        [self addSubview:self.backview];
         [self showbottom:FALSE];
        
        self.editbtn = [self createButton:nil rect:CGRectMake(LEFT_X + 3*(WIDTH +HSPACE), TOP_X, WIDTH, HEIGHT) img:[UIImage imageNamed:SNS_EDIT_ALBUM_BUTTON] tag:ALBUM_BOTTOM_EDIT];
        self.importbtn = [self createButton:nil rect:CGRectMake(LEFT_X, TOP_X, WIDTH, HEIGHT) img:[UIImage imageNamed: SNS_GALLERY_IMPORT_BUTTON] tag:ALBUM_BOTTOM_IMPORT];
        self.importbtn.hidden=YES;
        self.coverbtn = [self createButton: NSLocalizedString(@"Cover",@"Cover") rect:CGRectMake(LEFT_X, TOP_X, WIDTH, HEIGHT) img:[UIImage imageNamed:SNS_BUTTON] tag:ALBUM_BOTTOM_COVER];
        self.sharebtn = [self createButton:NSLocalizedString(@"Share",@"Share") rect:CGRectMake(LEFT_X + WIDTH +HSPACE, TOP_X, WIDTH, HEIGHT) img:[UIImage imageNamed: SNS_BUTTON] tag:ALBUM_BOTTOM_SHARE];
        self.addbtn = [self createButton:NSLocalizedString(@"Add to",@"Add to") rect:CGRectMake(LEFT_X + 2*(WIDTH + HSPACE), TOP_X, WIDTH, HEIGHT) img:[UIImage imageNamed: SNS_BUTTON] tag:ALBUM_BOTTOM_ADDTO];
        self.deletebtn = [self createButton:NSLocalizedString(@"Delete",@"Delete") rect:CGRectMake(LEFT_X + 3*(WIDTH + HSPACE), TOP_X, WIDTH, HEIGHT) img:[UIImage imageNamed: SNS_GALLERY_DELETE_BUTTON] tag:ALBUM_BOTTOM_DELETE];
        self.deletebtn.hidden=YES;
        
        mflag = NO;
        
        [self CheckImage:FALSE];
    }
    return self;
}

-(void)CheckImage:(BOOL)f
{ 
//    NSLog(@"checkimage f = %d",f);
   [editbtn setHidden:!f];
//   [importbtn setHidden:!f];
    
    [coverbtn setHidden:!f];
    [sharebtn setHidden:!f];
    [addbtn   setHidden:!f];
//    [deletebtn setHidden:!f];
    [self showbottom:f];
    if(f){
        [self EnableAllBtn:FALSE];
    }
}

-(void)EnableCoverBtn:(BOOL)flag
{
    coverbtn.enabled = flag;
    sharebtn.enabled=flag;
    if (flag) {
        coverbtn.titleLabel.alpha=EN_ALPHA;
        sharebtn.titleLabel.alpha=EN_ALPHA;
    }else{
        coverbtn.titleLabel.alpha=UN_ALPHA;
        sharebtn.titleLabel.alpha=UN_ALPHA;
    }


}

-(void)EnableAllBtn:(BOOL)flag
{
    coverbtn.enabled = flag;
    sharebtn.enabled = flag;
    addbtn.enabled = flag;
    importbtn.enabled = flag;
    if (flag) {
        coverbtn.titleLabel.alpha=EN_ALPHA;
        sharebtn.titleLabel.alpha=EN_ALPHA;
        addbtn.titleLabel.alpha=EN_ALPHA;
        importbtn.titleLabel.alpha=EN_ALPHA;
    }else{
        coverbtn.titleLabel.alpha=UN_ALPHA;
        sharebtn.titleLabel.alpha=UN_ALPHA;
        addbtn.titleLabel.alpha=UN_ALPHA;
        importbtn.titleLabel.alpha=UN_ALPHA;
    }
}

@end
