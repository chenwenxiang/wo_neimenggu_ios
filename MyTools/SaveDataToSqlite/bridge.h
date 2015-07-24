//
//  bridge.h
//  SwiftInAction-006-002
//
//  Created by zhihua on 14-7-8.
//  Copyright (c) 2014年 ucai. All rights reserved.
//

#import "sqlite3.h"

#import <UIKit/UIKit.h>

@interface Bridge : NSObject

+(NSString *)esc:(NSString *)str;

@end
