//
//  AlbumViewController.m
//  Flogger
//
//  Created by jwchen on 12-1-8.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "AlbumViewController.h"
#import "EditAlbumViewController.h"
#import "IssueGroupComServerProxy.h"
#import "GlobalData.h"
#import "IssueGruopCom.h"
#import "MyIssueGroup.h"
#import "Albuminfo.h"
#import "AlbumInfoComServerProxy.h"
#import "EntityEnumHeader.h"
#import "CheckGridCellButton.h"
#import "ShareFeedViewController.h"
#import "FeedViewerViewController.h"
#import "UIViewController+iconImage.h"
#import "FloggerInstructionView.h"


#define COMMAND_SETCOVER 100
#define COMMAND_CANCEL   200
#define ALBUMPAGESIZE 100

extern NSString * const kProfileChangedNotification;

@implementation AlbumViewController
@synthesize bottombarview,gridview,headview,orgflag,albuminfos,poupwindow,albumserverproxy,account,photoview, albumListSp, moreStatusDict, isSelectionMode, selectionDelegate;


-(void)notifyProfileChanged
{
    NSNotification *note = [NSNotification notificationWithName:kProfileChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

-(void)deinit
{
    self.gridview = nil;
    self.headview = nil;
    self.poupwindow = nil;
    self.photoview = nil;
    self.bottombarview = nil;
    self.moreStatusDict = nil;
}

-(void)dealloc
{
    self.bottombarview = nil;
    self.gridview = nil;
    self.headview = nil;
    self.albuminfos = nil;
    self.poupwindow = nil;
    self.albumserverproxy.delegate = nil;
    self.albumserverproxy = nil;
    self.account = nil;
    self.photoview = nil;
    
    self.albumListSp.delegate = nil;
    self.albumListSp = nil;
    [self deinit];
    [super dealloc];
}

-(void)reloadAlbum
{
    
    [self.gridview clearSelect];
    [self.gridview setSelectEnable:NO];
    [self.gridview setSelectEnable:YES];
    
    [self getAlbumList:NO];
    [self.tableView.tableView reloadData];
}
//-(BOOL)checkAccount
//{
//    if(![GlobalData sharedInstance].myAccount)
//    {
//        return NO;
//    }
//    if(!account)
//        return YES;
//    
//    if([account.useruid isEqualToNumber:[GlobalData sharedInstance].myAccount.account.useruid])
//        return YES;
//    else
//        return NO;
//}

-(MyIssueGroup*)getIssueGroupFromGroupID:(long long)groupid
{
    for(MyIssueGroup* group in [headview getItems])
    {
        if([group.id longLongValue] == groupid)
        {
            return group;
        }
    }
    return nil;
}

-(NSInteger)getIssueGroupIndexFromGroupID:(NSInteger)groupid
{
    NSInteger i = 0;
    for(MyIssueGroup* group in [headview getItems])
    {
        if([group.id longLongValue] == groupid)
        {
            return i;
        }
        i++;
    }
    return -1;
}

-(void)setgridviewContent:(MyIssueGroup*)issuegroup albuminfolist:(NSMutableArray*)albuminfoList : (BOOL) isRemoveSelect
{
    if (isRemoveSelect) {
        [self.gridview.dataArr removeAllObjects];
        [self.gridview.dataArr addObjectsFromArray:albuminfoList];
        //    NSLog(@"setgridviewContent self.dataarr count = %d",self.gridview.dataArr.count);
        self.gridview.hasMore = [(NSNumber *)[self.moreStatusDict objectForKey:issuegroup.id] boolValue];
        [self.gridview.tableView reloadData];
        
        if ([issuegroup.id longLongValue] != _groupid) {
            _groupid = [issuegroup.id longLongValue];
            [self getAlbumList:NO];
        }
    }
}

-(void)setgridviewContent:(MyIssueGroup*)issuegroup albuminfolist:(NSMutableArray*)albuminfoList
{
//    NSLog(@"setgridviewContent albuminfoList count = %d",albuminfoList.count);
    
    [self.gridview removeSelect];
    [self.gridview.dataArr removeAllObjects];
    [self.gridview.dataArr addObjectsFromArray:albuminfoList];
//    NSLog(@"setgridviewContent self.dataarr count = %d",self.gridview.dataArr.count);
    self.gridview.hasMore = [(NSNumber *)[self.moreStatusDict objectForKey:issuegroup.id] boolValue];
    [self.gridview.tableView reloadData];

    if ([issuegroup.id longLongValue] != _groupid) {
        _groupid = [issuegroup.id longLongValue];
        [self getAlbumList:NO];
    }
}



#pragma mark -- Http


-(void)setServerProxyWithType:(NSInteger)type
{
    if(_httptype == type){
        if (!self.serverProxy){
            switch(type)
            {
                case HTTP_GET_ALBUM:
                    self.serverProxy = [[[IssueGroupComServerProxy alloc] init] autorelease];
                    self.serverProxy.delegate = self;
                    break;
                case HTTP_DELETE_ALBUMINFO:    
                case HTTP_UPLOAD_ALBUMINFO:
                    self.serverProxy = [[[AlbumInfoComServerProxy alloc] init] autorelease];
                    self.serverProxy.delegate = self;
                    break;
            }
        }
    }
    else
    {
        if(self.serverProxy)
            self.serverProxy = nil;
        if(!self.serverProxy)
        {
            switch(type)
            {
                case HTTP_GET_ALBUM:
                    self.serverProxy = [[[IssueGroupComServerProxy alloc] init] autorelease];
                    self.serverProxy.delegate = self;
                    break;
                case HTTP_DELETE_ALBUMINFO:
                case HTTP_UPLOAD_ALBUMINFO:
                    self.serverProxy = [[[AlbumInfoComServerProxy alloc] init] autorelease];
                    self.serverProxy.delegate = self;
                    break;
            }

        }
        _httptype = type;
    }
}

-(void)deleteAlbuminfo:(NSMutableArray *)albuminfolist
{
    if (self.loading) {
        return;
    }
    
    if([GlobalData sharedInstance].myAccount == nil)
        return;
    
    self.loading = YES;
    
    //[self setServerProxyWithType:HTTP_DELETE_ALBUMINFO];
    if (!self.albumserverproxy) {
        self.albumserverproxy = [[[AlbumInfoComServerProxy alloc] init] autorelease];
        self.albumserverproxy.delegate = self;
    }

    _httptype = HTTP_DELETE_ALBUMINFO;
    
    //AlbumInfoComServerProxy *albuminfocomserverproxy = (AlbumInfoComServerProxy *)self.serverProxy;
    AlbuminfoCom *albuminfocom = [[[AlbuminfoCom alloc] init] autorelease];
    albuminfocom.albuminfoList = albuminfolist;
    albuminfocom.srcGroupID    = [NSNumber numberWithLongLong:_groupid];
    [albumserverproxy deleteAlbumInfo:albuminfocom];
    //[albuminfocomserverproxy uploadAlbumInfo:a withData:UIImageJPEGRepresentation(image, 1)];
}

-(void)uploadAlbumInfo:(UIImage*)image
{
    if (self.loading) {
        return;
    }
    
    if([GlobalData sharedInstance].myAccount == nil)
        return;
    
    self.loading = YES;
    
    //[self setServerProxyWithType:HTTP_UPLOAD_ALBUMINFO];
    if (!self.albumserverproxy) {
        self.albumserverproxy = [[[AlbumInfoComServerProxy alloc] init] autorelease];
        self.albumserverproxy.delegate = self;
    }

    _httptype = HTTP_UPLOAD_ALBUMINFO;
    
    //AlbumInfoComServerProxy *iis = (AlbumInfoComServerProxy *)self.serverProxy;
    AlbuminfoCom *albuminfocom = [[[AlbuminfoCom alloc] init] autorelease];
    //a.userUID = [GlobalData sharedInstance].myAccount.userUID;
    albuminfocom.mediaType = [NSNumber numberWithInt:ALBUM_INFO_MEDIA_PICTURE];
    albuminfocom.startSize = [NSNumber numberWithInt:0];
    [self.albumserverproxy uploadAlbumInfo:albuminfocom withData:UIImageJPEGRepresentation(image, 1)];
    
}

-(void)getAlbumList:(BOOL)isMore
{
//    if (self.loading) {
//        return;
//    }
    
    self.loading = YES;
    
    if (!self.albumListSp) {
        self.albumListSp = [[[IssueGroupComServerProxy alloc] init] autorelease];
        self.albumListSp.delegate = self;
    }
    
    
    IssueGruopCom *com = [[[IssueGruopCom alloc] init] autorelease];
    if (isMore) {
        com.searchEndID = self.gridview.endId;
        com.searchStartID = [NSNumber numberWithInt:-1];
    }
    else
    {
//        com.searchStartID = self.gridview.startId;
        com.searchStartID = [NSNumber numberWithInt:-1];
        com.searchEndID = [NSNumber numberWithInt:-1];
    }
    com.id = [NSNumber numberWithLongLong:_groupid];
    com.itemNumberOfPage = [NSNumber numberWithInt:ALBUMPAGESIZE] ;
    [self.albumListSp getAlbumInfo:com];
}

-(void)getAlbumRequest
{
    if (self.loading) {
        return;
    }
    
//    if([GlobalData sharedInstance].myAccount == nil)
//        return;
    
    self.loading = YES;
    
    //[self setServerProxyWithType:HTTP_GET_ALBUM];
    
    if (!self.serverProxy) {
        self.serverProxy = [[[IssueGroupComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    _httptype = HTTP_GET_ALBUM;
    
    IssueGroupComServerProxy *iis = (IssueGroupComServerProxy *)self.serverProxy;
    IssueGruopCom *issuegroupcom = [[[IssueGruopCom alloc] init] autorelease];
    issuegroupcom.userUID = self.account.useruid;
    issuegroupcom.itemNumberOfPage = [NSNumber numberWithInt:self.gridview.pageSize];
    [iis getAlbumInfoList:issuegroupcom];

}


-(void)setCoverRequest:(IssueGruopCom*)issuegroup
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[IssueGroupComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    _httptype = HTTP_SET_COVER;
    
    IssueGroupComServerProxy *iis = (IssueGroupComServerProxy *)self.serverProxy;
    issuegroup.type = [NSNumber numberWithInt:Album_Update];
    [iis updateAlbum:issuegroup];

}

#pragma mark -- setupView

- (void) buttonPressed:(id)sender  
{  
//    NSLog(@"album buttonpressed");
    if(sender == self.navigationItem.rightBarButtonItem){
        orgflag = !orgflag;
        [bottombarview CheckImage:orgflag];
    }
} 


-(void)setupview
{
    self.headview = [[[AlbumHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 109)] autorelease];
    
    self.headview.delegate = self;
    
//    self.gridview = [[[ClCheckGridView alloc]initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height - 110)] autorelease];
//    self.gridview.bottomOffset = 45;
    
    if ([GlobalUtils checkIsOwner:self.account] || !self.bcTabBarController) {
        self.gridview = [[[ClCheckGridView alloc]initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height - 110)] autorelease];
        self.gridview.bottomOffset = 45;
    } else {
        self.gridview = [[[ClCheckGridView alloc]initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height - 110-51)] autorelease];
        self.gridview.bottomOffset = 1;
    }
    [self.gridview setBackgroundColor:[UIColor whiteColor]];
    self.gridview.checkGridDelegate = self;
    self.gridview.type = kCheckGrid_AlbumInfo_Type;
    self.tableView = self.gridview;
    
    self.bottombarview = [[[AlbumBottomBar alloc]initWithFrame:CGRectMake(0, 372, self.view.frame.size.width, 44)]autorelease];
    self.bottombarview.delegate = self;
    
//    if (![GlobalUtils checkIsOwner:self.account]) {
//    }
    
    [self.view addSubview:self.headview];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottombarview];
    
    
//    
//    UIActionSheet *uias=UIActionSh
//                           
//    
//    uias.cancelButtonIndex = 1;
//    [uias showInView:self.view];
//    uias = nil;
    
    self.poupwindow = [[[PoupWindowViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    self.poupwindow.alpha = 0.0;
    self.poupwindow.delegate = self;
    [self.poupwindow settTitle:@"Are you sure you want to remove from favorites?"];
    [self.poupwindow setleftbtn:@"Remove" bgimg:[UIImage imageNamed:SNS_GALLARY_BUTTON]];
    [self.view addSubview:self.poupwindow];
    
    
    self.photoview = [[[PhotoDisplayView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.photoview.hidden = YES;
    
    [self.view addSubview:self.photoview];
    
    orgflag = FALSE;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    NSLog(@"albumview initWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _httptype = HTTP_GET_ALBUM;
        self.moreStatusDict = [[[NSMutableDictionary alloc] init] autorelease];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(BOOL) checkIsFullScreen
{
    if ([GlobalUtils checkIsOwner:self.account]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - View lifecycle

-(void)rightAction:(id)sender
{
    if (![GlobalUtils checkIsLogin]) {
        [super rightAction:sender];
        return;
    }
    orgflag = !orgflag;
    if (orgflag) {
        if (self.gridview.dataArr.count == 0) {
            [self showHelpView:SNS_INSTRUCTIONS_GALLERY_EDITALBUM];
        } else {
            [self showHelpView:SNS_INSTRUCTIONS_GALLERY_SELECT];
        }
        
         [self setNavigationTitleView:NSLocalizedString(@"Select items", @"Select items")];
    }else{
        [self setNavigationTitleView:NSLocalizedString(@"Gallery", @"Gallery")];
    }
    [gridview setSelectEnable:orgflag];
    [self setIsRightBarSelected:orgflag];
    [bottombarview CheckImage:orgflag];
}
-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
    self.view = view;
}

-(BOOL) checkIsShowHelpView
{
    self.helpImageURL = SNS_INSTRUCTIONS_ORGANIZE;
    if ([GlobalUtils checkIsFirstShowHelpView:self.helpImageURL] && [GlobalUtils checkIsOwner:self.account]) {
        return YES;
    } else {
        return NO;
    }
}

-(void) showHelpView : (NSString *) helpImageURL
{
    if ([GlobalUtils checkIsFirstShowHelpView:helpImageURL]) {
        FloggerInstructionView *instructionView = [[[FloggerInstructionView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withImageURL:helpImageURL] autorelease];
        [self.view.window addSubview:instructionView];        
    }
}

- (void)viewDidLoad
{
//    NSLog(@"albumview viewdidload");
    
    [self setupview];
    
    /*self.pickercontroller = [[[UIImagePickerController alloc] init]autorelease];
    pickercontroller.delegate = self;
    pickercontroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickercontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    pickercontroller.allowsEditing = YES;*/
    
    [gridview setSelectEnable:FALSE];
    gridview.checkGridDelegate = self;
    gridview.pageDelegate = self;
    gridview.refreshableTableDelegate = self;
    gridview.type = kCheckGrid_AlbumInfo_Type;
    gridview.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    [super viewDidLoad];
    _ismyself =[GlobalUtils checkIsOwner:self.account];  
    
    if(_ismyself && !isSelectionMode)
        [self setRightNavigationBarWithTitleAndImage:@"" image:SNS_ORGANIZE_BUTTON pressimage: 
         SNS_ORGANIZE_BUTTON_PRESSED];
    else
        [bottombarview setHidden:YES];    
    [self getAlbumRequest];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //[self deinit];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:NSLocalizedString(@"Gallery", @"Gallery")];
    if (self.headview.lastid == -1 && _masterGroupId) {
//        [self getAlbumRequest];
        _groupid = _masterGroupId;
        [self getAlbumList:NO];
        //scroll to to
        [self.headview.mainview scrollsToTop];
    }
    [self.headview reloadData];
//    self.headview.lastid = -1
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - checkgrid delegate
-(void)showPhotoView:(Albuminfo*)info
{
//    [self.photoview.photoview setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:info.originalurl]] placeholderImage:nil];
//    [self.photoview show];
//    [self.view bringSubviewToFront:self.photoview];
    
    FeedViewerViewController *fvc = [[[FeedViewerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    Issueinfo *issueinfo = [[[MyIssueInfo alloc] init] autorelease];
    issueinfo.id = info.issueid;
     issueinfo.issuecategory = info.type;
    fvc.issueInfo = issueinfo;
    [self.navigationController pushViewController:fvc animated:YES];
}
-(void)hidePhotoView
{
    [self.photoview hide];
}

-(void)checkgridSelectItem:(id)item
{
    if([gridview getselectnum] == 1)
    {
//        [self showHelpView:SNS_INSTRUCTIONS_GALLERY_SELECT];
        [bottombarview EnableAllBtn:TRUE]; 
    } else
    {
        [bottombarview EnableCoverBtn:FALSE]; 
    }
        
        
}
-(void)checkgridSelectNull
{
    [bottombarview EnableAllBtn:FALSE];
}
-(void)checkgridUnSelectItem:(id)item
{
    if([gridview getselectnum] == 1)
        [bottombarview EnableAllBtn:TRUE];
    else if([gridview getselectnum] > 1)
        [bottombarview EnableCoverBtn:FALSE];
    else
        [bottombarview EnableAllBtn:FALSE];
}

-(void)checkgridSelectAlbuminfo:(id)info
{
    if (isSelectionMode) {
        if (self.selectionDelegate && [self.selectionDelegate respondsToSelector:@selector(didSelectedAlbumn:)]) {
            [self.selectionDelegate didSelectedAlbumn:info];
        }
    }
    else {
        [self showPhotoView:info];
    }
}

- (void) alertView:(UIAlertView *)alertview
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==alertview.cancelButtonIndex) {
       [self poupwindowLeftAction];
    }
}
#pragma mark - Action Sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    printf("User Pressed Button %d\n", buttonIndex + 1);
    
    switch(buttonIndex)
    {
        case 0:{
            IssueGruopCom* com = [[[IssueGruopCom alloc]init] autorelease];
            com.type = [NSNumber numberWithInt:Album_Add];
            com.id =  [NSNumber numberWithLongLong:_groupid];
            MyIssueGroup* group = [self getIssueGroupFromGroupID:_groupid];
            com.groupname = group.name;
            Albuminfo *info = [gridview getSelectAlbumInfo:0];
            com.issueID = info.issueid;
            com.coverUrl = info.thumbnailurl;
            group.url = info.thumbnailurl;
//            [self.headview reloadData];
            [self setCoverRequest:com];
            [self reloadAlbum];
        }
            break;
    }
    //[actionSheet release];
    
}

-(void)showActionSheet
{
    UIActionSheet *uias=[[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"SetCover", @"SetCover"),  NSLocalizedString(@"Cancel", @"Cancel"),nil] autorelease];

    uias.cancelButtonIndex = 1;
    [uias showInView:self.view];
    uias = nil;
}


#pragma mark bottom operator
-(NSString*)createDescription:(NSInteger)numphoto videonum:(NSInteger)videonum
{
    NSString *content;
    if(numphoto == 0 && videonum == 0){
        content = NSLocalizedString(@"You have selected nothing", @"You have selected nothing");
    }else if(numphoto == 0 && videonum > 0){
        content = [NSString stringWithFormat:NSLocalizedString(@"You have selected %d video",@"You have selected %d video"),videonum];
    }else if(numphoto > 0 && videonum == 0){
        content = [NSString stringWithFormat:NSLocalizedString(@"You have selected %d photo",@"You have selected %d photo"),numphoto];
    }else{
        content = [NSString stringWithFormat:NSLocalizedString(@"You have selected %d photo and %d video",@"You have selected %d photo and %d video"),numphoto,videonum];
    }
    return content;
}


-(void)albumBottomBarCommand:(NSInteger)tag
{
//    NSLog(@"BottomBarCommand tag = %d",tag);
    switch(tag)
    {
        case ALBUM_BOTTOM_COVER:
            //[poupmenuview show];
            [self showActionSheet];
            break;
        case ALBUM_BOTTOM_SHARE:{
            ShareFeedViewController *vc = [[[ShareFeedViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            vc.shareType = SHAREISSUE;
            vc.shareComeFrom=FROM_GALLERY_SHARE;
            vc.delegate = self;
            vc.descriptionStr = [self createDescription:[gridview getPhotoSelectNum] videonum:[gridview getVideoSelectNum]];
            
            NSMutableArray* array = [[[NSMutableArray alloc]init]autorelease];
            for(MyAlbumInfo* ainfo in [gridview selectcells])
            {
                MyIssueInfo* info = [[[MyIssueInfo alloc]init]autorelease];
                info.id = ainfo.issueid;
                info.bmiddleurl = ainfo.middleUrl;
                info.shareMediaUrl = ainfo.shareMediaUrl;
                info.issuecategory = ainfo.type;
                [array addObject:info];
            }
            vc.issueList = array;
//            NSLog(@"vc issueList count = %d",vc.issueList.count);
            [self.navigationController pushViewController:vc animated:YES];
           // [self reloadAlbum];
        }
        break;
        case ALBUM_BOTTOM_ADDTO:{
            AlbumAddView *nextController = [[[AlbumAddView alloc] initWithNibName:nil bundle:nil] autorelease];
            nextController.isMove = YES;
            nextController.headview = headview;
            nextController.groupid = _groupid;
            nextController.albumlist = gridview.selectcells;
            nextController.delegate = self;
            [self.navigationController pushViewController:nextController animated:YES];    
        }
            break;
//        case ALBUM_BOTTOM_IMPORT:{
//            ComposeCommentViewController* controller = [[[ComposeCommentViewController alloc]initWithNibName:nil bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//            [controller showCaptureMedia:MEDIA_PHOTO];
//            controller.groupid = _groupid;
//            controller.delegate = self;
//        }
//            break;
        case ALBUM_BOTTOM_EDIT:{
            EditAlbumViewController *nextController = [[[EditAlbumViewController alloc] initWithNibName:nil bundle:nil] autorelease];
            [nextController setAlbumHeadView:headview];
             [self setNavigationTitleView:NSLocalizedString(@"Edit Album", @"Edit Album")];
            [self.navigationController pushViewController:nextController animated:YES];
        }
            break;
        case ALBUM_BOTTOM_DELETE:{
//            [self.poupwindow show];
//            [self.navigationItem.rightBarButtonItem setEnabled:FALSE];   
            _httptype = HTTP_DELETE_ALBUMINFO;
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to remove from favorites?",@"Are you sure you want to remove from favorites?")
                                                           message:nil
                                                          delegate:self 
                                                 cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                                                 otherButtonTitles:NSLocalizedString(@"Cancel",@"Cancel"),nil ];
            [alert show];
            [alert release];
            break;
        }
    }
    
}


#pragma mark - album head view select event
-(void)albumHeadDidSelectItem:(id)item index:(NSInteger)index
{
//    NSLog(@"albumHeadDidSelectItem index = %d",index);
    MyIssueGroup* group = (MyIssueGroup*)item;
    
    [self setgridviewContent:group albuminfolist:[self.headview.albuminfos objectAtIndex:index]];
}

#pragma mark poupmenu
/*-(void)PoupMenuCommand:(NSInteger)tag
{
    if(tag == COMMAND_SETCOVER){
        IssueGruopCom* com = [[[IssueGruopCom alloc]init] autorelease];
        com.type = [NSNumber numberWithInt:Album_Add];
        com.id =  [NSNumber numberWithInt:_groupid];
        MyIssueGroup* group = [self getIssueGroupFromGroupID:_groupid];
        com.groupname = group.name;
        Albuminfo *info = [gridview getSelectAlbumInfo:0];
        com.issueID = info.issueid;
        com.coverUrl = info.thumbnailurl;
        [self setCover:com];
    }
}
*/

//#pragma mark ComposeResultDelegate
//
//-(void)composeResultDoneWithIssueInfo:(Issueinfo*)info
//{
//    
//}
//
//-(void)composeResultDoneWithIssueInfoCom:(IssueInfoCom *)infocom
//{
//    
//    
//    [infocom issueinfo];
//    
//    if([infocom issueInfoList] == nil || [infocom issueInfoList].count == 0)
//        return;
//    NSLog(@"composeResultDoneWithIssueInfoCom infocom.issueInfoList.count = %d",infocom.issueInfoList.count);
//    Issueinfo* objIssueinfo = [[infocom issueInfoList] objectAtIndex:0];
//    Albuminfo* info = [[[Albuminfo alloc] init] autorelease];
//    info.originalurl = objIssueinfo.originalurl;
//    info.thumbnailurl = objIssueinfo.thumbnailurl;
//    //info.
//    info.groupid = infocom.groupID;
//    info.type = objIssueinfo.issuecategory;
//    
//    NSInteger i = 0;
//    for(MyIssueGroup* group in [headview getItems])
//    {
//        NSLog(@"composeResultDoneWithIssueInfoCom group.id = %d , info.groupid = %d",[group.id intValue],[info.groupid intValue]);
//        if([group.id intValue] == [info.groupid intValue])
//        {
//            [[self.headview.albuminfos objectAtIndex:i] addObject:info];
//            [self.gridview.dataArr removeAllObjects];
//            [self.gridview.dataArr addObjectsFromArray:[self.headview.albuminfos objectAtIndex:i]];
//            [self.gridview.tableView reloadData];
//        }
//        i++;
//    }
//
//    info = nil;
//    
//    
//}

#pragma mark - TransactionFinish

-(NSString*)findurlbycoverid:(NSMutableArray*)album coverid:(NSNumber*)coverid
{
    if(album != nil)
    {
        for(Albuminfo* info in album)
        {
            if(info!=nil && [coverid longLongValue] == [info.issueid longLongValue])
            {
                return info.thumbnailurl;
            }
        }
    }
    return @"";
}

-(MyIssueGroup *)getCurrentGroup
{
    for (MyIssueGroup *group in self.headview.items) {
        if ([group.id longLongValue] == _groupid) {
            return group;
        }
    }
    return nil;
}

-(NSInteger)getGroupIndex:(long long)groupId
{
    NSInteger index = -1;
    for (MyIssueGroup *group in self.headview.items) {
        index ++;
        if ([group.id longLongValue] == groupId) {
            break;
        }
    }
    return index;
}

-(void)transactionFinished:(BaseServerProxy *)sp
{
    [super transactionFinished:sp];
    
    if (self.albumListSp == sp) {
        IssueGruopCom *com = (IssueGruopCom *)sp.response;
        NSInteger index = -1;
    
        for (MyIssueGroup *group in self.headview.items) {
            index ++;
            if ([group.id isEqualToNumber:com.id]) {
                break;
            }
        }
        
        if (index >= 0) {
            NSMutableArray *oriArr = [self.headview.albuminfos objectAtIndex:index];
            NSArray *dataArr = com.albuminfoList;
            if (dataArr && dataArr.count > 0)
            {
                /*NSMutableArray *tmpArr = nil;
                if ([com.searchStartID intValue] != -1) {
                    tmpArr = [NSArray arrayWithArray:oriArr];
                    [oriArr removeAllObjects];
                }
                
                [oriArr addObjectsFromArray:dataArr];
                if (tmpArr && dataArr.count < ((ClPageTableView *)self.tableView).pageSize) {
                    [oriArr addObjectsFromArray:tmpArr];
                }*/
                if ([com.searchEndID longLongValue] == -1) {
                    [oriArr removeAllObjects];
                }
                [oriArr addObjectsFromArray:dataArr];
            }
            
            if ([com.searchStartID longLongValue] == -1) 
            {
                [self.moreStatusDict setObject:[NSNumber numberWithBool:(dataArr.count >= ALBUMPAGESIZE)] forKey:com.id];
            }
            
//            [(NSMutableArray *)[self.headview.albuminfos objectAtIndex:index] addObjectsFromArray:com.albuminfoList];
            
            [self setgridviewContent:[self getCurrentGroup] albuminfolist:[self.headview.albuminfos objectAtIndex:[self getGroupIndex:_groupid]]:YES];
        }
        
//        [self.gridview.tableView reloadData];
        
        return;
    }
    
    if(_httptype == HTTP_GET_ALBUM){
        IssueGruopCom* igc = (IssueGruopCom*)sp.response;
//        NSLog(@"gallery transactionFinished count = %d",igc.issuegroupList.count);
//        if (self.headview.mainview) {
//            for (UIView *view in self.headview.mainview.subviews) {
//                [view removeFromSuperview];
//            }
//        }
        for(MyIssueGroup* group in igc.issuegroupList)
        {
//            NSLog(@"gallery transactionFinished check group.albuminfoList count = %d",group.albuminfoList.count);
            [self.headview.albuminfos addObject:group.albuminfoList];
            if([group.type intValue] == 0){
                _masterGroupId = [group.id longLongValue];
                [self setgridviewContent:group albuminfolist:[self.headview.albuminfos objectAtIndex:0]];
            }
            
            if(group.coverid!=nil)
            {
//                NSMutableArray* lists = [self.headview.albuminfos objectAtIndex:self.headview.albuminfos.count - 1];
//                [headview addItem:group imgurl:[self findurlbycoverid:lists coverid:group.coverid]];
                [headview addItem:group imgurl:group.url];
            }
            else
            {
                [headview addItem:group imgurl:@""];

            }
        }
//        if (igc.issuegroupList.count > 0) {
//            [self.headview.mainview scrollsToTop];
//        }
        
    }else if(_httptype == HTTP_DELETE_ALBUMINFO){
//        NSLog(@"gallery delete albuminfo transactionFinished");
        for(Albuminfo* info in gridview.selectcells)
            [headview deleteAlbumInfo:info groupid:_groupid];
        [gridview removeSelect];
        [gridview.tableView reloadData];
        [self notifyProfileChanged];
        
    }else if(_httptype == HTTP_SET_COVER){
//        NSLog(@"gallery transactionFinished _httptype = HTTP_SET_COVER");
        IssueGruopCom* igc = (IssueGruopCom*)sp.response;
        if(igc.coverUrl && igc.coverUrl.length)
        {
            [headview setItemCoverImg:[self getIssueGroupFromGroupID:[igc.id longLongValue]] imgurl:igc.coverUrl];
        }
      
    }else{
//        NSLog(@"gallery transactionFinished _httptype = %d",_httptype);
    }
        
}


-(void)pageTableViewRequestLoadingMore:(ClPageTableView *)tableView
{
    [self getAlbumList:YES];
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
    [self getAlbumList:NO]; 
}

#pragma mark - poup window
-(void)poupwindowLeftAction
{
    [self.poupwindow hide];
    [self.navigationItem.rightBarButtonItem setEnabled:TRUE];
    _httptype = HTTP_DELETE_ALBUMINFO;
    [self deleteAlbuminfo:[gridview selectcells]];
}
-(void)poupwindowRightAction
{
    [self.poupwindow hide];
    [self.navigationItem.rightBarButtonItem setEnabled:TRUE];
}

#pragma mark - album move
-(void)albumMove:(BOOL)state srcgroupid:(long long)srcgroupid desgroupid:(long long)desgroupid
{
//    NSInteger index =  [self getIssueGroupIndexFromGroupID:desgroupid];
    if(state){
//        NSInteger index =  [self getIssueGroupIndexFromGroupID:desgroupid];
//        NSMutableArray* albuminfoList = [self.headview.albuminfos objectAtIndex:index];
//        [albuminfoList addObjectsFromArray:self.gridview.selectcells];
        
        NSMutableArray* albuminfoList1 = [self.headview.albuminfos objectAtIndex:[self getIssueGroupIndexFromGroupID:srcgroupid]];
        for(Albuminfo* albuminfo in self.gridview.selectcells)
            [albuminfoList1 removeObject:albuminfo];
    }
        [self.gridview removeSelect];
        [self.gridview setSelectEnable:NO];
        [self.gridview setSelectEnable:YES];
        
    [self getAlbumList:NO];
//        [self setgridviewContent:[self getCurrentGroup] albuminfolist:[self.headview.albuminfos objectAtIndex:[self getGroupIndex:_groupid]]];
        
        [self.tableView.tableView reloadData];
}

-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [self.albumserverproxy cancelAll];
    [self.albumListSp cancelAll];
}


@end
