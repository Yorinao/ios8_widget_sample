//
//  NewsMessageView.m
//  Today_Widget_Datalink_Sample
//
//  Created by ohtaisao on 2014/09/18.
//  Copyright (c) 2014年 isao. All rights reserved.
//

#import "NewsMessageView.h"


@implementation NewsMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.userInteractionEnabled = YES;
    [self setEditable:NO];
    [self setUserInteractionEnabled:YES];
    [self setSelectable:NO];
 
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    tapGesture.numberOfTapsRequired = 1;
    
    
    NSURL *url = [NSURL URLWithString:@"http://cache.www.dragonquest.jp/img_131/dqmsl/top/bnr_blog.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    iv.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [iv setAlpha:0.3];
    [self addSubview:iv];
     
    /*
    UIWebView *bannerview = [[UIWebView alloc] initWithFrame:self.bounds];
    NSURL *myURL = [NSURL URLWithString:@"http://cache.www.dragonquest.jp/img_131/dqmsl/top/bnr_blog.jpg"];
    
    [bannerview loadRequest:[NSURLRequest requestWithURL:myURL]];
    //[bannerview sizeThatFits:CGSizeZero];
    [bannerview setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bannerview];
    [bannerview scalesPageToFit];
*/
    
    // ビューにジェスチャーを追加
    [self addGestureRecognizer:tapGesture];
}


#pragma mark - 
#pragma mark tap controll
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
   
    NSString *urlstring;
    if (_link_url!=nil) {
        urlstring = [NSString stringWithFormat:@"opennews://#%@",_link_url];
    }
    else {
        urlstring = [NSString stringWithFormat:@"opennews://"];
    }
    
   
    
    NSURL *myURL = [NSURL URLWithString:urlstring];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:myURL forKey:@"NewsMessageView_GET_NSURL_BY_TAPPED"];
    // 通知を作成する
    NSNotification *n =
    [NSNotification notificationWithName:@"NewsMessageView" object:self userInfo:dic];
    
    // 通知実行！
    [[NSNotificationCenter defaultCenter] postNotification:n];
    
    /*
    UIWebView *webView = UIWebView.new;
    [self addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:myURL]];
    */
    return;
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSString *urlstring;
    if (_link_url!=nil) {
        urlstring = [NSString stringWithFormat:@"openNews://#%@",_link_url];
    }
    else {
        urlstring = [NSString stringWithFormat:@"openNews://"];
    }
  
    NSURL *myURL = [NSURL URLWithString:urlstring];
    UIWebView *webView = UIWebView.new;
    [self addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:myURL]];
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
