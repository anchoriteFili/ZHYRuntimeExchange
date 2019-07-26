//
//  NSURL+ChineseJudge.m
//  RuntimeExchange
//
//  Created by 赵宏亚 on 2019/7/26.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import "NSURL+ChineseJudge.h"
#import <objc/runtime.h>
#import "NSString+ZHString.h"

@implementation NSURL (ChineseJudge)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ // 进行方法替换。
        
        Method method = class_getClassMethod(self, @selector(URLWithString:));
        Method newMethod = class_getClassMethod(self, @selector(zh_URLWithString:));
        method_exchangeImplementations(method, newMethod);
    });
    
}

+ (instancetype)zh_URLWithString:(NSString *)URLString {
    
    NSURL *url = [NSURL zh_URLWithString:URLString];
    
    // 判断是否包含中文
    if ([URLString zhIsIncludeChinese]) {
        
        // 包含中文，进行转码
        NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *encodeUrl = [URLString stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
        url = [NSURL zh_URLWithString:encodeUrl];
    }
    
    NSLog(@"url ****** %@",url);
    
    return url;
}







@end
