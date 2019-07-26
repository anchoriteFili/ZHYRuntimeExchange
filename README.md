![](https://github.com/anchoriteFili/ZHYRuntimeExchange/blob/master/RuntimeExchange.gif)


#### 示例1：替换键盘删除按钮触发方法

```objc
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
```

```objc
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
    [self zh_deleteBackward];
    // 调取代理方法
    if ([self.delegate respondsToSelector:@selector(zh_textFieldDidDeleteBackward:)]) {
        id <ZHTextFieldDelegate>delegate = (id<ZHTextFieldDelegate>)self.delegate;
        [delegate zh_textFieldDidDeleteBackward:self];
    }
}

@end
```

#### 简单使用(验证码输入)

```objc
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
```

#### 示例2：页面显示时进行埋点

```objc
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
    [self zh_viewWillAppear:animated];
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    NSLog(@"%@ -- 页面显示",className);
    // 此处进行埋点
}

- (void)zh_viewWillDisappear:(BOOL)animated {
    [self zh_viewWillDisappear:animated];
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    NSLog(@"%@ -- 页面消失",className);
    // 此处进行埋点
}


@end
```
#### 示例3：替换`URLWithString`方法检测链接是否包含中文

```objc
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
```

```objc
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
```
