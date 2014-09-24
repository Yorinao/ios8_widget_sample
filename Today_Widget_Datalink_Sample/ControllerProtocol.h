//
//  ControllerProtocol.h
//  CustomURLSchemeSample
//
//  Created by Naoto Horiguchi on 2013/12/09.
//  Copyright (c) 2013年 Naoto Horiguchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ControllerProtocol <NSObject>

- (BOOL)action:(NSString *)action query:(NSDictionary *)query;

@end
