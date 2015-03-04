//
//  GlobalUtils.m
//  Flogger
//
//  Created by jwchen on 11-12-26.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//
#import "TKAlertCenter.h"
#import "GlobalUtils.h"
#import "GlobalData.h"
#import <AddressBook/AddressBook.h>
#import "NSString+MD5.h"
#import "RegexKitLite.h"
#import "RKLMatchEnumerator.h"
#import "AddressBookInfo.h"
#import "MyExternalaccount.h"
#import "SingleShareCell.h"
#import "SBJson.h"
#import "DataCache.h"

//#define kServer @"http://58.221.42.241:8080"
//#define kServer @"https://www.iflogger.com"
//#define kServerHTTP @"http://www.iflogger.com"
#define kServer @"https://www.folo.mobi"
#define kServerHTTP @"http://www.folo.mobi"
//#define kServer @"http://192.168.1.51:8080"
//#define kServerHTTP @"http://192.168.1.51:8080"
//#define kServer @"http://192.168.1.8:8080"
//#define kServer @"http://192.168.1.51:8080"
//#define kServer @"http://169.254.220.8:8080"
//#define kServer @"http://192.168.1.202:8080"
//#define kServer @"http://192.168.1.10"
//#define kServerHTTP @"http://192.168.1.10"
//#define kServer @"https://192.168.1.10"

//#define kServer @"http://58.221.42.241:8080"
//#define kServerHTTP @"http://58.221.42.241:8080"

//#define kServer @"https://60.12.232.250"
//#define kServerHTTP @"http://60.12.232.250"

//#define kServer @"http://60.12.234.177:8080"
//#define kServerHTTP @"http://60.12.234.177:8080"

#define kServicePath @"/Flogger/services/ws/"
#define kUploadPath @"/Flogger/fast/upload"
#define kPreUploadPath @"/Flogger/fast/"
#define kUploadPathHTTP @"/Flogger/fast/upload"


//#define kLingServerUrl @"http://58.221.44.240:8080/LingView/services/ling/"

@implementation GlobalUtils

+(NSString *)serverUrl
{
    return [NSString stringWithFormat:@"%@%@", kServer, kServicePath];
}

+(NSString *)uploadServerUrl
{
    //    return kLingServerUrl;
    return [NSString stringWithFormat:@"%@%@", kServerHTTP, kUploadPathHTTP];
}

+(NSString *)uploadServerUrlHTTPS
{
    //    return kLingServerUrl;
    return [NSString stringWithFormat:@"%@%@", kServer, kUploadPath];
}

+(NSString *)preUploadServerUrl
{
    //    return kLingServerUrl;
    return [NSString stringWithFormat:@"%@%@", kServer, kPreUploadPath];
}

+(NSString *)imageServerUrl:(NSString *)imagePath
{
    //    return kLingServerUrl;
    //    NSLog(@"imageServerUrl: %@", [NSString stringWithFormat:@"%@/Flogger%@", kServer, imagePath]);
    //    return [NSString stringWithFormat:@"%@/Flogger%@", kServer, imagePath];
    return imagePath;
}

+(UIFont*)getFontByStyle:(FontStyle)style
{
    return [UIFont systemFontOfSize:style];
}
+(UIFont*)getBoldFontByStyle:(FontStyle)style
{
    return [UIFont boldSystemFontOfSize:style];
}

+ (NSString *)getDisplayableStrFromDate:(NSDate *)date
{
    //    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    NSString* re = [df stringFromDate:date];
    //    NSLog(@"1111 date: %@", re);
    //    [df release];
    //    
    double kMin = 60;
    double kHour = (kMin * 60);
    double kDay = (kHour * 24);
    double kWeek = kDay * 7;
    double kMonth = kDay * 30;
    double kYear = kMonth * 12;
    
    double timeInterval = ([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]);
    
    //    NSLog(@"time inteval: %f", timeInterval);
    
    NSString *str = nil;
    if (timeInterval <= 0)
    {
        timeInterval = 1;
    }   
    if (timeInterval>kYear) {
        str = [NSString stringWithFormat:NSLocalizedString(@"%dy",@"%dy"), (NSInteger)(timeInterval/kYear)];
    } else if (timeInterval>kMonth ) {
        str = [NSString stringWithFormat:NSLocalizedString(@"%dm",@"%dm"), (NSInteger)(timeInterval/kMonth)];
    }
    else if (timeInterval>kWeek ) {
        str = [NSString stringWithFormat:NSLocalizedString(@"%dw",@"%dw"), (NSInteger)(timeInterval/kWeek)];
    }
    else if (timeInterval>kDay ) {
        str = [NSString stringWithFormat:NSLocalizedString(@"%dd",@"%dd"), (NSInteger)(timeInterval/kDay)];
    }
    else if (timeInterval>kHour ) {
        str = [NSString stringWithFormat:NSLocalizedString(@"%dh",@"%dh"), (NSInteger)(timeInterval/kHour)];
    }
    else if (timeInterval>kMin ) {
        str = [NSString stringWithFormat:NSLocalizedString(@"%dmin",@"%dmin"), (NSInteger)(timeInterval/kMin)];
    }
    else {
        str = [NSString stringWithFormat:NSLocalizedString(@"%ds",@"%ds"), (NSInteger)timeInterval];
    }
    
    return str;
    //    
    //    NSDate * now=[NSDate date];
    //    NSCalendar *cal = [NSCalendar currentCalendar];
    //    [cal setTimeZone:[NSTimeZone localTimeZone]];
    //    NSDateComponents * begin=[cal components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
    //    [begin setHour:0];
    //    [begin setMinute:0];
    //    [begin setSecond:0];
    //    NSDate * dayBegin=[cal dateFromComponents:begin];
    //    
    //    //    NSTimeInterval space= 60 * 60 *24;//40000
    //    
    //    NSTimeInterval spDate=[date timeIntervalSinceDate:dayBegin];//120000
    //    
    //    NSString * re = nil;
    //    if (spDate>=0) 
    //    {//today
    //        NSDateFormatter *todayFT = [[NSDateFormatter alloc] init];
    //        [todayFT setDateFormat:@"HH:mm"];
    //        re = [NSString stringWithFormat:@"今天 %@", [todayFT stringFromDate:date]];
    //        [todayFT release];
    //        
    //        NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //        [df setDateFormat:@"MM-dd HH:mm"];
    //        NSLog(@"dayBegin: %@", [df stringFromDate:dayBegin]);
    //        NSLog(@"date: %@, time: %f", [df stringFromDate:date], spDate);
    //        [df release];
    //    }
    //    else
    //    {
    //        NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //        [df setDateFormat:@"MM-dd HH:mm"];
    //        re = [df stringFromDate:date];
    //        //        NSLog(@"1111 date: %@", [df stringFromDate:dayBegin]);
    //        [df release];
    //    }
    //    
    //    return re;
}

+ (NSString *)getDisplayableStrFromDateForComment:(NSDate *)date
{
    //    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    NSString* re = [df stringFromDate:date];
    //    NSLog(@"1111 date: %@", re);
    //    [df release];
    //    
    double kMin = 60;
    double kHour = (kMin * 60);
    double kDay = (kHour * 24);
    double kWeek = kDay * 7;
    double kMonth = kDay * 30;
    double kYear = kMonth * 12;
    
    double timeInterval = ([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]);
    
    NSString *str = nil;
    if (timeInterval <= 0)
    {
        timeInterval = 1;
    }   
    if (timeInterval>kYear) {
        if ((NSInteger)(timeInterval/kYear)>1) {
            str = [NSString stringWithFormat:NSLocalizedString(@"%d years ago",@"%dy"), (NSInteger)(timeInterval/kYear)];
        }else{
            str = [NSString stringWithFormat:NSLocalizedString(@"%d year ago",@"%dy"), (NSInteger)(timeInterval/kYear)];
        }
    } else if (timeInterval>kMonth ) {
        if ((NSInteger)(timeInterval/kMonth)>1) {
            str = [NSString stringWithFormat:NSLocalizedString(@"%d months ago",@"%dm"), (NSInteger)(timeInterval/kMonth)];
        }else{
            str = [NSString stringWithFormat:NSLocalizedString(@"%d month ago",@"%dm"), (NSInteger)(timeInterval/kMonth)];
        }
    }
    else if (timeInterval>kWeek ) {
        if ((NSInteger)(timeInterval/kWeek)>1) {
            str = [NSString stringWithFormat:NSLocalizedString(@"%d weeks ago",@"%dw"), (NSInteger)(timeInterval/kWeek)];
        }else{
            str = [NSString stringWithFormat:NSLocalizedString(@"%d week ago",@"%dw"), (NSInteger)(timeInterval/kWeek)];   
        }
    }
    else if (timeInterval>kDay ) {
        if ((NSInteger)(timeInterval/kDay)>1) {
            str = [NSString stringWithFormat:NSLocalizedString(@"%d days ago",@"%dd"), (NSInteger)(timeInterval/kDay)];
        }else{
            str = [NSString stringWithFormat:NSLocalizedString(@"%d day ago",@"%dd"), (NSInteger)(timeInterval/kDay)];
        }
    }
    else if (timeInterval>kHour ) {
        if ( (NSInteger)(timeInterval/kHour)>1) {
            str = [NSString stringWithFormat:NSLocalizedString(@"%d hours ago",@"%dh"), (NSInteger)(timeInterval/kHour)];
        }else{
            str = [NSString stringWithFormat:NSLocalizedString(@"%d hour ago",@"%dh"), (NSInteger)(timeInterval/kHour)];
        }
    }
    else if (timeInterval>kMin ) {
        if ((NSInteger)(timeInterval/kMin)>1) {
            str = [NSString stringWithFormat:NSLocalizedString(@"%d minutes ago",@"%dmin"), (NSInteger)(timeInterval/kMin)];
        }else{
            str = [NSString stringWithFormat:NSLocalizedString(@"%d minute ago",@"%dmin"), (NSInteger)(timeInterval/kMin)];
        }
    }
    else {
        if ((NSInteger)timeInterval>1) {
            str = [NSString stringWithFormat:NSLocalizedString(@"%d seconds ago",@"%ds"), (NSInteger)timeInterval];
        }else{
            str = [NSString stringWithFormat:NSLocalizedString(@"%d second ago",@"%ds"), (NSInteger)timeInterval];
        }
    }
    
    return str;
    
}

+ (NSString *)displayableStrFromVideoduration:(int) videoduration
{
    
    int kMin = 60;
    int vMin=0;
    int vSend=0;
    
    NSString *str = nil;
    if (videoduration < 0)
    {
        videoduration = 0;
    }   
    if (videoduration>=kMin ) {
        vMin=(videoduration/kMin);
        vSend=videoduration%vMin;
    }else{
        vMin=0;
        vSend=videoduration;
    }
    str = [NSString stringWithFormat:NSLocalizedString(@"%d:%02d",@"%d:%02d"), vMin,vSend];
    
    return str;
    
}


+ (NSString *)getDisplayableStrFromDateTest:(NSDate *)date
{
    NSDate * now=[NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents * begin=[cal components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
    [begin setHour:0];
    [begin setMinute:0];
    [begin setSecond:0];
    NSDate * dayBegin=[cal dateFromComponents:begin];
    
    //    NSTimeInterval space= 60 * 60 *24;//40000
    
    NSTimeInterval spDate=[date timeIntervalSinceDate:dayBegin];//120000
    
    NSString * re = nil;
    if (spDate>=0) 
    {//today
        NSDateFormatter *todayFT = [[NSDateFormatter alloc] init];
        [todayFT setDateFormat:@"HH:mm"];
        re = [NSString stringWithFormat:@"今天 %@", [todayFT stringFromDate:date]];
        [todayFT release];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd HH:mm"];
        //        NSLog(@"dayBegin: %@", [df stringFromDate:dayBegin]);
        //        NSLog(@"date: %@, time: %f", [df stringFromDate:date], spDate);
        [df release];
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd HH:mm"];
        re = [df stringFromDate:date];
        //        NSLog(@"1111 date: %@", [df stringFromDate:dayBegin]);
        [df release];
    }
    
    return re;
}

+ (void)showMessageAlert:(NSString *)str delegate:(id)dele tag:(NSInteger)itag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil
                                                   delegate:dele cancelButtonTitle:nil
                                          otherButtonTitles:@"确认", @"取消", nil];
    alert.tag = itag;
    [alert show];
    [alert release];
}

+ (void)showPostMessageAlert:(NSString *)str
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:str];
}

+(UIBarButtonItem*)customBarButton :(NSString *)name normalimg:(UIImage*)img highlightimg:(UIImage*)img1 addTarget:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    if(img!=nil)
        [button setImage:img forState:UIControlStateNormal];
    if(img1!=nil)
        [button setImage:img1 forState:UIControlStateHighlighted];
    
    if(self!=nil)
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //[RELEASE_SAFELY(testImage)];
    
    if(img!=nil){
        if(name!=nil)
        {
            UILabel* label = [[UILabel alloc]initWithFrame:button.frame];
            label.font = [GlobalUtils getBoldFontByStyle:FONT_MIDDLE];
            label.text = name;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            [button addSubview:label];
            RELEASE_SAFELY(label);
            label = nil;
        }
    }else{
        if(name!=nil)
        {
            [button setTitle:name forState:UIControlStateNormal];
            [button setTintColor:[UIColor whiteColor]];
        }
    }
    UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    return barButtonItem;
}


+(CGSize)getBoldTextWidth:(NSString*)content fontstyle:(FontStyle)style
{
    return [content sizeWithFont:[GlobalUtils getBoldFontByStyle:style]];
}
+(CGSize)getTextWidth:(NSString*)content fontstyle:(FontStyle)style
{
    return [content sizeWithFont:[GlobalUtils getFontByStyle:style]];
}



+(void)showAlert:(NSString*)t message:(NSString*)message
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:t 
                                                   message:message
                                                  delegate:self 
                                         cancelButtonTitle:NSLocalizedString(@"OK",@"OK") 
                                         otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+(void)closeAlertView : (UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
    //    [GlobalUtils ]
}


+(NSArray *)retrivePhoneNumbers:(ABRecordRef)ref
{
    
    ABMultiValueRef multiPhones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
    
    NSInteger count = ABMultiValueGetCount(multiPhones);
    
    NSMutableArray *array = nil;
    if (count > 0) {
        array = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
        for(CFIndex i = 0; i < count; i++) {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
            NSString *phoneNumber = (NSString *) phoneNumberRef;
            
            //            NSLog(@"-----%@", phoneNumber);
            [array addObject:phoneNumber];
            CFRelease(phoneNumberRef);
        }
    }
    
    CFRelease(multiPhones);
    
    return array;
}

+(NSArray *)retriveEmail:(ABRecordRef)ref
{
    ABMultiValueRef multiPhones = ABRecordCopyValue(ref, kABPersonEmailProperty);
    
    NSInteger count = ABMultiValueGetCount(multiPhones);
    
    NSMutableArray *array = nil;
    if (count > 0) {
        array = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
        for(CFIndex i = 0; i < count; i++) {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
            //            CFRelease(multiPhones);
            NSString *phoneNumber = (NSString *) phoneNumberRef;
            AddressBookInfo *info = [[[AddressBookInfo alloc] init] autorelease];
            info.md5email = [[[phoneNumber uppercaseString] MD5] uppercaseString];
            //            NSLog(@"-----%@", phoneNumber);
            //            NSLog(@"-----%@", info.md5email);
            [array addObject:info];
            //            [phoneNumber release];
            CFRelease(phoneNumberRef);
        }
    }
    
    CFRelease(multiPhones);
    
    return array;
}

/*+(NSMutableArray *) retriveEmailArrayFromAddress
 {
 NSMutableArray * eMailArray = [[[NSMutableArray alloc] init] autorelease];
 
 ABAddressBookRef addressBook = ABAddressBookCreate();    
 CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
 for(int i = 0; i < CFArrayGetCount(results); i++)
 {
 ABRecordRef person = CFArrayGetValueAtIndex(results, i);
 //读取firstname
 NSString *firstname = (NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
 //读取lastname
 NSString *lastname = (NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
 //获取email多值
 ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
 int emailcount = ABMultiValueGetCount(email);    
 for (int x = 0; x < emailcount; x++)
 {
 //获取email Label
 NSString* emailLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
 //获取email值
 NSString* emailContent = (NSString*)ABMultiValueCopyValueAtIndex(email, x);
 
 //emailDict
 NSMutableDictionary *emailDict = [[[NSMutableDictionary alloc] init] autorelease];
 //            if (firstname) {
 //                [emailDict setObject:firstname forKey:kContactInfoFirstName];
 //            }
 [emailDict setValue:firstname forKey:kContactInfoFirstName];
 [emailDict setValue:lastname forKey:kContactInfoLastName];
 [emailDict setValue:emailContent forKey:kContactInfoEmail];
 [emailDict setValue:emailLabel forKey:kContactInfoEmailLabel];
 
 [eMailArray addObject:emailDict];
 }
 
 }
 
 CFRelease(results);
 CFRelease(addressBook);
 return eMailArray;    
 }
 
 
 +(NSMutableArray *) retrivePhoneArrayFromAddress
 {
 NSMutableArray * phoneArray = [[[NSMutableArray alloc] init] autorelease];
 
 ABAddressBookRef addressBook = ABAddressBookCreate();    
 CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
 for(int i = 0; i < CFArrayGetCount(results); i++)
 {
 ABRecordRef person = CFArrayGetValueAtIndex(results, i);
 //读取firstname
 NSString *firstname = (NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
 //读取lastname
 NSString *lastname = (NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
 
 //读取电话多值
 ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
 for (int k = 0; k<ABMultiValueGetCount(phone); k++)
 {
 //获取电话Label
 NSString * personPhoneLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
 //获取該Label下的电话值
 NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, k);
 
 NSMutableDictionary *phoneDict = [[[NSMutableDictionary alloc] init] autorelease];
 [phoneDict setObject:firstname forKey:kContactInfoFirstName];
 [phoneDict setObject:lastname forKey:kContactInfoLastName];
 [phoneDict setObject:personPhone forKey:kContactInfoPhone];
 [phoneDict setObject:personPhoneLabel forKey:kContactInfoPhoneLabel];
 
 [phoneArray addObject:phoneDict];
 }
 }
 
 CFRelease(results);
 CFRelease(addressBook);
 return phoneArray;    
 }*/


//+(void)
//+(NSArray *) retriveEmailDicFromAddress
//+(void) retriveContactsFromAddress
//{
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    
//    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    
//    for(int i = 0; i < CFArrayGetCount(results); i++)
//    {
//        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
//        //读取firstname
//        NSString *personName = (NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
//        //读取lastname
//        NSString *lastname = (NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
//        //读取middlename
//        NSString *middlename = (NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
//        //读取prefix前缀
//        NSString *prefix = (NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
//        //读取suffix后缀
//        NSString *suffix = (NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
//        //读取nickname呢称
//        NSString *nickname = (NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
//        //读取firstname拼音音标
//        NSString *firstnamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
//        //读取lastname拼音音标
//        NSString *lastnamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
//        //读取middlename拼音音标
//        NSString *middlenamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
//        //读取organization公司
//        NSString *organization = (NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
//        //读取jobtitle工作
//        NSString *jobtitle = (NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
//        //读取department部门
//        NSString *department = (NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
//        //读取birthday生日
//        NSDate *birthday = (NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
//        //读取note备忘录
//        NSString *note = (NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
//        //第一次添加该条记录的时间
//        NSString *firstknow = (NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
//        //最后一次修改該条记录的时间
//        NSString *lastknow = (NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty);        
//        //获取email多值
//        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
//        int emailcount = ABMultiValueGetCount(email);    
//        for (int x = 0; x < emailcount; x++)
//        {
//            //获取email Label
//            NSString* emailLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
//            //获取email值
//            NSString* emailContent = (NSString*)ABMultiValueCopyValueAtIndex(email, x);
//        }
//        //读取地址多值
//        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
//        int count = ABMultiValueGetCount(address);    
//        
//        for(int j = 0; j < count; j++)
//        {
//            //获取地址Label
//            NSString* addressLabel = (NSString*)ABMultiValueCopyLabelAtIndex(address, j);
//            //获取該label下的地址6属性
//            NSDictionary* personaddress =(NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);        
//            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
//            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
//            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
//            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
//            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
//            NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];  
//        }
//        
//        //获取dates多值
//        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
//        int datescount = ABMultiValueGetCount(dates);    
//        for (int y = 0; y < datescount; y++)
//        {
//            //获取dates Label
//            NSString* datesLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
//            //获取dates值
//            NSString* datesContent = (NSString*)ABMultiValueCopyValueAtIndex(dates, y);
//        }
//        //获取kind值
//        CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
//        if (recordType == kABPersonKindOrganization) {
//            // it's a company
//            NSLog(@"it's a company\n");
//        } else {
//            // it's a person, resource, or room
//            NSLog(@"it's a person, resource, or room\n");
//        }
//        
//        
//        //获取IM多值
//        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
//        for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
//        {
//            //获取IM Label
//            NSString* instantMessageLabel = (NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
//            //获取該label下的2属性
//            NSDictionary* instantMessageContent =(NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);        
//            NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
//            
//            NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];           
//        }
//        
//        //读取电话多值
//        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
//        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
//        {
//            //获取电话Label
//            NSString * personPhoneLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
//            //获取該Label下的电话值
//            NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, k);
//        }
//        
//        //获取URL多值
//        ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
//        for (int m = 0; m < ABMultiValueGetCount(url); m++)
//        {
//            //获取电话Label
//            NSString * urlLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
//            //获取該Label下的电话值
//            NSString * urlContent = (NSString*)ABMultiValueCopyValueAtIndex(url,m);
//        }
//        
//        //读取照片
//        NSData *image = (NSData*)ABPersonCopyImageData(person);
//        
//        
//        UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 50, 50)];
//        [myImage setImage:[UIImage imageWithData:image]];
//        myImage.opaque = YES;
//        
//    }
//    
//    CFRelease(results);
//    CFRelease(addressBook);
//}

+(NSMutableArray *)getAllContacts
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    NSMutableArray *emailArr = [[[NSMutableArray alloc] init] autorelease];
    for (CFIndex i = 0; i < nPeople && i < 20; i ++) {
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        NSArray *pArr = [self retriveEmail:ref];
        if (pArr && pArr.count > 0) {
            [emailArr addObjectsFromArray:pArr];
        }
    }
    
    CFRelease(allPeople);
    CFRelease(addressBook);
    
    return emailArr;
    
}

+(id)loadFromArchiverByName:(NSString *)fileName
{
    NSString *strPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                         stringByAppendingPathComponent:fileName
                         ];
    return [NSKeyedUnarchiver unarchiveObjectWithFile: strPath];
}

+(void)save2Archiver:(id)model name:(NSString *)fileName
{
    if (!model || !fileName) {
        return;
    }
    
    NSString *strPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                         stringByAppendingPathComponent:fileName
                         ];
    
    if ([NSKeyedArchiver archiveRootObject:model toFile:strPath]) {
        //        NSLog(@"save %@ success", fileName);
    }
}

+(void)removeFromArchiverByName:(NSString *)fileName
{
    NSString *strPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                         stringByAppendingPathComponent:fileName
                         ];;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:strPath error: nil];
}

+(NSString *)getStrByRegex:(NSString *)str
{
    
    NSString *regex = @"(@([\\p{InHalfwidth_and_Fullwidth_Forms}\\p{InKatakana}\\p{InHiragana}\\p{InCJK_Unified_Ideographs}\\w\\d_-]+)(@|\\s)?)";
    str = [str stringByReplacingOccurrencesOfRegex:regex withString:@"<A href='http://at/$1'>$0</A>"];
    
    regex = @"(#([\\p{InHalfwidth_and_Fullwidth_Forms}\\p{InKatakana}\\p{InHiragana}\\p{InCJK_Unified_Ideographs}\\w\\d_-]+)(#|\\s)?)";
    str = [str stringByReplacingOccurrencesOfRegex:regex withString:@"<A href='http://tag/$1'>$0</A>"];
    
    return str;
}

+(UIImage *) getDefaultImage : (NSNumber *) gender
{
    UIImage *femaleImage = [[FloggerUIFactory uiFactory] createImage:SNS_FEMALE_PLACEHOLDER];
    UIImage *maleImage = [[FloggerUIFactory uiFactory] createImage:SNS_MALE_PLACEHOLDER];
    //female:1   male:2
    UIImage *defaultImage = nil;
    if ([gender isEqualToNumber:[NSNumber numberWithInt:1]]) {
        defaultImage = femaleImage;
    } else {
        defaultImage = maleImage;
    }
    return defaultImage;
}

+(BOOL) isEmpty:(NSString* )str
{
    return str? str.length <= 0: YES;
}

+(BOOL) checkIsOwner: (MyAccount *) account
{
    if (![self checkIsLogin]) {
        return NO;
    }
    if (!account) {
        return YES;
    }
    if([account.useruid isEqualToNumber:[GlobalData sharedInstance].myAccount.account.useruid])
        return YES;
    else
        return NO;
}
+(BOOL) checkIsOwnerByUserUID: (long long) userUID
{
    if (![self checkIsLogin]) {
        return NO;
    }
    if(userUID  == [[GlobalData sharedInstance].myAccount.account.useruid longLongValue])
        return YES;
    else
        return NO;
}

+(BOOL) checkIsLogin
{
    if (![GlobalData sharedInstance].myAccount) {
        return NO;
    } else {
        return YES;
    }
}

+(void) clearWebCookie
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
}
+(void) clearExternalPlatformCacheAndCookie : (NSString *) url
{
    //    NSString *str;
    //    str string
    
    if (!url || [[url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return;
    }
    //    NSLog(@"url is %@", url);
    NSURL *targetURL = [NSURL URLWithString:url];
    [[NSURLCache sharedURLCache]removeCachedResponseForRequest:[NSURLRequest requestWithURL:targetURL]];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookiesForURL:targetURL]) {
        [storage deleteCookie:cookie];
    }
}

+(MyExternalaccount *)getExternalAccount:(NSNumber*)sourceID List:(NSArray*)externalAccountList
{
    for (MyExternalaccount *eaccount in externalAccountList) {
        if ([eaccount.usersource intValue] == [sourceID intValue]) {
            return eaccount;
        }
    }
    return nil;
}

+(MyExternalaccount *)getExternalAccount:(NSNumber*)sourceID
{
    return [GlobalUtils getExternalAccount:sourceID  List:[GlobalData sharedInstance].myAccount.externalaccounts];
}

+(void) saveTokenTime
{
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    NSMutableDictionary *data = [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
    [data setObject:[NSNumber numberWithDouble:currentTime] forKey:kTokenTime];
    NSString *sData = [data JSONRepresentation];
    NSData* pureData = [sData dataUsingEncoding:NSUTF8StringEncoding];
    [[DataCache sharedInstance]storeData:pureData forKey:kDataCacheSystemParameter Category:kDataCacheTempDataCategory];
}

+(BOOL) checkExpiredToken 
{
    NSData* pureData = [[DataCache sharedInstance]dataFromKey:kDataCacheSystemParameter Category:kDataCacheTempDataCategory];   
    //    NSLog(@"share expiretime is %f",[[GlobalData sharedInstance].myAccount.clientSystemParameter.shareExpireTime doubleValue]);
    double intervalTime = [[GlobalData sharedInstance].myAccount.clientSystemParameter.shareExpireTime doubleValue];
    if (intervalTime <= 0) {
        //28 minutes
        intervalTime = 28 * 60;
    }
    if(pureData)
    {
        NSString *sData = [[[NSString alloc]initWithData:pureData encoding:NSUTF8StringEncoding] autorelease];
        NSMutableDictionary *data = [sData JSONValue];
        if (![data objectForKey:kTokenTime]) {
            return YES;
        }
        CFAbsoluteTime lastTime = [[data objectForKey:kTokenTime] doubleValue];
        CFAbsoluteTime currentInterval = CFAbsoluteTimeGetCurrent() - lastTime;
        
        //        NSLog(@"last time si %f",lastTime);
        //        NSLog(@"now time is %f",CFAbsoluteTimeGetCurrent());
        
        if (currentInterval > intervalTime) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;    
}

+ (NSString *)getModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);                              
    if ([sDeviceModel isEqual:@"i386"])      return @"Simulator";  //iPhone Simulator
    if ([sDeviceModel isEqual:@"iPhone1,1"]) return @"iPhone1G";   //iPhone 1G
    if ([sDeviceModel isEqual:@"iPhone1,2"]) return @"iPhone3G";   //iPhone 3G
    if ([sDeviceModel isEqual:@"iPhone2,1"]) return @"iPhone3GS";  //iPhone 3GS
    if ([sDeviceModel isEqual:@"iPhone3,1"]) return @"iPhone3GS";  //iPhone 4 - AT&T
    if ([sDeviceModel isEqual:@"iPhone3,2"]) return @"iPhone3GS";  //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone3,3"]) return @"iPhone4";    //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone4,1"]) return @"iPhone4S";   //iPhone 4S
    if ([sDeviceModel isEqual:@"iPod1,1"])   return @"iPod1stGen"; //iPod Touch 1G
    if ([sDeviceModel isEqual:@"iPod2,1"])   return @"iPod2ndGen"; //iPod Touch 2G
    if ([sDeviceModel isEqual:@"iPod3,1"])   return @"iPod3rdGen"; //iPod Touch 3G
    if ([sDeviceModel isEqual:@"iPod4,1"])   return @"iPod4thGen"; //iPod Touch 4G
    if ([sDeviceModel isEqual:@"iPad1,1"])   return @"iPadWiFi";   //iPad Wifi
    if ([sDeviceModel isEqual:@"iPad1,2"])   return @"iPad3G";     //iPad 3G
    if ([sDeviceModel isEqual:@"iPad2,1"])   return @"iPad2";      //iPad 2 (WiFi)
    if ([sDeviceModel isEqual:@"iPad2,2"])   return @"iPad2";      //iPad 2 (GSM)
    if ([sDeviceModel isEqual:@"iPad2,3"])   return @"iPad2";      //iPad 2 (CDMA)
    
    NSString *aux = [[sDeviceModel componentsSeparatedByString:@","] objectAtIndex:0];
    
    //If a newer version exist
    if ([aux rangeOfString:@"iPhone"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] intValue];
        if (version == 3) return @"iPhone4";
        if (version >= 4) return @"iPhone4s";
        
    }
    if ([aux rangeOfString:@"iPod"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPod" withString:@""] intValue];
        if (version >=4) return @"iPod4thGen";
    }
    if ([aux rangeOfString:@"iPad"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPad" withString:@""] intValue];
        if (version ==1) return @"iPad3G";
        if (version >=2) return @"iPad2";
    }
    //If none was found, send the original string
    return sDeviceModel;
}

+(BOOL) checkExpiredTime : (NSString *) key
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        CFAbsoluteTime lastTime = [[[NSUserDefaults standardUserDefaults] objectForKey:key] doubleValue];
        CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent() - lastTime;
        double intervalTime = 60 * 30;
        if ([key isEqualToString:kTempSuggestUserTimeFeature] || 
            [key isEqualToString:kTempSuggestUserTimePopular]) 
        {
            //30 min
            intervalTime = 60 * 30;
        } else if ([key isEqualToString:kTempPopular]){
            //1 hour
            intervalTime = 60 * 60;
        }
        if (currentTime > intervalTime) {
            return YES;
        }        
    }
    return NO;
}

+(void) configureShowHelpView : (NSString *) viewImageURLKey
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:viewImageURLKey];
}
+(BOOL) checkIsFirstShowHelpView : (NSString *) viewImageURLKey
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:viewImageURLKey]) {
        return NO;
    } else {
        return YES;
    }
    
}

+(NSTimeInterval) getCropVideoTime
{
    NSTimeInterval originalTime = 0;
    if ([GlobalData sharedInstance].myAccount.clientSystemParameter.maxVideoDuration) {
        originalTime = [[GlobalData sharedInstance].myAccount.clientSystemParameter.maxVideoDuration intValue];
    }    
    if (originalTime <= 0) {
        originalTime = kVideoCropTime;
    }
    return originalTime;
}

+(NSString *)printLikers:(NSMutableArray*) likerList{
    NSMutableString *temp= [NSMutableString stringWithCapacity:20];
    for (Likeinfo *objLikeinfoTemp in likerList) {
        [temp appendFormat:@"<A href='at://doaction?%lli'>%@</A>, ",[objLikeinfoTemp.useruid longLongValue],objLikeinfoTemp.username];
    }
    temp=[temp substringToIndex:temp.length-2 ];
    return temp;
}

+(BOOL)checkIOS_6
{
    NSString *osVersion = @"5.9";
    NSString *currOsVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"osversion is %@",currOsVersion);
    return [currOsVersion compare:osVersion options:NSNumericSearch] == NSOrderedDescending;
}

@end
