//
//  WQAuthorityManager.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQAuthorityManager : NSObject

//[sharedManager checkLocation];
//[sharedManager checkAPNS];
//[sharedManager checkAdressBook];
//[sharedManager checkAlbum];
//[sharedManager checkCamera];
//[sharedManager checkMIC];



@property (nonatomic, assign) BOOL canLocate;



@property (nonatomic, assign) BOOL haveLocateAuthority;
@property (nonatomic, assign) BOOL haveAPNSAuthority;
@property (nonatomic, assign) BOOL haveAdressBookAuthority;
@property (nonatomic, assign) BOOL haveAlbumAuthority;
@property (nonatomic, assign) BOOL haveCameraAuthority;
@property (nonatomic, assign) BOOL haveMICAuthority;




+ (instancetype)manger;


- (void)checkLocation;


/**
 检查权限如果是已经询问过权限而拒绝了权限的话就弹窗申请权限
 */
- (void)showAlertForLocateAuthority;

/**
 检查权限如果是已经询问过权限而拒绝了权限的话就弹窗申请权限
 */
- (void)showAlertForAPNSAuthority;

/**
 检查权限如果是已经询问过权限而拒绝了权限的话就弹窗申请权限
 */
- (void)showAlertForAdressBookAuthority;

/**
 检查权限如果是已经询问过相册权限而拒绝了权限的话就弹窗申请权限
 */
- (void)showAlertForAlbumAuthority;

/**
 检查权限如果是已经询问过相机权限而拒绝了权限的话就弹窗申请权限
 */
- (void)showAlertForCameraAuthority;

/**
 检查权限如果是已经询问过麦克风权限而拒绝了权限的话就弹窗申请权限
 */
- (void)showAlertForMICAuthority;

//- (BOOL)shouldCheckAlbumAuthority;
//- (BOOL)shouldCheckCameraAuthority;
//- (BOOL)shouldCheckMICAuthority;


@property (nonatomic, assign) BOOL isAPNS;

@end
