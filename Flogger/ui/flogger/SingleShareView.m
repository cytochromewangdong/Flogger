//
//  SingleShareView.m
//  Flogger
//
//  Created by jwchen on 12-3-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SingleShareView.h"

@implementation SingleShareView
@synthesize platform, account, delegate;
@synthesize isShare;
@synthesize unBindButton,configButton,switchButton;

#define kHMargin 10
#define kSwitchWidth 100
#define kSwitchHeight 27

-(void)setupView
{
    UIImageView *imageView = [[FloggerUIFactory uiFactory] createImageView:nil];
    imageView.frame = CGRectMake(0, 0, 32, 32);
    [imageView setImageWithURL:[NSURL URLWithString:self.platform.bigbutton]];
    [self addSubview:imageView];
    UILabel *stringLable = [[FloggerUIFactory uiFactory] createLable];
    stringLable.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width, imageView.frame.origin.y, 100, 32);
    stringLable.textAlignment = UITextAlignmentLeft;
    stringLable.text = self.platform.name;
    [self addSubview:stringLable];
//    self.backgroundColor = [[FloggerUIFactory uiFactory] createViewFontColor];
    
    
//    if ([self getExternalAccount:externalPlatform]) {            
//        UIButton *unbindBtn = [[FloggerUIFactory uiFactory] createButton:unbindImage];
//        unbindBtn.frame = CGRectMake(226, 0, unbindImage.size.width, unbindImage.size.height);
//        [unbindBtn addTarget:self action:@selector(unBindClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:unbindBtn];
//        //            unbindBtn 
//    }
//    else
//    {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(209, 18, 110, 45);
//        btn.titleLabel.textAlignment = UITextAlignmentRight;
//        btn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [btn setTitle: NSLocalizedString(@"Configure >",@"Configure >") forState:UIControlStateNormal];
//        //            btn.frame = CGRectMake(self.frame.size.width - kHMargin - kSwitchWidth, (self.frame.size.height - kSwitchHeight)/2, kSwitchWidth, kSwitchHeight);
//        [btn addTarget:self action:@selector(configureClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:btn];
//    }
    
    UIImage *unBindImage = [[FloggerUIFactory uiFactory] createImage:SNS_ALBUM_DELETE_BUTTON];
    UIButton *unBindBtn = [[FloggerUIFactory uiFactory] createButton:unBindImage];
    [unBindBtn setTitle:@"UnBind" forState:UIControlStateNormal];
    unBindBtn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleBoldFont];
    unBindBtn.frame = CGRectMake(self.frame.size.width - kSwitchWidth, (self.frame.size.height - kSwitchHeight)/2, unBindImage.size.width, unBindImage.size.height);
    [unBindBtn addTarget:self action:@selector(unBindClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:unBindBtn];
    
    UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - kHMargin - kSwitchWidth, (self.frame.size.height - kSwitchHeight)/2, kSwitchWidth, kSwitchHeight)] autorelease];
    [switchView setOn:[account.sharestatus boolValue]];
    [switchView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:switchView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle: NSLocalizedString(@"Configure >",@"Configure >") forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = UITextAlignmentRight;
    btn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleBoldFont];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn.frame = CGRectMake(self.frame.size.width - kHMargin - kSwitchWidth, (self.frame.size.height - kSwitchHeight)/2, kSwitchWidth, kSwitchHeight);
    [btn addTarget:self action:@selector(configureClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    
    if (account) {
        if (!self.isShare) {
//            UIImage *unBindImage = [[FloggerUIFactory uiFactory] createImage:SNS_ALBUM_DELETE_BUTTON];
//            UIButton *unBindBtn = [[FloggerUIFactory uiFactory] createButton:unBindImage];
//            [unBindBtn setTitle:@"UnBind" forState:UIControlStateNormal];
//            unBindBtn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleBoldFont];
//            unBindBtn.frame = CGRectMake(self.frame.size.width - kSwitchWidth, (self.frame.size.height - kSwitchHeight)/2, unBindImage.size.width, unBindImage.size.height);
//            [unBindBtn addTarget:self action:@selector(unBindClicked:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:unBindBtn];
            unBindBtn.hidden = NO;
            switchView.hidden = YES;
            btn.hidden = YES;
        } else {                
//            UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - kHMargin - kSwitchWidth, (self.frame.size.height - kSwitchHeight)/2, kSwitchWidth, kSwitchHeight)] autorelease];
//            [switchView setOn:[account.sharestatus boolValue]];
//            [switchView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
//            [self addSubview:switchView];
            unBindBtn.hidden = YES;
            switchView.hidden = NO;
            btn.hidden = YES;

        }
    

    }
    else
    {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle: NSLocalizedString(@"Configure >",@"Configure >") forState:UIControlStateNormal];
//        btn.titleLabel.textAlignment = UITextAlignmentRight;
//        btn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleBoldFont];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//         
//        btn.frame = CGRectMake(self.frame.size.width - kHMargin - kSwitchWidth, (self.frame.size.height - kSwitchHeight)/2, kSwitchWidth, kSwitchHeight);
//        [btn addTarget:self action:@selector(configureClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self addSubview:btn];
        unBindBtn.hidden = YES;
        switchView.hidden = YES;
        btn.hidden = NO;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setUnBindButton : unBindBtn];
    [self setConfigButton : btn];
    [self setSwitchButton : switchView];
}

-(void)configureClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(singleShareView:platform:)]) {
        [self.delegate singleShareView:self platform:self.platform];
    }
}

-(void)unBindClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(singleShareViewUnBind:platform:)]) {
        [self.delegate singleShareViewUnBind:self platform:self.platform];
    }
}

-(void)valueChanged:(id)sender
{
    account.sharestatus = [[[NSNumber alloc] initWithBool:((UISwitch *)sender).isOn] autorelease];
}

- (id)initWithFrame:(CGRect)frame platform:(Externalplatform *)epf account:(Externalaccount *)acc
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.platform = epf;
        self.account = acc;
        [self setupView];
    }
    return self;
}


- (id)initWithFrameShare:(CGRect)frame platform:(Externalplatform *)epf account:(Externalaccount *)acc;{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.platform = epf;
        self.account = acc;
        self.isShare = YES;
        [self setupView];
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

-(void)dealloc
{
    self.platform = nil;
    self.account = nil;
    self.unBindButton = nil;
    self.configButton = nil;
    self.switchButton = nil;
    [super dealloc];
}

@end
