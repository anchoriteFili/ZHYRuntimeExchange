//
//  UITextField+UITextField_Delete.m
//  RuntimeExchange
//
//  Created by 赵宏亚 on 2019/7/23.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import "UITextField+UITextField_Delete.h"
#import <objc/runtime.h>

@implementation UITextField (UITextField_Delete)

+ (void)load {
    static dispatch_once_t onceToken; 
    dispatch_once(&onceToken, ^{
        // 替换系统方法
        Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
        Method method2 = class_getInstanceMethod([self class], @selector(zh_deleteBackward));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)zh_deleteBackward {
    // 此处已经与系统方法调换，其实调用的是系统方法
    [self zh_deleteBackward];
    // 调取代理方法
    if ([self.delegate respondsToSelector:@selector(zh_textFieldDidDeleteBackward:)]) {
        id <ZHTextFieldDelegate>delegate = (id<ZHTextFieldDelegate>)self.delegate;
        [delegate zh_textFieldDidDeleteBackward:self];
    }
}

@end
