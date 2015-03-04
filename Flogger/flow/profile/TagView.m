//
//  TagView.m
//  Flogger
//
//  Created by steveli on 25/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "TagView.h"
#import "TagButton.h"

#define HSPACE     10
#define ORG_X      5
#define ORG_Y      5
#define VSPACE     10
#define CELL_W     74
#define CELL_H     38
#define CELL_COUNT 4
#define TOP_SPACE  5
#define LEFT_SPACE 5


#define TAG_DEFAULT_WIDTH 61
#define TAG_CONTENT_SPACE 15



@implementation TagView
@synthesize mainview,datas,delegate,content,isshow;


-(void)dealloc
{
    self.datas = nil;
    self.mainview = nil;
    self.delegate = nil;
    self.content = nil;
    [super dealloc];
    
}

- (id)initWithFrame:(CGRect)frame
{
//    NSLog(@"tagview  initWithFrame");
    self = [super initWithFrame:frame];
    if (self) {
        self.mainview = [[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)]autorelease];
        [self addSubview:self.mainview];
        
        //mainview.backgroundColor = [UIColor blackColor];
        
        _x = ORG_X;
        _y = ORG_Y;
        _lastw = 0;
        _count = 0;
        
        self.isshow = NO;
    }
    return self;
}

-(void)createTagBtn:(NSString*)_content
{
    CGFloat w = [GlobalUtils getTextWidth:_content fontstyle:FONT_MIDDLE].width + 2*TAG_CONTENT_SPACE;
    if(w < TAG_DEFAULT_WIDTH)
        w = TAG_DEFAULT_WIDTH;
    
    if(w + _x + _lastw + HSPACE > self.frame.size.width){
        _x = ORG_X + HSPACE;
        _y += CELL_H + VSPACE;
    }else{
        _x = _x + _lastw + HSPACE;
    }
    
    if(_y > mainview.frame.size.height){
        [mainview setContentSize:CGSizeMake(self.frame.size.width, _y + TOP_SPACE + CELL_H)];
    }

    
    _lastw = w;
    _count++;
    TagButton* btn = [[[TagButton alloc]initWithFrame:CGRectMake(_x,_y+5, w, CELL_H-10)]autorelease];
    btn.tag = _count;
    [btn setText:_content];
    btn.delegate = self;
    
    if(isshow)
        [btn setShowDeleteIcon:YES];
    [mainview addSubview:btn];
}


-(void)createtagview
{
    NSMutableArray* array = [[[NSMutableArray alloc]initWithArray:[self.content componentsSeparatedByString:@","]]autorelease];
    self.datas = array;
    array = nil;
    for(NSString* str in datas)
    {
        //[self createTagBtn:[NSString stringWithFormat:@"#%@#",str]]; 
        [self createTagBtn:str]; 
    }

}

-(void)setTagContent:(NSString*)str
{
//    NSLog(@"settagcontent str = %@",str);
    self.content = nil;
    self.content = str;
    [self createtagview];    
}
-(NSString*)getTagContent
{
    return content;
}

-(void)reload
{
    NSArray* array =  [mainview subviews];
    for(UIView* view in array){
        [view removeFromSuperview];
        view = nil;
    }
    
    _x = ORG_X;
    _y = ORG_Y;
    _lastw = 0;
    _count = 0;
    
    self.datas = nil;
    [self createtagview];   
}


-(void)setTagData:(NSMutableArray*)d
{
//    NSLog(@"settagdata d.count = %d",d.count);
    self.datas = d;
    
    for(NSString* str in d)
    {
        [self createTagBtn:str];    
    }
}

-(void)tagButtonDelete:(id)sender
{
    TagButton* btn = (TagButton*)sender;
    
    NSRange range;
    
    if(btn.text != nil && ![btn.text isEqualToString:@""])
       range = [self.content rangeOfString:btn.text];
    else{
       range = [self.content rangeOfString:@",,"];
       if(range.length == 0)
       {
           if([[content substringFromIndex:(content.length - 1)] isEqualToString:@","]){
               [self.delegate tagviewCellDelete:sender content:[content substringToIndex:content.length-1]];
               return;
           }
       }
    }
//    NSLog(@"range content = %@ ,content.length = %d , btn.text = %@ , location = %d,length = %d",content,content.length,btn.text,range.location,range.length);
    
    if(range.length == 0)
        return;
    
    
    NSString* str1 = nil;
    NSString* str2 = nil;
    
    
    if(range.location > 0)
        str1 = [content substringToIndex:(range.location - 1)];
    
    if((range.location + range.length) < content.length){
        str2 = [content substringFromIndex:(range.location + range.length + 1)];
//        NSLog(@"delete text = %@ ,str1 = %@ , str2 = %@",btn.text,str1,str2);
    }else{
//        NSLog(@"delete text = %@ ,str1 = %@",btn.text,str1);
    }
    
    NSString* res = nil;
    if(str1 != nil && str2 != nil)
        res = [NSString stringWithFormat:@"%@,%@",str1,str2];
    else if(str1 != nil && str2 == nil)
        res = [NSString stringWithFormat:@"%@",str1];
    else if(str1 == nil && str2 != nil)
        res = [NSString stringWithFormat:@"%@",str2];
    
//    NSLog(@"delete text = %@ ,str1 = %@ , str2 = %@ ,res = %@",btn.text,str1,str2,res);

    [self.delegate tagviewCellDelete:sender content:res];
    str1 = nil;
    str2 = nil;
    res  = nil;
}
-(void)tagButtonPressed:(id)sender content:(NSString*)c
{
    [self.delegate tagviewCellPressed:sender content:c];
}


-(void)showdelete
{
    for(UIView* view in mainview.subviews)
    {
        TagButton* btn = (TagButton*)view;
        [btn setShowDeleteIcon:YES];
    }
    isshow = YES;
}
-(void)hidedelete
{
    for(UIView* view in mainview.subviews)
    {
        TagButton* btn = (TagButton*)view;
        [btn setShowDeleteIcon:NO];
    }
    
    isshow = NO;
}
@end
