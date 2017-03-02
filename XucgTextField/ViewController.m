//
//  ViewController.m
//  XucgTextField
//
//  Created by xucg on 2017/3/2.
//  Copyright © 2017年 xucg. All rights reserved.
//

#import "ViewController.h"
#import "XucgTextField.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet XucgTextField *textField1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textField1.maxLength = 6;
    _textField1.placeholder = @"长度限制6个字符";
    

    CGRect frame = CGRectZero;
    frame.origin.x = 16;
    frame.origin.y = 158;
    frame.size.height = 30;
    frame.size.width = self.view.frame.size.width - 32;
    XucgTextField *textField2 = [[XucgTextField alloc] initWithFrame:frame];
    textField2.placeholder = @"长度限制10个字符";
    textField2.backgroundColor = [UIColor greenColor];
    textField2.maxLength = 10;
    [self.view addSubview:textField2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
