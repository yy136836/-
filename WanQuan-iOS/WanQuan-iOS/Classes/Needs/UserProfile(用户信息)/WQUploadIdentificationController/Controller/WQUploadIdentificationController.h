//
//  WQUploadIdentificationController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^saveInfo)(NSArray * criditPhotoIDs, NSString * criditNumber);

@interface WQUploadIdentificationController : UIViewController

@property (nonatomic, copy) saveInfo savInfo;

@end
