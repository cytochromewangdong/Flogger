//
//  NameIndex.h
//  Flogger
//
//  Created by wyf on 12-6-15.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameIndex : NSObject {  
    NSString *_lastName;  
    NSString *_firstName;  
    NSInteger _sectionNum;  
    NSInteger _originIndex;  
}  
@property (nonatomic, retain) NSString *_lastName;  
@property (nonatomic, retain) NSString *_firstName;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *phoneLabel;
@property (nonatomic, retain) NSString *email;
@property (nonatomic) NSInteger _sectionNum;  
@property (nonatomic) NSInteger _originIndex;  
@property (nonatomic) BOOL isSelect;
- (NSString *) getFirstName;  
- (NSString *) getLastName;  
- (NSString *) getName;
- (NSString *) getHanzeName;
@end 
