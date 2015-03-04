//
//  TopicViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClPageViewController.h"

@protocol TopicSelectionDelegate <NSObject>

-(void)didSelectedTopic:(NSString *)topic;

@end

@interface TopicViewController : ClPageViewController <UITextFieldDelegate>
@property(nonatomic, assign) id /*<TopicSelectionDelegate>*/ delegate;
@property(nonatomic, retain) UITextField *searchField;
@end
