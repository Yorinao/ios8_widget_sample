//
//  TodayViewController.m
//  tablelike_view
//
//  Created by ohtaisao on 2014/09/18.
//  Copyright (c) 2014年 isao. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "ASIHTTPRequest.h"
#import "XMLReader.h"
#import "Item.h"

@interface TodayViewController () <NCWidgetProviding>
{
     Item *_item;
     NSMutableArray *items;
     NSDictionary *dicinfo;
}

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self receiveInfoWithCompletedBlock:^{
        NSLog(@"Connect Success");
        [self reload_NewsView];
    }
                             errorBlock:^{
        NSLog(@"Connect Error");
    }
     ];


    self.preferredContentSize = CGSizeMake(320.0f, 220.0f);
    /*
    CGRect webframe = CGRectMake(20, 20, 300, 150);
    UIWebView *bannerview = [[UIWebView alloc] initWithFrame:webframe];
    NSURL *myURL = [NSURL URLWithString:@"http://cache.www.dragonquest.jp/img_131/dqmsl/top/bnr_blog.jpg"];
  
    [bannerview loadRequest:[NSURLRequest requestWithURL:myURL]];
    //[bannerview sizeThatFits:CGSizeZero];
    [bannerview setBackgroundColor:[UIColor clearColor]];
    [self.Widget_View addSubview:bannerview];
    */
    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    // 通知センターに通知要求を登録する
    // この例だと、通知センターに"Tuchi"という名前の通知がされた時に、
    // hogeメソッドを呼び出すという通知要求の登録を行っている。
    [nc addObserver:self selector:@selector(jump_webview:) name:@"NewsMessageView" object:nil];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewsMessageView" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

-(void)jump_webview:(NSNotification *)center{
    // 通知の送信側から送られた値を取得する
    NSURL *myURL = [[center userInfo] objectForKey:@"NewsMessageView_GET_NSURL_BY_TAPPED"];
    [self.extensionContext openURL:myURL completionHandler:nil];
}

-(IBAction)next_news:(id)sender
{
    [_Widget_View rotate_News];
    [self reload_NewsView];
}
#pragma mark -
#pragma mark reload view
-(void)reload_NewsView
{
    [_Widget_View add_NewsMessageView:items];
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
            dispatch_sync(dispatch_get_main_queue(), errorBlock);
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
            //NSLog(@"%@",str_date_jpn);
            
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
        dispatch_sync(dispatch_get_main_queue(), block);
    });
}


@end
