//
//  WQTopicDetailController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicDetailController.h"
//#import "WQTopicDetailCommentView.h"
#import "YYKeyboardManager.h"
#import "WQTopicDtailUserInfoCell.h"
#import "WQTopicImagesCell.h"
#import "WQTopicCommentCell.h"

#import "WQTopicTypeMessageHeader.h"
#import "WQImageInfoModel.h"
#import "WQCommentDetailController.h"
#import "WQCommentTextView.h"
#import "WQTopicComplaintCell.h"
#import "WQfeedbackViewController.h"
#import "WQPhotoBrowser.h"
#import "WQTopicDetailFooter.h"
#import "WQTopicLinkCell.h"
//#import "WQTopicCommentWithImageView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "WQTopicArticleController.h"

#import "WQTopicLinkModel.h"

#import "WQGroupDynamicViewController.h"
#import "WQTopicStickOrDeleteController.h"

#import "WQActionSheet.h"

//底下的评论视图
#import "WQTextInputView.h"

@interface WQTopicDetailController ()<UITableViewDelegate,UITableViewDataSource,YYKeyboardObserver,UITextViewDelegate,WQTopicCommentCellDelegate,MWPhotoBrowserDelegate,TZImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate,WQTopicStickOrDeleteControllerDelegate,WQTextInputViewDelegate,WQActionSheetDelegate>

@property (nonatomic, retain) UITableView * mainTable;

@property (nonatomic, retain) WQTextInputView * commentView;
@property (nonatomic, retain) WQTopicStickOrDeleteController * popOverVC;

/**
 cell 的 index
 */
@property (nonatomic, strong) NSIndexPath *index;

/**
 是否有需要上传的图片
 */
@property (nonatomic, assign) BOOL havePic;
/**
 评论的图片的 Id
 */
@property (nonatomic, copy) NSString * uploadImageId;

/**
 当从评论详情页返回时可能有新的品论需要刷新
 */
@property (nonatomic, assign) BOOL shouldRefreshComments;

/**
 页数
 */
@property (nonatomic, assign) NSInteger start;

/**
 每页条数
 */
@property (nonatomic, assign) NSInteger limit;
/**
 评论的数组
 */
@property (nonatomic, retain) NSMutableArray * commentArray;

/**
 图片的数字组
 */
@property (nonatomic, retain) NSMutableArray<WQImageInfoModel *> * imageInfoArray;

/**
 用来存储 topic 的信息一般只有一个模型封装成数组为了规范代码
 */
@property (nonatomic, retain) NSMutableArray<WQTopicModel *> * topicModelArray;

/**
 链接文章的数组
 */
@property (nonatomic, retain) NSMutableArray * linkArray;

/**
 仅用于代理方法取值,网络请求时请直接操作其中的元素
 */
@property (nonatomic, retain) NSMutableArray * dataSource;

@property (nonatomic, assign) BOOL isOwner;

/**
 是否展示评论最底部
 */
@property (nonatomic, assign) BOOL shouldShowBottom;

/**
 右上角的按钮
 */
@property (nonatomic, retain) UIBarButtonItem * rightItem;

@property (nonatomic, retain, nullable) WQTopicModel *  model;


@end

@implementation WQTopicDetailController {
    WQLoadingView *loadingView;
    WQLoadingError *loadingError;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // [[YYKeyboardManager defaultManager] addObserver:self];
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _commentArray = @[].mutableCopy;
    _imageInfoArray = @[].mutableCopy;
    _linkArray = @[].mutableCopy;
    _topicModelArray = @[].mutableCopy;
    _dataSource = @[_topicModelArray,_imageInfoArray,_linkArray,_topicModelArray].mutableCopy;
    
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:nil];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;
    [self setupUI];
    [self fetchTopicInfo];
    //    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    if(@available(iOS 11.0, *)) {
        _mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mainTable.estimatedSectionFooterHeight = 0;
        _mainTable.estimatedSectionHeaderHeight = 0;
//        _mainTable.estimatedRowHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"主题";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    
    //    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    
    
    
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"•••" style:UIBarButtonItemStyleDone target:self action:@selector(stickOrDeleteTopic)];
    
    [_rightItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName :
                                             [UIColor blackColor]
                                         }
                              forState:UIControlStateNormal];
    
    
    if (self.shouldRefreshComments) {
        [self refreshComments];
    }
    
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

- (void)dealloc {
    // [[YYKeyboardManager defaultManager] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - http

/**
 获取话题详情
 */
- (void)fetchTopicInfo {
    
    NSString * strURL = @"api/group/getgrouptopicinfo";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSDictionary * param = @{@"secretkey":secreteKey,
                             @"tid":self.tid ? self.tid : self.model.tid};
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [loadingView dismiss];
            [loadingError show];
//            [SVProgressHUD showWithStatus:error.localizedDescription];
//            [SVProgressHUD dismissWithDelay:1.3];
            return ;
        }
        
        if (![response[@"success"] boolValue]) {
            [SVProgressHUD showWithStatus:response[@"message"]];
            [SVProgressHUD dismissWithDelay:1.3];
            return;
        }
        
        
        _model = [WQTopicModel yy_modelWithJSON:response];
        [WQDataSource sharedTool].isAdmin = _model.isAdmin;

        if (_model) {
            [_topicModelArray removeAllObjects];
            [_topicModelArray addObject:_model];
        }
        [_imageInfoArray removeAllObjects];
        for (NSDictionary * imageInfo in response[@"pic_with_width_height"]) {
            WQImageInfoModel * model = [[WQImageInfoModel alloc] init];
            model.imageFactor =  [imageInfo[@"height"] doubleValue] /[imageInfo[@"width"] doubleValue];
            model.imageId = imageInfo[@"id"];
            [_imageInfoArray addObject:model];
        }
        if ([response[@"link_url"] length]) {
            WQTopicLinkModel * model = [WQTopicLinkModel yy_modelWithJSON:response];
            _linkArray = @[model].mutableCopy;
        }
        if (self.detailType == TopicDetailTypeFromMessage) {
            WQTopicTypeMessageHeader * header = [[NSBundle mainBundle] loadNibNamed:@"WQTopicTypeMessageHeader" owner:nil options:nil].firstObject;
            header.frame = CGRectMake(0, 0, kScreenWidth, 40);
            header.groupNamelabel.text = response[@"gname"];
            _mainTable.tableHeaderView = header;
            header.ontap = ^{
                WQGroupDynamicViewController * vc = [[WQGroupDynamicViewController alloc] init];
                vc.gid = response[@"gid"];
                [self.navigationController pushViewController:vc animated:YES];
            };
        }
        
        
        _isOwner = _model.isOwner;
        if (_model.isAdmin) {
            self.navigationItem.rightBarButtonItem = _rightItem;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        [_mainTable reloadData];
        [self fetchComments];
        
    }];
    
}

/**
 获取话题评论
 */
- (void)fetchComments {
    //    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD show];

    NSString * strURL = @"api/group/grouptopicpostlist";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"tid"] = self.tid;
    param[@"start"] = @(self.start).description;
    //    param[@"limit"] = @(self.limit).description;
    //    param[@"content"] = _commentView.commentField.text;
    //    secretkey true string
    //    tid true string 主题ID
    //    start false string 0 分页参数
    //    limit false string 20 分页参数
    __weak typeof(self) weakself = self;
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        [_mainTable.mj_header endRefreshing];
        [_mainTable.mj_footer endRefreshing];
        
        if (error) {
//            [SVProgressHUD showWithStatus:error.localizedDescription];
//            [SVProgressHUD dismissWithDelay:1];
            [loadingView dismiss];
            return ;
        }
        
        if ([response[@"success"] boolValue]) {
            [SVProgressHUD showWithStatus:response[@"message"]];
            [SVProgressHUD dismissWithDelay:1];
        }
        [SVProgressHUD dismissWithDelay:0];
        
        if (!_start) {
            [weakself.commentArray removeAllObjects];
        }
        NSArray * new = [NSArray yy_modelArrayWithClass:[WQCommentAndReplyModel class] json:response[@"posts"]];
        if (new.count < 20) {
            [weakself.mainTable.mj_footer endRefreshingWithNoMoreData];
        } else {
            _start += 20;
        }
        [weakself.commentArray  addObjectsFromArray: new];
        
        
        
        [_mainTable reloadData];
        [loadingView dismiss];
        [loadingError dismiss];
        if (!weakself.commentArray.count) {
            
            
            
            
            WQTopicDetailFooter * footer = [[NSBundle mainBundle] loadNibNamed:@"WQTopicDetailFooter" owner:self options:nil].lastObject;
            
            
            footer.frame = CGRectMake(0, 0, kScreenWidth, 123);
            _mainTable.tableFooterView = footer;
            
            MJRefreshAutoGifFooter * refreshFooter = (MJRefreshAutoGifFooter * )_mainTable.mj_footer;
            [refreshFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
            [refreshFooter setBackgroundColor:HEX(0xf3f3f3)];
            
        } else {
            
            _mainTable.tableFooterView = [UIView new];
            MJRefreshAutoGifFooter * refreshFooter = (MJRefreshAutoGifFooter * )_mainTable.mj_footer;
            if (weakself.commentArray.count >= 20) {
                
                [refreshFooter setTitle:@"暂无更多数据"
                               forState:MJRefreshStateNoMoreData];
            } else {
                
                [refreshFooter setTitle:@" "
                               forState:MJRefreshStateNoMoreData];
            }
            
            
            refreshFooter.stateLabel.textColor = HEX(0x999999);
            refreshFooter.stateLabel.textAlignment = NSTextAlignmentCenter;
            // 设置字体
            refreshFooter.stateLabel.font = [UIFont systemFontOfSize:16];
            
            [refreshFooter setBackgroundColor:HEX(0xf3f3f3)];
        }
        if (self.shouldShowBottom) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakself.commentArray.count - 1 inSection:4] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                self.shouldShowBottom = NO;
            });
            
        }
        
        
    }];
}


/**
 上传评论图片
 */
- (void)uploadImage {
    
    NSString *urlString = @"file/upload";
    
    [SVProgressHUD showWithStatus:@"正在上传图片"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData * data = UIImageJPEGRepresentation(_commentView.addPicImageView.image, 0.7f);
        [formData appendPartWithFileData:data name:@"file" fileName:@"wanquantupian" mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        }
        NSLog(@"success : %@", responseObject);
        
        BOOL successbool = [responseObject[@"success"] boolValue];
        if (successbool) {
            self.uploadImageId = responseObject[@"fileID"];
            
            [self uploadComment];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        [SVProgressHUD dismiss];
        
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"上传图片失败,请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }];
}


/**
 上传评论
 */
- (void)uploadComment {
    //    secretkey true string
    //    tid true string 主题的ID
    //    content true string 回复的内容
    self.shouldShowBottom = YES;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"评论上传中…"];
    NSString * strURL = @"api/group/creategrouptopicpost";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"tid"] = self.tid;
    
    if (![_commentView.inputtextView.text isVisibleString] && !self.uploadImageId) {
        [WQAlert showAlertWithTitle:nil message:@"请填写评论内容" duration: 1.3];
        
    }
    
    if ([_commentView.inputtextView.text isVisibleString]) {
        param[@"content"] = _commentView.inputtextView.text;
    } else {
        param[@"content"] = @"图片评论";
    }
    
    if (self.uploadImageId) {
        param[@"pic"] = @[self.uploadImageId].yy_modelToJSONString;
    }
    //    todoHanyang 判断图片并上传
    
    __weak typeof(self) weakself = self;
    
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD showWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        
        if ([response[@"success"] boolValue]) {
            [SVProgressHUD showWithStatus:response[@"message"]];
            [SVProgressHUD dismissWithDelay:1];
        }
        [SVProgressHUD showWithStatus:@"发表成功"];
        [SVProgressHUD dismissWithDelay:1];
        [weakself refreshComments];
        weakself.uploadImageId = nil;
        weakself.commentView.inputtextView.text = nil;
        weakself.commentView.inputHeight.constant = 30;
        [weakself.commentView.delegate WQTextInputView:weakself.commentView
                              deleteImageButtonOnclick:weakself.commentView.deleteImageButton];
        [weakself.view endEditing:YES];
//        weakself.commentView.removeImage(weakself.commentView.removePicButton);
    }];
}


#pragma mark - UI
- (void)setupUI {
    _mainTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTable];
    _mainTable.showsVerticalScrollIndicator = NO;
    [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
        make.top.equalTo(@(NAV_HEIGHT));
    }];
    _mainTable.estimatedSectionHeaderHeight = 0;
    _mainTable.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        _mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQTopicDtailUserInfoCell" bundle:nil] forCellReuseIdentifier:@"WQTopicDtailUserInfoCell"];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQTopicImagesCell" bundle:nil] forCellReuseIdentifier:@"WQTopicImagesCell"];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQTopicCommentCell" bundle:nil] forCellReuseIdentifier:@"WQTopicCommentCell"];
    
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQTopicComplaintCell" bundle:nil] forCellReuseIdentifier:@"WQTopicComplaintCell"];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQTopicLinkCell" bundle:nil] forCellReuseIdentifier:@"WQTopicLinkCell"];
    
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    
    _mainTable.estimatedRowHeight = 100;
    _mainTable.backgroundColor = HEX(0xf3f3f3);
    UIView * footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, kScreenWidth, 15);
    UILabel * label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHex:0x666666];
    label.font = [UIFont systemFontOfSize:14];
    
    [label sizeToFit];
    [footer addSubview:label];
    label.center = footer.center;
    
    _mainTable.tableFooterView = footer;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _commentView =  [[NSBundle mainBundle] loadNibNamed:@"WQTextInputView" owner:self options:nil].lastObject;
    [self.view addSubview:_commentView];
    _commentView.delegate = self; 
    _commentView.inputtextView.delegate = self;
//    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.equalTo(@50);
//    }];
    _commentView.frame = CGRectMake(0, kScreenHeight - TAB_HEIGHT + 49 - 50, kScreenWidth, 50);
    
    loadingView = [[WQLoadingView alloc] init];
    [loadingView show];
    [self.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    _mainTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //    _mainTable.backgroundColor = [UIColor whiteColor];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshComments)];
    [header setTitle:@" " forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.hidden = YES;
    
//    NSArray *imageArray = [NSArray arrayWithObjects:
//                           [UIImage imageNamed:@"tableview_pull_refresh"],
//                           [UIImage imageNamed:@"tableview_pull_refresh"],
//                           nil];
    NSArray *pullingImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"上拉箭头"],
                              [UIImage imageNamed:@"上拉箭头"],
                              nil];
    
    //    [header setImages:imageArray forState:MJRefreshStateIdle];
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    
    [header placeSubviews];
    self.mainTable.mj_header = header;
    MJRefreshAutoNormalFooter *freshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    [freshFooter setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [freshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [freshFooter setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    freshFooter.stateLabel.textColor = HEX(0x999999);
    freshFooter.stateLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体
    freshFooter.stateLabel.font = [UIFont systemFontOfSize:16];
    _mainTable.mj_footer = freshFooter;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(loadingView) weakLoadingView = loadingView;
    loadingError = [[WQLoadingError alloc] init];
    [loadingError setClickRetryBtnClickBlock:^{
        [weakLoadingView show];
        [weakSelf fetchTopicInfo];
    }];
    [loadingError dismiss];
    [self.view addSubview:loadingError];
    [loadingError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return _topicModelArray.count;
    } else if(section == 1) {
        
        return _imageInfoArray.count;
    } else if(section == 2) {
        
        return _linkArray.count;
    } else if (section == 3) {
        
        return 1;
    } else if(section == 4) {
        
        return _commentArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return UITableViewAutomaticDimension;
    }
    
    if (indexPath.section == 1) {
        WQTopicImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WQTopicImagesCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = _imageInfoArray[indexPath.row];
        //        cell.model = nil;
        WQImageInfoModel * model = _imageInfoArray[indexPath.row];
        return (kScreenWidth - 30) * (model.imageFactor?:1) + 15;
    }
    
    if (indexPath.section == 2) {
        
        return 60;
    }
    if (indexPath.section == 3) {
        return 40;
    }
    
    if (indexPath.section == 4) {
        WQTopicCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQTopicCommentCell"];
        
        //        cell.addHeight = 0;
        
        cell.model = _commentArray[indexPath.row];
        //        cell.model = nil;
        return 93 + cell.addHeight;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //        主题详情
        
        WQTopicDtailUserInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQTopicDtailUserInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _topicModelArray[0];
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        //        图片
        WQTopicImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WQTopicImagesCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = _imageInfoArray[indexPath.row];
        __weak typeof(self) weakself = self;
        cell.ontap = ^{
            WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:weakself];
            browser .currentPhotoIndex = indexPath.row;
            browser.alwaysShowControls = NO;
            browser.displayActionButton = NO;
            browser.shouldTapBack = YES;
            browser.shouldHideNavBar = YES;
            [self.navigationController pushViewController:browser animated:YES];
        };
        
        //        cell.model = nil;
        return cell;
    }
    
    
    if (indexPath.section == 2) {
        //        链接
        WQTopicLinkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQTopicLinkCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = _linkArray[0];
        return cell;
    }
    
    
    if (indexPath.section ==3) {
        //        投诉
        
        WQTopicComplaintCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQTopicComplaintCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.complaintTopic = ^{
            WQfeedbackViewController * vc = [[WQfeedbackViewController alloc] init];
            vc.feedbackType = TYPE_GROUP_TOPIC;
            [self.navigationController pushViewController:vc animated:YES];
        };
        //        cell.deleteBtn.hidden = !self.isOwner;
//        已经将话题的删除按钮放到 navbar 上面暂时隐藏掉删除按钮
        cell.deleteTopic = ^{
            NSString * strURL = @"api/group/deletegrouptopic";
            
            NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
            if (!secreteKey.length) {
                return;
            }
            NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
            param[@"tid"] = self.tid;
            [SVProgressHUD showWithStatus:@"正在删除..."];
            WQNetworkTools *tools = [WQNetworkTools sharedTools];
            [tools request:WQHttpMethodPost
                 urlString:strURL
                parameters:param
                completion:^(id response, NSError *error) {
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
                        [SVProgressHUD dismissWithDelay:1.3];
                        return ;
                    }
                    
                    if (!response[@"success"]) {
                        [SVProgressHUD showErrorWithStatus:@"删除失败请重试"];
                        [SVProgressHUD dismissWithDelay:1.3];
                        return;
                    }
                    [SVProgressHUD showWithStatus:@"删除成功"];
                    [SVProgressHUD dismissWithDelay:1.3];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
        };
        
        return cell;
        
    }
    
    
    if (indexPath.section == 4) {
        //        评论
        WQTopicCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQTopicCommentCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = _commentArray[indexPath.row];
        //        cell.model = nil;
        
        
        UILongPressGestureRecognizer * longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    }
    
    
    return [UITableViewCell new];
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pointr = [recognizer locationInView:self.mainTable];
        NSIndexPath *indexPath = [self.mainTable indexPathForRowAtPoint:pointr];
        self.index = indexPath;
        WQTopicCommentCell *cell = [self.mainTable cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        CGPoint point = [recognizer locationInView:cell];
        CGRect r = CGRectMake(point.x, point.y, 0, 0);
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
        UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        if ([cell.model.user_id isEqualToString:im_namelogin] || _model.isAdmin || _model.isOwner) {
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
    WQTopicCommentCell *cell = [self.mainTable cellForRowAtIndexPath:self.index];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.commentLabel.text;
}

// 删除
- (void)handleDeleteCell:(id)sender {
    WQCommentAndReplyModel *model = _commentArray[self.index.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlString = @"api/group/deletegrouptopicpost";
    params[@"pid"] = model.id;
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
            [self fetchComments];
        }else {
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:response[@"message"] andAnimated:YES andTime:1.5];
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 4) {
        if (_commentArray.count) {
            return 10;
        }
    }
    
    
    return 0.25;
}




- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2 && !_linkArray.count) {
        
        return 1;
    }
    return 0.25;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    //    if (self.detailType == TopicDetailTypeFromMessage) {
    //
    //    }
    
    //    评论的头是灰色的
    if (section == 4) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        if (self.commentArray.count) {
            view.backgroundColor = HEX(0xf3f3f3);
        }
        return view;
    }
    
    
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}







- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 2) {
        //        TODOHanyang 进入外链
        WQTopicArticleController * vc = [[WQTopicArticleController alloc] init];
        vc.URLString = [_linkArray[0] link_url];
        vc.NavTitle = [_linkArray[0] link_txt];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 4) {
        
        WQCommentDetailController * vc = [[WQCommentDetailController alloc] init];
        vc.isNeedsVC = NO;
        WQCommentAndReplyModel * model = self.commentArray[indexPath.row];
        vc.pid = model.id;
        
        NSArray * second = model.comments;
        
        if (second.count) {
            vc.secondnaryComments = [NSArray yy_modelArrayWithClass:[WQGroupReplyModel class] json:second].mutableCopy;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        self.shouldRefreshComments = YES;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    for (UIView * view in cell.contentView.subviews) {
        if ([view isKindOfClass:[WQCommentTextView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (UIView * view in cell.contentView.subviews) {
        if ([view isKindOfClass:[YYLabel class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)WQTopicCommentCellDelegateshowMore:(WQCommentAndReplyModel *)model {
    WQCommentDetailController * vc = [[WQCommentDetailController alloc] init];
    
    
    vc.pid = model.id;
    NSArray * second = model.comments;
    
    if (second.count) {
        vc.secondnaryComments = [NSArray yy_modelArrayWithClass:[WQGroupReplyModel class] json:second].mutableCopy;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)WQTopicCommentCellD:(WQTopicCommentCell *)cell addCommentWithId:(NSString *)tid {
    WQCommentDetailController * vc = [[WQCommentDetailController alloc] init];
    vc.pid = cell.model.id;
    NSArray * second = cell.model.comments;
    
    if (second.count) {
        vc.secondnaryComments = [NSArray yy_modelArrayWithClass:[WQGroupReplyModel class] json:second].mutableCopy;
    }
    self.shouldRefreshComments = YES;
    vc.commenting = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - refresh & loadmore
- (void)refreshComments {
    _start = 0;
    [self fetchComments];
}

- (void)loadMoreComments {
    [self fetchComments];
    
}

#pragma mark - textViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
//    textView.inputDelegate
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString * str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ((str.isVisibleString) || _havePic) {
        
        _commentView.sendButton.enabled = YES;
    } else {
        
        _commentView.sendButton.enabled = NO;
    }
    return YES;
}



#pragma - rightbarbtn
- (void)stickOrDeleteTopic {

    if (self.navigationItem.rightBarButtonItem) {
        
        NSString *titleName = _model.isTop?@"取消置顶":@"置顶";
        WQActionSheet *actionSheet = [[WQActionSheet alloc]initWithTitles:@[titleName,@"删除"]];
        actionSheet.delegate = self;
        [actionSheet show];
    }
}

- (void)clickedButton:(WQActionSheet *)sheetView ClickedName:(NSString *)name
{
    if ([name isEqualToString:@"删除"]) {
        [self WQTopicStickOrDeleteControllerDelegateDeleteTopic];
    }else{
        [self WQTopicStickOrDeleteControllerDelegateStickTopic];
    }
    
}



#pragma mark - popoverPresentationController

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return YES;
}



#pragma mark - WQTopicStickOrDeleteControllerDelegateStickTopic

/**
 删除主题
 */
- (void)deleteTopic {
    NSString * strURL = @"api/group/deletegrouptopic";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"tid"] = self.tid;
    [SVProgressHUD showWithStatus:@"正在删除..."];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost
         urlString:strURL
        parameters:param
        completion:^(id response, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
                [SVProgressHUD dismissWithDelay:1.3];
                return ;
            }
            
            if (!response[@"success"]) {
                [SVProgressHUD showErrorWithStatus:@"删除失败请重试"];
                [SVProgressHUD dismissWithDelay:1.3];
                return;
            }
            if (self.deleteSuccessfulBlock) {
                self.deleteSuccessfulBlock();
            }
            [SVProgressHUD showWithStatus:@"删除成功"];
            [SVProgressHUD dismissWithDelay:1.3];
            
           
            [self.navigationController popViewControllerAnimated:YES];
        }];
}

/**
 删除主题
 */
- (void)WQTopicStickOrDeleteControllerDelegateDeleteTopic {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"确认删除此主题?\n删除后不可恢复。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteTopic];
    }];
    
    [alert addAction:cancle];
    [alert addAction:confirm];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}




/**
 置顶或取消置顶
 */
- (void)stickTopic {
    NSString * strURL = @"api/group/settopgrouptopic";
    
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"tid"] = self.tid;
    param[@"settop"] = _model.isTop ? @"false" : @"true";
    
    NSString * hudInfo = _model.isTop ? @"正在取消置顶..." : @"正在置顶...";
    
    [SVProgressHUD showWithStatus:hudInfo];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:strURL parameters:param completion:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD showWithStatus:@"网络请求出错..."];
            [SVProgressHUD dismissWithDelay:1.3];
            return ;
        }
        [SVProgressHUD dismiss];
        NSString * alertInfo;
        if (![response[@"success"] boolValue]) {
            
            alertInfo = _model.isTop ? @"取消置顶失败,请重试" : @"置顶失败,请重试";
            
        } else {
            if (self.topSuccessfulBlock) {
                self.topSuccessfulBlock();
            }
            alertInfo = _model.isTop ? @"取消置顶成功" : @"置顶成功";
            _model.isTop = !_model.isTop;
        }
            [WQAlert showAlertWithTitle:nil message:alertInfo duration:1.3];
        
    }];
}


/**
 置顶或取消置顶
 */
- (void)WQTopicStickOrDeleteControllerDelegateStickTopic {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:_model.isTop ? @"确定将此主题取消置顶?" : @"确认将此主题置顶?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:_model.isTop ? @"取消置顶" : @"确认置顶"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         
                                                         [self stickTopic];

        
    }];
    
    [alert addAction:cancle];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWasShown:(NSNotification*)noti {
    __weak typeof(self) weakSelf = self;
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.view);
//            make.height.offset(50);
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-rect.size.height);
        }];
    }];
}

- (void)keyBoardWillHidden:(NSNotification *)noti {
    __weak typeof(self) weakSelf = self;
    [_commentView.inputtextView resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
//            make.height.offset(50);
        }];
    }];
}


#pragma mark - 评论视图的代理方法 textInputViewDelegate

- (void)WQTextInputView:(WQTextInputView *)textInputView deleteImageButtonOnclick:(UIButton *)deleteImageButton {
    textInputView.addPicImageView.contentMode = UIViewContentModeCenter;
    [textInputView.addPicImageView setImage:[UIImage imageNamed:@"comment_tianjiatupian"]];
    deleteImageButton.hidden = YES;
    
    if (![textInputView.inputtextView.text isVisibleString]) {
        textInputView.sendButton.enabled = NO;
    } else {
        textInputView.sendButton.enabled = YES;
    }
    _havePic = NO;
    self.uploadImageId = nil;
}

- (void)WQTextInputView:(WQTextInputView *)textInputView sendButtonClicked:(UIButton *)sendButton {
    // MARK: 有图片上传图片 没有图片上传文字评论
        if (self.havePic) {
    
            [self uploadImage];
        }else if ([textInputView.inputtextView.text isVisibleString]) {
    
            [self uploadComment];
        }
    
        [self.view endEditing:YES];
}

- (void)WQTextInputView:(WQTextInputView *)textInputView addImageViewOnTap:(UIImageView *)addImageView {
    TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    //        picker.naviTitleColor = [UIColor blackColor];
    //        picker.barItemTextColor = [UIColor whiteColor];
    //        picker.naviBgColor = [UIColor blackColor];
    
    
    picker.navigationBar.tintColor = [UIColor whiteColor];
    [picker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    picker.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    picker.isStatusBarDefault = YES;
    picker.allowPickingGif = NO;
    picker.allowPickingVideo = NO;
    
    picker.navigationBar.tintColor = [UIColor whiteColor];
    [picker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    picker.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self presentViewController:picker animated:YES completion:^{
        [self.commentView.inputtextView becomeFirstResponder];
    }];
    //
    
    picker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        addImageView.image = photos[0];
        addImageView.contentMode = UIViewContentModeScaleToFill;
        _havePic = YES;
        textInputView.deleteImageButton.hidden = NO;
        textInputView.sendButton.enabled = YES;
    };
}


#pragma mark - photoBrowser

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imageInfoArray.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSURL * url = [NSURL URLWithString:[imageUrlString stringByAppendingString:[_imageInfoArray[index] imageId]]];
    MWPhoto * photo = [MWPhoto photoWithURL:url];
    
    return photo;
}

@end
