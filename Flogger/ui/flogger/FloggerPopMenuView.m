//
//  FloggerPopMenuView.m
//  Flogger
//
//  Created by jwchen on 12-2-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerPopMenuView.h"

#define kBtnTagBase 100

@implementation FloggerPopMenuView
@synthesize delegate, selectedIndex = _selectedIndex;
@synthesize allButton,videoButton,photoButton,tweetButton;
-(void) adjustPopMenuLayout
{
//    UIImage *selectBar = [[FloggerUIFactory uiFactory] createImage:SNS_SELECTION_BAR];
//    UIImage *
    UIImage *all = [[FloggerUIFactory uiFactory] createImage:SNS_DROPDOWN_ALL];
    UIImage *allHightlight = [[FloggerUIFactory uiFactory] createImage:SNS_DROPDOWN_ALL_HIGHLIGHT];
    UIImage *photo = [[FloggerUIFactory uiFactory] createImage:SNS_DROPDOWN_PHOTO];
    UIImage *photoHightlight = [[FloggerUIFactory uiFactory] createImage:SNS_DROPDOWN_PHOTO_HIGHLIGHT];
    UIImage *video = [[FloggerUIFactory uiFactory] createImage:SNS_DROPDOWN_VIDEO];
    UIImage *videoHightlight = [[FloggerUIFactory uiFactory] createImage:SNS_DROPDOWN_VIDEO_HIGHTLIGHT];
    UIImage *blog = [[FloggerUIFactory uiFactory] createImage:SNS_DROPDOWN_BLOG];
    UIImage *blogHightlight = [[FloggerUIFactory uiFactory] createImage:SNS_DROPDOWN_BLOG_HIGHTLIGHT];
    
    UIView *sortView = [[FloggerUIFactory uiFactory] createView];
//    int sortOriginalWidth = 165;
    sortView.frame = CGRectMake(320- all.size.width-5, 1, all.size.width, all.size.height + photo.size.height +video.size.height + blog.size.height);
    
    UIButton *allBtn = [[FloggerUIFactory uiFactory] createButton:nil];
    allBtn.frame = CGRectMake(0, 0, all.size.width, all.size.height);
    [allBtn setBackgroundImage:all forState:UIControlStateNormal];
    [allBtn setBackgroundImage:allHightlight forState:UIControlStateHighlighted];
    [allBtn setBackgroundImage:allHightlight forState:UIControlStateSelected];
    allBtn.tag = 100;
    [allBtn addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
    [allBtn setTitle:NSLocalizedString(@"All", @"All") forState:UIControlStateNormal];
    allBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];//[[FloggerUIFactory uiFactory] createMiddleBoldFont];
    UIColor *titleHightColor = [[[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0] autorelease];
    [allBtn setTitleColor:titleHightColor forState:UIControlStateNormal];
    [allBtn setTitleColor:[[[UIColor alloc] initWithRed:57/255.0 green:175/255.0 blue:248/255.0 alpha:1.0] autorelease] forState:UIControlStateSelected];
     [allBtn setTitleColor: [[[UIColor alloc] initWithRed:57/255.0 green:175/255.0 blue:248/255.0 alpha:1.0] autorelease]forState:UIControlStateHighlighted];
    allBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [allBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *photoBtn = [[FloggerUIFactory uiFactory] createButton:nil];
    photoBtn.frame = CGRectMake(0, all.size.height, photo.size.width, photo.size.height);
    [photoBtn setBackgroundImage:photo forState:UIControlStateNormal];
    [photoBtn setBackgroundImage:photoHightlight forState:UIControlStateHighlighted];
    [photoBtn setBackgroundImage:photoHightlight forState:UIControlStateSelected];
    
    photoBtn.tag = 101;
    [photoBtn addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn setTitle:NSLocalizedString(@"Photo", @"Photo") forState:UIControlStateNormal];
    photoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];//[[FloggerUIFactory uiFactory] createMiddleBoldFont];
    [photoBtn setTitleColor:titleHightColor forState:UIControlStateNormal];
    [photoBtn setTitleColor: [[[UIColor alloc] initWithRed:248/255.0 green:62/255.0 blue:62/255.0 alpha:1.0] autorelease] forState:UIControlStateSelected]; 
     [photoBtn setTitleColor: [[[UIColor alloc] initWithRed:248/255.0 green:62/255.0 blue:62/255.0 alpha:1.0] autorelease]forState:UIControlStateHighlighted];
    photoBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [photoBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *videoBtn = [[FloggerUIFactory uiFactory] createButton:nil];
    videoBtn.frame = CGRectMake(0, all.size.height + photo.size.height, video.size.width, video.size.height);
    
    [videoBtn setBackgroundImage:video forState:UIControlStateNormal];
    [videoBtn setBackgroundImage:videoHightlight forState:UIControlStateHighlighted];
    [videoBtn setBackgroundImage:videoHightlight forState:UIControlStateSelected];
    
    videoBtn.tag = 102;
    [videoBtn addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
    [videoBtn setTitle:NSLocalizedString(@"Video", @"Video") forState:UIControlStateNormal];
    videoBtn.titleLabel.font =[UIFont boldSystemFontOfSize:12]; //[[FloggerUIFactory uiFactory] createMiddleBoldFont];
    [videoBtn setTitleColor:titleHightColor forState:UIControlStateNormal];
    [videoBtn setTitleColor:[[[UIColor alloc] initWithRed:255/255.0 green:228/255.0 blue:0/255.0 alpha:1.0] autorelease] forState:UIControlStateSelected];
       [videoBtn setTitleColor: [[[UIColor alloc] initWithRed:255/255.0 green:228/255.0 blue:0/255.0 alpha:1.0] autorelease]forState:UIControlStateHighlighted];
    videoBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [videoBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    UIButton *weiboBtn = [[FloggerUIFactory uiFactory] createButton:nil];
    weiboBtn.frame = CGRectMake(0, all.size.height + photo.size.height + video.size.height, blog.size.width, blog.size.height);
    
    [weiboBtn setBackgroundImage:blog forState:UIControlStateNormal];
    [weiboBtn setBackgroundImage:blogHightlight forState:UIControlStateHighlighted];
    [weiboBtn setBackgroundImage:blogHightlight forState:UIControlStateSelected];

    
    weiboBtn.tag = 103;
    [weiboBtn addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
    [weiboBtn setTitle:NSLocalizedString(@"Shout", @"Shout") forState:UIControlStateNormal]; 
//    [weiboBtn setTitleColor :[UIColor blackColor] forState:UIControlStateNormal];
    weiboBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12]; //[[FloggerUIFactory uiFactory] createMiddleBoldFont];
    [weiboBtn setTitleColor:titleHightColor forState:UIControlStateNormal];
    [weiboBtn setTitleColor:[[[UIColor alloc] initWithRed:62/255.0 green:229/255.0 blue:93/255.0 alpha:1.0] autorelease] forState:UIControlStateSelected];
    [weiboBtn setTitleColor: [[[UIColor alloc] initWithRed:62/255.0 green:229/255.0 blue:93/255.0 alpha:1.0] autorelease]forState:UIControlStateHighlighted];
    weiboBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [weiboBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];

    [sortView addSubview:allBtn];
    [sortView addSubview:photoBtn];
    [sortView addSubview:videoBtn];
    [sortView addSubview:weiboBtn];
    
    [self addSubview:sortView];
    
    [self setAllButton:allBtn];
    [self setPhotoButton:photoBtn];
    [self setVideoButton:videoBtn];
    [self setTweetButton:weiboBtn];
    
    [self.allButton setSelected:YES];
    
}
-(void)initPopMenuView
{
    
    [self adjustPopMenuLayout];
    self.alpha = 0;
    [self addTarget:self action:@selector(backgroundTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initPopMenuView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initPopMenuView];
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

-(void)toggleMenu
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2];
    self.alpha = 1-self.alpha;
    [UIView commitAnimations];
}

-(void)backgroundTapped:(id)sender
{
    [self toggleMenu];
}

-(void)menuTapped:(id)sender
{
    [self.allButton setSelected:NO];
    [self.photoButton setSelected:NO];
    [self.videoButton setSelected:NO];
    [self.tweetButton setSelected:NO];
    
    NSInteger index = [(UIButton *)sender tag];
    self.selectedIndex = index - kBtnTagBase;
    switch (self.selectedIndex) {
        case 0:
            [self.allButton setSelected:YES];
            break;
        case 1:
            [self.photoButton setSelected:YES];
            break;
        case 2:
            [self.videoButton setSelected:YES];
            break;
        case 3:
            [self.tweetButton setSelected:YES];
            break;
        default:
            break;
    }
    if (delegate) {
        [delegate floggerPopMenuView:self clickedAtIndex:self.selectedIndex];
    }
    [self backgroundTapped:nil];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex && _selectedIndex >= 0)
    {
        [(UIButton *)[self viewWithTag:_selectedIndex + kBtnTagBase] setSelected:NO];
    }
    _selectedIndex = selectedIndex;
    
    [(UIButton *)[self viewWithTag:_selectedIndex + kBtnTagBase] setSelected:YES];
}

-(void) dealloc
{
    self.allButton = nil;
    self.photoButton = nil;
    self.videoButton = nil;
    self.tweetButton = nil;
    [super dealloc];
}

@end
