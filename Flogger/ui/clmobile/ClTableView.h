//
//  ClTableView.h
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClTableView;
@protocol ClTableViewDataSource <NSObject>
- (UITableViewCell *)tableView:(ClTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol ClTableViewDelegate <NSObject>

- (void)tableView:(ClTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(ClTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ClTableView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isLoading;
}

@property(nonatomic, assign) id <ClTableViewDataSource> dataSource;
@property(nonatomic, assign) id <ClTableViewDelegate> delegate;
@property(nonatomic, retain) NSMutableArray *dataArr;
@property(nonatomic, retain) NSMutableDictionary *dataDictionary;

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, assign) BOOL isLoading, hideSectionHeader;
@property(nonatomic, assign) GLfloat custHeight;
@property(nonatomic, retain) UIActivityIndicatorView *indicatorView;

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
            
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
            
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (id)initWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style;
@end
