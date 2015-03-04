//
//  SingleShareCell.m
//  Flogger
//
//  Created by wyf on 12-4-15.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SingleShareCell.h"
#define kHMargin 10
#define kTSwitchWidth 100
#define kTSwitchHeight 27

@implementation SingleShareCell

@synthesize platform,account,isShare,delegate;
@synthesize unBindButton,switchButton,configButton;
@synthesize iconImage,stringLabel;
//ShareSettingViewController,ShareFeedViewController,FindFriendSelectionViewController>=2 call
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier platform:(MyExternalPlatform *)epf account:(MyExternalaccount *)acc
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.platform = epf;
        self.account = acc;
        [self setupCell];
    }
    return self;
}
//FindFriendSelectionViewController call
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupDefaultCell];
    }
    
    return self;
}

-(void) setupDefaultCell
{
    CGRect bounds = self.bounds;
    UIImageView *imageView = [[FloggerUIFactory uiFactory] createImageView:nil];
    imageView.frame = CGRectMake(20, bounds.size.height/7,bounds.size.height*3/4, bounds.size.height*3/4);

    //    [imageView setImageWithURL:[NSURL URLWithString:self.platform.bigbutton]];
    [self addSubview:imageView];
    UILabel *stringLab = [[FloggerUIFactory uiFactory] createLable];
    stringLab.frame = CGRectMake(imageView.frame.origin.x + 50, bounds.size.height/8, 150, bounds.size.height*3/4);
    stringLab.textAlignment = UITextAlignmentLeft;
    //    stringLab.text = self.platform.name;
      stringLab.font = [[FloggerUIFactory uiFactory] createMiddleBoldFont];
    stringLab.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
    [self addSubview:stringLab];
    
    UIImage *unBindImage = [[FloggerUIFactory uiFactory] createImage:SNS_ALBUM_DELETE_BUTTON];
    UIButton *unBindBtn = [[FloggerUIFactory uiFactory] createButton:unBindImage];
    [unBindBtn setTitle:NSLocalizedString(@"Unbind",@"Unbind") forState:UIControlStateNormal];
    //////////unBindBtn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleBoldFont];
    UIFont *famFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    unBindBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    unBindBtn.titleLabel.font = famFont;
   unBindBtn.frame = CGRectMake(bounds.size.width-20-unBindImage.size.width, bounds.size.height/6, unBindImage.size.width, unBindImage.size.height);
    [unBindBtn addTarget:self action:@selector(unBindClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:unBindBtn];
    
    UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectMake(bounds.size.width-100, bounds.size.height/5, 80, bounds.size.height*3/4)] autorelease];
    
    [switchView setOn:[account.sharestatus boolValue]];
    [switchView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:switchView];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle: NSLocalizedString(@"Configure   ",@"Configure   ") forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

   // btn.titleLabel.textAlignment = UITextAlignmentRight;
    btn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleFont];
    [btn setTitleColor:[[FloggerUIFactory uiFactory] createTableViewFontColor] forState:UIControlStateNormal];
//    [btn setTintColor:[UIColor redColor]];
//    UIImage *bgImage = [FloggerUIFactory uiFactory] createImage:sns_
    
    btn.frame = CGRectMake(bounds.size.width-130, bounds.size.height/8, 110, bounds.size.height*3/4);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(configureClicked:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
    
    //    [self set]
    [self setUnBindButton : unBindBtn];
    [self setConfigButton : btn];
    [self setSwitchButton : switchView];
    
    [self setIconImage:imageView];
    [self setStringLabel:stringLab];
}

-(void) setupCell
{    
     CGRect bounds = self.bounds;
    UIImageView *imageView = [[FloggerUIFactory uiFactory] createImageView:nil];
//    imageView.frame = CGRectMake(20, 6, 32, 32);
    imageView.frame = CGRectMake(20, bounds.size.height/8,bounds.size.height*3/4, bounds.size.height*3/4);
    [imageView setImageWithURL:[NSURL URLWithString:self.platform.bigbutton]];
    [self addSubview:imageView];
    
    
    UILabel *stringLab = [[FloggerUIFactory uiFactory] createLable];
      stringLab.frame = CGRectMake(imageView.frame.origin.x + 50, bounds.size.height/8, 150, bounds.size.height*3/4);
    stringLab.textAlignment = UITextAlignmentLeft;
    stringLab.text = self.platform.name;
    stringLab.font = [[FloggerUIFactory uiFactory] createMiddleBoldFont];
    stringLab.textColor = [[FloggerUIFactory uiFactory] createTableViewFontColor];
    [self addSubview:stringLab];
    
    UIImage *unBindImage = [[FloggerUIFactory uiFactory] createImage:SNS_ALBUM_DELETE_BUTTON];
    UIButton *unBindBtn = [[FloggerUIFactory uiFactory] createButton:unBindImage];
    [unBindBtn setTitle:NSLocalizedString(@"Unbind",@"Unbind") forState:UIControlStateNormal];
    //unBindBtn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleBoldFont];
    UIFont *famFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    unBindBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    unBindBtn.titleLabel.font = famFont;
    unBindBtn.frame = CGRectMake(bounds.size.width-20-unBindImage.size.width, bounds.size.height/6, unBindImage.size.width, unBindImage.size.height);
    [unBindBtn addTarget:self action:@selector(unBindClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:unBindBtn];

    UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectMake(bounds.size.width-100, bounds.size.height/5, 80, bounds.size.height*3/4)] autorelease];
    
    [switchView setOn:[account.sharestatus boolValue]];
    [switchView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:switchView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle: NSLocalizedString(@"Configure   ",@"Configure   ") forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    btn.titleLabel.font = [[FloggerUIFactory uiFactory] createMiddleFont];
    [btn setTitleColor:[[FloggerUIFactory uiFactory] createTableViewFontColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(bounds.size.width-130, bounds.size.height/8, 110, bounds.size.height*3/4);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(configureClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
//    [self set]
    [self setUnBindButton : unBindBtn];
    [self setConfigButton : btn];
    [self setSwitchButton : switchView];
    
    [self setIconImage:imageView];
    [self setStringLabel:stringLab];
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
