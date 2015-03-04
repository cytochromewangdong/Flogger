//
//  ClCheckGridView.m
//  Flogger
//
//  Created by steveli on 09/03/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "ClCheckGridView.h"
#import "CheckGridCellButton.h"
#import "GridTableViewCell.h"
#import "CheckGridViewCell.h"
#import "ClCheckGridView.h"
#define TagOfBackGroundForAnimation 300
@implementation ClCheckGridView
@synthesize dataarrys, selectcells, checkGridDelegate,type, bottomOffset;

-(void)dealloc
{
    self.dataarrys = nil;
    self.selectcells = nil;
    self.delegate = nil;
    [super dealloc];
}

-(void)setupvalue
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    self.dataarrys = array;
    [array release];
    
    NSMutableArray* array1 = [[NSMutableArray alloc]init];
    self.selectcells = array1;
    [array1 release];
    
    _selectnum = 0;
    _videoselectnum = 0;
    _photoselectnum = 0;
    
    type = kCheckGrid_IssueInfo_Type;
    
    self.tableView.separatorColor = [UIColor clearColor];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupvalue];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupvalue];
    }
    return self;
}


-(void)clearSelect
{
   
    [self.selectcells removeAllObjects];
    _selectnum = 0;
    _photoselectnum = 0;
    _videoselectnum = 0;
    [self.checkGridDelegate checkgridSelectNull];
}

-(void)removeSelect
{
    for(int i = selectcells.count -1;i>=0;i--){
        [self.dataArr removeObject:[self.selectcells objectAtIndex:i]];    
    }
    
    [self.selectcells removeAllObjects];
    _selectnum = 0;
    _photoselectnum = 0;
    _videoselectnum = 0;
    [self.checkGridDelegate checkgridSelectNull];
}
-(void)setSelectEnable:(BOOL)flag
{
    if(_selectflag && !flag ){
        if(self.selectcells.count>0){
           [self.selectcells removeAllObjects];
            [self.tableView reloadData];
        }
        _selectnum = 0;
        _photoselectnum = 0;
        _videoselectnum = 0;
    }
    _selectflag = flag;
}
-(NSInteger)getselectnum
{
    return _photoselectnum + _videoselectnum;;
}
-(NSInteger)getVideoSelectNum
{
    return _videoselectnum;
}
-(NSInteger)getPhotoSelectNum
{
    return _photoselectnum;
}

-(Albuminfo*)getSelectAlbumInfo:(NSInteger)index
{
//    id btn = [self.selectcells objectAtIndex:index];
    Albuminfo *info = [self.selectcells objectAtIndex:index];
    return info;
}
-(Issueinfo*)getSelectIssueInfo:(NSInteger)index
{
    Issueinfo *info = [self.selectcells objectAtIndex:index];
    return info;
}



#pragma add data


/**** add issueinfo for the favorite *****/
-(void)addIssueInfo:(NSMutableArray*)info
{
    self.dataArr = info;
}


//for album

-(void)addAlbumInfo:(NSMutableArray*)info
{
    self.dataArr = info;
//    NSLog(@"self.dataarr count = %d",self.dataArr.count);
}

-(void)clear
{
    
}


-(BOOL)isIssueinfoVideo:(Issueinfo *)info
{
    return ISSUE_CATEGORY_VIDEO == [info.issuecategory intValue];
}


-(BOOL)isAlbuminfoVideo:(Albuminfo *)info
{
    return ISSUE_CATEGORY_VIDEO == [info.type intValue];
}


-(void)setIssueinfoCell:(CheckGridViewCell*)cell indexPath:(NSIndexPath *)indexPath
{
    cell.tag = [indexPath row];
    NSInteger index = [indexPath row] * cell.count;
    for(int i = 0 ; i < cell.count ; i++)
    {
        if(index < self.dataArr.count){
            Issueinfo *issueinfo = [self.dataArr objectAtIndex:index];
            CheckGridCellButton *btn = [cell.controlArray objectAtIndex:i];
            btn.backgroundColor=RGBCOLOR(61, 67, 75);
            [btn setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:issueinfo.thumbnailurl]] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PHOTO]];
            btn.issueinfo = issueinfo;
            btn.videoTimeLable.text=[GlobalUtils displayableStrFromVideoduration:[issueinfo.videoduration intValue]];

        
             [btn isVideo:[self isIssueinfoVideo:issueinfo]];  
            if ([self isIssueinfoVideo:issueinfo]==YES) {
                 [btn setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:issueinfo.thumbnailurl]] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_VIDEO]];
            }
        
            if([self.selectcells containsObject:issueinfo]){
                [btn setChecked:YES];
            }else{
                [btn setChecked:NO];
            }
            index++;
            [btn setHidden:NO];
            if([btn superview].tag ==TagOfBackGroundForAnimation){ [[btn superview] setHidden:NO];}
        }else{
            CheckGridCellButton *btn = [cell.controlArray objectAtIndex:i];
            if([btn superview].tag ==TagOfBackGroundForAnimation){[[btn superview] setHidden:YES];}
            [btn setHidden:YES];
            [btn setChecked:NO];
        }
    }
}

-(void)setAlbuminfoCell:(CheckGridViewCell*)cell indexPath:(NSIndexPath *)indexPath
{
    cell.tag = [indexPath row];
    NSInteger index = [indexPath row] * cell.count;
//    NSLog(@"index = %d , cell.count = %d cell.tag = %d",index,cell.count,cell.tag);
    for(int i = 0 ; i < cell.count ; i++)
    { 
        CheckGridCellButton *btn = [cell.controlArray objectAtIndex:i];
        [btn setImageWithURL:nil placeholderImage:nil];
        //[btn setBackgroundColor:[UIColor blueColor]];
        [btn setHidden:NO];
        [btn setEnabled:YES];
        
        if(index < self.dataArr.count){
            MyAlbumInfo *albuminfo = [self.dataArr objectAtIndex:index];
            CheckGridCellButton *btn = [cell.controlArray objectAtIndex:i];
            btn.backgroundColor=RGBCOLOR(61, 67, 75);
            if ([self isAlbuminfoVideo:albuminfo]==YES) {
                [btn setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:albuminfo.thumbnailurl]] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_VIDEO]];
            }else{
                [btn setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:albuminfo.thumbnailurl]] placeholderImage:[[FloggerUIFactory uiFactory] createImage:SNS_PLACEHOLDER_PHOTO]];
            }
            btn.albuminfo = albuminfo;
            btn.videoTimeLable.text=[GlobalUtils displayableStrFromVideoduration:[albuminfo.videoduration intValue]];
            
            [btn isVideo:[self isAlbuminfoVideo:albuminfo]]; 

            if([self.selectcells containsObject:albuminfo])
            {
                [btn setChecked:YES];
            }else{
                [btn setChecked:NO];
            }
            [btn setEnabled:YES];
            [btn setHidden:NO];
            if([btn superview].tag ==TagOfBackGroundForAnimation){ [[btn superview] setHidden:NO];}
            index++;
        }else{
            //CheckGridCellButton *btn = [cell.controlArray objectAtIndex:i];
            //[btn setImageWithURL:nil placeholderImage:nil];
            if([btn superview].tag ==TagOfBackGroundForAnimation){[[btn superview] setHidden:YES];}
            [btn setHidden:YES];
            [btn setEnabled:NO];
            //break;
        }
    }
}

-(BOOL) isLastRow:(NSInteger)row
{
    NSInteger lastRow = self.dataArr.count/4;
    if (self.dataArr.count %4==0) {
        lastRow --;
    }
    
    return row == lastRow;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isCellForMore:[indexPath row]]) {
        return [self heightForMore] + self.bottomOffset;
    }
    
    if (!self.hasMore && [self isLastRow:[indexPath row]]) {
        return 80 + self.bottomOffset;
    }
    
    return 81;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isCellForMore:[indexPath row]]) {
        return [self cellForMore:tableView];
    }
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    CheckGridViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[CheckGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.checkGridViewCellDelegate = self;
        
    }
    
    if(type == kCheckGrid_IssueInfo_Type)
        [self setIssueinfoCell:cell indexPath:indexPath];
    else
        [self setAlbuminfoCell:cell indexPath:indexPath];
    
    
    return cell;
}

#pragma checkgridviewcell delegate
-(void)removeSelectCell:(CheckGridCellButton*)btn
{
    if(type == kCheckGrid_IssueInfo_Type)
        [self.selectcells removeObject:btn.issueinfo];
    else
        [self.selectcells removeObject:btn.albuminfo];
}

-(void)addSelectcells:(CheckGridCellButton*)btn
{
    if(type == kCheckGrid_IssueInfo_Type)
        [self.selectcells addObject:btn.issueinfo];
    else
        [self.selectcells addObject:btn.albuminfo];
}

-(void)selectcell:(id)sender
{
    CheckGridCellButton* btn = (CheckGridCellButton*)sender;
    if(!_selectflag){
        
        if(self.checkGridDelegate){
            if(type == kCheckGrid_IssueInfo_Type){
                Issueinfo* info = [btn issueinfo];
                [self.checkGridDelegate checkgridSelectIssueInfo:info];
            }else{
                Albuminfo* info = [btn albuminfo];
                [self.checkGridDelegate checkgridSelectAlbuminfo:info];
            }
            
        }
        return;
    }
    if([btn IsChecked])
    {
//        NSLog(@"touchEndInside IsChecked");
        [btn setChecked:FALSE]; 
        if([btn getType]== ISSUE_CATEGORY_PICTURE)
            _photoselectnum --;
        else if([btn getType] == ISSUE_CATEGORY_VIDEO)
            _videoselectnum --;
        
        [self removeSelectCell:btn];
        
        if(self.checkGridDelegate){
            [self.checkGridDelegate checkgridUnSelectItem:btn];
        }
        
    }
    else
    {
//        NSLog(@"touchEndInside not IsChecked");
        [btn setChecked:TRUE];
        if([btn getType]== ISSUE_CATEGORY_PICTURE)
            _photoselectnum ++;
        else if([btn getType] == ISSUE_CATEGORY_VIDEO)
            _videoselectnum ++;
        
        [self addSelectcells:btn];
        if(checkGridDelegate){
            [checkGridDelegate checkgridSelectItem:btn];
        }
        
    }

}




@end
