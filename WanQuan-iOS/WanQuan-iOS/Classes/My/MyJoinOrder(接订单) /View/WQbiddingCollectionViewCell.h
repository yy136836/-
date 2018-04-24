//
//  WQbiddingCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQbiddingCollectionViewCell : UICollectionViewCell
@property(nonatomic,copy)void(^biddingpushxiangqingBlock)(NSString *huanxinId, NSString *nid, NSString *needOwnerId, NSString *userName, NSString *userPic, NSString *toName, NSString *toPic, BOOL isBidding, BOOL isTrueName, BOOL isBidTureName);
- (void)loadData;


@end
