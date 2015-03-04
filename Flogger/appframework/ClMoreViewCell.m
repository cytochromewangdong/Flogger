//
//  JwMoreViewCell.m
//  TingJing2
//
//  Created by jwchen on 11-11-18.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "ClMoreViewCell.h"

static const CGFloat kMoreButtonMargin = 20;

@implementation ClMoreViewCell

@synthesize animating = _animating, activityIndicatorView = _activityIndicatorView;

- (UIActivityIndicatorView*)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                  UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:_activityIndicatorView];
    }
    
    return _activityIndicatorView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self activityIndicatorView];
        [self setAnimating:NO force:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect viewFrame = self.contentView.frame;
    _activityIndicatorView.frame = CGRectMake(kMoreButtonMargin, (viewFrame.size.height - _activityIndicatorView.frame.size.height)/2, _activityIndicatorView.frame.size.width, _activityIndicatorView.frame.size.height);
    
    self.textLabel.font = [UIFont boldSystemFontOfSize:14];
    self.textLabel.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor]; 
    self.textLabel.frame = CGRectMake(40, 0, 240, 60);
    [self.textLabel setTextAlignment:UITextAlignmentCenter];
//    NSLog(@"layout===== _activityIndicatorView frame is %@",[NSValue valueWithCGRect:_activityIndicatorView.frame]);
}

-(void)setAnimating:(BOOL)animating force:(BOOL)isForce
{
    if (_animating != animating || isForce) {
        _animating = animating;
//        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
//        self.textLabel.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
        if (_animating) {
//            [self.activityIndicatorView bringSubviewToFront:<#(UIView *)#>]
            [self.activityIndicatorView startAnimating];
//            [[self.activityIndicatorView] super ssuz]
//            NSLog(@"layout===== _activityIndicatorView frame is %@",[NSValue valueWithCGRect:self.activityIndicatorView.frame]);
            self.textLabel.text = NSLocalizedString(@"Loading...", @"Loading...");
            
        } else {
            [_activityIndicatorView stopAnimating];
            self.textLabel.text = NSLocalizedString(@"Load more...", @"Load more...");
//            self.textLabel.font = [UIFont boldSystemFontOfSize:14];
//            self.textLabel.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
        }
        [self setNeedsLayout];
    }

}

- (void)setAnimating:(BOOL)animating {
    [self setAnimating:animating force:NO];
}

-(void)dealloc
{
    [_activityIndicatorView release];
    _activityIndicatorView = nil;
    [super dealloc];
}

@end
