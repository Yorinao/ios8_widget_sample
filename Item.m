//
//  Item.m
//  NewsReader
//
//  Created by Dolice on 2013/03/02.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import "Item.h"

@implementation Item

+(NSDate *)string2nsdate:(NSString *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale_jp = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    [formatter setLocale:locale_jp];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"YYYY年 M月dd日 HH時mm分"];
    NSDate *nsdate = [formatter dateFromString:date];
    return nsdate;
}
+(NSString *)nsdate2string:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"YYYY年 M月dd日 HH時mm分"];
    NSString *str_date = [formatter stringFromDate:date];
    return  str_date;
}

-(void)setDate:(NSString *)date
{
   _nsdate_date = [Item string2nsdate:date];
}

@end