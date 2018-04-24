
//
//  WQdynamicSearchViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQdynamicSearchViewController.h"
#import "WQSearchView.h"
#import "WQDynamicSearchEmptyView.h"
#import "WQdynamicTableViewCell.h"
#import "WQdynamicHomeModel.h"
#import "WQdynamicContentView.h"
#import "WQEssenceDetailController.h"
#import "WQdynamicDetailsViewConroller.h"
#import "WQmoment_statusModel.h"
#import "WQmoment_choicest_articleModel.h"
#import "WQdynamicUserInformationView.h"
#import "WQUserProfileController.h"
#import "WQTopicArticleController.h"
#import "WQdynamicToobarView.h"
#import "WQPopupWindowEncourageView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "UMSocialUIManager.h"
#import "WQTextInputViewWithOutImage.h"
#import "WQGroupInformationViewController.h"

static NSString *identifier = @"identifier";

@interface WQdynamicSearchViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,WQdynamicTableViewCellDelegate,WQPopupWindowEncourageViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,WQTextInputViewWithOutImageDelegate,WQSearchViewDelegate>

/**
 底部评论输入框
 */
@property (nonatomic, strong) WQTextInputViewWithOutImage *textInputViewWithOutImage;

/**
 鼓励的弹窗
 */
@property (nonatomic, strong) WQPopupWindowEncourageView *popupWindowEncourageView;

/**
 空页面
 */
@property (nonatomic, strong) WQDynamicSearchEmptyView *emptyView;

/**
 顶部的搜索view
 */
@property (nonatomic, strong) WQSearchView *searchView;

/**
 精选模型
 */
@property (nonatomic, strong) WQmoment_choicest_articleModel *articleModel;

/**
 动态模型
 */
@property (nonatomic, strong) WQmoment_statusModel *moment_statusModel;

/**
 midstring
 */
@property (nonatomic, copy) NSString *midString;

/**
 搜索的内容
 */
@property (nonatomic, copy) NSString *searchText;

/**
 当前状态
 */
@property (nonatomic, copy) NSString *type;

/**
 键盘响应者是否是评论框
 */
@property (nonatomic, assign) BOOL isTextInputView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WQdynamicSearchViewController {
    UITableView *ghTableView;
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    WQTabBarController *tabBarVC = (WQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabBarVC isKindOfClass:[WQTabBarController class]]) {
        tabBarVC.tabBar.hidden = NO;
    }
    
    self.isTextInputView = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    WQTabBarController *tabBarVC = (WQTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabBarVC isKindOfClass:[WQTabBarController class]]) {
        tabBarVC.tabBar.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 复制链接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(copyLink) name:WQSharCopyLink object:nil];
    // 键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupView];
}

#pragma mark - 监听通知
- (void)keyboardWasShown:(NSNotification*)noti {
    __weak typeof(self) weakSelf = self;
    if (self.isTextInputView) {
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
        make.bottom.equalTo(self.view).offset(TAB_HEIGHT);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark -- 初始化View
- (void)setupView {
    // 顶部的搜索view
    WQSearchView *searchView = [[WQSearchView alloc] init];
    self.searchView = searchView;
    searchView.searchTextField.delegate = self;
    [searchView.searchTextField becomeFirstResponder];
    searchView.delegate = self;
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.offset(66);
    }];
    
    ghTableView = [[UITableView alloc] init];
    ghTableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    if(@available(iOS 11.0, *)) {
        ghTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        ghTableView.estimatedSectionFooterHeight = 0;
        ghTableView.estimatedSectionHeaderHeight = 0;
        ghTableView.estimatedRowHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ghTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    // 设置代理对象
    ghTableView.delegate = self;
    ghTableView.dataSource = self;
    // 取消分割线&滚动条
    ghTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ghTableView.showsVerticalScrollIndicator = NO;
    // 设置自动行高和预估行高
    ghTableView.rowHeight = UITableViewAutomaticDimension;
    ghTableView.estimatedRowHeight = 200;
    // 注册cell
    [ghTableView registerClass:[WQdynamicTableViewCell class] forCellReuseIdentifier:identifier];
    [self.view addSubview:ghTableView];
    [ghTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(searchView.mas_bottom);
    }];
    
    loadingView = [[WQLoadingView alloc] init];
    [self.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(searchView.mas_bottom);
    }];
    
    // 空页面
    WQDynamicSearchEmptyView *emptyView = [[WQDynamicSearchEmptyView alloc] init];
    self.emptyView.hidden = NO;
    self.emptyView = emptyView;
    [self.view addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(searchView.mas_bottom);
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
    [self.textInputViewWithOutImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(TAB_HEIGHT);
        make.height.lessThanOrEqualTo(@130);
        make.height.greaterThanOrEqualTo(@50);
    }];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(loadingView) weakLoadingView = loadingView;
    loadingError = [[WQLoadingError alloc] init];
    [loadingError setClickRetryBtnClickBlock:^{
        [weakLoadingView show];
        [weakSelf loadListWithSearchText:weakSelf.searchText];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(searchView.mas_bottom);
    }];
}

#pragma mark -- 复制链接
- (void)copyLink {
    UMShareMenuSelectionView *view = [[UMShareMenuSelectionView alloc] init];
    [view hiddenShareMenuView];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    // 万圈状态
    if ([self.type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        pasteboard.string = [[BASE_URL_STRING stringByAppendingString:@"front/momentStatus/momentStatusH5Show?&mid="] stringByAppendingString:self.moment_statusModel.id];
    }else if ([self.type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        pasteboard.string = [NSString stringWithFormat:@"%@front/choicest/articleh5show?choicest_id=%@",BASE_URL_STRING,self.articleModel.essenceId.length ? self.articleModel.essenceId : @"8feb4a1d891943aeb0d382269602ea2f"];
    }
    [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField.text isVisibleString]) {
        [self.dataArray removeAllObjects];
        [ghTableView reloadData];
        return YES;
    }
    self.searchText = textField.text;
//    [SVProgressHUD show];
    [loadingView show];
    [self loadListWithSearchText:textField.text];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([str isEqualToString:@""]) {
        [self.searchView.xBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else {
        [self.searchView.xBtn setImage:[UIImage imageNamed:@"searchShanchu"] forState:UIControlStateNormal];
    }
    
    return YES;
}

#pragma mark -- 获取数据
- (void)loadListWithSearchText:(NSString *)searchText {
    NSString *urlString = @"api/moments/search";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keywork"] = searchText;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [loadingView dismiss];
            [loadingError show];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        [SVProgressHUD dismissWithDelay:0.3];
        self.dataArray = [NSArray yy_modelArrayWithClass:[WQdynamicHomeModel class] json:response[@"moments"]].mutableCopy;
        if (self.dataArray.count < 1) {

            ghTableView.emptyDataSetSource = self;
            ghTableView.emptyDataSetDelegate = self;
        }
        
        self.emptyView.hidden = YES;
        
        [self.view endEditing:YES];
        [ghTableView reloadData];
        [loadingError dismiss];
        [loadingView dismiss];
    }];
}

#pragma mark -- WQPopupWindowEncourageViewDelegate
- (void)wqSubmitBtnClike:(WQPopupWindowEncourageView *)encourageView moneyString:(NSString *)moneyString {
    [self.popupWindowEncourageView.moneyTextField endEditing:YES];
    // 打赏提交的响应事件
    NSString *urlString = @"api/moment/status/rewardstatus";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"money"] = moneyString;
    params[@"mid"] = self.midString;
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
        BOOL whetherTread = [response[@"success"]boolValue];
        if (whetherTread) {
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

- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton {
    
    // 万圈动态
    sendButton.enabled = NO;
    if ([self.type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        NSString *urlString = @"api/moment/status/sendcomment";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"content"] = view.inputtextView.text;
        params[@"mid"] = self.midString;
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
                [self loadListWithSearchText:self.searchText];
            }else {
                sendButton.enabled = YES;
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送不成功，请重试" andAnimated:YES andTime:1.5];
            }
        }];
    }else if ([self.type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        NSString *urlString = @"api/choicest/articlecreatecomment";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"content"] = view.inputtextView.text;
        params[@"choicest_id"] = self.midString;
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
                [self loadListWithSearchText:self.searchText];
            }else {
                sendButton.enabled = YES;
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送不成功，请重试" andAnimated:YES andTime:1.5];
            }
        }];
    }
}

#pragma mark -- WQdynamicTableViewCellDelegate
- (void)wqContentLabelClick:(WQdynamicTableViewCell *)cell {
    // 万圈动态
    if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        WQdynamicDetailsViewConroller *vc = [[WQdynamicDetailsViewConroller alloc] init];
        vc.mid = cell.model.moment_status.id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        WQEssenceDetailController *vc = [[WQEssenceDetailController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)wqUser_picImageViewClick:(WQdynamicTableViewCell *)cell {
    // 头像的响应事件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    NSString *uid;
    if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        // 万圈状态
        uid = cell.model.moment_status.user_id;
    }else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        uid = cell.model.moment_choicest_article.user_id;
    }
    
    WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:uid];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wqGuanzhuBtnClick:(WQdynamicTableViewCell *)cell {
    // 关注的响应事件
    // 已关注
    if (cell.model.moment_choicest_article.user_followed) {
        // 取消关注
        NSString *urlString = @"api/user/follow/deletefollow";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"uid"] = cell.model.moment_choicest_article.user_id;
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
                cell.model.moment_choicest_article.user_followed = NO;
                cell.userInformationView.guanzhuBtn.backgroundColor = [UIColor whiteColor];
                [cell.userInformationView.guanzhuBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
                [cell.userInformationView.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
            }
        }];
    }else {
        NSString *urlString = @"api/user/follow/createfollow";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"uid"] = cell.model.moment_choicest_article.user_id;
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
                cell.model.moment_choicest_article.user_followed = YES;
                cell.userInformationView.guanzhuBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
                [cell.userInformationView.guanzhuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.userInformationView.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)wqLinksContentViewClick:(WQLinksContentView *)linksContentView cell:(WQdynamicTableViewCell *)cell {
    // 外链的响应事件
    WQTopicArticleController *vc = [[WQTopicArticleController alloc] init];
    vc.URLString = cell.model.moment_status.link_url;
    vc.NavTitle = cell.model.moment_status.link_txt;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wqPraiseBtnClick:(WQdynamicToobarView *)yoobarView cell:(WQdynamicTableViewCell *)cell {
    // 赞的响应事件
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString;
    // 万圈状态
    if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        urlString = @"api/moment/status/likeordislike";
        params[@"mid"] = cell.model.moment_status.id;
        params[@"like"] = @"true";
    }else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        urlString = @"api/choicest/articlelike";
        params[@"choicest_id"] = cell.model.moment_choicest_article.id;
    }
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
            [yoobarView.praiseBtn setImage:[UIImage imageNamed:@"dynamicyidianzan"] forState:UIControlStateNormal];
            [yoobarView.praiseBtn setTitleColor:[UIColor colorWithHex:0xee9b11] forState:UIControlStateNormal];
            if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
                // 万圈状态
                cell.model.moment_status.can_like = NO;
                NSInteger i = [cell.model.moment_status.like_count integerValue];
                cell.model.moment_status.like_count = [NSString stringWithFormat:@"%zd",i + 1];
            }else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
                // 精选状态
                cell.model.moment_choicest_article.can_like = NO;
                NSInteger i = [cell.model.moment_choicest_article.like_count integerValue];
                cell.model.moment_choicest_article.like_count = [NSString stringWithFormat:@"%zd",i + 1];
            }
            
            [WQAlert showAlertWithTitle:nil message:WQ_ZAN_MESSAGE duration:1];
            
            [ghTableView reloadData];
        }
    }];
}

#pragma mark -- WQdynamicTableViewCellDelegate
- (void)wqGroupNameClick:(WQessenceView *)essenceView cell:(WQdynamicTableViewCell *)cell {
    // 来自圈子的响应事件
    WQGroupInformationViewController *vc = [[WQGroupInformationViewController alloc] init];
    vc.gid = cell.model.moment_choicest_article.article_group_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wqCommentsBtnClick:(WQdynamicToobarView *)yoobarView cell:(WQdynamicTableViewCell *)cell {
    // 评论的响应事件
    self.type = cell.model.moment_type;
    self.isTextInputView = YES;
    // 评论的响应事件
    // 万圈动态
    if ([cell.model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        // 评论的数量
        if ([cell.model.moment_status.comment_count integerValue] == 0) {
            // 评论的数量为O时
            self.midString = cell.model.moment_status.id;
            [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
        }else {
            WQdynamicDetailsViewConroller *vc = [[WQdynamicDetailsViewConroller alloc] init];
            vc.isComment = YES;
            vc.mid = cell.model.moment_status.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([cell.model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 评论的数量
        if (cell.model.moment_choicest_article.comment_count == 0) {
            // 评论的数量为O时
            self.midString = cell.model.moment_choicest_article.id;
            [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
        }else {
            WQEssenceDetailController *vc = [[WQEssenceDetailController alloc] init];
            vc.isComment = YES;
            vc.model = cell.model.moment_choicest_article;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)wqSharBtnClick:(WQdynamicToobarView *)yoobarView cell:(WQdynamicTableViewCell *)cell {
    // 分享的响应事件
    self.type = cell.model.moment_type;
    self.articleModel = cell.model.moment_choicest_article;
    self.moment_statusModel = cell.model.moment_status;
    // 分享的响应事件
    __weak typeof(self) weakSelf = self;
    //显示分享面板
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
        }
    }];
}

- (void)wqCaiBtnClick:(WQdynamicToobarView *)toobarView cell:(WQdynamicTableViewCell *)cell {
    // 踩的响应事件
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/moment/status/likeordislike";
    params[@"mid"] = cell.model.moment_status.id;
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
            cell.model.moment_status.dislike_count = cell.model.moment_status.dislike_count + 1;
            [ghTableView beginUpdates];
            [ghTableView reloadData];
            [ghTableView endUpdates];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}

- (void)wqEencourageBtnClick:(WQdynamicToobarView *)toobarView cell:(WQdynamicTableViewCell *)cell {
    // 鼓励的响应事件
    self.popupWindowEncourageView.hidden = NO;
    self.midString = cell.model.moment_status.id;
    [self.popupWindowEncourageView.moneyTextField becomeFirstResponder];
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQdynamicHomeModel *model = self.dataArray[indexPath.row];
    // 万圈动态
    if ([model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        WQdynamicDetailsViewConroller *vc = [[WQdynamicDetailsViewConroller alloc] init];
        vc.isComment = NO;
        vc.mid = model.moment_status.id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        WQEssenceDetailController *vc = [[WQEssenceDetailController alloc] init];
        vc.model = model.moment_choicest_article;
        vc.isComment = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQdynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    tableView.rowHeight = UITableViewAutomaticDimension;
    cell.delegate = self;
    cell.dynamicContentView.picImageview.image = nil;
    cell.dynamicContentView.imageView.image = nil;
    cell.model = self.dataArray[indexPath.row];
        
    return cell;
}

#pragma mark -- WQSearchViewDelegate
- (void)wqSearchViewCancelBtnClick:(WQSearchView *)searchView {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击X的时候在此展开键盘
- (void)wqDeleteClick:(WQSearchView *)searchView {
    [self.searchView.searchTextField becomeFirstResponder];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -44;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return HEX(0xf3f3f3);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"sousuowuneirong"];
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString * str  = [[NSMutableAttributedString alloc] init];
    NSDictionary * att = @{NSForegroundColorAttributeName:HEX(0x999999),
                           NSFontAttributeName:[UIFont systemFontOfSize:14],
                           NSParagraphStyleAttributeName:paragraphStyle};
    
    NSString * noResult = @"\n暂时没找到相关内容";
    
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:noResult attributes:att]];
    [str setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:6],
                         NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, 1)];
    
    return str;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.view endEditing:YES];
}

#pragma mark -- dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    // 万圈状态
    if ([self.type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        NSString *imageUrl;
        if (self.moment_statusModel.pic.count) {
            imageUrl = [imageUrlString stringByAppendingString:self.moment_statusModel.pic.firstObject];
        }else {
            imageUrl = @"https://wanquan.belightinnovation.com/metronic_v4.5.2/theme/assets/pages/img/admin-logo.png";
        }
        NSString *titleString = @"万圈动态 - 关注校友最新动态";
        NSString *contentString;
        if (self.moment_statusModel.content.length) {
            contentString = self.moment_statusModel.content;
        }else {
            contentString = @"您的好友发表了图片和链接,进入查看详情";
        }
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString descr:contentString           thumImage:imageUrl];
        //设置网页地址
        shareObject.webpageUrl = [[BASE_URL_STRING stringByAppendingString:@"front/momentStatus/momentStatusH5Show?&mid="] stringByAppendingString:self.moment_statusModel.id];
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
    }else if ([self.type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
        // 精选状态
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        NSString *thumbURL = WEB_IMAGE_LARGE_URLSTRING(self.articleModel.essenceCover);
        NSString *titleString = [NSString stringWithFormat:@"万圈精选 - %@",self.articleModel.essenceSubject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString
                                                                                 descr:self.articleModel.essenceDesc
                                                                             thumImage:thumbURL];
        
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@front/choicest/articleh5show?choicest_id=%@",BASE_URL_STRING,self.articleModel.essenceId.length ? self.articleModel.essenceId : @"8feb4a1d891943aeb0d382269602ea2f"];
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
