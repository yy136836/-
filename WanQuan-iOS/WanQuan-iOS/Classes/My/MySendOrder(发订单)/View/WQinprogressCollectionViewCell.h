//
//  WQinprogressCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 root->我的->我发的需求->进行中 
 */
@interface WQinprogressCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) void(^inprogressPushxiangqingClikeBlock)(NSString *);
- (void)loadData;

@end
