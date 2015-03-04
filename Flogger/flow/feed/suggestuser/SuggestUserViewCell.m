//
//  SuggestUserViewCell.m
//  Flogger
//
//  Created by jwchen on 12-3-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SuggestUserViewCell.h"
#import "Issueinfo.h"
#import "EntityEnumHeader.h"
#import "GlobalData.h"

#import "FloggerButtonView.h"
#define kTopMinHeight 93
#define kUserHeight 60
#define kImageHeight 90

#define kPhotoSize 40
#define kSuggestTopHeight @"kSuggestTopHeight"
#define kDescriptionHeight @"kDescriptionHeight"

#define kVGap 5
#define kVLGap 2

@implementation SuggestUserViewCell
@synthesize imageView1, imageView2, imageView3, imageView4, imageView1P, imageView2P, imageView3P, imageView4P, btn1, btn2, btn3, btn4;
@synthesize iconView, userLabel, followerLabel, followBtn, descriptionLabel, imageContainerView;
@synthesize account = _account, delegate;//,mode;

+(CGFloat) tableView:(UITableView *)tableView heightForAccount:(MyAccount *)account
{
    /*CGFloat totalHeight = 0;
     
     CGFloat titleHeight = 0;
     NSNumber *middleHeightN = [account.dataDict objectForKey:kSuggestTopHeight];
     if (middleHeightN && [middleHeightN floatValue] > 0) {
     titleHeight = [middleHeightN floatValue];
     }
     else
     {
     //        CGFloat titleHeight = 0;
     
     titleHeight += kVGap;
     NSString *str = account.username;
     CGFloat desHeight = [str sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(150, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
     
     titleHeight += desHeight + kVLGap;
     
     str = [NSString stringWithFormat:@"%d", [account.followerscount intValue]];
     
     titleHeight += [str sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(150, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
     
     titleHeight += kVLGap;
     
     NSString *title = account.status;
     
     titleHeight += [title sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(225, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
     
     [account.dataDict setObject:[NSNumber numberWithFloat:desHeight] forKey:kDescriptionHeight];
     
     titleHeight  += kVGap;
     
     if (titleHeight < kTopMinHeight) {
     titleHeight = kTopMinHeight;
     }
     
     [account.dataDict setObject:[NSNumber numberWithFloat:titleHeight] forKey:kSuggestTopHeight];
     }
     
     totalHeight += titleHeight;
     
     if(account.issueList && account.issueList.count > 0)
     {
     totalHeight += kImageHeight + kVGap;
     }
     */
    //    NSLog(@"user height: %f", totalHeight);
    
    //    return totalHeight;
    CGFloat totalHei = 0;
    if(account.issueList && account.issueList.count > 0)
    {
        //        totalHei = 160;
        totalHei = 140+15;
    } else {
        totalHei = 60;
    }
    
    return totalHei;
    
}

-(void) adjustSuggestUserViewCell
{
    NSString *newFollow=@"New_Follow_Button.png";
    UIImage *iconImage = [[FloggerUIFactory uiFactory] createImage:SNS_MALE_PLACEHOLDER];
    UIImage *followImage = [[FloggerUIFactory uiFactory] createImage:newFollow];
    //    UIImage *unfollowImage = [[FloggerUIFactory uiFactory] createImage:SNS_UNFOLLOW_MIDDLE_BUTTON];
    
    UIImageView *iconImageV = [[FloggerUIFactory uiFactory] createImageView:iconImage];
    iconImageV.layer.cornerRadius = 5;
    iconImageV.layer.masksToBounds = YES;
    iconImageV.frame = CGRectMake(2, 2, 40, 40);
    //    iconImageV.frame = CGRectMake(10, 10, 44, 44);
    //**********add layout**************//
    //    iconImageV.layer.borderWidth=2;
    //    iconImageV.layer.borderColor=[[UIColor whiteColor]CGColor];
    //    iconImageV.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[[UIImageView alloc]init]autorelease];
    iconImageView.frame=CGRectMake(10,10,44,44);
    iconImageView.backgroundColor=[UIColor whiteColor];
    iconImageView.layer.cornerRadius=5;
    //    [iconImageview addSubview:iconImageV];
    [iconImageView addSubview:iconImageV];
    //    UIView *back
    
    
    UILabel *userLab = [[FloggerUIFactory uiFactory] createLable];
    userLab.frame = CGRectMake(60, 17, 170, 17);
    userLab.textAlignment = UITextAlignmentLeft;
    userLab.font = [UIFont boldSystemFontOfSize: 16];
    userLab.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
    //    userLab.font = [[FloggerUIFactory uiFactory] createSmallBoldFont];
    
    UILabel *followLab = [[FloggerUIFactory uiFactory] createLable];
    followLab.frame = CGRectMake(60, 31, 170, 15);
    followLab.textAlignment = UITextAlignmentLeft;
    followLab.font = [UIFont systemFontOfSize: 12];
    followLab.textColor = [[FloggerUIFactory uiFactory] createDescFontColor];//[[UIColor alloc] initWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
    
    //    followLab.textColor = 
    //    followLab.textColor = [uicolorr]
    //    followLab.font = [[FloggerUIFactory uiFactory] createSmallFont];
    
    //    TTStyledTextLabel *descriptionLab = [[FloggerUIFactory uiFactory] createTTStyledTextLable];
    //    descriptionLab.frame = CGRectMake(100, 55, 200, 50);
    //    descriptionLab.textAlignment = UITextAlignmentLeft;
    
    UIButton *followButton = [[FloggerUIFactory uiFactory] createButton:followImage];
    followButton.frame = CGRectMake(240, 16, followImage.size.width, followImage.size.height);
    //    [followButton setBackgroundImage:unfollowImage forState:UIControlStateSelected];
    [followButton setTitle:NSLocalizedString(@"Follow", @"Follow") forState:UIControlStateNormal];
    //    [followButton setTitle:NSLocalizedString(@"Unfollow", @"Unfollow") forState:UIControlStateSelected];
    //    followButton.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleBoldFont];
    UIFont *famFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    followButton.titleLabel.font = famFont;
    followButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    [followButton addTarget:self action:@selector(followBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIScrollView *imageContain = [[FloggerUIFactory uiFactory] createScrollView];
    imageContain.frame = CGRectMake(60, 60, 260, 85+15);
    imageContain.userInteractionEnabled = YES;
    
    int viewWidth = 75;
    int viewHeight = 75;
    int imageContainHeight = 123-120;
    UIImage *playImage = [[FloggerUIFactory uiFactory] createImage:SNS_PLAY_BUTTON];
    CGRect playRect = CGRectMake((viewWidth - playImage.size.width) / 2, (viewHeight - playImage.size.height) / 2, playImage.size.width, playImage.size.height);
    
    
    UIButton *imageV1 = [[FloggerUIFactory uiFactory] createButton:nil];
    imageV1.frame = CGRectMake(5, imageContainHeight, viewWidth, viewHeight);
    imageV1.tag = 0;
    [imageV1 addTarget:self action:@selector(issueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV1p = [[FloggerUIFactory uiFactory] createImageView:nil];
    imageV1p.frame = playRect;
    [imageV1 addSubview:imageV1p];
    
    UIButton *imageV2 = [[FloggerUIFactory uiFactory] createButton:nil];
    imageV2.frame = CGRectMake(85, imageContainHeight, viewWidth, viewHeight);
    imageV2.tag = 1;
    [imageV2 addTarget:self action:@selector(issueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV2p = [[FloggerUIFactory uiFactory] createImageView:nil];
    imageV2p.frame = playRect;
    [imageV2 addSubview:imageV2p];
    
    UIButton *imageV3 = [[FloggerUIFactory uiFactory] createButton:nil];
    imageV3.frame = CGRectMake(165, imageContainHeight, viewWidth, viewHeight);
    imageV3.tag = 2;
    [imageV3 addTarget:self action:@selector(issueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV3p = [[FloggerUIFactory uiFactory] createImageView:nil];
    imageV3p.frame = playRect;
    [imageV3 addSubview:imageV3p];
    
    UIButton *imageV4 = [[FloggerUIFactory uiFactory] createButton:nil];
    imageV4.frame = CGRectMake(245, imageContainHeight, viewWidth, viewHeight);
    imageV4.tag = 3;
    [imageV4 addTarget:self action:@selector(issueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV4p = [[FloggerUIFactory uiFactory] createImageView:nil];
    imageV4p.frame = playRect;
    [imageV4 addSubview:imageV4p];
    
    
    //    UILabel *lineLab = [[FloggerUIFactory uiFactory] createLable];
    //   lineLab.frame = CGRectMake(0, labelHeight, 320, 1);
    //    lineLab.backgroundColor =  [UIColor colorWithRed:181/255.0  green:180/255.0 blue:174/255.0 alpha:1.0];
    //    
    //    NSLog(@"labelHeight=====%d",labelHeight);
    //    
    //    UILabel *lineLab2 = [[FloggerUIFactory uiFactory] createLable];
    //    lineLab2.frame = CGRectMake(0, labelHeight+1, 320, 1);
    ////    lineLab2.frame = CGRectMake(0, imageContainHeight+1, 320, 1);
    //    lineLab2.backgroundColor =  [UIColor whiteColor];
    
    //    [imageContain addSubview:imageV1];
    //    [imageContain addSubview:imageV2];
    //    [imageContain addSubview:imageV3];
    //    [imageContain addSubview:imageV4];
    
    /* UIImageView *imageV1 = [[FloggerUIFactory uiFactory] createImageView:nil];
     imageV1.frame = CGRectMake(5, 123, viewWidth, viewHeight);
     UIImageView *imageV1p = [[FloggerUIFactory uiFactory] createImageView:nil];
     imageV1p.frame = playRect;
     [imageV1 addSubview:imageV1p];
     
     UIImageView *imageV2 = [[FloggerUIFactory uiFactory] createImageView:nil];
     imageV2.frame = CGRectMake(85, 123, viewWidth, viewHeight);
     UIImageView *imageV2p = [[FloggerUIFactory uiFactory] createImageView:nil];
     imageV2p.frame = playRect;
     [imageV2 addSubview:imageV2p];
     
     UIImageView *imageV3 = [[FloggerUIFactory uiFactory] createImageView:nil];
     imageV3.frame = CGRectMake(165, 123, viewWidth, viewHeight);
     UIImageView *imageV3p = [[FloggerUIFactory uiFactory] createImageView:nil];
     imageV3p.frame = playRect;
     [imageV3 addSubview:imageV3p];
     
     UIImageView *imageV4 = [[FloggerUIFactory uiFactory] createImageView:nil];
     imageV4.frame = CGRectMake(245, 123, viewWidth, viewHeight);
     UIImageView *imageV4p = [[FloggerUIFactory uiFactory] createImageView:nil];
     imageV4p.frame = playRect;
     [imageV4 addSubview:imageV4p];*/
    //    [self addSubview:lineLab];
    //    [self addSubview:lineLab2];
    //    [self addSubview:iconImageV];
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:userLab];
    [self.contentView addSubview:followLab];
    //    [self addSubview:descriptionLab];
    if ([GlobalUtils checkIsLogin]) {
        [self.contentView addSubview:followButton];
    }
    
    [self.contentView addSubview:imageContain];
    
    [self setIconView:iconImageV];
    [self setImageView1P:imageV1p];
    [self setImageView1P:imageV1p];
    [self setImageView1P:imageV1p];
    [self setImageView1P:imageV1p];
    
    [self setBtn1:imageV1];
    [self setBtn2:imageV2];
    [self setBtn3:imageV3];
    [self setBtn4:imageV4];
    
    [self setUserLabel:userLab];
    [self setFollowerLabel:followLab];
    //    [self setDescriptionLabel:descriptionLab];
    [self setFollowBtn:followButton];
    [self setImageContainerView:imageContain];
    
    //    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //    //    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //    self.backgroundColor = [UIColor clearColor];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self adjustSuggestUserViewCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

/*-(void) prepareForReuse
 {
 [super prepareForReuse];
 
 //    @property(nonatomic, retain) MyAccount *account;
 //    @property(nonatomic, assign) id delegate;
 //    @property(nonatomic, retain) UIImageView *iconView;
 //    @property(nonatomic, retain) UIImageView *imageView1, *imageView1P, *imageView2, *imageView2P, *imageView3, *imageView3P, *imageView4, *imageView4P;
 //    @property(nonatomic, retain) UIButton *btn1, *btn2, *btn3, *btn4;
 //    @property(nonatomic, retain) UILabel *userLabel, *followerLabel, *descriptionLabel;
 //    @property(nonatomic, retain) UIButton *followBtn;
 //    
 //    @property(nonatomic, retain) UIView *imageContainerView;
 //    
 self.imageView1 = nil;
 self.imageView2 = nil;
 self.imageView3 = nil;
 self.imageView4 = nil;
 
 self.imageView1P = nil;
 self.imageView2P = nil;
 self.imageView3P = nil;
 self.imageView4P = nil;
 
 self.btn1 = nil;
 self.btn2 = nil;
 self.btn3 = nil;
 self.btn4 = nil;
 
 self.iconView = nil;
 self.userLabel = nil;
 self.followBtn = nil;
 self.followerLabel = nil;
 self.descriptionLabel = nil;
 
 self.imageContainerView = nil;
 }*/

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
    
    self.btn1 = nil;
    self.btn2 = nil;
    self.btn3 = nil;
    self.btn4 = nil;
    
    self.iconView = nil;
    self.userLabel = nil;
    self.followBtn = nil;
    self.followerLabel = nil;
    self.descriptionLabel = nil;
    
    self.imageContainerView = nil;
    [super dealloc];
}

-(void)updateFollowBtn
{
    if ([self.account.followed boolValue]) {
        [self.followBtn setBackgroundImage:[UIImage imageNamed:@"New_Unfollow_Button.png"] forState:UIControlStateNormal];
        [self.followBtn setTitle:NSLocalizedString(@"Unfollow", @"Unfollow") forState:UIControlStateNormal];
    }
    else
    {
        [self.followBtn setBackgroundImage:[UIImage imageNamed:@"New_Follow_Button.png"]forState:UIControlStateNormal];
        [self.followBtn setTitle:NSLocalizedString(@"Follow", @"Follow") forState:UIControlStateNormal];
    }
}

//-(BOOL)checkAccount
//{
//    if([self.account.useruid isEqualToNumber:[GlobalData sharedInstance].myAccount.account.useruid])
//        return YES;
//    else
//        return NO;
//}

-(void)setAccount:(MyAccount *)account
{
    UIImage *cellPlaceHolder = [[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PHOTO];
    if (_account != account) {
        [_account release];
        _account = [account retain];;
    }
    
    //头像
    if (self.account.imageurl) {
        self.iconView.backgroundColor=RGBCOLOR(61, 67, 75);
        [self.iconView setImageWithURL:[NSURL URLWithString:self.account.imageurl] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PROFILE_PICTURE]];
    }
    if (self.account.fname && self.account.fname.length > 0) {
        //        NSLog(@"username fname is %@",self.account.fname);
        self.userLabel.text = self.account.fname;//[NSString stringWithFormat:@"%@%@", account.fname,account.lname];
    } else
    {
        self.userLabel.text = account.username;
    }
    
    //    self.followerLabel.text = [NSString stringWithFormat:@"%d", [account.followerscount intValue]];
    self.followerLabel.text = [NSString stringWithFormat:@"@%@", account.username];
    
    if (self.account.status) {
        //todo 
        //        self.descriptionLabel.text = account.status;
        self.descriptionLabel.hidden = NO;
    }
    else
    {
        self.descriptionLabel.hidden = YES;
    }
    
    //    self.account.description
    
    if (self.account.issueList && self.account.issueList.count > 0) {
        //        statements
        [self.imageContainerView setHidden:NO];
        for (UIView *view in self.imageContainerView.subviews) {
            [view removeFromSuperview];
        }        
        //        self.imageContainerView 
        //        CGFloat mediaHeight = 90.0;
        CGFloat mediaHeight = 90.0;
        //        CGFloat defaultWidth = 68;
        CGFloat defaultWidth = 90.0;
        //        int totalWidth = 0;
        int totalWidth = 1;
        CGSize contentSize = CGSizeZero;
        int imageViewTag = 0;
        for (MyIssueInfo *issueInfo in account.issueList) { 
            int thumbnailWidth;
            int thumbNailHeight;
            if (!issueInfo.thumbnailWidth || !issueInfo.thumbnailHeight) {
                thumbnailWidth = 0;
                thumbNailHeight = 0;
            } else {
                thumbnailWidth = [issueInfo.thumbnailWidth intValue];
                thumbNailHeight = [issueInfo.thumbnailHeight intValue];
            }
            
            UIView *floggerContainer = [[[UIView alloc]init]autorelease];//[[[FloggerImageView alloc]init]autorelease];
            floggerContainer.backgroundColor = RGBCOLOR(0x3d, 0x43, 0x4b);//3d434b
            FloggerButtonView *tempImageViewBtn = [[[FloggerButtonView alloc]init]autorelease];//[[FloggerUIFactory uiFactory] createButton:nil];
            tempImageViewBtn.applyAnimation=YES;
            tempImageViewBtn.backgroundColor=RGBCOLOR(61, 67, 75);
            if (thumbNailHeight > 0) {
                floggerContainer.frame = CGRectMake(totalWidth, 0, thumbnailWidth * mediaHeight/thumbNailHeight, mediaHeight);//tempImageViewBtn
                tempImageViewBtn.frame = CGRectMake(0, 0, thumbnailWidth * mediaHeight/thumbNailHeight, mediaHeight);
                totalWidth += thumbnailWidth * mediaHeight/thumbNailHeight + 5;
            } else {
                floggerContainer.frame = CGRectMake(totalWidth, 0, defaultWidth, mediaHeight);//tempImageViewBtn
                tempImageViewBtn.frame = CGRectMake(0, 0, defaultWidth, mediaHeight);
                totalWidth += defaultWidth + 5;
            }                        
            //            tempImageViewBtn.backgroundColor = [UIColor blueColor];
            
            //            tempImageViewBtn.layer.cornerRadius = 3;
            //            tempImageViewBtn.layer.masksToBounds = YES;
            //            NSLog(@"scalethunbnailurl is %@",issueInfo.scalethumbnailurl);
            
            tempImageViewBtn.tag = imageViewTag;
            imageViewTag++;
            [tempImageViewBtn addTarget:self action:@selector(issueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            //video
            if ([issueInfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO) {
                [tempImageViewBtn setImageWithURL:[NSURL URLWithString:issueInfo.scalethumbnailurl] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_VIDEO]];
                int playWidth = 30;
                UIImage *playImage = [[FloggerUIFactory uiFactory] createImage:SNS_FEED_THUMBNAIL_PLAY];
                UIImageView *btnImage = [[FloggerUIFactory uiFactory] createImageView:playImage];
                btnImage.frame = CGRectMake(3, mediaHeight- 13.5, playImage.size.width, playImage.size.height);
                
                UIView *viewPlay = [[FloggerUIFactory uiFactory] createView];
                
                
                viewPlay.frame = CGRectMake(0, mediaHeight- 15, tempImageViewBtn.frame.size.width, 15);
                viewPlay.backgroundColor=[UIColor blackColor];
                viewPlay.alpha=0.5;
                
                
                UILabel *videoTimeLable=[[FloggerUIFactory uiFactory] createLable];
                videoTimeLable.text=[GlobalUtils displayableStrFromVideoduration:[issueInfo.videoduration intValue]];
                videoTimeLable.textColor=[UIColor whiteColor];
                videoTimeLable.textAlignment = UITextAlignmentRight;
                videoTimeLable.frame = CGRectMake(0, mediaHeight - 13, tempImageViewBtn.frame.size.width-2, 11);
                videoTimeLable.font=[[FloggerUIFactory uiFactory] createSamllVideoTimeFont];
                videoTimeLable.backgroundColor=[UIColor clearColor];
                
                [tempImageViewBtn addSubview:viewPlay]; 
                [tempImageViewBtn addSubview:videoTimeLable];
                [tempImageViewBtn addSubview:btnImage]; 
            }
            //************add layout****************//
            tempImageViewBtn.layer.borderWidth=2;
            tempImageViewBtn.layer.borderColor=[[UIColor whiteColor]CGColor];
            tempImageViewBtn.layer.shadowColor = [[UIColor grayColor] CGColor];
            tempImageViewBtn.layer.shadowOffset = CGSizeMake(0, 1);
            tempImageViewBtn.layer.shadowRadius = 1;
            tempImageViewBtn.layer.shadowOpacity = 0.5;
            tempImageViewBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:tempImageViewBtn.bounds]CGPath];
            [tempImageViewBtn setImageWithURL:[NSURL URLWithString:issueInfo.scalethumbnailurl] placeholderImage:cellPlaceHolder];
            [self.imageContainerView addSubview:floggerContainer];//tempImageViewBtn];
            [floggerContainer addSubview:tempImageViewBtn];
            contentSize = CGSizeMake(totalWidth, mediaHeight);
        }
        [self.imageContainerView setContentSize:contentSize];
        [self.imageContainerView setCanCancelContentTouches: NO];
        
    } else {
        [self.imageContainerView setHidden:YES];
    }
    
    
    
    
    /*if (self.account.issueList && self.account.issueList.count > 0) {
     self.imageContainerView.hidden = NO;
     
     self.imageView1.hidden = YES;
     self.imageView1P.hidden = YES;
     self.imageView2.hidden = YES;
     self.imageView2P.hidden = YES;
     self.imageView3.hidden = YES;
     self.imageView3P.hidden = YES;
     self.imageView4.hidden = YES;
     self.imageView4P.hidden = YES;
     
     self.btn1.hidden = YES;
     self.btn2.hidden = YES;
     self.btn3.hidden = YES;
     self.btn4.hidden = YES;
     
     int i = 0;
     for (Issueinfo *issueInfo in account.issueList) {
     if (i == 0) {
     //                [self.imageView1 setImageWithURL:[NSURL URLWithString:issueInfo.thumbnailurl]];
     [self.btn1 setImageWithURL:[NSURL URLWithString:issueInfo.thumbnailurl] placeholderImage:cellPlaceHolder];
     
     
     self.imageView1P.hidden = [issueInfo.issuecategory intValue] != ISSUE_CATEGORY_VIDEO;
     self.imageView1.hidden = NO;
     self.btn1.hidden = NO;
     }
     else if(i == 1)
     {
     //                [self.imageView2 setImageWithURL:[NSURL URLWithString:issueInfo.thumbnailurl]];
     [self.btn2 setImageWithURL:[NSURL URLWithString:issueInfo.thumbnailurl] placeholderImage:cellPlaceHolder];
     self.imageView2P.hidden = [issueInfo.issuecategory intValue] != ISSUE_CATEGORY_VIDEO;
     self.imageView2.hidden = NO;
     self.btn2.hidden = NO;
     }
     else if(i == 2)
     {
     //                [self.imageView3 setImageWithURL:[NSURL URLWithString:issueInfo.thumbnailurl]];
     [self.btn3 setImageWithURL:[NSURL URLWithString:issueInfo.thumbnailurl] placeholderImage:cellPlaceHolder];
     self.imageView3P.hidden = [issueInfo.issuecategory intValue] != ISSUE_CATEGORY_VIDEO;
     self.imageView3.hidden = NO;
     self.btn3.hidden = NO;
     }
     else
     {
     //                [self.imageView4 setImageWithURL:[NSURL URLWithString:issueInfo.thumbnailurl]];
     [self.btn4 setImageWithURL:[NSURL URLWithString:issueInfo.thumbnailurl] placeholderImage:cellPlaceHolder];
     self.imageView4P.hidden = [issueInfo.issuecategory intValue] != ISSUE_CATEGORY_VIDEO;
     self.imageView4.hidden = NO;
     self.btn4.hidden = NO;
     }
     
     i ++;
     }
     }
     else
     {
     self.imageContainerView.hidden = YES;
     }*/
    
    
    //follow unfollow
    if ([GlobalUtils checkIsOwner:self.account]) {
        [self.followBtn setHidden:YES];
    } else {
        [self.followBtn setHidden:NO];
    }
    //    if (self.) {
    //        <#statements#>
    //    }
    
    //    if (self.mode == ComeFromNewFriendListView && [self.account.followed boolValue]) {
    //        [self.followBtn setHidden:YES];
    //    }
    
    [self updateFollowBtn];
    //    if ([account.followed boolValue]) {
    //        self.followBtn.selected = true;
    //    } else {
    //        self.followBtn.selected = false;
    //    }
    int currentHight;
    if(account.issueList && account.issueList.count > 0)
    {
        currentHight = 143+15;
    } else {
        currentHight = 60;
    }
    
    UILabel *lineLab = [[FloggerUIFactory uiFactory] createLable];
    lineLab.frame = CGRectMake(0, currentHight, 320, 1);
    lineLab.backgroundColor =  [UIColor colorWithRed:181/255.0  green:180/255.0 blue:174/255.0 alpha:1.0];
    lineLab.tag = 150;
    
    
    UILabel *lineLab2 = [[FloggerUIFactory uiFactory] createLable];
    lineLab2.frame = CGRectMake(0, currentHight+1, 320, 1);
    lineLab2.backgroundColor =  [UIColor whiteColor];
    lineLab2.tag = 151;
    [self.contentView addSubview:lineLab];
    [self.contentView addSubview:lineLab2];
    
}


/*- (void)layoutSubviews {
 [super layoutSubviews];
 
 CGRect frame = self.frame;
 
 frame = CGRectMake(self.iconView.frame.origin.x, self.iconView.frame.origin.y, kPhotoSize, kPhotoSize);
 self.iconView.frame = frame;
 
 CGFloat y = kVGap;
 CGFloat height = [self.account.username sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(150, CGFLOAT_MAX)].height;
 frame = CGRectMake(self.userLabel.frame.origin.x, y, self.userLabel.frame.size.width, height);
 self.userLabel.frame = frame;
 
 y += height + kVLGap;
 
 height = [self.followerLabel.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(150, CGFLOAT_MAX)].height;
 
 frame = CGRectMake(self.followerLabel.frame.origin.x, y, self.followerLabel.frame.size.width, height);
 self.followerLabel.frame = frame;
 
 y += height + kVLGap;
 CGFloat desHeight = [[self.account.dataDict objectForKey:kDescriptionHeight] floatValue];
 if (desHeight > 0) {
 frame = CGRectMake(self.descriptionLabel.frame.origin.x, y, self.descriptionLabel.frame.size.width, desHeight);
 self.descriptionLabel.frame = frame;
 //        self.descriptionLabel.hidden = NO;
 y += desHeight + kVGap;
 }
 else
 {
 y += kVGap;
 //        self.descriptionLabel.hidden = YES;
 }
 
 if (self.account.issueList && self.account.issueList.count > 0) {
 CGFloat topHeight = [[self.account.dataDict objectForKey:kSuggestTopHeight] floatValue];
 frame = CGRectMake(self.imageContainerView.frame.origin.x, topHeight, self.imageContainerView.frame.size.width, kImageHeight);
 self.imageContainerView.frame = frame;
 //        self.imageContainerView.hidden = NO;
 }
 else
 {
 //        self.imageContainerView.hidden = YES;
 }
 }*/

-(void)followBtnClicked:(id)sender
{    
    if (self.delegate && [self.delegate respondsToSelector:@selector(suggestUserViewCell:didActionOnAccount:)]) {
        [self.delegate suggestUserViewCell:self didActionOnAccount:self.account];
    }
    
    BOOL followed = ![self.account.followed boolValue];
    self.account.followed = [NSNumber numberWithBool:followed];
    //    NSInteger friendsCount = [[GlobalData sharedInstance].myAccount.account.friendscount intValue];
    //    if (followed) {
    //        friendsCount ++;
    //    }
    //    else {
    //        friendsCount --;
    //    }
    //    [GlobalData sharedInstance].myAccount.account.friendscount = [NSNumber numberWithInt:friendsCount];
    self.followBtn.selected = !self.followBtn.isSelected;
    
    [self updateFollowBtn];
    
    //    if(self.mode == ComeFromNewFriendListView)
    //    {
    //        [self.followBtn setHidden:YES];
    //        self.account.followed = [NSNumber numberWithBool:!followed];
    //    }
    
    //    if(self.mode==ComeFromNewFriendListView&&self.followBtn.selected==YES){
    //         [self.followBtn setHidden:YES];
    //    }
    
    
}

-(void)issueBtnClicked:(id)sender
{
    NSInteger index = ((UIButton *)sender).tag;
    if(self.delegate && [self.delegate respondsToSelector:@selector(suggestUserViewCell:didSelectedAtIssueInfo:)])
    {
        Issueinfo *issueinfo = [self.account.issueList objectAtIndex:index];
        [self.delegate suggestUserViewCell:self didSelectedAtIssueInfo:issueinfo];
    }
    
}
@end
