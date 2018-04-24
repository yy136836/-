//
//  WQvisibleRangecell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/24.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQvisibleRangeModel;
@interface WQvisibleRangecell : UITableViewCell
@property(nonatomic,strong)WQvisibleRangeModel *visibleRangemodel;

@property (weak, nonatomic) IBOutlet UIImageView *checkImage;

/**
 灰色的圈
 */
@property (weak, nonatomic) IBOutlet UIImageView *quanquanImageView;

@end
