//
//  XMViewController.m
//  XMGesturePassword
//
//  Created by lxumeng on 02/22/2024.
//  Copyright (c) 2024 lxumeng. All rights reserved.
//

#import "XMViewController.h"
@import XMGesturePassword;

@interface XMViewController ()<XMGesturePasswordViewDelegate>

@property (nonatomic, strong) XMGesturePasswordView *passwordView;

@end

@implementation XMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.passwordView];
}

/// MARK: - XMGesturePasswordViewDelegate
/// 仅提供手势密码输出，存取逻辑需自己实现
- (void)xmGestureResultPassword:(NSString *)password {
//    if ("设置密码") {
//        NSLog(@"保存密码:%@",password);
//    }
//    if ("正在验证" && "与之前保存结果相同") {
//        NSLog(@"通过验证");
//    }
    if ("正在验证" && "验证错误") {
        [self.passwordView showError];
    }
}

/// MARK: - Getter

- (XMGesturePasswordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[XMGesturePasswordView alloc] initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 60, self.view.frame.size.width - 60)];
        _passwordView.delegate = self;
    }
    return _passwordView;
}


@end
