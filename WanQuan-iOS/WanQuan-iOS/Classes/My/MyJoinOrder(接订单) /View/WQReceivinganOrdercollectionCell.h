//
//  WQReceivinganOrdercollectionCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQReceivinganOrdercollectionCell : UICollectionViewCell

@property(nonatomic,copy)void(^pushxiangqingClikeBlock)(NSString *userId, NSString *nid, NSString *needOwnerId, NSString *fromName, NSString *fromPic, NSString *toName, NSString *toPic, BOOL isBidding, BOOL isTrueName, BOOL isBidTureName);
- (void)loadData;

@end
