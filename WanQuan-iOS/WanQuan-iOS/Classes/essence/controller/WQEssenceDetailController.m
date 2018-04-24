//
//  WQEssenceDetailController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQEssenceDetailController.h"
#import "WQParticularCommentCell.h"
//#import "WQTopicDetailCommentView.h"
#import "WQcommentListModel.h"
#import "WQEssenceSharePopController.h"
#import "UMSocialUIManager.h"
#import "WQGroupChooseSharGroupViewController.h"
#import "WQUserProfileController.h"
#import "WQTopicArticleController.h"
#import "WQTopicDetailFooter.h"
#import "WQLoginPopupWindow.h"
#import "WQLogInController.h"
#import "WQTextInputViewWithOutImage.h"
#import "WQEssencePraiseView.h"
#import "WQPopupWindowEncourageView.h"
#import "WQmengcengView.h"
#import "WQDynamicDetailsPopupWindowView.h"
#import "WQmoment_choicest_articleModel.h"
#import "WQGroupInformationViewController.h"
//#import "WQIndividualTrendCommentModel.h"
#import "WQDynamicLevelOncCommentModel.h"
#import "WQDynamicDetailsCommentTableViewCell.h"
#import "WQEssenceTitleView.h"
#import "WQCommentDetailsViewController.h"

#import "WQfeedbackViewController.h"
#import "WQActionSheet.h"
#import "NSObject+WebLoadImage.h"
@interface WQEssenceDetailController ()<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate,UITextViewDelegate, ParticularCommentCellReplyDelegate, WQEssenceSharePopControllerDelegate, UIPopoverPresentationControllerDelegate, WQLoginPopupWindowDelegate,WQTextInputViewWithOutImageDelegate, WQEssencePraiseViewDelegate, WQPopupWindowEncourageViewDelegate,WQDynamicDetailsCommentTableViewCellDelegate,WQActionSheetDelegate>
{

}
@property (nonatomic, retain) UITableView * mainTable;

/**
 评论数组
 */
@property (nonatomic, retain) NSMutableArray * comments;

/**
 热门评论
 */
@property (nonatomic, retain) NSMutableArray * hotComments;

/**
 底部评论按钮
 */
@property (nonatomic, retain) WQTextInputViewWithOutImage * commentView;

/**
 加载的精选的链接
 */
@property (nonatomic, copy) NSString * articleURLString;

/**
 分享的链接
 */
@property (nonatomic, copy) NSString * shareLinkURLString;

/**
 正在回复的人的 id
 */
@property (nonatomic, copy) NSString * replyingId;

@property (nonatomic, retain) WQEssenceSharePopController * popOverVC;
@property (nonatomic, retain) UIBarButtonItem * shareItem;

/**
 是否正在评论评论的话等结束滚到最下端
 */
@property (nonatomic, assign) BOOL commenting;

@property (nonatomic, retain) WQPopupWindowEncourageView * popupWindowEncourageView;

/**
 点赞数
 */
@property (nonatomic, assign) NSInteger like_count;

@property (nonatomic, weak) UIButton * zanButton;


@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger count;

/**
 我是否赞过该精选
 */
@property (nonatomic, assign) BOOL i_like;

/**
 cell 的 index
 */
@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, strong) WQEssencePraiseView *header;

@end



@implementation WQEssenceDetailController {
    WQLoginPopupWindow *loginPopupWindow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _comments = @[].mutableCopy;
    _hotComments = @[].mutableCopy;
    
    //    todohanyang
    //#ifdef DEBUG
    //    _articleURLString = @"http://wanquan.belightinnovation.com/front/choicest/articleh5show?choicest_id=8feb4a1d891943aeb0d382269602ea2f";
    //#else
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (secreteKey.length) {
        _articleURLString = [NSString stringWithFormat:@"%@front/choicest/articleh5show?secretkey=%@&choicest_id=%@",BASE_URL_STRING,secreteKey,self.model.essenceId.length ? self.model.essenceId : @"8feb4a1d891943aeb0d382269602ea2f"];
    } else {
        _articleURLString = [NSString stringWithFormat:@"%@front/choicest/articleh5show?choicest_id=%@",BASE_URL_STRING,self.model.essenceId.length ? self.model.essenceId : @"8feb4a1d891943aeb0d382269602ea2f"];
    }
    _shareLinkURLString = [NSString stringWithFormat:@"%@front/choicest/articleh5show?choicest_id=%@",BASE_URL_STRING,self.model.essenceId.length ? self.model.essenceId : @"8feb4a1d891943aeb0d382269602ea2f"];
    //#endif
    
    loginPopupWindow = [[WQLoginPopupWindow alloc] init];
    loginPopupWindow.delegate = self;
    loginPopupWindow.hidden = YES;
    [[UIApplication sharedApplication].delegate.window addSubview:loginPopupWindow];
    [loginPopupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].delegate.window);
    }];
    
    _like_count = _model.essenceLikeCount;
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    // 复制链接
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(copyLink) name:WQSharCopyLink object:nil];
    
    [self loadArticalDetail];
}

#pragma mark -- 复制链接
- (void)copyLink {
    UMShareMenuSelectionView *view = [[UMShareMenuSelectionView alloc] init];
    [view hiddenShareMenuView];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareLinkURLString;
    [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //    加载网页
    _commenting = NO;
    //    [IQKeyboardManager sharedManager].enable = YES;
    self.navigationItem.title = @"万圈精选";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:[UIColor blackColor]];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    

    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    _shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiangqunmingpian"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    UIButton * moreButton = [[UIButton alloc] init];
    [moreButton setTitle:@"∙∙∙" forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreButton sizeToFit];
    [moreButton addTarget:self action:@selector(barBtnsClick) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *barBtns = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.navigationItem.rightBarButtonItems = @[barBtns,_shareItem];
 
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

- (void)setupUI {
    [self.view setBackgroundColor:WQ_BG_LIGHT_GRAY];
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreenWidth, kScreenHeight - NAV_HEIGHT - TAB_HEIGHT) style:UITableViewStyleGrouped];
    if(@available(iOS 11.0, *)) {
        _mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mainTable.estimatedSectionFooterHeight = 0;
        _mainTable.estimatedSectionHeaderHeight = 0;
        _mainTable.estimatedRowHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    _webView.delegate = self;
    
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    
    
    _mainTable.separatorColor = WQ_SEPARATOR_COLOR;
    [_mainTable registerClass:[WQDynamicDetailsCommentTableViewCell class] forCellReuseIdentifier:@"WQDynamicDetailsCommentTableViewCell"];
    _mainTable.rowHeight = UITableViewAutomaticDimension;
    
    
    _mainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _mainTable.tableFooterView = [UIView new];
    _mainTable.backgroundColor = HEX(0xf3f3f3);
    _commentView = [[NSBundle mainBundle]loadNibNamed:@"WQTextInputViewWithOutImage" owner:self options:nil].lastObject;
    //    _commentView.frame = CGRectMake(0, kScreenHeight - TAB_HEIGHT, kScreenWidth, 50);
    [self.view addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(TAB_HEIGHT - 50));
        make.height.greaterThanOrEqualTo(@50);
        make.height.lessThanOrEqualTo(@130);
    }];
    _commentView.delegate = self;
    _commentView.inputtextView.delegate = self;
    _mainTable.estimatedRowHeight = 190;
    _mainTable.rowHeight = UITableViewAutomaticDimension;
    
    
}

#pragma mark --  收藏
- (void)wqScBtnClick{
    // 收藏的响应事件
    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    NSString *strURL = @"api/favorite/favorite";
    NSMutableDictionary * param = @{@"secretkey":[WQDataSource sharedTool].secretkey}.mutableCopy;
    param[@"target_id"] = self.model.essenceId;
    param[@"target_type"] = @"TYPE_CHOICEST_ARTICLE";
    param[@"favorited"] =  self.model.essenceFavorited ? @"false": @"true";
    
    [SVProgressHUD show];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD showWithStatus:@"网络连接错误"];
            [SVProgressHUD dismissWithDelay:1.3];
            return ;
        }
        
        if ([response[@"success"] boolValue]) {
            NSString * hudInfo = self.model.essenceFavorited ? @"已取消收藏" : @"已收藏至\"我的—我收藏的文章\"";
            [SVProgressHUD showWithStatus:hudInfo];
            [SVProgressHUD dismissWithDelay:1.3];
            _model.essenceFavorited = !_model.essenceFavorited;
            
            if (_FavSuccessBlock) {
                _FavSuccessBlock();
            }
        } else {
            
            [SVProgressHUD showWithStatus:response[@"message"]];
            [SVProgressHUD dismissWithDelay:1.3];
        }
        
    }];
}

#pragma mark - **************** 举报
- (void)wqReportBtnClick {
    // 举报的响应事件
    WQfeedbackViewController *vc = [[WQfeedbackViewController alloc] init];
    vc.feedbackType = TYPE_MOMENT;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_webView stopLoading];
    [IQKeyboardManager sharedManager].enable = NO;
    [SVProgressHUD dismiss];
}

#pragma mark - tableview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WQCommentDetailsViewController * vc = [[WQCommentDetailsViewController alloc] init];
    
    [vc setDeleteCommentBlock:^{
        [_comments removeAllObjects];
        [_hotComments removeAllObjects];
        [self loadArticleCommentList];
    }];
    
    [vc setSendSuccessCommentBlock:^{
        _commenting = YES;
        [self loadArticleCommentList];
    }];
    if (indexPath.section == 0) {
        vc.model = _hotComments[indexPath.row];
        vc.commentId = vc.model.id;
    }
    
    if (indexPath.section == 1) {
        vc.model = _comments[indexPath.row];
        vc.commentId = vc.model.id;
    }
    vc.mid = self.model.essenceId;
    vc.type = CommentDetailTypeEssence;
    vc.isShowKeyBord = YES;
    [self.navigationController pushViewController:vc animated:YES];;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _hotComments.count;
    }
    if (section == 1) {
        return _comments.count;
    }
    
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQDynamicDetailsCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQDynamicDetailsCommentTableViewCell"];
    UILongPressGestureRecognizer * longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:longPressGesture];
    //    cell.model = nil;
    if (!indexPath.section) {
        if (self.hotComments.count > indexPath.row) {
            
            cell.model = _hotComments[indexPath.row];
            cell.delegate = self;
        }
    }
    
    if (indexPath.section == 1) {
        if (self.comments.count > indexPath.row) {
            cell.model = self.comments[indexPath.row];
            cell.delegate = self;
        }
    }
    
    
    return cell;
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pointr = [recognizer locationInView:self.mainTable];
        NSIndexPath *indexPath = [self.mainTable indexPathForRowAtPoint:pointr];
        self.index = indexPath;
        WQDynamicDetailsCommentTableViewCell *cell = [self.mainTable cellForRowAtIndexPath:indexPath];
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
    WQDynamicDetailsCommentTableViewCell *cell = [self.mainTable cellForRowAtIndexPath:self.index];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.replyLabel.text;
}

// 删除
- (void)handleDeleteCell:(id)sender {
    WQDynamicDetailsCommentTableViewCell *cell = [self.mainTable cellForRowAtIndexPath:self.index];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/choicest/articledeletecomment";
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
            [_comments removeAllObjects];
            [_hotComments removeAllObjects];
            [self loadArticleCommentList];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return UITableViewAutomaticDimension;
//}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WQEssencePraiseView * header = [[NSBundle mainBundle] loadNibNamed:@"WQEssencePraiseView" owner:nil options:nil].lastObject;
    self.header = header;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    _zanButton = header.zanButton;
    [header.zanButton setTitle:[NSString stringWithFormat:@"%ld",_like_count] forState:UIControlStateNormal];
    // 我是否赞过该动态
    if (self.i_like) {
        [header.zanButton setImage:[UIImage imageNamed:@"dynamicyidianzan"] forState:UIControlStateNormal];
        [header.zanButton setTitleColor:[UIColor colorWithHex:0xee9b11] forState:UIControlStateNormal];
    }else {
        [header.zanButton setImage:[UIImage imageNamed:@"zanEssence"] forState:UIControlStateNormal];
        [header.zanButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    }
    header.delegate = self;
    header.contentView.backgroundColor = [UIColor whiteColor];
//    _zanButton.selected = _model.essenceLikeCount;
    if (!section) {
        header.commentTypeLabel.text = @"热门评论";
        header.clipsToBounds = YES;
        return header;
    } else {
        if (self.comments.count) {
            WQEssenceTitleView * view = [[NSBundle mainBundle] loadNibNamed:@"WQEssenceTitleView" owner:nil options:nil].lastObject;
            return view;
        }else {
            return [UIView new];
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    if (!section) {
        if (_hotComments.count) {
            return 90;
        } else {
            return 50;
        }
    }
    
    if (section == 1) {
        if (_comments.count) {
            return 40;
        }
    }
    
    return CGFLOAT_MIN;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (void)share {

    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    [self essenceSharePopShareToThird];
}

/**
 加载精选内容
 */
- (void)loadArticalDetail {
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        secreteKey = @"";
    }
    
    //    NSString * URLStr = [NSString stringWithFormat:@"%@front/choicest/articleh5show?choicest_id=%@",BASE_URL_STRING,self.model.id.length ? self.model.id : @"8feb4a1d891943aeb0d382269602ea2f"];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_articleURLString]];
    [_webView loadRequest:request];
    [SVProgressHUD show];
}

- (void)wqHeadBtnClike:(WQDynamicDetailsCommentTableViewCell *)cell {
    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    // 头像的响应事件
    WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:cell.model.user_id];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat factor = 2.0;
        
      
        CGFloat documentHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue] / factor * kScreenWidth / 375;
        _webView.frame = CGRectMake(0, 0, kScreenWidth, documentHeight);
        [self.view addSubview:_mainTable];
        
        [_mainTable beginUpdates];
        _mainTable.tableHeaderView = _webView;
        [_mainTable endUpdates];
        _webView.scrollView.scrollEnabled = NO;
        //        [self loadCommentDetail];
        
        
        [self loadArticleCommentList];
        [self refreshZanCount];
    });
    
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //    TODOHanyang
    
    
    NSString *requestString =  request.URL.absoluteString;
    

    if ([requestString isEqualToString:_articleURLString]) {
        return YES;
    }
    if ([requestString hasPrefix:@"wanquan://"]) {
        //        NSString * parameterString = request.URL.parameterString;
        NSString * host = request.URL.host;
        
        if ([host isEqualToString:@"show_user_home"]) {
            
            NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
            if ([role_id isEqualToString:@"200"]) {
                [self showLogin];
                return NO;
            }
            // MARK: 点击头像
            NSDictionary * params = request.URL.parameters;
            if (params[@"uid"]) {
                WQUserProfileController * vc = [[WQUserProfileController alloc] initWithUserId:params[@"uid"]];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            return NO;
        }
        // MARK: 点击外链
        if ([host isEqualToString:@"show_3rd_link"]) {
            NSDictionary * param = request.URL.parameters;
            NSString * link = param[@"link"];
            if (link.length) {
                
                link = [link stringByRemovingPercentEncoding];
                
                if (link.length) {
                    WQTopicArticleController * vc = [[WQTopicArticleController alloc] init];
                    vc.URLString = link;
                    vc.NavTitle = @"";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
        // MARK: 进入圈名片
        if ([host isEqualToString:@"show_group_card"]) {
            NSDictionary * param = request.URL.parameters;
            NSString * link = param[@"gid"];
            
            WQGroupInformationViewController * vc = [[WQGroupInformationViewController alloc] init];
            vc.gid = link;
            [self.navigationController pushViewController:vc animated:YES];
        }
        // MARK: 调登录
        if ([host isEqualToString:@"loginOrReg_tips"]) {
            [self showLogin];
        }
        
        
    }
    return NO;
}




//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [SVProgressHUD dismiss];
//    [WQAlert showAlertWithTitle:nil message:@"网页未能打开,请尝试再次进入该网页" duration:1.2];
//}
#pragma mark - textView

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//
//}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return NO;
    }
    return YES;
}




- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString * endSStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (!endSStr.length) {
        NSDictionary *titleDict = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                    NSForegroundColorAttributeName : [UIColor colorWithHex:0x878787]};
        // 图片文本
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"comment_pinglun"];
        attachment.bounds = CGRectMake(0, 0, 16, 16);
        NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@" 评论" attributes:titleDict];
        // 合并文字
        NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
        [attM appendAttributedString:text];
        
        
        
        [textView setValue:attM forKey:@"attributedPlaceholder"];
    }
    
    if (!endSStr.isVisibleString) {
        _commentView.sendButton.enabled = NO;
    } else {
        _commentView.sendButton.enabled = YES;
    }
    
    return YES;
}




/**
 点击回车如果有内容上传内容否则收起键盘
 
 @param textField
 @return
 */
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//    if ([textField.text isVisibleString]) {
//        [self uploadComment];
//    } else {
//        [self.view endEditing:YES];
//    }
//    [textField resignFirstResponder];
//
//    return YES;
//}



/**
 当键盘收起
 重置评论 field 的placeholder
 重置回复人
 重置回复内容
 @param textField
 @param reason
 */
//- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
//    textField.leftView = [UIView new];
//    textField.text = nil;
//    _replyingId = nil;
//
//    NSDictionary *titleDict = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
//                                NSForegroundColorAttributeName : [UIColor colorWithHex:0x878787]};
//    // 图片文本
//    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//    attachment.image = [UIImage imageNamed:@"comment_pinglun"];
//    attachment.bounds = CGRectMake(0, 0, 16, 16);
//    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
//    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@" 评论" attributes:titleDict];
//    // 合并文字
//    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
//    [attM appendAttributedString:text];
//
//    _commentView.commentField.attributedPlaceholder = attM;
//}


#pragma mark - WQTextInputViewWithOutImageDelegate
- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton {
    if ([view.inputtextView.text isVisibleString]) {
        [self uploadComment:sendButton];
    } else {
        [self.view endEditing:YES];
    }
    [view.inputtextView resignFirstResponder];
    
}


#pragma mark - httpRequests
/**
 上传评论 上传完成后重新加载评论;
 */
- (void)uploadComment:(UIButton *)send {
    [SVProgressHUD show];
    NSString * strURL = @"api/choicest/articlecreatecomment";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    
    //    secretkey true string
    //    choicest_id true string
    //    ori_comment_id false string 如特定回复评论,则为被回复评论的ID
    //    content true string
    send.enabled = NO;
    [SVProgressHUD showWithStatus:@"正在发送评论..."];
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"content"] = _commentView.inputtextView.text;
    param[@"choicest_id"] = self.model? self.model.essenceId : @"8feb4a1d891943aeb0d382269602ea2f";
    
    if (_replyingId.length) {
        param[@"ori_comment_id"] = _replyingId;
    }
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    _commenting = YES;
    
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD showWithStatus:@"评论上传失败,请重试.."];
            [SVProgressHUD dismissWithDelay:1.3];
            _commenting = NO;
            send.enabled = YES;
            return ;
        }
        BOOL success = [response[@"success"]boolValue];
        if (success) {
            send.enabled = YES;
            _commentView.inputtextView.text = @"";
            [_commentView.inputtextView resignFirstResponder];
            //            [_commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //                make.height.equalTo(@50);
            //            }];
            [self.view endEditing:YES];
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [SVProgressHUD showWithStatus:@"上传成功..."];
            //            [SVProgressHUD dismissWithDelay:1.3];
        } else {
            _commenting = NO;
            send.enabled = YES;
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"发送不成功，请重试"];
            [SVProgressHUD dismissWithDelay:1.3];
        }
        
        [self loadArticleCommentList];
        _replyingId = nil;
    }];
    
}


/**
 加载评论列表
 */
- (void)loadArticleCommentList {
    [SVProgressHUD dismiss];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    NSString * strURL = @"api/choicest/articlegetcomment1list";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    //    choicest_id true string
    //    start false number 0 分页参数，从第几个开始，默认为0
    //    count false number 20
    [SVProgressHUD show];
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"start"] = @(_start);

    param[@"count"] = _commenting ? @(_comments.count + _hotComments.count + 20) : @(_count);
    param[@"choicest_id"] = self.model.essenceId.length ? self.model.essenceId : @"8feb4a1d891943aeb0d382269602ea2f";
    //    param[@"hot"] = @"true";
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost
         urlString:strURL
        parameters:param
        completion:^(id response, NSError *error) {
            
            if ([SVProgressHUD isVisible]) {
                [SVProgressHUD dismiss];
            }
            [SVProgressHUD dismiss];
            [SVProgressHUD dismiss];
            [SVProgressHUD dismiss];
            if (error) {
                [WQAlert showAlertWithTitle:nil
                                    message:@"网络请求错误"
                                   duration:1];
                [_mainTable.mj_header endRefreshing];
                [_mainTable.mj_footer endRefreshing];

                return ;
            }
            
            BOOL success = [response[@"success"]boolValue];
            
            if (!success) {
                [_mainTable.mj_header endRefreshing];
                [_mainTable.mj_footer endRefreshing];
                [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1];
                return;
            }

            
            NSArray * res = [NSArray yy_modelArrayWithClass:[WQDynamicLevelOncCommentModel class]
                                                       json:response[@"comments"]];
            
            if (_commenting) {
                [_comments removeAllObjects];
                [_hotComments removeAllObjects];
            }
            for (WQDynamicLevelOncCommentModel *model in res) {
                // 热门评论
                if (model.hot) {
                    [self.hotComments addObject:model];
                }else {
                    [self.comments addObject:model];
                }
            }
            
            [_mainTable.mj_header endRefreshing];
            if (_commenting == YES) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [_mainTable beginUpdates];
                    //                    [_mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_comments.count - 1 inSection:1]
                    //                                      atScrollPosition:UITableViewScrollPositionBottom
                    //                                              animated:YES];
//                    [_mainTable endUpdates];
                    _commenting = NO;
                });
            }
            _mainTable.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
                _start = 0;
                [_hotComments removeAllObjects];
                [_comments removeAllObjects];
                [self loadArticleCommentList];
            }];
            
            if (!_comments.count) {
                
                WQTopicDetailFooter * footer = [[NSBundle mainBundle] loadNibNamed:@"WQTopicDetailFooter" owner:self options:nil].lastObject;
                footer.frame = CGRectMake(0, 0, kScreenWidth, 150);
                _mainTable.tableFooterView = footer;
                MJRefreshAutoGifFooter * refreshFooter = (MJRefreshAutoGifFooter * )_mainTable.mj_footer;
                [refreshFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
                [refreshFooter setBackgroundColor:HEX(0xf3f3f3)];
                _mainTable.mj_footer = nil;
                
                
            } else {
                
                
                if (!_mainTable.mj_footer) {
                    _mainTable.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
                        _start = _comments.count + _hotComments.count;
                        [self loadArticleCommentList];
                    }];
                }
                _mainTable.tableFooterView = UIView.new;
                MJRefreshAutoGifFooter * refreshFooter = (MJRefreshAutoGifFooter * )_mainTable.mj_footer;
                [refreshFooter setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
                [refreshFooter setBackgroundColor:HEX(0xf3f3f3)];
                [refreshFooter setTintColor:HEX(0x333333)];
            }
            
            
            if (_comments.count % _count) {
                [_mainTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_mainTable.mj_footer endRefreshing];
            }
            [_mainTable reloadData];

        }];
    
    
}









/**
 点击评论列表的回复按钮的时间
 
 @param model 评论的模型
 */
- (void)particularCommentCellReplyTo:(WQcommentListModel *)model {
    
    _replyingId = model.id;
    [_commentView.inputtextView becomeFirstResponder];
    //    _commentView.commentField.attributedPlaceholder = nil;
    [_commentView.inputtextView setValue:[NSString stringWithFormat:@"回复%@:",model.user_name] forKey:@"placeholder"];
}

- (void)particularCommentCellshowLogin {
    [self showLogin];
}


#pragma mark - WQEssencePraiseViewDelegate
- (void)WQEssencePraiseViewZanOnClick:(UIButton *)sender {
    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
//    if (sender.selected) {
//        [WQAlert showAlertWithTitle:nil message:@"您已经赞过了" duration:1.2];
//        return;
//    }
    
    
    NSString *urlString = @"api/choicest/articlelike";
    NSMutableDictionary * params = @{}.mutableCopy;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"choicest_id"] = _model.essenceId;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(1.3 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                       });
        
        if (error) {
            [SVProgressHUD showWithStatus:@"网络连接错误.."];
            [SVProgressHUD dismissWithDelay:1.2];
            return ;
        }
        
        BOOL success = [response[@"success"] boolValue];
        if (!success) {
            
            
            if ([response[@"message"] isEqualToString:@"您已经赞过了"]) {
                [SVProgressHUD dismiss];
                [WQAlert showAlertWithTitle:nil message:@"您已经赞过了" duration:1.2];
            } else {
                
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"message"]]];
            }
            
        } else {
            sender.selected = YES;
        }
        [SVProgressHUD dismissWithDelay:1.3];
        [self refreshZanCount];
    }];
}


- (void)refreshZanCount {
    NSString * strURL = @"api/choicest/articlegetlikelist";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    
    
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"choicest_id"] = _model.essenceId;
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            _like_count = [response[@"like_count"] integerValue];;
            self.i_like = [response[@"i_like"] boolValue];
            [_zanButton setTitle:[NSString stringWithFormat:@"%ld",_like_count] forState:UIControlStateNormal];
            [self.mainTable reloadData];
        }
        
    }];
    
}


- (void)WQEssencePraiseViewPraiseOnClick:(UIButton *)sender {
    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
    
    if ([role_id isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    WQPopupWindowEncourageView *popupWindowEncourageView = [[WQPopupWindowEncourageView alloc] init];
    popupWindowEncourageView.delegate = self;
    [self.navigationController.view addSubview:popupWindowEncourageView];
    [popupWindowEncourageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    [popupWindowEncourageView.moneyTextField becomeFirstResponder];
    _popupWindowEncourageView = popupWindowEncourageView;
}


#pragma mark -- WQPopupWindowEncourageViewDelegate
- (void)wqSubmitBtnClike:(WQPopupWindowEncourageView *)encourageView moneyString:(NSString *)moneyString {
    [encourageView.moneyTextField endEditing:YES];
    // 打赏提交的响应事件
    [self PlayTourDetermineBtnClikeMoneyString:moneyString];
}

- (void)wqCancelBtn:(WQPopupWindowEncourageView *)encourageView {
    // 打赏取消的响应事件
    [encourageView.moneyTextField endEditing:YES];
    
    [encourageView removeFromSuperview];
}


- (void)PlayTourDetermineBtnClikeMoneyString:(NSString *)moneyString {
    NSString *urlString = @"api/choicest/articlereward";
    NSMutableDictionary * params = @{}.mutableCopy;
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"money"] = moneyString;
    params[@"choicest_id"] = self.model.essenceId;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"ecode"] boolValue]) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
            [SVProgressHUD showErrorWithStatus:@"\n   余额不足请充值  \n"];
            [SVProgressHUD dismissWithDelay:1.3];
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
            [self.popupWindowEncourageView removeFromSuperview];
        }else{
            
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:response[@"message"]  preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

#pragma makr -- 三个点的响应事件
- (void)barBtnsClick {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"] isEqualToString:@"200"]) {
        [self showLogin];
        return;
    }
    
    NSString *titleName = self.model.essenceFavorited ? @"取消收藏":@"收藏";
    WQActionSheet *actionSheet = [[WQActionSheet alloc]initWithTitles:@[titleName,@"举报"]];
    actionSheet.delegate = self;
    [actionSheet show];
}

- (void)clickedButton:(WQActionSheet *)sheetView ClickedName:(NSString *)name
{
    if ([name isEqualToString:@"举报"]) {
        [self wqReportBtnClick];
    }else if([name isEqualToString:@"收藏"] ||
             [name isEqualToString:@"取消收藏"]){
        [self wqScBtnClick];
    }
}






#pragma mark - essenceSharePopDelegate
- (void)essenceSharePopShareToCircle {
    [_popOverVC dismissViewControllerAnimated:YES completion:^{
        WQGroupChooseSharGroupViewController *vc = [[WQGroupChooseSharGroupViewController alloc] init];
        vc.shareType = ShareTypeChoiset;
        vc.nid = self.model.essenceId;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //    NSString *moneySplicecontent = [NSString stringWithFormat:@"%@",self.groupIntroduce];
    //创建网页内容对象
    NSString *thumbURL = WEB_IMAGE_LARGE_URLSTRING(self.model.essenceCover);
    NSString *titleString = [NSString stringWithFormat:@"万圈精选 - %@",self.model.essenceSubject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString
                                                                             descr:_model.essenceDesc
                                                                         thumImage:thumbURL];
    
    //设置网页地址
    shareObject.webpageUrl = self.shareLinkURLString;
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

#pragma mark - 友盟分享
- (void)essenceSharePopShareToThird {
    
    //    [_popOverVC dismissViewControllerAnimated:YES completion:^{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }
    __weak typeof(self) weakSelf = self;
    //显示分享面板
//    [WQSingleton sharedManager].platNum = 3;
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
        }else if (platformType == WQCopyLink){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.shareLinkURLString;
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
        }
    }];
}

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



#pragma mark - popoverPresentationController

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return YES;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showLogin {
    
    //    self.tabBarController.tabBar.hidden = YES;
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







#pragma mark -- 去登录
- (void)tologin {
    WQLogInController *vc = [[WQLogInController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- WQLoginPopupWindowDelegate
- (void)wqLoginBtnClick:(WQLoginPopupWindow *)loginPopupWindow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        loginPopupWindow.hidden = YES;
        //        self.tabBarController.tabBar.hidden = NO;
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
        //        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
    //WQRegisteredViewController *vc = [[WQRegisteredViewController alloc] init];
    WQLogInController *vc = [[WQLogInController alloc] initWithTouristLoginStatus:regist];
    //vc.isLogin = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)wqTranslucentAreaClick:(WQLoginPopupWindow *)loginPopupWindow {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loginPopupWindow.hidden = YES;
        //        self.tabBarController.tabBar.hidden = NO;
    });
    [loginPopupWindow.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(loginPopupWindow);
        make.height.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [loginPopupWindow layoutIfNeeded];
    }];
}

- (void)keyboardWasShown:(NSNotification*)noti {
    __weak typeof(self) weakSelf = self;
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.view bringSubviewToFront:_commentView];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.view);
            //            make.height.offset(50);
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-rect.size.height - TAB_HEIGHT + 50);
        }];
    }];
}

- (void)keyBoardWillHidden:(NSNotification *)noti {
    __weak typeof(self) weakSelf = self;
    [_commentView.inputtextView resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-TAB_HEIGHT + 50);
        }];
    }];
}

#pragma mark -- WQDynamicDetailsCommentTableViewCellDelegate
- (void)wqCommentsBtnClick:(WQDynamicDetailsCommentTableViewCell *)cell {
    // 评论的响应事件
    self.replyingId = cell.model.id;
    
    
    WQCommentDetailsViewController * vc = [[WQCommentDetailsViewController alloc] init];
    
    [vc setDeleteCommentBlock:^{
        [_comments removeAllObjects];
        [_hotComments removeAllObjects];
        [self loadArticleCommentList];
    }];
    [vc setSendSuccessCommentBlock:^{
        _commenting = YES;
        [self loadArticleCommentList];
    }];
    
   
    vc.model = cell.model;
    vc.commentId = vc.model.id;
    vc.mid = self.model.essenceId;
    vc.type = CommentDetailTypeEssence;
    vc.isShowKeyBord = YES;
    [self.navigationController pushViewController:vc animated:YES];;
    
   // [self.commentView.inputtextView becomeFirstResponder];
}

- (void)wqJingxuanCommentClick:(WQDynamicDetailsCommentTableViewCell *)cell
{
    WQCommentDetailsViewController * vc = [[WQCommentDetailsViewController alloc] init];
    
    [vc setDeleteCommentBlock:^{
        [_comments removeAllObjects];
        [_hotComments removeAllObjects];
        [self loadArticleCommentList];
    }];
    [vc setSendSuccessCommentBlock:^{
        _commenting = YES;
        [self loadArticleCommentList];
    }];
    
    
    vc.model = cell.model;
    vc.commentId = vc.model.id;
    vc.mid = self.model.essenceId;
    vc.type = CommentDetailTypeEssence;
    vc.isShowKeyBord = NO;
    [self.navigationController pushViewController:vc animated:YES];;
}


- (void)wqPraiseBtnClick:(WQDynamicDetailsCommentTableViewCell *)cell {
    // 游客登录
    if (![EMClient sharedClient].isLoggedIn) {
        [self showLogin];
        return;
    }
    
    // 评论赞的响应事件
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *urlString = @"api/choicest/articlecommentlike";
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
            //            [_mainTable reloadData];
            [_mainTable beginUpdates];
            cell.model = cell.model;
            [_mainTable endUpdates];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}


@end
