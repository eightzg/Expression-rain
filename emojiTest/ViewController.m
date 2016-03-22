//
//  ViewController.m
//  emojiTest
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 eight. All rights reserved.
//


#define HKWidth [UIScreen mainScreen].bounds.size.width
#define HKHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "GifView.h"
#import "UIView+Extension.h"

@interface ViewController () <UITextFieldDelegate>
//父视图
@property (nonatomic, strong) UIView *contentView;
//按钮
@property (nonatomic, strong) UIButton *button;
//文本框
@property (nonatomic, strong) UITextField *textField;
//定时器对象
@property (nonatomic, strong) NSTimer *timer;
//和文字对应的数字
@property (nonatomic, assign) int number;
//键盘高度
@property (nonatomic, assign) float kbHeight;

@end

@implementation ViewController

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, (HKHeight - 50), HKWidth, 50)];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (UITextField *)textField
{
    if (!_textField) {
        self.textField = [[UITextField alloc] init];
        [self.contentView addSubview:_textField];
        _textField.frame = CGRectMake(30, 10, HKWidth - 110, 30);
        _textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _textField;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] init];
        [self.contentView addSubview:_button];
        _button.frame = CGRectMake(HKWidth - 65, 10, 55, 30);
        [_button setTitle:@"发送" forState:UIControlStateNormal];
    }
    return _button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景灰色
    self.contentView.backgroundColor = [UIColor colorWithRed:236/255.f green:236/255.f blue:236/255.f alpha:0.9];
    //按钮绿色
    self.button.backgroundColor = [UIColor colorWithRed:148/255.f green:199/255.f blue:107/255.f alpha:0.9];
    [self.button addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    //设置代理
    self.textField.delegate = self;
    //监听键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    //监听键盘退出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}



//开始动画
- (void)startTimer{
    //动画对应的数字不存在时候返回
    if (self.number == 0) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(randomAnimateWithDelay) userInfo:nil repeats:YES];
    [self performSelector:@selector(fireTimer) withObject:nil afterDelay:5];
    
}

//停止动画
- (void)fireTimer {
    [self.timer invalidate];
}

//延时随机动画
- (void)randomAnimateWithDelay {
    double time = arc4random() % 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self randomAnimateGif];
    });
}

//随机动画
- (void)randomAnimate {
    UIImage *image1 = [UIImage imageNamed:@"shy.gif"];
    
    int i = HKWidth;
    /*
     *起始位置x1,终点位置x2
     */
    double x1 = arc4random() % i;
    double x2 = arc4random() % (i / 2);
    if (x1 > HKWidth / 2) {
        x2 = -x2;
    }
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(x1, -HKHeight, 24, 24)];
    if (x1 < 30 || x1 > (HKWidth - 30)) {
        imageView1.frame = CGRectMake(x1, -HKHeight, 48, 48);
    }else if (x1 > 100 && x1 < 110) {
        imageView1.frame = CGRectMake(x1, -HKHeight, 96, 96);
    }
    imageView1.image = image1;
    [UIView animateWithDuration:4 animations:^{
        imageView1.transform = CGAffineTransformMakeTranslation(x2,2 * HKHeight);
    }];
    [self.view addSubview:imageView1];
}

//随机动画（gif）
- (void)randomAnimateGif {
    int i = HKWidth;
    /*
     *起始位置x1,终点位置x2
     */
    double x1 = arc4random() % i;
    double x2 = arc4random() % (i / 2);
    if (x1 > HKWidth / 2) {
        x2 = -x2;
    }
    NSString *nameStr = [NSString stringWithFormat:@"expression%d",self.number];
    NSString *path = [[NSBundle mainBundle] pathForResource:nameStr ofType:@"gif"];
    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake(x1, -50, 24, 24) filePath:path];
    if (x1 < 30 || x1 > (HKWidth - 30)) {
        gifView.frame = CGRectMake(x1, -HKHeight, 48, 48);
    }else if (x1 > 100 && x1 < 110) {
        gifView.frame = CGRectMake(x1, -HKHeight, 96, 96);
    }

    [UIView animateWithDuration:4 animations:^{
        gifView.transform = CGAffineTransformMakeTranslation(x2,2 * HKHeight);
    }];
    [self.view addSubview:gifView];
}

//按钮点击
- (void)btnClicked {
    //再次点击按钮取消动画，动画文字对应的数字重置
    [self.timer invalidate];
    self.number = 0;
    
    NSString *text = self.textField.text;
    if ([text isEqualToString:@"羞羞哒"]) {
        self.number = 6;
    }
    if ([text isEqualToString:@"色眯眯"]) {
        self.number = 3;
    }
    if ([text isEqualToString:@"么么哒"]) {
        self.number = 75;
    }
    if ([text isEqualToString:@"开心"]) {
        self.number = 13;
    }
    if ([text isEqualToString:@"偷笑"]) {
        self.number = 19;
    }
    if ([text isEqualToString:@"傻笑"]) {
        self.number = 27;
    }
    if ([text isEqualToString:@"好衰"]) {
        self.number = 33;
    }
    if ([text isEqualToString:@"好棒"]) {
        self.number = 65;
    }
    if ([self.textField.text isEqualToString:@""]) {
        return;
    }else {
        [self startTimer];
    }
    [self.textField resignFirstResponder];
}

//点击撤回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}

//通知监听方法
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;

    NSLog(@">>>>>>>>>>>%f",yOffset);
    self.contentView.y += yOffset;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    self.contentView.y += yOffset;
}
@end
