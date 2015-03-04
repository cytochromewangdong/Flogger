//
//  EditAlbumViewController.m
//  Flogger
//
//  Created by steveli on 06/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "EditAlbumViewController.h"
#import "Issuegroup.h"
#import "IssueGruopCom.h"
#import "IssueGroupComServerProxy.h"
#import "Three20/Three20.h"

#define TAG_DELETE_ICON 1
#define TAG_IMAGEVIEW   2
#define TAG_DELETE_BTN  3
#define TAG_TEXTFIELD   4
#define TAG_NUMLABLE    5


@implementation EditAlbumObject
@synthesize deleteflag,myissuegroup,coverurl, isFocused;

-(id)init:(MyIssueGroup*)issuegroup flag:(BOOL)f
{
    self = [super init];
    if (self) {
        self.myissuegroup = issuegroup;
        deleteflag = f;
    }
    return self;
    
}
-(void)dealloc
{
    self.myissuegroup = nil;
    self.coverurl     = nil;
    [super dealloc];
}
@end



@implementation EditAlbumViewController
@synthesize headview,ischange,items_delflag,tempname;

-(void)dealloc
{
    self.headview      = nil;
    self.items_delflag = nil;
    self.tempname = nil;
    [super dealloc];
}

-(void)setAlbumHeadView:(AlbumHeadView *)hview
{
//    NSLog(@"setAlbumHeadView ");
    self.headview = hview;
}

-(void)setAlbum:(NSMutableArray *)albums
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(MyIssueGroup*)getIssueGroup:(NSInteger)index
{
    return [(EditAlbumObject*)[self.dataArray objectAtIndex:index] myissuegroup];
}


#pragma net service
-(void)addAlbum:(IssueGruopCom*)issuegroup
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[IssueGroupComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    IssueGroupComServerProxy *iis = (IssueGroupComServerProxy *)self.serverProxy;
    issuegroup.type = [NSNumber numberWithInt:Album_Add];
    issuegroup.groupname = NSLocalizedString(@"New Album", @"New Album");
    
    NSInteger index=0;
    BOOL flag=TRUE;
    while (TRUE) {
        for(MyIssueGroup* group in [headview getItems]){
            if ([issuegroup.groupname isEqualToString: group.name]) {
                index++;
                flag=FALSE;
                break;
            }
        }
        issuegroup.groupname= [NSString stringWithFormat:NSLocalizedString(@"New Album%d", @"New Album%d"), index];
        if (flag) {
            if (index==0) {
                issuegroup.groupname = NSLocalizedString(@"New Album", @"New Album");
            }
            break;
        }else{
            flag=TRUE;
        }
    }

    [iis addAlbum:issuegroup];
    
    _type = Album_Add;

}

-(void)deleteAlbum:(IssueGruopCom*)issuegroup
{
    if (self.loading) {
        return;
    }
    
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[IssueGroupComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    IssueGroupComServerProxy *iis = (IssueGroupComServerProxy *)self.serverProxy;
    issuegroup.type = [NSNumber numberWithInt:Album_Delete];
    [iis deleteAlbum:issuegroup];
    
    _type = Album_Delete;

}
-(void)updateAlbum:(IssueGruopCom*)issuegroup
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[IssueGroupComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    IssueGroupComServerProxy *iis = (IssueGroupComServerProxy *)self.serverProxy;
    issuegroup.type = [NSNumber numberWithInt:Album_Delete];
    [iis updateAlbum:issuegroup];

    _type = Album_Update;
}


-(void)transactionFailed:(BaseServerProxy *)serverproxy
{
    [super transactionFailed:serverproxy];
    if(_type == Album_Update){
        [self.tableView reloadData]; 
    }
}

-(void)transactionFinished:(BaseServerProxy *)serverproxy
{
    IssueGruopCom* igc = (IssueGruopCom*)serverproxy.response;
//    NSLog(@"gallery transactionFinished count = %d",igc.issuegroupList.count);
    if(igc.issuegroupList == 0)
        return;
    
    switch(_type)
    {
        case Album_Add:
            {
                MyIssueGroup* group = [[[MyIssueGroup alloc]init]autorelease];
                group.name = igc.groupname;
                group.imageurl = nil;
                group.type = igc.type;
                group.id = igc.id;
                
                EditAlbumObject* object = [[[EditAlbumObject alloc]init:group flag:NO]autorelease];
                object.isFocused = YES;
                [self.dataArray addObject:object];
                
                [self.headview addItem:group imgurl:nil];
                [self.headview addAlbumList:group.albuminfoList];
                
                //object = nil;
                //group = nil;
                [self.tableView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow: self.dataArray.count - 1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
            }
            break;
        case Album_Delete:
            {
                [self.dataArray removeObjectAtIndex:_deleteindex];
                if (self.headview.lastid == _deleteindex + 1) {
                    self.headview.lastid = -1;
                }
                
                [self.headview.items removeObjectAtIndex:_deleteindex];
                [self.headview deleteAlbumList:_deleteindex];
                [self.tableView reloadData]; 
            }
            break;
        case Album_Update:
            {
                MyIssueGroup* group = [self getIssueGroup:_updateindex];
//                [self getIssueGroup:_updateindex].name = _tempname;
                [group setName:tempname];
                [self.tableView reloadData];
            }
            break;
    }
    
    [super transactionFinished:serverproxy];
}


#pragma mark - View lifecycle

-(void)rightAction:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled=NO;
    self.navigationItem.rightBarButtonItem = nil;
//     [self setLeftNavigationBarWithTitle:NSLocalizedString(@"Back", @"Back") image:SNS_BACK_BUTTON];
    IssueGruopCom* com = [[[IssueGruopCom alloc]init] autorelease];
    com.type = [NSNumber numberWithInt:Album_Add];
    com.groupname = NSLocalizedString(@"New Album", @"New Album");
    [self addAlbum:com];
}

-(void)leftAction:(id)sender
{
    
    [self.headview reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) loadView
{
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
//    view.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];
    self.view = view;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
//setLeftNavigationBarWithTitle
//    [self setRightNavigationBarWithTitle: NSLocalizedString(@"New Album",@"New Album")image:SNS_BUTTON_GREY];
    [self setRightNavigationBarWithTitle:nil image:SNS_GALLERY_NEW_ALBUM];
//    [self setLeftNavigationBarWithTitle:NSLocalizedString(@"Back", @"Back") image:SNS_BACK_BUTTON];
    [self setBackNavigation];
    ischange = NO;
    _showkeyboard = NO;
    _type = 0;
    _deleteindex = 0;
    //[self registerForKeyboardNotifications];

    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.tableView.backgroundColor=[UIColor colorWithPatternImage:[[FloggerUIFactory uiFactory] createImage:SNS_BACKGROUND_TEXTURE]];//[[FloggerUIFactory uiFactory] createBackgroundColor];
    //NSInteger i = 0;
    NSMutableArray *tempdatas = [[[NSMutableArray alloc] init] autorelease];

    for(MyIssueGroup* group in [headview getItems]){
        EditAlbumObject* object = [[[EditAlbumObject alloc]init:group flag:NO]autorelease];
//        NSLog(@"qweqwe = %@",object.myissuegroup.url);
        [tempdatas addObject:object];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArray = tempdatas;
    
//    NSLog(@"headview items count = %d , self.dataArray count = %d",[headview getItems].count,self.dataArray.count);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


/*- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    if(_showkeyboard == NO){
        [super keyboardWillBeShown:aNotification];
        _showkeyboard = YES;
        
        CGRect frame = self.tableView.frame;
        frame.size.height -= self.keyboardRect.size.height;
        self.tableView.frame = frame;

    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    _showkeyboard = NO;
    CGRect frame = self.tableView.frame;
    frame.size.height = self.view.frame.size.height;
    self.tableView.frame = frame;
    
    NSLog(@"keyboardWillBeHidden table x = %f,y = %f,w = %f,h = %f",self.tableView.tableView.frame.origin.x,self.tableView.tableView.frame.origin.y,self.tableView.tableView.frame.size.width,self.tableView.tableView.frame.size.height);

}
*/
#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField;
{
//    NSLog(@"editalbum textFieldDidEndEditing");
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"edit album textFieldDidEndEditing");
    //NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell*)textField.superview];
    //_updateindex = path.row;

//       EditAlbumObject* object = [self.dataArray objectAtIndex:path.row];
//  textField.text = [object.myissuegroup name];
    self.navigationItem.rightBarButtonItem.enabled=YES;
      [self setRightNavigationBarWithTitle: nil image:SNS_GALLERY_NEW_ALBUM];
//     [self setLeftNavigationBarWithTitle:NSLocalizedString(@"Back", @"Back") image:SNS_BACK_BUTTON];
    [self setBackNavigation];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    NSLog(@"edit album textFieldShouldReturn");

    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell*)textField.superview];
    _updateindex = path.row;
    EditAlbumObject* object = [self.dataArray objectAtIndex:path.row];
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([textField.text isEqualToString: @""]||textField.text == nil || [textField.text isEqualToString:object.myissuegroup.name]){
        textField.text =object.myissuegroup.name;
        [textField resignFirstResponder];
        return YES;
    }
    IssueGruopCom* com = [[[IssueGruopCom alloc]init] autorelease];
    com.type = [NSNumber numberWithInt:Album_Add];
    com.id = [self getIssueGroup:path.row].id;
    com.groupname = textField.text;
    [self updateAlbum:com];
    self.tempname = textField.text;
    [textField resignFirstResponder];
    
    return YES;
    
}

-(void)deleteiconbtnpress:(id)sender
{
//    NSLog(@"album deleteiconbtnpress");
    UIButton* btn = (UIButton*)sender;
    UITableViewCell *cell = (UITableViewCell *) [btn superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    int count =[self.dataArray count];
    for(int i=0; i < count; i++){
        if (i==row) {
            EditAlbumObject* object = (EditAlbumObject*)[self.dataArray objectAtIndex:row];
            object.deleteflag = !object.deleteflag;
        }else{
            ((EditAlbumObject*)[self.dataArray objectAtIndex:i]).deleteflag=NO;
        }

    }
    [self.tableView reloadData];
    /*[self.tableView reloadData];
    
    
    UIButton* deletebtn = (UIButton*)[cell viewWithTag:TAG_DELETE_BTN];
    if(deletebtn.isHidden){
        [deletebtn setHidden:NO];
        [btn setBackgroundImage:[UIImage imageNamed:@"Delete_Circle_Icon_Rotated.png"] forState:UIControlStateNormal];
        
        
        NSNumber* num = [items_delflag objectAtIndex:row];
        num = [NSNumber numberWithInt:1];
        
    }else{
        [deletebtn setHidden:YES];
        [btn setBackgroundImage:[UIImage imageNamed:@"Delete_Circle_Icon.png"] forState:UIControlStateNormal];
        NSNumber* num = [items_delflag objectAtIndex:row];
        num = [NSNumber numberWithInt:0];
    }*/
}

//-(void)deletebtnpress:(id)sender
//{
//    NSLog(@"album deletebtnpress");
//    UIButton* btn = (UIButton*)sender;
//    UITableViewCell *cell = (UITableViewCell *) [btn superview];
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    NSInteger row = indexPath.row;
//    _deleteindex = row;
//    
//    
//    IssueGruopCom* com = [[[IssueGruopCom alloc]init] autorelease];
//    com.type = [NSNumber numberWithInt:Album_Add];
//    com.id = [self getIssueGroup:row].id;
//    [self deleteAlbum:com];
//
//    
//    //[self.data removeObjectAtIndex:row];
//    //[self.tableView reloadData];
//}
-(void)deletebtnpress:(id)sender
{

    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Really want to delete this gallery?",@"Really want to delete this gallery?")
                                                   message:nil
                                                  delegate:self 
                                         cancelButtonTitle:NSLocalizedString(@"OK",@"OK")
                                         otherButtonTitles:NSLocalizedString(@"Cancel",@"Cancel"),nil ];
    UIButton* btn = (UIButton*)sender;
    UITableViewCell *cell = (UITableViewCell *) [btn superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    alert.tag= indexPath.row;


    [alert show];
    [alert release];
    //[self.data removeObjectAtIndex:row];
    //[self.tableView reloadData];
}

- (void) alertView:(UIAlertView *)alertview
	clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==alertview.cancelButtonIndex) {

//        NSLog(@"album deletebtnpress");
        NSInteger row = alertview.tag;
        _deleteindex = row;

        IssueGruopCom* com = [[[IssueGruopCom alloc]init] autorelease];
        com.type = [NSNumber numberWithInt:Album_Add];
        com.id = [self getIssueGroup:row].id;
        [self deleteAlbum:com];

    }
}


#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}*/



-(void)createCell:(UITableViewCell*)cell row:(NSInteger)row
{
    UIButton* btn = [[[UIButton alloc]initWithFrame:CGRectMake(12, 41, 26, 26)]autorelease];
    btn.tag = TAG_DELETE_ICON;
    [btn setBackgroundImage:[UIImage imageNamed:SNS_MINUS] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:SNS_MINUS_ROTATED] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(deleteiconbtnpress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgview = [[[UIImageView alloc]initWithFrame:CGRectMake(55, 13, 56.5, 75.5)]autorelease];
    imgview.tag = TAG_IMAGEVIEW;
    
    
    UIButton* deletebtn = [[[UIButton alloc]initWithFrame:CGRectMake(240, 32, 65, 35)]autorelease];
    deletebtn.tag = TAG_DELETE_BTN;
    [deletebtn setBackgroundImage:[UIImage imageNamed: SNS_ALBUM_DELETE_BUTTON] forState:UIControlStateNormal];
    deletebtn.hidden = TRUE;
    [deletebtn addTarget:self action:@selector(deletebtnpress:) forControlEvents:UIControlEventTouchUpInside];
    [deletebtn setTitle: NSLocalizedString(@"Delete", @"Delete") forState:UIControlStateNormal];
    UIFont *famFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    deletebtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    deletebtn.titleLabel.font = famFont;
    
    UITextField* textfield = [[[UITextField alloc]initWithFrame:CGRectMake(127, 5, 110, 80)]autorelease];
    textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfield.tag = TAG_TEXTFIELD;
    textfield.font=[UIFont boldSystemFontOfSize:14];
    textfield.returnKeyType = UIReturnKeyDone;
    textfield.delegate = self;
    
    UILabel *numLab = [[FloggerUIFactory uiFactory] createLable];
    numLab.tag = TAG_NUMLABLE;
    numLab.frame = CGRectMake(127, 19, 110, 80);
    numLab.textAlignment = UITextAlignmentLeft;
//    numLab.text = @"300";
    numLab.font = [UIFont systemFontOfSize:10];
    numLab.textColor = [[FloggerUIFactory uiFactory] createNumFontColor];
   

    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:textfield];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidEndEditing:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:textfield];

    
    */
    UILabel *lineLab = [[FloggerUIFactory uiFactory] createLable];
    lineLab.frame = CGRectMake(0, 99, 320, 1);
    lineLab.backgroundColor =  [UIColor colorWithRed:181/255.0  green:180/255.0 blue:174/255.0 alpha:1.0];
    lineLab.tag = 150;
    
    
    UILabel *lineLab2 = [[FloggerUIFactory uiFactory] createLable];
    lineLab2.frame = CGRectMake(0, 100, 320, 1);
    lineLab2.backgroundColor =  [UIColor whiteColor];
    lineLab2.tag = 151;
    [cell addSubview:lineLab];
    [cell addSubview:lineLab2];
    
    [cell addSubview:btn];
    [cell addSubview:imgview];
    [cell addSubview:deletebtn];
    [cell addSubview:textfield];
    [cell addSubview:numLab];
    
    btn = nil;
    imgview = nil;
    deletebtn = nil;
    textfield = nil;
    numLab=nil;

}

-(void)adjustTextField:(UITextView *)object {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellAtIndexPath:(NSIndexPath *)indexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        [self createCell:cell row:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //UILabel* label1 = (UILabel*)[cell viewWithTag:2];
    
    NSUInteger row = [indexPath row];
    UIImageView* imgview = (UIImageView*)[cell viewWithTag:TAG_IMAGEVIEW]; 
    UITextField* textfield = (UITextField*)[cell viewWithTag:TAG_TEXTFIELD];
    UILabel    *numLab  = (UILabel*)[cell viewWithTag:TAG_NUMLABLE];
    UIButton   * btn_icon  = (UIButton*)[cell viewWithTag:TAG_DELETE_ICON];
    UIButton   * btn_delete = (UIButton*)[cell viewWithTag:TAG_DELETE_BTN];
    
    [btn_delete setHidden:NO];
    [btn_icon setHidden:NO];
    
    EditAlbumObject* object = (EditAlbumObject* )[self.dataArray objectAtIndex:row];
    //MyIssueGroup *issue = object.myissuegroup;
    
    
//    NSLog(@"row = %d name = %@ type = %d",row,object.myissuegroup.name,[object.myissuegroup.type intValue]);

    numLab.text=[NSString stringWithFormat:NSLocalizedString(@"%d files", @"%d files"),[object.myissuegroup.mediaCount intValue]];

    
   textfield.text = object.myissuegroup.name;
    textfield.textColor=[[FloggerUIFactory uiFactory] createTableViewFontColor];
    
    [[imgview viewWithTag:222] removeFromSuperview];
    
    if([object.myissuegroup url] == nil){
        imgview.image = [UIImage imageNamed: SNS_ALBUM];
    }else{
//        [imgview setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:[object.myissuegroup url]]] placeholderImage:[UIImage imageNamed: SNS_ALBUM]];

        
        imgview.image = [UIImage imageNamed:SNS_ALBUM];
        UIImageView *coverImage = [[[UIImageView alloc]initWithFrame:CGRectMake(3, 2, 51, 71)]autorelease];
        coverImage.tag = 222;
        coverImage.layer.masksToBounds = YES; 
        coverImage.contentMode = UIViewContentModeScaleAspectFill;
        [coverImage setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:[object.myissuegroup url]]] placeholderImage:nil];
        [imgview addSubview:coverImage];
        
        
//        UIImageView *imgview = (UIImageView *)[self.mainview viewWithTag:IMG_VIEW_COVER_MAIN+btnView.tag];
//        [imgview setImage:[UIImage imageNamed: SNS_ALBUM]];
//        UIImageView* coverimgview = (UIImageView *)[imgview viewWithTag:IMG_VIEW_COVER_SUB];
//        if(!coverimgview)
//        {
//            coverimgview = [[[UIImageView alloc]initWithFrame:CGRectMake(3, 2, 51, 71)]autorelease];
//            coverimgview.tag = IMG_VIEW_COVER_SUB;
//            coverimgview.layer.masksToBounds = YES;
//            coverimgview.contentMode = UIViewContentModeScaleAspectFill;
//            // coverimgview.contentMode = UIViewContentModeScaleAspectFit;
//            [imgview addSubview:coverimgview];
//        }
//        
//        [coverimgview setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:imgurl]] placeholderImage:nil];
        
    }
    if([object.myissuegroup.type intValue]){//
        if(object.deleteflag){
            [btn_delete setHidden:NO];
            [btn_icon setBackgroundImage:[UIImage imageNamed: SNS_MINUS_ROTATED] forState:UIControlStateNormal];
        }else{
            [btn_delete setHidden:YES];
            [btn_icon setBackgroundImage:[UIImage imageNamed:SNS_MINUS] forState:UIControlStateNormal];
        }
        textfield.enabled = YES;

    }else{//主相册
        btn_icon.hidden = YES;
        btn_delete.hidden = YES;
        textfield.enabled = YES;
    }
    
    if (object.isFocused) {
        [self performSelector:@selector(getFocused:) withObject:textfield afterDelay:0.5];
        object.isFocused = NO;
    }
    return cell;
}

-(void)getFocused:(UITextField *)tv
{
    [tv becomeFirstResponder];
}

/*-(UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView.tableView cellAtIndexPath:indexPath];
}*/

#pragma mark - Table view delegate


- (BOOL)findAndResignFirstResonder: (UIView*) stView
{
    if (stView.isFirstResponder) {
        [stView resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in stView.subviews) {
        if ([self findAndResignFirstResonder: subView])
            return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self findAndResignFirstResonder: self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"heightForRowAtIndexPath indexPath.row = %d",indexPath.row);
    return 100;
}




@end
