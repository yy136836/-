//
//  WQIndividualTrendsTableView.h
//  WanQuan-iOS
//
//  Created by hanyang on 2018/1/15.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQIndividualTrendCommentModel.h"
@interface WQIndividualTrendsTableView : UITableView
@property (nonatomic, retain) WQIndividualTrendCommentModel * model;
- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
