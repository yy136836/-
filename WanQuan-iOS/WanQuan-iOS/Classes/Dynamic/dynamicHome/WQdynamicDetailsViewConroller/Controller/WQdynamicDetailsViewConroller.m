//
//  WQdynamicDetailsViewConroller.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQdynamicDetailsViewConroller.h"
#import "WQparticularsModel.h"
#import "WQDynamicDetailsTableViewCell.h"
#import "WQDynamicDetailsCommentTableViewCell.h"
#import "WQTextInputViewWithOutImage.h"
#import "WQDynamicDetailsToolBarView.h"
#import "WQPopupWindowEncourageView.h"
#import "WQdynamicHomeViewController.h"
#import "WQfeedbackViewController.h"
#import "WQUserProfileController.h"
#import "WQLoginPopupWindow.h"
#import "WQLogInController.h"
#import "WQDynamicLevelOncCommentModel.h"
#import "WQCommentDetailsViewController.h"
#import "UMSocialUIManager.h"
#import "WQActionSheet.h"
static NSString *identifier = @"identifier";
static NSString *commentIdentifier = @"commentIdentifier";

@interface WQdynamicDetailsViewConroller () <UITableViewDelegate,UITableViewDataSource,WQTextInputViewWithOutImageDelegate,UITextViewDelegate,WQDynamicDetailsTableViewCellDelegate,WQPopupWindowEncourageViewDelegate,WQLoginPopupWindowDelegate,WQDynamicDetailsCommentTableViewCellDelegate,WQActionSheetDelegate>

/**
 数据模型
 */
@property (nonatomic, strong) WQparticularsModel *model;

/**
 底部评论输入框
 */
@property (nonatomic, strong) WQTextInputViewWithOutImage *textInputViewWithOutImage;

/**
 鼓励的弹窗
 */
@property (nonatomic, strong) WQPopupWindowEncourageView *popupWindowEncourageView;

/**
 一级评论的数据
 */
@property (nonatomic, strong) NSMutableArray *comments;

/**
 热门评论的数据
 */
@property (nonatomic, strong) NSMutableArray *hotComments;

/**
 评论 数据  一级二级都在
 */
@property (nonatomic, strong) NSArray *commentData;

/**
 回复id
 */
@property (nonatomic, copy) NSString *replyid;

/**
 cell的index
 */
@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, copy) NSString *role_id;

@end

@implementation WQdynamicDetailsViewConroller {
    UITableView *ghTableView;
    WQLoginPopupWindow *loginPopupWindow;
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"动态详情";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *sharBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dynamicShar"] style:UIBarButtonItemStylePlain target:self action:@selector(sharBarBtnClick)];
    
    UIButton * moreButton = [[UIButton alloc] init];
    [moreButton setTitle:@"∙∙∙" forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreButton sizeToFit];
    [moreButton addTarget:self action:@selector(barBtnsClick) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *barBtns = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    WQNavBackButton *btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItems = @[barBtns,sharBarBtn];
    
    [self loadList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
//    [SVProgressHUD showWithStatus:@"加载中…"];
    
    [self.hotComments removeAllObjects];
    [self.comments removeAllObjects];
    
    [self loadCommentsList];
    [self setupView];
    
    self.role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    
    // 复制链接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(copyLink) name:WQSharCopyLink object:nil];
    // 键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark -- 复制链接
- (void)copyLink {
    UMShareMenuSelectionView *view = [[UMShareMenuSelectionView alloc] init];
    [view hiddenShareMenuView];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [[BASE_URL_STRING stringByAppendingString:@"front/momentStatus/momentStatusH5Show?&mid="] stringByAppendingString:self.mid];
    [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
}

- (void)setupView {
    ghTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    ghTableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    ghTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    // 设置代理对象
    ghTableView.delegate = self;
    ghTableView.dataSource = self;
    ghTableView.estimatedRowHeight = 0;
    ghTableView.estimatedSectionHeaderHeight = 0;
    ghTableView.estimatedSectionFooterHeight = 0;
    // 取消分割线
    ghTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [ghTableView registerClass:[WQDynamicDetailsTableViewCell class] forCellReuseIdentifier:identifier];
    [ghTableView registerClass:[WQDynamicDetailsCommentTableViewCell class] forCellReuseIdentifier:commentIdentifier];
    [self.view addSubview:ghTableView];
    [ghTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
    }];
    
    // 鼓励的弹窗
    WQPopupWindowEncourageView *popupWindowEncourageView = [[WQPopupWindowEncourageView alloc] init];
    popupWindowEncourageView.delegate = self;
    self.popupWindowEncourageView = popupWindowEncourageView;
    popupWindowEncourageView.hidden = YES;
    [self.view addSubview:popupWindowEncourageView];
    [popupWindowEncourageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    // 评论的输入框
    self.textInputViewWithOutImage = [[NSBundle mainBundle] loadNibNamed:@"WQTextInputViewWithOutImage" owner:self options:nil].lastObject;
    [self.view addSubview:self.textInputViewWithOutImage];
    self.textInputViewWithOutImage.delegate = self;
    self.textInputViewWithOutImage.inputtextView.placeholder = @"聊聊您的想法";
    self.textInputViewWithOutImage.inputtextView.delegate = self;
    self.textInputViewWithOutImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textInputViewWithOutImageClick)];
    [self.textInputViewWithOutImage addGestureRecognizer:tap];
    [self.textInputViewWithOutImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(TAB_HEIGHT - 50));
        make.height.lessThanOrEqualTo(@130);
        make.height.greaterThanOrEqualTo(@50);
    }];
    // 登录的弹窗
    loginPopupWindow = [[WQLoginPopupWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    loginPopupWindow.delegate = self;
    loginPopupWindow.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:loginPopupWindow];
    
    loadingView = [[WQLoadingView alloc] init];
    [loadingView show];
    [self.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(loadingView) weakLoadingView = loadingView;
    loadingError = [[WQLoadingError alloc] init];
    [loadingError setClickRetryBtnClickBlock:^{
        [weakLoadingView show];
        [weakSelf loadList];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    

  
    
}




- (void)loadList {
    NSString *urlString = @"api/moment/status/getstatus";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"mid"] = self.mid;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [loadingError show];
            [loadingView dismiss];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        [SVProgressHUD dismissWithDelay:0.3];
        self.model = [WQparticularsModel yy_modelWithJSON:response];

        [loadingView dismiss];
        [ghTableView reloadData];
    }];
}

- (void)loadCommentsList {
    [self.hotComments removeAllObjects];
    [self.comments removeAllObjects];
    NSString *urlString = @"api/moment/status/getcomment1list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"mid"] = self.mid;
    params[@"hot"] = @"false";
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismissWithDelay:0.3];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        [SVProgressHUD dismissWithDelay:0.3];
        
        NSArray *comments = [NSArray yy_modelArrayWithClass:[WQDynamicLevelOncCommentModel class] json:response[@"comments"]];
        self.commentData = comments;
        for (WQDynamicLevelOncCommentModel *model in comments) {
            // 热门评论
            if (model.hot) {
                [self.hotComments addObject:model];
            }else {
                [self.comments addObject:model];
            }
        }
        
        if (self.isComment) {
            __weak typeof(self)  weakSelf = self;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf.textInputViewWithOutImage.inputtextView becomeFirstResponder];
            });
        }

        
        [ghTableView reloadData];
        if (self.isComment) {
            if (self.comments.count) {
                if (self.hotComments.count) {
                    [ghTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                [ghTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return NO;
    }
    return YES;
}

- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton {
    
    sendButton.enabled = NO;
    
    NSString *urlString = @"api/moment/status/sendcomment";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"content"] = view.inputtextView.text;
    params[@"mid"] = self.mid;
    
    if (self.replyid.length) {
        params[@"ori_comment_id"] = self.replyid;
    }
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
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
        }else {
            sendButton.enabled = YES;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送不成功，请重试" andAnimated:YES andTime:1.5];
        }
        [self loadCommentsList];
    }];
}

#pragma mark - 监听通知
- (void)keyboardWasShown:(NSNotification*)noti {
    __weak typeof(self) weakSelf = self;
    if (!self.popupWindowEncourageView.moneyTextField.isFirstResponder) {
        CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [weakSelf.textInputViewWithOutImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-rect.size.height);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf.view layoutIfNeeded];
        }];
    }
}

- (void)keyBoardWillHidden:(NSNotification *)noti {
    [self.textInputViewWithOutImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(TAB_HEIGHT - 50));
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - ****************收藏与取消收藏
- (void)wqScBtnClick {
    // 收藏的响应事件
    NSString *strURL = @"api/favorite/favorite";
    NSMutableDictionary * param = @{@"secretkey":[WQDataSource sharedTool].secretkey}.mutableCopy;
    param[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    param[@"target_type"] = @"TYPE_MOMENT_STATUS";
    param[@"target_id"] = self.mid;
    param[@"favorited"] = !self.model.favorited ? @"true" : @"false";
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD showWithStatus:@"网络连接错误"];
            [SVProgressHUD dismissWithDelay:1.3];
            return ;
        }
        
        NSLog(@"%@",response);
        
        if ([response[@"success"] boolValue]) {
            self.model.favorited = !self.model.favorited;
            NSString *hudInfo = !self.model.favorited ? @"已取消收藏" : @"已收藏至 \"我的—关注、收藏\"";
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:hudInfo andAnimated:YES andTime:1.5];

        } else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
        
    }];
}
#pragma mark - ****************删除
- (void)wqDeleteBtnClick{
    // 删除的响应事件
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"加载中…"];
    NSString *urlString = @"api/moment/status/deletestatus";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"mid"] = self.mid;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        [SVProgressHUD dismissWithDelay:1];
        BOOL whetherlike = [response[@"success"]boolValue];
        if (whetherlike) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"删除成功" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:WQdeleteSuccessful object:self userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }
    }];
}
#pragma mark - ****************举报
- (void)wqReportBtnClick {
    // 举报的响应事件
    WQfeedbackViewController *vc = [[WQfeedbackViewController alloc] init];
    vc.feedbackType = TYPE_MOMENT;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 评论输入框的响应事件
- (void)textInputViewWithOutImageClick {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
}

#pragma mark -- WQPopupWindowEncourageViewDelegate
- (void)wqSubmitBtnClike:(WQPopupWindowEncourageView *)encourageView moneyString:(NSString *)moneyString {
    [self.popupWindowEncourageView.moneyTextField endEditing:YES];
    // 打赏提交的响应事件
    NSString *urlString = @"api/moment/status/rewardstatus";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"money"] = moneyString;
    params[@"mid"] = self.mid;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"ecode"] boolValue]) {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"余额不足请充值" andAnimated:YES andTime:1.5];
            return;
        }
        if ([response[@"success"]boolValue]) {
            [self loadList];
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"谢谢您的鼓励" andAnimated:YES andTime:1.5];
            self.popupWindowEncourageView.hidden = YES;
        }else{
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}
- (void)wqCancelBtn:(WQPopupWindowEncourageView *)encourageView {
    // 打赏取消的响应事件
    encourageView.hidden = YES;
    self.popupWindowEncourageView.moneyTextField.text = @"";
    [self.popupWindowEncourageView.moneyTextField endEditing:YES];
}

#pragma mark -- WQDynamicDetailsTableViewCellDelegate
- (void)wqUser_picImageViewClick:(WQdynamicUserInformationView *)view cell:(WQDynamicDetailsTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    // 头像的响应事件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    if ([cell.model.user_id isEqualToString:im_namelogin]) {
        // 是自己
        WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:cell.model.user_id];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        // 不是自己
        WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:cell.model.user_id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)wqUnlikeBtnClike:(WQDynamicDetailsToolBarView *)toolBarView cell:(WQDynamicDetailsTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    // 赞的响应事件
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/moment/status/likeordislike";
    params[@"mid"] = self.mid;
    params[@"like"] = @"true";
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] integerValue]) {
            [WQAlert showAlertWithTitle:nil message:WQ_ZAN_MESSAGE duration:1];

            [self loadList];
            [toolBarView.unlikeBtn setImage:[UIImage imageNamed:@"dynamicyidianzan"] forState:UIControlStateNormal];
            [toolBarView.unlikeBtn setTitleColor:[UIColor colorWithHex:0xee9b11] forState:UIControlStateNormal];
            if (self.likeBlock) {
                self.likeBlock();
            }
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1];
        }
    }];
}

- (void)wqPlayTourBtnClike:(WQDynamicDetailsToolBarView *)toolBarView cell:(WQDynamicDetailsTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    // 鼓励的响应事件
    self.popupWindowEncourageView.hidden = !self.popupWindowEncourageView.hidden;
    self.mid = cell.model.id;
    [self.popupWindowEncourageView.moneyTextField becomeFirstResponder];
}

- (void)wqRetweetbtnClike:(WQDynamicDetailsToolBarView *)toolBarView cell:(WQDynamicDetailsTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    
  WQAlertController *alertView =  [WQAlertController initWQAlertControllerWithTitle:nil message:@"确定要踩这条动态吗？" style:1 titleArray:@[@"取消",@"确定踩"] alertAction:^(NSInteger index) {
      if (index) {
          [self caiAction];
      }
    }];
    [alertView showWQAlert];
}

- (void)caiAction
{
    // 踩的响应事件
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/moment/status/likeordislike";
    params[@"mid"] = self.mid;
    params[@"like"] = @"false";
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] integerValue]) {
            [self loadList];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}

#pragma mark -- WQDynamicDetailsCommentTableViewCellDelegate
- (void)wqCommentsBtnClick:(WQDynamicDetailsCommentTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    // 评论的响应事件
    //self.replyid = cell.model.id;
    //[self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
    
    WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
    [vc setDeleteCommentBlock:^{
        [self loadCommentsList];
    }];
    [vc setSendSuccessCommentBlock:^{
        [self loadCommentsList];
    }];
    vc.model = cell.model;
    vc.mid = self.mid;
    vc.isShowKeyBord = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)wqHeadBtnClike:(WQDynamicDetailsCommentTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    // 头像的响应事件
    WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:cell.model.user_id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wqPraiseBtnClick:(WQDynamicDetailsCommentTableViewCell *)cell {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    // 评论赞的响应事件
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/moment/status/commentlike";
    params[@"comment_id"] = cell.model.id;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] integerValue]) {
            cell.model.like_count += 1;
            cell.model.isLiked = !cell.model.isLiked;
            [ghTableView reloadData];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}

#pragma mark -- UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        WQDynamicDetailsCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        WQCommentDetailsViewController *vc = [[WQCommentDetailsViewController alloc] init];
        [vc setDeleteCommentBlock:^{
            [self loadCommentsList];
        }];
        [vc setSendSuccessCommentBlock:^{
            [self loadCommentsList];
        }];
        vc.model = cell.model;
        vc.mid = self.mid;
        vc.isShowKeyBord = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 有热门评论
    if (self.hotComments.count && self.comments.count) {
        return 3;
    }else if (!self.hotComments.count && self.comments.count) {
        return 2;
    }else if (self.hotComments.count && !self.comments.count) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.hotComments.count && self.comments.count) {
        if (section == 0) {
            return 1;
        }
        if (section == 1) {
            return self.hotComments.count;
        }
        if (section == 2) {
            return self.comments.count;
        }
    }else if (!self.hotComments.count && self.comments.count) {
        if (section == 0) {
            return 1;
        }
        if (section == 1) {
            return self.comments.count;
        }
    }else if (self.hotComments.count && !self.comments.count) {
        if (section == 0) {
            return 1;
        }
        if (section == 1) {
            return self.hotComments.count;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WQDynamicDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.model = self.model;
        cell.delegate = self;
        
        return cell;
    }else {
        WQDynamicDetailsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier forIndexPath:indexPath];
        cell.mid = self.mid;
        cell.delegate = self;
        if (self.hotComments.count && self.comments.count) {
            if (indexPath.section == 1) {
                if (self.hotComments.count > indexPath.row) {
                    cell.model = self.hotComments[indexPath.row];
                }
            }
            if (indexPath.section == 2) {
                if (self.comments.count > indexPath.row) {
                    cell.model = self.comments[indexPath.row];
                }
            }
        }
        
        if (!self.hotComments.count && self.comments.count) {
            cell.model = self.comments[indexPath.row];
        }
        
        if (self.hotComments.count && !self.comments.count) {
            cell.model = self.hotComments[indexPath.row];
        }
        UILongPressGestureRecognizer * longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    }
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pointr = [recognizer locationInView:ghTableView];
        NSIndexPath *indexPath = [ghTableView indexPathForRowAtPoint:pointr];
        self.index = indexPath;
        WQDynamicDetailsCommentTableViewCell *cell = [ghTableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        CGPoint point = [recognizer locationInView:cell];
        CGRect r = CGRectMake(point.x, point.y, 0, 0);
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
        UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        if ([cell.model.user_id isEqualToString:im_namelogin]) {
            [menu setMenuItems:[NSArray arrayWithObjects:itCopy, itDelete,  nil]];
        }else {
            [menu setMenuItems:[NSArray arrayWithObjects:itCopy, nil]];
        }
        [menu setTargetRect:r inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}

// 复制
- (void)handleCopyCell:(id)sender {
    WQDynamicDetailsCommentTableViewCell *cell = [ghTableView cellForRowAtIndexPath:self.index];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.replyLabel.text;
    
   // 规格
}

// 删除
- (void)handleDeleteCell:(id)sender {
    WQDynamicDetailsCommentTableViewCell *cell = [ghTableView cellForRowAtIndexPath:self.index];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/moment/status/deletecomment";
    params[@"cid"] = cell.model.id;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        if ([response[@"success"] integerValue]) {
            [self loadCommentsList];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ghTableView.estimatedRowHeight = 400;
        return UITableViewAutomaticDimension;
    }else {
        ghTableView.estimatedRowHeight = 190;
        return UITableViewAutomaticDimension;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 有热门评论
    if (self.hotComments.count) {
        if (section == 1 || section == 2) {
            return @"";
        }
    }else {
        if (self.comments.count) {
            if (section == 1) {
                return @"";
            }
        }else {
            return @" ";
        }
    }
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 40;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 有热门评论
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    
    UILabel *hotLabel = [UILabel labelWithText:@"热门评论" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:16];
    UILabel *latestLabel = [UILabel labelWithText:@"最新评论" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:16];
    if (self.hotComments.count) {
        if (section == 1) {
            [backgroundView addSubview:hotLabel];
            [hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(backgroundView.mas_centerY);
                make.left.equalTo(backgroundView).offset(ghSpacingOfshiwu);
            }];
        }
        if (section == 2) {
            [backgroundView addSubview:latestLabel];
            [latestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(backgroundView.mas_centerY);
                make.left.equalTo(backgroundView).offset(ghSpacingOfshiwu);
            }];
        }
    }else {
        if (self.comments.count) {
            if (section == 1) {
                [backgroundView addSubview:latestLabel];
                [latestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(backgroundView.mas_centerY);
                    make.left.equalTo(backgroundView).offset(ghSpacingOfshiwu);
                }];
            }
        }
    }
    
    return backgroundView;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 分享
- (void)sharBarBtnClick {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    // 分享的响应事件
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    
    [WQSingleton sharedManager].platname = @"NORMAL";
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        if(platformType == UMSocialPlatformType_Sina){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sina shareTypeIndex:0];
        }else if(platformType == UMSocialPlatformType_Sms){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Sms shareTypeIndex:1];
        }else if (platformType == UMSocialPlatformType_QQ){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_QQ shareTypeIndex:2];
        }else if (platformType == UMSocialPlatformType_Qzone){
            [weakSelf shareWithPlatformType:UMSocialPlatformType_Qzone shareTypeIndex:3];
        }else if (platformType == UMSocialPlatformType_WechatSession){//微信
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatSession shareTypeIndex:4];
        }else if (platformType == UMSocialPlatformType_WechatTimeLine){//朋友圈
            [weakSelf shareWithPlatformType:UMSocialPlatformType_WechatTimeLine shareTypeIndex:5];
        }else if (platformType == WQCopyLink){//复制链接
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *copyLink= [[BASE_URL_STRING stringByAppendingString:@"front/momentStatus/momentStatusH5Show?&mid="] stringByAppendingString:self.mid];
            pasteboard.string = copyLink;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
        }
    }];
}

#pragma mark -- 三个点的响应事件
- (void)barBtnsClick {
    // 游客登录
    if ([self.role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    
    NSArray *titleNameArray;
    NSString *title = !self.model.favorited ? @"收藏" : @"取消收藏";
    if ([self.model.user_id isEqualToString:im_namelogin]) {//自己发的有删除
        titleNameArray = @[title,@"举报",@"删除"];
    }else {
        titleNameArray = @[title,@"举报"];
    }
    WQActionSheet *ActionSheet = [[WQActionSheet alloc]initWithTitles:titleNameArray];
    ActionSheet.delegate =self;
    [ActionSheet show];

    
    // 是否收藏
}
- (void)clickedButton:(WQActionSheet *)sheetView ClickedName:(NSString *)name
{
    if ([name isEqualToString:@"收藏"] ||
        [name isEqualToString:@"取消收藏"]) {
        [self wqScBtnClick];
    }else if ([name isEqualToString:@"举报"]){
        [self wqReportBtnClick];
    }else if ([name isEqualToString:@"删除"]){
        [self wqDeleteBtnClick];
    }
    
}


- (void)showLogin {
    [self.view bringSubviewToFront:loginPopupWindow];
    loginPopupWindow.hidden = NO;
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(kScaleX(200));
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
}

- (void)wqLoginBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    WQLogInController *vc = [[WQLogInController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)wqRegisteredBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    WQLogInController *vc = [[WQLogInController alloc] initWithTouristLoginStatus:regist];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)wqTranslucentAreaClick:(WQLoginPopupWindow *)loginPopupWindow {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
}

#pragma mark -- dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 懒加载
// 一级评论的数组
- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

// 热门评论的数组
- (NSMutableArray *)hotComments {
    if (!_hotComments) {
        _hotComments = [NSMutableArray array];
    }
    return _hotComments;
}

#pragma mark -- 分享
- (void)shareWithPlatformType:(UMSocialPlatformType)platformType shareTypeIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD show];
    
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
    ///创建网页内容对象
    NSString *imageUrl;
    if (self.model.pic.count) {
        imageUrl = [imageUrlString stringByAppendingString:self.model.pic.firstObject];
    }else {
        imageUrl = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
    }
    NSString *titleString = @"万圈动态 - 关注校友最新动态";
    NSString *contentString;
    if (self.model.content.length) {
        contentString = self.model.content;
    }else {
        contentString = @"您的好友发表了图片和链接,进入查看详情";
    }
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString descr:contentString           thumImage:imageUrl];
    //设置网页地址
    shareObject.webpageUrl = [[BASE_URL_STRING stringByAppendingString:@"front/momentStatus/momentStatusH5Show?&mid="] stringByAppendingString:self.mid];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:self completion:^(id data, NSError *error) {
                                    [SVProgressHUD dismiss];
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
}

- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj {
    messageObj.moreInfo = @{@"source_url": @"http://www.umeng.com",
                            @"app_name": @"U-Share",
                            @"suggested_board_name": @"UShareProduce",
                            @"description": @"U-Share: best social bridge"};
}

@end
