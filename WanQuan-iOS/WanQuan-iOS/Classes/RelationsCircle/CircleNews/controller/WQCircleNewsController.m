//
//  WQCircleNewsController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCircleNewsController.h"
#import "WQCircleApplyCell.h"
#import "WQCircleDynamicCell.h"
#import "WQCircleApplyListController.h"
#import "WQPraiseListController.h"
#import "WQCircleNewsModel.h"
#import "WQEssenceDetailController.h"
#import "WQCirleMessageCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "WQdynamicDetailsViewConroller.h"
#import "WQCommentDetailsViewController.h"

NSString * circleApplyCellIdenty = @"WQCircleApplyCell";
NSString * circleDynamicCellIdenty = @"WQCircleDynamicCell";



@interface WQCircleNewsController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, retain) UITableView * mainTable;
@property (nonatomic, retain) NSMutableArray * dataArray;



@end

@implementation WQCircleNewsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"圈消息";
    _dataArray = @[].mutableCopy;
    [self setupUI];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadCircleDynamicList];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20],
                                                                      NSForegroundColorAttributeName : [UIColor blackColor]}];
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"]
//                                                                  style:UIBarButtonItemStyleDone
//                                                                 target:self
//                                                                 action:@selector(back:)];
//
//    [leftItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}
//                            forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}




- (void)setupUI {
    _mainTable = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_mainTable];
    
    [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(@(NAV_HEIGHT));
    }];
    _mainTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.tableFooterView = [UIView new];
    _mainTable.tableHeaderView = [UIView new];
    _mainTable.rowHeight = UITableViewAutomaticDimension;
    _mainTable.estimatedRowHeight = 160;
    [_mainTable registerNib:[UINib nibWithNibName:@"WQCircleApplyCell" bundle:nil] forCellReuseIdentifier:circleApplyCellIdenty];
    _mainTable.emptyDataSetDelegate = self;
    _mainTable.emptyDataSetSource = self;
}



- (void)loadCircleDynamicList {
    
    NSString * strURL = @"api/message/querycommentmessage";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        
        
//        {
//            "success": true,
//            "messages": [
//                        {
//                             "posttime": "2017-01-03 20:21",
//                             "targetid": "6a2aa09e10ed4e59996c4e02ea82b8ee",
//                             "subject": "发布新的订单",
//                             "title": "订单发布",
//                             "type": "TYPE_NEED", 
//                             "content": "来自订单：郭杭是个大帅bi"
//                         }
//                         ]
//        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            _dataArray = [NSArray yy_modelArrayWithClass:[WQCircleNewsModel class] json:response[@"messages"]].mutableCopy;
            
            
            NSString * strURL = @"api/message/reddot";
            NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
            if (!secreteKey.length) {
                
            }
            NSDictionary * param = @{@"secretkey":secreteKey};
            
            WQNetworkTools *tools = [WQNetworkTools sharedTools];
            NSURLSessionDataTask * task =  [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
                if (error) {
                    return ;
                }
                
                
                //        ecode = 0;
                //        好友申请
                //        "friendapply_count" = 0;
                //        消息
                //        message = 0;
                //        入群申请
                //        "message_applyjoingroup" = 0;
                //        评论
                //        "message_comment" = 0;
                //        赞
                //        "message_like" = 0;
                //        系统消息
                //        "message_sys" = 0;
                //        "my_bidded_need_bidded_doing_count" = 0;
                //        "my_bidded_need_bidded_finished_count" = 1;
                //        "my_bidded_need_bidding_count" = 0;
                //        "my_bidded_need_total_count" = 1;
                //        "my_count" = 1;
                //        "my_created_need_bidded_count" = 0;
                //        "my_created_need_bidding_count" = 0;
                //        "my_created_need_finished_count" = 0;
                //        "my_created_need_total_count" = 0;
                //        success = 1;
                
                
                
                
                
                ROOT(root);
                
                if (root) {
                    if ([response[@"my_bidded_need_bidded_doing_count"] boolValue]||
                        [response[@"my_bidded_need_bidding_count"] boolValue]||
                        [response[@"my_created_need_bidded_count"] boolValue]||
                        [response[@"my_created_need_bidding_count"] boolValue]) {
                        root.haveBidInfoToDealWith = YES;
                    } else {
                        root.haveBidInfoToDealWith = NO;
                    }
                    
                    
                    
                    root.haveFriendapply = [response[@"friendapply_count"] boolValue];
                    
                    root.haveSystemInfoToDealWith = [response[@"message_sys"] boolValue];
                    
                    root.haveGroupApply  = [response[@"message_applyjoingroup"] boolValue];
                    
                    root.haveCommentInfoToDealWith = [response[@"message_comment"] boolValue];
                    
                    root.haveMessageInfoToDealWith = [response[@"message"] boolValue];
                    
                    root.haveLikeTodealWith = [response[@"message_like"] boolValue];
                    
                    root.haveCircleEvent = [response[@"message_applyjoingroup"]boolValue]||[response[@"message_comment"]boolValue]||[response[@"message_like"]boolValue];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldHideRedNotifacation object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:WQShouldShowRedNotifacation object:nil];
                    
                    [_mainTable reloadData];


                    
                }
            }];

            
            
            
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (0 == section) {
        return 1;
    }
    if (1 == section) {
        return _dataArray.count;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ROOT(root);

    
    if (indexPath.section == 0) {
        WQCircleApplyCell * cell = [tableView dequeueReusableCellWithIdentifier:circleApplyCellIdenty];
        
        if (indexPath.row == 0) {
            cell.desLabel.text = @"入圈申请";
            cell.avatar.image = [UIImage imageNamed:@"ruquanshenqing"];
            cell.redDot.hidden = !root.haveGroupApply ;
//            [[WQNetworkTools sharedTools] fetchRedDot];
//            cell.isApply = YES;
        }
        // MARK: 不要删除留下以防回头改回来
//        if (indexPath.row == 1) {
//            cell.desLabel.text = @"我收到的赞";
//            cell.avatar.image = [UIImage imageNamed:@"woshoudaodezan"];
//            cell.redDot.hidden = !root.haveLikeTodealWith ;
//
////            cell.isApply = NO;
//        }
        
        cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
    if (indexPath.section == 1) {
        WQCirleMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:circleDynamicCellIdenty];
        
        if (!cell) {
            cell = [[WQCirleMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:circleDynamicCellIdenty];
        }
        
        cell.model = _dataArray[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
    return [UITableViewCell new];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }
    
    if (indexPath.section == 1) {
        WQCirleMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:circleDynamicCellIdenty];
        
        if (!cell) {
            cell = [[WQCirleMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:circleDynamicCellIdenty];
        }
        
        cell.model = _dataArray[indexPath.row];
//        return 160 + cell.addHeight;
////        NSLog(@"%lf",125 + cell.addHeight);
        return UITableViewAutomaticDimension;

    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        WQCircleDynamicCell * cell0 = (WQCircleDynamicCell *)cell;
        cell0.addHeight = 0;
    } else {
        WQCircleApplyCell * cell1 = (WQCircleApplyCell *)cell;
        cell1.isApply = NO;
        cell1.redDot.hidden = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            WQCircleApplyListController * vc = [[WQCircleApplyListController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 1) {
            [[WQNetworkTools  sharedTools] fetchRedDot];
            WQCircleApplyCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.redDot.hidden = YES;
            ROOT(root);
            root.haveLikeTodealWith = NO;
            WQPraiseListController * vc = [[WQPraiseListController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 1) {
//        WQCircleNewsModel *model = _dataArray[indexPath.row];
//        // 精选一级评论
//        if ([model.targettype isEqualToString:@"TARGET_TYPE_CHOICEST_ARTICLE"]) {
////            WQEssenceDetailController *vc = [[WQEssenceDetailController alloc] init];
////            vc.isComment = NO;
////            vc.model = model.moment_choicest_article;
////            [self.navigationController pushViewController:vc animated:YES];
//        }
//        // 精选二级评论
//        if ([model.targettype isEqualToString:@"TARGET_TYPE_CHOICEST_COMMENT"]) {
//
//        }
//        // 动态一级评论
//        if ([model.targettype isEqualToString:@"TARGET_TYPE_MOMENT_STATUS"]) {
//            WQdynamicDetailsViewConroller *vc = [[WQdynamicDetailsViewConroller alloc] init];
//            vc.isComment = NO;
//            vc.mid = model.targetid;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        // 动态二级评论
//        if ([model.targettype isEqualToString:@"TARGET_TYPE_COMMENT"]) {
//            WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
////            vc.model = cell.model;
//            vc.mid = model.targetid;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        // 需求一级评论
//        if ([model.targettype isEqualToString:@"TARGET_TYPE_NEED"]) {
//
//        }
//        // 需求二级评论
//        if ([model.targettype isEqualToString:@"TARGET_TYPE_NEED_COMMENT"]) {
//
//        }
    }
    
}


- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma DZNEmpty
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return HEX(0xf3f3f3);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    return [UIImage imageNamed:@"wuxiaoxi"];
    
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString * str  = [[NSMutableAttributedString alloc] init];
    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x999999),
                           NSFontAttributeName:[UIFont systemFontOfSize:14],
                           NSParagraphStyleAttributeName:paragraphStyle};
    
    NSString * noResult = @"\n 还没有新的赞";
    
    
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:noResult attributes:att]];
    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:6],
                         NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, 1)];
    
    return str;
}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    return [[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
//}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -44;
}
@end
