//
//  VideoGridViewCell.m
//  Flogger
//
//  Created by jwchen on 12-2-17.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "VideoGridViewCell.h"

@implementation VideoGridViewCell

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
    {
        return ( nil );
    }
    
    UIImageView *playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    playView.userInteractionEnabled = NO;
    playView.image = [UIImage imageNamed:@"Play_Button"];
    [self.contentView addSubview: playView];
    [playView release];
    
    return ( self );
}

@end
