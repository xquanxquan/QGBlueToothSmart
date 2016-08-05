//
//  ViewController1.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/7/28.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "ViewController1.h"

@interface ViewController1 ()

@end

@implementation ViewController1


- (void)viewDidLoad {
    if(_value1!=nil){
    NSLog(@"使用属性传值");
        _a.text=self.value1;
        blockPass=1;

    
    }else if(_delegate!=nil){
         blockPass=2;
    
    }
    else if(_bk!=nil){
        //设置返回
        blockPass=3;
        self.bk(_a);
             NSLog(@"使用block传值");
    }else{
        
    }
//    _a.text=self.value1;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)bck1:(id)sender {
   
    if (blockPass==3) {
        _a.text=@"block传值返回";
        
        _bk(_a);
        
    }else if(blockPass==2){
        [_delegate passValue:@"使用协议传值"];
   
    }else{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"passValueToView" object:@"通过消息机制传值"
     ];}
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
