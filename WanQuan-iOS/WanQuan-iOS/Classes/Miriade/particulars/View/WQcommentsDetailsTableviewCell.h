//
//  WQcommentsDetailsTableviewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/27.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQcommentListModel,WQcommentsDetailsTableviewCell;

@protocol WQcommentsDetailsTableviewCellDelegate <NSObject>

- (void)wqUser_picClick:(WQcommentsDetailsTableviewCell *)cell;

@end

@interface WQcommentsDetailsTableviewCell : UITableViewCell
@property (nonatomic, weak) id <WQcommentsDetailsTableviewCellDelegate>delegate;

@property (nonatomic, strong) WQcommentListModel *model;
@end
