//
//  WebViewController.m
//  Today_Widget_Datalink_Sample
//
//  Created by ohtaisao on 2014/09/22.
//  Copyright (c) 2014年 isao. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [webView loadRequest:[NSURLRequest requestWithURL:myURL]];
    
    [_WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_myURL]]];
    [_WebView sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
