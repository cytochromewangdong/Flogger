//
//  FloggerInstructionView.m
//  Flogger
//
//  Created by wyf on 12-7-6.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerInstructionView.h"

@implementation FloggerInstructionView
@synthesize viewImageURL;


-(void) tapInstructionView : (UIGestureRecognizer *) tapGesture
{
    if (self.tag == VIEWIMAGEVIEWTAG) {
        [self removeFromSuperview];
    }
}

- (id)initWithFrame:(CGRect)frame withImageURL: (NSString *) imageURL
{
    self.viewImageURL = imageURL;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *viewImage = [[FloggerUIFactory uiFactory] createImage:viewImageURL];
        UIImageView *viewImageView = [[FloggerUIFactory uiFactory] createImageView:viewImage];
        viewImageView.frame = frame;
        viewImageView.userInteractionEnabled = YES;
        
        self.tag = VIEWIMAGEVIEWTAG;
        [self addSubview:viewImageView];
        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] init]autorelease];
        [tapGesture addTarget:self action:@selector(tapInstructionView:)];
        
        [self addGestureRecognizer:tapGesture];
        //configure        
        [GlobalUtils configureShowHelpView:viewImageURL];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
