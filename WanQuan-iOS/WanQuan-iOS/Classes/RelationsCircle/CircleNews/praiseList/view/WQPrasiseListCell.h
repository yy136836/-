//
//  WQPrasiseListCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQPraiseListModel.h"
@interface WQPrasiseListCell : UITableViewCell

@property (nonatomic, retain) WQPraiseListModel * model;
@property (nonatomic, assign) CGFloat addHeight;

@end
