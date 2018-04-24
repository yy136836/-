//
//  WQdetailsConrelooerViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/29.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQdetailsConrelooerViewController.h"
#import "WQHomeNearby.h"
#import "WQChaViewController.h"
#import "WQPeopleListTableViewCell.h"
#import "WQPeopleListModel.h"
#import "WQUserProfileController.h"
#import "WQTheArbitrationViewController.h"
#import "WQevaluateViewController.h"
#import "WQstrongSingleMessageViewController.h"
#import "WQTopicDetailFooter.h"
#import "WQorderDetailsTableViewCell.h"
#import "WQaskButtonTableViewCell.h"
#import "WQorderHeadView.h"
#import "ChatHelper.h"
#import "UMSocialUIManager.h"
#import "UMSocialSinaHandler.h"
#import "WQListTagTableViewCell.h"
#import "WQBBSTableViewCell.h"
#import "WQGroupChooseSharGroupViewController.h"
#import "WQDynamicLevelOncCommentModel.h"
#import "WQdetailsBottomView.h"
#import "WQDynamicDetailsCommentTableViewCell.h"
#import "WQTextInputViewWithOutImage.h"
#import "WQCommentDetailsViewController.h"
#import "WQDataEmptyView.h"

static NSString *cellID = @"cellid";
static NSString *PeopleListCellid = @"PeopleListCellid";
static NSString *askBtncellID = @"WQaskButtonTableViewCell";
static NSString *identifier = @"identifier";
static NSString *viewerCellId = @"viewerCellId";
static NSString *commentIdentifier = @"commentIdentifier";

@interface WQdetailsConrelooerViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WQTheArbitrationViewControllerDelegate,WQevaluateViewControllerDelegate,WQorderDetailsTableViewCellDelegate,WQdetailsBottomViewDelegate,WQTextInputViewWithOutImageDelegate,UITextViewDelegate,WQDynamicDetailsCommentTableViewCellDelegate>


@property (nonatomic, copy) NSString *imHuanxinid;
@property (nonatomic, copy) NSString *work_status;
@property (nonatomic, copy) NSString *workStatusDone;
@property (nonatomic, strong) WQHomeNearby *homemodel;
@property (nonatomic, strong) WQPeopleListModel *peopleListModel;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *tableViewdetailOrderData;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *PeopleListparams;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableDictionary *agreeToPaymentParams;
@property (nonatomic, strong) NSMutableDictionary *cancellParams;
@property (nonatomic, strong) NSMutableDictionary *modifyParams;
@property (nonatomic, strong) NSMutableDictionary *deleteneedParams;
@property (nonatomic, strong) NSArray *btnTitleArray;
@property (nonatomic, strong) NSMutableDictionary *confirmParams;
@property (nonatomic, strong) NSMutableDictionary *ignoreParams;
@property (nonatomic, assign) WQOrderType wqOrderType;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableSet *bidUserList;

@property (nonatomic, strong) WQorderHeadView *orderHeadView;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSDictionary *response;

// 底部未接单询问的view
@property (nonatomic, strong) WQdetailsBottomView *detailsBottomView;

@property (nonatomic, strong) NSArray *comments;

@property (nonatomic, assign) BOOL isCom;

@property (nonatomic, assign) BOOL isOnccommen;

@property (nonatomic, copy) NSString *cid;

/**
 底部评论输入框
 */
@property (nonatomic, strong) WQTextInputViewWithOutImage *textInputViewWithOutImage;

@end

@implementation WQdetailsConrelooerViewController

- (instancetype)initWithmId:(NSString *)mid wqOrderType:(WQOrderType)orderType {
    if (self = [super init]) {
        self.midString = mid;
        self.wqOrderType = orderType;
    }
    return self;
}

- (instancetype)initWithindex:(WQOrderType)index {
    if (self = [super init]) {
        self.index = index;
    }
    return self;
}

- (instancetype)initWithmId:(NSString *)mid index:(WQOrderType )index {
    if (self = [super init]) {
        self.midString = mid;
        self.index = index;
        [self setupUI];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WQlongitudeuptodateNotifacation:) name:WQlongitudeuptodateNotifacation object:nil];
    
    // 键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [self loadCommentsList];
}

#pragma mark - 监听通知
- (void)keyboardWasShown:(NSNotification*)noti {
    __weak typeof(self) weakSelf = self;
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [weakSelf.textInputViewWithOutImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-rect.size.height);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)keyBoardWillHidden:(NSNotification *)noti {
    [self.textInputViewWithOutImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(100);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)loadCommentsList {
    NSString *urlString = @"api/need/comment/getNeedComment1List";
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"need_id"] = self.midString;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        self.comments = [NSArray yy_modelArrayWithClass:[WQDynamicLevelOncCommentModel class] json:response[@"comments"]];
        
        if (!self.comments.count && self.isCom) {
//            WQTopicDetailFooter * footer = [[NSBundle mainBundle] loadNibNamed:@"WQTopicDetailFooter" owner:self options:nil].lastObject;
//            footer.label.text = @"暂时还没有人评论";
//            footer.frame = CGRectMake(0, 0, kScreenWidth, 123);
//            self.tableview.tableFooterView = footer;
            
            WQDataEmptyView *footerView = [[WQDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 73)];
            footerView.textLabel.text = @"暂时还没有人评论";
            self.tableview.tableFooterView = footerView;
            
        }
        
        [self.tableview reloadData];
    }];
}

- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton {
    NSString *urlString = @"api/need/comment/createComments";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"content"] = view.inputtextView.text;
    params[@"need_id"] = self.midString;
    if (self.isOnccommen) {
        params[@"ori_comment_id"] = self.midString;
    }else {
        params[@"ori_comment_id"] = self.cid;
    }
    
    sendButton.enabled = NO;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            sendButton.enabled = YES;
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        //取消键盘第一响应者
        [view.inputtextView resignFirstResponder];
        view.inputtextView.text = nil;
        view.inputtextView.placeholder = @"聊聊您的想法";
        if ([response[@"success"] boolValue]) {
            sendButton.enabled = YES;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送成功" andAnimated:YES andTime:1.5];
            [self loadCommentsList];
        }else {
            sendButton.enabled = YES;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送不成功，请重试" andAnimated:YES andTime:1.5];
        }
    }];
}

- (void)wqCommentsBtnClick:(WQDynamicDetailsCommentTableViewCell *)cell {
    // 评论
    self.isOnccommen = NO;
    self.cid = cell.model.id;
    [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
}

- (void)wqHeadBtnClike:(WQDynamicDetailsCommentTableViewCell *)cell {
    // 头像的响应事件
    WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:cell.model.user_id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commentsBtnClick {
    // 评论
    self.isOnccommen = YES;
    [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
}

- (void)WQlongitudeuptodateNotifacation:(NSNotification *)notificaton {
    NSDictionary *dict = notificaton.userInfo;
    self.location = [dict[WQuptodateKey] MKCoordinateValue];
    self.params[@"geo_lat"] = @(self.location.latitude).description;
    self.params[@"geo_lng"] = @(self.location.longitude).description;
    [self loadData];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_tableview) {
        [_tableview reloadData];
    }
    [self setupUI];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self loadData];
    [self loadPeopleListData];
    
    self.navigationItem.title = @"需求详情";
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];

    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(leftBarbtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
}

// 返回三角的响应事件
- (void)leftBarbtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 初始化UI
- (void)setupUI {
    self.bidUserList = [[NSMutableSet alloc] init];
    
    WQorderHeadView *orderHeadView = [[WQorderHeadView alloc] initWithFrame:CGRectMake(0, 0, 0, 107) titleString:@"1111"];
    self.orderHeadView = orderHeadView;
    __weak typeof(self) weakSelf = self;
    // 编辑头像进入个人信息页
    [orderHeadView setHeadPortraitBlock:^{
        
        if (![self.response[@"truename"] boolValue]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"实名用户匿名状态" preferredStyle:UIAlertControllerStyleAlert];
            
            [weakSelf presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return ;
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
        // 是当前账户
        if ([self.response[@"user_id"] isEqualToString:im_namelogin]) {
            WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:weakSelf.response[@"user_id"]];

            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:weakSelf.response[@"user_id"]];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableHeaderView = orderHeadView;
    tableview.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    //[tableview registerNib:[UINib nibWithNibName:@"WQdetailsConrelooerTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [tableview registerClass:[WQorderDetailsTableViewCell class] forCellReuseIdentifier:cellID];
    [tableview registerClass:[WQaskButtonTableViewCell class] forCellReuseIdentifier:askBtncellID];
    [tableview registerNib:[UINib nibWithNibName:@"WQPeopleListTableViewCell" bundle:nil] forCellReuseIdentifier:PeopleListCellid];
    [tableview registerClass:[WQBBSTableViewCell class] forCellReuseIdentifier:identifier];
    [tableview registerClass:[WQListTagTableViewCell class] forCellReuseIdentifier:viewerCellId];
    [tableview registerClass:[WQDynamicDetailsCommentTableViewCell class] forCellReuseIdentifier:commentIdentifier];
    
    if (@available(iOS 11.0, *)) {
        tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.tableview = tableview;
    // 设置自动行高
    tableview.rowHeight = UITableViewAutomaticDimension;
    // 设置预估行高
    tableview.estimatedRowHeight = ghCellHeight;
    //取消分割线
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableview];
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
        make.bottom.equalTo(self.view);
    }];
    if (self.index == WQDefaultTasks) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            // 滚动位置
            [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        });
    }
    
    
    // 评论的输入框
    self.textInputViewWithOutImage = [[NSBundle mainBundle] loadNibNamed:@"WQTextInputViewWithOutImage" owner:self options:nil].lastObject;
    [self.view addSubview:self.textInputViewWithOutImage];
    self.textInputViewWithOutImage.delegate = self;
    self.textInputViewWithOutImage.inputtextView.placeholder = @"聊聊您的想法";
    self.textInputViewWithOutImage.inputtextView.delegate = self;
    self.textInputViewWithOutImage.userInteractionEnabled = YES;
    [self.textInputViewWithOutImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(100);
        make.height.lessThanOrEqualTo(@130);
        make.height.greaterThanOrEqualTo(@50);
    }];
}

#pragma mark -- WQdetailsBottomViewDelegate
- (void)askBtnClick:(WQdetailsBottomView *)bottomView {
    [self sessionBtnClike];
}

#pragma mark - 加载UI数据
- (void)loadData {
    [SVProgressHUD showWithStatus:@"加载中…"];
    NSString *urlString = @"api/need/getneedinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"nid"] = self.midString;
    self.params[@"geo_lat"] = [userDefaults objectForKey:@"geo_lat"];
    CGFloat longti = [WQLocationManager defaultLocationManager].currentLocation.coordinate.longitude;
    CGFloat lati = [WQLocationManager defaultLocationManager].currentLocation.coordinate.latitude;
    self.params[@"geo_lat"] = @(lati).description.length?@(lati).description:@(LATI_D).description;
    self.params[@"geo_lng"] =  @(longti).description.length?@(longti).description:@(LONTI_D).description;
    _params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    __weak typeof(self)weakSelf = self;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        self.response = response;
        NSLog(@"%@",response);
        
        if (![response[@"success"] boolValue]) {
            [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.5];
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"¥"
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x5288d8]}]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",response[@"money"]]
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],
                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x5288d8]}]];
        self.orderHeadView.moneyLabel.attributedText = str;
        
        weakSelf.imHuanxinid = response[@"user_id"];
        
        //    状态：STATUS_BIDDING(待接单);STATUS_BIDDED（进行中）;STATUS_FNISHED（已完成）

        if ([response[@"status"] isEqualToString:@"STATUS_FNISHED"]) {
            self.wqOrderType = WQOrderTypeFinish;
        }else if ([response[@"status"] isEqualToString:@"STATUS_BIDDED"]){
            self.wqOrderType = WQOrderTypeEnsure;
        }else if ([response[@"status"] isEqualToString:@"STATUS_BIDDING"]){
            self.wqOrderType = WQOrderTypeSelected;
        }
        [self addLeftBtn];
        
        WQHomeNearby *model = [WQHomeNearby yy_modelWithJSON:response];
        weakSelf.homemodel = model;
        //self.orderHeadView.timeLabel.text = model.finished_date;
        self.orderHeadView.aFewDegreesBackgroundLabel.height = YES;
        
        NSString *urlString = [imageUrlString stringByAppendingString:model.user_pic.length ? model.user_pic : @""];
        [self.orderHeadView.headPortraitImageView yy_setImageWithURL:[NSURL URLWithString:urlString] options:YYWebImageOptionShowNetworkActivity];
        self.orderHeadView.creditLabel.text = response[@"creditPoints"];
        
        self.orderHeadView.userNameLabel.text = model.user_name;
        NSArray *tagArray = response[@"user_tag"];
        if ([response[@"truename"] boolValue]) {
            switch (tagArray.count) {
                case 1:{
                    self.orderHeadView.tagOncLabel.hidden = NO;
                    self.orderHeadView.tagOncLabel.text = tagArray.firstObject;
                    self.orderHeadView.tagTwoLabel.hidden = YES;
                }
                    break;
                case 2:{
                    self.orderHeadView.tagOncLabel.hidden = NO;
                    self.orderHeadView.tagTwoLabel.hidden = NO;
                    self.orderHeadView.tagOncLabel.text = tagArray.firstObject;
                    self.orderHeadView.tagTwoLabel.text = tagArray.lastObject;
                }
                    break;
                case 0:{
                    self.orderHeadView.tagOncLabel.hidden = YES;
                    self.orderHeadView.tagTwoLabel.hidden = YES;
                }
                    break;
                default:
                    break;
            }
        }else {
            self.orderHeadView.tagOncLabel.hidden = YES;
            self.orderHeadView.tagTwoLabel.hidden = YES;
        }
        
        NSInteger time = [[NSString stringWithFormat:@"%@",response[@"left_secends"]] integerValue];
        self.orderHeadView.timeLabel.text = [WQTool getFinishTime:time];
        
        if (![WQDataSource sharedTool].verified && ![response[@"user_idcard_status"] isEqualToString:@"STATUS_VERIFIED"]) {
            self.orderHeadView.creditImageView.image = [UIImage imageNamed:@""];
            self.orderHeadView.creditLabel.hidden = YES;
            self.orderHeadView.aFewDegreesBackgroundLabel.hidden = YES;
        }
        
        self.orderHeadView.aFewDegreesBackgroundLabel.hidden = YES;
        NSInteger distance = [[NSString stringWithFormat:@"%zd",[response[@"distance"] integerValue]] integerValue];
        if (distance > 10000) {
            NSInteger kmPosition = distance / 1000;
            self.orderHeadView.distanceLabel.text = [[NSString stringWithFormat:@"%zd",kmPosition] stringByAppendingString:@"千米"];
        }else {
            self.orderHeadView.distanceLabel.text = [[NSString stringWithFormat:@"%zd",distance] stringByAppendingString:@"米"];
        }
        NSString *pointsString = [[NSString stringWithFormat:@"%@",response[@"user_creditscore"]] stringByAppendingString:@"分"];
        self.orderHeadView.creditLabel.text = pointsString;
        
        // 如果是bbs的话不显示询问的按钮
        if ([[NSString stringWithFormat:@"%@",response[@"category_level_1"]] isEqualToString:@"BBS"]) {
            [self.detailsBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            
            [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
            }];
        }
        
        [SVProgressHUD dismiss];
        [model setImagesBlock:^{
            [weakSelf.tableViewdetailOrderData addObject:weakSelf.homemodel];
            [weakSelf.tableview reloadData];
        }];
    }];
}

- (void)addLeftBtn
{
    if (self.wqOrderType == WQOrderTypeSelected) {
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dingdanshanchu"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteBtnClike)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }else{
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiangqunmingpian"] style:UIBarButtonItemStylePlain target:self action:@selector(sharBarBtnClike)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }

}

#pragma mark -- 获取接单人列表
- (void)loadPeopleListData {
    [SVProgressHUD showWithStatus:@"加载中…"];
    NSString *urlString = @"api/need/getneedbidder";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.PeopleListparams[@"nid"] = self.midString;
    _PeopleListparams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            //dispatch_group_enter(group);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        [SVProgressHUD dismiss];
        NSLog(@"%@",response);
        self.modelArray = [NSArray yy_modelArrayWithClass: NSClassFromString(@"WQPeopleListModel") json:response[@"bids"]].mutableCopy;
        [self.bidUserList removeAllObjects];
        for(WQPeopleListModel *people in self.bidUserList){
            [self.bidUserList addObject:people.user_id];
        }
        if (!self.modelArray.count) {

            WQDataEmptyView *footerView = [[WQDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 73)];
            footerView.textLabel.text = @"暂时还没有人接单";
            self.tableview.tableFooterView = footerView;
        }
        [self.tableview reloadData];
    }];

}

#pragma mark - 删除订单监听事件
- (void)deleteBtnClike {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除订单"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"取消");
                                                         }];
    UIAlertAction *destructiveButton =
    [UIAlertAction actionWithTitle:@"删除"
                             style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * _Nonnull action) {
                               NSString *urlString = @"api/need/deleteneed";
                               NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                               self.deleteneedParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
                               self.deleteneedParams[@"nid"] = self.midString;
                               [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_deleteneedParams completion:^(id response, NSError *error) {
                                   if (error) {
                                       NSLog(@"%@",error);
                                       return ;
                                   }
                                   if ([response isKindOfClass:[NSData class]]) {
                                       response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                                   }
                                   NSLog(@"%@",response);
                                   if ([response[@"success"] boolValue]) {
                                       //发送通知,让tableview刷新数据源
                                       [[NSNotificationCenter defaultCenter]postNotificationName:WQdeleteClike object:self userInfo:nil];
                                       UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"删除成功" preferredStyle:UIAlertControllerStyleAlert];
                                       
                                       [self presentViewController:alertVC animated:YES completion:^{
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               [alertVC dismissViewControllerAnimated:YES completion:nil];
                                               [self dismissViewControllerAnimated:YES completion:nil];
                                               [self.navigationController popViewControllerAnimated:YES];
                                           });
                                       }];
                                   }
                               }];
                           }];
    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
    
    [alertController addAction:cancelButton];
    [alertController addAction:destructiveButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 临时会话
- (void)sessionBtnClike {
    /*WQstrongSingleMessageViewController *messageVC = [[WQstrongSingleMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];*/
    

    EaseConversationListViewController *VC = [[EaseConversationListViewController alloc] initWithNid:self.homemodel.id needOwnerId:self.homemodel.user_id isFromTemp:YES bidUserList:self.bidUserList];
    if (self.wqOrderType == WQOrderTypeFinish) {
        VC.finished = YES;
    }
    
    
    
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 领取
- (void)wqToReceiveBtnClike {
    NSString *urlString = @"api/need/bidandfinishneed";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *toReceiveParams = [NSMutableDictionary dictionary];
    toReceiveParams[@"nid"] = self.midString;
    toReceiveParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    toReceiveParams[@"truename"] = @"true";
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:toReceiveParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        self.response = response;
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            
        }else{
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

- (void)commentsBtnOncClick {
    // 评论
    self.isOnccommen = YES;
//    self.midString = self.needsId;
    [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
}

- (void)wqtextcClick:(WQDynamicDetailsCommentTableViewCell *)cell {
    //    WQDynamicDetailsCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
    vc.nid = self.midString;
    vc.type = CommentDetaiTypeNeeds;
    vc.model = cell.model;
    vc.mid = cell.model.id;
    vc.isnid = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 1 && self.isCom) {
        WQDynamicDetailsCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
        vc.nid = self.midString;
        vc.type = CommentDetaiTypeNeeds;
        vc.model = cell.model;
        vc.mid = cell.model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 每个section下边多余间距处理
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.homemodel.category_level_1 isEqualToString:@"BBS"]) {
        if (indexPath.section == 0) {
            return UITableViewAutomaticDimension;
        }else {
            if (self.isCom) {
                return UITableViewAutomaticDimension;
            }else {
                return 80;
            }
        }
    }else {
        if (indexPath.section == 0) {
            return UITableViewAutomaticDimension;
        }else{
            if (self.isCom) {
                return UITableViewAutomaticDimension;
            }else {
                return 216;
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @" ";
    }else {
        return @"";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // BBS的话不显示接单者列表那一行
    if (section == 1 && [self.homemodel.category_level_1 isEqualToString:@"BBS"]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
        view.backgroundColor = WQ_BG_LIGHT_GRAY;
        // 白色的背景
        UIView *background = [[UIView alloc] init];
        background.backgroundColor = [UIColor whiteColor];
        [view addSubview:background];
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(view);
            make.top.equalTo(view.mas_top).offset(ghStatusCellMargin);
        }];
        
        // 接单者的按钮
        UIButton *tagBtn = [[UIButton alloc] init];
        tagBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        [tagBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateSelected];
        [tagBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        if (self.modelArray.count) {
            [tagBtn setTitle:[NSString stringWithFormat:@"领取者  %zd",self.modelArray.count] forState:UIControlStateNormal];
        }else {
            [tagBtn setTitle:@"领取者" forState:UIControlStateNormal];
        }
        if (!self.isCom) {
            tagBtn.selected = YES;
        }
        [background addSubview:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(background.mas_centerY);
            make.left.equalTo(background.mas_left).offset(ghSpacingOfshiwu);
        }];
        
        // 评论
        UIButton *comBtn = [[UIButton alloc] init];
        comBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        [comBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        [comBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateSelected];
        if (self.isCom) {
            comBtn.selected = YES;
        }
        if (self.comments.count) {
            NSInteger i = self.comments.count;
            for (WQDynamicLevelOncCommentModel *model in self.comments) {
                i += model.comment_children_count;
            }
            [comBtn setTitle:[NSString stringWithFormat:@"评论  %zd",i] forState:UIControlStateNormal];
        }else {
            [comBtn setTitle:@"评论" forState:UIControlStateNormal];
        }
        [background addSubview:comBtn];
        [comBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(background.mas_centerY);
            make.left.equalTo(tagBtn.mas_right).offset(25);
        }];
        
        [tagBtn addClickAction:^(UIButton * _Nullable sender) {
            self.isCom = NO;
            if (!self.modelArray.count) {
//                WQTopicDetailFooter * footer = [[NSBundle mainBundle] loadNibNamed:@"WQTopicDetailFooter" owner:self options:nil].lastObject;
//                footer.label.text = @"暂时还没有人接单";
//                footer.frame = CGRectMake(0, 0, kScreenWidth, 123);
//                self.tableview.tableFooterView = footer;
                WQDataEmptyView *footerView = [[WQDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 73)];
                footerView.textLabel.text = @"暂时还没有人接单";
                self.tableview.tableFooterView = footerView;
            }else {
                self.tableview.tableFooterView = [UIView new];
            }
            [self.tableview reloadData];
            sender.selected = YES;
            comBtn.selected = NO;
        }];
        [comBtn addClickAction:^(UIButton * _Nullable sender) {
            self.isCom = YES;
            if (!self.comments.count) {
//                WQTopicDetailFooter * footer = [[NSBundle mainBundle] loadNibNamed:@"WQTopicDetailFooter" owner:self options:nil].lastObject;
//                footer.label.text = @"暂时还没有人评论";
//                footer.frame = CGRectMake(0, 0, kScreenWidth, 123);
//                self.tableview.tableFooterView = footer;
                WQDataEmptyView *footerView = [[WQDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 73)];
                footerView.textLabel.text = @"暂时还没有人评论";
                self.tableview.tableFooterView = footerView;
            }else {
                self.tableview.tableFooterView = [UIView new];
            }
            
            [self.tableview reloadData];
            tagBtn.selected = NO;
            sender.selected = YES;
        }];
        
        UIButton *commentsBtn = [[UIButton alloc] init];
        commentsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        commentsBtn.layer.cornerRadius = 5;
        commentsBtn.layer.masksToBounds = YES;
        commentsBtn.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
        [commentsBtn setImage:[UIImage imageNamed:@"xiepinglun"] forState:UIControlStateNormal];
        [commentsBtn setTitleColor:[UIColor colorWithHex:0x9872ca] forState:UIControlStateNormal];
        [commentsBtn addTarget:self action:@selector(commentsBtnOncClick) forControlEvents:UIControlEventTouchUpInside];
        [commentsBtn setTitle:@" 写评论" forState:UIControlStateNormal];
        [view addSubview:commentsBtn];
        [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 25));
            make.centerY.equalTo(tagBtn.mas_centerY);
            make.right.equalTo(view.mas_right).offset(-ghSpacingOfshiwu);
        }];
        
        if (self.isCom) {
            commentsBtn.hidden = NO;
        }else {
            commentsBtn.hidden = YES;
        }
        
        // 底部分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        [background addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(background);
            make.height.offset(0.5);
        }];
        
        return view;
    }
    
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
        view.backgroundColor = WQ_BG_LIGHT_GRAY;
        // 白色的背景
        UIView *background = [[UIView alloc] init];
        background.backgroundColor = [UIColor whiteColor];
        [view addSubview:background];
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(view);
            make.top.equalTo(view.mas_top).offset(ghStatusCellMargin);
        }];
        
        // 接单者的按钮
        UIButton *tagBtn = [[UIButton alloc] init];
        tagBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        [tagBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateSelected];
        [tagBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        if (self.modelArray.count) {
            [tagBtn setTitle:[NSString stringWithFormat:@"接单人 %zd",self.modelArray.count] forState:UIControlStateNormal];
        }else {
            [tagBtn setTitle:@"接单人" forState:UIControlStateNormal];
        }
        if (!self.isCom) {
            tagBtn.selected = YES;
        }
        [background addSubview:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(background.mas_centerY);
            make.left.equalTo(background.mas_left).offset(ghSpacingOfshiwu);
        }];
        
        // 评论
        UIButton *comBtn = [[UIButton alloc] init];
        comBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        [comBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        [comBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateSelected];
        if (self.isCom) {
            comBtn.selected = YES;
        }
        if (self.comments.count) {
            NSInteger i = self.comments.count;
            for (WQDynamicLevelOncCommentModel *model in self.comments) {
                i += model.comment_children_count;
            }
            [comBtn setTitle:[NSString stringWithFormat:@"评论  %zd",i] forState:UIControlStateNormal];
        }else {
            [comBtn setTitle:@"评论" forState:UIControlStateNormal];
        }
        
        [background addSubview:comBtn];
        [comBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(background.mas_centerY);
            make.left.equalTo(tagBtn.mas_right).offset(25);
        }];

        [tagBtn addClickAction:^(UIButton * _Nullable sender) {
            self.isCom = NO;
            if (!self.modelArray.count) {
                WQDataEmptyView *footerView = [[WQDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 73)];
                footerView.textLabel.text = @"暂时还没有人接单";
                self.tableview.tableFooterView = footerView;
            }else {
                self.tableview.tableFooterView = [UIView new];
            }
            [self.tableview reloadData];
            sender.selected = YES;
            comBtn.selected = NO;
        }];
        [comBtn addClickAction:^(UIButton * _Nullable sender) {
            self.isCom = YES;
            if (!self.comments.count) {
//                WQTopicDetailFooter * footer = [[NSBundle mainBundle] loadNibNamed:@"WQTopicDetailFooter" owner:self options:nil].lastObject;
//                footer.label.text = @"暂时还没有人评论";
//                footer.frame = CGRectMake(0, 0, kScreenWidth, 123);
//                self.tableview.tableFooterView = footer;
                WQDataEmptyView *footerView = [[WQDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 73)];
                footerView.textLabel.text = @"暂时还没有人评论";
                self.tableview.tableFooterView = footerView;
            }else {
                self.tableview.tableFooterView = [UIView new];
            }
            [self.tableview reloadData];
            tagBtn.selected = NO;
            sender.selected = YES;
        }];
        
        UIButton *commentsBtn = [[UIButton alloc] init];
        commentsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        commentsBtn.layer.cornerRadius = 5;
        commentsBtn.layer.masksToBounds = YES;
        commentsBtn.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
        [commentsBtn setImage:[UIImage imageNamed:@"xiepinglun"] forState:UIControlStateNormal];
        [commentsBtn setTitleColor:[UIColor colorWithHex:0x9872ca] forState:UIControlStateNormal];
        [commentsBtn addTarget:self action:@selector(commentsBtnOncClick) forControlEvents:UIControlEventTouchUpInside];
        [commentsBtn setTitle:@" 写评论" forState:UIControlStateNormal];
        [view addSubview:commentsBtn];
        [commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 25));
            make.centerY.equalTo(tagBtn.mas_centerY);
            make.right.equalTo(view.mas_right).offset(-ghSpacingOfshiwu);
        }];
        
        if (self.isCom) {
            commentsBtn.hidden = NO;
        }else {
            commentsBtn.hidden = YES;
        }

        // 底部分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        [background addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(background);
            make.height.offset(0.5);
        }];
        
        return view;
    }else {
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // BBS的话不显示接单者列表那一行
    if (section == 1 && [self.homemodel.category_level_1 isEqualToString:@"BBS"]) {
        return 50;
    }

    if (section == 1) {
        return 58;
    }else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([self.homemodel.category_level_1 isEqualToString:@"BBS"]) {
//        return 2;
//    }else {
        return 2;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.homemodel.category_level_1 isEqualToString:@"BBS"]) {
        if (section == 0) {
            return 1;
        }else {
            if (self.isCom) {
                return self.comments.count;
            }else {
                return self.modelArray.count;
            }
        }
    }else {
        if (section == 0) {
            return 1;
        }else {
            if (self.isCom) {
                return self.comments.count;
            }else {
                return self.modelArray.count;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // BBS的
    if ([self.homemodel.category_level_1 isEqualToString:@"BBS"]) {
        if (indexPath.section == 0) {
            WQorderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isGroup = NO;
            cell.isYourOwn = YES;
            cell.delegate = self;
            cell.model = self.homemodel;
            return cell;
        }else if (indexPath.section == 1) {
//            WQListTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:viewerCellId forIndexPath:indexPath];
//            NSString *guankanrenshu = @"领取人数: ";
//            cell.watchLabel.text = [[[guankanrenshu stringByAppendingString:self.homemodel.bidded_count] stringByAppendingString:@"/"] stringByAppendingString:self.homemodel.total_count];
//            return cell;
            if (self.isCom) {
                WQDynamicDetailsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier forIndexPath:indexPath];
                cell.delegate = self;
                cell.praiseBtn.hidden = YES;
                
                cell.model = self.comments[indexPath.row];
                
                return cell;
            }
            
            WQBBSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.modelArray[indexPath.row];
            if (indexPath.row == self.modelArray.count -1) {
                [cell.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.left.bottom.equalTo(cell.contentView);
                    make.height.offset(0.5);
                }];
            }
            return cell;
            
        }
        
    }else {
    }
//    状态：STATUS_BIDDING(待接单);STATUS_BIDDED（进行中）;STATUS_FNISHED（已完成）
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        WQorderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = self.homemodel;
        return cell;
    }else{
        
        if (self.isCom) {
            WQDynamicDetailsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.praiseBtn.hidden = YES;
            
            cell.model = self.comments[indexPath.row];
            
            return cell;
        }
        
        WQPeopleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PeopleListCellid];
        if (cell == nil) { 
            cell = [[WQPeopleListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PeopleListCellid];
        }
        if (self.wqOrderType == WQOrderTypeSelected) {
            cell.cancelBtn.hidden = YES;
            cell.cancelImage.hidden = YES;
        }
        cell.model = self.modelArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 点击头像
        __weak typeof(cell) weakCell = cell;
        [cell setHeadPortraitBlock:^{
            //[weakSelf clickOnThePicture:weakCell.model.truename user_id:weakCell.model.user_id];
            [weakSelf clickOnThePicture:weakCell.model.truename user_id:weakCell.model.user_id user_idcard_stauts:weakCell.model.user_idcard_stauts];
        }];
        
        // 点击头像
        [cell setTouxiangBtnClikeBlock:^{
            WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            //[weakSelf clickOnThePicture:cell.model.truename user_id:cell.model.user_id];
            [weakSelf clickOnThePicture:weakCell.model.truename user_id:weakCell.model.user_id user_idcard_stauts:weakCell.model.user_idcard_stauts];
        }];
        
        // 环信单聊
        cell.huihuaClikeBlock = ^ {
            WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            WQPeopleListModel * model = cell.model;
            BOOL isBidFinished = NO;
            if ([model.work_status isEqualToString:@"WORK_STATUS_DONE"] ) {
                isBidFinished = YES;
            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *fromName;
            NSString *fromPic;
            if(weakSelf.homemodel.truename){
                fromName = [userDefaults objectForKey:@"true_name"];
                fromPic = [userDefaults objectForKey:@"pic_truename"];
            }else{
                fromName = [userDefaults objectForKey:@"flower_name"];
                fromPic = [userDefaults objectForKey:@"flower_name"];
            }
            [weakSelf pushChatVC:cell.model.user_id needId:weakSelf.homemodel.id needOwnerId:[EMClient sharedClient].currentUsername fromName:fromName fromPic:fromPic toName:cell.model.user_name toPic:cell.model.user_pic isFromTemp:YES isTrueName:weakSelf.homemodel.truename isBidTureName:cell.model.truename bidFinished:isBidFinished];
        };
        
        // 发单者申请取消
        [cell setCancelBntClikeBlick:^{
            WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"申请取消交易"
                                                                                     message:@""
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"关闭"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     NSLog(@"关闭");
                                                                 }];
            UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"申请"
                                                                        style:UIAlertActionStyleDestructive
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                          [weakSelf toApplyForCancellation:cell.model.id work_status:cell.model.work_status];
                                                                      }];
            [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
            [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
            //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
            
            [alertController addAction:cancelButton];
            [alertController addAction:destructiveButton];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }];
        
//        [cell.SelectedBtn setTitle:self.btnTitleArray[self.wqOrderType] forState:0];
        if (self.wqOrderType == WQOrderTypeFinish) {
            cell.SelectedBtn.hidden = YES;
        }else{
            cell.SelectedBtn.hidden = NO;
        }
        
        // 选定他
        [cell setXuandingClikeBlock:^{
            WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            /*if ([self.workStatusDone isEqualToString:@"WORK_STATUS_PRE_DONE"]) {
                return ;
            }
            if ([self.work_status isEqualToString:@"WORK_STATUS_PRE_DONE"] || [self.workStatusArbiration isEqualToString:@"WORK_STATUS_ARBIRATION"]) {
                return ;
            }*/
            
            if (cell.model.work_status.length) {
                if ([cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_DONE"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_ARBIRATION"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_DOING"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_DONE"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_NOT_DONE" ] || [cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_NOT_DONE"]) {
                    return ;
                }
            }
            
          
            if (weakSelf.wqOrderType == WQOrderTypeSelected) {
                NSString *urlString = @"api/need/setneedbidder";
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                NSString *xuqiuId = cell.model.id;
                weakSelf.modifyParams[@"nbid"] = xuqiuId;
                _modifyParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
                [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_modifyParams completion:^(id response, NSError *error) {
                    if (error) {
                        NSLog(@"%@",error);
                        return ;
                    }
                    if ([response isKindOfClass:[NSData class]]) {
                        response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                    }
                    NSLog(@"%@",response);
                    if ([response[@"success"] boolValue]) {
                        //发送通知,让tableview刷新数据源
                        [[NSNotificationCenter defaultCenter] postNotificationName:WQdeleteClike object:weakSelf userInfo:nil];
                        
                        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"选定对方成功，请互相联系" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [weakSelf presentViewController:alertVC animated:YES completion:^{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [alertVC dismissViewControllerAnimated:YES completion:nil];
                                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            });
                        }];
                    }else{
                        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"该用户已被选定" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [weakSelf presentViewController:alertVC animated:YES completion:^{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [alertVC dismissViewControllerAnimated:YES completion:nil];
                                [weakSelf dismissViewControllerAnimated:YES completion:^{
                                }];
                            });
                        }];
                    }
                }];
            }else if (weakSelf.wqOrderType == WQOrderTypeEnsure){
                /*if ([cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_NOT_DONE"]) {
                    return ;
                }*/
                if ([cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_DONE"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_ARBIRATION"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_DOING"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_DONE"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_NOT_DONE"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_NOT_DONE"]) {
                    return ;
                }

                NSString *urlString = @"api/need/changebiddedneedworkstatus";
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *nbid = weakSelf.response[@"id"];
                weakSelf.confirmParams[@"nbid"] = nbid;
                _confirmParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
                _confirmParams[@"work_status"] = @"WORK_STATUS_DONE";
                [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_confirmParams completion:^(id response, NSError *error) {
                    if (error) {
                        NSLog(@"%@",error);
                        return ;
                    }
                    if ([response isKindOfClass:[NSData class]]) {
                        response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                    }
                    NSLog(@"%@",response);
                    if ([response[@"success"]boolValue]) {
                        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"已确认完成" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [weakSelf presentViewController:alertVC animated:YES completion:^{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [alertVC dismissViewControllerAnimated:YES completion:nil];
                                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                            });
                        }];
                    }else{
                        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"选定不成功" preferredStyle:UIAlertControllerStyleAlert];
                        [weakSelf presentViewController:alertVC animated:YES completion:^{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [alertVC dismissViewControllerAnimated:YES completion:nil];
                                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                            });
                        }];
                    }
                }];
            }
        }];
        
        if ([cell.model.work_status isEqualToString:@"WORK_STATUS_DOING"]) {
            cell.rightImage.hidden = NO;
            [cell.SelectedBtn setTitle:@"同意付款" forState:UIControlStateNormal];
            [cell.cancelBtn setTitle:@"申请取消交易" forState:UIControlStateNormal];
            [cell.cancelImage setImage:[UIImage imageNamed:@"dingdanshenqingquxiaojiaoyi"] forState:UIControlStateNormal];
            [cell.selectedImage setImage:[UIImage imageNamed:@"dingdanquerenwancheng"]];
            cell.SelectedBtn.hidden = NO;
            cell.cancelBtn.hidden = NO;
            cell.cancelImage.hidden = NO;
            cell.SelectedBtn.enabled = NO;
            
            // 选定完后的状态为联系接单人   申请取消交易  确认完成的状态
            [cell.cancelImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.contentView.mas_centerX);
                make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                make.height.offset(15);
            }];
            [cell.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.cancelImage.mas_centerX);
                make.top.equalTo(cell.cancelImage.mas_bottom).offset(kScaleX(-2));
            }];
            
            [cell.temporaryImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(kScaleY(55));
                make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleY(ghSpacingOfshiwu));
            }];
            
            [cell.selectedImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(kScaleY(-55));
                make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleY(ghSpacingOfshiwu));
            }];

            
            //[cell.SelectedBtn addTarget:self action:@selector(agreeToPayment) forControlEvents:UIControlEventTouchUpInside];
            [cell.SelectedBtn addClickAction:^(UIButton * _Nullable sender) {
                WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"本需求已确认完成"
                                                                                         message:@""
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                         NSLog(@"取消");
                                                                     }];
                UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"确定"
                                                                            style:UIAlertActionStyleDestructive
                                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                                              [weakSelf agreeToPaymenNeedId:cell.model.id];
                                                                          }];
                [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
                [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
                
                [alertController addAction:cancelButton];
                [alertController addAction:destructiveButton];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            }];
            //[cell.cancelBtn addTarget:self action:@selector(applyForArbitration) forControlEvents:UIControlEventTouchUpInside];
            [cell.cancelBtn addClickAction:^(UIButton * _Nullable sender) {
                WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"申请取消交易"
                                                                                         message:@""
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"关闭"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                         NSLog(@"关闭");
                                                                     }];
                UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"申请"
                                                                            style:UIAlertActionStyleDestructive
                                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                                              [weakSelf toApplyForCancellation:cell.model.id work_status:cell.model.work_status];
                                                                          }];
                [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
                [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
                //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
                
                [alertController addAction:cancelButton];
                [alertController addAction:destructiveButton];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                //[weakSelf applyForArbitrationNbid:cell.model.id work_status:cell.model.work_status];
                //[weakSelf toApplyForCancellation:cell.model.id work_status:cell.model.work_status];
            }];
        }
            if ([cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_DONE"] ) {
                cell.rightImage.hidden = NO;
                [cell.SelectedBtn setTitle:@"确认完成" forState:UIControlStateNormal];
                [cell.cancelBtn setTitle:@"申请仲裁" forState:UIControlStateNormal];
                [cell.cancelImage setImage:[UIImage imageNamed:@"shenqingzhongcaihui"] forState:UIControlStateNormal];
                cell.SelectedBtn.hidden = NO;
                cell.cancelBtn.hidden = NO;
                cell.cancelImage.hidden = NO;
                cell.SelectedBtn.enabled = NO;
                
                [cell.cancelImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(cell.contentView.mas_centerX);
                    make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                    make.height.offset(15);
                }];
                [cell.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(cell.cancelImage.mas_centerX);
                    make.top.equalTo(cell.SelectedBtn);
                }];
                
                [cell.temporaryImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView.mas_left).offset(kScaleY(55));
                    make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleY(ghSpacingOfshiwu));
                }];
                
                [cell.selectedImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(kScaleY(-55));
                    make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleY(ghSpacingOfshiwu));
                }];
                
                //[cell.SelectedBtn addTarget:self action:@selector(agreeToPayment) forControlEvents:UIControlEventTouchUpInside];
                [cell.SelectedBtn addClickAction:^(UIButton * _Nullable sender) {
                    WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"本需求已确认完成"
                                                                                             message:@""
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                             NSLog(@"取消");
                                                                         }];
                    UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"确定"
                                                                                style:UIAlertActionStyleDestructive
                                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                                  [weakSelf agreeToPaymenNeedId:cell.model.id];
                                                                              }];
                    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
                    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
                    
                    [alertController addAction:cancelButton];
                    [alertController addAction:destructiveButton];
                    [weakSelf presentViewController:alertController animated:YES completion:nil];
                }];
                //[cell.cancelBtn addTarget:self action:@selector(applyForArbitration) forControlEvents:UIControlEventTouchUpInside];
                [cell.cancelBtn addClickAction:^(UIButton * _Nullable sender) {
                    WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    //[weakSelf applyForArbitrationNbid:cell.model.id work_status:cell.model.work_status];
                }];
                
            }
        
        if ([cell.model.work_status isEqualToString:@"WORK_STATUS_ARBIRATION"]) {
            cell.rightImage.hidden = NO;
            [cell.SelectedBtn setTitle:@" 仲裁中" forState:UIControlStateNormal];
            [cell.SelectedBtn setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
            [cell.selectedImage setImage:[UIImage imageNamed:@"fadanshenqingzhongcaihui"]];
            
            [cell.temporaryImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(kScaleY(85));
                make.top.equalTo(cell.lineView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            
            [cell.selectedImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(kScaleY(-85));
                make.top.equalTo(cell.lineView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            
            //[cell.SelectedBtn addTarget:self action:@selector(applyForArbitration) forControlEvents:UIControlEventTouchUpInside];
            [cell.SelectedBtn addClickAction:^(UIButton * _Nullable sender) {
                WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                //[self agreeToPaymenNeedId:cell.model.id];
                [weakSelf applyForArbitrationNbid:cell.model.id work_status:cell.model.work_status];
            }];
            cell.SelectedBtn.enabled = YES;
            cell.cancelBtn.hidden = YES;
            cell.cancelImage.hidden = YES;
        }
        
        if (cell.model.isfeedbacked) {
            [cell.SelectedBtn setTitle:@"已评价" forState:UIControlStateNormal];
            cell.selectedImage.image = [UIImage imageNamed:@"pingjia"];
            cell.cancelBtn.hidden = YES;
            cell.SelectedBtn.enabled = YES;
            cell.cancelImage.hidden = YES;
        }
        
        if ([cell.model.work_status isEqualToString:@"WORK_STATUS_DONE"]) {
            cell.rightImage.hidden = NO;
            cell.SelectedBtn.hidden = NO;
            cell.selectedImage.hidden = NO;
            [cell.SelectedBtn setTitle:@"评价" forState:UIControlStateNormal];
            cell.cancelBtn.hidden = YES;
            cell.cancelImage.hidden = YES;
            [cell.cancelImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            //[cell.cancelImage setTitle:@"|" forState:UIControlStateNormal];
            [cell.cancelImage setTitleColor:[UIColor colorWithHex:0Xcbcbcb] forState:UIControlStateNormal];
            [cell.cancelImage.titleLabel setFont:[UIFont systemFontOfSize:30]];
            if (![cell.model.can_feedback boolValue]) {
                [cell.SelectedBtn setTitle:@"已评价" forState:UIControlStateNormal];
                //cell.SelectedBtn.enabled = YES;
                cell.selectedImage.image = [UIImage imageNamed:@"pingjia"];
                cell.cancelBtn.hidden = YES;
                cell.cancelImage.hidden = YES;
                cell.cancelImage.hidden = NO;
                [cell.cancelImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                //[cell.cancelImage setTitle:@"|" forState:UIControlStateNormal];
                [cell.cancelImage setTitleColor:[UIColor colorWithHex:0Xcbcbcb] forState:UIControlStateNormal];
                [cell.cancelImage.titleLabel setFont:[UIFont systemFontOfSize:30]];
                [cell.SelectedBtn setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
            }else{
                [cell.SelectedBtn addClickAction:^(UIButton * _Nullable sender) {
                    WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    WQevaluateViewController *evaluateVC = [[WQevaluateViewController alloc] initWithneedId:cell.model.id];
                    evaluateVC.delegate = self;
                    [weakSelf.navigationController pushViewController:evaluateVC animated:YES];
                }];
            }
        }
        
        if ([cell.model.work_status isEqualToString:@"WORK_STATUS_DOING"]) {
            cell.cancelImage.hidden = NO;
            cell.cancelBtn.hidden = NO;
            [cell.SelectedBtn setTitle:@"确认完成" forState:UIControlStateNormal];
            [cell.cancelBtn setTitle:@"申请取消交易" forState:UIControlStateNormal];
            [cell.cancelImage setImage:[UIImage imageNamed:@"dingdanshenqingquxiaojiaoyi"] forState:UIControlStateNormal];
            [cell.cancelImage setTitle:@"" forState:UIControlStateNormal];
            [cell.selectedImage setImage:[UIImage imageNamed:@"dingdanquerenwancheng"]];
            
            
            // 选定完后的状态为联系接单人   申请取消交易  确认完成的状态
            [cell.cancelImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.contentView.mas_centerX);
                make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                make.height.offset(15);
            }];
            [cell.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.cancelImage.mas_centerX);
                make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
            }];
            
            [cell.temporaryImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(kScaleY(55));
                make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleY(ghSpacingOfshiwu));
            }];
            
            [cell.selectedImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(kScaleY(-55));
                make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleY(ghSpacingOfshiwu));
            }];
            
//            [cell.selectedImage mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(cell.contentView.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
//                make.top.equalTo(cell.lineView.mas_bottom).offset(kScaleY(ghSpacingOfshiwu));
//            }];
//            
//            [cell.SelectedBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(cell.selectedImage.mas_centerX);
//                make.top.equalTo(cell.selectedImage.mas_bottom).offset(kScaleX(-2));
//            }];
            
            cell.rightImage.hidden = NO;
            [cell.SelectedBtn addClickAction:^(UIButton * _Nullable sender) {
                WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"本需求已确认完成"
                                                                                         message:@""
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                         NSLog(@"取消");
                                                                     }];
                UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"确定"
                                                                            style:UIAlertActionStyleDestructive
                                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                                              [self agreeToPaymenNeedId:cell.model.id];
                                                                          }];
                [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
                [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
                //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
                
                [alertController addAction:cancelButton];
                [alertController addAction:destructiveButton];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            }];
            cell.cancelBtn.hidden = NO;
            cell.cancelImage.hidden = NO;
        }
        if ([cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_NOT_DONE"]) {
            [cell.SelectedBtn setTitle:@"等待接单人确认取消" forState:UIControlStateNormal];
            [cell.selectedImage setImage:[UIImage imageNamed:@"fadandengdaishijian"]];
            cell.cancelBtn.hidden = YES;
            cell.cancelImage.hidden = YES;
            //[cell.cancelImage setTitle:@"|" forState:UIControlStateNormal];
            [cell.cancelImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [cell.cancelImage.titleLabel setFont:[UIFont systemFontOfSize:30]];
            [cell.cancelImage setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
            cell.SelectedBtn.enabled = NO;
            cell.cancelImage.hidden = NO;
            [cell.SelectedBtn setEnabled:NO];
            
            [cell.SelectedBtn setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
            
            [cell.temporaryImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(kScaleY(85));
                make.top.equalTo(cell.lineView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            
            [cell.selectedImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(kScaleY(-85));
                make.top.equalTo(cell.lineView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
        }
        
        if ([cell.model.status isEqualToString:@"STATUS_FNISHED"]) {
            [cell.SelectedBtn setTitle:@"评价" forState:UIControlStateNormal];
            [cell.selectedImage setImage:[UIImage imageNamed:@"pingjiagaoliang"]];
            cell.cancelBtn.hidden = YES;
            cell.cancelImage.hidden = YES;
            if (![cell.model.can_feedback boolValue]) {
                [cell.SelectedBtn setTitle:@"已评价" forState:UIControlStateNormal];
                cell.selectedImage.image = [UIImage imageNamed:@"pingjia"];
                cell.cancelBtn.hidden = YES;
                cell.SelectedBtn.enabled = NO;
                cell.cancelImage.hidden = YES;
                
                //[cell.cancelImage setTitle:@"|" forState:UIControlStateNormal];
                [cell.cancelImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [cell.cancelImage.titleLabel setFont:[UIFont systemFontOfSize:30]];
                [cell.cancelImage setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
                [cell.SelectedBtn setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
            }else{
                [cell.SelectedBtn addClickAction:^(UIButton * _Nullable sender) {
                    WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    WQevaluateViewController *evaluateVC = [[WQevaluateViewController alloc] initWithneedId:cell.model.id];
                    evaluateVC.delegate = self;
                    [weakSelf.navigationController pushViewController:evaluateVC animated:YES];
                    return ;
                }];
            }
        } else {
            cell.SelectedBtn.enabled = YES;
            cell.cancelBtn.enabled = YES;
            cell.temporaryBtn.enabled = YES;
            cell.huihuaClikeBlock = ^{
                WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                WQPeopleListModel * model = cell.model;
                BOOL isBidFinished = NO;
                if ([model.work_status isEqualToString:@"WORK_STATUS_DONE"] ) {
                    isBidFinished = YES;
                }
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *fromName;
                NSString *fromPic;
                if(weakSelf.homemodel.truename){
                    fromName = [userDefaults objectForKey:@"true_name"];
                    fromPic = [userDefaults objectForKey:@"pic_truename"];
                }else{
                    fromName = [userDefaults objectForKey:@"flower_name"];
                    fromPic = [userDefaults objectForKey:@"flower_name"];
                }
                [weakSelf pushChatVC:cell.model.user_id needId:weakSelf.homemodel.id needOwnerId:[EMClient sharedClient].currentUsername fromName:fromName fromPic:fromPic toName:cell.model.user_name toPic:cell.model.user_pic isFromTemp:NO isTrueName:weakSelf.homemodel.truename isBidTureName:cell.model.truename bidFinished:isBidFinished];

            };
            
            cell.cancelBntClikeBlick = ^{
                if ([weakCell.model.work_status isEqualToString:@"WORK_STATUS_PRE_DONE"]) {
//                    WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
//                                                                                             message:@""
//                                                                                      preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"关闭"
//                                                                           style:UIAlertActionStyleCancel
//                                                                         handler:^(UIAlertAction * _Nonnull action) {
//                                                                             NSLog(@"关闭");
//                                                                         }];
//                    UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"申请"
//                                                                                style:UIAlertActionStyleDestructive
//                                                                              handler:^(UIAlertAction * _Nonnull action) {
//                                                                                  [weakSelf toApplyForCancellation:cell.model.id work_status:cell.model.work_status];
                                                                                  [weakSelf applyForArbitrationNbid:weakCell.model.id work_status:weakCell.model.work_status];
//                                                                              }];
//                    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
//                    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
//                    //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
//                    
//                    [alertController addAction:cancelButton];
//                    [alertController addAction:destructiveButton];
//                    [weakSelf presentViewController:alertController animated:YES completion:nil];
                }else {
                    WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"申请取消交易"
                                                                                             message:@""
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"关闭"
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                             NSLog(@"关闭");
                                                                         }];
                    UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"申请"
                                                                                style:UIAlertActionStyleDestructive
                                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                                  [weakSelf toApplyForCancellation:cell.model.id work_status:cell.model.work_status];
                                                                                  //[weakSelf applyForArbitrationNbid:cell.model.id work_status:cell.model.work_status];
                                                                              }];
                    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
                    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
                    //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
                    
                    [alertController addAction:cancelButton];
                    [alertController addAction:destructiveButton];
                    [weakSelf presentViewController:alertController animated:YES completion:nil];
                }

            };
            
            cell.xuandingClikeBlock = ^{
                WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                /*if ([self.workStatusDone isEqualToString:@"WORK_STATUS_PRE_DONE"]) {
                 return ;
                 }
                 if ([self.work_status isEqualToString:@"WORK_STATUS_PRE_DONE"] || [self.workStatusArbiration isEqualToString:@"WORK_STATUS_ARBIRATION"]) {
                 return ;
                 }*/
                
                if (cell.model.work_status.length) {
                    if ([cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_DONE"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_ARBIRATION"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_DOING"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_DONE"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_NOT_DONE"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_NOT_DONE"]) {
                        return ;
                    }
                }
                
                
                if (weakSelf.wqOrderType == WQOrderTypeSelected || weakSelf.wqOrderType == WQHomePushToDetailsVc) {
                    NSString *urlString = @"api/need/setneedbidder";
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    NSString *xuqiuId = cell.model.id;
                    weakSelf.modifyParams[@"nbid"] = xuqiuId;
                    _modifyParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
                    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_modifyParams completion:^(id response, NSError *error) {
                        if (error) {
                            NSLog(@"%@",error);
                            return ;
                        }
                        if ([response isKindOfClass:[NSData class]]) {
                            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                        }
                        NSLog(@"%@",response);
                        if ([response[@"success"] boolValue]) {
                            //发送通知,让tableview刷新数据源
                            [[NSNotificationCenter defaultCenter] postNotificationName:WQdeleteClike object:weakSelf userInfo:nil];
                            
                            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"选定对方成功，请互相联系" preferredStyle:UIAlertControllerStyleAlert];
                            
                            [weakSelf presentViewController:alertVC animated:YES completion:^{
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                });
                            }];
                        }else{
                            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"该用户已被选定" preferredStyle:UIAlertControllerStyleAlert];
                            
                            [weakSelf presentViewController:alertVC animated:YES completion:^{
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                                    }];
                                });
                            }];
                        }
                    }];
                }else if (weakSelf.wqOrderType == WQOrderTypeEnsure){
                    /*if ([cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_NOT_DONE"]) {
                     return ;
                     }*/
                    if ([cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_DONE"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_ARBIRATION"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_DOING"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_DONE"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_NOT_DONE"]) {
                        return ;
                    }
                    if ([cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_NOT_DONE"]) {
                        return;
                    }
                    
                    NSString *urlString = @"api/need/changebiddedneedworkstatus";
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    NSString *nbid = weakSelf.response[@"id"];
                    weakSelf.confirmParams[@"nbid"] = nbid;
                    _confirmParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
                    _confirmParams[@"work_status"] = @"WORK_STATUS_DONE";
                    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_confirmParams completion:^(id response, NSError *error) {
                        if (error) {
                            NSLog(@"%@",error);
                            return ;
                        }
                        if ([response isKindOfClass:[NSData class]]) {
                            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                        }
                        NSLog(@"%@",response);
                        if ([response[@"success"]boolValue]) {
                            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"已确认完成" preferredStyle:UIAlertControllerStyleAlert];
                            
                            [weakSelf presentViewController:alertVC animated:YES completion:^{
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                });
                            }];
                        }else{
                            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"选定不成功" preferredStyle:UIAlertControllerStyleAlert];
                            [weakSelf presentViewController:alertVC animated:YES completion:^{
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                });
                            }];
                        }
                    }];
                }
            };
        }
        
        if ([cell.model.work_status isEqualToString:@""]) {
            [cell.SelectedBtn setTitle:@"选定他" forState:UIControlStateNormal];
            cell.rightImage.hidden = YES;
            //cell.cancelBtn.hidden = YES;
            cell.SelectedBtn.hidden = NO;
            cell.cancelBtn.hidden = YES;
            cell.cancelImage.hidden = NO;
            [cell.cancelImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            //[cell.cancelImage setTitle:@"|" forState:UIControlStateNormal];
            [cell.cancelImage setTitleColor:[UIColor colorWithHex:0Xcbcbcb] forState:UIControlStateNormal];
            [cell.cancelImage.titleLabel setFont:[UIFont systemFontOfSize:30]];
            
            // 还没有选定人的时候   是两个按钮  一个是选定他 一个是临时会话
//            [cell.temporaryImage mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(cell.contentView.mas_left).offset(kScaleY(85));
//            }];
            
            [cell.temporaryImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(kScaleY(85));
                make.top.equalTo(cell.lineView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            
            [cell.selectedImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(kScaleY(-85));
                make.top.equalTo(cell.lineView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            
        }else{
            /*if (![cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_NOT_DONE"]) {
                [cell.cancelImage setImage:[UIImage imageNamed:@"shenqingzhongcai"] forState:UIControlStateNormal];
                [cell.cancelBtn setTitle:@"申请仲裁" forState:UIControlStateNormal];
                [cell.cancelImage setTitle:@"" forState:UIControlStateNormal];
                
                [cell.cancelImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(20, 22));
                }];
            }*/
            
            [cell.SelectedBtn addClickAction:^(UIButton * _Nullable sender) {
                if ([cell.model.work_status isEqualToString:@"WORK_STATUS_DOING"] || [cell.model.work_status isEqualToString:@"WORK_STATUS_PRE_DONE"]) {
                    WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    //[self agreeToPaymenNeedId:cell.model.id];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"本订单已确认完成"
                                                                                             message:@""
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                             NSLog(@"取消");
                                                                         }];
                    UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"确定"
                                                                                style:UIAlertActionStyleDestructive
                                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                                  [weakSelf agreeToPaymenNeedId:cell.model.id];
                                                                              }];
                    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
                    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
                    //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
                    
                    [alertController addAction:cancelButton];
                    [alertController addAction:destructiveButton];
                    [weakSelf presentViewController:alertController animated:YES completion:nil];
                }
               
                [cell.cancelBtn addClickAction:^(UIButton * _Nullable sender) {
                    WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    [weakSelf applyForArbitrationNbid:cell.model.id work_status:cell.model.work_status];
                    //[weakSelf toApplyForCancellation:cell.model.id work_status:cell.model.work_status];
                }];
                /*if ([cell.model.work_status isEqualToString:@"WORK_STATUS_DOING"]){
                    return ;
                }
                UIAlertController *alertVC = [UIAlertController
                                              alertControllerWithTitle:@"提示" message:@"选定失败" preferredStyle:UIAlertControllerStyleAlert];
                
                [weakSelf presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
                return;*/
            }];
            if ([cell.model.work_status isEqualToString:@"WORK_STATUS_DONE"]) {
                [cell.SelectedBtn setTitle:@"评价" forState:UIControlStateNormal];
                [cell.selectedImage setImage:[UIImage imageNamed:@"dingdanlianxifadanren"]];
                cell.cancelBtn.hidden = YES;
                cell.cancelImage.hidden = YES;
                
                [cell.temporaryImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView.mas_left).offset(kScaleY(85));
                    make.top.equalTo(cell.lineView.mas_bottom).offset(ghSpacingOfshiwu);
                }];
                
                [cell.selectedImage mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(kScaleY(-85));
                    make.top.equalTo(cell.lineView.mas_bottom).offset(ghSpacingOfshiwu);
                }];
                
                if (![cell.model.can_feedback boolValue]) {
                    [cell.SelectedBtn setTitle:@"已评价" forState:UIControlStateNormal];
                    cell.selectedImage.image = [UIImage imageNamed:@"pingjia"];
                    cell.cancelBtn.hidden = YES;
                    cell.SelectedBtn.enabled = NO;
                    cell.cancelImage.hidden = YES;
                    //[cell.cancelImage setTitle:@"|" forState:UIControlStateNormal];
                    [cell.cancelImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [cell.cancelImage.titleLabel setFont:[UIFont systemFontOfSize:30]];
                    [cell.cancelImage setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
                    [cell.SelectedBtn setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
                }else{
                    [cell.SelectedBtn addClickAction:^(UIButton * _Nullable sender) {
                        WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                        WQevaluateViewController *evaluateVC = [[WQevaluateViewController alloc] initWithneedId:cell.model.id];
                        evaluateVC.delegate = self;
                        [weakSelf.navigationController pushViewController:evaluateVC animated:YES];
                        return ;
                    }];
                }
            }
        }
        
        if ([cell.model.work_status isEqualToString:@"WORK_STATUS_NOT_DONE"]) {
            cell.rightImage.hidden = NO;
            [cell.SelectedBtn setTitle:@"评价" forState:UIControlStateNormal];
            cell.cancelBtn.hidden = YES;
            cell.cancelImage.hidden = YES;
            cell.selectedImage.hidden = NO;
            cell.SelectedBtn.hidden = NO;
            [cell.selectedImage setImage:[UIImage imageNamed:@"dingdanlianxifadanren"]];
            [cell.cancelImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            //[cell.cancelImage setTitle:@"|" forState:UIControlStateNormal];
            [cell.cancelImage setTitleColor:[UIColor colorWithHex:0Xcbcbcb] forState:UIControlStateNormal];
            [cell.cancelImage.titleLabel setFont:[UIFont systemFontOfSize:30]];
            
            [cell.temporaryImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(kScaleY(85));
                make.top.equalTo(cell.lineView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            
            [cell.selectedImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(kScaleY(-85));
                make.top.equalTo(cell.lineView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            
            if (![cell.model.can_feedback boolValue]) {
                [cell.SelectedBtn setTitle:@"已评价" forState:UIControlStateNormal];
                cell.selectedImage.image = [UIImage imageNamed:@"pingjia"];
                cell.cancelBtn.hidden = YES;
                cell.SelectedBtn.enabled = NO;
                [cell.SelectedBtn setTitleColor:[UIColor colorWithHex:0xa3a3a3] forState:UIControlStateNormal];
            }else{
                [cell.SelectedBtn addClickAction:^(UIButton * _Nullable sender) {
                    WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    WQevaluateViewController *evaluateVC = [[WQevaluateViewController alloc] initWithneedId:cell.model.id];
                    evaluateVC.delegate = self;
                    [weakSelf.navigationController pushViewController:evaluateVC animated:YES];
                }];
            }
        }
        
        BOOL redDotbool = [WQUnreadMessageCenter haveUnreadMessageForBid:self.midString withChater:cell.model.user_id];
        
        cell.redDotView.hidden = ! redDotbool;
        cell.midString = self.midString;

        return cell;
    }
}

#pragma mark - WQevaluateViewControllerDelegate
- (void)wqEvaluateViewControllerRefresh:(WQevaluateViewController *)wqEvaluateViewController {
    [self.tableview reloadData];
}

#pragma mark - WQTheArbitrationViewControllerDelegate
- (void)wqSubmittedToArbitrationForSuccess:(WQTheArbitrationViewController *)theArbitrationVC {
    [self.tableview reloadData];
}

#pragma mark - 同意付款
- (void)agreeToPaymenNeedId:(NSString *)needId {
    NSString *urlString = @"api/need/changebiddedneedworkstatus";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.agreeToPaymentParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    self.agreeToPaymentParams[@"nbid"] = needId;
    self.agreeToPaymentParams[@"work_status"] = @"WORK_STATUS_DONE";
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_agreeToPaymentParams completion:^(id response, NSError *error) {
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
            [SVProgressHUD showInfoWithStatus:@" 付款成功! "];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }else {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
//            [SVProgressHUD setForegroundColor:[UIColor colorWithHex:0xa550d6]];
            [SVProgressHUD showErrorWithStatus:@"已付款，请勿重复操作"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }
    }];
}

#pragma mark - 申请仲裁
- (void)applyForArbitrationNbid:(NSString *)nbid work_status:(NSString *)work_status {
    // 正在仲裁中
    if ([work_status isEqualToString:@"WORK_STATUS_ARBIRATION"]) {
        return;
    }
    WQTheArbitrationViewController *theArbitrationVC = [[WQTheArbitrationViewController alloc] initWithNbid:nbid];
    theArbitrationVC.delegate = self;
    [self.navigationController pushViewController:theArbitrationVC animated:YES];
}

#pragma mark - 发单者申请取消
- (void)toApplyForCancellation:(NSString *)nbid work_status:(NSString *)work_status {
    if (![work_status isEqualToString:@"WORK_STATUS_PRE_DONE"] && ![work_status isEqualToString:@"WORK_STATUS_DOING"]) {
        return ;
    }
    NSString *urlString = @"api/need/changebiddedneedworkstatus";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.cancellParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    _cancellParams[@"nbid"] = nbid;
    _cancellParams[@"work_status"] = @"WORK_STATUS_PRE_NOT_DONE";
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_cancellParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
            [SVProgressHUD showInfoWithStatus:@"已申请取消订单"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }else {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
            [SVProgressHUD showErrorWithStatus:@"请等待接单人确认，请勿重复提交"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }
    }];
}

//_conversation = [[EMClient sharedClient].chatManager getConversation:conversationChatter type:conversationType createIfNotExist:YES];
#pragma mark - 环信单聊
- (void)pushChatVC:(NSString *)user_id needId:(NSString *)needId
       needOwnerId:(NSString *)needOwnerId fromName:(NSString *)userName
           fromPic:(NSString *)userPic toName:(NSString *)toName toPic:(NSString *)toPic
         isFromTemp:(BOOL) isFromTemp
        isTrueName:(BOOL) isTrueName
     isBidTureName:(BOOL) isBidTureName
       bidFinished:(BOOL)isfinished {
    WQChaViewController *chatVc = [[WQChaViewController alloc] initWithConversationChatter:user_id conversationType:EMConversationTypeChat needId:needId needOwnerId:needOwnerId fromName:userName fromPic:userPic toName:toName toPic:toPic isFromTemp:isFromTemp isTrueName:isTrueName isBidTureName:isBidTureName];
    chatVc.bidFinished = isfinished;
    if (self.wqOrderType  == WQOrderTypeFinish) {
        chatVc.bidFinished = YES;
    }
    [self.navigationController pushViewController:chatVc animated:YES];
}

#pragma mark - 点击头像
- (void)clickOnThePicture:(BOOL)isTruename user_id:(NSString *)user_id user_idcard_stauts:(NSString *)user_idcard_stauts {
    if (!isTruename) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"实名用户匿名状态" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }
    if ([user_idcard_stauts isEqualToString:@"STATUS_UNVERIFY"] || [user_idcard_stauts isEqualToString:@"STATUS_VERIFING"]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"非实名认证用户" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }
    WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:user_id];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 忽略此用户

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(indexPath.section == 2)) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {

    
    UITableViewRowAction* action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"忽略此用户" handler:^(UITableViewRowAction* _Nonnull action, NSIndexPath* _Nonnull indexPath) {
        NSString *urlString = @"api/need/deleteneedbid";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        WQdetailsConrelooerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        WQPeopleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *nbid = cell.model.id;
        self.ignoreParams[@"nbid"] = nbid;
        _ignoreParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
        [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_ignoreParams completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            NSLog(@"%@",response);
            if ([response[@"success"] boolValue]) {
                
                
                [self.modelArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableview reloadData];
            } else {
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",response[@"message"]] message:[NSString stringWithFormat:@"%@",response[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                        }];
                    });
                }];
            }
        }];
    }];
    action2.backgroundColor=[UIColor redColor];
    return @[action2];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}

- (NSMutableArray *)tableViewdetailOrderData {
    if (!_tableViewdetailOrderData) {
        _tableViewdetailOrderData = [[NSMutableArray alloc] init];
    }
    return _tableViewdetailOrderData;
}
- (NSString *)imHuanxinid {
    if (!_imHuanxinid) {
        _imHuanxinid = [[NSString alloc] init];
    }
    return _imHuanxinid;
}

- (NSMutableDictionary *)PeopleListparams {
    if (!_PeopleListparams) {
        _PeopleListparams = [[NSMutableDictionary alloc] init];
    }
    return _PeopleListparams;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] init];
    }
    return _modelArray;
}

- (NSMutableDictionary *)modifyParams {
    if (!_modifyParams) {
        _modifyParams = [[NSMutableDictionary alloc] init];
    }
    return _modifyParams;
}

- (NSMutableDictionary *)deleteneedParams {
    if (!_deleteneedParams) {
        _deleteneedParams = [[NSMutableDictionary alloc] init];
    }
    return _deleteneedParams;
}

- (NSArray *)btnTitleArray {
    if (!_btnTitleArray) {
        _btnTitleArray = @[@"选定他",@"确认完成",@""];
    }
    return _btnTitleArray;
}

- (NSMutableDictionary *)confirmParams {
    if (!_confirmParams) {
        _confirmParams = [[NSMutableDictionary alloc] init];
    }
    return _confirmParams;
}

- (NSMutableDictionary *)ignoreParams {
    if (!_ignoreParams) {
        _ignoreParams = [[NSMutableDictionary alloc] init];
    }
    return _ignoreParams;
}
- (NSMutableDictionary *)cancellParams {
    if (!_cancellParams) {
        _cancellParams = [[NSMutableDictionary alloc] init];
    }
    return _cancellParams;
}
- (NSMutableDictionary *)agreeToPaymentParams {
    if (!_agreeToPaymentParams) {
        _agreeToPaymentParams = [[NSMutableDictionary alloc] init];
    }
    return _agreeToPaymentParams;
}
- (NSDictionary *)response {
    if (!_response) {
        _response = [[NSDictionary alloc] init];
    }
    return _response;
}

#pragma mark - 两秒后移除提示框
- (void)delayMethod {
    //两秒后移除提示框
    [SVProgressHUD dismiss];
}


- (void)sharBarBtnClike {
    __weak typeof(self) weakSelf = self;
    
    [WQSingleton sharedManager].platname = @"WQ";
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        if(platformType == UMSocialPlatformType_Sina){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sina shareTypeIndex:0];
        }else if(platformType == UMSocialPlatformType_Sms){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sms shareTypeIndex:1];
        }else if (platformType == UMSocialPlatformType_QQ){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_QQ shareTypeIndex:2];
        }else if (platformType == UMSocialPlatformType_Qzone){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Qzone shareTypeIndex:3];
        }else if (platformType == UMSocialPlatformType_WechatSession){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatSession shareTypeIndex:4];
        }else if (platformType == UMSocialPlatformType_WechatTimeLine){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatTimeLine shareTypeIndex:5];
        }else if (platformType == WQQuanZi){
            WQGroupChooseSharGroupViewController *vc = [[WQGroupChooseSharGroupViewController alloc] init];
            vc.nid = self.midString;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(platformType == WQCopyLink){
            NSString *shardString = [NSString stringWithFormat:@"http://wanquan.belightinnovation.com/front/share/need?nid=%@",self.response[@"id"]];
            NSString *copyLink= shardString;
            [WQTool copy:self urlStr:copyLink];
        }
    }];


}

//分享不同的内容到平台platformType
- (void)shareWithPlatformType:(UMSocialPlatformType)platformType shareTypeIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    switch (index) {
        case 0:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Sina];
            break;
        case 1:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Sms];
            break;
        case 2:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_QQ];
            break;
        case 3:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
            break;
        case 4:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            break;
        case 5:
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
            break;
        default:
            break;
    }
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareWebpageObject *shareObject;
    if ([self.response[@"category_level_1"] isEqualToString:@"BBS"]) {
        NSString *str = @"读BBS领红包";
        NSString *spaceString = @"   ";
        NSString *joiningTogetherString = [str stringByAppendingString:spaceString];
        NSString *contentString = [joiningTogetherString stringByAppendingString:[NSString stringWithFormat:@"%@",self.response[@"content"]]];
        //创建网页内容对象
        NSString* thumbURL = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
        shareObject = [UMShareWebpageObject shareObjectWithTitle:self.response[@"subject"] descr:contentString thumImage:thumbURL];
    }else {
        NSString *money = @"需求酬金:¥";
        NSString *moneySplice = [money stringByAppendingString:[NSString stringWithFormat:@"%@",self.response[@"money"]]];
        NSString *theBlankSpace = @"   ";
        NSString *inTheEndString = [moneySplice stringByAppendingString:[NSString stringWithFormat:@"%@",theBlankSpace]];
        NSString *moneySplicecontent = [inTheEndString stringByAppendingString:[NSString stringWithFormat:@"%@",self.response[@"content"]]];
        //创建网页内容对象
        NSString* thumbURL = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
        shareObject = [UMShareWebpageObject shareObjectWithTitle:self.response[@"subject"] descr:moneySplicecontent thumImage:thumbURL];
    }
    
    //设置网页地址
    NSString *shardString = @"http://wanquan.belightinnovation.com/front/share/need?nid=";
    shareObject.webpageUrl = [shardString stringByAppendingString:[NSString stringWithFormat:@"%@",self.response[@"id"]]];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error {
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj {
    messageObj.moreInfo = @{@"source_url": @"http://www.umeng.com",
                            @"app_name": @"U-Share",
                            @"suggested_board_name": @"UShareProduce",
                            @"description": @"U-Share: best social bridge"};
}

@end
