//
//  WebViewController.h
//  Today_Widget_Datalink_Sample
//
//  Created by ohtaisao on 2014/09/22.
//  Copyright (c) 2014年 isao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *WebView;
@property NSString *myURL;
@end
