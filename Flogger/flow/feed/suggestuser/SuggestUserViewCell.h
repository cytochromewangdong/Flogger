//
//  SuggestUserViewCell.h
//  Flogger
//
//  Created by jwchen on 12-3-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccount.h"

@class SuggestUserViewCell;

@protocol SuggestUserViewCellDelegate <NSObject>

-(void)suggestUserViewCell:(SuggestUserViewCell *)cell didActionOnAccount:(MyAccount *)account;

-(void)suggestUserViewCell:(SuggestUserViewCell *)cell didSelectedAtIssueInfo:(Issueinfo *)info;

@end

//typedef enum{
//    ComeFromNewFriendListView = 1,
//   
//}FromMode;

@interface SuggestUserViewCell : UITableViewCell
{
    MyAccount *_account;
}

@property(nonatomic, retain) MyAccount *account;
@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) UIImageView *iconView;
@property(nonatomic, retain) UIImageView *imageView1, *imageView1P, *imageView2, *imageView2P, *imageView3, *imageView3P, *imageView4, *imageView4P;
@property(nonatomic, retain) UIButton *btn1, *btn2, *btn3, *btn4;
@property(nonatomic, retain) UILabel *userLabel, *followerLabel;
@property(nonatomic, retain) TTStyledTextLabel *descriptionLabel;
@property(nonatomic, retain) UIButton *followBtn;

@property(nonatomic, retain) UIScrollView *imageContainerView;
//@property(nonatomic, assign) FromMode mode;

+(CGFloat) tableView:(UITableView *)tableView heightForAccount:(MyAccount *)account;

-(void)followBtnClicked:(id)sender;

-(void)issueBtnClicked:(id)sender;

@end
