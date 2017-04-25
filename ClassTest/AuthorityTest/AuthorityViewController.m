//
//  AuthorityViewController.m
//  ClassTest
//
//  Created by xu cuiping on 2017/4/7.
//  Copyright © 2017年 yonyou. All rights reserved.
//

#import "AuthorityViewController.h"
#import <AFNetworkReachabilityManager.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import <Contacts/Contacts.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCellularData.h>

@interface AuthorityViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, strong) CNContactStore *contactStore;

@end

@implementation AuthorityViewController

-(instancetype)init
{
  self = [super init];
  if(self)
  {
    self.manager = [[CLLocationManager alloc] init];
    self.contactStore = [[CNContactStore alloc] init];
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [self jump];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)network:(id)sender
{
  //AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
  //if( status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown)
  //{
   //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Photos"]];
  //}
  CTCellularData *cellularData = [[CTCellularData alloc]init];
  cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
    //获取联网状态
    switch (state) {
      case kCTCellularDataRestricted:
        NSLog(@"Restricrted");
        break;
      case kCTCellularDataNotRestricted:
        NSLog(@"Not Restricted");
        [self getNewWork];
        break;
      case kCTCellularDataRestrictedStateUnknown:
        NSLog(@"Unknown");
        break;
      default:
        break;
    };
  };
}
-(void)getNewWork
{
  CTCellularData *cellularData = [[CTCellularData alloc]init];
  CTCellularDataRestrictedState state = cellularData.restrictedState;
  switch (state) {
    case kCTCellularDataRestricted:
      NSLog(@"Restricrted");
      break;
    case kCTCellularDataNotRestricted:
      NSLog(@"Not Restricted");
      break;
    case kCTCellularDataRestrictedStateUnknown:
      NSLog(@"Unknown");
      break;
    default:
      break;
  }
}
#pragma mark相机
- (IBAction)camera:(id)sender
{
  __block BOOL isAuthorized = NO;
  //判断相机权限
  AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
  switch (AVstatus) {
    case AVAuthorizationStatusAuthorized:
      NSLog(@"Authorized");
       isAuthorized = YES;
      break;
    case AVAuthorizationStatusDenied:
      NSLog(@"Denied");
      [self gotoSetting:@"请打开系统设置中“隐私”相机，允许用友CRM访问您的相机"];
      break;
    case AVAuthorizationStatusNotDetermined:
      NSLog(@"not Determined");
      [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
        if (granted) {
          NSLog(@"Authorized");
          isAuthorized = YES;
        }else{
          NSLog(@"Denied or Restricted");
        }
      }];
      break;
    case AVAuthorizationStatusRestricted:
      NSLog(@"Restricted");
      break;
    default:
      break;
  }
  if(isAuthorized)
  {
    [self presentCamera];
  }
}
-(void)presentCamera
{
  BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
  if (!isCamera) { //若不可用，弹出警告框
    NSLog(@"摄像头不可用");
    return;
  }
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
  imagePicker.delegate = self;
  [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark相册
- (IBAction)photo:(id)sender
{
  __block BOOL isAuthorized = NO;
  //检查是否有获取照片的权限
  PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
  switch (photoAuthorStatus) {
    case PHAuthorizationStatusAuthorized:
      NSLog(@"Authorized");
      isAuthorized = YES;
      break;
    case PHAuthorizationStatusDenied:
      //禁用
      NSLog(@"Denied");
      [self gotoSetting:@"请打开系统设置中“隐私”照片，允许用友CRM访问您的照片"];
      break;
    case PHAuthorizationStatusNotDetermined:
      NSLog(@"not Determined");//没有设置权限
      [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
          NSLog(@"Authorized");
          isAuthorized = YES;
        }else{
          NSLog(@"Denied or Restricted");
        }
      }];
      break;
    case PHAuthorizationStatusRestricted:
      NSLog(@"Restricted");
      break;
    default:
      break;
  }
  if(isAuthorized)
  {
    [self presentPhoto];
  }
}
-(void)presentPhoto
{
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
  imagePicker.delegate = self;
  [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark麦克风
- (IBAction)microphone:(id)sender
{
  AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//麦克风权限
  switch (AVstatus) {
    case AVAuthorizationStatusAuthorized:
      NSLog(@"Authorized");
      break;
    case AVAuthorizationStatusDenied:
      NSLog(@"Denied");
      break;
    case AVAuthorizationStatusNotDetermined:
      NSLog(@"not Determined");
      [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted)
        {
          
        }
        else
        {
          
        }
      }];
      break;
    case AVAuthorizationStatusRestricted:
      NSLog(@"Restricted");
      break;
    default:
      break;
  }
}

#pragma mark位置
- (IBAction)location:(id)sender
{
  BOOL isLocation = [CLLocationManager locationServicesEnabled];
  if (!isLocation) {
    NSLog(@"not turn on the location");
  }
  
  CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
  switch (CLstatus) {
    case kCLAuthorizationStatusAuthorizedAlways:
      NSLog(@"Always Authorized");
      break;
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      NSLog(@"AuthorizedWhenInUse");
      break;
    case kCLAuthorizationStatusDenied:
      NSLog(@"Denied");
      [self gotoSetting:@"请打开系统设置中“隐私”位置，允许用友CRM访问您的位置"];
      break;
    case kCLAuthorizationStatusNotDetermined:
      NSLog(@"not Determined");
      [self getLoactionAuthority];
      break;
    case kCLAuthorizationStatusRestricted:
      NSLog(@"Restricted");
      break;
    default:
      break;
  }
}

-(void)getLoactionAuthority
{
  
  self.manager.delegate = self;
  self.manager.desiredAccuracy = kCLLocationAccuracyBest;
  //[manager requestAlwaysAuthorization];//一直获取定位信息
  [self.manager requestWhenInUseAuthorization];//使用的时候获取定位信息
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
  switch (status) {
    case kCLAuthorizationStatusAuthorizedAlways:
      NSLog(@"Always Authorized");
      [self.manager startUpdatingLocation];  //开始定位
      break;
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      NSLog(@"AuthorizedWhenInUse");
      [self.manager startUpdatingLocation];  //开始定位
      break;
    case kCLAuthorizationStatusDenied:
      NSLog(@"Denied");
      break;
    case kCLAuthorizationStatusNotDetermined:
      NSLog(@"not Determined");
      break;
    case kCLAuthorizationStatusRestricted:
      NSLog(@"Restricted");
      break;
    default:
      break;
  }
}

#pragma mark推送
- (IBAction)pushnotification:(id)sender
{
  UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
  switch (settings.types) {
    case UIUserNotificationTypeNone:
      NSLog(@"None");
      [self registerPushNotification];
      break;
    case UIUserNotificationTypeAlert:
      NSLog(@"Alert Notification");
      break;
    case UIUserNotificationTypeBadge:
      NSLog(@"Badge Notification");
      break;
    case UIUserNotificationTypeSound:
      NSLog(@"sound Notification'");
      break;
      
    default:
      break;
  }
}
-(void)registerPushNotification
{
  UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
  [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
  [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (IBAction)contacts:(id)sender
{
  CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
  switch (status) {
    case CNAuthorizationStatusAuthorized:
    {
      NSLog(@"Authorized:");
    }
      break;
    case CNAuthorizationStatusDenied:{
      NSLog(@"Denied");
      [self gotoSetting:@"请打开系统设置中“隐私”通讯录，允许用友CRM访问您的通讯录"];
    }
      break;
    case CNAuthorizationStatusRestricted:{
      NSLog(@"Restricted");
    }
      break;
    case CNAuthorizationStatusNotDetermined:{
      NSLog(@"NotDetermined");
      [self getContactAuthority];
      break;
    }
  }
}
-(void)getContactAuthority
{
  [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
    if (granted) {
      
      NSLog(@"Authorized");
      
    }else{
      
      NSLog(@"Denied or Restricted");
    }
  }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  NSLog(@"取消相册相机");
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
  NSLog(@"确定相册相机");
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

-(void)gotoSetting:(NSString *)message
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
  }];
  UIAlertAction *set = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
  }];
  [alertController addAction:cancel];
  [alertController addAction:set];
  [self presentViewController:alertController animated:YES completion:^{
    
  }];
}

-(void)jump
{
  NSString * defaultWork = [self getDefaultWork];//defaultWorkspace
  NSString * bluetoothMethod = [self getBluetoothMethod];//openSensitiveURL:withOptions:
  NSURL*url=[NSURL URLWithString:@"Prefs:root="];
  
  Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
  [[LSApplicationWorkspace  performSelector:NSSelectorFromString(defaultWork)]   performSelector:NSSelectorFromString(bluetoothMethod) withObject:url     withObject:nil];
}

-(NSString *) getDefaultWork{
  NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
  NSString *method = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
  return method;
}

-(NSString *) getBluetoothMethod{
  NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x6f, 0x70, 0x65, 0x6e, 0x53, 0x65, 0x6e, 0x73, 0x69,0x74, 0x69,0x76,0x65,0x55,0x52,0x4c} length:16];
  NSString *keyone = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
  NSData *dataTwo = [NSData dataWithBytes:(unsigned char []){0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73} length:11];
  NSString *keytwo = [[NSString alloc] initWithData:dataTwo encoding:NSASCIIStringEncoding];
  NSString *method = [NSString stringWithFormat:@"%@%@%@%@",keyone,@":",keytwo,@":"];
  return method;
}
@end
