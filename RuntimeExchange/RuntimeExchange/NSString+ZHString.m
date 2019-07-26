//
//  NSString+ZHString.m
//  RuntimeExchange
//
//  Created by 赵宏亚 on 2019/7/26.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import "NSString+ZHString.h"

@implementation NSString (ZHString)

// 字符串是否包含中文判断
- (BOOL)zhIsIncludeChinese {
    for(int i=0; i< [self length];i++) {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end
