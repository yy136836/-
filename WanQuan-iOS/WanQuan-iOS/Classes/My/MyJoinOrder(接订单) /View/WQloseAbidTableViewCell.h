//
//  WQloseAbidTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQWaitOrderModel,WQloseAbidTableViewCell;


typedef void (^ChatHistoryOnClick) (void);


@interface WQloseAbidTableViewCell : UITableViewCell
@property(nonatomic,strong)WQWaitOrderModel *model;
// 评价的按钮
@property (strong, nonatomic) UIButton *evaluationBtn;

@property(nonatomic,copy)void(^evaluateBtnClikeBlock)();

@property (nonatomic, copy) ChatHistoryOnClick chatHistoryOnCkick;
@end


