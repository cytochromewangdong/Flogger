//
//  CheckGridViewCell.m
//  Flogger
//
//  Created by steveli on 10/03/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import "CheckGridViewCell.h"
#import "CheckGridCellButton.h"

#define CELL_W  74
#define CELL_H  74
#define HSPACE 5
#define ORG_X 5
#define ORG_Y 7
#define TagOfBackGroundForAnimation 300

@implementation CheckGridViewCell

@synthesize controlArray, count ,checkGridViewCellDelegate;


-(void)btnClicked:(id)sender
{
    if(checkGridViewCellDelegate && [checkGridViewCellDelegate respondsToSelector:@selector(selectcell:)])
    {
        [checkGridViewCellDelegate selectcell:sender];
    }
}


-(CheckGridCellButton*)createButton:(CGFloat)x y:(CGFloat)y
{
    count++;
    CGRect cellframe = CGRectMake(0,0,CELL_W,CELL_H);
    UIView *floggerContainer = [[[UIView alloc]init]autorelease];
    floggerContainer.backgroundColor = RGBCOLOR(0x3d, 0x43, 0x4b);//3d434b
    floggerContainer.frame=CGRectMake(x,y,CELL_W,CELL_H);
    floggerContainer.tag=TagOfBackGroundForAnimation;
    CheckGridCellButton* btn = [[[CheckGridCellButton alloc]initWithFrame:cellframe]autorelease];
    btn.applyAnimation=YES;
    btn.tag = count;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:floggerContainer];
    [floggerContainer addSubview:btn];
    return btn;
}

-(void)setupView
{
    self.controlArray = [[[NSMutableArray alloc]init]autorelease];
    [controlArray addObject:[self createButton:ORG_X y:ORG_Y]];
    [controlArray addObject:[self createButton:ORG_X + CELL_W + HSPACE y:ORG_Y]];
    [controlArray addObject:[self createButton:ORG_X + 2*(CELL_W + HSPACE) y:ORG_Y]];
    [controlArray addObject:[self createButton:ORG_X + 3*(CELL_W + HSPACE) y:ORG_Y]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    self.controlArray = nil;
    [super dealloc];
}

@end
