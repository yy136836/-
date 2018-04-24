//
//  WQTopicDtailUserInfoCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQTopicModel.h"

@interface WQTopicDtailUserInfoCell : UITableViewCell
@property (nonatomic, retain) WQTopicModel * model;
@property (weak, nonatomic) IBOutlet UILabel *topicTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *topicConttentLabel;
@end
