//
//  UIViewCalender.h
//  Today_Widget_Datalink_Sample
//
//  Created by ohtaisao on 2014/09/18.
//  Copyright (c) 2014年 isao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsMessageView.h"

@interface UIViewCalender : UIView
{
    NSInteger daynum;
    int       Skip_news_day;
    int       Max_news_count;
    NSDate *Cal_Start_Day;
    NSDate *Cal_End_Day;
    NSDate *Cur_Day;
}

-(void)add_NewsMessageView:(NSMutableArray *)NewsItems;
-(void)rotate_News;

@end
