//
//  WQEssenceDetailController+SwizzeMethod.h
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/16.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQEssenceDetailController.h"
#import "WQActionSheet.h"
@interface WQEssenceDetailController (SwizzeMethod)  <UIGestureRecognizerDelegate,WQActionSheetDelegate>



/**
 * get image's url from this javascript
 */
@property (nonatomic, strong) NSString *imageJS;

/**
 * image's qr code string, if have
 * or nil
 */
@property (nonatomic, strong) NSString *qrCodeString;

/**
 * image
 */
@property (strong, nonatomic) UIImage *image;



@end
