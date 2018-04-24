//
//  WQpublishTwoTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQpublishModel;
@interface WQpublishTwoTableViewCell : UITableViewCell
@property(nonatomic,strong)WQpublishModel *publishModel;
@property (weak, nonatomic) IBOutlet UILabel *callbackLabel;
@property (weak, nonatomic) IBOutlet UIButton *publishTwoBtn;

@property (weak, nonatomic) IBOutlet UILabel *publishTwoLabel;
@end
