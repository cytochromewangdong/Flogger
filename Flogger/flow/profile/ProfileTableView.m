//
//  ProfileTableView.m
//  Flogger
//
//  Created by steveli on 20/03/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "ProfileTableView.h"
#import "ProfileViewController.h"
#import "SBJson.h"
#import "GlobalData.h"

@implementation ProfileTableView
//@synthesize profileHeaderWebView;
@synthesize profileImageView;
@synthesize headerLayout;
@synthesize headerView = _headerView;
@synthesize handler;
/*-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:self.action object:nil];
}

-(void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.action object:nil];
}*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.profileImageView = [[[SDImageDelegate alloc]init]autorelease];
        self.profileImageView.delegate = self;
    }
    return self;
}
//-(BOOL)isTheOwner:(MyAccount*) account 
//{
//    if([account.useruid isEqualToNumber:[GlobalData sharedInstance].myAccount.account.useruid])
//        return YES;
//    else
//        return NO;
//}
-(void) callbacksetProfileImage{
    //function setMainImage(url)
    MyAccount* account = [self.dataArr objectAtIndex:0];
    
    FloggerViewAdpater *profilePhoto = [self.headerView getAdpaterByName:@"profilePhoto"];
    FloggerImageView *imageView = (FloggerImageView*)profilePhoto.view;

    [imageView setImageWithURL:[NSURL URLWithString:account.imageurl] placeholderImage:nil];
    //[self.profileHeaderWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@" setPhoto('%@')",account.imageurl]];
    
    //[[self webView]stringByEvaluatingJavaScriptFromString:self.issueInfo.imageurl];
    //function setProfileImage(url)
}
-(NSString*)action
{
    return _action;
}
- (void)setAction:(NSString *)action
{
    RELEASE_SAFELY(_action);
    _action = [action retain];
    if(action)
    {
        //self.profileHeaderWebView = [[[FloggerWebAdapter getSingleton]createProfileHeaderView:self.action]autorelease];
        //[self.profileHeaderWebView clearData];
        //[self registerNotification];  
    }
}

-(FloggerLayout*) getHeaderlayout
{
    if(!self.headerLayout)
    {
        NSString *xmlLayoutPath = [[NSBundle mainBundle]pathForResource:@"profile" ofType:@"xml"];
        NSString *xmlCSSLayoutPath = [[NSBundle mainBundle]pathForResource:@"profile.css" ofType:@"xml"];
        headerLayout = [[FloggerLayoutAdapter sharedInstance]createLayout:xmlLayoutPath StylePath:xmlCSSLayoutPath];
    }
    return self.headerLayout;
}
-(FloggerViewAdpater*) headerView
{
    if(!_headerView)
    {
        _headerView = [[FloggerLayoutAdapter sharedInstance] createViewSet:[self getHeaderlayout] ParentAapter:nil ActionHandler:self];
    }
    return _headerView;
}
- (void)fillHeaderCell
{
    MyAccount* account = [self.dataArr objectAtIndex:0];
    if(account)
    {
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary: account.dataDict];
        BOOL ismyself = [GlobalUtils checkIsOwner:account];//[self isTheOwner:account];
        //[data setObject:[NSNumber numberWithBool:ismyself] forKey:KEY_ISOWN];
        NSMutableDictionary *invisibleList = [[[NSMutableDictionary alloc]init]autorelease];
        if(ismyself || ![GlobalUtils checkIsLogin])
        {
            [invisibleList setObject:@"followContainer" forKey:@"followContainer"];
        }

        //nsloaclized
        [data setObject:NSLocalizedString(@"Followers", @"Followers") forKey:@"lblFollowersCount"];
        [data setObject:NSLocalizedString(@"Following", @"Following") forKey:@"lblFollowingCount"];
        [data setObject:NSLocalizedString(@"Gallery", @"Gallery") forKey:@"lblGalleryCount"];
        NSString *followTxt = nil;
        NSMutableDictionary* fillParam = [[[NSMutableDictionary alloc]init]autorelease];
        
        NSString *displayName = nil;
        if ([data objectForKey:@"fname"] && [[data objectForKey:@"fname"] length] > 0) {
            displayName = [data objectForKey:@"fname"];
            [data setObject:displayName forKey:@"profileName"];
        } else {
            if ([data objectForKey:@"username"]) {
                displayName = [data objectForKey:@"username"];
                [data setObject:displayName forKey:@"profileName"];
            } else {
                displayName = @"";
                [data setObject:displayName forKey:@"profileName"];
            }
        }
        
        if(![account.followed boolValue])
        {
            followTxt = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"You are not following", @"You are not following"), displayName];
            FloggerLayoutParam *paramFollow= [[[FloggerLayoutParam alloc]init]autorelease];
            [fillParam setObject:paramFollow forKey:@"follow-btn"];
            paramFollow.actionType = @"follow";
            paramFollow.image = [UIImage imageNamed:@"sns_Follow_Button.png"];
            
            [data setObject:NSLocalizedString(@"Follow", @"Follow") forKey:@"followBtnLabel"];
        } else {
            followTxt = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"You are following", @"You are following"), displayName];
            FloggerLayoutParam *paramFollow= [[[FloggerLayoutParam alloc]init]autorelease];
            [fillParam setObject:paramFollow forKey:@"follow-btn"];
            paramFollow.actionType = @"unfollow";
            paramFollow.image = [UIImage imageNamed:@"sns_Unfollow_Button.png"];
            
            [data setObject:NSLocalizedString(@"Unfollow", @"Unfollow") forKey:@"followBtnLabel"];
        }
        [data setObject:followTxt forKey:@"lblFollowing"];

        [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.headerView ViewDisplayParameters:fillParam DataFillParameters:data InvisibleViews:invisibleList];
        //[self.profileHeaderWebView fillData:[data JSONRepresentation]];
        //profileImageView.delegate = self;
        if(account.imageurl)
        {
            BOOL ret = [self.profileImageView loadImageWithURL:account.imageurl];
            if(ret)
            {
                [self callbacksetProfileImage];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self isCellForMore:[indexPath row]]) {                 
        return [self cellForMore:tableView];
    }
    
    if([indexPath row] == 0)
    {
        static NSString *ProfileCellIdentifier = @"ProfileCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProfileCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            FloggerViewAdpater *headerView = self.headerView ;
            [cell.contentView addSubview:headerView.view];
        }
        
        [self fillHeaderCell];
        
        return cell;
    }
    else
    {
        
        static NSString *CellIdentifier = @"FeedViewCell";
        
        FeedViewCell *cell = (FeedViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[FeedViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease ];
            cell.action =self.action;
            cell.delegate = self;
        }
        
        if([indexPath row] > 0)
        {
            Issueinfo *issueinfo = [self.dataArr objectAtIndex:[indexPath row]];
            //modify profile image begin
            MyAccount *account = [self.dataArr objectAtIndex:0];
            BOOL ismyself = [GlobalUtils checkIsOwner:account];//[self isTheOwner:account];
            if (ismyself) {
                issueinfo.imageurl = account.imageurl;
            }
            //modify profile image end
            cell.issueInfo = issueinfo;
        }
        
        return cell;
    }
}
- (void) handleAction:(NSNotification *)notification
{
    //if(!notification.object)
    {
        [self.handler handleAction:notification];
        //[self.tableView reloadData];
    }
}
-(void)handleAction:(NSInteger)actionType withIssueInfo:(Issueinfo *)issueInfo
{
    if (actionType == kTagProfileBtn) {
        if ((!issueInfo.inspiredid && issueInfo.username)|| (issueInfo.inspiredid && [issueInfo.inspiredid isEqualToNumber:issueInfo.useruid])){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return;
        }
    }
    [super handleAction:actionType withIssueInfo:issueInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self isCellForMore:[indexPath row]]) 
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    if([indexPath row] == 0)
    {
        [self fillHeaderCell];
        return self.headerView.view.frame.size.height;
    }
    /*if(!self.heightview)
    {
        self.heightview = [[FloggerLayoutAdapter sharedInstance] createViewSet:[self getMainlayout] ParentAapter:nil ActionHandler:nil];   
    }*/

    Issueinfo *issueinfo = [self.dataArr objectAtIndex:[indexPath row]];
    //return [FeedViewCell tableView:tableView heightForItem:issueinfo];
    NSMutableDictionary *displayParam = [FeedViewCell createParamFromIssueInfo:issueinfo ExtraParam:nil];
    NSMutableDictionary *invisibleList = [FeedViewCell createInvisibleList:issueinfo ExtraParam:nil];
    CGRect rect = [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.heightview ViewDisplayParameters:displayParam DataFillParameters:issueinfo.dataDict InvisibleViews:invisibleList];
    
    return rect.size.height;
}
-(void)downloadFinished:(SDImageDelegate*)downloader
{
    if(downloader==self.profileImageView)
    {
        [self callbacksetProfileImage];
    }
}

-(void)dealloc
{
    //[self unregisterNotification];
    //self.profileHeaderWebView = nil;
    self.profileImageView.delegate = nil;
    self.profileImageView = nil;

    self.headerLayout = nil;
    RELEASE_SAFELY(_headerView);
    RELEASE_SAFELY(_action);
    [super dealloc];
}
@end
