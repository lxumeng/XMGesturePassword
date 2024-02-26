//
//  XMViewController.m
//  XMGesturePassword
//
//  Created by lxumeng on 02/22/2024.
//  Copyright (c) 2024 lxumeng. All rights reserved.
//

#import "XMViewController.h"
@import XMGesturePassword;

@interface XMViewController ()

@end

@implementation XMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    XMGesturePasswordView *passwordView = [[XMGesturePasswordView alloc] initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 60, self.view.frame.size.width - 60)];
    __weak typeof(passwordView) pa = passwordView;
    [passwordView addPasswordBlock:^(NSString *password) {
        __strong typeof(pa) p = pa;
        [p showError];
    }];
    [self.view addSubview:passwordView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
