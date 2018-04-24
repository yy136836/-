//
//  WQEmptICareCollectionView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/11.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Status) {
    // 我关注
    IFocusOn,
    // 关注我
    PayAttentionToMy,
    // 收藏
    PayAttentionToMe
};

@interface WQEmptICareCollectionView : UIView

@property (nonatomic, assign) Status status;

@end
