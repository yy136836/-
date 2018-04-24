//
//  WQparticularsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/21.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <YYLabel.h>
#import "WQparticularsViewController.h"
#import "WQparticularsTableViewCell.h"
#import "WQparticularsModel.h"
#import "WQOriginalStatusView.h"
#import "WQretweetStatus.h"
#import "WQStatusToolBar.h"
#import "WQsourceMomentStatusModel.h"
#import "WQzanLike_listModel.h"
#import "WQlikeListView.h"
#import "WQfeedbackViewController.h"
#import "WQcommentsDetailsTableviewCell.h"
#import "WQUserProfileController.h"
#import "WQcommentListModel.h"
#import "WQMiriadeViewController.h"
#import "WQPopupWindowEncourageView.h"
#import "WQCommentsInputView.h"
#import "WQTopicArticleController.h"
#import "WQTextInputViewWithOutImage.h"
#import "WQParticularCommentCell.h"

#define gHframeHWXY 0

static NSString *cellid = @"cellid";
static NSString *identifier = @"identifier";

@interface WQparticularsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,WQcommentsDetailsTableviewCellDelegate,ParticularCommentCellReplyDelegate,WQPopupWindowEncourageViewDelegate,WQCommentsInputViewDelegate,WQTextInputViewWithOutImageDelegate,statusToolBarBtnClikedelegate>
@property (nonatomic, strong) WQparticularsTableViewCell *cell;
@property (nonatomic, strong) WQparticularsModel *model;
@property (nonatomic, strong) WQPopupWindowEncourageView *popupWindowEncourageView;
@property (nonatomic, strong) WQCommentsInputView *commentsInputView;
/**
 评论的输入框
 */
@property (nonatomic, strong) WQTextInputViewWithOutImage *textInputViewWithOutImage;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *playTourParams;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *zanParams;
@property (nonatomic, strong) NSMutableDictionary *caiParams;
@property (nonatomic, strong) NSMutableDictionary *commentsParams;
@property (nonatomic, strong) NSMutableDictionary *forwardingParams;
@property (nonatomic, strong) UITextField *shardTextField;
@property (nonatomic, copy) NSString *midString;
@property (nonatomic, copy) NSString *moneyString;


/**
 正在回复的评论的 id
 */
@property (nonatomic, copy) NSString * replyId;

@end

@implementation WQparticularsViewController {
    WQLoadingView *loadingView;
}

- (instancetype)initWithmId:(NSString *)mid {
    if (self = [super init]) {
        self.midString = mid;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"好友圈详情";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    UIBarButtonItem *righttwoBtn = [[UIBarButtonItem alloc]initWithTitle:@"反馈" style:UIBarButtonItemStylePlain target:self action:@selector(fankuiBtnClike)];
    self.navigationItem.rightBarButtonItem = righttwoBtn;
    [righttwoBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:0x000000]} forState:UIControlStateNormal];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationController.navigationBar.shadowImage = WQ_SHADOW_IMAGE;
    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self loadData];
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -- WQCommentsInputViewDelegate
- (void)wqStartEditing:(WQCommentsInputView *)commentsView {
//    __weak typeof(self) weakSelf = self;
//    if (weakSelf.commentTextFieldCliekBlick) {
//        weakSelf.commentTextFieldCliekBlick();
//    }
}

- (void)wqCommentsTextField:(WQCommentsInputView *)commentsView commentsContentString:(NSString *)commentsContent {
    

}

#pragma mark - 监听通知
- (void)keyboardWasShown:(NSNotification*)noti {
    
    __weak typeof(self) weakSelf = self;
    if (weakSelf.shardTextField.isFirstResponder) {
        weakSelf.shardTextField.placeholder = @"输入转发内容不超过100字";
        NSDictionary *userInfo = noti.userInfo;
        CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect textRect = weakSelf.shardTextField.frame;
        textRect.origin.y = rect.origin.y - 40;
        textRect.size.height = 40;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.shardTextField.frame = textRect;
        }];
    }else {
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
    CGRect textRect = self.shardTextField.frame;
    textRect.size.height = gHframeHWXY;
    textRect.origin.y = self.view.frame.size.height;
    self.shardTextField.placeholder = nil;
    self.shardTextField.frame = textRect;
    self.shardTextField.text = @"";
    self.shardTextField.leftView = nil;
    [self.textInputViewWithOutImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(TAB_HEIGHT - 50));
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 初始化UI 
- (void)setupUI {
    WQCommentsInputView *commentsInputView = [[WQCommentsInputView alloc] init];
    
    __weak typeof(commentsInputView) weakCommentsInputView = commentsInputView;
    [commentsInputView setWqChangeHeightBlock:^(CGFloat h) {
        [weakCommentsInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(h + ghStatusCellMargin);
        }];
    }];
    
    commentsInputView.delagate = self;
    self.commentsInputView = commentsInputView;
    [self.view addSubview:commentsInputView];
    [commentsInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
    
    UITableView *tableview = [[UITableView alloc] init];
    [tableview registerClass:[WQparticularsTableViewCell class] forCellReuseIdentifier:cellid];
    [tableview registerClass:[WQcommentsDetailsTableviewCell class] forCellReuseIdentifier:identifier];
    [tableview registerNib:[UINib nibWithNibName:@"WQParticularCommentCell" bundle:nil] forCellReuseIdentifier:@"WQParticularCommentCell"];
    tableview.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.tableview = tableview;
    // 设置自动行高

    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:tableview];
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(commentsInputView.mas_top);
    }];
    
    _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    tableview.dataSource = self;
    tableview.delegate = self;
    
    if(@available(iOS 11.0, *)) {
        tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableview.estimatedSectionFooterHeight = 0;
        tableview.estimatedSectionHeaderHeight = 0;
        tableview.estimatedRowHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    tableview.rowHeight = UITableViewAutomaticDimension;
    // 设置预估行高
    tableview.estimatedRowHeight = 500;
    //[self.view addSubview:self.commentTextField];
    [self.view addSubview:self.shardTextField];
    
    // 鼓励的弹窗
    WQPopupWindowEncourageView *popupWindowEncourageView = [[WQPopupWindowEncourageView alloc] init];
    popupWindowEncourageView.delegate = self;
    popupWindowEncourageView.hidden = YES;
    self.popupWindowEncourageView = popupWindowEncourageView;
    [self.view addSubview:popupWindowEncourageView];
    [popupWindowEncourageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
    
    // 评论的输入框
    self.textInputViewWithOutImage = [[NSBundle mainBundle] loadNibNamed:@"WQTextInputViewWithOutImage" owner:self options:nil].lastObject;
    [self.view addSubview:self.textInputViewWithOutImage];
    self.textInputViewWithOutImage.delegate = self;
    self.textInputViewWithOutImage.inputtextView.delegate = self;
    self.textInputViewWithOutImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textInputViewWithOutImageClick:)];
    [self.textInputViewWithOutImage addGestureRecognizer:tap];
    [self.textInputViewWithOutImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(TAB_HEIGHT - 50));
        make.height.greaterThanOrEqualTo(@50);
        make.height.lessThanOrEqualTo(@130);
    }];
}

- (void)textInputViewWithOutImageClick:(UITapGestureRecognizer *)tap {
    [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
    self.textInputViewWithOutImage.inputtextView.text = @"";
}

#pragma mark -- WQPopupWindowEncourageViewDelegate
- (void)wqSubmitBtnClike:(WQPopupWindowEncourageView *)encourageView moneyString:(NSString *)moneyString {
    [self.popupWindowEncourageView.moneyTextField endEditing:YES];
    // 打赏提交的响应事件
    
//    if ([_model.user_id isEqualToString:[EMClient sharedClient].currentUsername]) {
//        WQAlert showAlertWithTitle:nil message:<#(NSString *)#> duration:<#(NSTimeInterval)#>
//    }
    [self PlayTourDetermineBtnClikeMoneyString:moneyString];
}

- (void)wqCancelBtn:(WQPopupWindowEncourageView *)encourageView {
    // 打赏取消的响应事件
    encourageView.hidden = YES;
    [self.popupWindowEncourageView.moneyTextField endEditing:YES];
}

- (void)fankuiBtnClike {
    
    if (![WQDataSource sharedTool].isVerified) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"请实名认证后操作"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                                                      
                                                                      [self.navigationController pushViewController:vc animated:YES];
                                                                  }];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    if ([role_id isEqualToString:@"200"]) {
        
        [WQAlert showAlertWithTitle:nil message:@"请登录后投诉" duration:1.5];
    }
    
    WQfeedbackViewController *feedbackVc = [WQfeedbackViewController new];
    feedbackVc.feedbackType = TYPE_MOMENT;
    [self.navigationController pushViewController:feedbackVc animated:YES];
}

#pragma mark - 请求数据
- (void)loadData {
    NSString *urlString = @"api/moment/status/getstatus";
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    _params[@"mid"] = self.midString;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        
        if (![response[@"success"] boolValue]) {
            //[WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.3];
            return;
        }
        
        WQparticularsModel *model = [WQparticularsModel yy_modelWithJSON:response];
        
        self.model = model;
        
        if (model.truename) {
            switch (model.user_tag.count) {
                case 0:{
                    self.cell.originalStatusView.tagOncLabel.hidden = YES;
                    self.cell.originalStatusView.tagTwoLabel.hidden = YES;
                }
                    break;
                case 1:{
                    self.cell.originalStatusView.tagOncLabel.hidden = NO;
                    self.cell.originalStatusView.tagTwoLabel.hidden = YES;
                    self.cell.originalStatusView.tagOncLabel.text = model.user_tag.firstObject;
                }
                    break;
                case 2:{
                    self.cell.originalStatusView.tagOncLabel.hidden = NO;
                    self.cell.originalStatusView.tagTwoLabel.hidden = NO;
                    self.cell.originalStatusView.tagOncLabel.text = model.user_tag.firstObject;
                    self.cell.originalStatusView.tagTwoLabel.text = model.user_tag.lastObject;
                }
                    break;
                default:
                    break;
            }
        }else {
            self.cell.originalStatusView.tagOncLabel.hidden = YES;
            self.cell.originalStatusView.tagTwoLabel.hidden = YES;
        }
        
        if ([model.user_name isEqualToString:@""]) {
            self.cell.originalStatusView.nameLabel.text = @"好友的好友";
            self.cell.originalStatusView.iconView.image = [UIImage imageNamed:@"Userpic"];
        }else {
            self.cell.originalStatusView.nameLabel.text = model.user_name;
            [self.cell.originalStatusView.iconView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] options:0];
        }
        
        NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString:model.content];
        text.yy_lineSpacing = 5;
        text.yy_font = [UIFont systemFontOfSize:17];
        self.cell.retweetStatusView.contentLabel.attributedText = text;
        
        //self.cell.retweetStatusView.contentLabel.attributedText = [self getAttributedStringWithString:model.content lineSpace:5];
        self.cell.statusToolBarView.likeLabel.text = [NSString stringWithFormat:@"%d",model.like_count];
        self.cell.statusToolBarView.TreadLable.text = [NSString stringWithFormat:@"%d",model.dislike_count];
        self.cell.statusToolBarView.CommentsLabel.text = [NSString stringWithFormat:@"%d",model.comment_count];
        self.cell.picArray = model.source_moment_status.pic;
        self.cell.model = model;
        self.cell.likeListView.likeArray = self.model.like_list;
        [self.tableview reloadData];
    }];
}

#pragma mark -- 评论的响应事件
- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton {
    NSString *urlString = @"api/moment/status/sendcomment";
    self.commentsParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    _commentsParams[@"content"] = view.inputtextView.text;
    _commentsParams[@"mid"] = self.midString;
    
    if (self.replyId.length) {
        _commentsParams[@"ori_comment_id"] = self.replyId;
    }
    sendButton.enabled = NO;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_commentsParams completion:^(id response, NSError *error) {
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
        view.inputtextView.placeholder = @"请输入评论内容";
        BOOL whetherTread = [response[@"success"]boolValue];
        if (whetherTread) {
            sendButton.enabled = YES;
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"发送成功"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }else {
            sendButton.enabled = YES;
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"发送不成功，请重试"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }
        [self loadData];
    }];
}

#pragma mark -- 转发外链的响应事件
- (void)wqForwardingLinksContentViewClick:(WQparticularsTableViewCell *)cell linkURLString:(NSString *)linkURLString {
    WQTopicArticleController *vc = [[WQTopicArticleController alloc] init];
    vc.URLString = linkURLString;
    vc.NavTitle = cell.model.link_txt;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - statusToolBarBtnClikedelegate
- (void)likBtnClike:(WQparticularsTableViewCell *)statusToolBarlikBtn mid:(NSString *)mid {
    NSString *urlString = @"api/moment/status/likeordislike";
    self.zanParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    _zanParams[@"like"] = @"true";
    _zanParams[@"mid"] = mid;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_zanParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL whetherlike = [response[@"success"]boolValue];
        if (whetherlike == 0) {
            [WQAlert showAlertWithTitle:nil message:WQ_ZAN_MESSAGE duration:1];

            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }
        [self loadData];
    }];
}

- (void)TreadBtnClike:(WQparticularsTableViewCell *)statusToolBarTreadBtn mid:(NSString *)mid {
    NSString *urlString = @"api/moment/status/likeordislike";
    self.caiParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    _caiParams[@"like"] = @"false";
    _caiParams[@"mid"] = self.midString;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_caiParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL whetherTread = [response[@"success"]boolValue];
        if (whetherTread == 0) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
//            [SVProgressHUD setForegroundColor:[UIColor colorWithHex:0xa550d6]];
            //[SVProgressHUD showErrorWithStatus:@"不建议您自怨自艾踩自己"];
            [SVProgressHUD showErrorWithStatus:response[@"message"]];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }
        [self loadData];
    }];
}

- (void)commentsBtnClike:(WQparticularsTableViewCell *)statusToolBarcommentsBtn mid:(NSString *)mid {
    [_textInputViewWithOutImage.inputtextView becomeFirstResponder];
    [_textInputViewWithOutImage.inputtextView setValue:@"输入评论内容" forKey:@"placeholder"];
}

- (void)shareBtnClike:(WQparticularsTableViewCell *)shareBtnClike mid:(NSString *)mid {
    [self.shardTextField becomeFirstResponder];
}

- (void)wqsetPlayTourBtnDelegate:(WQparticularsTableViewCell *)wqsetPlayTourBtnClike {
    self.popupWindowEncourageView.hidden = NO;
    [self.popupWindowEncourageView.moneyTextField becomeFirstResponder];
//    [WQEditTextView showWithController:self andRequestDataBlock:^(NSString *text) {
//        NSString *moneyString = text;
//        [self PlayTourDetermineBtnClike];
//    }];
}

// 删除万圈
- (void)wqDeleteBtnClikeDelegate:(WQparticularsTableViewCell *)wqDeleteBtn {
    NSString *urlString = @"api/moment/status/deletestatus";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
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
        BOOL whetherlike = [response[@"success"]boolValue];
        if (whetherlike) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"删除成功" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
//                    if (self.deleteSuccessfulBlock) {
//                        self.deleteSuccessfulBlock();
//                    }
                    //[self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:WQdeleteSuccessful object:self userInfo:nil];
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[WQMiriadeViewController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                });
            }];
        }
    }];
}

/**
 鼓励
 */
- (void)PlayTourDetermineBtnClikeMoneyString:(NSString *)moneyString {
    NSString *urlString = @"api/moment/status/rewardstatus";
    self.playTourParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    _playTourParams[@"money"] = moneyString;
    _playTourParams[@"mid"] = self.midString;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:_playTourParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"ecode"]boolValue]) {
//            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//            [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0xa550d6]];
            [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
            [SVProgressHUD showErrorWithStatus:@"\n   余额不足请充值  \n"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            return;
        }
        
        BOOL whetherTread = [response[@"success"]boolValue];
        if (whetherTread) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"谢谢您的鼓励" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            self.popupWindowEncourageView.hidden = YES;
        }else{
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
        [self loadData];
    }];
}

#pragma make - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.shardTextField) {
        if ([textField.text isEqualToString:@""]) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return YES;
        }
        if (textField.text.length > 100) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请控制评论字数少于100字" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            return YES;
        }
        NSString *urlString = @"api/moment/status/forwardstatus";
        self.forwardingParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        _forwardingParams[@"content"] = textField.text;
        _forwardingParams[@"mid"] = self.midString;
        _forwardingParams[@"pic"] = @"[]";
        [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_forwardingParams completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            NSLog(@"%@",response);
            textField.text = nil;
            BOOL success = [response[@"success"]boolValue];
            if (success) {
                //[self loadData];
                [textField resignFirstResponder];
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"转发成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }else {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }
        }];
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    _replyId = nil;
    _commentsInputView.commentsTextView.placeholder = nil;
}

#pragma mark - WQcommentsDetailsTableviewCellDelegate
- (void)wqUser_picClick:(WQcommentsDetailsTableviewCell *)cell {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    if ([cell.model.user_id isEqualToString:im_namelogin]) {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:cell.model.user_id];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:cell.model.user_id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - tableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.model.comment_list.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
        self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cell.delegate = self;
        self.cell.originalStatusView.creditPointsLabel.text = [self.creditPoints stringByAppendingString:@"分"];
        
        __weak typeof(self) weakSelf = self;
        __weak typeof(_cell) _weakCell = _cell;
        
        // 点击头像
        [self.cell setHeadPortraitBlock:^{
            
            if (!weakSelf.model.truename) {
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"无法查看二度好友信息" preferredStyle:UIAlertControllerStyleAlert];
                
                [weakSelf presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                }];
                return ;
            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
            // 是当前账户
            if ([_weakCell.model.user_id isEqualToString:im_namelogin]) {
                WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:_weakCell.model.user_id];
                
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:_weakCell.model.user_id];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        
        return self.cell;
    } else {
//        WQcommentsDetailsTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//        cell.delegate = self;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.model = self.model.comment_list[indexPath.row];
//        return cell;
        
        WQParticularCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQParticularCommentCell"];
        
        cell.model = self.model.comment_list[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    } else {
        WQParticularCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQParticularCommentCell"];
        
//        cell.model = self.model.comment_list[indexPath.row];
        
        
        return [cell heightWhithModel:self.model.comment_list[indexPath.row]];
    }
}

#pragma mark - 回复列表点击回复按钮

- (void)particularCommentCellReplyTo:(WQcommentListModel *)model {
    [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
    _replyId = model.id;
    self.textInputViewWithOutImage.inputtextView.text = @"";
    NSString * text =[NSString stringWithFormat:@" 回复:%@ ", model.user_name];
    self.textInputViewWithOutImage.inputtextView.placeholder = text;
}




#pragma mark - 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}

- (NSString *)midString {
    if (!_midString) {
        _midString = [[NSString alloc]init];
    }
    return _midString;
}

- (NSArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSArray alloc]init];
    }
    return _modelArray;
}

- (WQparticularsTableViewCell *)cell {
    if (!_cell) {
        _cell = [[WQparticularsTableViewCell alloc]init];
    }
    return _cell;
}
- (NSMutableDictionary *)zanParams {
    if (!_zanParams) {
        _zanParams = [[NSMutableDictionary alloc]init];
    }
    return _zanParams;
}
- (NSMutableDictionary *)caiParams {
    if (!_caiParams) {
        _caiParams = [[NSMutableDictionary alloc]init];
    }
    return _caiParams;
}

- (NSMutableDictionary *)commentsParams {
    if (!_commentsParams) {
        _commentsParams = [[NSMutableDictionary alloc]init];
    }
    return _commentsParams;
}
//转发输入
- (UITextField *)shardTextField {
    if (!_shardTextField) {
        _shardTextField = [[UITextField alloc]initWithFrame:CGRectMake(gHframeHWXY, self.view.frame.size.height, self.view.frame.size.width, gHframeHWXY)];
    }
    _shardTextField.returnKeyType = UIReturnKeySend;
    _shardTextField.enablesReturnKeyAutomatically = YES;
    _shardTextField.borderStyle = UITextBorderStyleRoundedRect;
    _shardTextField.delegate = self;
    _shardTextField.returnKeyType = UIReturnKeyDone;
    return _shardTextField;
}

- (NSMutableDictionary *)playTourParams {
    if (!_playTourParams) {
        _playTourParams = [[NSMutableDictionary alloc]init];
    }
    return _playTourParams;
}

- (NSMutableDictionary *)forwardingParams {
    if (!_forwardingParams) {
        _forwardingParams = [[NSMutableDictionary alloc] init];
    }
    return _forwardingParams;
}

#pragma mark -- 行间距
- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

#pragma mark - 两秒后移除提示框
- (void)delayMethod {
    //两秒后移除提示框
    [SVProgressHUD dismiss];
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}
#pragma mark - 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
