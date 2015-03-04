//
//  ExternalShareView.h
//  Flogger
//
//  Created by jwchen on 12-2-25.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExternalShareView;
@protocol ExternalShareViewDelegate <NSObject>
-(void)externalShareView:(ExternalShareView *)externalShareView didSelectedAtIndex:(NSInteger)index;
@end

@interface ExternalShareView : UIView
{
    NSArray *_platformArray;
}
@property(nonatomic, assign) id /*<ExternalShareViewDelegate>*/ delegate;
@property(nonatomic, retain) NSArray *platformArray;
@end
