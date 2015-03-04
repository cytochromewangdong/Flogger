//
//  FeedGridPageTableView.m
//  Flogger
//
//  Created by jwchen on 12-2-21.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FeedGridPageTableView.h"
#import "FeedGridTableViewCell.h"
#import "MyIssueInfo.h"
#import "EntityEnumHeader.h"
#define NATRUAL_THUMBNAIL_PADDING 6
#define NATRUAL_VERTICAL_THUMBNAIL_PADDING 6
#define NATRUAL_THUMBNAIL_HEIGHT 90
#define MAX_WIDTH 315
#define THRESH_HOLD_WIDTH 5

//#define kTagMediaBtn 10006
@implementation FeedRange
@synthesize startIndex,endIndex,scale;
@end
@interface FeedGridPageTableView()
@property(nonatomic, retain) NSMutableArray *rowCellArray;
@end
@implementation FeedGridPageTableView
@synthesize feedGridTableViewDelegate,rowCellArray;
+(float) getNormalizeWidth:(MyIssueInfo*) info
{
    static float CONST_DIMENTION = 100;
    float th = info.thumbnailHeight?[info.thumbnailHeight floatValue]:CONST_DIMENTION;
    float tw = info.thumbnailWidth?[info.thumbnailWidth floatValue]:CONST_DIMENTION;
    if(th <= 0.0001)
    {
        th = CONST_DIMENTION;
    }
    if(tw <= 0.0001)
    {
        tw = CONST_DIMENTION;
    }
    
    if(th<=NATRUAL_THUMBNAIL_HEIGHT)
    {
        return tw;//[info.thumbnailWidth floatValue];
    }
    
    tw = tw * NATRUAL_THUMBNAIL_HEIGHT / th; 
    return tw;
}
+(void) reorderForFreeLayout:(NSMutableArray*)data
{
    float width = 0;
    for(int i=0;i<[data count];i++)
    {
        MyIssueInfo* info = [data objectAtIndex:i];
        width += NATRUAL_THUMBNAIL_PADDING;
        float currentWidth = [FeedGridPageTableView getNormalizeWidth:info];
        width += currentWidth;
        if(width>MAX_WIDTH)
        {
            float difference =  MAX_WIDTH - (width - currentWidth);
            BOOL isFound = NO;
            float maxiumMatchWidth = 0;
            int maxiumCoressIndex = -1;
            if(difference>THRESH_HOLD_WIDTH)
            {
                for(int j=i+1;j<[data count];j++)
                {
                    MyIssueInfo* nextInfo = [data objectAtIndex:j];
                    float nextCurrentWidth = [FeedGridPageTableView getNormalizeWidth:nextInfo];
                    if(nextCurrentWidth<=difference)
                    {
                        //[newLayout addObject:info];
                        isFound = YES;
                        if(maxiumMatchWidth<nextCurrentWidth)
                        {
                            maxiumMatchWidth = nextCurrentWidth;
                            maxiumCoressIndex = j;
                            
                        }
                        //width = MAX_WIDTH - difference + nextCurrentWidth;
                        //[data exchangeObjectAtIndex:j withObjectAtIndex:i];
                        //break;
                    }
                }
                if(isFound)
                {
                    width = MAX_WIDTH - difference + maxiumMatchWidth;
                    [data exchangeObjectAtIndex:maxiumCoressIndex withObjectAtIndex:i];  
                }
                /*if(!isFound)
                {
                    for(int j=i+1;j<[data count];j++)
                    {
                        MyIssueInfo* nextInfo = [data objectAtIndex:j];
                        float nextCurrentWidth = [FeedGridPageTableView getNormalizeWidth:nextInfo];
                        if(nextCurrentWidth/1.2<=difference)
                        {
                            //[newLayout addObject:info];
                            isFound = YES;
                            if(maxiumMatchWidth<nextCurrentWidth/1.3)
                            {
                                maxiumMatchWidth = nextCurrentWidth/1.3;
                                maxiumCoressIndex = j;
                            }
                            //width = MAX_WIDTH - difference + nextCurrentWidth;
                            //[data exchangeObjectAtIndex:j withObjectAtIndex:i];
                            //break;
                        }
                    }
                    if(isFound)
                    {
                        width = MAX_WIDTH - difference + maxiumMatchWidth;
                        MyIssueInfo* nextInfo = [data objectAtIndex:maxiumCoressIndex];
                        nextInfo.thumbnailWidth = [NSNumber numberWithFloat:maxiumMatchWidth];
                        nextInfo.thumbnailHeight = [NSNumber numberWithFloat:NATRUAL_THUMBNAIL_HEIGHT];
                        [data exchangeObjectAtIndex:maxiumCoressIndex withObjectAtIndex:i];
                        
                    }
                }*/
                /*if(!isFound)
                {
                    for(int j=i+1;j<[data count];j++)
                    {
                        MyIssueInfo* nextInfo = [data objectAtIndex:j];
                        float nextCurrentWidth = [FeedGridPageTableView getNormalizeWidth:nextInfo];
                        if(nextCurrentWidth/1.2<=difference)
                        {
                            //[newLayout addObject:info];
                            isFound = YES;
                            width = MAX_WIDTH - difference + nextCurrentWidth;
                            [data exchangeObjectAtIndex:j withObjectAtIndex:i];
                            break;
                        }
                    }
                }*/
                
            } 
            
            // gather the information
            if(!isFound)
            {
                width =NATRUAL_THUMBNAIL_PADDING + currentWidth;
            }
        } 
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if ([self isCellForMore:[indexPath row]]) {
        return [self heightForMore];
    }
    return NATRUAL_THUMBNAIL_HEIGHT + NATRUAL_THUMBNAIL_PADDING;//kCellHeight;
}

-(BOOL)isVideo:(Issueinfo *)info
{
    return ISSUE_CATEGORY_VIDEO == [info.issuecategory intValue];
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isCellForMore:[indexPath row]]) {
        return [self cellForMore:tableView];
    }
    
    static NSString *CellIdentifier = @"CellIdentifier";
    FeedGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GridTableViewCell" owner:nil options:nil];
//        cell = [array objectAtIndex:0];
        cell = [[[FeedGridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.delegate = self;
    }
    
    [cell clear];
    cell.tag = [indexPath row];
    /*int loopRow = 0;
    float width = 0;
    int subIndex = -1;
    //NSLog(@"=========:%d   ||| %d ||| %d ",[indexPath row] ,self.dataArr.count, subIndex);
    while (loopRow<[indexPath row] && subIndex < (int)self.dataArr.count) 
    {
        width += NATRUAL_THUMBNAIL_PADDING;
        MyIssueInfo* info = [self.dataArr objectAtIndex:++subIndex];
        float currentWidth = [self getNormalizeWidth:info];
        width += currentWidth;
        if(width > MAX_WIDTH)
        {
            loopRow++;
            width =NATRUAL_THUMBNAIL_PADDING + currentWidth;
        }
    }
    if(subIndex<0) subIndex=0;
    MyIssueInfo* info = [self.dataArr objectAtIndex:subIndex++];
    float currentWidth = [self getNormalizeWidth:info];
    float x = NATRUAL_THUMBNAIL_PADDING;
    width = NATRUAL_THUMBNAIL_PADDING + currentWidth;
    do {
//        NSLog(@"=========:%d | %f | %f",[indexPath row], currentWidth,width);
        [cell addImageToView:[self isVideo:info] subIndex:subIndex - 1 X:x Y:NATRUAL_VERTICAL_THUMBNAIL_PADDING W:currentWidth H:NATRUAL_THUMBNAIL_HEIGHT TheIssue:info];
        x += NATRUAL_THUMBNAIL_PADDING;
        x += currentWidth;
        if(subIndex >= self.dataArr.count)
        {
            break;
        }
        info = [self.dataArr objectAtIndex:subIndex++];
        currentWidth = [self getNormalizeWidth:info];
        width += currentWidth;
        width += NATRUAL_THUMBNAIL_PADDING;
    } while (width <= MAX_WIDTH);*/
    FeedRange *theRange = [rowCellArray objectAtIndex:[indexPath row]];
    float x = NATRUAL_THUMBNAIL_PADDING;
    for (int i=theRange.startIndex; i<theRange.endIndex; i++) {
        MyIssueInfo* info = [self.dataArr objectAtIndex:i];
        float currentWidth = [FeedGridPageTableView getNormalizeWidth:info];//*(theRange.scale>1.5?1.0:theRange.scale)
        [cell addImageToView:[self isVideo:info] subIndex:i X:x Y:NATRUAL_VERTICAL_THUMBNAIL_PADDING W:currentWidth H:NATRUAL_THUMBNAIL_HEIGHT TheIssue:info];
        x += NATRUAL_THUMBNAIL_PADDING;
        x += currentWidth; 
    }
    
//    NSLog(@"table view tag======%d",tableView.tag);
//    
//    if (tableView.tag==kTagMediaBtn) {
//        UILabel *lineLab = [[FloggerUIFactory uiFactory] createLable];
//        lineLab.frame = CGRectMake(0, 98, 320, 1);
//        lineLab.backgroundColor =  [UIColor colorWithRed:181/255.0  green:180/255.0 blue:174/255.0 alpha:1.0];
//        
//        UILabel *lineLab2 = [[FloggerUIFactory uiFactory] createLable];
//        lineLab2.frame = CGRectMake(0, 99, 320, 1);
//        lineLab2.backgroundColor =  [UIColor whiteColor];
//        [cell addSubview:lineLab];
//        [cell addSubview:lineLab2];
//    }
    
//    UILabel *lineLab = [[FloggerUIFactory uiFactory] createLable];
//    lineLab.frame = CGRectMake(0, 90, 320, 1);
//    lineLab.backgroundColor =  [UIColor colorWithRed:181/255.0  green:180/255.0 blue:174/255.0 alpha:1.0];
//    
//    UILabel *lineLab2 = [[FloggerUIFactory uiFactory] createLable];
//    lineLab2.frame = CGRectMake(0, 91, 320, 1);
//    lineLab2.backgroundColor =  [UIColor whiteColor];
//    [cell addSubview:lineLab];
//    [cell addSubview:lineLab2];
    
    
    
    return cell;
}

-(void)selectGridTableViewCell:(FeedGridTableViewCell *)gridTableViewCell atIndex:(NSInteger)index;
{
    if (feedGridTableViewDelegate && [feedGridTableViewDelegate respondsToSelector:@selector(feedGridPageTableView:atRow:withIndex:)]) {
        [feedGridTableViewDelegate feedGridPageTableView:self atRow:gridTableViewCell.tag withIndex:index];
    }
}


-(NSInteger) analyseData
{
    NSInteger number = 0;
    float width = 0;
    float pureWidth = 0;
    self.rowCellArray = [[[NSMutableArray alloc] init] autorelease];
    FeedRange *currentRange = [[[FeedRange alloc] init] autorelease];
    currentRange.startIndex = 0;
    //for (MyIssueInfo* info in self.dataArr)
    for(int i=0;i<[self.dataArr count];i++)
    {
        MyIssueInfo* info = [self.dataArr objectAtIndex:i];
        width += NATRUAL_THUMBNAIL_PADDING;
        float currentWidth = [FeedGridPageTableView getNormalizeWidth:info];
        width += currentWidth;
        pureWidth +=currentWidth;
        if(width>MAX_WIDTH)
        {
            // gather the information
            currentRange.endIndex = i;
            [rowCellArray addObject:currentRange];
            
            currentRange = [[[FeedRange alloc] init] autorelease]; 
            currentRange.startIndex = i;
            currentRange.scale = MAX_WIDTH/(pureWidth - currentWidth);
            number++;
            width =NATRUAL_THUMBNAIL_PADDING + currentWidth;
            pureWidth =currentWidth;
        } 
    }
    if(width>0)
    {
        currentRange.endIndex = [self.dataArr count];
        [rowCellArray addObject:currentRange];
        currentRange.scale = MAX_WIDTH/pureWidth;
        number ++;
    }
    
    if (self.hasMore) {
        number ++;
    }
    
    _my_rowCount = number;
    return number;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self analyseData];
}

-(BOOL) isCellForMore:(NSUInteger)index
{
    return _hasMore && index ==_my_rowCount-1;//_hasMore && index == (self.dataArr.count/4 + ((self.dataArr.count % 4)? 1 : 0));
}
-(void)dealloc
{
    self.rowCellArray = nil;
    [super dealloc];
}
@end
