//
//  AlbumHeadView.m
//  Flogger
//
//  Created by jwchen on 12-1-8.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "AlbumHeadView.h"

#define HSPACE -1
#define ORG_X 8.5
#define ORG_Y -2
#define VSPACE 10
#define CELL_W  75
#define CELL_H  107.5
#define TOP_SPACE 5
#define LEFT_SPACE 5

#define IMG_VIEW_COVER_MAIN 1000
#define IMG_VIEW_COVER_SUB 2000


@implementation AlbumHeadView
@synthesize items,lastbtn,backview,mainview,delegate,albuminfos, selectedId, lastid = _lastid;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backview = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)]autorelease];
        [self.backview setImage:[UIImage imageNamed: SNS_ALBUM_BACKGROUND]];
        self.mainview = [[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)]autorelease];
        
        
        _x = ORG_X;
        
        [self addSubview:self.backview];
        [self addSubview:self.mainview];
        
        self.items = [[[NSMutableArray alloc] init]autorelease];
//        self.coverurlitems = [[[NSMutableArray alloc] init]autorelease];
        
        _lastid = -1;
        _count = 0;
        
        self.albuminfos = [[[NSMutableArray alloc]init] autorelease];
    }
    return self;
}

-(void)btnPressed:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
//    NSLog(@"album head %d button clicked, lasttag = %d", tag , _lastid);
        
    if(tag != _lastid)
    {    
        UIButton *btn = (UIButton *)sender;
        [btn setSelected:TRUE];
        
        //[UIView commitAnimations];
        
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setDuration:0.35f];
        [opacityAnimation setRepeatCount:1.f];
        //        [opacityAnimation setAutoreverses:YES];
        [opacityAnimation setFromValue:[NSNumber numberWithFloat:0.f]];
        [opacityAnimation setToValue:[NSNumber numberWithFloat:1.f]];
        //        [opacityAnimation setAutoreverses: YES];
        opacityAnimation.fillMode = kCAFillModeBoth;
        [opacityAnimation setRemovedOnCompletion:NO];
        //        [opacityAnimation ]
        [btn.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
        [self.lastbtn setSelected:FALSE];
        
        _lastid = tag;
        self.lastbtn = btn;
        
        if(self.delegate)
           [self.delegate albumHeadDidSelectItem:[items objectAtIndex:tag-1] index:tag-1];
    }
    
}

-(void)createcell:(MyIssueGroup*)group  imgurl:(NSString*)imgurl
{
    _cellframe = CGRectMake(_x,ORG_Y,CELL_W,CELL_H);
    UIButton* btn = [[[UIButton alloc]initWithFrame:_cellframe]autorelease];
    [btn setImage:[UIImage imageNamed:  SNS_ALBUM_HIGHLIGHT] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed: SNS_ALBUM_HIGHLIGHT] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //[UIView commitAnimations];
    btn.tag = _count+1;//items.count;
    _count++;
    
    if(_lastid == -1 && _count == 1){
        self.lastbtn = btn;
        _lastid = 1;
    }
    
    if (btn.tag == _lastid) {
        [btn setSelected:YES];
        self.lastbtn = btn;
    }
    
    [mainview addSubview:btn];
    
    
    if(imgurl == nil)
        imgurl = @"";
    imgurl=[imgurl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
    UIImageView* imgview = [[[UIImageView alloc]initWithFrame:CGRectMake(_cellframe.origin.x + 9, _cellframe.origin.y + 9, 56.5, 75.5)]autorelease];
    imgview.tag = IMG_VIEW_COVER_MAIN+btn.tag;
    if([imgurl length]<=0){
        [imgview setImage:[UIImage imageNamed: SNS_ALBUM]];
    }else{
        [imgview setImage:[UIImage imageNamed: SNS_ALBUM]];
        UIImageView* coverimgview = [[[UIImageView alloc]initWithFrame:CGRectMake(3, 2, 51, 71)]autorelease];
        coverimgview.layer.masksToBounds = YES;
        coverimgview.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleToFill;
        [coverimgview setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:imgurl]] placeholderImage:nil];
        coverimgview.tag = IMG_VIEW_COVER_SUB;
      [imgview addSubview:coverimgview];
    }
    
    
    UILabel* label = [[[UILabel alloc]initWithFrame:CGRectMake(_cellframe.origin.x + 0, _cellframe.origin.y + 81, CELL_W, 25)]autorelease];
    label.text = group.name;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label setFont:[GlobalUtils getBoldFontByStyle:FONT_MIDDLE]];
    
    //[btn addSubview:imgview];
    //[btn addSubview:label];
    [mainview addSubview:imgview];
    [mainview addSubview:label];
    imgview = nil;
    label = nil;
    btn = nil;
    
    _x += CELL_W - HSPACE;
    
    
    if(_x > mainview.frame.size.width){
        [mainview setContentSize:CGSizeMake( _x+LEFT_SPACE , self.frame.size.height)];
    }
}


-(void)reloadData
{
    _x = ORG_X;
    _count = 0;
//    _lastid = -1;
    [[mainview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i=0;i<items.count;i++)
        [self createcell:[items objectAtIndex:i] imgurl:((MyIssueGroup *)[items objectAtIndex:i]).url/*[coverurlitems objectAtIndex:i]*/];
}

-(void)setItemCoverImg:(MyIssueGroup*)group imgurl:(NSString*)imgurl
{
    if(group)
    {
//        [self.coverurlitems removeObjectAtIndex:(_lastid - 1)];
//        [self.coverurlitems insertObject:imgurl atIndex:(_lastid - 1)];
//        [self reloadData];
        NSInteger index = [self getIssueGroupFromGroupID:[group.id longLongValue]];
        UIView *btnView = [self.mainview viewWithTag:index + 1];
        UIImageView *imgview = (UIImageView *)[self.mainview viewWithTag:IMG_VIEW_COVER_MAIN+btnView.tag];
        [imgview setImage:[UIImage imageNamed: SNS_ALBUM]];
        UIImageView* coverimgview = (UIImageView *)[imgview viewWithTag:IMG_VIEW_COVER_SUB];
        if(!coverimgview)
        {
            coverimgview = [[[UIImageView alloc]initWithFrame:CGRectMake(3, 2, 51, 71)]autorelease];
            coverimgview.tag = IMG_VIEW_COVER_SUB;
            coverimgview.layer.masksToBounds = YES;
            coverimgview.contentMode = UIViewContentModeScaleAspectFill;
           // coverimgview.contentMode = UIViewContentModeScaleAspectFit;
            [imgview addSubview:coverimgview];
        }
        
        [coverimgview setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:imgurl]] placeholderImage:nil];
        
//        NSLog(@"album head view setItemCoverImg _lastid = %d,imgurl = %@",_lastid,imgurl);
    }
}

-(void)addItem:(MyIssueGroup*)group  imgurl:(NSString*)imgurl
{
    [self.items addObject:group];
    if(imgurl != nil){
//        [self.coverurlitems addObject:imgurl];
        [self createcell:group imgurl:imgurl];
    }else{
//        [self.coverurlitems addObject:SNS_ALBUM];
        [self createcell:group imgurl:nil];
    }
}

-(void)addAlbumList:(NSMutableArray*)array
{
    [self.albuminfos addObject:array];
}

-(void)deleteAlbumList:(NSInteger)index
{
    if(index > self.albuminfos.count)
        return;
    [self.albuminfos removeObjectAtIndex:index];
}

-(NSInteger)getIssueGroupFromGroupID:(long long)groupid
{
    NSInteger i = 0;
    for(MyIssueGroup* group in self.items)
    {
        if([group.id longLongValue] == groupid)
        {
            return i;
        }
        i ++;
    }
    return -1;
}


-(void)deleteAlbumInfo:(Albuminfo*)info groupid:(long long)groupid
{
    
    NSInteger index =  [self getIssueGroupFromGroupID:groupid];
    [[self.albuminfos objectAtIndex:index] removeObject:info];
}

-(void)addItem:(UIImage*)img name:(NSString*)name
{
    _cellframe = CGRectMake(_x,ORG_Y,CELL_W,CELL_H);
    UIButton* btn = [[[UIButton alloc]initWithFrame:_cellframe]autorelease];
    [mainview addSubview:btn];
    
    UIImageView* imgview = [[[UIImageView alloc]initWithFrame:CGRectMake(_x, ORG_Y, 70, 70)]autorelease];
    [imgview setImage:img];
    
    UILabel* label = [[[UILabel alloc]initWithFrame:CGRectMake(_x, ORG_Y, 70, 20)]autorelease];
    label.text = name;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    [self.mainview addSubview:imgview];
    [self.mainview addSubview:label];

    _x += CELL_W + HSPACE;
    
    if(_x > mainview.frame.size.width){
        [mainview setContentSize:CGSizeMake(_x+LEFT_SPACE,self.frame.size.height)];
    }
}

-(void)dealloc
{
    self.items = nil;
    self.lastbtn = nil;
    self.mainview = nil;
    self.backview = nil;
    self.delegate = nil;
//    self.coverurlitems = nil;
    self.albuminfos = nil;
    [super dealloc];
        
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(NSMutableArray*)getItems
{
    return self.items;
}

@end
