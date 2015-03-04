//
//  ImageGridViewCell.h
//  Flogger
//
//  Created by jwchen on 11-12-11.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "AQGridViewCell.h"


@interface ImageGridViewCell : AQGridViewCell
{
    UIImageView *_imageView;
}

@property(nonatomic, retain)UIImage *image;
@property(nonatomic, retain) UIImageView *imageView;
@end
