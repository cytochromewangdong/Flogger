//
//  AlbumAddView.m
//  Flogger
//
//  Created by jwchen on 12-2-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "AlbumAddView.h"
#import "Issuegroup.h"
#import "MyIssueGroup.h"
#import "GlobalData.h"
#import "IssueGroupComServerProxy.h"
#import "IssueGruopCom.h"

#define NewAlbumTitleTag 50

@implementation AlbumAddView
@synthesize items,albumserverproxy,albumlist,headview,groupid,delegate, isMove;
@synthesize tableView;

-(void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView = nil;
    self.items = nil;
    self.albumlist = nil;
    self.albumserverproxy.delegate = nil;
    self.albumserverproxy = nil;
    self.headview =nil;
    self.delegate = nil;
    [super dealloc];
    
}
-(BOOL) checkIsFullScreen
{
    return YES;
}
-(void)setAlbum:(NSMutableArray *)albums groupid:(long long)gid
{
//    NSLog(@"Album add albums count = %d  , groupid = %d",albums.count,gid);
    for(MyIssueGroup* group in albums){
//        NSLog(@"Album add albums group.id  = %d",group.id.intValue);
        if([group.id longLongValue] == gid)
            continue;
        [self.tableView.dataArr addObject:group];
//        NSLog(@"addobject  self.tableView.dataArr count = %d",self.tableView.dataArr.count);
    }
    
//    NSLog(@"self.tableView.dataArr count = %d",self.tableView.dataArr.count);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 416);
//    view.backgroundColor = [UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    self.view = view;
    
    self.tableView = [[[ClTableView alloc] initWithFrame:self.view.bounds withStyle:UITableViewStylePlain] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
//    [self set]
    [self setLeftNavigationBarWithTitle:NSLocalizedString(@"Back", @"Back") image:nil];
    [self setRightNavigationBarWithTitle:nil image:SNS_GALLERY_NEW_ALBUM];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitleView:NSLocalizedString(@"Add to album", @"Add to album")];
    
}

-(void) rightAction:(id)sender
{
    NSString *message = [NSString stringWithFormat:@"%@\r\r",NSLocalizedString(@"Enter a name for this album", @"Enter a name for this album")];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Album", @"New Album") message:message delegate:self cancelButtonTitle:nil otherButtonTitles: NSLocalizedString(@"Cancel", @"Cancel"),NSLocalizedString(@"OK", @"OK"), nil];
    UITextField *newAlbumTextF = [[FloggerUIFactory uiFactory] createTextField];
    newAlbumTextF.frame = CGRectMake(12, 70, 260, 25);
//    newAlbumTextF.placeholder = NSLocalizedString(@"Title", @"Title");
    newAlbumTextF.tag = NewAlbumTitleTag;
    newAlbumTextF.text = NSLocalizedString(@"New Album", @"New Album");
    newAlbumTextF.backgroundColor = [UIColor whiteColor];
    UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)] autorelease];
    newAlbumTextF.leftView = paddingView;
    newAlbumTextF.leftViewMode = UITextFieldViewModeAlways;
    
    [newAlbumTextF becomeFirstResponder];
    [alertView addSubview:newAlbumTextF];
    
    [alertView show];
    [alertView release];
}

-(void) saveNewAlbum : (NSString *) newAlbumName
{
    if (!self.serverProxy) {
        self.serverProxy = [[[IssueGroupComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    IssueGroupComServerProxy *iis = (IssueGroupComServerProxy *)self.serverProxy;
    IssueGruopCom *issuegroup = [[[IssueGruopCom alloc]init] autorelease];
    issuegroup.type = [NSNumber numberWithInt:Album_Add];
    issuegroup.groupname = newAlbumName;
    [iis addAlbum:issuegroup];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            
            
        {
            UITextField *nameTextF = [alertView viewWithTag:NewAlbumTitleTag];
            [self saveNewAlbum : nameTextF.text];
        }

            break;
        default:
            break;
    }
}


- (void)viewDidLoad
{
//    [super viewDidLoad];
    [self setAlbum:[headview getItems] groupid:groupid];    
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)addAlbum:(NSInteger)index
{
    if (self.loading) {
        return;
    }
    
    if([GlobalData sharedInstance].myAccount == nil)
        return;
    
    self.loading = YES;
    
    if(!self.albumserverproxy){
        self.albumserverproxy = [[[AlbumInfoComServerProxy alloc] init] autorelease];
        self.albumserverproxy.delegate = self;
    }
    
//    AlbumInfoComServerProxy *iis = (AlbumInfoComServerProxy *)self.serverProxy;
    AlbuminfoCom *albuminfocom = [[[AlbuminfoCom alloc] init] autorelease];

    
    MyIssueGroup *group = (MyIssueGroup*)[self.tableView.dataArr objectAtIndex:index];
    albuminfocom.type =  [NSNumber numberWithInt:1];
    albuminfocom.srcGroupID  = [NSNumber numberWithLongLong:groupid];//[NSNumber numberWithInt:groupid];;
    albuminfocom.destGroupID = group.id;
    
    _desgroupid = [group.id longLongValue];
    
    albuminfocom.albuminfoList = self.albumlist;
    [self.albumserverproxy moveAlbum:albuminfocom];
}


#pragma mark - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self addAlbum:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UIImageView* imgview = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 56.5, 75.5)]autorelease];
        imgview.tag = 100;
        UITextField* textfield = [[[UITextField alloc]initWithFrame:CGRectMake(78, 40, 110, 80)]autorelease];
        textfield.tag = 101;
        textfield.font=[UIFont boldSystemFontOfSize:14];
        textfield.textColor=[[FloggerUIFactory uiFactory] createTableViewFontColor];
        textfield.enabled = NO; 
        [cell addSubview:imgview];
        [cell addSubview:textfield];
    }
    UIImageView* imgview = (UIImageView *)[cell viewWithTag:100];//[[[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 56.5, 75.5)]autorelease];
    UITextField* textfield = (UITextField*)[cell viewWithTag:101];//[[[UITextField alloc]initWithFrame:CGRectMake(78, 45, 110, 80)]autorelease];
    NSUInteger row = [indexPath row];
    Issuegroup *issue = [self.tableView.dataArr objectAtIndex:row];
//    cell.textLabel.text = [issue name];
//    cell.textLabel.font=[UIFont boldSystemFontOfSize:14];

    textfield.text=[issue name];
    
    [[imgview viewWithTag:3333] removeFromSuperview];
    if([issue url] == nil){
        imgview.image = [UIImage imageNamed: SNS_ALBUM];
    }else{
        //         [imgview setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:[issue url] ]] placeholderImage:[UIImage imageNamed: SNS_ALBUM]];
        imgview.image = [UIImage imageNamed:SNS_ALBUM];
        UIImageView *coverImage = [[[UIImageView alloc]initWithFrame:CGRectMake(3, 2, 51, 71)]autorelease];
        coverImage.layer.masksToBounds = YES; 
        coverImage.tag = 3333;
        coverImage.contentMode = UIViewContentModeScaleAspectFill;
        [coverImage setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:[issue url] ]] placeholderImage:nil];
        [imgview addSubview:coverImage];
    }

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView.tableView cellAtIndexPath:indexPath];
}




-(void)transactionFinished:(BaseServerProxy *)sp
{
    [super transactionFinished:sp];
    if (sp == self.albumserverproxy) {
        [self.navigationController popViewControllerAnimated:YES];
        if(self.delegate){
            [self.delegate albumMove:isMove srcgroupid:groupid desgroupid:_desgroupid];
        }
    } else if (sp == self.serverProxy){
//        <#statements#>
        IssueGruopCom* igc = (IssueGruopCom*)sp.response;
        MyIssueGroup* group = [[[MyIssueGroup alloc]init]autorelease];
        group.name = igc.groupname;
        group.imageurl = nil;
        group.type = igc.type;
        group.id = igc.id;
        
//        EditAlbumObject* object = [[[EditAlbumObject alloc]init:group flag:NO]autorelease];
//        object.isFocused = YES;
//        [self.dataArray addObject:object];
        
        [self.headview addItem:group imgurl:nil];
        [self.headview addAlbumList:group.albuminfoList];
        
        [self.tableView.dataArr addObject:group]; 
        
        //object = nil;
        //group = nil;
//        self.tableView.dataArr addObject:<#(id)#>
        [self.tableView.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: self.tableView.dataArr.count - 1 inSection:0];
        [self.tableView.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

-(void) cancelNetworkRequests
{
    [super cancelNetworkRequests];
    [self.albumserverproxy cancelAll];
}
@end
