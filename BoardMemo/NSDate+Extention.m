//
//  NSDate+Extention.m
//  LevelUp
//
//  Created by 堤 健 on 12/07/08.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Extention.h"

@implementation NSDate (Extention)

- (NSString *)timeString
{
    NSString *timeString;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    timeString = [formatter stringFromDate:self];
    
    return timeString;
}

-(int)hour
{
    int hour;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:(NSHourCalendarUnit) fromDate:self];
    hour = [comps hour];
    
    return hour;
}

-(int)minute
{
    int minute;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:(NSMinuteCalendarUnit) fromDate:self];
    minute = [comps minute];
    
    return minute;
}

@end
