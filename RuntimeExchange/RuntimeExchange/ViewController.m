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
        
        NSMutableString *str = [NSMutableString stringWithString:textField.text];
        UILabel *label = [self.view viewWithTag:10000+textField.text.length];
        label.text = [str substringWithRange:NSMakeRange(textField.text.length-1, 1)];
        
    } else if (textField.text.length == 0) {
        self.label1.text = @"";
    } else {
        
        NSLog(@"个数超过了4个");
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 4)];
        return;
    }
    
}


@end
