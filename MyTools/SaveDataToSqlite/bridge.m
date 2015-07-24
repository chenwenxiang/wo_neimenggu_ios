//
//  bridge.m
//  SwiftInAction-006-002
//
//  Created by zhihua on 14-7-9.
//  Copyright (c) 2014年 ucai. All rights reserved.
//

#import "bridge.h"

@implementation Bridge

+(NSString *)esc:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"''";
    }
    NSString *buf = @(sqlite3_mprintf("%q", [str cStringUsingEncoding:NSUTF8StringEncoding]));
    return buf;
}

@end
