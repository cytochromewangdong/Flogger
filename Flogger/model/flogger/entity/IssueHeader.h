//
//  IssueHeader.h
//  Flogger
//
//  Created by jwchen on 12-2-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#ifndef Flogger_IssueHeader_h
#define Flogger_IssueHeader_h

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
    ISSUE_CATEGORY_VIDEO
}IssueInfoCategory;

#endif
