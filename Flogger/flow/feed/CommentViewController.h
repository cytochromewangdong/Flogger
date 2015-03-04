//
//  CommentViewController.h
//  Flogger
//
//  Created by wyf on 12-8-2.
//  Copyright (c) 2012年 atoato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "BaseNetworkViewController.h"
#import "ViewerFeedTableView.h"
#import "UploadServerProxy.h"

typedef enum 
{
    SHOWCOMMNENT,
    WRITEVIEWCOMMENT    
}COMMENTVIEWMODE;

@interface CommentViewController : BaseNetworkViewController <HPGrowingTextViewDelegate>{
	UIView *containerView;
    HPGrowingTextView *textView;
    BOOL _isFirst;
}
@property (nonatomic, retain) ViewerFeedTableView *feedView;
@property(nonatomic, retain) Issueinfo *issueInfo;
@property(nonatomic, assign) BOOL showHeader;
@property(nonatomic, retain) UploadServerProxy *preUploadProxy;
@property(nonatomic, retain) NSString* uploadFileID;
@property(nonatomic,assign) COMMENTVIEWMODE commentMode; 
//@property(nonatomic, retain) NSMutableArray *dataArray;
-(void)resignTextView;

@end
