//
//  TodayViewController.h
//  tablelike_view
//
//  Created by ohtaisao on 2014/09/18.
//  Copyright (c) 2014年 isao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsMessageView.h"
#import "UIViewCalender.h"

@interface TodayViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIViewCalender *Widget_View;

-(IBAction)next_news:(id)sender;

@end
