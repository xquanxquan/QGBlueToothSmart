//
//  ViewController.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/7/27.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
@interface ViewController ()

@end

@implementation ViewController
typedef int(^blk_t)(int);//返回值位int 名字为blk_t 参数是int
-(void)passValue:(NSString *)value{
         NSLog(@"使用协议传值");
    _info_txt.text=value;
}

- (void)viewDidLoad {
//    _quan=@"sa";
//    __block int t=10;
//    blk_t k=^(int k){
//        t=1;
//        return t;
//    };
//    int a=k(2);
//    NSLog(@"%d",a);

    [super viewDidLoad];
    

}
-(void)ntiPassValue:(NSNotification *)nti{
    NSLog(@"值传进来了:%@",nti.object);
    _info_txt.text=nti.object;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn1:(id)sender {
    __weak typeof(self) weakself=self;//
    ViewController1 *vic=[self.storyboard instantiateViewControllerWithIdentifier:@"vic"];
    //初始化界面 第二个ui界面
    [vic setBk:^(UILabel *_a){
            _a.text=_info_txt.text;//如果反向传值 注释这句话
//            _info_txt.text=_a.text;//如果正向传值 注释这句话
    }];

  
    [weakself presentViewController:vic animated:YES completion:^{}];
    //好处 传值不止一个参数 可以多个object同时传 正反传都可以
}
- (IBAction)proPassValue:(id)sender {
    ViewController1 *vic=[self.storyboard instantiateViewControllerWithIdentifier:@"vic"];
    
    vic.delegate=self;
    [self presentViewController:vic animated:YES completion:^{}];
    //正反都可以但要设置不同的属性
}

- (IBAction)onePassValue:(id)sender {
}

- (IBAction)propertyPassValue:(id)sender {
    ViewController1 *vic=[self.storyboard instantiateViewControllerWithIdentifier:@"vic"];

      [vic setValue1:_info_txt.text];
    [self presentViewController:vic animated:YES completion:^{}];
//只能反向传值

}
- (IBAction)notificationPassValue:(id)sender {
    ViewController1 *vic=[self.storyboard instantiateViewControllerWithIdentifier:@"vic"];
    vic->blockPass=4;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"passValueToView" object:nil];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ntiPassValue:) name:@"passValueToView" object:nil];
[self presentViewController:vic animated:YES completion:^{}];
    //所有地方都可以给中心传值 但中心要先开启
}
@end
