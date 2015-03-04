//
//  PhotoDisplayView.h
//  Flogger
//
//  Created by steveli on 16/03/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PhotoView : UIView {
   CGImageRef  image;
}
@end

@interface PhotoDisplayView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic,retain)  UIImageView               * photoview;
@property (nonatomic,retain)  UIImageView               * bgview; 

-(void)show;
-(void)hide;

@end
