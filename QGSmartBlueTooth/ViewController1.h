//
//  ViewController1.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/7/28.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^blk1_t)(UILabel *_a);
@protocol proPassValue <NSObject>

-(void)passValue:(NSString *)value;

@end
@interface ViewController1 : UIViewController{
   @public int blockPass;
}
@property (weak,nonatomic) id<proPassValue> delegate;
@property (strong, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) IBOutlet UILabel *a;
- (IBAction)bck1:(id)sender;
@property (strong,nonatomic)blk1_t bk;
@property (nonatomic,strong)NSString* value1;

@end
