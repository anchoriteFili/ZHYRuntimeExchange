//
//  UIViewController+VCAppearExchange.m
//  RuntimeExchange
//
//  Created by 赵宏亚 on 2019/7/23.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import "UIViewController+VCAppearExchange.h"
#import <objc/runtime.h>

@implementation UIViewController (VCAppearExchange)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        exchangeMethod(class, @selector(viewWillAppear:), @selector(zh_viewWillAppear:));
        exchangeMethod(class, @selector(viewWillDisappear:), @selector(zh_viewWillDisappear:));
    });
}

// 方法替换
void exchangeMethod(Class class, SEL method, SEL newMethod) {
    
    Method method1 = class_getInstanceMethod(class, method);
    Method method2 = class_getInstanceMethod(class, newMethod);
    method_exchangeImplementations(method1, method2);
}

- (void)zh_viewWillAppear:(BOOL)animated {
    // 此处已经与系统方法调换，其实调用的是系统方法
    [self zh_viewWillAppear:animated];
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    NSLog(@"%@ -- 页面显示",className);
    // 此处进行埋点
}

- (void)zh_viewWillDisappear:(BOOL)animated {
    // 此处已经与系统方法调换，其实调用的是系统方法
    [self zh_viewWillDisappear:animated];
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    NSLog(@"%@ -- 页面消失",className);
    // 此处进行埋点
}


@end
