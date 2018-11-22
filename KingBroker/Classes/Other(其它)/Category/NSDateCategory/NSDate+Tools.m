//
//  NSDate+Tools.m
//  BSProject
//
//  Created by Liu-Mac on 13/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "NSDate+Tools.h"

@implementation NSDate (Tools)

+ (NSDate *)dateWithString:(NSString *)str dateFormat:(NSString *)dateFormat {
    
    NSDateFormatter *dfmt = [[NSDateFormatter alloc] init];
    dfmt.dateFormat = dateFormat;
    
    return [dfmt dateFromString:str];
}
+ (BOOL)dateWithStrings:(NSString *)str dateFormat:(NSString *)dateFormat {
    NSDateFormatter *dfmt = [[NSDateFormatter alloc] init];
    dfmt.dateFormat = dateFormat;
    
    NSDate *datas = [dfmt dateFromString:str];
    
    long timeSp = [datas timeIntervalSince1970]*1000;
    
    long time = [[NSDate date] timeIntervalSince1970]*1000;
    if ((time-timeSp)>3600*24) {
        return YES;
    }else{
        return NO;
    }
    
}
+ (NSDateComponents *)compareDateFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:fromDate toDate:toDate options:kNilOptions];
}

- (BOOL)isThisDay {
    
    NSDateFormatter *dfmt = [[NSDateFormatter alloc] init];
    dfmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [dfmt stringFromDate:self];
    NSString *todayStr = [dfmt stringFromDate:[NSDate date]];
    
    return [dateStr isEqualToString:todayStr];
}

- (BOOL)isYesterDay {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [calendar isDateInYesterday:self];
}

- (BOOL)isThisYear {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger thisYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger dateYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return (thisYear == dateYear);    
}

@end
