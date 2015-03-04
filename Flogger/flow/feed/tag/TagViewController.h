//
//  TagViewController.h
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClPageViewController.h"


typedef enum 
{
    TAG_RECENT = 1,
    TAG_FOLLOWING,
    TAG_FEATURED
}TagType;

@protocol AtSelectionDelegate <NSObject>

-(void)didAtSelection:(NSString *)username;

@end

@interface TagViewController : ClPageViewController <UITextFieldDelegate>
{
    TagType _tagType;
}

@property(nonatomic, assign) id /*<AtSelectionDelegate>*/ delegate;
@property(nonatomic, assign) TagType tagType;
@property(nonatomic, retain) UITextField *searchField;
-(void)btnTapped:(id)sender;
@end
