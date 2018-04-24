//
//  WQGroupChooseSharGroupTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGroupModel;

@interface WQGroupChooseSharGroupTableViewCell : UITableViewCell

@property (nonatomic, strong) WQGroupModel *model;
// 已选的人的对勾
@property (weak, nonatomic) IBOutlet UIImageView *hookImageView;

@end
