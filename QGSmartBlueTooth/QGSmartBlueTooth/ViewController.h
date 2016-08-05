//
//  ViewController.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/7/27.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController1.h"
@interface ViewController : UIViewController<proPassValue>

{

    NSString * _quan;
}
//@property(nonatomic,strong)CLLocationManager *locMgr;
- (IBAction)btn1:(id)sender;//block传值
@property (strong, nonatomic) IBOutlet UIButton *btn_name;
@property (strong, nonatomic) IBOutlet UITextField *info_txt;
- (IBAction)proPassValue:(id)sender;//协议传值
- (IBAction)onePassValue:(id)sender;//单例传值
- (IBAction)propertyPassValue:(id)sender;//属性传值

- (IBAction)notificationPassValue:(id)sender;//消息机制传值


@property (copy,nonatomic)NSString*quan;
@end

