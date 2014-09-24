//
//  ViewController.m
//  Today_Widget_Datalink_Sample
//
//  Created by ohtaisao on 2014/09/17.
//  Copyright (c) 2014年 isao. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "Item.h"
#import "ASIHTTPRequest.h"
#import "XMLReader.h"
#import "WebViewController.h"

@interface ViewController ()
{
    NSString *jump_link;
    Item *_item;
    NSMutableArray *items;
    NSDictionary *dicinfo;
    
    NSInteger Cell_Count;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:@"applicationDidBecomeActive"
                                               object:nil];
    
    [self jump_webview];
    
    [self receiveInfoWithCompletedBlock:^{
        [_NewsTableView reloadData];
    }
                             errorBlock:nil];
}

- (void)applicationDidBecomeActive {
    //NSLog(@"hogehoge");
     [self jump_webview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationDidBecomeActive" object:nil];
    
//[super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark jump method
-(void)jump_webview
{
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    jump_link = appdel.link_html;
    
    if (jump_link!=nil) {
        [self jump_webview:jump_link and_title:nil];
        jump_link = nil;
        appdel.link_html = nil;
    }

}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self find_and_jump_link:cell.textLabel.text];
}

#pragma mark -
#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [items count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    // セルの内容はNSArray型の「items」にセットされているものとする
    Item *one_news = [items objectAtIndex:indexPath.row];
    
   
    cell.textLabel.text       = one_news.title;
    [cell.textLabel adjustsFontSizeToFitWidth];
    //[cell.textLabel sizeToFit];
   
    cell.detailTextLabel.text = one_news.date;
    
    return cell;
}

#pragma mark -
#pragma mark local
-(void)find_and_jump_link:(NSString *)title
{
    for (Item *one in items) {
        if ([title compare:one.title] == NSOrderedSame) {
            [self jump_webview:one.hpaddress and_title:title];
        }
    }
}

-(void)jump_webview:(NSString *)link and_title:(NSString *)title
{
    //Storyboardを特定して
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //そのStoryboardにある遷移先のViewConrollerを用意して
    WebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"webview"];
    vc.myURL = link;
    vc.title = title;
    //呼び出し！
    // [self performSegueWithIdentifier:@"tbv2web" sender:self];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark get rss info
-(void) receiveInfoWithCompletedBlock:(dispatch_block_t)block errorBlock:(dispatch_block_t)errorBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        //NSURL *url = [NSURL URLWithString:@"http://headlines.yahoo.co.jp/rss/all-c_int.xml"];
        NSURL *url = [NSURL URLWithString:@"http://www.4gamer.net/rss/smartphone/smartphone_index.xml"];
        
        ASIHTTPRequest *request;
        NSError *err;
        
        request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request startSynchronous];
        err = [request error];
        if (err) {
            if (errorBlock!=nil) {
                dispatch_sync(dispatch_get_main_queue(), errorBlock);
            }
            
            return ;
        }
        dicinfo = [XMLReader dictionaryForXMLData:request.responseData error:&err];
        NSArray *rss_array     = [dicinfo valueForKey:@"rdf:RDF"];
        NSArray *channel_items = [rss_array valueForKey:@"item"];
        
        [items removeAllObjects];
        // Imagetext_save_load *isl = [[Imagetext_save_load alloc] init];
        
        NSMutableArray *tmp_items = [[NSMutableArray alloc] init];
        int set_description_flg;
        for (NSArray *one_chan in channel_items) {
            
            set_description_flg = TRUE;
            Item *tmp_item = [[Item alloc] init];
            
            NSDictionary *chan_title = [one_chan valueForKey:@"title"];
            NSString *title = [chan_title valueForKey:@"text"];
            
            NSDictionary *pubDate = [one_chan valueForKey:@"dc:date"];
            NSString *str_date = [pubDate valueForKey:@"text"];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeStyle:NSDateFormatterFullStyle];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
            NSDate *date = [formatter dateFromString:str_date];
            
            NSString *str_date_jpn = [Item nsdate2string:date];
           
           // NSLog(@"%@",str_date_jpn);
            
            NSDictionary *linkHtmlD = [one_chan valueForKey:@"link"];
            NSString *linkHtml = [linkHtmlD valueForKey:@"text"];
            
            // 文字列strの中に@"AAA"というパターンが存在するかどうか
            title = [title stringByReplacingOccurrencesOfString:@"'" withString:@""];
            
            tmp_item.title    = title;
            tmp_item.date     = str_date_jpn;
            tmp_item.category = @"";
            tmp_item.hpaddress = linkHtml;
            
            /*
             if (set_description_flg) {
             //_item.description = @"";
             NSDictionary *channel_link_ar = [one_chan valueForKey:@"link"];
             NSString *channel_link = [channel_link_ar valueForKey:@"text"];
             [Url_content get_content_form_url:channel_link reload_table:m_TblView setitem:tmp_item];
             }
             */
            
            [tmp_items addObject:tmp_item];
        }
        
        [items removeAllObjects];
        items = [[NSMutableArray alloc] initWithArray:tmp_items];
        
        if (block!=nil) {
            dispatch_sync(dispatch_get_main_queue(), block);
            
        }
    });
}


@end
