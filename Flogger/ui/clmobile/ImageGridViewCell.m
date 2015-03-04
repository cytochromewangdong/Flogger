//
//  ImageGridViewCell.m
//  Flogger
//
//  Created by jwchen on 11-12-11.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "ImageGridViewCell.h"

@implementation ImageGridViewCell
@synthesize image, imageView = _imageView;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return ( nil );
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _imageView.userInteractionEnabled = NO;
    [self.contentView addSubview: _imageView];
    
    return ( self );
}

- (CALayer *) glowSelectionLayer
{
    return ( _imageView.layer );
}

-(void)setImage:(UIImage *)img
{
    if (image == img) {
        return;
    }
    
    if (image) {
        RELEASE_SAFELY(image);
    }
    image = [img retain];
    [_imageView setImage:img];
}

-(void)dealloc
{
    RELEASE_SAFELY(_imageView);
    RELEASE_SAFELY(image);
    [super dealloc];
}
@end
