//
//  SportMainController.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/2.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "SportMainController.h"
#define  pingmukuang  [[UIScreen mainScreen] bounds].size.width;
#define  pingmugao  ([[UIScreen mainScreen] bounds].size.height-60)/3;
@interface SportMainController ()

@end

@implementation SportMainController

- (void)viewDidLoad {
    [self beginMusicOberser];
    
    _select_Name.selectedSegmentIndex=1;

    _SportDataSourse=[[NSMutableArray alloc]init];
    [_SportDataSourse addObject: @{@"name":@"电量:",@"value":@"40",@"count_name":@"%"}];
    [_SportDataSourse addObject: @{@"name":@"平均速度",@"value":@"40",@"count_name":@"km"}];


    [super viewDidLoad];
    _QGSportCenter = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    _QGSportCenter.delegate =self;
//      UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 1)];
//    [footerView setBackgroundColor:[UIColor blackColor]];
//    
//    [_SportTableview setTableFooterView:footerView];

    // Do any additional setup after loading the view.
}
#pragma mark-BluetoothPeripheral
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(NA, 6_0){
    //名字改变
    NSLog(@"%@",peripheral.services);
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    //发现服务
    for (CBService *servise in peripheral.services) {
        NSLog(@"%@和%@",servise.UUID.UUIDString,servise.characteristics);
            [_QGSportPeripherar discoverCharacteristics:nil forService:servise];
        

    }
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    //订阅或者读相应的特征
    for (CBCharacteristic *characterist in service.characteristics) {
        
        NSLog(@"charcterist%@",characterist);
        if([characterist.UUID.UUIDString isEqualToString:@"2A37"]||[characterist.UUID.UUIDString isEqualToString:@"2A19"]||[characterist.UUID.UUIDString isEqualToString:@"2A53"]){
                    NSLog(@"读取了心率");
            //        [peripheral readValueForCharacteristic:c];//读取服务特征值
            [peripheral setNotifyValue:YES forCharacteristic:characterist];
            
   
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if ([characteristic.UUID.UUIDString isEqualToString:@"2A37"]) {
        if ([_SportItem1Name.text isEqualToString:@"心率"]) {
            int  k=[self convertDataToHexIntForHeartRate:characteristic.value];
            if (_select_Name.selectedSegmentIndex==0&&k==0) {
                countLeaveEar++;
                if (countLeaveEar>=20) {
                    countLeaveEar=0;
                    [_musicPlay pause];
                }
            
           
            }else if(_select_Name.selectedSegmentIndex==0&&k!=0){
                
                [self playmusic];
                [self restartSonglistToQueue];
             
            }
                if(_select_Name.selectedSegmentIndex==0&&k<60&&k>0){
                countSleep++;
                if (countSleep>30&&countNosport>30) {
                    [_musicPlay stop];

                }
                
            }
        
                
            _SportiTem1Value.text=[NSString stringWithFormat:@"%d",k];
            
        }
    }
    else if ([characteristic.UUID.UUIDString isEqualToString:@"2A19"]){
            int  k=[self convertDataToHexIntForBarttery:characteristic.value];
            
            _battaryvalue.text=[NSString stringWithFormat:@"%d％",k];
            
        
    }
    else if ([characteristic.UUID.UUIDString isEqualToString:@"2A53"]){
        double  k=[self convertDataToHexIntForSpeed:characteristic.value];
        
        _SportiTem2Value.text=[NSString stringWithFormat:@"%.2f",k];
        if (k==0) {
            countNosport++;
        }
        else{
            countNosport=0;
        }
        
        
    }

    
//    [_SportDataSourse addObject: @{@"name":@"心率",@"value":@"40",@"count_name":@"BMP"}];

    //读值或者订阅值
}
#pragma mark-BluetoothCenterManager
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    //关闭蓝牙的时候保存的数据
    NSLog(@"断开连接");
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
        if([peripheral.name isEqual:@"Jabra PULSE Smart"]){
            _QGSportPeripherar=peripheral;
            [_QGSportCenter stopScan];
        }
 
        
        NSLog(@"%@,信号强度:%@\n,广播消息:%@\n",peripheral,RSSI,advertisementData);
    
    
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接成功: %@", peripheral);
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    

}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"连接失败");
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"没有该服务");
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    [_QGSportCenter scanForPeripheralsWithServices:nil options:nil];
    
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
#pragma mark-NSDataTO16String

- (int )convertDataToHexIntForHeartRate:(NSData *)data {
    
    __block int result=0;
 
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        if (dataBytes[0]==0x04) {
           
        }else if(dataBytes[0]==0x06){
                result=dataBytes[1];
       
        }
        
    }];
    
    return result;
}
- (int )convertDataToHexIntForBarttery:(NSData *)data {
    __block int result=0;
    
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
       
            

            result=dataBytes[0];
            
        
        
    }];
    
    return result;
}
- (double )convertDataToHexIntForSpeed:(NSData *)data {
    __block double result=0;
    __block double x=0;
    __block double y=0;
    __block double z=0;
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        
        unsigned char *dataBytes = (unsigned char*)bytes;
        
        x=pow(dataBytes[1],2);
        y=pow(dataBytes[2],2);
        z=pow(dataBytes[3],2);
        result=pow(x+y+z, 0.5);
        
        
        
    }];
    
    return result;
}

- (IBAction)QGBeginScanf:(id)sender {
    if(_QGSportPeripherar!=nil){
    [_QGSportCenter connectPeripheral:_QGSportPeripherar options:nil];
        NSLog(@"连接中");
        _status.text=@"进行中";

    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"打开蓝牙才能搜索" message:@"请确定设备已经开启" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新搜索" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){NSLog(@"取消");
            [_QGSportCenter scanForPeripheralsWithServices:nil options:nil];}
                                       ];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){NSLog(@"确定");}];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}
#pragma mark- viewSetting
- (IBAction)QGStopScanf:(id)sender {
    [self playmusic];
    [self restartSonglistToQueue];

  
    
    [_musicPlay beginGeneratingPlaybackNotifications];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (IBAction)select:(id)sender {
    if (_select_Name.selectedSegmentIndex==0) {
        NSLog(@"选择确定");
    }
    else{
        NSLog(@"选择否定");

    }
    
}
#pragma -mark MUSIC
-(void)beginMusicOberser{
    dispatch_async(dispatch_get_main_queue(), ^{
        _musicPlay = [MPMusicPlayerController systemMusicPlayer];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter  removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:_musicPlay];
          [notificationCenter  removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:_musicPlay];
        [notificationCenter addObserver:self selector:@selector(handle_NowPlayingItemChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:_musicPlay];
        //     [notificationCenter addObserver:self selector:@selector(handle_VolumeDidChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:musicPlayer];
        
        [notificationCenter addObserver:self selector:@selector(handle_StateDidChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:_musicPlay];
        
        [_musicPlay beginGeneratingPlaybackNotifications];
        
    });
}
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    NSLog(@"Media Picker was cancelled");
    
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(void)handle_StateDidChange:(NSNotification *)notification {
    MPMusicPlayerController * musicPlayer = [notification object];
    _song_name.text=musicPlayer.nowPlayingItem.title;
    NSLog(@"消息进来了%@",musicPlayer.nowPlayingItem.title);
}
//-(void)handle_VolumeDidChanged:(NSNotification *)notification {
//    MPMusicPlayerController * musicPlayer = [notification object];
//    NSLog(@"消息进来了");
//    _info1.text=musicPlayer.nowPlayingItem.title;
//}
-(void)handle_NowPlayingItemChanged:(NSNotification *)notification {
    MPMusicPlayerController * musicPlayer = [notification object];
    _song_name.text=musicPlayer.nowPlayingItem.title;

    NSLog(@"消息进来了%@",musicPlayer.nowPlayingItem.title);
}
//- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
//{
//    
//    
//    //MPMusicPlayerController类可以播放音乐库中的音乐
//    //MPMusicPlayerController提供两种播放器类型，一种是applicationMusicPlayer，一种是iPodMusicPlayer，这里用iPodMusicPlayer。前者在应用退出后音乐播放会自动停止，后者在应用停止后不会退出播放状态。
//    MPMusicPlayerController *musicPC = [[MPMusicPlayerController alloc]init];
//    
//    //MPMusicPlayerController加载音乐不同于前面的AVAudioPlayer,AVAudioPlayer是通过一个文件路径来加载,而MPMusicPlayerController需要一个播放队列,正是由于它的播放音频来源是一个队列，因此MPMusicPlayerController支持上一曲、下一曲等操作。
//    [musicPC setQueueWithItemCollection:mediaItemCollection];
//    [musicPC play];
//    
//    
//    
//}
//
-(void)restartSonglistToQueue{//重新将歌单添加到队列
    
    if (_musicPlay.nowPlayingItem!=nil) {
        [_musicPlay play];
        
    }
    else{
        if (_songList!=nil) {
            [_musicPlay setQueueWithItemCollection:_songList];
            
            [_musicPlay play];
        }
        
    }
}
-(void)playmusic{//添加全部歌曲
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
//    MPMediaPropertyPredicate *predicate=[MPMediaPropertyPredicate predicateWithValue:@"少儿歌曲" forProperty:MPMediaItemPropertyArtist];
//    
//    [everything addFilterPredicate:predicate];
//    
    //    NSArray *itemsFromArtistQuery = [everything items];
    //    NSLog(@"%@",itemsFromArtistQuery);
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    
    int i=0;
    NSMutableArray<MPMediaItem *> * items=[[NSMutableArray<MPMediaItem *> alloc]init];
    for (MPMediaItem *song in itemsFromGenericQuery) {
        if (i>=1) {
            [items addObject:song];
        }
        
        
        
        i++;
        _songList= [MPMediaItemCollection collectionWithItems:items];
    }
}
- (IBAction)lastSong:(id)sender {
    if(_musicPlay .nowPlayingItem==0){
        NSLog(@"这是第一首歌");
    }
    else{
        [_musicPlay skipToPreviousItem];}
}
- (IBAction)nextsong:(id)sender {
    [_musicPlay skipToNextItem];
}
@end
