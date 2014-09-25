//
//  UIViewCalender.m
//  Today_Widget_Datalink_Sample
//
//  Created by ohtaisao on 2014/09/18.
//  Copyright (c) 2014年 isao. All rights reserved.
//

#import "UIViewCalender.h"
#import "Item.h"

const CGFloat kNewsHeight = 35;
const CGFloat kNewsWidth  = 180;
const CGFloat kStartPosNews = 30;

typedef NS_ENUM(NSInteger, Week) {
    Sunday=1,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday
};

@implementation UIViewCalender

const NSInteger kNumDay = 7;
const NSInteger kMaxRow = 4;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeView];
    }
    return self;
}

// xib を使用する場合
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        [self initializeView];
    }
    return self;
}

-(void)initializeView
{
    daynum = kNumDay;
    NSDate *today = [NSDate date];
    Cal_Start_Day = [today initWithTimeInterval:-1*24*60*60 sinceDate:today];
    Cal_Start_Day = [self get_minmax_day:Cal_Start_Day];
    Cal_End_Day   = [today initWithTimeInterval:7*24*60*60 sinceDate:Cal_Start_Day];
    Cal_End_Day   = [self get_minmax_day:Cal_End_Day];
    Cur_Day       = Cal_Start_Day;
    Skip_news_day = 0;
    Max_news_count = 20;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //Init Size
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.width;
    
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    
    CGFloat height = self.bounds.size.height;
    CGContextTranslateCTM(c, 0.0, height);
    CGContextScaleCTM(c, 1.0, - 1.0);
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorSpace(c, cs);
    CGColorSpaceRelease(cs);
    
    CGContextSetFillColorWithColor(c, self.backgroundColor.CGColor);
    CGContextFillEllipseInRect(c, CGRectMake(0, 0, w, h));
    
    // 白い線
    [self draw_daylines:c Color:[UIColor whiteColor].CGColor];
    
    CGContextFlush(c);
    CGContextRestoreGState(c);

}

-(void)draw_daylines:(CGContextRef)c Color:(CGColorRef)color {
    
    CGColorRef cur_color;
    
    //Init Size
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat daycell_width = [self get_daywidth];
    
    CGColorRef def_color = color;
    
    Cur_Day = Cal_Start_Day;
    for (CGFloat day_posx = self.bounds.origin.x;
        day_posx <= self.bounds.origin.x + w; day_posx +=  daycell_width) {
        CGPoint start = CGPointMake(day_posx, self.bounds.origin.y + h);
        CGPoint end   = CGPointMake(day_posx, self.bounds.origin.y);
       
        
        Week now = [self get_weekend:Cur_Day];
        if (now == Saturday) {
            cur_color = [UIColor blueColor].CGColor;
            [self drawfillrect:c origin:end and_width:daycell_width and_height:h Color:cur_color];
        }
        else if (now == Sunday) {
            cur_color  = [UIColor redColor].CGColor;
            [self drawfillrect:c origin:end and_width:daycell_width and_height:h Color:cur_color];
        }
        else {
            cur_color = def_color;
        }
        
        [self drawline:c Start:start End:end Color:cur_color];
        //get_weekend
        
        Cur_Day = [self get_incr_day:Cur_Day];
        [self drawstring:c and_str:[self get_calday_string:Cur_Day] and_pos:start and_Fondsize:10 and_cgcolor:cur_color];
        
    }
    Cur_Day = Cal_Start_Day;
 }

-(void)drawline:(CGContextRef)c Start:(CGPoint)start End:(CGPoint)end Color:(CGColorRef)color {
    CGContextSetStrokeColorWithColor(c, color);
   
    CGContextMoveToPoint( c, start.x, start.y);
    CGContextAddLineToPoint(c, end.x, end.y);
    CGContextStrokePath(c);
}

-(void)drawfillrect:(CGContextRef)c origin:(CGPoint)origin and_width:(CGFloat)width and_height:(CGFloat)height Color:(CGColorRef)color {
    
    UIColor *uic = [UIColor colorWithCGColor:color];
    
    CGFloat red;
    
    CGFloat green;
    
    CGFloat blue;
    
    CGFloat alpha;
    
    // UIColor 型の color から RGBA の値を取得します。
    
    [uic getRed:&red green:&green blue:&blue alpha:&alpha];
    CGFloat color_array[4] = {red, green, blue, 0.2};
    
    CGContextSetFillColor(c, color_array);
    CGContextFillRect(c, CGRectMake(origin.x - width, origin.y, width, height));
}

-(void)drawstring:(CGContextRef)context and_str:(NSString *)str and_pos:(CGPoint )pos and_Fondsize:(CGFloat)size and_cgcolor:(CGColorRef)color
{
   // UIFont *font = [UIFont fontWithName:@"Verdana-Bold"size:size];
    //UIColor *color = [UIColor whiteColor];
    
    //[str drawAtPoint:pos withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    UIColor *uic = [UIColor colorWithCGColor:color];
    
    CGFloat red;
    
    CGFloat green;
    
    CGFloat blue;
    
    CGFloat alpha;
    
    // UIColor 型の color から RGBA の値を取得します。
    
    [uic getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    
    CGContextSelectFont(context, "Helvetica", size, kCGEncodingMacRoman);
    
    char* text = [str UTF8String];
    int textlen = strlen(text);
    CGContextShowTextAtPoint(context, pos.x - (size*textlen)/2, pos.y - size, text, strlen(text));
    CGContextSetTextDrawingMode (context, kCGTextFillStroke);
    //free(text);
}

#pragma mark -
#pragma mark public method

-(void)add_NewsMessageView:(NSMutableArray *)NewsItems
{
    if (![[NewsItems firstObject] isKindOfClass:[Item class]] ) {
        return;
    }
    
    for (id one in self.subviews) {
        if ([one isKindOfClass:[NewsMessageView class]]) {
            [one removeFromSuperview];
        }
    }
    
    Max_news_count = [NewsItems count];
    
    NSArray *sort_items;
    NSSortDescriptor *SortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nsdate_date" ascending:YES];
    sort_items = [NewsItems sortedArrayUsingDescriptors:@[SortDescriptor]];
    
    Item *first_day_news, *last_day_news;
    last_day_news  = [sort_items lastObject];
    first_day_news = [sort_items firstObject];
    
    NSDate *first_day, *last_day;
    
    first_day = first_day_news.nsdate_date;
    last_day  = last_day_news.nsdate_date;
    
    NSUInteger flags;
    NSDateComponents *first_comps, *last_comps;
    NSInteger min_day, max_day;
    
    flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    first_comps = [calendar components:flags fromDate:first_day];
    
    min_day = first_comps.day;
    
    NSDate *min_ns_day, *max_ns_day;
    
    min_ns_day = [self get_minmax_day:first_day];
    max_ns_day = [last_day initWithTimeInterval:7*24*60*60 sinceDate:min_ns_day];
    
    last_comps = [calendar components:NSDayCalendarUnit fromDate:max_ns_day];
    
    max_day = last_comps.day;
    NSTimeInterval since = [max_ns_day timeIntervalSinceDate:min_ns_day];
    
    daynum = ceil(since/(24*60*60));

    
    Cal_End_Day = max_ns_day;
    Cal_Start_Day = min_ns_day;
    
    NSTimeInterval day_length;
    day_length = [max_ns_day timeIntervalSinceDate:min_ns_day];
    
    CGFloat news_pos_y = kStartPosNews;
   
    int count = 0;
    int row_count = 0;
    for (Item *one_news in sort_items) {
        
        if (Skip_news_day > count) {
            count++;
            continue;
        }
        
        if (row_count > kMaxRow) {
            break;
        }
        
        if(news_pos_y + kNewsHeight > self.bounds.size.height) break;
        NSTimeInterval since;
        
        // dateAとdateBの時間の間隔を取得(dateA - dateBなイメージ)
        since = [one_news.nsdate_date timeIntervalSinceDate:min_ns_day];
        
        CGFloat hiritu = since / day_length;
        CGFloat w = self.bounds.size.width;
        CGFloat pos_x = self.bounds.origin.x + w * hiritu;
        [self add_one_newsview:pos_x and_posy:news_pos_y and_newsitem:one_news];
        news_pos_y += kNewsHeight + 2;
        count++;
        row_count++;
    }
    
    [self setNeedsDisplay];
    
}

-(void)rotate_News
{
    Skip_news_day+= kMaxRow;
    if (Skip_news_day + kMaxRow > Max_news_count) {
        Skip_news_day = 0;
    }
}

#pragma mark -
#pragma mark add_NewsMessageView local method

-(CGFloat)get_daywidth
{
    CGFloat w = self.bounds.size.width;

    if (daynum==0) {
        return w/kNumDay;
    }
    else {
        return w/daynum;
    }
}

-(NSInteger)get_weekend:(NSDate *)day
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:day];
    NSInteger weekday = [weekdayComponents weekday];
    
    Week cur_week = weekday;
    if (cur_week == Sunday) {
        return Sunday;
    }
    else if (cur_week == Saturday) {
        return Saturday;
    }

    return 0;
}

-(NSDate *)get_minmax_day:(NSDate *)org_day
{
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    comps = [calendar components:flags fromDate:org_day];
    
    NSString *str_day  = [self ceil_day:comps.day];
    NSString *str_mon  = [self ceil_day:comps.month];
    NSString *str_year = [self ceil_day:comps.year];
    
    NSString *str_ns_day = [NSString stringWithFormat:@"%@ %@ %@ 00:00:00",str_year,str_mon, str_day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // フォーマットを文字列で指定
    [dateFormatter setDateFormat:@"yyyy MM dd HH:mm:ss"];
    return [dateFormatter dateFromString:str_ns_day];
}

-(NSString *)get_calday_string:(NSDate *)org_day
{
    NSUInteger flags;
    NSDateComponents *comps;
    
    flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    comps = [calendar components:flags fromDate:org_day];
    
    NSString *str_day  = [self ceil_day:comps.day];
    NSString *str_mon  = [self ceil_day:comps.month];
    
    NSString *str_ns_day = [NSString stringWithFormat:@"%@/%@",str_mon, str_day];
    
    return str_ns_day;
}

-(NSDate *)get_incr_day:(NSDate *)day
{
    return [day initWithTimeInterval:1*24*60*60 sinceDate:day];
}


-(NSString *)ceil_day:(NSInteger)day
{
    if (day < 10) {
        return  [NSString stringWithFormat:@"0%d",day];
    }
    else {
        return [NSString stringWithFormat:@"%d",day];
    }
}

-(void)add_one_newsview:(CGFloat )pos_x and_posy:(CGFloat )pos_y and_newsitem:(Item *)item
{
    CGRect size = CGRectMake(pos_x, pos_y, kNewsWidth, kNewsHeight);
    NewsMessageView *msgview = [[NewsMessageView alloc] initWithFrame:size];
    [msgview setText:item.title];
    [msgview setLink_url:item.hpaddress];
    
    [self addSubview:msgview];
}


@end
