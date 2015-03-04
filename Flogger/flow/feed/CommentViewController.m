//
//  CommentViewController.m
//  Flogger
//
//  Created by wyf on 12-8-2.
//  Copyright (c) 2012年 atoato. All rights reserved.
//

#import "CommentViewController.h"
#import "AsyncTaskManager.h"
#import "Guid.h"
#import "TopicViewController.h"
#import "TagViewController.h"

#define  TEXTMAXLENGTH 280
#define COMMENTSIZE 1000

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize feedView,issueInfo,showHeader;
@synthesize preUploadProxy;
@synthesize uploadFileID;
@synthesize commentMode;

- (void)decorateDesc:(ClPageTableView *)tableView
{
    for (int i=1; i < [tableView.dataArr count]; i++) {
        Issueinfo* currentRec  = [tableView.dataArr objectAtIndex:i];
        NSString * deco;
        if (currentRec.hypertext) {
            deco = [NSString stringWithFormat:@"<span class='userFormat'>%@:</span> %@",currentRec.username,currentRec.hypertext];
        } else {
            deco = [NSString stringWithFormat:@"<span class='userFormat'>%@:</span>",currentRec.username];
        }
        
        [currentRec.dataDict setObject:deco forKey:@"decoratedHypertext"];
        
    }
}

-(id)init
{
	self = [super init];
	if(self){
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillHide:) 
													 name:UIKeyboardWillHideNotification 
												   object:nil];	
        
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChangeAction:) name:kDataChangeIssueInfo object:nil];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeAction:) name:kNotificationAtSomebodyAction object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:kNotificationKeyboardHide object:nil];
        
//        self.uploadFileID = [[Guid randomGuid]stringValue];
	}
	
	return self;
}

-(void) keyboardHideAction : (NSNotification *) notification
{
    [textView resignFirstResponder];
}

-(BOOL) checkIsFullScreen
{
    return YES;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
//	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
//    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1];
    
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 460);
    self.view = view;
    
	
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 229, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.returnKeyType = UIReturnKeySend;
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 2;
    
	//textView.returnKeyType = UIReturnKeyRoute;//UIReturnKeyGo; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.internalTextView.placeholder = NSLocalizedString(@"Add Comment...", @"Add Comment...");
//    textView.internalTextView.keyboardType = UIKeyboardTypeTwitter;

    textView.maxLength = TEXTMAXLENGTH;
    
    textView.backgroundColor = [UIColor whiteColor];
    
//    textView. = self;
//    textView.
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    
	
    UIImage *rawEntryBackground = [[FloggerUIFactory uiFactory] createImage:SNS_COM_COMMENT_INPUT];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];//[rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
    entryImageView.frame = CGRectMake(5, 0, 230, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [[FloggerUIFactory uiFactory] createImage:SNS_COM_COMMENT_BACKGROUND];//[UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
//	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    UIImage *topicImage = [[FloggerUIFactory uiFactory] createImage:SNS_COM_INSERT_TAG];
    UIImage *atImage = [[FloggerUIFactory uiFactory] createImage:SNS_COM_INSERT_AT];
    
    UIButton *topicBtn = [[FloggerUIFactory uiFactory] createButton:topicImage];
    topicBtn.frame = CGRectMake(244, (40-topicImage.size.height)/2 +2, topicImage.size.width, topicImage.size.height);
    [topicBtn addTarget:self action:@selector(topicBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    topicBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    UIButton *atBtn = [[FloggerUIFactory uiFactory] createButton:atImage];
    atBtn.frame = CGRectMake(285, (40-atImage.size.height)/2 + 1, atImage.size.width, atImage.size.height);
    [atBtn addTarget:self action:@selector(atBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    atBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    [containerView addSubview:topicBtn];
    [containerView addSubview:atBtn];
    
    
    CGRect frame = CGRectMake(0, 0, 320, 416-containerView.frame.size.height);
    
    ViewerFeedTableView *feedTableView = [[[ViewerFeedTableView alloc] initWithFrame:frame]autorelease];
    feedTableView.showHeader = NO;
    feedTableView.feedTableDelegate = self;
    feedTableView.refreshableTableDelegate = self;
    feedTableView.pageSize = COMMENTSIZE;
//    feedTableView.refreshableTableDelegate = self;
    [self.view addSubview:feedTableView];

//    UITableView *feedTableV = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
//    feedTableV.delegate = self;
//    feedTableV.dataSource = self;
//    
//    [self.view addSubview:feedTableV];
    
    self.feedView = feedTableView;
//    self.feedView.tableView.frame = CGRectMake(0, 0, 320, 100);
//    self.feedView.frame = CGRectMake(0, 0, 320, 100);
    
//    NSLog(@"==== feedview is %@",[NSValue valueWithCGRect:self.feedView.frame]);
    
    [self doRequest:NO];
    [self.view addSubview:containerView];
}


-(void)atBtnTapped:(id)sender
{
    TagViewController *tagvc = [[TagViewController alloc] initWithNibName:nil bundle:nil];
    tagvc.delegate = self;
    [self.navigationController pushViewController:tagvc animated:YES];
    [tagvc release];
}

-(void)topicBtnTapped:(id)sender
{
    TopicViewController *tvc = [[TopicViewController alloc] initWithNibName:nil bundle:nil];
    tvc.delegate = self;
    [self.navigationController pushViewController:tvc animated:YES];
    [tvc release];
}

-(void)didSelectedTopic:(NSString *)topic
{
    if (topic && topic.length > 0) {
        NSString *preStr = textView.text;
        textView.text = [NSString stringWithFormat:@"%@#%@#", preStr, topic];
//        [self textViewDidChange:textView];
    }
}


-(void)didAtSelection:(NSString *)username
{
    if (username && username.length > 0) {
        NSString *preStr = textView.text;
        textView.text = [NSString stringWithFormat:@"%@%@ ", preStr, username];
//        [self textViewDidChange:textView];
    }
}

-(void)doRequest:(BOOL)isMore
{
    if (self.loading) {
        return;
    }
    self.loading = YES;
    
    if (!self.serverProxy) {
        self.serverProxy = [[[IssueInfoComServerProxy alloc] init] autorelease];
        self.serverProxy.delegate = self;
    }
    
    
    IssueInfoCom *issueInfoCom = [[[IssueInfoCom alloc] init] autorelease];
    
    if (isMore)
    {
        issueInfoCom.searchEndID = self.feedView.endId;
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
    }
    else
    {
        issueInfoCom.searchEndID = [NSNumber numberWithInt:-1];        
        issueInfoCom.searchStartID = [NSNumber numberWithInt:-1];
    }
    
    issueInfoCom.issueId = self.issueInfo.id;
    [(IssueInfoComServerProxy *)self.serverProxy getThread:issueInfoCom];
    
}
-(NSMutableDictionary *) getIssueParaDic
{
    NSMutableDictionary *paraDic = [[[NSMutableDictionary alloc] init] autorelease];
    
    IssueInfoCom *com = [[[IssueInfoCom alloc] init] autorelease];
    IssueinfoBean *tmpIssueinfo = [[[IssueinfoBean alloc] init] autorelease];
    com.issueinfo = tmpIssueinfo;
    
    if (self.issueInfo) 
    {
        com.issueinfo.parentid = self.issueInfo.id;
    }
//    NSLog(@"==== textview is %@=====",textView.text);
    com.issueinfo.text = textView.text;//[messageTV text]; 
    com.uploadFileID = [[Guid randomGuid]stringValue];//self.uploadFileID;
    NSInteger category = ISSUE_CATEGORY_TWEET;
    com.issueinfo.issuecategory = [NSNumber numberWithInt:category];
    [paraDic setObject:com forKey:kPostIssueInfoCom];
    return paraDic;
}



-(void) doUploadRequest
{
    
    UploadServerProxy* currentPreUploadProxy = [[[UploadServerProxy alloc] init] autorelease];
    NSMutableDictionary *paraDic = [self getIssueParaDic];
    IssueInfoCom *com = [paraDic valueForKey:kPostIssueInfoCom];
//    self.paraDictonary = paraDic;
//    NSString* newPath  = [paraDic valueForKey:kUploadFilePATHKey];
    [[AsyncTaskManager sharedInstance] addTask:currentPreUploadProxy];
    [currentPreUploadProxy preUploadIssue:com withData:nil];

    
}

-(BOOL) isEmpty:(NSString*) text
{
    return ![text length];
}

-(BOOL) checkInputValid
{
    NSString *string = textView.text;
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
//    if (self.cameraInfo) {
//        return YES;
//    }
    
    if([self isEmpty:string])
    {        
        [GlobalUtils showAlert:NSLocalizedString(@"", @"") message:NSLocalizedString(@"Please write a message",@"Please write a message")];
        return NO;
    }
    return YES;
    
}

//-(BOOL) textFieldShouldReturn:(UITextField *)textField
//{
////    [textField resignFirstResponder];
//    [self resignTextView];
//    return YES;
//}
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView;
{
    [self resignTextView];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self resignTextView];
//    });
    return YES;
}

-(void)resignTextView
{
    if (![self checkInputValid]) {
        return;
    }
//	[textView resignFirstResponder];
//    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
//    NSLog(@"==== start time is %f",CFAbsoluteTimeGetCurrent() - startTime);
//    startTime = CFAbsoluteTimeGetCurrent();
    [self doUploadRequest];
    textView.text = @"";
//    [textView becomeFirstResponder];s
//    NSLog(@"==== end time is %f",CFAbsoluteTimeGetCurrent() - startTime);
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
	
//    NSLog(@"======= containerframe is %@ ======",[NSValue valueWithCGRect:containerFrame]);
    self.feedView.tableView.frame= CGRectMake(0, 0, 320, containerFrame.origin.y);
    self.feedView.frame = CGRectMake(0, 0, 320, containerFrame.origin.y);
    //416 - containerFrame.size.height; 
//    self.feedView.frame = CGRectMake(0, 0, 320, 200);
	// commit animations
	[UIView commitAnimations];
    
    //test
    [self commentScrollToEnd];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
//    NSLog(@"======= containerframe is %@ ======",[NSValue valueWithCGRect:containerFrame]);
    
    self.feedView.tableView.frame= CGRectMake(0, 0, 320, containerFrame.origin.y);
    self.feedView.frame = CGRectMake(0, 0, 320, containerFrame.origin.y);
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}

//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return YES;
//}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

-(void) viewDidLoad
{
//    if (self.commentMode == WRITECOMMENT) {
//        [textView becomeFirstResponder];
//    }
    [super viewDidLoad];
    _isFirst = YES;
}

//-(void) commentScrollToEnd
//{
//    NSLog(@"==== comment view feedview count is %d",feedView.dataArr.count);
//    if (!self.showHeader && feedView.dataArr.count > 1) {
//        [feedView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:feedView.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.commentMode == WRITEVIEWCOMMENT) {
        [textView becomeFirstResponder];
    }
    [self setNavigationTitleView: NSLocalizedString(@"Comment",@"Comment")];
    [self commentScrollToEnd];
    
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

//-(void) transactionFailed:(BaseServerProxy *)serverproxy
//{
//    [super transactionFailed:serverproxy];
//}

-(void)updateView:(ClPageTableView *)tableView withResponse:(IssueInfoCom *)response
{
    if (response.myIssueInfoList && response.myIssueInfoList.count > 0)
    {
        NSMutableArray *tmpArr = nil;
        if ([response.searchStartID longLongValue] != -1) {                      
            tmpArr = [NSArray arrayWithArray:tableView.dataArr];
        }
        [tableView.dataArr removeAllObjects];
        [tableView.dataArr addObject:self.issueInfo];
        // show the desciption of the header as comment
        if(self.issueInfo.hypertext && self.issueInfo.hypertext.length > 0)
        {
            MyIssueInfo *newIssue = [[[MyIssueInfo alloc] init] autorelease];
            newIssue.dataDict = [NSMutableDictionary dictionaryWithDictionary:self.issueInfo.dataDict];
            newIssue.issuecategory = [NSNumber numberWithInt:3];
            newIssue.bmiddleurl = nil;
            [tableView.dataArr addObject:newIssue]; 
        }
        [tableView.dataArr addObjectsFromArray:response.myIssueInfoList];
        if (tmpArr && response.myIssueInfoList.count < tableView.pageSize) {
            [tableView.dataArr addObjectsFromArray:tmpArr];
        }
    } else {
        //refresh
        if ([response.searchEndID longLongValue] == -1) {                      
            //            tmpArr = [NSArray arrayWithArray:tableView.dataArr];
            [tableView.dataArr removeAllObjects];
            [tableView.dataArr addObject:self.issueInfo];
            // show the desciption of the header as comment
            if(self.issueInfo.hypertext && self.issueInfo.hypertext.length > 0)
            {
                MyIssueInfo *newIssue = [[[MyIssueInfo alloc] init] autorelease];
                newIssue.dataDict = [NSMutableDictionary dictionaryWithDictionary:self.issueInfo.dataDict];
                newIssue.issuecategory = [NSNumber numberWithInt:3];
                newIssue.bmiddleurl = nil;
                [tableView.dataArr addObject:newIssue]; 
            }
            
        }
    }
    [self decorateDesc:tableView];
    
    if ([response.searchStartID longLongValue] == -1) 
    {
        [tableView checkMore:response.myIssueInfoList];
    }
    
    //    [self saveDataToFile];
    [tableView.tableView reloadData];
}

-(void) textChangeAction : (NSNotification *) notification
{
    Issueinfo *issueIn = (Issueinfo *) notification.object;
    NSString *username = issueIn.username;
    if (username && username.length > 0) {
        NSString *preStr = textView.text;
        textView.text = [NSString stringWithFormat:@"%@%@%@ ", preStr,@"@",username];
        [textView becomeFirstResponder];
              // [self textViewDidChange:textView];
    }
}

-(void) dataChangeAction : (NSNotification *) notification
{
     NSMutableDictionary *data = (NSMutableDictionary *) notification.object;
    if ([kNotificationCommentAction isEqualToString:[data objectForKey:kNotificationAction]]) 
    {
        Issueinfo *notificationIssueInfo = [data objectForKey:kNotificationInfoIssueThread];
        Issueinfo *tranIssueInfo = [[[MyIssueInfo alloc] init] autorelease];
        tranIssueInfo.dataDict = [NSMutableDictionary dictionaryWithDictionary:notificationIssueInfo.dataDict];
        {
            if (self.feedView.dataArr.count == 0) {
                Issueinfo *tempIssue = [[[Issueinfo alloc] init] autorelease];
                [self.feedView.dataArr addObject:tempIssue];
            }
            if (!tranIssueInfo.id) {
                [self.feedView.dataArr addObject:tranIssueInfo];
            } else
            {
                BOOL isExist = NO;
                NSString *transLocalID =  [tranIssueInfo.dataDict objectForKey:kLocalIssueID];
                for (int i = 1; i < [self.feedView.dataArr count]; i++) {
                    Issueinfo *currentIssueInfo = [self.feedView.dataArr objectAtIndex:i];
                    NSString * currentLocalID = [currentIssueInfo objectForKey:kLocalIssueID];
                    if ([transLocalID isEqualToString:currentLocalID]) {
                        currentIssueInfo.dataDict = tranIssueInfo.dataDict;
                        isExist = YES;
                        break;
                    }
                } 
                if (!isExist) {
                    [self.feedView.dataArr addObject:tranIssueInfo];
                }
            }
            
            
        }
        //comment list replace end
        
        if (self.isViewLoaded && self.view.window) {
            [self.feedView.tableView reloadData];
            [self commentScrollToEnd];
        } else {
//            _isDataChange = TRUE;
        }
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self saveDataToFile];
        //        });  
        return;
    }
}
-(void) commentScrollToEnd
{
//    NSLog(@"==== test 2 feedview count is %d",feedView.dataArr.count);
    if (!self.showHeader && feedView.dataArr.count > 1) {
        [feedView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:feedView.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //        [self setNavigationTitleView:NSLocalizedString(@"Comments", @"Comments")];
    }
}

-(void)refreshDataSource:(ClRefreshableTableView *)refreshTableView
{
//    [self doRequest:NO];
    [self doRequest:NO];
}

-(void)networkFinished:(BaseServerProxy *)serverproxy
{
    self.feedView.isLoading = NO;
    self.feedView.isLoadingMore = NO;
    self.feedView.lastUpdateDate = [NSDate date];
    [super networkFinished:serverproxy];
}

-(void) transactionFinished:(BaseServerProxy *)serverproxy
{
    [super transactionFinished:serverproxy];

    
    if (serverproxy == self.preUploadProxy) {
        IssueInfoCom *com = (IssueInfoCom *)serverproxy.response;
        NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] init] autorelease];
        NSString * deco;
        if (com.threadHead.hypertext) {
            deco = [NSString stringWithFormat:@"<span class='userFormat'>%@:</span> %@",com.threadHead.username,com.threadHead.hypertext];
        } else {
            deco = [NSString stringWithFormat:@"<span class='userFormat'>%@</span>",com.threadHead.username];
        }            
        [com.threadHead.dataDict setObject:deco forKey:@"decoratedHypertext"];        
        [dataDic setObject:kNotificationCommentAction forKey:kNotificationAction];
        [dataDic setObject:com.threadHead forKey:kNotificationInfoIssueThread];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDataChangeIssueInfo object:dataDic];
        
        
    } else {
        self.issueInfo = [(IssueInfoCom *)serverproxy.response threadHead];
        
        
        if (self.feedView.dataArr.count > 0) {
            [self.feedView.dataArr removeObjectAtIndex:0];
        }
        [self.feedView.dataArr insertObject:self.issueInfo atIndex:0];
        
        [self updateView:self.feedView withResponse:(IssueInfoCom *)serverproxy.response];
        [self.feedView.tableView reloadData];
        
        if (_isFirst) {
            [self commentScrollToEnd];
            _isFirst = NO;
        }
    }
}

- (void)dealloc {
    textView.delegate = nil;
    [textView release];
	[containerView release];
    
    self.feedView.refreshableTableDelegate = nil;
    self.feedView = nil;
    self.issueInfo = nil;
    
    self.preUploadProxy.delegate = nil;
    self.preUploadProxy = nil;
    self.uploadFileID = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataChangeIssueInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationAtSomebodyAction object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationKeyboardHide object:nil];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
