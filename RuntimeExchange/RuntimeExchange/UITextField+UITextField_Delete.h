//
//  UITextField+UITextField_Delete.h
//  RuntimeExchange
//
//  Created by 赵宏亚 on 2019/7/23.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZHTextFieldDelegate <UITextFieldDelegate>

// 删除按钮点击时调用
- (void)zh_textFieldDidDeleteBackward:(UITextField *)textField;

@end

@interface UITextField (UITextField_Delete)

@property (nonatomic, weak) id<ZHTextFieldDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
