//
//  WQCommentDetailController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCommentDetailController.h"
#import "WQCommentDetailInfoCell.h"
#import "WQCommentReplyCell.h"
//#import "WQTopicDetailCommentView.h"
#import "YYKeyboardManager.h"
#import "WQTopicDetailController.h"
#import "WQTextInputViewWithOutImage.h"
#import "WQCommentAndReplyModel.h"

@interface WQCommentDetailController ()<UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,WQTextInputViewWithOutImageDelegate,WQCommentDetailInfoCellShowDetailDelagete>
@property (nonatomic, retain) UITableView * mainTable;
@property (nonatomic, retain) NSMutableArray * commentsDataSource;
@property (nonatomic, retain) WQTextInputViewWithOutImage * bottom;

@property (nonatomic, retain) NSString * repling_cid;
//@property (nonatomic, retain) WQCommentAndReplyModel * model;

/**
 cell 的 index
 */
@property (nonatomic, strong) NSIndexPath *index;

/**
 评论上传成功后需要看到自己的评论要滚动到最下面
 */
@property (nonatomic, assign) BOOL isRepling;

@end

@implementation WQCommentDetailController

#pragma mark - lifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.navigationItem.title = @"回复";
    self.view.backgroundColor = WQ_BG_LIGHT_GRAY;
    _commentsDataSource = _secondnaryComments;

   
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
//    if (self.pid) {
        [self fetchCommentDetail];
    if (!self.isNeedsVC) {
        [self fetchCommentInfo];
        self.model = [[WQCommentAndReplyModel alloc] init];
    }
    
//    }
//    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
//    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 监听通知
- (void)keyboardWasShown:(NSNotification*)noti; {
    __weak typeof(self) weakSelf = self;
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.bottom mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(weakSelf.view.mas_bottom ).offset(-rect.size.height - TAB_HEIGHT + 50);
        }];
    }];
}
//
- (void)keyBoardWillHidden:(NSNotification *)noti {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.bottom mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-TAB_HEIGHT + 50);
        }];
    }];
}

#pragma mark - UI
- (void)setupUI {
    _mainTable = [[UITableView alloc] init];
    [self.view addSubview:_mainTable];
    [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAV_HEIGHT));
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset((-TAB_HEIGHT));
    }];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQCommentDetailInfoCell" bundle:nil]
     forCellReuseIdentifier:@"WQCommentDetailInfoCell"];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQCommentReplyCell" bundle:nil]
     forCellReuseIdentifier:@"WQCommentReplyCell"];
    
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.estimatedRowHeight = 100;
//    _mainTable.rowHeight = UITableViewAutomaticDimension;
    _mainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    _bottom = [[NSBundle mainBundle] loadNibNamed:@"WQTextInputViewWithOutImage"
                                                                      owner:nil
                                                                    options:nil].lastObject;
    
    [self.view addSubview:_bottom];
    
    [_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TAB_HEIGHT + 50);
        make.height.greaterThanOrEqualTo(@50);
    }];
    
    _mainTable.tableFooterView = [UIView new];
    _mainTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _bottom.inputtextView.delegate = self;
    _bottom.delegate = self;
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.commenting) {
        [_bottom.inputtextView becomeFirstResponder];
        self.commenting = NO;
    }

}



#pragma mark - http
- (void)fetchCommentDetail {
    NSString * strURL;
    
    if (self.isNeedsVC) {
        strURL = @"api/group/groupneedpostcommentlist";
    }else {
        strURL = @"api/group/grouptopicpostcommentlist";
    }
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
//    secretkey true string
//    pid true string 一级评论的ID
//    start false string 0
//    limit false string 20
    
    NSDictionary * param = @{@"secretkey":secreteKey,
                             @"pid":self.model.id?:self.pid,
                             @"limit":@"1000",
                             @"start":@"0" };
    
    __weak typeof(self) weakself = self;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }

        weakself.bottom.inputtextView.text = nil;
        NSArray * comments = response[@"comments"];
        
        _commentsDataSource  = [NSArray yy_modelArrayWithClass:[WQGroupReplyModel class] json:comments].mutableCopy;
        [_mainTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
        
        if (self.isRepling) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self scrollsToBottomAnimated:YES];
            });
            self.isRepling = NO;
        }
        
    }];

}


- (void)fetchCommentInfo {
    NSString * strURL = @"api/group/getgrouptopicpostinfo";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    
    param[@"pid"] = self.pid;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            return ;
        }
        if (![response[@"success"] boolValue]) {
            return;
        }
        
        self.model = [WQCommentAndReplyModel yy_modelWithJSON:response];
        [self.mainTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }];

}


- (void)scrollsToBottomAnimated:(BOOL)animated {
    CGFloat offset = _mainTable.contentSize.height - _mainTable.bounds.size.height;
    
    if (offset > 0) {
        
        [_mainTable setContentOffset:CGPointMake(0, offset) animated:animated];
    }
}




- (void)uploadComment:(UIButton *)sendBtn {
    self.isRepling = YES;
    [SVProgressHUD showWithStatus:@"评论上传中..."];;
    
    NSString * strURL;
    
    if (self.isNeedsVC) {
        strURL = @"api/group/creategroupneedpostcomment";
    }else {
        strURL = @"api/group/creategrouptopicpostcomment";
    }
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    
//    secretkey true string
//    pid true string 一级回复的ID
//    content true string 回复正文
//    reply_cid false string 如果此二级回复给特定的其他二级回复，此参数为被回复二级回复的ID
    param[@"pid"] = self.pid;
    param[@"content"] = _bottom.inputtextView.text;
    
    if (_repling_cid) {
        
        param[@"reply_cid"] = _repling_cid;
    }
    sendBtn.enabled = NO;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD showWithStatus:@"上传不成功，请重试"];
            [SVProgressHUD dismissWithDelay:1.2];
            sendBtn.enabled = YES;
            return ;
        }
        
        if (![response[@"success"] boolValue]) {
            [SVProgressHUD showWithStatus:@"上传不成功，请重试"];
            [SVProgressHUD dismissWithDelay:1.2];
            sendBtn.enabled = YES;
        }
        _repling_cid = nil;
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
        
        [_bottom.inputtextView setValue:attM forKey:@"attributedPlaceholder"];
        [SVProgressHUD showSuccessWithStatus:@"评论上传成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:WQCommentSuccess object:self];
        [SVProgressHUD dismissWithDelay:1.2];
        sendBtn.enabled = YES;
        [self fetchCommentDetail];
    }];

}



#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if(section == 1) {
        
//        return 3;
       return _commentsDataSource.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WQCommentDetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQCommentDetailInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        cell.delegate = self;
        
        UILongPressGestureRecognizer * longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    } else {
        WQCommentReplyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQCommentReplyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WQGroupReplyModel * replyModel = _commentsDataSource[indexPath.row];
        cell.model = replyModel;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        cell.select = ^(WQCommentReplyCell *cell) {
            [self tableView:_mainTable didSelectRowAtIndexPath:indexPath];
        };
        
        cell.deleteReply = ^(WQGroupReplyModel *model) {
            NSString * strURL = @"api/group/deletegrouptopicpostcomment";
            
            NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
            if (!secreteKey.length) {
                return;
            }
            NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
            param[@"cid"] = model.id;
            [SVProgressHUD showWithStatus:@"正在删除该回复.."];
            WQNetworkTools *tools = [WQNetworkTools sharedTools];
            [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
                if (error) {
                    [SVProgressHUD showWithStatus:@"网络连接出错..."];
                    [SVProgressHUD dismissWithDelay:1.3];
                    return ;
                }
                [SVProgressHUD dismiss];
                if ([response[@"success"] boolValue]) {
                    [WQAlert showAlertWithTitle:nil message:@"删除成功" duration:1.3];
                    [self fetchCommentDetail];
                } else {
                    [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.3];
                }
            }];

        } ;
        
        UILongPressGestureRecognizer *longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    }
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pointr = [recognizer locationInView:self.mainTable];
        NSIndexPath *indexPath = [self.mainTable indexPathForRowAtPoint:pointr];
        self.index = indexPath;
        if (indexPath.section == 0) {
            WQCommentDetailInfoCell *cell = [self.mainTable cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            CGPoint point = [recognizer locationInView:cell];
            CGRect r = CGRectMake(point.x, point.y, 0, 0);
            UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
            UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
            UIMenuController *menu = [UIMenuController sharedMenuController];
            if ([cell.model.user_id isEqualToString:im_namelogin] || [WQDataSource sharedTool].isAdmin) {
                [menu setMenuItems:[NSArray arrayWithObjects:itCopy, itDelete,  nil]];
            }else {
                [menu setMenuItems:[NSArray arrayWithObjects:itCopy, nil]];
            }
            [menu setTargetRect:r inView:cell];
            [menu setMenuVisible:YES animated:YES];
        }else {
            WQCommentReplyCell *cell = [self.mainTable cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            CGPoint point = [recognizer locationInView:cell];
            CGRect r = CGRectMake(point.x, point.y, 0, 0);
            UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
            UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
            UIMenuController *menu = [UIMenuController sharedMenuController];
            if ([cell.model.user_id isEqualToString:im_namelogin] || [WQDataSource sharedTool].isAdmin) {
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
        WQCommentDetailInfoCell *cell = [self.mainTable cellForRowAtIndexPath:self.index];
        pasteboard.string = cell.commentLabel.text;
    }else {
        WQCommentReplyCell *cell = [self.mainTable cellForRowAtIndexPath:self.index];
        pasteboard.string = cell.commentTextVIew.text;
    }
}

// 删除
- (void)handleDeleteCell:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.index.section == 0) {
        NSString *urlString = @"api/group/deletegrouptopicpost";
        if (self.isNeedsVC) {
            urlString = @"api/group/deletegroupneedpost";
        }
        params[@"pid"] = self.pid;
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
        NSString *urlString = @"api/group/deletegrouptopicpostcomment";
        if (self.isNeedsVC) {
            urlString = @"api/group/deletegroupneedpostcomment";
        }
        WQCommentReplyCell *cell = [self.mainTable cellForRowAtIndexPath:self.index];
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
                [self fetchCommentDetail];
                if (self.deleteCommentBlock) {
                    self.deleteCommentBlock();
                }
            }else {
                [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        WQGroupReplyModel * model = _commentsDataSource[indexPath.row];
        _repling_cid = model.id;
        [_bottom.inputtextView becomeFirstResponder];
//        UILabel * label = [[UILabel alloc] init];
//
//        label.frame = CGRectMake(0, 0, 20, 12);
//
//
//
//        label.text = [NSString stringWithFormat:@"@%@",model.user_name];
//        label.font = _bottom.inputtextView.font;
//        [label sizeToFit];
//        _bottom.inputtextView.leftView = label;
//
//        _bottom.commentField.leftViewMode = UITextFieldViewModeAlways;
        
        
        NSDictionary *titleDict = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                    NSForegroundColorAttributeName : [UIColor colorWithHex:0x878787]};
        NSMutableAttributedString * placeHolder =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复:%@", model.user_name]
                                               attributes:titleDict];
        
        [_bottom.inputtextView setValue:placeHolder forKey:@"attributedPlaceholder"];
        
        
        
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        
        WQCommentDetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQCommentDetailInfoCell"];
        cell.model = self.model;
        
        
//        CGRect rect = [self.model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 60 - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
//
//
//        CGSize size = [cell.commentLabel sizeThatFits:CGSizeMake(kScreenWidth - 60 - 10, MAXFLOAT)];
//
//        if (size.height > cell.commentLabel.height) {
//            return rect.size.height - cell.commentLabel.height + 160 + cell.imageHeight ;
//        } else {
//            return 160 + cell.imageHeight;
//        }
    
        return UITableViewAutomaticDimension;
        
    } else if (indexPath.section == 1) {
        
        WQCommentReplyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQCommentReplyCell"];
        cell.model = _commentsDataSource[indexPath.row];
        cell.deleteReply = ^(WQGroupReplyModel * model) {
            NSString * strURL = @"api/group/deletegroupneedpostcomment";
            
            NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
            if (!secreteKey.length) {
                return;
            }
            NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
            
            [SVProgressHUD showWithStatus:@"正在删除..."];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            WQNetworkTools *tools = [WQNetworkTools sharedTools];
            [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
                if (error) {
                    [SVProgressHUD setStatus:@"删除失败请重试"];
                    [SVProgressHUD dismissWithDelay:1.3];
                    return ;
                }
                [SVProgressHUD dismiss];
                
                if (!response[@"success"]) {
                    [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.3];
                } else {
                    [WQAlert showAlertWithTitle:nil message:@"删除成功" duration:1.3];
                    [self fetchCommentDetail];
                }
                
            }];

        };
        return 45 + cell.commentTextVIew.height;

    } else {
        return 0;
    }
    
}


//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    NSString *role_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"role_id"];
//    if ([role_id isEqualToString:@"200"]) {
//        [self showLogin];
//        return NO;
//    }
//    return YES;
//}




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
        _bottom.sendButton.enabled = NO;
    } else {
        _bottom.sendButton.enabled = YES;
    }
    
    return YES;
}



//#pragma mark - textfield
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//    if ([textField.text isVisibleString]) {
//        [self uploadComment];
//    }
//    _repling_cid = nil;
//    [self.view endEditing:YES];
//    return YES;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
//    textField.leftView = [UIView new];
//}

#pragma mark - WQTextInputViewWithOutImageDelegate
- (void)WQTextInputViewWithOutImage:(WQTextInputViewWithOutImage *)view sendComment:(UIButton *)sendButton {
    if ([_bottom.inputtextView.text isVisibleString]) {
        [self uploadComment:sendButton];
    }
    [self.view endEditing:YES];
}



#pragma - WQCommentDetailInfoCellShowDetailDelagete

- (void)WQCommentDetailInfoCellShowDetail:(WQCommentAndReplyModel *)model {
    if (model.tid) {
        WQTopicDetailController * vc = [[WQTopicDetailController alloc] init];
        vc.tid = model.tid;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}






- (void)WQCommentDetailInfoCellDeleteComment:(WQCommentAndReplyModel *)model {
//    TODOHanyang
    
    NSString * strURL = @"api/group/deletegrouptopicpost";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"pid"] = self.model.id?:self.pid;
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        
        if (error) {
            return ;
        }
        if (![response[@"success"] boolValue]) {
            [WQAlert showAlertWithTitle:nil message:response[@"message"] duration:1.3];
            return;
        }
        
        [WQAlert showAlertWithTitle:nil message:@"评论删除成功!" duration:1.3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];

}



- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
