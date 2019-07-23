//
//  ViewController.m
//  RuntimeExchange
//
//  Created by 赵宏亚 on 2019/7/23.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+UITextField_Delete.h"

@interface ViewController ()<ZHTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.textField.delegate = self;
    [self.textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
}

/**
 键盘删除键点击方法，里边只做减处理
 
 @param textField textField
 */
- (void)zh_textFieldDidDeleteBackward:(UITextField *)textField {
//    self.label1.text = textField.text;
    
    NSMutableString *str = [NSMutableString stringWithString:textField.text];
    
    NSLog(@"length == %lu",(unsigned long)str.length);
    
    // 根据字符串长度对不会空label的后一位的label赋值为空
    if (textField.text.length <= 3) {
        UILabel *label = [self.view viewWithTag:10001+textField.text.length];
        label.text = @"";
    }
}


/**
 textField内容变化时调用代理，只做增处理

 @param textField textField
 */
- (void)valueChanged:(UITextField *)textField {
    
    if (textField.text.length <= 4 && textField.text.length != 0) {
        // 只给最后一个不为空的label赋值
        NSMutableString *str = [NSMutableString stringWithString:textField.text];
        UILabel *label = [self.view viewWithTag:10000+textField.text.length];
        label.text = [str substringWithRange:NSMakeRange(textField.text.length-1, 1)];
        
    } else if (textField.text.length == 0) { // 字数等于0时清空第一个label
        self.label1.text = @"";
    } else { // 字数大于4时进行提示
        
        [self showAlertLabel];
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 4)];
        return;
    }
    
}

- (void)showAlertLabel { // 简易的提示label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.backgroundColor = UIColor.blackColor;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 25;
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
    label.text = @"最多只能输入4个数字";
    label.textColor = UIColor.whiteColor;
    [self.view addSubview:label];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程
            [label removeFromSuperview];
        });
    });
}


@end
