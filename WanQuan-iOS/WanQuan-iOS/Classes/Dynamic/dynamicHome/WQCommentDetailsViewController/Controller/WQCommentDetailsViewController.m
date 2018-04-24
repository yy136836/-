//
//  WQCommentDetailsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/15.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQCommentDetailsViewController.h"
#import "WQCommentLevelOncTableViewCell.h"
#import "WQCommentDetailsTableViewCell.h"
#import "WQDynamicLevelOncCommentModel.h"
#import "WQDynamicLevelSecondaryModel.h"
#import "WQTextInputViewWithOutImage.h"
#import "WQLoginPopupWindow.h"
#import "WQLogInController.h"
#import "WQUserProfileController.h"

static NSString *identifier = @"identifier";
static NSString *interestedInIdentifier = @"interestedInIdentifier";

@interface WQCommentDetailsViewController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,WQTextInputViewWithOutImageDelegate,WQCommentDetailsTableViewCellDelegate,WQLoginPopupWindowDelegate>

/**
 底部评论输入框
 */
@property (nonatomic, strong) WQTextInputViewWithOutImage *textInputViewWithOutImage;

/**
 二级评论数据
 */
@property (nonatomic, strong) NSArray *comments;

/**
 参数
 */
@property (nonatomic, strong) NSMutableDictionary *params;

/**
 回复id
 */
@property (nonatomic, copy) NSString *replyid;

/**
 cell的index
 */
@property (nonatomic, strong) NSIndexPath *index;

@end

@implementation WQCommentDetailsViewController {
    UITableView *ghTableView;
    WQLoginPopupWindow *loginPopupWindow;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"评论详情";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    
    WQNavBackButton *btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    
    
    if (!_model) {
        [self loadCommentDetail];
    } else {
        [self loadList];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"加载中…"];
    
    // 键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.replyid = self.model.id;
    [self setUpView];
}

#pragma mark -- 初始化View
- (void)setUpView {
    ghTableView = [[UITableView alloc] init];
    ghTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    ghTableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    if(@available(iOS 11.0, *)) {
        ghTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        ghTableView.estimatedSectionFooterHeight = 0;
        ghTableView.estimatedSectionHeaderHeight = 0;
        ghTableView.estimatedRowHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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
    [ghTableView registerClass:[WQCommentLevelOncTableViewCell class] forCellReuseIdentifier:identifier];
    [ghTableView registerClass:[WQCommentDetailsTableViewCell class] forCellReuseIdentifier:interestedInIdentifier];
    [self.view addSubview:ghTableView];
    [ghTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
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
    
    
    
    if (_isShowKeyBord) {
        __weak typeof(self)  weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf.textInputViewWithOutImage.inputtextView becomeFirstResponder];
        });        
    }
    
}

- (void)setIsnid:(BOOL)isnid {
    _isnid = isnid;
    if (isnid) {
        NSString *urlString = @"api/need/comment/getNeedCommentInfo";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"cid"] = self.mid;
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
            self.model = [WQDynamicLevelOncCommentModel yy_modelWithJSON:response];
            [SVProgressHUD dismissWithDelay:0.3];
            [ghTableView reloadData];
        }];
    }
}

- (void)loadList {
    
    if (self.isnid) {
        NSString *urlString = @"api/need/comment/getNeedComment2List";
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"comment_id"] = self.mid.length ? self.mid : self.model.id;;
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
            
            self.comments = [NSArray yy_modelArrayWithClass:[WQDynamicLevelSecondaryModel class] json:response[@"comments"]];
            
            [ghTableView reloadData];
        }];
        return;
    }
    
    NSString *urlString;
    if (_type == CommentDetailTypeMoment) {
        urlString = @"api/moment/status/getcomment2list";
    }else if (_type == CommentDetailTypeEssence) {
        urlString = @"api/choicest/articlegetcomment2list";
    }else {
        urlString = @"api/need/comment/getNeedComment2List";
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"comment_id"] = _commentId.length ? _commentId : self.model.id;
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
        
        self.comments = [NSArray yy_modelArrayWithClass:[WQDynamicLevelSecondaryModel class] json:response[@"comments"]];
        
        [ghTableView reloadData];
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

#pragma mark -- WQTextInputViewWithOutImageDelegate
- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton {
    if(![view.inputtextView.text isVisibleString]) {
        [WQAlert showAlertWithTitle:nil message:@"未填写有效内容" duration:1];
        return;
    }
    
    sendButton.enabled = NO;
    NSString *urlString;
    if (_type == CommentDetailTypeMoment) {
        urlString = @"api/moment/status/sendcomment";
    }else if (_type == CommentDetailTypeEssence) {
        urlString = @"api/choicest/articlecreatecomment";
    }else {
        urlString = @"api/need/comment/createComments";
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"content"] = view.inputtextView.text;
        params[@"need_id"] = self.nid;
        if (self.replyid.length) {
            params[@"ori_comment_id"] = self.replyid;
        }else {
            params[@"ori_comment_id"] = self.commentId;
        }
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
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送成功" andAnimated:YES andTime:1.5];
                [self loadList];
                sendButton.enabled = YES;
                if (self.SendSuccessCommentBlock) {
                    self.SendSuccessCommentBlock();
                }
            }else {
                sendButton.enabled = YES;
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送不成功，请重试" andAnimated:YES andTime:1.5];
            }
        }];
        return;
    }
    
    self.params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    self.params[@"content"] = view.inputtextView.text;
    if (_type == CommentDetailTypeMoment) {
        self.params[@"mid"] = self.mid;
    } else {
        self.params[@"choicest_id"] = self.mid;
    }
    
    self.params[@"ori_comment_id"] = self.replyid.length ? self.replyid : self.model.id;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:self.params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送不成功，请重试" andAnimated:YES andTime:1.5];
            sendButton.enabled = YES;
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        //取消键盘第一响应者
        [view.inputtextView resignFirstResponder];
        view.inputtextView.placeholder = @"聊聊您的想法";
        if ([response[@"success"] boolValue]) {
            sendButton.enabled = YES;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送成功" andAnimated:YES andTime:1.5];
            self.replyid = self.model.id;
            _textInputViewWithOutImage.inputtextView.text = @"";
            view.inputtextView.text = nil;
            [self loadList];
            if (self.SendSuccessCommentBlock) {
                self.SendSuccessCommentBlock();
            }

        }else {
            sendButton.enabled = YES;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"发送不成功，请重试" andAnimated:YES andTime:1.5];
        }
        [self loadList];
    }];
}

- (void)textInputViewWithOutImageClick {
    [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
}

#pragma mark -- WQCommentDetailsTableViewCellDelegate
- (void)wqPraiseBtnClick:(WQCommentDetailsTableViewCell *)cell {
    NSString *urlString = _type == CommentDetailTypeMoment ?  @"api/moment/status/commentlike" : @"api/choicest/articlecommentlike";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"comment_id"] = cell.model.id;
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

- (void)loadCommentDetail {
    NSString * strURL;
    if (self.type == CommentDetailTypeMoment) {
        strURL = @"api/moment/status/getMomentStatusTopicCommentInfo";
    } else {
        strURL = @"api/choicest/getArticleTopicCommentInfo";
    }
    

    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"cid"] = _commentId;
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        if ([response[@"success"] boolValue]) {
            _model = [WQDynamicLevelOncCommentModel new];
            [_model WQSetValuesForKeysWithDictionary:response];
            _mid = _model.aid.length ? _model.aid : _model.mid;
            [self loadList];
        }
    }];
}

- (void)setModel:(WQDynamicLevelOncCommentModel *)model {
    _model = model;
    NSLog(@"%@",model);
}

#pragma mark -- UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        WQDynamicLevelSecondaryModel *model = self.comments[indexPath.row];
        self.replyid = model.id;
        [self.textInputViewWithOutImage.inputtextView becomeFirstResponder];
        self.textInputViewWithOutImage.inputtextView.placeholder = [NSString stringWithFormat:@"回复%@",model.user_name];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.comments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        WQCommentLevelOncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        if (_type == CommentDetaiTypeNeeds) {
            cell.praiseBtn.hidden = YES;
        }
        if (self.isnid) {
            cell.nid = self.nid;
        }
        cell.isnid = self.isnid;
        [cell setHeadBtnClikeBlock:^{
            NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
            if ([role_id isEqualToString:@"200"]) {
                [self showLogin];
                return ;
            }
            WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:cell.model.user_id];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        if (_commentId.length) {
            cell.fromMessage = YES;
        }
        
        [cell setRefreshBlock:^{
            [tableView reloadData];
        }];
        
        cell.model = self.model;
        
        UILongPressGestureRecognizer * longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    }else {
        WQCommentDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:interestedInIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.comments[indexPath.row];
        
        if (_type == CommentDetaiTypeNeeds) {
            cell.praiseBtn.hidden = YES;
        }
        
        [cell setHeadBtnClikeBlock:^{
            NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
            if ([role_id isEqualToString:@"200"]) {
                [self showLogin];
                return ;
            }
            
            WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:cell.model.user_id];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
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
        if (indexPath.section == 0) {
            WQCommentLevelOncTableViewCell *cell = [ghTableView cellForRowAtIndexPath:indexPath];
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
        }else {
            WQCommentDetailsTableViewCell *cell = [ghTableView cellForRowAtIndexPath:indexPath];
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
}

// 复制
- (void)handleCopyCell:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if (self.index.section == 0) {
        WQCommentLevelOncTableViewCell *cell = [ghTableView cellForRowAtIndexPath:self.index];
        pasteboard.string = cell.contentLabel.text;
    }else {
        WQCommentDetailsTableViewCell *cell = [ghTableView cellForRowAtIndexPath:self.index];
        pasteboard.string = cell.contentLabel.text;
    }
}

// 删除
- (void)handleDeleteCell:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/moment/status/deletecomment";
    if (self.index.section == 0) {
        WQCommentLevelOncTableViewCell *cell = [ghTableView cellForRowAtIndexPath:self.index];
        if (_commentId.length) {
            urlString = @"api/choicest/articledeletecomment";
            params[@"comment_id"] = _commentId;
        }else {
            urlString = @"api/moment/status/deletecomment";
            params[@"cid"] = cell.model.id;
        }
        if (_type == CommentDetaiTypeNeeds) {
            urlString = @"api/need/comment/deleteNeedComment";
            params[@"comment_id"] = cell.model.id;
            
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
                if (self.deleteCommentBlock) {
                    self.deleteCommentBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
            }
        }];
    }else {
        WQCommentDetailsTableViewCell *cell = [ghTableView cellForRowAtIndexPath:self.index];
        if (_commentId.length) {
            urlString = @"api/choicest/articledeletecomment";
            params[@"comment_id"] = cell.model.id;
        }else {
            urlString = @"api/moment/status/deletecomment";
            params[@"cid"] = cell.model.id;
        }
        
        if (_type == CommentDetaiTypeNeeds) {
            urlString = @"api/need/comment/deleteNeedComment";
            params[@"comment_id"] = cell.model.id;

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
                [self loadList];
                if (self.deleteCommentBlock) {
                    self.deleteCommentBlock();
                }
            }else {
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
            }
        }];
    }
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
        make.bottom.equalTo(self.view).offset(-(TAB_HEIGHT - 50));
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark -- 懒加载
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}


@end
