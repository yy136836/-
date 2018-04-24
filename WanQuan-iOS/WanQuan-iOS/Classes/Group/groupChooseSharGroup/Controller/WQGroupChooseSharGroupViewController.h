//
//  WQGroupChooseSharGroupViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    ShareTypeNeed = 0,
    ShareTypeChoiset
} ShareType;

@interface WQGroupChooseSharGroupViewController : UIViewController


/**
 分享的是需求还是精选
 */
@property (nonatomic, assign) ShareType shareType;

// 需求转发到群组的需求id


/**
 当shareType 为0 为需求id
 当shareType 为1 是精选id
 */
@property (nonatomic, copy) NSString *nid;


@end
