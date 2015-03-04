//
//  ImageDetail.h
//  Flogger
//
//  Created by jwchen on 11-12-13.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageDetail : NSObject {
    UIImage *img;
    NSString *name;
    NSString *date;
}
@property(nonatomic) NSString *name,*date;
@property(nonatomic) UIImage *img;

-(void)setData:(UIImage*)img:(NSString*)n:(NSString*)d;
@end
