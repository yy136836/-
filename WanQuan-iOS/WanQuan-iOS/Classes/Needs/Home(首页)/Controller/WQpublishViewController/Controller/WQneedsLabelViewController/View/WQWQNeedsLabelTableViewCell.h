//
//  WQWQNeedsLabelTableViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQNeedsLabelModel;
@interface WQWQNeedsLabelTableViewCell : UITableViewCell
@property(nonatomic,strong)WQNeedsLabelModel *needsLabelModel;
@property(nonatomic,copy)void(^ClikeBlock)();
@property (weak, nonatomic) IBOutlet UITextField *propellingXml;
@end
