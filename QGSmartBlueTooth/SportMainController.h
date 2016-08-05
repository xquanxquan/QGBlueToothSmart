//
//  SportMainController.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/2.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "ViewController.h"
#import<CoreBluetooth/CoreBluetooth.h>
#import <MediaPlayer/MediaPlayer.h>
@interface SportMainController : ViewController<CBCentralManagerDelegate,CBPeripheralDelegate,MPMediaPickerControllerDelegate>{
    int countLeaveEar;//统计失去心率次数 （1次/s）
    int countSleep;//连续统计心率低于60
    int countNosport;//计算连续加速度为0的次数
}
@property(nonatomic,strong)MPMusicPlayerController *musicPlay;//音乐控制
@property (nonatomic,strong)NSMutableArray * SportDataSourse;//数据源 没有用到
@property (nonatomic,strong)CBCentralManager * __block QGSportCenter;//蓝牙控制中心

- (IBAction)QGStopScanf:(id)sender;
- (IBAction)QGBeginScanf:(id)sender;
@property(strong,atomic) MPMediaItemCollection *songList;//歌曲名单
@property (strong, nonatomic) IBOutlet UILabel *SportiTem1Value;
@property (strong, nonatomic) IBOutlet UILabel *SportiTem1CountName;
@property (strong, nonatomic) IBOutlet UILabel *SportItem1Name;
- (IBAction)lastSong:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *SportiTem2Value;
- (IBAction)nextsong:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *SportiTem2CountName;
@property (strong, nonatomic) IBOutlet UILabel *SportItem2Name;
@property (strong, nonatomic) IBOutlet UILabel *batterName;
@property (strong, nonatomic) IBOutlet UILabel *battaryvalue;
- (IBAction)select:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *song_name;//歌曲名字

@property (strong, nonatomic) IBOutlet UISegmentedControl *select_Name;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property(nonatomic,strong)CBPeripheral*QGSportPeripherar;//广播者
/*******************************************bug*******************************/
//播放第一首歌的时候按上一首会让歌曲进程结束
//
//
//
@end
