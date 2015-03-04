//
//  FloggerMenuView.m
//  Flogger
//
//  Created by jwchen on 12-1-20.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerMenuView.h"

#define kTopActionHeight 44

#define kHMargin 20
#define kVMargin 40

#define kItemWith 72.5
#define kItemHeight 86.5

//#define kBigItemWith 90
//#define kBigItemHeight 100

#define kBigItemWith 130
#define kBigItemHeight 170

#define kNewBtnLeftTag 1000
#define kNewBtnRightTag 1001

@implementation FloggerMenuView
@synthesize count = _count, delegate;

-(void)setCount:(NSInteger)c
{
    _count = c;
    NSInteger high = c / 10;
    high = high >= 10? 9 : high;
    UIImageView *left = (UIImageView *)[self viewWithTag:kNewBtnLeftTag];
    [left setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SNS_Notifcation_%d", high]]];
    
    NSInteger low = c % 10;
    UIImageView *right = (UIImageView *)[self viewWithTag:kNewBtnRightTag];
    [right setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SNS_Notifcation_%d", low]]];
}

-(void)btnPressed:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
//    NSLog(@"%d button clicked", tag);
    if (delegate) {
        [delegate btnTapped:tag];
    }
    [self hide];
}

-(void)setupTopBar:(CGRect)frame
{
    //action view
    UIView *actionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kTopActionHeight)] autorelease];
    UIImageView* topbar = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, actionView.frame.size.height)] autorelease];
    [topbar setImage:[UIImage imageNamed: SNS_TOP_BAR]];
    [actionView addSubview:topbar];
    [topView addSubview:actionView];
    
    UIButton *searchBtn = [[[UIButton alloc] initWithFrame:CGRectMake(5, 8, 60, 29)] autorelease];
    [searchBtn setBackgroundImage:[UIImage imageNamed: SNS_HOME_SEARCH] forState:UIControlStateNormal];
    searchBtn.tag = Menu_Search;
    [searchBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:searchBtn];
    
    UIButton *tweetBtn = [[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 60 - 5, 8, 60, 29)] autorelease];
    tweetBtn.tag = Menu_Tweet;
    [tweetBtn setBackgroundImage:[UIImage imageNamed: SNS_HOME_TWEET] forState:UIControlStateNormal];
    [tweetBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:tweetBtn];
    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newBtn.tag = Menu_Notification;
    newBtn.backgroundColor = [UIColor clearColor];
    NSInteger newWidth = 22 * 2 + 2;
    newBtn.frame = CGRectMake(frame.size.width/2 - (newWidth/2), 7, newWidth, 30);
    UIImageView *leftImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 30)] autorelease];
    leftImageView.tag = kNewBtnLeftTag;
    [newBtn addSubview:leftImageView];
    
    UIImageView *rightImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(leftImageView.frame.size.width + 2, 0, 22, 30)] autorelease];
    rightImageView.tag = kNewBtnRightTag;
    [newBtn addSubview:rightImageView];
    [newBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:newBtn];
}

-(UIButton *)generateBtnWithImage:(NSString *)image x:(NSInteger)x y:(NSInteger)y tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.frame = CGRectMake(x, y, width, height);
    //    UIImage *
        UIImage *imageP = [[FloggerUIFactory uiFactory] createImage:image];
    btn.frame = CGRectMake(x, y, imageP.size.width, imageP.size.height);

    [btn setBackgroundImage:imageP forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(UIButton *)generateBtnWithImage:(NSString *)image title:(NSString *)title x:(NSInteger)x y:(NSInteger)y tag:(NSInteger)tag imageFrame:(CGRect)imageFrame titleEdgeInsets:(UIEdgeInsets)titleInsets width:(NSInteger)width height:(NSInteger)height
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(x, y, width, height);
//    UIImage *
    btn.frame = CGRectMake(x, y, width, height);
    
    if ([image isEqualToString:SNS_HOME_PHOTO_CAMERA] || [image isEqualToString:SNS_HOME_VIDEO_CAMERA]) {
        
    } else {
        [btn setBackgroundImage:[UIImage imageNamed: SNS_HOME_HIGHLITED_BOX] forState:UIControlStateHighlighted];
    }
    
    
    UIImageView* img = [[[UIImageView alloc]initWithFrame:imageFrame] autorelease];
    [img setImage:[UIImage imageNamed: image]];
    [btn addSubview:img];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[GlobalUtils getBoldFontByStyle:FONT_MIDDLE]];
    [btn setTitleEdgeInsets:titleInsets];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(UIButton *)generateBtnWithImage:(NSString *)image title:(NSString *)title x:(NSInteger)x y:(NSInteger)y tag:(NSInteger)tag
{
    return [self generateBtnWithImage:image title:title x:x y:y tag:tag imageFrame:CGRectMake(11, 10, 52.5, 53) titleEdgeInsets:UIEdgeInsetsMake(65 ,0, 0, 0) width:kItemWith height:kItemHeight];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(x, y, kItemWith, kItemWith);
//    [btn setBackgroundImage:[UIImage imageNamed: @"Selection_Box.png"] forState:UIControlStateHighlighted];
//    
//    UIImageView* img = [[[UIImageView alloc]initWithFrame:CGRectMake(11, 10, 58, 55)] autorelease];
//    [img setImage:[UIImage imageNamed: image]];
//    [btn addSubview:img];
//    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [btn.titleLabel setFont:[GlobalUtils getBoldFontByStyle:FONT_MIDDLE]];
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(65 ,7, 0, 7)];
//    btn.tag = tag;
//    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    return btn;
}

-(void)setupTopView
{
    [self setupTopBar:self.topView.frame];
    
    NSInteger y = kTopActionHeight + kVMargin;
    
    CGFloat hMargin = (self.topView.frame.size.width - kItemWith * 3)/4;
    
    NSInteger x = hMargin;
    
    //profile button
    UIButton *btn = [self generateBtnWithImage: SNS_HOME_PROFILE title: NSLocalizedString(@"Profile",@"Profile") x:x y:y tag:Menu_Profile];
    [self.topView addSubview:btn];
    
    //feed button
    x += hMargin + kItemWith;
    btn = [self generateBtnWithImage: SNS_HOME_FEED title:NSLocalizedString(@"Feed",@"Feed") x:x y:y tag:Menu_Feed];
    [self.topView addSubview:btn];
    
    //Find People button
    x += hMargin + kItemWith;
    btn = [self generateBtnWithImage: SNS_HOME_FIND_PEOPLE title:NSLocalizedString(@"Find People",@"Find People") x:x y:y tag:Menu_Find_People imageFrame:CGRectMake(11, 10, 52.5, 53) titleEdgeInsets:UIEdgeInsetsMake(65 ,0, 0, 0) width:kItemWith + 10 height:kItemHeight];
//    btn = [self generateBtnWithImage:@"Home_Find_People.png" title:@"Find People" x:x y:y tag:Menu_Find_People];
    [self.topView addSubview:btn];
    
    //Gallery button
    x = hMargin;
    y += kVMargin + kItemHeight;
    btn = [self generateBtnWithImage: SNS_HOME_GALLERY title:NSLocalizedString(@"Gallery",@"Gallery") x:x y:y tag:Menu_Gallery];
    [self.topView addSubview:btn];
    
    //Favorites button
    x += hMargin + kItemWith;
    btn = [self generateBtnWithImage: SNS_HOME_FAVORITE title:NSLocalizedString(@"Favorites",@"Favorites") x:x y:y tag:Menu_Favorites];
    [self.topView addSubview:btn];
    
    //Settings button
    x += hMargin + kItemWith;
    btn = [self generateBtnWithImage: SNS_HOME_SETTINGS title:NSLocalizedString(@"Settings",@"Settings") x:x y:y tag:Menu_Setting];
    [self.topView addSubview:btn];
    
    //Photo button
    NSInteger hGap = (topView.frame.size.width - (kBigItemWith * 2))/3;
    x = hGap;
//    y += kItemHeight + kVMargin;
    y += kItemHeight;
    CGRect imageFrame = CGRectMake(8, 10, 130, 133);
    UIEdgeInsets titleEdgInset = UIEdgeInsetsMake(85 ,20, 0, 5);
    btn = [self generateBtnWithImage: SNS_HOME_PHOTO_CAMERA title:NSLocalizedString(@"Photo",@"Photo") x:x y:y tag:Menu_Photo imageFrame:imageFrame titleEdgeInsets:titleEdgInset width:kBigItemWith height:kBigItemHeight];
//    btn = [self generateBtnWithImage:SNS_HOME_PHOTO_CAMERA x:x y:y tag:Menu_Photo];
    [self.topView addSubview:btn];
    
    //video
    x += hGap + 110;
    btn = [self generateBtnWithImage: SNS_HOME_VIDEO_CAMERA title:NSLocalizedString(@"Video",@"Video") x:x y:y tag:Menu_Video imageFrame:imageFrame titleEdgeInsets:titleEdgInset width:kBigItemWith height:kBigItemHeight];
//    btn = [self generateBtnWithImage:SNS_HOME_VIDEO_CAMERA x:x y:y tag:Menu_Video];
    [self.topView addSubview:btn];

}

-(void)setupView:(CGRect)frame
{
    UIImageView* bgview = [[[UIImageView alloc]initWithFrame:CGRectMake(0, kTopActionHeight, self.frame.size.width, self.frame.size.height)] autorelease];
    [bgview setImage:[UIImage imageNamed: SNS_HOME_BACKGROUND]];
    bgview.alpha = 0.95f;
    [self insertSubview:bgview atIndex:0];
    [self setupTopView];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = kFloggerMenuTag;
        [self setupView:frame];
        self.count = 0;
    }
    return self;
}
@end
