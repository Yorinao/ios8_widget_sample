//
//  Url_content.m
//  NewsReader
//
//  Created by オオタ イサオ on 2013/12/23.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import "Url_content.h"

@implementation Url_content

+(void)get_content_form_url:(NSString *)urlstring setitem:(Item *)item
{
    //http://boilerpipe-web.appspot.com/extract?url=%@&output=json
    //http://ec2-54-199-163-10.ap-northeast-1.compute.amazonaws.com/php/get_test.php?page=http://headlines.yahoo.co.jp/hl?a=20140125-00000055-mai-soci
    //http://ec2-54-199-163-10.ap-northeast-1.compute.amazonaws.com/kodoku/story.plist
//    NSString *urlString = [NSString stringWithFormat:@"http://ec2-54-199-163-10.ap-northeast-1.compute.amazonaws.com/php/get_text.php?page=%@", urlstring];
    NSString *urlString = [urlstring  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *requests = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  
    
    [NSURLConnection sendAsynchronousRequest:requests queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error==nil && data) {
       // if (data) {
            // NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSMutableDictionary*  directions = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            NSDictionary* result=[directions objectForKey:@"result"];
        
            NSString* status=[result objectForKey:@"status"];
            NSLog(@"Status: %@", status);
            
            if ([status isEqualToString:@"true"]) {
                //NSDictionary *resp = [result valueForKey:@"response"];
                NSString *content = [result valueForKey:@"description"];
        
                 item.description = content;
                // 文字列strの中に@"AAA"というパターンが存在するかどうか
              
                NSRange searchResult_maru = [content rangeOfString:@"。\n"];
                NSRange searchResult_kako = [content rangeOfString:@"\n"];
                if(searchResult_maru.location == NSNotFound && searchResult_kako.location == NSNotFound){
              
                    item.description = content;
                }else{
                    // みつかった場合の処理
                    NSString *one_content;
                                   one_content= [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    NSLog(@"%@",one_content);
                    item.description = one_content;
                    
                }
                
            }
        }else NSLog(@"%@",error);
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"Request Done" object:nil];
        
        
    }];

}

@end
