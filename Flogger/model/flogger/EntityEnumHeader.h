//
//  EntityEnumHeader.h
//  Flogger
//
//  Created by jwchen on 12-2-18.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ACCOUNTCOM_USER = 1,
    ACCOUNTCOM_FOLLOWING,
    ACCOUNTCOM_FEATURED,
    ACCOUNTCOM_FOLLOWER
}AccountComType;

typedef enum 
{
    ISSUE_INFO_MYSELF,
    ISSUE_INFO_FOLLOWING,
    ISSUE_INFO_FEATURED
}IssueInfoType;

typedef enum 
{
    ISSUE_CATEGORY_TWEET,
    ISSUE_CATEGORY_PICTURE,
    ISSUE_CATEGORY_VIDEO,
    ISSUE_CATEGORY_ACTIVITY
}IssueInfoCategory;


typedef enum{
    ALBUM_INFO_MEDIA_PICTURE = 1,
    ALBUM_INFO_MEDIA_VIDE
}AlbumInfoComMediaType;


typedef enum{
    EXTERNL_SINA = 1,
    EXTERNL_QQ,
    EXTERNL_SOHU,
    EXTERNL_RENREN,
    EXTERNL_KAIXIN,
    EXTERNL_FACABOOK,
    EXTERNL_TWEETER
}ExternalUserSource;

typedef enum
{
    UTILITY_MYSELF,
    UTILITY_FOLLOWING
}UtilityType;

typedef enum 
{
    /*ACTION_COMMENT_TWEET=2,
    ACTION_COMMENT_MEDIA=3,
    ACTION_LIKE=4,
    ACTION_FOLLOW=6*/
    ACTION_PUBLISH = 1,
    ACTION_RESPONE_WEIBO = 2,
    ACTION_RESPONE_PHOTO = 3,
    ACTION_RESPONE_VIDEO = 4,
    ACTION_LIKE = 5,
    ACTION_AT = 6,
    ACTION_FOLLOW = 7
}ActionType;


typedef enum{
    PARENT_WEIBO = 3,
    PARENT_PHOTO = 1,
    PARENT_VIDEO = 2
}ParentType;

@interface EntityEnumHeader : NSObject

@end
