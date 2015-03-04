//
//  GlobalCommon.h
//  Flogger
//
//  Created by wyf on 12-4-9.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kVideoCropTime 30

#define kRotateIndicate @"rotateIndicate"
#define kRemoteUserInfo @"remoteUserInfo"

#define kDataCacheSystemParameter @"dataCacheSystemParameter"
#define kTokenTime @"tokenTime"
#define kDeviceToken @"tokenToken"
#define kPushInfo @"systempushInfo"


#define kFinishServer @"finishServer"
#define kFinishVideoURL @"finishVideoURL"

#define kUploadServerProxy @"kUploadServerProxy"
//#define kDeleteIssueInfo @"deleteIssueInfo"
//#define kPostIssueInfo @"postIssueInfo"
#define kDataChangeIssueInfo @"dataChangeIssueInfo"

#define kDataCacheTempDataCategory @"dataCacheTempDataCategory"
#define kDataCacheFeedData @"dataCacheFeedData"
#define kDataCacheProfileData @"dataCacheProfileData"
#define kDataCacheCommentData @"dataCacheCommentData"
#define kDataCacheNotificationYou @"dataCacheNotificationYou"
#define kDataCacheNotificationFollow @"dataCacheNotificationFollow"
#define kDataCacheSuggestusersPopular @"dataCacheSuggestusersPopular"
#define kDataCacheSuggestusersFeature @"dataCacheSuggestusersFeature"
#define kDataCachePopular @"dataCachePopular"

#define kNotificationInfoIssueId @"notificationInfoIssueId"
#define kNotificationInfoIssueThread @"notificationIssueThread"
#define kNotificationInfoIssueParentId @"notificationIssueParentId"


#define kNotificationAction @"notificationAction"
#define kNotificationDeleteAction @"notificationDeleteAction"
#define kNotificationPostAction @"notificationPostAction"
#define kNotificationCommentAction @"notificationCommentAction"
#define kNotificationLikeAction @"notificationLikeAction"
#define kNotificationUnLikeAction @"notificationUnLikeAction"

#define kNotificationAtSomebodyAction @"notificationatsomebodyAction"
#define kNotificationReloadTableView @"notificationreloadtableview"
#define kNotificationKeyboardHide @"notificationKeyboardHide"
#define kNotificationReloadCell @"notificationreloadcell"

//#define k

#define kPostImagePath @"imagePath"
#define kPostVideoThumbnail @"videoThumbnail"
#define kPostVideoURL @"videoURL"
#define kPostIssueInfoCom @"IssueInfoCom"
#define kPostOriginalImage @"originalImage"
#define kPostIsImportImage @"isImportImage"

//dataFile
#define kSavedDataMainData @"savedDataMainData"
#define kSavedDataHasMore @"savedDataHasMore"
#define kSavedDataCurrentRow @"savedDataCurrentRow"
#define kSavedDataLastUpdateTime @"savedDataLastUpdateTime"
#define kSavedDataIssueCategory @"savedDataIssueCategory"

//contact info
#define kContactInfoFirstName @"contactInfoFirstName"
#define kContactInfoLastName @"contactInfoLastName"
#define kContactInfoEmail @"contactInfoEmail"
#define kContactInfoEmailLabel @"contactInfoEmailLabel"
#define kContactInfoPhone @"contactInfoPhone"
#define kContactInfoPhoneLabel @"contactInfoPhoneLabel"

//temp
#define kTempSuggestUserTimePopular @"tempSuggestUserTimePopular"
#define kTempSuggestUserTimeFeature @"tempSuggestUserTimeFeature"
#define kTempPopular @"tempPopular"
#define kTempPopularPhotos @"tempPopularPhotos"
#define kTempPopularVideos @"tempPopularVideos"
#define kTempNotificationYou @"tempNotificationYou"
#define kTempNotificationFollowing @"tempNotificationFollowing"

//
#define kThumbnailFormat @"thum_%@"
#define kUploadFilePATHKey @"global_upFile"
#define kLocalIssueID @"local_issue_id"

//tag
#define kTableViewVideoTag 876
@interface GlobalCommon : NSObject

@end
