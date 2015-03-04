//
//  FeedCell.m
//  Flogger
//
//  Created by jwchen on 12-2-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FeedViewCell.h"
#import "Issueinfo.h"
#import "GlobalData.h"
#import "MyIssueInfo.h"
#import "SBJson.h"
#import "MyMovieViewController.h"
#import "MyMoviePlayerManager.h"
//#import "FeedTableView.h"


#define kTopViewHeight 260
#define kMiddleViewHeight 70
#define kBottomViewHeight 29
#define kShareHeight 280
#define kIconHeight 55
//#define kUserHeight 23

#define kVGap 5
#define kVLGap 2

#define kContentHeight @"kContentHeight"
#define kLocationHeight @"kLocationHeight"
#define kMiddleHeight @"kMiddleHeight"
#define kUserHeight @"kUserHeight"

#define kContentWidth 241

#define kActivityIndicateTag 222
#define NUMBER_SUBVIEW_COUNT 3
#define NATRUAL_THUMBNAIL_HEIGHT 90

#define MOVIEPLAYTAG 7869
@implementation FeedViewCell
@synthesize issueInfo = _issueInfo, delegate;//, webView;
@synthesize mainImageView,profileImageView;
@synthesize action;
@synthesize mainview,extraParam;
@synthesize isPlaying,myMoviePlayer;

+(void) getNormalizeWidth:(float*)tw height:(float*)th
{
    static float CONST_DIMENTION = 100;
    if(*th <= 0.0001)
    {
        *th = CONST_DIMENTION;
    }
    if(*tw <= 0.0001)
    {
        *tw = CONST_DIMENTION;
    }
    
    if(*th<=NATRUAL_THUMBNAIL_HEIGHT)
    {
        return;
    }
    *tw = (*tw) * NATRUAL_THUMBNAIL_HEIGHT / (*th); 
    *th = NATRUAL_THUMBNAIL_HEIGHT;
    return;
}
+(NSMutableDictionary *)createParamFromIssueInfo:(Issueinfo *)issueInfo ExtraParam:(NSMutableDictionary*) param
{
//    static GLfloat C_WIDTH = 278;
//    static GLfloat C_HEIGHT = 372;
//    static GLfloat C_WIDTH = 300;
//    static GLfloat C_HEIGHT = 400;
//    GLfloat C_WIDTH = 250;
//    GLfloat C_HEIGHT = 333;
    GLfloat C_WIDTH ;
    GLfloat C_HEIGHT ;
    BOOL isMainView = YES;
    if ([param objectForKey:@"subView"]) {
        C_WIDTH = 90;
        //C_WIDTH = 0;
        C_HEIGHT = 90;
        isMainView = NO;
    } else {
        C_WIDTH = 290;
        C_HEIGHT = 390;
    }

    NSMutableDictionary* dict = [[[NSMutableDictionary alloc]init]autorelease];
    FloggerLayoutParam *paramPhoto = [[[FloggerLayoutParam alloc]init]autorelease];
    [dict setObject:paramPhoto forKey:@"photo"];
    if ([issueInfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO)
    {
        paramPhoto.actionType = @"playVideo";
//        paramPhoto.actionType = @"";
    } 

    // ==========get the height
//    if ([issueInfo.photowidth floatValue]) {
//        <#statements#>
//    }
  
    paramPhoto.width = [issueInfo.photowidth floatValue];//[issueInfo.photowidth floatValue]/2;
    paramPhoto.height = [issueInfo.photoheight floatValue];//[issueInfo.photoheight floatValue]/2;
//    NSLog(@"photo width is %f====",paramPhoto.width);
//    NSLog(@"photo height is %f====",paramPhoto.height);
    GLfloat w1=0,h1=0;
    if(isMainView)
    {
        if(paramPhoto.width < 0.00001)
        {
            paramPhoto.width =  C_WIDTH;
        }
        if(paramPhoto.height < 0.00001)
        {
            paramPhoto.height =  C_HEIGHT;
        }
        w1 = C_WIDTH;//paramPhoto.width>C_WIDTH?C_WIDTH: paramPhoto.width
        h1 = paramPhoto.height * w1 / paramPhoto.width;
        paramPhoto.width = w1;
        paramPhoto.height = h1;
    } else {
        w1 = paramPhoto.width;
        h1 = paramPhoto.height;
        [FeedViewCell getNormalizeWidth:&w1 height:&h1];
        paramPhoto.width = w1;
        paramPhoto.height = h1;
    }
    paramPhoto = [[[FloggerLayoutParam alloc]init]autorelease];
    paramPhoto.width = w1+10;//[issueInfo.photowidth floatValue]/2;
    paramPhoto.height = h1+10;//[issueInfo.photoheight floatValue]/2;
    [dict setObject:paramPhoto forKey:@"photobackground"];
    FloggerLayoutParam *paramPhotoContainer = [[[FloggerLayoutParam alloc]init]autorelease];
    /*[dict setObject:paramPhotoContainer forKey:@"photoContainer"];
    paramPhotoContainer.width = w1+10;
    paramPhotoContainer.height = h1+10;*/
    paramPhotoContainer.width = 0;
    paramPhotoContainer.height = h1+10;
    [dict setObject:paramPhotoContainer forKey:@"leftShadow"];
    [dict setObject:paramPhotoContainer forKey:@"rightShadow"];
    paramPhotoContainer = [[[FloggerLayoutParam alloc]init]autorelease];
    [dict setObject:paramPhotoContainer forKey:@"photoSubContainer"];
    paramPhotoContainer.width = w1+4;
    paramPhotoContainer.height = h1+4;
    

   // [dict setObject:paramPhotoContainer forKey:@"photoContainerLeft"];
   // [dict setObject:paramPhotoContainer forKey:@"photoContainerRight"];
    
    //FloggerLayoutParam *paramPhotoBackground = [[[FloggerLayoutParam alloc]init]autorelease];
    //[dict setObject:paramPhotoBackground forKey:@"photobackground"];
    //paramPhotoBackground.width = w1;
    //paramPhotoBackground.height = h1;
    
    //FloggerLayoutParam *paramProfile = [[[FloggerLayoutParam alloc]init]autorelease];
    //[dict setObject:paramProfile forKey:@"profileImage"];
    
    FloggerLayoutParam *paramBtnLike = [[[FloggerLayoutParam alloc]init]autorelease];
    [dict setObject:paramBtnLike forKey:@"btn_like"];
    if([[issueInfo.dataDict objectForKey:@"liked"] boolValue])
    {
        //paramBtnLike.imgSrc = @"sns_Pressed_Like_Button.png" ;
//        NSLog(@"test==== %d",[[issueInfo.dataDict objectForKey:@"liked"] intValue]);
        paramBtnLike.image = [UIImage imageNamed:@"sns_Pressed_Like_Button.png"];
        paramBtnLike.actionType = @"unlike";
    } else {
//        NSLog(@"else ==== test==== %d",[[issueInfo.dataDict objectForKey:@"liked"] intValue]);
        //paramBtnLike.imgSrc =@"sns_Like_Button.png"; 
        paramBtnLike.image = [UIImage imageNamed:@"sns_Like_Button.png"];
        paramBtnLike.actionType = @"like";
    }
    
    FloggerLayoutParam *paramBtnFlg = [[[FloggerLayoutParam alloc] init] autorelease];
    [dict setObject:paramBtnFlg forKey:@"btn_report"];
//    if ([issueInfo.useruid isEqualToNumber:[GlobalData sharedInstance].myAccount.account.useruid]) {
    if ([GlobalUtils checkIsOwnerByUserUID:[issueInfo.useruid longLongValue]]) {
        paramBtnFlg.image = [[FloggerUIFactory uiFactory] createImage:SNS_DELETE_BUTTON];
        paramBtnFlg.actionType = @"delete";
        paramBtnFlg.pressedImage=[[FloggerUIFactory uiFactory] createImage:SNS_DELETE_BUTTON_PRESSED];
    } else {
        paramBtnFlg.image = [[FloggerUIFactory uiFactory]createImage:SNS_FLAG_BUTTON];
        paramBtnFlg.actionType = @"flag";
         paramBtnFlg.pressedImage=[[FloggerUIFactory uiFactory] createImage:SNS_FLAG_BUTTON_PRESSED];
    }
    
    
    //    if ([issueInfo.useruid isEqualToNumber:[GlobalData sharedInstance].myAccount.account.useruid]) {
    //now comment btn valid
//    if ([@"0" isEqualToString:[param objectForKey:@"comment"]]) {
//        FloggerLayoutParam *paramCommentFlg = [[[FloggerLayoutParam alloc] init] autorelease];
//        [dict setObject:paramCommentFlg forKey:@"btn_comment"];
//        paramCommentFlg.actionType = NONE_ACTION;
//    }
    //video

    if(isMainView)
    {
        if([issueInfo isKindOfClass:[MyIssueInfo class]])
        {
            MyIssueInfo * myIssueInfor = (MyIssueInfo *)issueInfo;
            int index =2;
            int arrayIndex = 0;
            for (MyIssueInfo * subIssueInfor  in myIssueInfor.commentList)
            {
                FloggerLayoutParam *paramPhoto = [[[FloggerLayoutParam alloc]init]autorelease];
                NSString *key = [NSString stringWithFormat:@"image_%d",index];
                [dict setObject:paramPhoto forKey:key];
                w1 = [subIssueInfor.photowidth floatValue];
                h1 = [subIssueInfor.photoheight floatValue];
                [FeedViewCell getNormalizeWidth:&w1 height:&h1];
                paramPhoto.width = w1;
                paramPhoto.height = h1;
                paramPhoto.actionType = [NSString stringWithFormat:@"$thread$%d",arrayIndex];
                
                
                key = [NSString stringWithFormat:@"profileImageAlias_%d",index];
                paramPhoto = [[[FloggerLayoutParam alloc]init]autorelease];
                [dict setObject:paramPhoto forKey:key];
                paramPhoto.actionType = [NSString stringWithFormat:@"$profile$%d",arrayIndex];
                
                
                key = [NSString stringWithFormat:@"location_%d",index];
                paramPhoto = [[[FloggerLayoutParam alloc]init]autorelease];
                [dict setObject:paramPhoto forKey:key];
                paramPhoto.actionType = [NSString stringWithFormat:@"$map$%d",arrayIndex];
                
                //key = [NSString stringWithFormat:@"image_%d",index];
                //paramPhoto = [[[FloggerLayoutParam alloc]init]autorelease];
                //[dict setObject:paramPhoto forKey:key];
                //paramPhoto.actionType = [NSString stringWithFormat:@"$image$%d",arrayIndex];
                
                arrayIndex++;
                index++;
            }
        }
    }
    
    return dict;
}
+(NSMutableDictionary*)createInvisibleList:(Issueinfo *)issueInfo  ExtraParam:(NSMutableDictionary*) param
{
    NSMutableDictionary *list = [[[NSMutableDictionary alloc]init]autorelease];
    if([issueInfo isKindOfClass:[MyIssueInfo class]])
    {
        MyIssueInfo * myIssueInfor = (MyIssueInfo *)issueInfo;
        //NSLog(@"myIssueInfor.likers  %@",myIssueInfor.likers);
        NSString *likers=myIssueInfor.likers;
        
      //  issueInfo.issuecategory
        if (likers!=nil) {
           // NSLog(@"myIssueInfor.likers  %@",likers);
            // [list setObject:@"bottomLinedown" forKey:@"bottomLinedown"];
            //[myIssueInfor.dataDict setObject:likers forKey:@"likerDesc"];
            if ([issueInfo.issuecategory intValue ]==0) {//weibo
                [list setObject:@"likers" forKey:@"likers"];                 
               // [param setObject:@"0" forKey:@"removeLastLine"]; 
            }else{
                //[myIssueInfor.dataDict setObject:likers forKey:@"likerDesc"];
                [list setObject:@"likersW" forKey:@"likersW"];
            }
        }else{
            [list setObject:@"likers" forKey:@"likers"];  
            [list setObject:@"likersW" forKey:@"likersW"];
            
        }
    }
    
    if([issueInfo.issuecategory intValue ]==0){
                    [list setObject:@"leftShadow" forKey:@"leftShadow"];
                   [list setObject:@"rightShadow" forKey:@"rightShadow"];
    }
    
    if([issueInfo isKindOfClass:[MyIssueInfo class]])
    {
        if(issueInfo.id){
            [list setObject:@"footOfflineBar" forKey:@"footOfflineBar"];

        }else{
            [list setObject:@"footBar" forKey:@"footBar"];
//            MyIssueInfo * myIssueInfor = (MyIssueInfo *)issueInfo;
//            [myIssueInfor.dataDict setObject:@"Your media will be uploaded the next time you connect to the internet" forKey:@"btn_Offline_Word"];
        }
    }
    if([@"1" isEqualToString:[param objectForKey:@"removeLastLine"]])
    {
        [list setObject:@"bottomLine" forKey:@"bottomLine"];
        [list setObject:@"bottomLinedown" forKey:@"bottomLinedown"];
    }
    if(!issueInfo.inspiredid||[issueInfo.inspiredid longLongValue]<=0)
    {
        [list setObject:@"inspired" forKey:@"inspired"];
    }
    if([issueInfo.issuecategory intValue]!=1 && [issueInfo.issuecategory intValue]!=2)
    {
        [list setObject:@"photo" forKey:@"photo"];
        //[list setObject:@"photoContainer" forKey:@"photoContainer"];
        [list setObject:@"photobackground" forKey:@"photobackground"];
        [list setObject:@"photoSubContainer" forKey:@"photoSubContainer"];
        [list setObject:@"profileImageContainerAlias" forKey:@"profileImageContainerAlias"];
        [list setObject:@"timeAlias" forKey:@"timeAlias"];
    }else{
        [list setObject:@"textTopNone" forKey:@"textTopNone"];
    }
    if([issueInfo.issuecategory intValue]!=2)
    {
        [list setObject:@"videoPlay" forKey:@"videoPlay"];
         [list setObject:@"videoTime" forKey:@"videoTime"];
         //[list setObject:@"lblVideoTime" forKey:@"lblVideoTime"];
    }
    if (![GlobalUtils checkIsLogin]) {
        [list setObject:@"btn_share" forKey:@"btn_share"];
        [list setObject:@"btn_report" forKey:@"btn_report"];
        [list setObject:@"btn_like" forKey:@"btn_like"];
        [list setObject:@"btn_comment" forKey:@"btn_comment"];
        //hide copyfilter
        [list setObject:@"copyfilterIcon" forKey:@"copyfilterIcon"];
    }
   /*
    //现在feed页面是自己不隐藏按钮了
    if ([GlobalUtils checkIsOwnerByUserUID:[issueInfo.useruid longLongValue]] && [@"0" isEqualToString:[param objectForKey:@"delete"]]) {
        [list setObject:@"btn_report" forKey:@"btn_report"];
    }
     */
    if (!issueInfo.location || [[issueInfo.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [list setObject:@"userName_location" forKey:@"userName_location"];
    }else{
        [list setObject:@"userName_not_location" forKey:@"userName_not_location"];
    }
    if ([issueInfo.issuecategory intValue] != 1 && [issueInfo.issuecategory intValue] != 2) {
        [list setObject:@"inspiredIcon" forKey:@"inspiredIcon"];
        [list setObject:@"copyfilterIcon" forKey:@"copyfilterIcon"];
    }else  {
        if (!issueInfo.parentid || [issueInfo.parentid longLongValue] <= 0) {
            [list setObject:@"inspiredIcon" forKey:@"inspiredIcon"];
        }
        if (!issueInfo.filtersyntax || issueInfo.filtersyntax.length <=0 ) {
            [list setObject:@"copyfilterIcon" forKey:@"copyfilterIcon"];
        }
    }
    
    //
    if(![issueInfo isKindOfClass:[MyIssueInfo class]])
    {
        if((!issueInfo.hypertext || ![issueInfo.hypertext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) )
        {
            [list setObject:@"textContainer" forKey:@"textContainer"];
        }   
    }
   
    if([issueInfo isKindOfClass:[MyIssueInfo class]])
    {
        MyIssueInfo * myIssueInfor = (MyIssueInfo *)issueInfo;
        
        if((!issueInfo.hypertext || ![issueInfo.hypertext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) && [myIssueInfor.commentList count]<=0 && [myIssueInfor.likecnt intValue]<=0)
        {
            [list setObject:@"textContainer" forKey:@"textContainer"];
        } 
        //video,photo下面什么描述都没有，只有like时，去掉下滑线。
        if((!issueInfo.hypertext || ![issueInfo.hypertext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) && [myIssueInfor.commentList count]<=0)
        {
            [list setObject:@"bottomLineLike" forKey:@"bottomLineLike"];
        } 
        if([issueInfo.issuecategory intValue ]==0&&[myIssueInfor.commentList count]<=0)
        {
            [list setObject:@"bottomLineLikeW" forKey:@"bottomLineLikeW"];
        } 
        if((!issueInfo.hypertext || ![issueInfo.hypertext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length)||[issueInfo.issuecategory intValue ]==0)
        {
            [list setObject:@"Container_1" forKey:@"Container_1"];
           // [list setObject:@"bottomLineLike" forKey:@"bottomLineLike"];
        }  
        if(![issueInfo.issuecategory intValue ]==0)
        {
            [list setObject:@"ContainerWeibo" forKey:@"ContainerWeibo"];
        }
        if(issueInfo.hypertext)
        {
            NSString *newHyperText = [NSString stringWithFormat:@"<span class='nameBold'>%@: </span>%@", issueInfo.username,issueInfo.hypertext];
            [myIssueInfor.dataDict setObject:newHyperText forKey:@"newHypertext"];
        }
        int index = 2;
        for (MyIssueInfo* subissue in myIssueInfor.commentList) 
        {
            /*if(!subissue.hypertext)
            {
                NSString *container = [NSString stringWithFormat:@"desc_%d",index];
                [list setObject:container forKey:container];
            }*/
            if(!subissue.location)
            {
                NSString *container = [NSString stringWithFormat:@"location_%d",index];
                [list setObject:container forKey:container];  
            }
            
            if(!subissue.bmiddleurl || ![subissue.bmiddleurl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length)
            {
                NSString *container = [NSString stringWithFormat:@"image_%d",index];
                [list setObject:container forKey:container];  
            }
            //NSLog(@"====%@",subissue.bmiddleurl);
            if([subissue.issuecategory intValue]!=2)
            {
                NSString *container = [NSString stringWithFormat:@"videoPlay_%d",index];
                [list setObject:container forKey:container];  
            }
            NSString *key;
            if(subissue.hypertext)
            {
                key = [NSString stringWithFormat:@"hypertext_%d",index];
                NSString *newHyperText = [NSString stringWithFormat:@"<span class='nameBold'>%@: </span>%@", subissue.username,(subissue.hypertext?subissue.hypertext:@"")];
                [myIssueInfor.dataDict setObject:newHyperText forKey:key];
            }
            if(subissue.location)
            {
                key = [NSString stringWithFormat:@"location_%d",index];
                [myIssueInfor.dataDict setObject:subissue.location forKey:key];
            }
            
            index++;
        }
        index = [myIssueInfor.commentList count]+2;
        
        for(;index<NUMBER_SUBVIEW_COUNT+2;)
        {
            NSString *container = [NSString stringWithFormat:@"Container_%d",index];
            [list setObject:container forKey:container];
            index++;
        }
        int sumAll = [myIssueInfor.commentcnt intValue]; //+ [myIssueInfor.responsecnt intValue];
        if(sumAll <= NUMBER_SUBVIEW_COUNT)
        {
            [list setObject:@"Container_bottom" forKey:@"Container_bottom"];          
        } else {
            NSString *showAll = [NSString stringWithFormat:NSLocalizedString(@"View all %d comments", @"View all 100 comments"), sumAll];
            [myIssueInfor.dataDict setObject:showAll forKey:@"viewAll"];
        }
        {
            index = [myIssueInfor.commentList count]+1;
            if(!(index==1&&[issueInfo.issuecategory intValue ]==0&&[myIssueInfor.likecnt intValue]>0)){
                   NSString *container = [NSString stringWithFormat:@"bottomLine_%d",index];
                  [list setObject:container forKey:container];
            }

        }
     
    }
    
    return list;
}
+(CGFloat)tableView:(UITableView *)tableView heightForItem:(Issueinfo *)issueInfo
{
    FloggerWebView* heightTestView = [[FloggerWebAdapter getSingleton]getShapeReference];
    return [self tableView:tableView heightForItem:issueInfo webview:heightTestView];
}
+(CGFloat) tableView:(UITableView *)tableView heightForItem:(Issueinfo *)issueInfo webview:(FloggerWebView*) floggerWebView
{
    if(floggerWebView.isLoaded) {
        [floggerWebView fillData:[issueInfo.dataDict JSONRepresentation]];
        CGFloat height = [floggerWebView getHeight];
        floggerWebView.isUsing = NO;
        return height?height:50;
    } else {
        return 50;
    }
}

-(void) adjustFeedViewCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.mainImageView =[[[SDImageDelegate alloc]init]autorelease];
    self.profileImageView = [[[SDImageDelegate alloc]init]autorelease];
    
}
-(void) callbacksetMainImage{
    //function setMainImage(url)
    FloggerViewAdpater *photo = [self.mainview getAdpaterByName:@"photo"];
    [(TTImageView*)photo.view setImage:self.mainImageView.image];
    //function setProfileImage(url)
}
-(void) callbacksetProfileImage{
    FloggerViewAdpater *profileImage = [self.mainview getAdpaterByName:@"profileImage"];
    [(TTImageView*)profileImage.view setImage:self.profileImageView.image];
}
//-(void)

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self adjustFeedViewCell];

    }
    return self;
}
-(void) prepareForReuse
{
//    NSLog(@"prepare for reuse");
    [super prepareForReuse];
    //self.mainview.actionDeletgate = nil;
    FloggerViewAdpater *photo = [self.mainview getAdpaterByName:@"photo"];
    //[(FloggerImageView*)photo.view setImage:nil];
    [(FloggerImageView*)photo.view setImageWithURL:nil placeholderImage:nil];
    FloggerViewAdpater *profileImage = [self.mainview getAdpaterByName:@"profileImage"];
    //[(FloggerImageView*)profileImage.view setImage:nil];
    [(FloggerImageView*)profileImage.view setImageWithURL:nil placeholderImage:nil];
    
    //test start
//    NSLog(@"prepare to use");
//    MPMoviePlayerController *customPlayerController =  [MyMoviePlayerManager getMyMoviePlayerManager].moviePlayerController;
//    if (customPlayerController && customPlayerController.playbackState != MPMoviePlaybackStateStopped) 
//    if (customPlayerController)
//    {
//        [customPlayerController stop];
//        [customPlayerController.view removeFromSuperview];
//        customPlayerController = nil;        
//    }
    [[photo.view viewWithTag:kTableViewVideoTag] removeFromSuperview]; 
    [[photo.view viewWithTag:kActivityIndicateTag] removeFromSuperview];
    //test end
    
    FloggerViewAdpater *profileImageAlias = [self.mainview getAdpaterByName:@"profileImageAlias"];
    [(FloggerImageView*)profileImageAlias.view setImageWithURL:nil placeholderImage:nil];
    FloggerViewAdpater *profileImageAlias_2 = [self.mainview getAdpaterByName:@"profileImageAlias_2"];
    [(FloggerImageView*)profileImageAlias_2.view setImageWithURL:nil placeholderImage:nil];
    
    

////    if (isPlaying) 
//    {
//        MPMoviePlayerController *moviePlayer = (MPMoviePlayerController *)[photo.view viewWithTag:MOVIEPLAYTAG];
////        if (moviePlayer.playbackState != MPMoviePlaybackStateStopped) {
////            [moviePlayer stop];
////        }
//        if (moviePlayer) {
//            [moviePlayer stop];            
//            [moviePlayer.view removeFromSuperview];
//        }        
//        isPlaying = NO;
//    }
//    NSLog(@"=== prepare to use===222");
    if (self.myMoviePlayer) {
//        NSLog(@"=== my movie player exit===222");
        [self.myMoviePlayer stop];
        [self.myMoviePlayer.view removeFromSuperview];
        self.myMoviePlayer = nil;
    }
//    UITableView
    FloggerViewAdpater *videoplay = [self.mainview getAdpaterByName:@"videoPlay"];
//    uiacti [videoplay.view viewWithTag:kActivityIndicateTag] 
    [[videoplay.view viewWithTag:kActivityIndicateTag]removeFromSuperview]; 
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) handleAction:(NSNotification *)notification
{
    NSString *paramAction = [notification.object objectForKey:KEY_WEB_ACTION];
    Issueinfo * param =  _issueInfo;
    NSInteger actionType = 0;
    if([paramAction hasPrefix:@"$"])
    {
        
        NSString *allStr = [paramAction substringFromIndex:1];
        NSArray *actAndParam = [allStr componentsSeparatedByString:@"$"];
        int subIndex = [[actAndParam objectAtIndex:1]intValue];
        paramAction = [actAndParam objectAtIndex:0];
        param = [((MyIssueInfo*)_issueInfo).commentList objectAtIndex:subIndex];
        
    } 
    if(notification.object)
    {
        if([[notification.object objectForKey:kScheme] isEqualToString:kTagTag])
        {
            NSString *tag = [notification.object objectForKey:kKeyword];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (delegate) {
                    [delegate openTag:tag];
                }
            } );
        } else 
            if([[notification.object objectForKey:kScheme] isEqualToString:kAtTag])
            {
                actionType = kTagProfileBtn;
                param = [[[MyIssueInfo alloc]init]autorelease]; 
                NSString *at = [notification.object objectForKey:kKeyword];
                param.useruid = [NSNumber numberWithLongLong:[at longLongValue]];
//                NSLog(@"value %@",param.useruid);
            }
            else if([[notification.object objectForKey:kScheme] isEqualToString:kListTag])
            {
//                NSString *tag = [notification.object objectForKey:k];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (delegate) {
//                        [delegate openTag:tag];
//                    }
//                } );
                actionType = kTagShowLikers;
            }  
            else 
                if([@"like" isEqual:paramAction])
                {
                    if (![GlobalUtils checkIsLogin]) {
                        return;
                    }
                    actionType = kTagLikeBtn;
                } else
                    if([@"unlike" isEqual:paramAction])
                    {
                        if (![GlobalUtils checkIsLogin]) {
                            return;
                        }
                        actionType = kTagDeleteLikeBtn;
                    } else 
                        if([@"comment" isEqual:paramAction])
                            {
                            //if (![GlobalUtils checkIsLogin]) {
                            //    return;
                            //}
                            actionType = kTagCommentBtn;
                            } else 
                            if([@"report" isEqual:paramAction])
                            {
                                actionType = kTagFlagBtn;
                            } else 
                                if([@"share" isEqual:paramAction])
                                {
                                    actionType = kTagShareBtn;
                                } else 
                                    if([@"profile" isEqualToString:paramAction])
                                    {
                                        actionType = kTagProfileBtn;
                                    } else 
                                        if([@"photo" isEqual:paramAction])
                                        {
                                            actionType = kTagImageBtn;
                                        } else 
                                        if([@"playVideo" isEqual:paramAction])
                                        {
                                            FloggerViewAdpater *videoplayBackground = [self.mainview getAdpaterByName:@"photo"];
                                            FloggerImageView * playViewBackground = (FloggerImageView *) videoplayBackground.view;
                                            
                                            FloggerViewAdpater *videoplay = [self.mainview getAdpaterByName:@"videoPlay"];
                                            FloggerImageView * playView = (FloggerImageView *) videoplay.view;
                                            
                                            
                                            if ([playView viewWithTag:kActivityIndicateTag] || (![playView viewWithTag:kActivityIndicateTag] && [playViewBackground viewWithTag:kTableViewVideoTag])) {
                                                return;
                                            }
                                            
                                            [playView setImage:nil];
                                            UIActivityIndicatorView *activityIndicate = [[[UIActivityIndicatorView alloc] init] autorelease];
                                            activityIndicate.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
                                            activityIndicate.frame = CGRectMake(0, 0, playView.frame.size.width, playView.frame.size.height);
                                            activityIndicate.tag = kActivityIndicateTag;
                                            [activityIndicate performSelector:@selector(startAnimating) withObject:nil afterDelay:0.01];
//                                            [activityIndicate startAnimating];
                                            //test start
//                                            UIView *testView = [[[UIView alloc] init] autorelease];
//                                            testView.frame = CGRectMake(0, 0, playView.frame.size.width, playView.frame.size.height);
//                                            testView.backgroundColor = [UIColor redColor];
//                                            [playView addSubview:testView];
                                            //test end
                                            [playView addSubview:activityIndicate];
                                            [delegate setBufferCell:self];
                                            actionType = kTagPlayVideo;
                                        } else
                                            if([@"flag" isEqual:paramAction])
                                            {
                                                if (![GlobalUtils checkIsLogin]) {
                                                    return;
                                                }
                                                actionType = kTagFlagBtn;
                                            } else
                                                if([@"delete" isEqual:paramAction])
                                                {
                                                    actionType = kTagDelete;
                                                } else 
                                                    if([@"copyfilter" isEqual:paramAction])
                                                    {
                                                        actionType = kTagCopyFilter;
                                                    }  else 
                                                        if([@"photoComment" isEqual:paramAction])
                                                        {
                                                            actionType = kTagPhotoComment;
                                                        }  else 
                                                            if([@"playVideoComment" isEqual:paramAction])
                                                            {
                                                                actionType = kTagPlayVideoComment;
                                                                
                                                            }  else 
                                                                if([@"inspire" isEqual:paramAction])
                                                                {
                                                                    actionType = kTagInspire;
                                                                } else 
                                                                 if([@"map" isEqual:paramAction]){
                                                                     actionType = kTagMap;
                                                                } else
                                                                    if([@"writeComment" isEqualToString:paramAction])
                                                                    {
                                                                    if (![GlobalUtils checkIsLogin]) {
                                                                        return;
                                                                    }
                                                                        actionType = kTagWriteComment;
                                                                    } else 
                                                                        if([@"thread" isEqualToString:paramAction] ){
                                                                            actionType = kTagShowFullThread;
                                                                        } else 
                                                                            if([@"atSomebody" isEqualToString:paramAction] ){
                                                                                actionType = kTagAtSomebody;
                                                                            }
    dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate) {
                [delegate handleAction:actionType withIssueInfo:param];
            }
        } );
    } 
    else 
    {
        
    }
}
-(void) restoreNormalState
{
    FloggerViewAdpater *videoplay = [self.mainview getAdpaterByName:@"videoPlay"];
    FloggerImageView * playView = (FloggerImageView *) videoplay.view;
    [playView setImage:[UIImage imageNamed:@"sns_Play_Button.png"]];
    UIActivityIndicatorView * activity = (UIActivityIndicatorView *)[playView viewWithTag:kActivityIndicateTag]; 
    [activity removeFromSuperview];
//    self.delegate
//    [sel]
   
    
}

-(BOOL) checkPlayView
{
    FloggerViewAdpater *videoplay = [self.mainview getAdpaterByName:@"videoPlay"];
    FloggerImageView * playView = (FloggerImageView *) videoplay.view;
    if (playView) {
        return YES;
    } else {
        return NO;
    }
}

-(void) addMoviePlayer : (NSURL *) videoUrl withBufferPath : (NSString *) bufferFilePath withController : (UIViewController *) controller
{
    NSLog(@"=== addmovieplayer == is ");
    FloggerViewAdpater *videoplay = [self.mainview getAdpaterByName:@"photo"];
    FloggerImageView * playView = (FloggerImageView *) videoplay.view;
//    playView.userInteractionEnabled = NO;
    MyMoviePlayerManager *myMovieViewControl = [MyMoviePlayerManager getMyMoviePlayerManager];//[[[MyMoviePlayerManager alloc] init] autorelease];
    myMovieViewControl.currentViewController = controller;
    [myMovieViewControl  iniViewFrame:playView.bounds];    
    myMovieViewControl.cellView = self; 
//    myMovieViewControl.feedTable = tableView;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:bufferFilePath]) {
        videoUrl = [NSURL fileURLWithPath:bufferFilePath];
        [myMovieViewControl playMovieFile:videoUrl];
    } else {
        [myMovieViewControl playMovieStream:videoUrl];
    }
}

-(void) addMoviePlayer : (NSURL *) videoUrl withBufferPath : (NSString *) bufferFilePath
{
    FloggerViewAdpater *videoplay = [self.mainview getAdpaterByName:@"photo"];
    FloggerImageView * playView = (FloggerImageView *) videoplay.view;
    
    MyMovieViewController *myMovieViewControl = [[[MyMovieViewController alloc] init] autorelease];
    [myMovieViewControl  iniViewFrame:playView.bounds];    
    myMovieViewControl.cellView = self;    
//    myMovieViewControl.view.tag = MOVIEPLAYTAG;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:bufferFilePath]) {
        videoUrl = [NSURL fileURLWithPath:bufferFilePath];
        [myMovieViewControl playMovieFile:videoUrl];
    } else {
        [myMovieViewControl playMovieStream:videoUrl];
    }
    self.isPlaying = YES;
//    self.myMoviePlayer = myMovieViewControl.moviePlayerController;
    //    [playView addSubview:myMovieViewControl.moviePlayerController.view];
//    self.bufferCell.isPlaying = YES;
    self.myMoviePlayer = myMovieViewControl.moviePlayerController;
    
//    NSLog(@"===== set mymovieplayer");
    
//    MPMoviePlayerController *mpMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
//    mpMoviePlayer.view.frame = playView.bounds;
//    
//    mpMoviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
//    mpMoviePlayer.controlStyle = MPMovieControlStyleEmbedded;
//    [mpMoviePlayer prepareToPlay];
//    [mpMoviePlayer play];
//    [playView addSubview:mpMoviePlayer.view];
    
//    myMovieViewControl 
//    [myMovieViewControl playMovieStream:videoUrl];
    
}

//-(FloggerWebView*)createMainWebView
//{
//    return  [[FloggerWebAdapter getSingleton]getFeedView:self.action];
//}
/*-(void) loadWeb
{
    self.webView =[[self createMainWebView]autorelease];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:self.action object:nil];
    self.webView.actionDelegate =self;
}*/
-(void) removeFromSuperview
{
    NSLog(@"=== prepare to use removeFromSuperview ===");
    NSLog(@"remove de view is %@",[self class]);
//    [self testRemoveMov];
    [self removeMovInCell];
//    if ([self viewWithTag:kTableViewVideoTag] || [self viewWithTag:kActivityIndicateTag])
//    {
//        [self testRemoveMov];
//        
//    }
    if (self.myMoviePlayer) {
        NSLog(@"=== my movie player exit===");
        [self.myMoviePlayer stop];
        [self.myMoviePlayer.view removeFromSuperview];
        self.myMoviePlayer = nil;
    }
    [super removeFromSuperview];
}
-(void)delayset
{
    if(self.issueInfo.bmiddleurl)
    {
        
        FloggerViewAdpater *photo = [self.mainview getAdpaterByName:@"photo"];
        FloggerImageView *imageView = (FloggerImageView*)photo.view;
        
        if ([self.issueInfo.issuecategory intValue] == ISSUE_CATEGORY_VIDEO)
        {
              [imageView setImageWithURL:[NSURL URLWithString:self.issueInfo.bmiddleurl] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_VIDEO]];
        } else{
             [imageView setImageWithURL:[NSURL URLWithString:self.issueInfo.bmiddleurl] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PHOTO]];
        }

        
//        [imageView setImageWithURL:[NSURL URLWithString:self.issueInfo.bmiddleurl] placeholderImage:imageView.defaultImage];
        
        //FloggerImageView *testImageview =[[[FloggerImageView alloc]init]autorelease];
        //[testImageview  setImageWithURL:[NSURL URLWithString:self.issueInfo.bmiddleurl] placeholderImage:imageView.defaultImage];
        /*ret = [mainImageView loadImageWithURL:self.issueInfo.bmiddleurl];
        if(ret)
        {
            [self callbacksetMainImage];
        }*/
    }
    profileImageView.delegate = self;
    if(self.issueInfo.imageurl)
    {
        FloggerViewAdpater *profileImage = [self.mainview getAdpaterByName:@"profileImage"];
        FloggerImageView *imageView = (FloggerImageView*)profileImage.view;
        [imageView setImageWithURL:[NSURL URLWithString:self.issueInfo.imageurl] placeholderImage:imageView.defaultImage];
        
        profileImage = [self.mainview getAdpaterByName:@"profileImageAlias"];
        imageView = (FloggerImageView*)profileImage.view;
        [imageView setImageWithURL:[NSURL URLWithString:self.issueInfo.imageurl] placeholderImage:imageView.defaultImage];
        /*ret = [profileImageView loadImageWithURL:self.issueInfo.imageurl];
        if(ret)
        {
            [self callbacksetProfileImage];
        }*/
    }    
    if([self.issueInfo isKindOfClass:[MyIssueInfo class]])
    {
        MyIssueInfo * myIssueInfor = (MyIssueInfo *)self.issueInfo;
        int index = 2;
        for (MyIssueInfo * subIssueInfor  in myIssueInfor.commentList)
        {
            NSString *key = [NSString stringWithFormat:@"profileImageAlias_%d",index];
            FloggerViewAdpater *image = [self.mainview getAdpaterByName:key];
            FloggerImageView *imageView = (FloggerImageView*)image.view;
            [imageView setImageWithURL:[NSURL URLWithString:subIssueInfor.imageurl] placeholderImage:imageView.defaultImage];
            
            key = [NSString stringWithFormat:@"image_%d",index];
            image = [self.mainview getAdpaterByName:key];
            imageView = (FloggerImageView*)image.view;
            if(subIssueInfor.bmiddleurl)
            {
                [imageView setImageWithURL:[NSURL URLWithString:subIssueInfor.bmiddleurl] placeholderImage:imageView.defaultImage];
            } else {
                imageView.image = nil;
            }
            //NSLog(@"====%@",subIssueInfor.hypertext);
            index++;
        }
    }
}
-(void)setIssueInfo:(Issueinfo *)issueInfo
{
    //NSLog(@"===========aaaa:%@",issueInfo.id);
    [self setIssueInfo:issueInfo Layout:[self.delegate getMainlayout]];
    //NSLog(@"===========bbbb:%@",issueInfo.id);
}
-(void)setIssueInfo:(Issueinfo *)issueInfo Layout:(FloggerLayout*) layout
{
    if(!self.mainview)
    {
        [self.mainview.view removeFromSuperview];
        mainview = [[FloggerLayoutAdapter sharedInstance] createViewSet:layout ParentAapter:nil ActionHandler:self];
        //self.mainview.view.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    
        [self.contentView addSubview:self.mainview.view];
    }
    if(_issueInfo!=issueInfo)
    {
        RELEASE_SAFELY(_issueInfo);
        _issueInfo  = [issueInfo retain];
    }
    //[self performSelectorInBackground:@selector(delayset) withObject:nil];
    //[self delayset];
    //dispatch_async(dispatch_get_main_queue(),  ^{
    [self fillDataToCell];
    //[self.mainview.view removeFromSuperview];
    //});
}
-(void) fillDataToCell
{
    NSMutableDictionary *mydata = [[[NSMutableDictionary alloc]initWithDictionary:self.issueInfo.dataDict]autorelease];
//    NSString *timeFormat = [GlobalUtils getDisplayableStrFromDate:[NSDate dateWithTimeIntervalSince1970:[self.issueInfo.createdate longLongValue]/1000]];
    NSString *timeFormat;
    if (self.issueInfo.createdate) {
        timeFormat = [GlobalUtils getDisplayableStrFromDate:[NSDate dateWithTimeIntervalSince1970:[self.issueInfo.createdate longLongValue]/1000]];
    }else {
        timeFormat = @"--";
    }
    
    [mydata setObject:timeFormat forKey:@"time"];

    
    [mydata setObject:[GlobalUtils displayableStrFromVideoduration:[self.issueInfo.videoduration intValue]] forKey:@"videoTime"];

   // dispatch_async(dispatch_get_main_queue(), ^{
        [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.mainview ViewDisplayParameters:[FeedViewCell createParamFromIssueInfo:self.issueInfo ExtraParam:self.extraParam] DataFillParameters:mydata InvisibleViews:[FeedViewCell createInvisibleList:self.issueInfo  ExtraParam:self.extraParam]];
        [self delayset];
    
     //   [self setNeedsDisplay];
    //}); 
}
-(void)layoutSubviews
{
    [super layoutSubviews];
        //[self fillDataToCell];

}
-(void)dealloc
{
    RELEASE_SAFELY(_issueInfo);
    //self.webView.actionDelegate = nil;
    //[[self webView]stringByEvaluatingJavaScriptFromString:@"clearData()"];
    //self.webView.isUsing = NO;
    //self.webView
    //[[FloggerWebAdapter getSingleton]refreshFeedView:self.webView action:self.action];
    self.myMoviePlayer = nil;
    
    self.mainImageView.delegate = nil;
    self.profileImageView.delegate = nil;
    self.profileImageView = nil;
    self.mainImageView = nil;
    //self.webView = nil;
    self.delegate = nil;
    self.mainview = nil;
    [super dealloc];
}

-(void)downloadFinished:(SDImageDelegate*)downloader
{
    if(downloader==self.mainImageView)
    {
        if([self.issueInfo.bmiddleurl isEqualToString:downloader.lastKey])
        {
            [self callbacksetMainImage];
        }
    }
    if(downloader==self.profileImageView)
    {
//        NSLog(@"downloadFinish imger url === is %@",self.issueInfo.imageurl);
//        NSLog(@"fdownloader.lastKey  is %@",downloader.lastKey);
        if([self.issueInfo.imageurl   isEqualToString:downloader.lastKey])
        {
            [self callbacksetProfileImage];
        } 
    }
}

//- (void)willRemoveSubview:(UIView *)subview
//{
//    [super willRemoveSubview:subview];
////    if (subview == [self viewWithTag:kTableViewVideoTag]) 
//    {
//        MPMoviePlayerController *customPlayerController =  [MyMoviePlayerManager getMyMoviePlayerManager].moviePlayerController;
//    }
//}
-(void) removeMovInCell
{
//    MPMoviePlayerController *customPlayerController =  [MyMoviePlayerManager getMyMoviePlayerManager].moviePlayerController;
    if ([self viewWithTag:kTableViewVideoTag] || [self viewWithTag:kActivityIndicateTag])
    {
        [MyMoviePlayerManager restoreMyMoviePlayerManager];        
    }
    
    
    
}

//-(void) w
- (void)didMoveToSuperview
{
//     NSLog(@"==== did move to superview ===");
    [super didMoveToSuperview];
   /* if ([self viewWithTag:kTableViewVideoTag]) 
        //    if (!newSuperview)
    {
        NSLog(@"close movie==");
        //        [self performSelectorOnMainThread:@selector(testRemoveMov) withObject:nil waitUntilDone:NO];
//                [self performSelector:@selector(testRemoveMov) withObject:nil afterDelay:0.01];
        //        [self performSelectorInBackground:@selector(testRemoveMov) withObject:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self testRemoveMov];
                });
//        [self testRemoveMov];
        
    }*/
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    NSLog(@"newSuperview is %@",[newSuperview class]);
    [super willMoveToSuperview:newSuperview];
//    if ([self viewWithTag:kTableViewVideoTag] || [self viewWithTag:kActivityIndicateTag]) 
////    if (!newSuperview)
//    {
////        NSLog(@"close movie==");
////        [self performSelectorOnMainThread:@selector(testRemoveMov) withObject:nil waitUntilDone:NO];
////        [self performSelector:@selector(testRemoveMov) withObject:nil afterDelay:0.01];
////        [self performSelectorInBackground:@selector(testRemoveMov) withObject:nil];
////        dispatch_async(dispatch_get_global_queue(0, 0), ^{
////            [self testRemoveMov];
////        });
//        [self testRemoveMov];
//        
//    }
}

@end
