//
//  TagButton.m
//  Flogger
//
//  Created by steveli on 24/02/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "TagButton.h"
@implementation TagButton
@synthesize btn_tag,btn_delete,delegate,text;

#define WIDTH 61
#define HEIGHT 28
#define DELETE_WIDTH 18
#define DELETE_HEIGHT 18

-(void)dealloc
{
    self.btn_tag    = nil;
    self.btn_delete = nil;
    self.delegate   = nil;
    self.text       = nil;
    [super dealloc];
}

-(void)pressed:(id)sender
{
    if(sender == btn_tag){
        [delegate tagButtonPressed:self content:self.text];
    }else if(sender == btn_delete){
        [delegate tagButtonDelete:self];
    }
}


-(void)setupView:(CGRect)frame
{
    self.btn_tag = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
    [self.btn_tag setBackgroundImage:[UIImage imageNamed: SNS_TAG_BUTTON] forState:UIControlStateNormal];
    [self.btn_tag addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btn_delete = [[[UIButton alloc]initWithFrame:CGRectMake(btn_tag.frame.origin.x - DELETE_WIDTH/2 , btn_tag.frame.origin.y - DELETE_HEIGHT/2, DELETE_WIDTH, DELETE_HEIGHT)]autorelease];
    [self.btn_delete setBackgroundImage:[UIImage imageNamed: SNS_MINUS] forState:UIControlStateNormal];
    [self.btn_delete setHidden:YES];
    [self.btn_delete addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn_tag];
    [self addSubview:self.btn_delete];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView:frame];
    }
    return self;
}

-(void)setText:(NSString *)str
{
    text = str;
    [self.btn_tag setTitle:[NSString stringWithFormat:@"#%@#",text] forState:UIControlStateNormal];
    [self.btn_tag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_tag.titleLabel setFont:[GlobalUtils getFontByStyle:FONT_MIDDLE]];
    [self.btn_tag.titleLabel setTextAlignment:UITextAlignmentCenter];
}

-(void)setShowDeleteIcon:(BOOL)flag
{
    _isshowdeleteicon = flag;
    [self.btn_delete setHidden:!flag];
}

@end
