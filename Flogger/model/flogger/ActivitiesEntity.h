//
//  ActivitiesEntity.h
//  Flogger
//
//  Created by jwchen on 12-3-6.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseEntity.h"
#import "ActivityResultEntity.h"
#import "EntityEnumHeader.h"

@interface ActivitiesEntity : BaseEntity
@property(nonatomic, retain) NSString *user;
@property(nonatomic, assign) ActionType actionType;
@property(nonatomic, assign) IssueInfoCategory category;
@property(nonatomic, retain) NSMutableArray *activities;
@end
