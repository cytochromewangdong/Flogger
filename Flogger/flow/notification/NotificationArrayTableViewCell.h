//
//  NotificationArrayTableViewCell.h
//  Flogger
//
//  Created by steveli on 17/03/2012.
//  Copyright (c) 2012 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityResultEntity.h"
#import "FloggerLayoutAdapter.h"
#import "ExternalFriendGroup.h"
#define PROFILE_EVENT @"profile"
#define CURRENT_IMAGE_CLICK_EVENT @"currentImageClickEvent"
#define PARENT_IMAGE_CLICK_EVENT @"parentImageClickEvent"
#define AT_CLICK_EVENT @"atEvent"
#define RECOMMAND_CLICK_EVENT @"recommandEvent"
#define kMainProfileImageSideLen 40
#define kFollowProfileImageSideLen 40
#define kImageBigGap 12
#define kImageSmallGap 5
#define kPhotoVideoHeight 75
#define kparentImageHeight 50

#define kBigImageRadius 5
#define kSmallImageRadius 5

#define kScrollTop 55
#define kScrollLeft 10
#define kScrollWidth 300

@class NotificationViewController;
@class NotificationArrayTableViewCell;
@protocol NotificationArrayTableViewCellDelegate <NSObject>
-(void)NotificatinPhotoCellButtonParentMediaOnClick:(ActivityResultEntity*)entity;
-(void)NotificatinPhotoCellButtonMediaOnClick:(ActivityResultEntity*)entity;
-(void)NotificatinPhotoCellTagOnClick:(ActivityResultEntity*)entity;

-(void)NotificatinProfileClick:(MyAccount*)entity;
-(void)RecommandClick:(NSArray*)groupFriends;
@end



@interface NotificationArrayTableViewCell : UITableViewCell<FloggerActionHandler,TapDelegate>
{
    //NSArray *_photoArray;
    NSMutableArray* _entries;
    NSInteger  _imageCount;
    CGFloat _contentWidth;
}


//@property(nonatomic, retain) UIButton *iconView;
//@property(nonatomic, retain) UILabel *titleLable, *timeLabel;
//@property(nonatomic, retain) UIScrollView *scrollView;

//@property(nonatomic, retain) NSArray *photoArray;
//@property(nonatomic, retain) NSMutableArray* entityarrays;
@property(nonatomic, retain) FloggerViewAdpater *mainview;
//@property(nonatomic, retain) NSMutableDictionary *data;
@property(nonatomic, assign) NotificationViewController*  celldelegate;
@property(nonatomic, retain) UIScrollView *scrollView;
-(void) fillData:(NSMutableArray*)entries;

+(NSString *)getNotificationStr:(ActivityResultEntity *)notification;

+(NSString *)getArrayNotificationStr:(ActivityResultEntity *)notification count:(NSInteger)count;

+(NSMutableDictionary *)createParamFromEntries:(NSMutableArray*)data;
+(NSMutableDictionary*)createInvisibleList:(NSMutableArray *)data;
@end
