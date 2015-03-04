//
//  ClGridPageTableView.m
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClGridPageTableView.h"
#import "GridTableViewCell.h"

@implementation ClGridPageTableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = self.dataArr.count/4;
    if (self.dataArr.count % 4 > 0) {
        number ++;
    }
    
    if (self.hasMore) {
        number ++;
    }
    return number;
}

-(BOOL) isCellForMore:(NSUInteger)index
{
    return _hasMore && index == (self.dataArr.count/4 + ((self.dataArr.count % 4)? 1 : 0));
}

@end
