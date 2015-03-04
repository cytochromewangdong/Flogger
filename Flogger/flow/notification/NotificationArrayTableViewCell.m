//
//  NotificationArrayTableViewCell.m
//  Flogger
//
//  Created by steveli on 17/03/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "NotificationArrayTableViewCell.h"
#import "FloggerWebView.h"
#import "FloggerWebAdapter.h"
#import "TagFeedViewController.h"
//#define kNotificationTableViewCellContentHeight 75
//#define kNotificationTableViewCellImageHeight 65
//#define kNotificationTableViewCellTwoImageHeight 75

//#define kTitleHeight @"kTitleHeight"
//#define kVGap 5
//#define kVLGap 2
#define NON_PROFILE_IMAGE_BORDER_WIDTH 2
#define FOLLOW_IMAGE_BORDER_WIDTH 2
#define PICSCONTAINER_WIDTH 242

@implementation NotificationArrayTableViewCell

@synthesize celldelegate,mainview,scrollView;
+(NSString *)getActionStrByTypeWithCount:(ActionType)actionType count:(NSInteger)count
{
    NSString *str = nil;
    switch (actionType) {
        case ACTION_FOLLOW:
            str = [NSString stringWithFormat:NSLocalizedString(@"%@%d people",@"%@%d people"), NSLocalizedString(@"has followed on ", @"has followed on "), count];
            break;
        case ACTION_RESPONE_VIDEO:
            str = [NSString stringWithFormat:NSLocalizedString(@"%@%d",@"%@%d video"), NSLocalizedString(@"has commented on ", @"has commented on "), count];
            break;
        case ACTION_RESPONE_PHOTO:    
            str = [NSString stringWithFormat:NSLocalizedString(@"%@%d",@"%@%d photo"), NSLocalizedString(@"has commented on ", @"has commented on "), count];
            break;
        case ACTION_LIKE:
            str = [NSString stringWithFormat:@"%@%d", NSLocalizedString(@"has liked on ", @"has liked on "), count];
            break;
        default:
            break;
    }
    
    return str;
}


+(NSString *)getActionStrByType:(ActionType)actionType andTargetName:(NSString *)name
{
    NSString *str = nil;
    switch (actionType) {
        case ACTION_FOLLOW:
            str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>", NSLocalizedString(@"has followed on ", @"has followed on "), name];
            break;
        case ACTION_AT:
            str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>", NSLocalizedString(@"has tagged on ", @"has tagged on "), name];
            break;   
        case ACTION_RESPONE_WEIBO:
        case ACTION_RESPONE_VIDEO:
        case ACTION_RESPONE_PHOTO:    
            str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>", NSLocalizedString(@"has commented on ", @"has commented on "), name];
            break;
            
        case ACTION_LIKE:
            str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>", NSLocalizedString(@"has liked on ", @"has liked on "), name];
            break;
        default:
            break;
    }
    
    return str;
}
//andParentId:(NSNumber *)parentId 
+(NSString *)getActionStrByType:(ActionType)actionType   andParentType:(ParentType)parentType  andParentId:(NSNumber *)parentId andTargetName:(NSString *)name
{
    NSString *str = nil;
    switch (actionType) {
        case ACTION_FOLLOW:
            str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>", NSLocalizedString(@"has followed on ", @"has followed on "), name];
            break;
        case ACTION_AT:
            switch (parentType) {
                case PARENT_PHOTO:
                    str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>%@", NSLocalizedString(@"has tagged on ", @"has tagged on "), name,NSLocalizedString(@"in photo", @"in photo")];
                    break;
                case PARENT_VIDEO:
                    str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>%@", NSLocalizedString(@"has tagged on ", @"has tagged on "), name,NSLocalizedString(@"in video", @"in video")];
                    break;
                case PARENT_WEIBO:
                    if (parentId!=nil&&[parentId longLongValue]>0) {
                          str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>%@", NSLocalizedString(@"has tagged on ", @"has tagged on "), name,NSLocalizedString(@"in comment", @"in comment")];
                    }else{
                    str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>%@", NSLocalizedString(@"has tagged on ", @"has tagged on "), name,NSLocalizedString(@"in shout", @"in shout")];
                    }
                    break;
                default:
                    break;
            }
            break;   
        case ACTION_RESPONE_WEIBO:
        case ACTION_RESPONE_VIDEO:
        case ACTION_RESPONE_PHOTO:    
            str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>", NSLocalizedString(@"has commented on ", @"has commented on "), name];
            break;
            
        case ACTION_LIKE:
            str = [NSString stringWithFormat:@"%@<span class='importantBold'>%@</span>", NSLocalizedString(@"has liked on ", @"has liked on "), name];
            break;
        default:
            break;
    }
    
    return str;
}

+(NSString *)getTargetStrByIssueCategory:(IssueInfoCategory)category{
    NSString *str = nil;
    
    switch (category) {
        //case ISSUE_CATEGORY_TWEET:

        //    break;
            
        case ISSUE_CATEGORY_PICTURE:
            str = NSLocalizedString(@"photo", @"photo");
            break;
            
        case ISSUE_CATEGORY_VIDEO: 
            str = NSLocalizedString(@"video", @"video");
            break;
        default:
            str = NSLocalizedString(@"Weibo", @"Weibo");
            break;
    }
    str = [NSString stringWithFormat:@"<span class='importantBold'>%@</span>", str];
    return str;
}

+(NSString *)getTargetStrByIssueCategoryMany:(IssueInfoCategory)category{
    NSString *str = nil;
    
    switch (category) {
            //case ISSUE_CATEGORY_TWEET:
            
            //    break;
            
        case ISSUE_CATEGORY_PICTURE:
            str = NSLocalizedString(@"photos", @"photos");
            break;
            
        case ISSUE_CATEGORY_VIDEO: 
            str = NSLocalizedString(@"videos", @"videos");
            break;
        default:
            str = NSLocalizedString(@"Weibo", @"Weibo");
            break;
    }
    str = [NSString stringWithFormat:@"<span class='importantBold'>%@</span>", str];
    return str;
}

+(NSString *)getArrayNotificationStr:(ActivityResultEntity *)notification count:(NSInteger)count
{
    NSString *str = nil;
    if ([notification.actiontype intValue] < ACTION_AT) {
        if (count>1) {
            str = [NSString stringWithFormat:@"<span class='importantBold'>%@ </span>%@ %@", notification.username, [NotificationArrayTableViewCell getActionStrByTypeWithCount:[notification.actiontype intValue] count:count ], [NotificationArrayTableViewCell getTargetStrByIssueCategoryMany:[notification.parenttype intValue]]];
        }else{
            str = [NSString stringWithFormat:@"<span class='importantBold'>%@ </span>%@ %@", notification.username, [NotificationArrayTableViewCell getActionStrByTypeWithCount:[notification.actiontype intValue] count:count ], [NotificationArrayTableViewCell getTargetStrByIssueCategory:[notification.parenttype intValue]]];
        }
    }
    else
    { 
        str = [NSString stringWithFormat:@"<span class='importantBold'>%@</span> %@", notification.username, [NotificationArrayTableViewCell getActionStrByTypeWithCount:[notification.actiontype intValue] count:count]];
    }
    return str;
    
}

+(NSString *)getNotificationStr:(ActivityResultEntity *)notification
{
    NSString *str = nil;
    NSString *name = notification.targetusername;
    if ([notification.actiontype intValue] < ACTION_AT)
    {
        if ([GlobalUtils checkIsOwnerByUserUID:[notification.targetuseruid longLongValue]])
        {
            name = NSLocalizedString(@"your ", @"your ");
        }
        else
        {
            name = [NSString stringWithFormat:NSLocalizedString(@"%@'s ", @"%@'s "), name];
        }
        //andParentId:[notification.parentid]
        str = [NSString stringWithFormat:@"<span class='importantBold'>%@</span> %@%@", notification.username, [NotificationArrayTableViewCell getActionStrByType:[notification.actiontype intValue] andParentType:[notification.parenttype intValue]  andParentId:notification.parentid andTargetName:name ], [NotificationArrayTableViewCell getTargetStrByIssueCategory:[notification.parenttype intValue]]];
    }
    else
    {
        if (!name || [GlobalUtils checkIsOwnerByUserUID:[notification.targetuseruid longLongValue]]) {
            name = NSLocalizedString(@"you", @"you");
        }
        
        str = [NSString stringWithFormat:@"<span class='importantBold'>%@</span> %@", notification.username, [NotificationArrayTableViewCell getActionStrByType:[notification.actiontype intValue] andParentType:[notification.parenttype intValue] andParentId:notification.parentid  andTargetName:name]];
    }
    return str;
}


+(NSMutableDictionary *)createParamFromEntries:(NSMutableArray*)data
{    
    NSMutableDictionary* dict = [[[NSMutableDictionary alloc]init]autorelease];
    FloggerLayoutParam *paramContainer = [[[FloggerLayoutParam alloc]init]autorelease];
    [dict setObject:paramContainer forKey:@"picsContainer"];
    GLfloat heightOfScroll = kPhotoVideoHeight+NON_PROFILE_IMAGE_BORDER_WIDTH * 2+2;
    if([[data objectAtIndex:0] isKindOfClass:[ExternalFriendGroup class]])
    {
        heightOfScroll = kFollowProfileImageSideLen+FOLLOW_IMAGE_BORDER_WIDTH*2;
        paramContainer.height = heightOfScroll;
        //paramContainer = [[[FloggerLayoutParam alloc]init]autorelease];
        //[dict setObject:paramContainer forKey:@"profileImage"];
        //paramContainer.actionType = NONE_ACTION;

        paramContainer = [[[FloggerLayoutParam alloc]init]autorelease];
        [dict setObject:paramContainer forKey:@"blockForAction"];
        paramContainer.userEnabled = USER_INTERACTION_DISABLED;
        
        paramContainer = [[[FloggerLayoutParam alloc]init]autorelease];
        [dict setObject:paramContainer forKey:@"topContainer"];
        paramContainer.actionType = RECOMMAND_CLICK_EVENT;
        
        return dict;
    }
    ActivityResultEntity* mainEntry = [data objectAtIndex:0];
    if(mainEntry.actiontype.intValue == ACTION_FOLLOW)
    {
//        heightOfScroll = kFollowProfileImageSideLen;
          heightOfScroll = kFollowProfileImageSideLen+FOLLOW_IMAGE_BORDER_WIDTH*2;
    }
    paramContainer.height = heightOfScroll;

    if(mainEntry.parenttype.intValue == PARENT_WEIBO||mainEntry.actiontype.intValue ==ACTION_AT)
    {
        FloggerLayoutParam *paramDesc = [[[FloggerLayoutParam alloc]init]autorelease];
        [dict setObject:paramDesc forKey:@"desc"];
        NSString *actionForClick = PARENT_IMAGE_CLICK_EVENT;
        if(mainEntry.actiontype.intValue ==ACTION_AT)
        {
            actionForClick = AT_CLICK_EVENT;
        }
        paramDesc.actionType = actionForClick;
        
        paramDesc = [[[FloggerLayoutParam alloc]init]autorelease];
        [dict setObject:paramDesc forKey:@"textContainer"];
        paramDesc.actionType = actionForClick;

    
        paramDesc = [[[FloggerLayoutParam alloc]init]autorelease];
        [dict setObject:paramDesc forKey:@"desc2"];
    
        paramDesc.actionType = actionForClick;
    }
    return dict;
}
+(NSMutableDictionary*)createInvisibleList:(NSMutableArray *)data
{
    ActivityResultEntity* mainEntry = [data objectAtIndex:0];
    NSMutableDictionary *list = [[[NSMutableDictionary alloc]init]autorelease];
    if([[data objectAtIndex:0] isKindOfClass:[ExternalFriendGroup class]])
    {
        [list setObject:@"textContainer" forKey:@"textContainer"];
        return list;
    }
    if(((mainEntry.actiontype.intValue ==ACTION_RESPONE_WEIBO || mainEntry.actiontype.intValue == ACTION_LIKE)
       && mainEntry.parenttype.intValue == PARENT_WEIBO)||mainEntry.actiontype.intValue ==ACTION_AT)
    {
        [list setObject:@"picsContainer" forKey:@"picsContainer"];
    } 
    if(((mainEntry.actiontype.intValue ==ACTION_RESPONE_WEIBO)
        && mainEntry.parenttype.intValue == PARENT_WEIBO)||mainEntry.actiontype.intValue ==ACTION_AT||(mainEntry.actiontype.intValue ==ACTION_LIKE&&[mainEntry.parenttype intValue]==PARENT_WEIBO))
    { 
    }
    else {
        [list setObject:@"textContainer" forKey:@"textContainer"];
    }
    if(mainEntry.actiontype.intValue == ACTION_FOLLOW && [GlobalUtils checkIsOwnerByUserUID:mainEntry.targetuseruid.longLongValue])
    {
        [list setObject:@"picsContainer" forKey:@"picsContainer"]; 
    }
    NSString * topMsg =  data.count == 1 ? [NotificationArrayTableViewCell getNotificationStr:mainEntry]:[NotificationArrayTableViewCell getArrayNotificationStr:mainEntry count:data.count];
    [mainEntry.dataDict setObject:topMsg forKey:@"topHypertext"];
    return list;
}
-(UIScrollView*) getScrollView
{
    FloggerViewAdpater* picsContainer = [self.mainview getAdpaterByName:@"picsContainer"];
        //picsContainer.view.frame = CGRectMake(0, 100, 300, 90);
    return (UIScrollView*)picsContainer.view;
    /*if(!self.scrollView)
    {
        self.scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, 300, 75)];
    }
    return self.scrollView;*/
}
-(void) adjustNotificationTableView
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self adjustNotificationTableView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) fillRecommendUserScrollView
{
    _imageCount = 0;
    //    CGFloat contentWidth = 0;
    CGFloat contentWidth = 1;
    NSMutableArray *allTogether = [[[NSMutableArray alloc]init]autorelease];
    for (ExternalFriendGroup *entity in _entries)
    {
        [allTogether addObjectsFromArray:entity.externalfriendsList];
    }
    for(MyAccount* entity in allTogether) 
    {
        FloggerImageView * followView = [[[FloggerImageView alloc]init]autorelease];
        followView.applyAnimation=TRUE;
        followView.userInteractionEnabled = YES;
        followView.actionDelegate = self;
        followView.layer.masksToBounds = YES;
        followView.layer.cornerRadius = kSmallImageRadius;
        followView.frame =  CGRectMake(FOLLOW_IMAGE_BORDER_WIDTH, FOLLOW_IMAGE_BORDER_WIDTH, kFollowProfileImageSideLen, kFollowProfileImageSideLen);
        UIImageView *followImage = [[[UIImageView alloc]init]autorelease];
        followImage.userInteractionEnabled = YES;
        followImage.frame=CGRectMake(contentWidth, 0, kFollowProfileImageSideLen+FOLLOW_IMAGE_BORDER_WIDTH*2, kFollowProfileImageSideLen+FOLLOW_IMAGE_BORDER_WIDTH*2);
        [followImage addSubview:followView];
        followImage.backgroundColor = [UIColor whiteColor] ;
        followImage.layer.cornerRadius = kSmallImageRadius;  
        
        //            followView.backgroundColor=RGBCOLOR(61, 67, 75);
        ////            NSLog(@"aaaae   %d",entity.targetimageurl.intValue);
        //            followView.frame = CGRectMake(contentWidth, 0, kFollowProfileImageSideLen, kFollowProfileImageSideLen);
        [followView setImageWithURL:[NSURL URLWithString:entity.imageurl] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PROFILE_PICTURE]];
        //            contentWidth += kFollowProfileImageSideLen + kImageSmallGap;
        contentWidth += kFollowProfileImageSideLen + kImageSmallGap+FOLLOW_IMAGE_BORDER_WIDTH*2;
        //            [[self getScrollView] addSubview:followView];
        [[self getScrollView] addSubview:followImage];
        followView.data = entity;
        followView.action = PROFILE_EVENT;
        
        _imageCount++;
    }
    //[self getScrollView].backgroundColor = [UIColor blueColor];
    //CGRect frame = [self getScrollView].frame;
    //if(contentWidth < frame.size.width)
    {
        //frame.size.width = contentWidth;
        //frame.size.height = kFollowProfileImageSideLen+FOLLOW_IMAGE_BORDER_WIDTH*2;
        //[self getScrollView].frame = frame;
    }
    _contentWidth = contentWidth;
    [[self getScrollView] setContentSize:CGSizeMake(contentWidth, kFollowProfileImageSideLen+FOLLOW_IMAGE_BORDER_WIDTH*2)];
}

-(void) fillFollowScrollView
{
    _imageCount = 0;
//    CGFloat contentWidth = 0;
    CGFloat contentWidth = 1;
    for (ActivityResultEntity *entity in _entries)
    {
        if(entity.targetimageurl)
        {
            FloggerImageView * followView = [[[FloggerImageView alloc]init]autorelease];
            followView.applyAnimation=TRUE;
            followView.userInteractionEnabled = YES;
            followView.actionDelegate = self;
//            followView.layer.masksToBounds = YES;
//            followView.layer.cornerRadius = kSmallImageRadius;
        
//            followView.layer.borderColor=[[UIColor whiteColor] CGColor];
//            followView.layer.borderWidth=2.0;
//            followView.layer.cornerRadius = kSmallImageRadius;
        
        followView.layer.masksToBounds = YES;
        followView.layer.cornerRadius = kSmallImageRadius;
        followView.frame =  CGRectMake(FOLLOW_IMAGE_BORDER_WIDTH, FOLLOW_IMAGE_BORDER_WIDTH, kFollowProfileImageSideLen, kFollowProfileImageSideLen);
        UIImageView *followImage = [[[UIImageView alloc]init]autorelease];
        followImage.userInteractionEnabled = YES;
        followImage.frame=CGRectMake(contentWidth, 0, kFollowProfileImageSideLen+FOLLOW_IMAGE_BORDER_WIDTH*2, kFollowProfileImageSideLen+FOLLOW_IMAGE_BORDER_WIDTH*2);
        [followImage addSubview:followView];
        followImage.backgroundColor = [UIColor whiteColor] ;
        followImage.layer.cornerRadius = kSmallImageRadius;  
        
//            followView.backgroundColor=RGBCOLOR(61, 67, 75);
////            NSLog(@"aaaae   %d",entity.targetimageurl.intValue);
//            followView.frame = CGRectMake(contentWidth, 0, kFollowProfileImageSideLen, kFollowProfileImageSideLen);
            [followView setImageWithURL:[NSURL URLWithString:entity.targetimageurl] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PROFILE_PICTURE]];
//            contentWidth += kFollowProfileImageSideLen + kImageSmallGap;
              contentWidth += kFollowProfileImageSideLen + kImageSmallGap+FOLLOW_IMAGE_BORDER_WIDTH*2;
//            [[self getScrollView] addSubview:followView];
        [[self getScrollView] addSubview:followImage];
            followView.data = entity;
            followView.action = PROFILE_EVENT;
        }
        _imageCount++;
    }

    _contentWidth = contentWidth;
    [[self getScrollView] setContentSize:CGSizeMake(contentWidth, kFollowProfileImageSideLen+FOLLOW_IMAGE_BORDER_WIDTH*2)];
    //[self getScrollView].frame = CGRectMake(kScrollLeft, kScrollTop, kScrollWidth, kFollowProfileImageSideLen);
}

-(void)fillOtherScrollView
{
    _imageCount = 0;
//    CGFloat contentWidth = 0;
    CGFloat contentWidth = 1;
    CGFloat contentHeight = kPhotoVideoHeight;
    UIImage *playImage = [[FloggerUIFactory uiFactory] createImage:SNS_FEED_THUMBNAIL_PLAY];
    for (ActivityResultEntity *entity in _entries) {
        if(entity.mediaUrl)
        {
           
            GLfloat tHeight =  entity.mediaheight? [entity.mediaheight floatValue]:kPhotoVideoHeight;
            GLfloat tWidth = entity.mediawidth?[entity.mediawidth floatValue]:kPhotoVideoHeight;
            tWidth = tWidth * kPhotoVideoHeight / tHeight;
            tHeight = kPhotoVideoHeight;
            FloggerImageView * imageView= [[[FloggerImageView alloc]init]autorelease];
            imageView.applyAnimation=TRUE;
            imageView.backgroundColor = RGBCOLOR(61, 67, 75);
            
//            NSLog(@"aaaas   %d",entity.actiontype.intValue);
            if (entity.actiontype.intValue==ACTION_RESPONE_PHOTO)  {
                [imageView setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:entity.mediaUrl]] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PHOTO]];
            }else if(entity.actiontype.intValue==ACTION_RESPONE_VIDEO){
                [imageView setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:entity.mediaUrl]] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_VIDEO]];

                UILabel *videoTimeLable=[[FloggerUIFactory uiFactory] createLable];
                videoTimeLable.text=[GlobalUtils displayableStrFromVideoduration:[entity.currentThread.videoduration intValue]];
                videoTimeLable.textColor=[UIColor whiteColor];//[[FloggerUIFactory uiFactory] createNumFontColor];
                videoTimeLable.textAlignment = UITextAlignmentRight;
                videoTimeLable.frame = CGRectMake(0, tHeight- 14, tWidth, 14);
                videoTimeLable.font=[[FloggerUIFactory uiFactory] createVideoTimeFont];
                videoTimeLable.backgroundColor=[UIColor clearColor];
                
              UIImageView *imageV1p = [[FloggerUIFactory uiFactory] createImageView:playImage];
              imageV1p.frame = CGRectMake(3, tHeight- 12.5, playImage.size.width, playImage.size.height);
                
                
                UIView *viewPlay = [[FloggerUIFactory uiFactory] createView];
                viewPlay.frame = CGRectMake(0, tHeight- 15, tWidth, 15);
                viewPlay.backgroundColor=[UIColor blackColor];
                viewPlay.alpha=0.5;
                /*等待后台时间给我
                UILabel *videoTimeLable=[[FloggerUIFactory uiFactory] createLable];
                videoTimeLable.text="";
                videoTimeLable.textColor=[UIColor whiteColor];
                videoTimeLable.textAlignment = UITextAlignmentRight;
                videoTimeLable.frame = CGRectMake(0, tHeight - 13, 15, 11);
                videoTimeLable.font=[[FloggerUIFactory uiFactory] createSamllVideoTimeFont];
                videoTimeLable.backgroundColor=[UIColor clearColor];
                */
                [imageView addSubview:viewPlay];
                [imageView addSubview:imageV1p];
                [imageView addSubview:videoTimeLable];
            }
           UIView *floggerContainer = [[[UIView alloc]init]autorelease];
            floggerContainer.backgroundColor = RGBCOLOR(0x3d, 0x43, 0x4b);//3d434b
            FloggerImageView * currentImageView = imageView;
            currentImageView.userInteractionEnabled = YES;
            currentImageView.actionDelegate = self;

//            currentImageView.frame =  CGRectMake(contentWidth, 0, tWidth, tHeight);
            currentImageView.frame =  CGRectMake(0, 0, tWidth, tHeight);
            floggerContainer.frame = CGRectMake(NON_PROFILE_IMAGE_BORDER_WIDTH, NON_PROFILE_IMAGE_BORDER_WIDTH, tWidth, tHeight);
            currentImageView.data = entity;
//            currentImageView.layer.cornerRadius = kBigImageRadius;
//            currentImageView.layer.masksToBounds = YES;
        
            //***************给currentImageView加border和shadow*********************//
            UIImageView *currentImage = [[[UIImageView alloc]init]autorelease];
            currentImage.userInteractionEnabled = YES;
            currentImage.frame=CGRectMake(contentWidth, 0, tWidth+NON_PROFILE_IMAGE_BORDER_WIDTH*2, tHeight+NON_PROFILE_IMAGE_BORDER_WIDTH*2);
            [currentImage addSubview:floggerContainer];
            [floggerContainer addSubview:currentImageView];
            
            currentImage.backgroundColor = [UIColor whiteColor];
            currentImage.layer.shadowColor = [[UIColor grayColor] CGColor];
            currentImage.layer.shadowOffset = CGSizeMake(0, 1);
            currentImage.layer.shadowRadius = 1;
            currentImage.layer.shadowOpacity = 0.5;
            currentImage.layer.shadowPath = [[UIBezierPath bezierPathWithRect:currentImage.bounds]CGPath];
        
            currentImageView.action = CURRENT_IMAGE_CLICK_EVENT;
//            [[self getScrollView] addSubview:currentImageView];
//             contentWidth += tWidth + kImageSmallGap;
            [[self getScrollView] addSubview:currentImage];
            contentWidth += tWidth + kImageSmallGap+ NON_PROFILE_IMAGE_BORDER_WIDTH*2;
        }
        if(entity.parentMediaUrl)
        {   
            float videoBg;
            float videoH;
            float videoW;
            float videoY;
            GLfloat standardHeight;
            if(entity.mediaUrl){
                standardHeight=kparentImageHeight;
                videoBg=10;
                videoH=3;
                videoW=5;
                videoY=8.5;
            }else{
                standardHeight=kPhotoVideoHeight;
                videoBg=15;
                videoH=0;
                videoW=0;
                videoY=12.5;
            }
            //GLfloat standardHeight =  entity.mediaUrl?kparentImageHeight:kPhotoVideoHeight;
            GLfloat borderWidth = entity.mediaUrl?2:NON_PROFILE_IMAGE_BORDER_WIDTH;
            GLfloat tHeight =  entity.parentmediaheight? [entity.parentmediaheight floatValue]:standardHeight;
            GLfloat tWidth = entity.parentmediawidth?[entity.parentmediawidth floatValue]:standardHeight;
            tWidth = tWidth * standardHeight / tHeight;
            tHeight = standardHeight;
            
            FloggerImageView * imageView= [[[FloggerImageView alloc]init]autorelease];
            imageView.applyAnimation=TRUE;
            imageView.backgroundColor = RGBCOLOR(61, 67, 75);
            if (entity.parenttype.intValue==PARENT_PHOTO)  {
                [imageView setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:entity.parentMediaUrl]] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PHOTO]];
            }else if(entity.parenttype.intValue==PARENT_VIDEO){
                [imageView setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:entity.parentMediaUrl]] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_VIDEO]];
                
                UILabel *videoTimeLable=[[FloggerUIFactory uiFactory] createLable];
                videoTimeLable.text=[GlobalUtils displayableStrFromVideoduration:[entity.parentThread.videoduration intValue]];
                videoTimeLable.textColor=[UIColor whiteColor];//[[FloggerUIFactory uiFactory] createNumFontColor];
                videoTimeLable.textAlignment = UITextAlignmentRight;
                videoTimeLable.frame = CGRectMake(0, tHeight- 14, tWidth, 14);
                videoTimeLable.font=[[FloggerUIFactory uiFactory] createVideoTimeFont];
                videoTimeLable.backgroundColor=[UIColor clearColor];
                
                UIImageView *imageV1p = [[FloggerUIFactory uiFactory] createImageView:playImage];
                imageV1p.frame = CGRectMake(2, tHeight- videoY,playImage.size.width-videoW, playImage.size.height-videoH);
                
                UIView *viewPlay = [[FloggerUIFactory uiFactory] createView];
                viewPlay.frame = CGRectMake(0, tHeight- videoBg, tWidth, videoBg);
                viewPlay.backgroundColor=[UIColor blackColor];
                viewPlay.alpha=0.5;
                
                [imageView addSubview:viewPlay];
                [imageView addSubview:imageV1p];
                [imageView addSubview:videoTimeLable];
            }
            

            UIView *floggerContainer = [[[UIView alloc]init]autorelease];
            floggerContainer.backgroundColor = RGBCOLOR(0x3d, 0x43, 0x4b);//3d434b
            FloggerImageView * parentImageView =imageView;
            parentImageView.userInteractionEnabled = YES;
            parentImageView.actionDelegate = self;
//            parentImageView.frame =  CGRectMake(NON_PROFILE_IMAGE_BORDER_WIDTH, NON_PROFILE_IMAGE_BORDER_WIDTH, tWidth, tHeight);
            parentImageView.frame =  CGRectMake(0, 0, tWidth, tHeight);
             floggerContainer.frame =  CGRectMake(borderWidth, borderWidth, tWidth, tHeight);
            //parentImageView.frame =  CGRectMake(contentWidth, kPhotoVideoHeight - standardHeight, tWidth, tHeight);
            parentImageView.data = entity;
//            parentImageView.layer.masksToBounds = YES;
//            parentImageView.layer.cornerRadius = kSmallImageRadius;

            
            
            //***********给parentImageView加border和shadow*****************//
            UIImageView *parentImage = [[[UIImageView alloc]init]autorelease];
            parentImage.userInteractionEnabled = YES;
//            parentImage.frame=CGRectMake(contentWidth, kPhotoVideoHeight - standardHeight, tWidth+NON_PROFILE_IMAGE_BORDER_WIDTH*2, tHeight+NON_PROFILE_IMAGE_BORDER_WIDTH*2);
            parentImage.frame=CGRectMake(contentWidth, kPhotoVideoHeight - standardHeight, tWidth+borderWidth*2, tHeight+borderWidth*2);
            [parentImage addSubview:floggerContainer];
            [floggerContainer addSubview:parentImageView];
            parentImage.backgroundColor = [UIColor whiteColor];
            parentImage.layer.shadowColor = [[UIColor grayColor] CGColor];
            parentImage.layer.shadowOffset = CGSizeMake(0, 1);
            parentImage.layer.shadowRadius = 1;
            parentImage.layer.shadowOpacity = 0.5;
            parentImage.layer.shadowPath = [[UIBezierPath bezierPathWithRect:parentImage.bounds]CGPath];
             parentImageView.action = PARENT_IMAGE_CLICK_EVENT;
//          [[self getScrollView] addSubview:parentImageView];
//          contentWidth += tWidth + kImageBigGap;
            [[self getScrollView] addSubview:parentImage];
            contentWidth += tWidth + kImageBigGap + NON_PROFILE_IMAGE_BORDER_WIDTH*2;
            
        }
        _imageCount++;
    }
    _contentWidth = contentWidth;
    [[self getScrollView] setContentSize:CGSizeMake(contentWidth, contentHeight)];
    //[self getScrollView].frame = CGRectMake(kScrollLeft, kScrollTop, kScrollWidth, kPhotoVideoHeight);
}

-(void) fillDataToCell
{
    ActivityResultEntity* firstEntry = [_entries objectAtIndex:0];
    NSString *timeFormat = [GlobalUtils getDisplayableStrFromDate:[NSDate dateWithTimeIntervalSince1970:[firstEntry.createdate longLongValue]/1000]];
    [firstEntry.dataDict setObject:timeFormat forKey:@"time"];
    NSMutableDictionary * paramEntry = [NotificationArrayTableViewCell createParamFromEntries:_entries];
    FloggerLayoutParam *layoutParam = [paramEntry objectForKey:@"picsContainer"];
    if(_contentWidth < PICSCONTAINER_WIDTH)
    {
        layoutParam.width = _contentWidth; 
    }
    [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.mainview ViewDisplayParameters:paramEntry DataFillParameters:firstEntry.dataDict InvisibleViews:[NotificationArrayTableViewCell createInvisibleList:_entries]]; 
}


-(void) prepareForReuse
{
    [super prepareForReuse];
    // clear the image from the profile
    FloggerViewAdpater *profileImage = [self.mainview getAdpaterByName:@"profileImage"];
    //[(FloggerImageView*)profileImage.view setImage:nil];
     [(FloggerImageView*)profileImage.view setImageWithURL:nil placeholderImage:nil];

    // clear the images from the scrollView
    [[self getScrollView].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    

}
-(BOOL) handleTap:(id)param
{
    NSMutableDictionary *dictParam = param;
    id eventParam = [dictParam objectForKey:K_EVENT_DATA];
    NSString *action = [dictParam objectForKey:K_EVENT_ACTION];
    if([eventParam isKindOfClass:[MyAccount class]])
    {
        [self.celldelegate NotificatinProfileClick:eventParam]; 
        return YES;
    }
    ActivityResultEntity* data = [dictParam objectForKey:K_EVENT_DATA];
    if([action isEqualToString:PROFILE_EVENT])
    {
        [self.celldelegate NotificatinPhotoCellButtonMediaOnClick:data]; 
    } else if([action isEqualToString:CURRENT_IMAGE_CLICK_EVENT])
    {
        [self.celldelegate NotificatinPhotoCellButtonMediaOnClick:data]; 
    } else if([action isEqualToString:PARENT_IMAGE_CLICK_EVENT])
    {
        [self.celldelegate NotificatinPhotoCellButtonParentMediaOnClick:data]; 
    } 
    return YES;
}
- (void) handleAction:(NSNotification*) notification
{
    //[notification.object objectForKey:KEY_WEB_ACTION]
    if(notification.object)
    {
        if([[notification.object objectForKey:kScheme] isEqualToString:kTagTag])
        {
            return;
            NSString *tag = [notification.object objectForKey:kKeyword];
            if (celldelegate) {
                [celldelegate openTag:tag];
            }
            return;
        } else if([[notification.object objectForKey:kScheme] isEqualToString:kAtTag])
        {
            return;
            NSString *tag = [notification.object objectForKey:kKeyword];
            /*ActivityResultEntity * param = [[[ActivityResultEntity alloc]init]autorelease]; 
            param.useruid = [NSNumber numberWithLongLong:[tag longLongValue]];*/
            if (celldelegate) {
                [celldelegate go2UserSelectedProfile:tag];
                 
            }
            return;
        }

        NSString* action = [notification.object objectForKey:KEY_WEB_ACTION];
        if([action isEqualToString:RECOMMAND_CLICK_EVENT])
        {
            [self.celldelegate RecommandClick:_entries];
            return;
        }
        ActivityResultEntity * param = [_entries objectAtIndex:0];
        if([action isEqualToString:AT_CLICK_EVENT])
        {
            [self.celldelegate NotificatinPhotoCellTagOnClick:param];
            return;
        }
        if([action isEqualToString:@"profile"])
        {
            [self.celldelegate goCurrentProfile:param];
            //todo
        }else if([action isEqualToString:PARENT_IMAGE_CLICK_EVENT])
        {

            [self.celldelegate NotificatinPhotoCellButtonParentMediaOnClick:param];  
        }
        
    } 
    else 
    {
        
    }
    
}

-(void)fillData:(NSMutableArray *)entries
{
    
    _imageCount = 0;
    _contentWidth = 0;
    //[[self getScrollView]removeFromSuperview];
    if (_entries != entries) {
        RELEASE_SAFELY(_entries);
        _entries = [entries retain];
    }
    
    
    if(!self.mainview)
    {
        [self.mainview.view removeFromSuperview];
        mainview = [[FloggerLayoutAdapter sharedInstance] createViewSet:[self.celldelegate getMainlayout] ParentAapter:nil ActionHandler:self];
        [self addSubview:self.mainview.view];
    }
    if([[_entries objectAtIndex:0] isKindOfClass:[ExternalFriendGroup class]])
    {
        [self fillRecommendUserScrollView];
        FloggerViewAdpater *profileImage = [self.mainview getAdpaterByName:@"profileImage"];
        FloggerImageView *imageView = (FloggerImageView*)profileImage.view;
        imageView.image = [UIImage imageNamed:@"icon.png"];
        
        ExternalFriendGroup* firstEntry = [_entries objectAtIndex:0];
        [firstEntry.dataDict setObject:[NSString stringWithFormat:NSLocalizedString(@"You have %d new friends that use Folo", @"You have %d new friends that use Folo"),_imageCount] forKey:@"topHypertext"];
//        [firstEntry.dataDict setObject:[NSString stringWithFormat:NSLocalizedString(@"You have %d new friends that use <span class='importantBold'>Folo</span>", @""),_imageCount] forKey:@"topHypertext"];
        
        NSMutableDictionary * paramEntry = [NotificationArrayTableViewCell createParamFromEntries:_entries];
        FloggerLayoutParam *layoutParam = [paramEntry objectForKey:@"picsContainer"];
        if(_contentWidth < PICSCONTAINER_WIDTH)
        {
            layoutParam.width = _contentWidth; 
        }
        [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.mainview ViewDisplayParameters:paramEntry DataFillParameters:firstEntry.dataDict InvisibleViews:[NotificationArrayTableViewCell createInvisibleList:_entries]]; 
    } else {
        ActivityResultEntity* mainEntry = [entries objectAtIndex:0];
        
        if(mainEntry.actiontype.intValue == ACTION_FOLLOW)
        {
            [self fillFollowScrollView];
        }
        else
        {
            [self fillOtherScrollView];
        }
        //[self getScrollView].layer.borderColor = [UIColor redColor].CGColor;
        //[self getScrollView].layer.borderWidth = 1;
        // add message
        
        // add the profile image
        FloggerViewAdpater *profileImage = [self.mainview getAdpaterByName:@"profileImage"];
        FloggerImageView *imageView = (FloggerImageView*)profileImage.view;
        [imageView setImageWithURL:[NSURL URLWithString:mainEntry.imageurl] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PROFILE_PICTURE]];
        [self fillDataToCell];
    }
    //[self addSubview:[self getScrollView]];
}

-(void)dealloc
{
    self.celldelegate = nil;
    self.mainview = nil;
    self.scrollView = nil;
    RELEASE_SAFELY(_entries);
    [super dealloc];
}


-(void)NotificatinPhotoCellButtonLargeOnClick:(id)sender entity:(ActivityResultEntity *)entity
{
    if(self.celldelegate){
        if(entity.parentMediaUrl){
            [self.celldelegate NotificatinPhotoCellButtonParentMediaOnClick:entity];
        }else{
            [self.celldelegate NotificatinPhotoCellButtonMediaOnClick:entity];
        }
    }
    
}

-(void)NotificatinPhotoCellButtonSmallOnClick:(id)sender entity:(ActivityResultEntity *)entity
{
    [self.celldelegate NotificatinPhotoCellButtonMediaOnClick:entity];
}

@end
