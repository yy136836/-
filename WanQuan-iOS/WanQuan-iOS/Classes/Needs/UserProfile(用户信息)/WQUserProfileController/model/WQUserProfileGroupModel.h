//
//  WQUserProfileGroupModel.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQUserProfileGroupModel : NSObject


/**
 //"gid": "0969a3f28f964416909d1d2ed0b9450d",
 */
@property (nonatomic, copy) NSString * gid;

/**
 //"isOwner": false,
 */
@property (nonatomic, assign) BOOL isOwner;

@property (nonatomic, assign) BOOL isGroupUser;

/**
 //"name": "王者荣耀交流群",
 */
@property (nonatomic, copy) NSString * name;

/**
 //"pic": "7e2b4e24d6694885991d1f35723cee3d",
 */
@property (nonatomic, copy) NSString * pic;

/**
 //"public_show": true
 */
@property (nonatomic, assign) BOOL public_show;


/**
 圈描述
 */
@property (nonatomic, copy) NSString * desc;

@end
