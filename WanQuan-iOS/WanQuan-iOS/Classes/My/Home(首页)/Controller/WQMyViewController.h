//
//  WQMyViewController.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/10/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQViewController.h"

/**
 root-> 我的(已弃置)
 */
@interface WQMyViewController : WQViewController<UITableViewDataSource,UITableViewDelegate,UITabBarDelegate,UITabBarControllerDelegate>
@property (nonatomic, strong) UITableView *tableview;

@end
