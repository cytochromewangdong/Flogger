//
//  BaseTableViewController.h
//  Flogger
//
//  Created by jwchen on 12-3-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseServerProxy.h"

@interface BaseTableViewController : UITableViewController
@property(nonatomic, retain) NSMutableArray *dataArray;
@property(nonatomic, retain) NSMutableDictionary *dataDictionary;
@property(nonatomic, assign) UITableViewCellStyle tableStyle;
@property(nonatomic, assign) BOOL hideSectionHeader;

-(void)setRightNavigationBarWithTitleAndImage:(NSString *)text image:(NSString *)imageName pressimage:(NSString*)pressimgname;
-(void)setRightNavigationBarWithTitle:(NSString *)text image:(NSString *)imageName;
-(void)setLeftNavigationBarWithTitle:(NSString *)text image:(NSString *)imageName;
-(void)setBackNavigation;


-(void)leftAction:(id)sender;
-(void)rightAction:(id)sender;
-(void)backAction:(id)sender;


@property(nonatomic, assign) BOOL loading;
@property(nonatomic, retain) BaseServerProxy *serverProxy;

- (void)networkFinished:(BaseServerProxy *)serverproxy;
-(void)transactionFinished:(BaseServerProxy *)serverproxy;
-(void)transactionFailed:(BaseServerProxy *)serverproxy;
-(void)networkError:(BaseServerProxy *)serverproxy;

-(void)reloading;

@end
