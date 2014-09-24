//
//  Item.h
//  NewsReader
//
//  Created by Dolice on 2013/03/02.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Save_Props.h"

@interface Item : NSObject
{

}
@property NSString *title;
@property(nonatomic)  NSString *date;
@property NSString *description;
@property NSString *user;
@property NSString *category;
@property NSString *hpaddress;
@property(readonly) NSDate *nsdate_date;

+(NSDate *)string2nsdate:(NSString *)date;
+(NSString *)nsdate2string:(NSDate *)date;

@end
