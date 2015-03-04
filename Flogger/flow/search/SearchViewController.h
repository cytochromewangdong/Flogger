//
//  SearchViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClPageViewController.h"
#import "TagInfoComServerProxy.h"
#import "FloatViewControllerProtocol.h"
#import "AccountCom.h"

typedef enum 
{
    SEARCH_USER,
    SEARCH_TOPIC
}SearchType;

typedef enum {
    FROM_POPULAR,
    FROM_FIND_FRIEND
}SearchMode;

@interface SearchViewController : ClPageViewController<UITextFieldDelegate, FloatViewControllerProtocol>

@property(nonatomic, retain) TagInfoComServerProxy *tagServerProxy;

@property(nonatomic, retain) UITextField *keywordField;
@property(nonatomic, retain) UIButton *userBtn, *topicBtn;
@property(nonatomic, assign) SearchType searchType;
@property(nonatomic, assign) SearchMode searchMode;
@property(nonatomic, retain) UIButton *cancelButton;
@property(nonatomic, retain) TagInfoCom *currentTagInfoCom;
@property(nonatomic, retain) AccountCom *currentAccountCom;

-(void)btnClicked:(id)sender;
@end
