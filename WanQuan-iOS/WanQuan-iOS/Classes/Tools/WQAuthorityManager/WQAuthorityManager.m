//
//  WQAuthorityManager.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAuthorityManager.h"
#import <AddressBook/AddressBook.h>
#import <Photos/Photos.h>

@implementation WQAuthorityManager

+ (instancetype)manger {
    static WQAuthorityManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];

    });
    [sharedManager checkMIC];
    [sharedManager checkAPNS];
    // 相册
    [sharedManager checkAlbum];
    // 相机
    [sharedManager checkCamera];
    [sharedManager checkLocation];
    [sharedManager checkAdressBook];
    return sharedManager;
}


- (void)checkLocation {
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (isLocation) {
        
        self.canLocate = YES;
    } else {
        
        self.canLocate = NO;
        NSLog(@"手机未开启定位");
    }
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    switch (CLstatus) {
        case kCLAuthorizationStatusAuthorizedAlways: NSLog(@"允许定位");
            self.haveLocateAuthority = YES;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: NSLog(@"允许定位");
            self.haveLocateAuthority = YES;
            break;
        case kCLAuthorizationStatusDenied: NSLog(@"Denied");
            
            if ([CLLocationManager locationServicesEnabled]) {
                
                NSLog(@"定位服务开启，被拒绝");
                //TODOHANYANG
                self.haveLocateAuthority = NO;
            } else {
                
                NSLog(@"定位服务关闭，不可用");
                //TODOHANYANG
                self.haveLocateAuthority = YES;
            }
            break;
        case kCLAuthorizationStatusNotDetermined:
            
            
            NSLog(@"还未选择定位权限");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"无法确认是否开启定位权限");
            break;
        default:
            break;
    }
    
}
- (void)checkAPNS {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (!settings.types) {
            
            self.haveAPNSAuthority = NO;
        } else {
            
            self.haveAPNSAuthority = YES;
        }
//    });
    
    
}


- (BOOL)checkAdressBook {
    ABAuthorizationStatus ABstatus = ABAddressBookGetAuthorizationStatus();
    

    
    switch (ABstatus) {
        case kABAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            self.haveAdressBookAuthority = YES;
            break;
            
        case kABAuthorizationStatusDenied:
            NSLog(@"Denied'");
            self.haveAdressBookAuthority = NO;
            break;
        case kABAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            return NO;
            break;
        case kABAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            return NO;
            break;
        default: break;
    }
    return YES;
}


- (BOOL)checkAlbum {
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    

    
    switch (photoAuthorStatus) {
            
        case PHAuthorizationStatusAuthorized:{
            
            self.haveAlbumAuthority = YES;
            NSLog(@"Authorized");
            break;
        }
            
        case PHAuthorizationStatusDenied: {
            
            self.haveAlbumAuthority = NO;
            NSLog(@"Denied");
            break;
        }
            
        case PHAuthorizationStatusNotDetermined:{
            
            NSLog(@"not Determined");
            return NO;
            break;
        }
            
        case PHAuthorizationStatusRestricted:{
            return NO;
            NSLog(@"Restricted");
            break;
        }
            
        default:
            break;
    }
    return YES;
}

- (BOOL)checkCamera {

    
    
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    switch (AVstatus) {
            //允许状态
        case AVAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            self.haveCameraAuthority = YES;
            break;
            //不允许状态，可以弹出一个alertview提示用户在隐私设置中开启权限
        case AVAuthorizationStatusDenied: {NSLog(@"Denied");
            self.haveCameraAuthority = NO;
            break;
        }
            //未知，第一次申请权限
        case AVAuthorizationStatusNotDetermined: {
            NSLog(@"not Determined");
            return NO;
            break;
        }
            //此应用程序没有被授权访问,可能是家长控制权限
        case AVAuthorizationStatusRestricted: {
            NSLog(@"Restricted");
            return NO;
            break;
        }
        default: break;
    }
    return YES;
}

- (BOOL)checkMIC {
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//麦克风权限
    switch (AVstatus) {
            //允许状态
        case AVAuthorizationStatusAuthorized:{
            NSLog(@"Authorized");
            self.haveMICAuthority = YES;
            break;
        }
            //不允许状态，可以弹出一个alertview提示用户在隐私设置中开启权限
        case AVAuthorizationStatusDenied: {
            NSLog(@"Denied");
            self.haveMICAuthority = NO;
            break;
        }
            //未知，第一次申请权限
        case AVAuthorizationStatusNotDetermined: {
            NSLog(@"not Determined");
            return NO;
            break;
        }
            //此应用程序没有被授权访问,可能是家长控制权限
        case AVAuthorizationStatusRestricted: {
            NSLog(@"Restricted");
            return NO;
            break;
        }
        default:
            break;
    }
    return YES;
}



- (void)showAlertForLocateAuthority {
    
    [self checkLocation];
    
    if([CLLocationManager authorizationStatus]) {
        if (!self.haveLocateAuthority) {
            [self showAlertWithTitle:@"还未开启定位信息访问权限" andAlertMessage:@"请在设置-隐私-地理位置中允许万圈访问"];
        }
    }
}

- (void)showAlertForAPNSAuthority {
    
    [self checkAPNS];
    
    if (_haveAPNSAuthority) {
        return;
    }
    NSDate * date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    NSString * str = [NSString stringWithFormat:@"%lf",interval];
    
    
    NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:WQAPNSAlertTime];
    
    double early = [str1 doubleValue];
    
    
    BOOL threeDaysLater = NO;
    if (interval - early  > ((double)24) * 3 * 60 * 60) {
        threeDaysLater = YES;
    }
    
    
    if((!str1.length) ||(threeDaysLater)) {
        
        if (!self.haveAPNSAuthority) {
            [self showAlertWithTitle:@"还未开启通知" andAlertMessage:@"开启通知能让您及时了解订单状态,收到好友的消息"];
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:WQAPNSAlertTime];
        }
    }
}

- (void)showAlertForAdressBookAuthority {
    
    if (!ABAddressBookGetAuthorizationStatus()) {
        return;
    }
    NSDate * date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    NSString * str = [NSString stringWithFormat:@"%lf",interval];
    
    
    NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:WQAdressBookAlertTime];
    
    double early = [str1 doubleValue];
    
    
    BOOL sevenDaysLater = NO;
    if (interval - early  > ((double)24) * 7 * 60 * 60) {
        sevenDaysLater = YES;
    }
    
    
    if((!str1.length) ||(sevenDaysLater)) {
        
        [self checkAdressBook];
        if (!self.haveAdressBookAuthority) {
            [self showAlertWithTitle:@"还未开启通讯录权限" andAlertMessage:@"想看哪些通讯录好友已加入万圈\n请在设置-隐私-通讯录中允许万圈访问"];
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:WQAPNSAlertTime];
        }
    }
}

- (void)showAlertForAlbumAuthority {
    
    
    if([PHPhotoLibrary authorizationStatus]){
        [self checkAlbum];
        if (!self.haveAlbumAuthority) {
            [self showAlertWithTitle:@"“万圈”想要访问您的手机相册" andAlertMessage:@"请在设置-隐私-相册中允许万圈访问"];
        }
    }
}

- (void)showAlertForCameraAuthority {
    
    
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        [self checkCamera];
        
        if (!self.haveCameraAuthority) {
            [self showAlertWithTitle:@"还未开启相机访问权限" andAlertMessage:@"请在设置-隐私-相机中允许万圈访问"];
        }
    }

    
}

- (void)showAlertForMICAuthority {
    
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]) {
        [self checkMIC];
        if (!self.haveMICAuthority) {
            [self showAlertWithTitle:@"还未开启麦克风访问权限" andAlertMessage:@"请在设置-隐私-麦克风允许万圈访问"];
        }
    }

    
}

- (void)showAlertWithTitle:(NSString *)alertTitle andAlertMessage:(NSString *)message {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:alertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    __weak typeof([UIApplication sharedApplication]) weakapp =  [UIApplication sharedApplication];
    UIAlertAction * setting = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakapp openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alert addAction:actionCancle];
    [alert addAction:setting];
    UIViewController * vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    while (vc.presentedViewController) {
        
        vc = vc.presentedViewController;
    }
    [vc presentViewController:alert animated:YES completion:nil];
}


@end
