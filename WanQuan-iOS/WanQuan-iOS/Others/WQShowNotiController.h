//
//  WQShowNotiController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnClick)();

@interface WQShowNotiController : UIViewController

@property (nonatomic, copy)OnClick dissmiss;

@end
