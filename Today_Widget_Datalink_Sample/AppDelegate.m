//
//  AppDelegate.m
//  Today_Widget_Datalink_Sample
//
//  Created by ohtaisao on 2014/09/17.
//  Copyright (c) 2014年 isao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    bool isFirst = YES;
    // 初回起動かどうかを判定する処理
    
    // ここで表示したい ViewController を指定する
    UIViewController *viewController;
    if(isFirst){
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"root"];
    }else{
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"webview"];
    }
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    //[self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    
    
  //  self.window.rootViewController = viewController;
  //  [self.window makeKeyAndVisible];

    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation");
    NSLog(@"absoluteString : %@",[url absoluteString]); //openNews://host
    NSLog(@"scheme         : %@",[url scheme]); //openNews
    NSLog(@"query          : %@",[url query]);  //?adc
    NSString *scheme = [url scheme];
  
    if ([scheme isEqualToString:@"opennews"]) {
        NSLog(@"Open URL Schemes !!");
        NSString *host = [url fragment];
        _link_html = [NSString stringWithFormat:@"%@",host];
        NSLog(@"%@",_link_html);
        
//        BOOL stop = YES;
//        while (stop);
        
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation");
    NSLog(@"absoluteString : %@",[url absoluteString]); //openNews://host
    NSLog(@"scheme         : %@",[url scheme]); //openNews
    NSLog(@"query          : %@",[url query]);  //?adc
    NSString *scheme = [url scheme];
    
    if ([scheme isEqualToString:@"opennews"]) {
        NSLog(@"Open URL Schemes !!");
        NSString *host = [url fragment];
        _link_html = [NSString stringWithFormat:@"%@",host];
        NSLog(@"%@",_link_html);
        
        //        BOOL stop = YES;
        //        while (stop);
        
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
