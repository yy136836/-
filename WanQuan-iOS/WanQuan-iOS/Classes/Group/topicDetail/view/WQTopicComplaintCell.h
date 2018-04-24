//
//  WQTopicComplaint Cell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WQTopicComplaintCellBtnOnClick)();

@interface WQTopicComplaintCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *complaintBtn;

@property(nonatomic, copy) WQTopicComplaintCellBtnOnClick deleteTopic;
@property(nonatomic, copy) WQTopicComplaintCellBtnOnClick complaintTopic;

@end
