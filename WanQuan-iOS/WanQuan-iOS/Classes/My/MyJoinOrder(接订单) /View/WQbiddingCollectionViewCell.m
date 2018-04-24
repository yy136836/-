//
//  WQbiddingCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQbiddingCollectionViewCell.h"
#import "WQWaitOrderoncModel.h"
#import "WQbiddingTableViewCell.h"
#import "WQWaitOrderModel.h"
#import "WQTheArbitrationViewController.h"
#import "WQorderViewController.h"
#import "WQMyReceivinganOrderViewController.h"
#import "WQMyReceivinganOrderVisitorsLoginView.h"

static NSString *cellid = @"cellid";

@interface WQbiddingCollectionViewCell()  <UITableViewDataSource,UITableViewDelegate,WQTheArbitrationViewControllerDelegate>
@property (nonatomic, strong) WQWaitOrderoncModel *waitOrderoncModel;
@property (nonatomic, strong) NSMutableDictionary *haunxinparams;
@property (nonatomic, strong) NSMutableDictionary *confirmCompletedParams;
@property (nonatomic, strong) NSMutableDictionary *cancelTheDealParams;
@property (nonatomic, strong) NSMutableDictionary *applyForArbitrationParams;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, copy) NSString *huanxinId;    //环信id
@property (nonatomic, copy) NSString *needsid;      //用户id
@property (nonatomic, copy) NSString *work_status;
@property (nonatomic, copy) NSIndexPath* (^indexPathBlock)();
@property (nonatomic, weak) WQMyReceivinganOrderViewController * vc;
@property (nonatomic, strong) WQMyReceivinganOrderVisitorsLoginView *myReceivinganOrderVisitorsLoginView;
@end

@implementation WQbiddingCollectionViewCell
-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    //UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    //topView.backgroundColor = [UIColor colorWithHex:0xededed];
    UITableView *contentTableView = [[UITableView alloc] init];
    contentTableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    //[contentTableView registerNib:[UINib nibWithNibName:@"WQbiddingTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    [contentTableView registerClass:[WQbiddingTableViewCell class] forCellReuseIdentifier:cellid];
    self.tableview = contentTableView;
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    //contentTableView.tableHeaderView = topView;
    //取消分割线
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.contentView addSubview:contentTableView];
    [contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [contentTableView layoutIfNeeded];
    
    WQMyReceivinganOrderVisitorsLoginView *myReceivinganOrderVisitorsLoginView = [[WQMyReceivinganOrderVisitorsLoginView alloc] init];
    self.myReceivinganOrderVisitorsLoginView = myReceivinganOrderVisitorsLoginView;
    myReceivinganOrderVisitorsLoginView.isSendOrder = NO;
    myReceivinganOrderVisitorsLoginView.hidden = YES;
    [self.contentView addSubview:myReceivinganOrderVisitorsLoginView];
    [myReceivinganOrderVisitorsLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self loadData];
    
    return self;
}

#pragma mark - 获取环信id
- (void)loadHuanxinid
{
    NSString *urlString = @"api/need/getneedbidder";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.haunxinparams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    _haunxinparams[@"nid"] = self.huanxinId;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_haunxinparams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        NSLog(@"%@",response);
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSArray *array = response[@"bids"];
        for (NSDictionary *dict in array) {
            self.needsid = dict[@"user_id"];
        }
    }];
}

#pragma mark - 加载数据
- (void)loadData
{
    NSString *urlString = @"api/need/mybidneed";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    self.params[@"type"] = @"BIDDED_DOING";
    
    __weak typeof(self) weakself = self;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        weakself.vc = (WQMyReceivinganOrderViewController *)weakself.viewController;
        
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        _waitOrderoncModel = [WQWaitOrderoncModel yy_modelWithJSON:response];
        
        if (_waitOrderoncModel.needs.count < 1) {
            self.myReceivinganOrderVisitorsLoginView.hidden = NO;
        } else {
            NSLog(@"%@",self.waitOrderoncModel.needs);
            [self.tableview reloadData];
            NSMutableArray * needIds = @[].mutableCopy;
            
            for (WQWaitOrderModel * model in _waitOrderoncModel.needs) {
                [needIds addObject:model.id];
            }
            
            [_vc hideOrShowDotForBills:needIds ofBidType:BidTypeSelected];
            _vc.selectedBidIds = needIds;
        }
    }];
}

#pragma mark - tableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.waitOrderoncModel.needs.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WQbiddingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WQorderViewController *orderVc = [[WQorderViewController alloc] initWithNeedsId:cell.model.id];
    orderVc.isHome = NO;
    orderVc.isIPickUpTheOrder = NO;
    [self.viewController.navigationController pushViewController:orderVc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    WQbiddingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WQWaitOrderModel *model = self.waitOrderoncModel.needs[indexPath.row];
    cell.model = model;
    __weak typeof(cell) weakCell = cell;
    if ([cell.model.workstatus isEqualToString:@"WORK_STATUS_PRE_NOT_DONE"]) {
        
        [cell.completeBtn setTitle:@"申请仲裁" forState:UIControlStateNormal];
        [cell.completeBtn setTitleColor:WQ_LIGHT_PURPLE forState:UIControlStateNormal];
        [cell.completeBtn setImage:[UIImage imageNamed:@"shenqingzhongcai"] forState:UIControlStateNormal];
        [cell.completeBtn addClickAction:^(UIButton * _Nullable sender) {
            
            
            
            
            
            UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"对方申请取消交易,是否申请仲裁"
                                                message:@""
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton =
            [UIAlertAction actionWithTitle:@"否"
                                     style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       NSLog(@"否");
                                   }];
            UIAlertAction *destructiveButton =
            [UIAlertAction actionWithTitle:@"是"
                                     style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       WQbiddingTableViewCell *cell = [weakSelf.tableview cellForRowAtIndexPath:indexPath];
                                       NSString *nbid = cell.model.nbid;
                                       WQTheArbitrationViewController *theArbitrationVC = [[WQTheArbitrationViewController alloc] initWithNbid:nbid];
                                       theArbitrationVC.delegate = weakSelf;
                                       [weakSelf.viewController.navigationController pushViewController:theArbitrationVC animated:YES];
                                   }];
            [destructiveButton setValue:WQ_LIGHT_PURPLE forKey:@"titleTextColor"];
            [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
            //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
            
            [alertController addAction:cancelButton];
            [alertController addAction:destructiveButton];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            
            WQbiddingTableViewCell *cell = [weakSelf.tableview cellForRowAtIndexPath:indexPath];
            NSString *nbid = cell.model.nbid;
            WQTheArbitrationViewController *theArbitrationVC = [[WQTheArbitrationViewController alloc] initWithNbid:nbid];
            theArbitrationVC.delegate = weakSelf;
            [weakSelf.viewController.navigationController pushViewController:theArbitrationVC animated:YES];
        }];
        [cell.agreedToCancelBtn setTitleColor:[UIColor colorWithHex:0x5d2a89] forState:UIControlStateNormal];
        [cell.agreedToCancelBtn setImage:[UIImage imageNamed:@"tongyiquxiao"] forState:UIControlStateNormal];
        [cell.agreedToCancelBtn setTitle:@"同意取消" forState:UIControlStateNormal];
        
        cell.agreedToCancelBtn.enabled = YES;
        cell.orangeEdges.hidden = NO;
        
        cell.promptLabel.hidden = NO;
        cell.promptLabel.text = @"对方申请取消交易";
    }
    if ([cell.model.workstatus isEqualToString:@"WORK_STATUS_ARBIRATION"]) {
        [cell.agreedToCancelBtn setTitle:@"|" forState:UIControlStateNormal];
        [cell.agreedToCancelBtn setTitleColor:[UIColor colorWithHex:0xcbcbcb] forState:UIControlStateNormal];
        [cell.agreedToCancelBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        cell.agreedToCancelBtn.enabled = NO;
        [cell.completeBtn setTitle:@" 仲裁中" forState:UIControlStateNormal];
        [cell.completeBtn setTitleColor:WQ_LIGHT_PURPLE forState:UIControlStateNormal];
        cell.yellowEdges.hidden = NO;
        
        cell.promptLabel.hidden = NO;
        cell.promptLabel.text = @"对方不同意支付";
    }
    
    if ([cell.model.workstatus isEqualToString:@"WORK_STATUS_DOING"]) {
        //cell.agreedToCancelBtn.hidden = NO;
        cell.agreedToCancelBtn.enabled = NO;
        [cell.agreedToCancelBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell.agreedToCancelBtn setTitle:@"|" forState:UIControlStateNormal];
        [cell.agreedToCancelBtn setTitleColor:[UIColor colorWithHex:0xcbcbcb] forState:UIControlStateNormal];
    }
    
    if ([cell.model.workstatus isEqualToString:@"WORK_STATUS_PRE_DONE"]) {
        [cell.completeBtn setTitleColor:[UIColor colorWithHex:0xcbcbcb] forState:UIControlStateNormal];
        cell.agreedToCancelBtn.enabled = NO;
        [cell.agreedToCancelBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell.agreedToCancelBtn setTitle:@"|" forState:UIControlStateNormal];
        [cell.agreedToCancelBtn setTitleColor:[UIColor colorWithHex:0xcbcbcb] forState:UIControlStateNormal];
    }
    
    [cell setBillingPresonClikeBlock:^{
        WQbiddingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *nid = cell.model.id;
        NSString *userId = cell.model.user_id;//发单者ID
        NSString *toName = cell.model.user_name;//发单者显示名称
        NSString *toPic = cell.model.user_pic;//发单者显示头像
        NSString *userName = cell.model.bid_user_name;//接单者显示名称
        NSString *userPic = cell.model.bid_user_pic; //接单者显示头像
        BOOL isTrueName = cell.model.truename;
        BOOL isBidTureName = cell.model.bid_truename;
        if (weakSelf.biddingpushxiangqingBlock) {
            weakSelf.biddingpushxiangqingBlock(userId, nid, userId, userName, userPic, toName, toPic, NO, isTrueName, isBidTureName);
        }
    }];
    
    [cell setCompleteBlick:^{
        if ([weakCell.model.workstatus isEqualToString:@"WORK_STATUS_PRE_DONE"]) {
            return ;
        }
        if ([weakCell.model.workstatus isEqualToString:@"WORK_STATUS_DOING"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"订单已完成,申请发单者付款"
                                                                                     message:@""
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     NSLog(@"取消");
                                                                 }];
            UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"申请"
                                                                        style:UIAlertActionStyleDestructive
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                          WQbiddingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                                                          [weakSelf orderIsConfirmed:cell.model.nbid work_status:cell.model.workstatus];
                                                                      }];
            [destructiveButton setValue:WQ_LIGHT_PURPLE forKey:@"titleTextColor"];
            [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
            
            [alertController addAction:cancelButton];
            [alertController addAction:destructiveButton];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
        }
    }];
    [cell setAgreedToCancelBlock:^{
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"同意取消此需求"
                                            message:@""
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton =
        [UIAlertAction actionWithTitle:@"关闭"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * _Nonnull action) {
                                   NSLog(@"关闭");
                               }];
        UIAlertAction *destructiveButton =
        [UIAlertAction actionWithTitle:@"同意"
                                 style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction * _Nonnull action) {
                                   WQbiddingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                   [weakSelf setAgreedToCancel:cell.model.nbid];
                               }];
        [destructiveButton setValue:WQ_LIGHT_PURPLE forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }];
    
    //BOOL redDotbool = [EaseConversationListViewController shouldShowRedDot:cell.model.id withBidUser:cell.model.user_id];
    BOOL redDotbool = [WQUnreadMessageCenter haveUnreadMessageForBid:cell.model.id];
    if (redDotbool) {
        cell.redDotView.hidden = NO;
    }else
    {
        cell.redDotView.hidden = YES;
    }
    
    BOOL bidDot =  cell.model.reddot;
    
    //订单的红点
    
    
    
    if (bidDot) {
        [cell showDotBadge];
        cell.badge.frame = CGRectMake(cell.badge.x - 15, cell.badge.y + 10, cell.badge.width, cell.badge.height);
        
    } else {
        [cell hideDotBadge];
    }
    
    return cell;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

#pragma mark - 接单者申请仲裁
- (void)applyForArbitration
{
    WQbiddingTableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.indexPath];
    NSString *nbid = cell.model.nbid;
    WQTheArbitrationViewController *theArbitrationVC = [[WQTheArbitrationViewController alloc] initWithNbid:nbid];
    theArbitrationVC.delegate = self;
    [self.viewController.navigationController pushViewController:theArbitrationVC animated:YES];
}

#pragma mark - 提交平台审核
- (void)wqSubmittedToArbitrationForSuccess:(WQTheArbitrationViewController *)theArbitrationVC
{
    
}

#pragma mark - 接单者同意取消交易
- (void)setAgreedToCancel:(NSString *)nbid
{
    NSString *urlString = @"api/need/changebiddedneedworkstatus";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.applyForArbitrationParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    _applyForArbitrationParams[@"nbid"] = nbid;
    _applyForArbitrationParams[@"work_status"] = @"WORK_STATUS_NOT_DONE";
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_applyForArbitrationParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            //            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
            //            [SVProgressHUD setForegroundColor:[UIColor colorWithHex:0xa550d6]];
            [SVProgressHUD showInfoWithStatus:@"已同意取消需求"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
            //            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
            //            [SVProgressHUD setForegroundColor:[UIColor colorWithHex:0xa550d6]];
            [SVProgressHUD showErrorWithStatus:@"请勿重复提交"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }
    }];
}

#pragma mark - 接单者确认完成
- (void)orderIsConfirmed:(NSString *)nbid work_status:(NSString *)work_status
{
    if ([work_status isEqualToString:@"WORK_STATUS_PRE_NOT_DONE"]) {
        return;
    }
    NSString *urlString = @"api/need/changebiddedneedworkstatus";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.confirmCompletedParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    self.confirmCompletedParams[@"nbid"] = nbid;
    self.confirmCompletedParams[@"work_status"] = @"WORK_STATUS_PRE_DONE";
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:_confirmCompletedParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            //            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
            //            [SVProgressHUD setForegroundColor:[UIColor colorWithHex:0xa550d6]];
            [SVProgressHUD showInfoWithStatus:@"请等候发单人确认"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
            //            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
            //            [SVProgressHUD setForegroundColor:[UIColor colorWithHex:0xa550d6]];
            [SVProgressHUD showErrorWithStatus:@"请勿重复提交"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }
    }];
    
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableDictionary *)haunxinparams
{
    if (!_haunxinparams) {
        _haunxinparams = [[NSMutableDictionary alloc]init];
    }
    return _haunxinparams;
}
- (NSMutableDictionary *)confirmCompletedParams
{
    if (!_confirmCompletedParams) {
        _confirmCompletedParams = [[NSMutableDictionary alloc] init];
    }
    return _confirmCompletedParams;
}
- (NSMutableDictionary *)cancelTheDealParams
{
    if (!_cancelTheDealParams) {
        _cancelTheDealParams = [[NSMutableDictionary alloc] init];
    }
    return _cancelTheDealParams;
}
- (NSMutableDictionary *)applyForArbitrationParams
{
    if (!_applyForArbitrationParams) {
        _applyForArbitrationParams = [[NSMutableDictionary alloc] init];
    }
    return _applyForArbitrationParams;
}

#pragma mark - 两秒后移除提示框
- (void)delayMethod
{
    //两秒后移除提示框
    [SVProgressHUD dismiss];
}

@end
