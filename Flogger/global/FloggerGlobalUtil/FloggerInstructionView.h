//
//  FloggerInstructionView.h
//  Flogger
//
//  Created by wyf on 12-7-6.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define VIEWIMAGEVIEWTAG 777

@interface FloggerInstructionView : UIView


- (id)initWithFrame:(CGRect)frame withImageURL: (NSString *) imageURL;

@property (nonatomic, retain) NSString *viewImageURL;
@end
