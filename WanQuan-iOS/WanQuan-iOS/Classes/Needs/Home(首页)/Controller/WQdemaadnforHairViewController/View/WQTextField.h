//
//  WQTextField.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/5/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, titleType) {
    wenshi,
    zhaoren,
    BBS,
    bangzhu,
};

@interface WQTextField : UITextField

- (instancetype)initWithTitleType:(titleType)type;

@end
