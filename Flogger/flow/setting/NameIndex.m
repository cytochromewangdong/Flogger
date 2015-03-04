//
//  NameIndex.m
//  Flogger
//
//  Created by wyf on 12-6-15.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "NameIndex.h"
#import "pinyin.h"

@implementation NameIndex  
@synthesize _firstName, _lastName;  
@synthesize _sectionNum, _originIndex;  
@synthesize phone,phoneLabel,email;
@synthesize isSelect;


- (NSString *) getName
{
    NSString *name = @"";
    if ([_lastName canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英语  
        name = [[NSString stringWithFormat:@"%@%@",_lastName,_firstName] stringByReplacingOccurrencesOfString:@" " withString:@""];
        return name;  
    } else {
        NSString *hanzeName = [[NSString stringWithFormat:@"%@%@",_lastName,_firstName] stringByReplacingOccurrencesOfString:@" " withString:@""];
        for (int i =0; i < hanzeName.length; i++) {
            name = [NSString stringWithFormat:@"%@%c",name,pinyinFirstLetter([hanzeName characterAtIndex:i])];
        }
        return name;
    }
    
}

- (NSString *) getHanzeName
{
    NSString *name = @"";
    if ([_lastName canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英语  
        name = [[NSString stringWithFormat:@"%@%@",_lastName,_firstName] stringByReplacingOccurrencesOfString:@" " withString:@""];
        return name;  
    } else {
        NSString *hanzeName = [[NSString stringWithFormat:@"%@%@",_lastName,_firstName] stringByReplacingOccurrencesOfString:@" " withString:@""];
//        for (int i =0; i < hanzeName.length; i++) {
//            name = [NSString stringWithFormat:@"%@%c",name,pinyinFirstLetter([hanzeName characterAtIndex:i])];
//        }
        return hanzeName;
    }
}
- (NSString *) getFirstName {  
    if ([_firstName canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英语  
        return _firstName;  
    }  
    else { //如果是非英语  
        return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_firstName characterAtIndex:0])];  
    }  
    
}  
- (NSString *) getLastName { 
    if (!_lastName) {
        _lastName = @"";
    }
    if ([_lastName canBeConvertedToEncoding:NSASCIIStringEncoding]) { 
        if (_lastName && _lastName.length > 0) {
             return _lastName; 
        } else {
             return _firstName; 
        }
    }  
    else {  
        if (_lastName && _lastName.length > 0) {
            return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_lastName characterAtIndex:0])];
        } else {
            return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_firstName characterAtIndex:0])];
        }
          
    }  
    
}  
- (void)dealloc {  
    [_firstName release];  
    [_lastName release]; 
    self.phone = nil;
    self.phoneLabel = nil;
    self.email = nil;
    [super dealloc];  
}  
@end  
