//
//  ViewerFeedTableView.m
//  Flogger
//
//  Created by dong wang on 12-4-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ViewerFeedTableView.h"
#import "ViewerCell.h"
#import "SBJson.h"
#import "FeedViewerViewController.h"

@implementation ViewerFeedTableView
@synthesize headerLayout;
//@synthesize viewerHeaderWebView;
@synthesize headerView = _headerView,showHeader;
@synthesize profileImageView,mainImageView;//, viewerShapeWebView;
-(id) init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.showHeader = YES;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        self.showHeader = YES;
    }
    return self;
}
-(id)initWithFrame:(CGRect)anFrame andApplyCssFromSelector:(NSString *)anSelector
{
    self =[super initWithFrame:anFrame andApplyCssFromSelector:anSelector];
    if (self) {
        // Custom initialization
        self.showHeader = YES;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style
{
    self = [super initWithFrame:frame withStyle:style];
    if (self) {
        // Custom initialization
        self.showHeader = YES;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.showHeader = YES;
    }
    return self;
}
-(NSString*)action
{
    return _action;
}
-(void) adjustViewerCell
{
    self.mainImageView =[[[SDImageDelegate alloc]init]autorelease];
    self.profileImageView = [[[SDImageDelegate alloc]init]autorelease];
    
}
/*- (void) handleAction:(NSNotification *)notification
{
    if(!notification.object)
    {
        [self.tableView reloadData];
    } else 
    {
        Issueinfo * param =  [self.dataArr objectAtIndex:0];
        NSInteger actionType = 0;
        if([[notification.object objectForKey:kScheme] isEqualToString:kTagTag])
        {
            NSString *tag = [notification.object objectForKey:kKeyword];
            dispatch_async(dispatch_get_main_queue(), ^{
                    [self openTag:tag];
            } );
        } else 
            if([[notification.object objectForKey:kScheme] isEqualToString:kAtTag])
            {
                actionType = kTagProfileBtn;
                param = [[[Issueinfo alloc]init]autorelease]; 
                NSString *at = [notification.object objectForKey:kKeyword];
                param.useruid = [NSNumber numberWithLongLong:[at longLongValue]];
                NSLog(@"value %@",param.useruid);
            } else 
                if([@"like" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
                {
                    if (![GlobalUtils checkIsLogin]) {
                        return;
                    }
                    actionType = kTagLikeBtn;
                } else
                    if([@"unlike" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
                    {
                        if (![GlobalUtils checkIsLogin]) {
                            return;
                        }
                        actionType = kTagDeleteLikeBtn;
                    } else 
                        if([@"comment" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
                        {
//                            actionType = kTagCommentBtn;
                        } else 
                            if([@"report" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
                            {
                                if (![GlobalUtils checkIsLogin]) {
                                    return;
                                }
                                actionType = kTagFlagBtn;
                            } else 
                                if([@"share" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
                                {
                                    if (![GlobalUtils checkIsLogin]) {
                                        return;
                                    }
                                    actionType = kTagShareBtn;
                                } else 
                                    if([@"profile" isEqualToString:[notification.object objectForKey:KEY_WEB_ACTION]])
                                    {
                                        actionType = kTagProfileBtn;
                                    } else 
                                        if([@"photo" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
                                        {
                                            actionType = kTagImageBtn;
                                        } else
                                        if([@"playVideo" isEqual:[notification.object objectForKey:KEY_WEB_ACTION]])
                                        {
                                            actionType = kTagPlayVideo;
                                        }
        dispatch_async(dispatch_get_main_queue(), ^{
                [self handleAction:actionType withIssueInfo:param];
        } );

    }
}*/
//-(void) go2PlayVideo:(Issueinfo *)issueinfo
//{
//    //to do play video    
//    NSURL *videoUrl = [NSURL URLWithString:[NSString stringWithFormat:issueinfo.videourl]];
//    MPMovieSourceType movieSourceType = MPMovieSourceTypeUnknown;
//    movieSourceType = MPMovieSourceTypeStreaming;
//    
//    MPMoviePlayerViewController *moviePlayer = [[[MPMoviePlayerViewController alloc] initWithContentURL:videoUrl] autorelease];
//    moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//    moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [moviePlayer.moviePlayer prepareToPlay];
//    [moviePlayer.moviePlayer play];
//    [self.feedTableDelegate.navigationController presentModalViewController:moviePlayer animated:YES];    
//}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:self.action object:nil];
//    [su]
}

-(void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.action object:nil];
}
/*- (void)setAction:(NSString *)action
{
    RELEASE_SAFELY(_action);
    _action = [action retain];
    if(action)
    {
        self.viewerHeaderWebView = [[[FloggerWebAdapter getSingleton]createViewerHeaderView:self.action]autorelease];
        self.viewerShapeWebView =  [[[FloggerWebAdapter getSingleton]createViewerView:self.action]autorelease];
        [self adjustViewerCell];
        [self registerNotification];  
    }
}
-(void) callbacksetMainImage{
    //function setMainImage(url)
    [self.viewerHeaderWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@" setMainImage('%@')",((Issueinfo *)[self.dataArr objectAtIndex:0]).bmiddleurl]];
    //function setProfileImage(url)
}
-(void) callbacksetProfileImage{
    [self.viewerHeaderWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@" setProfileImage('%@')",((Issueinfo *)[self.dataArr objectAtIndex:0]).imageurl]];
}*/
-(FloggerLayout*) getMainlayout
{
    if(!self.cellLayout)
    {
        NSString *xmlLayoutPath = [[NSBundle mainBundle]pathForResource:@"viewer" ofType:@"xml"];
        NSString *xmlCSSLayoutPath = [[NSBundle mainBundle]pathForResource:@"viewer.css" ofType:@"xml"];
        self.cellLayout = [[[FloggerLayoutAdapter sharedInstance]createLayout:xmlLayoutPath StylePath:xmlCSSLayoutPath]autorelease];
    }
    return self.cellLayout;
}

-(FloggerLayout*) getHeaderlayout
{
    if(!self.headerLayout)
    {
        NSString *xmlLayoutPath = [[NSBundle mainBundle]pathForResource:@"feed" ofType:@"xml"];
        NSString *xmlCSSLayoutPath = [[NSBundle mainBundle]pathForResource:@"feed.css" ofType:@"xml"];
        self.headerLayout = [[[FloggerLayoutAdapter sharedInstance]createLayout:xmlLayoutPath StylePath:xmlCSSLayoutPath] autorelease];
    }
    return self.headerLayout;
}
-(FloggerViewAdpater*) headerView
{
    if(!_headerView)
    {
        _headerView = [[FloggerLayoutAdapter sharedInstance] createViewSet:[self getHeaderlayout] ParentAapter:nil ActionHandler:nil];
    }
    return _headerView;
}
-(NSMutableDictionary*) extraParam
{
    NSMutableDictionary *param = [[[NSMutableDictionary alloc]init]autorelease];
//    [param setObject:@"0" forKey:@"delete"];
    [param setObject:@"0" forKey:@"comment"];
    [param setObject:@"1" forKey:@"removeLastLine"];
    return param;
}
//-(NSInteger) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.showHeader) {
//        return 1;
//    } else {
//        return self.dataArr.count;
//    }
//}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) 
    {
        if (self.showHeader) {
            return 1;
        } else {
            return [super tableView:tableView numberOfRowsInSection:section];
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
        static NSString *viewerCellIdentifier = @"ViewerCellIdentifier";
        ViewerCell* cell = [tableView dequeueReusableCellWithIdentifier:viewerCellIdentifier];
        if(!cell)
        {
            cell = [[[ViewerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:viewerCellIdentifier] autorelease];  
            cell.extraParam = [self extraParam];
            cell.action = self.action;
            cell.delegate = self;
        }
        
        Issueinfo *issueinfo= [self.dataArr objectAtIndex:0];
        [cell setIssueInfo:issueinfo Layout:self.headerLayout];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"ViewerCell";
        
        ViewerCell *cell = (ViewerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[ViewerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.action = self.action;
            cell.delegate = self;
        }
        
        Issueinfo *issueinfo = [self.dataArr objectAtIndex:[indexPath row]];
        NSMutableDictionary *extraDic = [[[NSMutableDictionary alloc] init] autorelease];
        [extraDic setObject:[NSNumber numberWithBool:YES] forKey:@"subView"];
        
        cell.extraParam = extraDic;
        cell.issueInfo = issueinfo;
        //cell setIssueInfo:<#(Issueinfo *)#> Layout:<#(FloggerLayout *)#>
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isCellForMore:[indexPath row]]) 
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    if([indexPath row] == 0)
    {
        /*int height = 0;
        if(self.viewerHeaderWebView.isLoaded)
        {
            Issueinfo *issueinfo = [self.dataArr objectAtIndex:0];
            if(issueinfo)
            {
                [self.viewerHeaderWebView fillData:[issueinfo.dataDict JSONRepresentation]];
                height = [self.viewerHeaderWebView getHeight];
            }
        }
        return height? height:221;*/
        if(!self.showHeader)
        {
            return 0;
        }
        NSMutableDictionary *eParam = [self extraParam];
        Issueinfo *issueinfo = [self.dataArr objectAtIndex:0];
        CGRect rect = [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.headerView ViewDisplayParameters:[FeedViewCell createParamFromIssueInfo:issueinfo ExtraParam:eParam] DataFillParameters:issueinfo.dataDict InvisibleViews:[FeedViewCell createInvisibleList:issueinfo ExtraParam:eParam]];
        return rect.size.height;//[FeedViewCell tableView:tableView heightForItem:issueinfo];
    }
    
//    Issueinfo *issueinfo = [self.dataArr objectAtIndex:[indexPath row]];
//    if(!self.heightview)
//    {
//        self.heightview = [[FloggerLayoutAdapter sharedInstance] createViewSet:[self getViewMainlayout] ParentAapter:nil ActionHandler:nil];   
//    }
//    
//    CGRect rect = [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.heightview ViewDisplayParameters:[[FeedViewCell createParamFromIssueInfo:issueinfo]autorelease] DataFillParameters:issueinfo.dataDict InvisibleViews:[[FeedViewCell createInvisibleList:issueinfo]autorelease]];

    
    Issueinfo *issueinfo = [self.dataArr objectAtIndex:[indexPath row]];
    NSMutableDictionary *extraDic = [[[NSMutableDictionary alloc] init] autorelease];
    [extraDic setObject:[NSNumber numberWithBool:YES] forKey:@"subView"];
    
    CGRect rect = [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.heightview ViewDisplayParameters:[FeedViewCell createParamFromIssueInfo:issueinfo ExtraParam:extraDic] DataFillParameters:issueinfo.dataDict InvisibleViews:[FeedViewCell createInvisibleList:issueinfo ExtraParam:extraDic]];
    return rect.size.height;//[FeedViewCell tableView:tableView heightForItem:issueinfo];
    
}

-(void)handleAction:(NSInteger)actionType withIssueInfo:(Issueinfo *)issueInfo
{
    if (actionType == kTagPlayVideoComment || actionType == kTagPhotoComment || actionType == kTagShowFullThread) {
//        actionType = kTagCommentBtn;
        FeedViewerViewController *viewerController = [[[FeedViewerViewController alloc] init] autorelease];
        viewerController.issueInfo = [[[MyIssueInfo alloc] init] autorelease];//issueinfo;
        viewerController.issueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:issueInfo.dataDict];
        [self.feedTableDelegate.navigationController pushViewController:viewerController animated:YES];
        return;
    } else if (actionType == kTagAtSomebody) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAtSomebodyAction object:issueInfo];
    }else{
       
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyboardHide object:nil];
//        [NSNotificationCenter defaultCenter] 
        
    }
//    else if (actionType == kTagDelete)
//    {
//        
//    }
    [super handleAction:actionType withIssueInfo:issueInfo];
}

//-(void) tran

-(void)dealloc
{
    [self unregisterNotification];
    //self.viewerHeaderWebView = nil;
    self.mainImageView.delegate = nil;
    self.profileImageView.delegate = nil;
    self.profileImageView = nil;
    self.mainImageView = nil;
    self.headerLayout = nil;
    RELEASE_SAFELY(_headerView);
    RELEASE_SAFELY(_action);
    [super dealloc];
}
@end
