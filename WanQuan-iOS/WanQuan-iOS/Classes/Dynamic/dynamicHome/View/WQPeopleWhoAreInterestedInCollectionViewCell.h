//
//  WQPeopleWhoAreInterestedInCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQPeopleWhoAreInterestedInModel,WQPeopleWhoAreInterestedInCollectionViewCell;

@protocol WQPeopleWhoAreInterestedInCollectionViewCellDelegate <NSObject>

/**
 关注按钮的响应事件

 @param cell self
 */
- (void)wqGuanzhuBtnClick:(WQPeopleWhoAreInterestedInCollectionViewCell *)cell;

@end

@interface WQPeopleWhoAreInterestedInCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <WQPeopleWhoAreInterestedInCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) WQPeopleWhoAreInterestedInModel *model;

/**
 关注的按钮
 */
@property (nonatomic, strong) UIButton *guanzhuBtn;

@end
