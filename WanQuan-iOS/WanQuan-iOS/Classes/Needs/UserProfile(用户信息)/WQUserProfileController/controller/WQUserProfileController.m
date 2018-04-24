//
//  WQUserProfileController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileController.h"
/**
 导入用到的所有的 View
 */
#import "UserProfileViews.h"
/**
 导入用到的所有的 Controller
 */
#import "UserPrifileControllers.h"
/**
 导入用到的所有的 Model
 */
#import "UserProfileModels.h"



#import <NSAttributedString+YYText.h>
#import "WQTwoWorkUserProfileModel.h"
#import "WQTwoUserProfileModel.h"
#import "WQGroupDynamicViewController.h"

/**
 使用枚举来代替数字加强代码的可读性以及可扩展性
 */
typedef NS_ENUM(NSUInteger, ProfileSectionName) {
    /**
     基本信息
     */
    ProfileSectionNameUserBaseInfo = 0,
    /**
     如果是来自添加好友页面则看到好友请求的信息
     */
    ProfileSectionNameFriendRequestInfo,
    /**
     工作经历
     */
    ProfileSectionNameWorkExperienceInfo,
    /**
     学习经历
     */
    ProfileSectionNameEducationExperienceInfo,
    /**
     发的需求
     */
    ProfileSectionNameNeedsInfo,
    /**
     个人动态
     */
    ProfileSectionNameInvidualTrendsInfo,
    /**
     加入的圈子
     */
    ProfileSectionNameJionedGroupsInfo
};

typedef NS_ENUM(NSUInteger, UploadImageType) {
    UploadImageTypeHeadImage,
    UploadImageTypeProfileBackGround,
};


@interface WQUserProfileController ()<UITableViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,WQBottomPopupWindowViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, retain) WQUserProfileModel *userModel;


@property (nonatomic ,retain) WQUserInfoModel * userInfoModel;

// MARK: 以下数组作为实际的所有经历的数据源
@property (nonatomic, retain) NSArray * allEducationExperience;
@property (nonatomic, retain) NSArray * allWorkExperience;
@property (nonatomic, retain) NSArray * allNeeds;
@property (nonatomic, retain) NSArray * allInvidualTrends;
@property (nonatomic, retain) NSArray * allJoinedGroups;

// MARK: 以下数组作为真正展示的数据源
@property (nonatomic, retain) NSArray * showEducationExperience;
@property (nonatomic, retain) NSArray * showWorkExperience;
@property (nonatomic, retain) NSArray * showNeeds;
@property (nonatomic, retain) NSArray * showInvidualTrends;
@property (nonatomic, retain) NSArray * showJoinedGroups;


@property (nonatomic, retain) UITableView * mainTable;
@property (nonatomic, retain) WQBottomPopupWindowView * popWindow;
@property (nonatomic, strong) WQGroupDynamicNavView *navView;

@property (nonatomic, retain) UIImage * toReplaceImage;


@property (nonatomic, retain) UIImageView * Showbackground;
@property (nonatomic, retain) UIImageView * BackgroundMask;


/**
 *  放大比例
 */
@property (nonatomic,assign)CGFloat scale;




/////**
//// 当该页面
//// */
////@property (nonatomic, assign) NSInteger totleSectionCount;
//
//@property (nonatomic, assign) BOOL groups_show_all;

@end

@implementation WQUserProfileController {
    WQLoadingView *loadingView;
}

- (instancetype)initWithUserId:(NSString *)UserId {
    WQUserProfileController * i = [[WQUserProfileController alloc] init];
    i.userId = UserId;
    return i;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:self.Showbackground];
    [self.Showbackground addSubview:self.BackgroundMask];
    
    self.navigationItem.title = @"个人主页";

    
    
    [self setupUI];
    
    //    if (self.isFromFriendRequest) {
    //        self.totleSectionCount = 4;
    //    } else {
    //        self.totleSectionCount = 3;
    //    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainSwitchChanged:) name:WQUserProfileMainSwitchStateDidChangeNoti object:nil];
    [self setupNavView];
    
}

- (UIImageView *)BackgroundMask
{
    if (!_BackgroundMask) {
        _BackgroundMask = [[UIImageView alloc]init];
        _BackgroundMask.image = [UIImage imageNamed:@"personBackGrund"];
        _BackgroundMask.frame = CGRectMake(0, 0, kScreenWidth, kScaleX(184));
    }
    return _BackgroundMask;
}

- (UIImageView *)Showbackground
{
    if (!_Showbackground) {
        _Showbackground = [[UIImageView alloc]init];
        _Showbackground.frame = CGRectMake(0, 0, kScreenWidth, kScaleX(184));
        self.scale = kScreenWidth/ kScaleX(184);
        [_Showbackground setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _Showbackground.contentMode = UIViewContentModeScaleAspectFill;
        _Showbackground.clipsToBounds = YES;
    }
    return _Showbackground;
}


- (void)updateNavWithOffsetY:(NSInteger)i {
    if (i >= 100) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x333333]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithHex:0x333333] }];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:20],
           NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333]}];
        WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:[UIColor colorWithHex:0x333333]];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = left;
        self.navigationItem.title = [NSString stringWithFormat:@"%@的个人主页",_userInfoModel.true_name];

    }else {
        self.navigationItem.title = @"个人主页";

        [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0xffffff]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithHex:0xffffff] }];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:20],
           NSForegroundColorAttributeName:[UIColor colorWithHex:0xffffff]}];
        WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor: [UIColor colorWithHex:0xffffff]];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = left;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]
                                                                                       size:CGSizeMake(kScreenWidth, NAV_HEIGHT)]
                                                      forBarMetrics:UIBarMetricsDefault];
        
        
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        // 高度宽度同时拉伸 从中心放大
        CGFloat imgH = kScaleY(184) - scrollView.contentOffset.y * 2;
        CGFloat imgW = imgH * self.scale;
        self.Showbackground.frame = CGRectMake(scrollView.contentOffset.y * self.scale,0, imgW,imgH);
        self.BackgroundMask.frame = CGRectMake(scrollView.contentOffset.y * self.scale,0, imgW,imgH);
    } else {
        // 只拉伸高度
        self.Showbackground.frame = CGRectMake(0, 0, kScreenWidth,kScaleY(184) - scrollView.contentOffset.y);
        self.BackgroundMask.frame = CGRectMake(0, 0, kScreenWidth,kScaleY(184) - scrollView.contentOffset.y);

    }

    
    
    // 如果需要竖着滑动生效.横着不生效
    if (ABS(scrollView.contentOffset.x) > ABS(scrollView.contentOffset.y)) {
        return;
    }
    
    YHValue resValue = YHValueMake(1, 0);
    YHValue conValue = YHValueMake(kScaleX(100), 64);
    self.navView.alpha = [NSObject resultWithConsult:scrollView.contentOffset.y andResultValue:resValue andConsultValue:conValue];
    NSInteger i = scrollView.contentOffset.y;
    [self updateNavWithOffsetY:i];
    [self setNeedsStatusBarAppearanceUpdate];

    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.delegate = self;
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (self.fromFriendList) {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete"]
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(deleteFriend)];
    }
    if (@available(iOS 11.0, *)) {
        _mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    if (_selfEditing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tihuanbeijingtu"]
                                                                                  style:UIBarButtonItemStyleDone target:self
                                                                                 action:@selector(changeTopBackGround)];
    }
    
    NSInteger i = self.mainTable.contentOffset.y;
    [self updateNavWithOffsetY:i];
    
    [self loadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}

#pragma mark -- 导航栏渐变
- (void)setupNavView {
    WQGroupDynamicNavView *navview = [[WQGroupDynamicNavView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navview.alpha = 0;
    self.navView = navview;
    [self.view addSubview:navview];
}


- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, -1, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.backgroundColor = [UIColor clearColor];
    // 设置自动行高和预估行高
    _mainTable.rowHeight = UITableViewAutomaticDimension;
    _mainTable.estimatedRowHeight = 300;
//    [_mainTable registerNib:[UINib nibWithNibName:@"WQUserProfileUserInfoCell" bundle:nil]
//     forCellReuseIdentifier:@"WQUserProfileUserInfoCell"];
    [_mainTable registerClass:[WQUserProfileUserInfoCell class] forCellReuseIdentifier:@"WQUserProfileUserInfoCell"];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQUserProfileExperienceCell" bundle:nil]
     forCellReuseIdentifier:@"WQUserProfileExperienceCell"];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQUserExperienceWithOutPossitionCell" bundle:nil]
     forCellReuseIdentifier:@"WQUserExperienceWithOutPossitionCell"];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQUserProfileFriendRequestInfoCell" bundle:nil]
     forCellReuseIdentifier:@"WQUserProfileFriendRequestInfoCell"];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQUserProfileJoinedGroupCell" bundle:nil]
     forCellReuseIdentifier:@"WQUserProfileJoinedGroupCell"];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQUserprofileJoinedGroupNotSelfCell" bundle:nil]
     forCellReuseIdentifier:@"WQUserprofileJoinedGroupNotSelfCell"];
    
    [_mainTable registerClass:NSClassFromString(@"WQInvidualCircleCell")
       forCellReuseIdentifier:@"WQInvidualCircleCell"];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQUserProfileShowMoreCell" bundle:nil]
     forCellReuseIdentifier:@"WQUserProfileShowMoreCell"];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"WQUserProfileNeedCell" bundle:nil]
     forCellReuseIdentifier:@"WQUserProfileNeedCell"];
    [_mainTable registerNib:[UINib nibWithNibName:@"WQInvidualFavoredCell" bundle:nil]
     forCellReuseIdentifier:@"WQInvidualFavoredCell"];
    
    //_mainTable.estimatedSectionHeaderHeight = 0;
    
    _mainTable.estimatedSectionFooterHeight = 0;
//    _mainTable.estimatedRowHeight = 0;
    [self.view addSubview:_mainTable];
    
    loadingView = [[WQLoadingView alloc] init];
    [loadingView show];
    [self.view addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == ProfileSectionNameUserBaseInfo) {
        return 1;
    }
    
    if (section == ProfileSectionNameFriendRequestInfo) {
        if (self.fromFriendRequest) {
            return 1;
        } else  {
            return 0;
        }
    }
    
    if (section == ProfileSectionNameWorkExperienceInfo) {
        return _showWorkExperience.count == _allWorkExperience.count ? _showWorkExperience.count : _showWorkExperience.count +1;
    }
    if (section == ProfileSectionNameEducationExperienceInfo) {
        return _showEducationExperience.count == _allEducationExperience.count ? _showEducationExperience.count : _showEducationExperience.count + 1;
    }
    
    if (section == ProfileSectionNameNeedsInfo) {
        return _showNeeds.count;
    }
    
    if (section == ProfileSectionNameInvidualTrendsInfo) {
        return _showInvidualTrends.count == _allInvidualTrends.count ? _showInvidualTrends.count : _showInvidualTrends.count + 1;
    }
    
    if (section == ProfileSectionNameJionedGroupsInfo) {
        return _showJoinedGroups.count == _allJoinedGroups.count ? _showJoinedGroups.count : _showJoinedGroups.count + 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    WQUserProfileCommonSectionHeaderView * header = [[NSBundle mainBundle] loadNibNamed:@"WQUserProfileCommonSectionHeaderView" owner:nil options:nil].lastObject;
    if (section == ProfileSectionNameUserBaseInfo) {
        return 1;
    }
    
    if (section == ProfileSectionNameFriendRequestInfo) {
        return CGFLOAT_MIN;
    }
    
    if (section == ProfileSectionNameWorkExperienceInfo) {
        
        if (self.showWorkExperience.count) {
            return 45;
        }
        return 100;
    }
    
    if (section == ProfileSectionNameEducationExperienceInfo) {
        
        if (self.showEducationExperience.count) {
            return 45;
        }
        return 100;
    }
    
    if (section == ProfileSectionNameNeedsInfo) {
        if (_showNeeds.count) {
            if (!_selfEditing) {
                return 50;
            } else {
                return [header headerHeightForHeaderConttent:@"他人查看您的主页时,需求将根据您发布时的设置显示或隐藏"];
            }
        }
    }
    
    if (section == ProfileSectionNameInvidualTrendsInfo) {
        if (_showInvidualTrends.count) {
            if (!_selfEditing) {
                return 50;
            } else {
                return [header headerHeightForHeaderConttent:@"他人查看您的主页时,动态将根据您发布时的设置显示或隐藏"];
            }
        }
    }
    
    if (section == ProfileSectionNameJionedGroupsInfo) {
        if (_showJoinedGroups.count) {
            if (!_selfEditing) {
                return 50;
            } else {
                return [header headerHeightForHeaderConttent:@"暂未加入圈子或暂未设置展示"];
            }
        } else {
            
            if (_selfEditing) {
                return 130;
            } else {
                return [header headerHeightForHeaderConttent:@"关闭后,他人查看您的个人主页时, 看不到您加入的圈子"];
            }
        }
    }
    
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == ProfileSectionNameUserBaseInfo) {
        
        return 10;
    }
    
    if (section == ProfileSectionNameFriendRequestInfo) {
        if (_fromFriendRequest) {
            
            return 10;
        } else {
            return CGFLOAT_MIN;
        }
        
    }
    
    if (section == ProfileSectionNameWorkExperienceInfo) {
        
        //        if (_showWorkExperience.count) {
        //            return 25;
        //        }
        return 10;
    }
    if (section == ProfileSectionNameEducationExperienceInfo) {
        
        //        if (_showEducationExperience.count) {
        //            return 25;
        //        }
        return 10;
    }
    
    
    if (section == ProfileSectionNameNeedsInfo) {
        if (_showInvidualTrends.count) {
            return 10;
        }
    }
    
    if (section == ProfileSectionNameInvidualTrendsInfo) {
//        if (_showJoinedGroups.count) {
            return 10;
//        }
    }
    
    if (section == ProfileSectionNameJionedGroupsInfo) {
        if (_showJoinedGroups.count) {
            return 10;
        }
    }
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    WQUserProfileCommonSectionHeaderView * header = [[NSBundle mainBundle] loadNibNamed:@"WQUserProfileCommonSectionHeaderView" owner:nil options:nil].lastObject;
    header.backgroundColor = [UIColor blueColor];
    header.clipsToBounds = YES;
    
//    BOOL myAccountAndEditing = _selfEditing && [_userInfoModel.im_namelogin isEqualToString:[EMClient sharedClient].currentUsername];
    
    BOOL isMyAccount = _userInfoModel.ismyaccount;
    if (section == ProfileSectionNameWorkExperienceInfo) {
        
        WQUserProfileAddExpericeView * view = [[NSBundle mainBundle] loadNibNamed:@"WQUserProfileAddExpericeView" owner:self options:nil].lastObject;
        view.titleLabel.text = @"工作经历";
        
        if (!_showWorkExperience.count) {
            if (isMyAccount) {
                view.emptyTextLabel.text = @"添加详细的工作经历\n让他人更好的了解您";
            } else {
                view.emptyTextLabel.text = @"暂未填写工作经历";
            }
        }
        
        
        view.addButton.hidden = !self.selfEditing || !self.userInfoModel.ismyaccount;
        [view.addButton addTarget:self action:@selector(addWork) forControlEvents:UIControlEventTouchUpInside];
        view.clipsToBounds = YES;
        return view;
    }
    if (section == ProfileSectionNameEducationExperienceInfo  ) {
        WQUserProfileAddExpericeView * view = [[NSBundle mainBundle] loadNibNamed:@"WQUserProfileAddExpericeView"
                                                                            owner:self
                                                                          options:nil].lastObject;
        
        view.titleLabel.text = @"学习经历";
        
        if (!_showEducationExperience.count) {
            if (isMyAccount) {
                view.emptyTextLabel.text = @"添加详细的学习经历\n让校友找到您";
            } else {
                view.emptyTextLabel.text = @"暂未填写学习经历";
            }
        }
        
        
        view.addButton.hidden = !self.selfEditing || !self.userInfoModel.ismyaccount;
        
        [view.addButton addTarget:self action:@selector(addEducation) forControlEvents:UIControlEventTouchUpInside];
        view.clipsToBounds = YES;
        return view;
    }
    
    
    if (section == ProfileSectionNameNeedsInfo) {
        
        
        header.titleLabel.text = @"需求";
        header.conttentLabel.text = @"他人查看您的主页时, 需求将根据您发布时的设置显示或隐藏";
        header.goReco.hidden = YES;
        return header;
    }
    
    if (section == ProfileSectionNameInvidualTrendsInfo) {
        header.titleLabel.text = @"动态";
        header.conttentLabel.text = @"他人查看您的主页时, 动态将根据您发布时的设置显示或隐藏";
        header.goReco.hidden = YES;
        return header;
    }
    
    if (section == ProfileSectionNameJionedGroupsInfo) {
        header.titleLabel.text = @"加入的圈子";
        header.labAllShow.hidden = NO;
//        header.switch1.hidden = (!_selfEditing) || (!_showJoinedGroups.count);
        header.switch1.hidden = YES;
//        header.labAllShow.hidden = (!_selfEditing) || (!_showJoinedGroups.count);
        header.labAllShow.hidden = YES;
        header.switch1.on = _userInfoModel.groups_show_all;
        header.goReco.hidden = (!_selfEditing) || _allJoinedGroups.count;
        if (_showJoinedGroups.count) {
            if (_selfEditing) {
                //
                header.conttentLabel.text = @"关闭后,他人查看您的个人主页时, 看不到您加入的圈子";
                
            } else {
                header.conttentLabel.text = @"";
            }
        } else {
            //
            if (_selfEditing) {
                //
                header.conttentLabel.text = @"加入圈子, 可以结识更多志同道合的人.";
            } else {
                header.conttentLabel.text = @"暂未加入圈子或没有设置展示";
            }
            
        }
        
        ROOT(root);
        header.goRecommendPage = ^{
            
            ROOT(root);
            [self.navigationController popViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                root.selectedIndex = 2;
            });
            
            //            WQRelationsCircleHomeViewController * vc = [[WQRelationsCircleHomeViewController alloc] init];
            //            [self.navigationController pushViewController:vc animated:YES];
        };
        
        
        return header;
    }
    
    
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
//    if (section == ProfileSectionNameWorkExperienceInfo ||
//        section == ProfileSectionNameEducationExperienceInfo) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.backgroundColor =WQ_BG_LIGHT_GRAY;
        return view;
//    }
//    return nil;
//
}


- (UITableViewCell * _Nonnull)showMoreInfoCellFor:(NSIndexPath * _Nonnull)indexPath {
    WQUserProfileShowMoreCell * showMoreCell =
    [_mainTable dequeueReusableCellWithIdentifier:@"WQUserProfileShowMoreCell"];
    
    ProfileSectionName sectionName = indexPath.section;
    UserProfileShowMore blk;
    UIImage * toRightImage = [UIImage imageNamed:@"jiantouyou"];
    UIImage * toBottomImage = [UIImage imageNamed:@"jiantouxia"];
    
    
    NSTextAttachment * attachR = [[NSTextAttachment alloc] init];
    attachR.image = toRightImage;
    NSTextAttachment * attachB = [[NSTextAttachment alloc] init];
    attachB.image = toBottomImage;
    NSAttributedString * attaR = [NSAttributedString attributedStringWithAttachment:attachR];
    NSAttributedString * attaB = [NSAttributedString attributedStringWithAttachment:attachB];
    
    switch (sectionName) {
        case ProfileSectionNameWorkExperienceInfo: {
            
            
            // MARK: 以下数组作为实际的所有经历的数据源
            //            @property (nonatomic, retain) NSArray * allEducationExperience;
            //            @property (nonatomic, retain) NSArray * allWorkExperience;
            //            @property (nonatomic, retain) NSArray * allNeeds;
            //            @property (nonatomic, retain) NSArray * allInvidualTrends;
            //            @property (nonatomic, retain) NSArray * allJoinedGroups;
            //
            //            // MARK: 以下数组作为真正展示的数据源
            //            @property (nonatomic, retain) NSArray * showEducationExperience;
            //            @property (nonatomic, retain) NSArray * showWorkExperience;
            //            @property (nonatomic, retain) NSArray * showNeeds;
            //            @property (nonatomic, retain) NSArray * showInvidualTrends;
            //            @property (nonatomic, retain) NSArray * showJoinedGroups;
            
            NSString * title = [NSString stringWithFormat:@"查看其他 %ld 条 ",_allWorkExperience.count - _showWorkExperience.count];
            
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
            NSMutableParagraphStyle * style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
            style.alignment = NSTextAlignmentCenter;
            [attr yy_setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                     NSParagraphStyleAttributeName :style}];
            [attr appendAttributedString:attaB];
            
            
            [showMoreCell.showMoreButton setAttributedTitle:attr forState:UIControlStateNormal];
            
            blk = ^{
                
                NSMutableArray * indexPaths = @[].mutableCopy;
                
                for (NSInteger i = _showWorkExperience.count; i < _allWorkExperience.count; ++ i) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:ProfileSectionNameWorkExperienceInfo] ];
                }
                //
                _showWorkExperience = _allWorkExperience;
                
                [_mainTable beginUpdates];
                [_mainTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [_mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:ProfileSectionNameWorkExperienceInfo]] withRowAnimation:UITableViewRowAnimationNone];
                [_mainTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                [_mainTable endUpdates];
                
                
            };
            break;
        }
        case ProfileSectionNameEducationExperienceInfo: {
            
            NSString * title = [NSString stringWithFormat:@"查看其他 %ld 条 ",_allEducationExperience.count - _showEducationExperience.count];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
            NSMutableParagraphStyle * style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
            style.alignment = NSTextAlignmentCenter;
            [attr yy_setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                     NSParagraphStyleAttributeName :style}];
            [attr appendAttributedString:attaB];
            [showMoreCell.showMoreButton setAttributedTitle:attr forState:UIControlStateNormal];
            
            blk = ^{
                
                //
                NSMutableArray * indexPaths = @[].mutableCopy;
                
                for (NSInteger i = _showEducationExperience.count; i < _allEducationExperience.count; ++ i) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:ProfileSectionNameEducationExperienceInfo] ];
                }
                _showEducationExperience = _allEducationExperience;
                [_mainTable beginUpdates];
                [_mainTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [_mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:ProfileSectionNameEducationExperienceInfo]] withRowAnimation:UITableViewRowAnimationNone];
                [_mainTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                [_mainTable endUpdates];
                
            };
            break;
        }
        case ProfileSectionNameInvidualTrendsInfo: {
            
            
            NSString * title = [NSString stringWithFormat:@"查看更多 "];
            
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
            [attr yy_setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
            [attr appendAttributedString:attaR];
            [showMoreCell.showMoreButton setAttributedTitle:attr forState:UIControlStateNormal];
            
            blk = ^{
                
                // TODO: 进入个人所有动态的列表
                WQInvidualTrendsController * vc = [[WQInvidualTrendsController alloc] initWithUserId:self.userInfoModel.im_namelogin andUserName:_userInfoModel.true_name];
                [self.navigationController pushViewController:vc animated:YES];
            };
            break;
        }
        case ProfileSectionNameJionedGroupsInfo:{
            NSString * title = [NSString stringWithFormat:@"查看更多 "];
            
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:title];
            [attr yy_setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
            [attr appendAttributedString:attaR];
            [showMoreCell.showMoreButton setAttributedTitle:attr forState:UIControlStateNormal];
            blk = ^{
                // TODO: 进入个人所有展示的加入的圈子的列表
                WQUserProfileAllJoinedGroupsController * vc = [[WQUserProfileAllJoinedGroupsController alloc] init];
                vc.groupsInfo = _allJoinedGroups.copy;
                [self.navigationController pushViewController:vc animated:YES];
            };
            break;
        }
        default:
            break;
    }
    
    showMoreCell.showMoreInfo = blk;
    return showMoreCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if (section == ProfileSectionNameUserBaseInfo) {
        // MARK: 个人信息
        WQUserProfileUserInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQUserProfileUserInfoCell"];
        cell.toReplaceImage = _toReplaceImage;
        cell.model = _userInfoModel;
        cell.selfEditing = self.selfEditing;
        
            if (_userInfoModel.pic_bg.length) {
                [self.Showbackground yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_URLSTRING(_userInfoModel.pic_bg)] placeholder:[UIImage imageWithColor:[UIColor colorWithHex:0xeeeeee]]];
            }else {
                // 为空的话显示默认图
                self.Showbackground.image = [UIImage imageNamed:@"userProfileBg"];
            }

        
        
        cell.goTalking = ^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *userName = [userDefaults objectForKey:@"true_name"];
            NSString *userPic = [userDefaults objectForKey:@"pic_truename"];
            
            WQChaViewController *chatController = [[WQChaViewController alloc]
                                                   initWithConversationChatter:self.userInfoModel.im_namelogin
                                                   conversationType:EMConversationTypeChat
                                                   needId:nil
                                                   needOwnerId:nil
                                                   fromName:userName
                                                   fromPic:userPic
                                                   toName:_userModel.true_name
                                                   toPic:_userModel.pic_truename
                                                   isFromTemp:NO
                                                   isTrueName:YES
                                                   isBidTureName:YES];
            
            [self.navigationController pushViewController:chatController animated:YES];
            
        };
        
        
        cell.friendApply = ^{
            WQaddFriendsController *addFriendsVc = [[WQaddFriendsController alloc]initWithIMId:self.userId];
            addFriendsVc.type = @"添加好友";
            [self.navigationController pushViewController:addFriendsVc animated:YES];
        };
        
        cell.goPreview = ^{
            
            WQUserProfileController * vc = [[WQUserProfileController alloc] init];
            vc.userId = self.userId;
            vc.selfEditing = !self.selfEditing;
            
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.changeAvartar = ^{
            WQBottomPopupWindowView * view = [[WQBottomPopupWindowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            _popWindow = view;
            [self.view addSubview:view];
            view.delegate = self;
        };
        
        
        
        cell.goConfim = ^{
            WQComfimController * vc = [[WQComfimController alloc] init];
            vc.phoneNumber = _userModel.cellphone;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.follwOrUnfollow = ^(UIButton *sender) {
            
            [self followOrUnfollowUser:sender];
        };
        
        
        cell.changeBackGroundImage = ^{
            [self changeTopBackGround];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.section == ProfileSectionNameFriendRequestInfo) {
        WQUserProfileFriendRequestInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQUserProfileFriendRequestInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userName = _userInfoModel.true_name;
        cell.requestInfo = _requestInfo;
        return cell;
    }
    //    工作经历
    if (section == ProfileSectionNameWorkExperienceInfo) {
        
        
        if (_showWorkExperience.count < _allWorkExperience.count && indexPath.row == 2) {
            return  [self showMoreInfoCellFor:indexPath];
        }
        
        WQUserWorkExperienceModel * model = _showWorkExperience[indexPath.row];
        
        if (model.work_position.length) {
            
            WQUserProfileExperienceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQUserProfileExperienceCell"];
            cell.workModel = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.rightArrow.hidden = !self.selfEditing || !self.userInfoModel.ismyaccount;
            
            if (indexPath.row == _showWorkExperience.count - 1) {
                cell.bottomSpace.constant = 20;
            } else {
                cell.bottomSpace.constant = 0;
            }
            
            cell.goConfim = ^{
                [self confim:indexPath];
            };
            return cell;
        } else {
            
            WQUserExperienceWithOutPossitionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQUserExperienceWithOutPossitionCell"];
            cell.workModel = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.rightArrow.hidden = !self.selfEditing || !self.userInfoModel.ismyaccount;;
            cell.goConfim = ^{
                [self confim:indexPath];
            };
            return cell;
        }
        
    }
    //    学习经历
    if (section == ProfileSectionNameEducationExperienceInfo) {
        
        if (_allEducationExperience.count > _showEducationExperience.count &&
            (indexPath.row ==2)) {
            return [self showMoreInfoCellFor:indexPath];
        }
        WQUserProfileExperienceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQUserProfileExperienceCell"];
        cell.educationModel = _showEducationExperience[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightArrow.hidden = !self.selfEditing;
        
        if (indexPath.row == _showEducationExperience.count - 1) {
            cell.bottomSpace.constant = 20;
        } else {
            cell.bottomSpace.constant = 0;
        }
        cell.goConfim = ^{
            [self confim:indexPath];
        };
        return  cell;
    }
    
    //    需求信息
    if (section == ProfileSectionNameNeedsInfo) {
        WQUserProfileNeedCell * cell =
        [_mainTable dequeueReusableCellWithIdentifier:@"WQUserProfileNeedCell"];
        cell.model = _allNeeds[indexPath.row];
        if (indexPath.row == _allNeeds.count - 1) {
            cell.imageBottomConstent.constant = 15;
        } else {
            cell.imageBottomConstent.constant = 0;
        }
        return cell;
    }
    
    if (section == ProfileSectionNameInvidualTrendsInfo) {
        if (_allInvidualTrends.count > _showInvidualTrends.count && indexPath.row == 3) {
            return [self showMoreInfoCellFor:indexPath];
        } else {
            
            WQUserProfileInvidualTrendsModel * model = _showInvidualTrends[indexPath.row];
            //            TYPE_MOMENT_STATUS=万圈状态；TYPE_CHOICEST_ARTICLE=精选文章；TYPE_MOMENT_USER=感兴趣用户
            if ([model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
                
                WQInvidualCircleCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQInvidualCircleCell"];
                
                
                cell.model = model;
                if (indexPath.row == _showInvidualTrends.count - 1) {
                    [cell adjustSapratorForLast];
                } else {
                    [cell adjustForCommon];
                }
                return cell;
                
            }
            if ([model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
                
                WQInvidualFavoredCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQInvidualFavoredCell"];
                cell.model = model;
                if (indexPath.row == _showInvidualTrends.count - 1) {
                    [cell adjustSapratorForLast];
                } else {
                    [cell adjustForCommon];
                }
                return cell;
            }
            
            WQInvidualCircleCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQInvidualCircleCell"];
            return cell;
        }
    }
    
    if (section == ProfileSectionNameJionedGroupsInfo && indexPath.row == 3 && !_selfEditing) {
        return [self showMoreInfoCellFor:indexPath];
    } else {
        WQUserProfileGroupModel * model = _showJoinedGroups[indexPath.row];
        
        
        
        if (!_selfEditing) {
            
            WQUserprofileJoinedGroupNotSelfCell * cell =
            [_mainTable dequeueReusableCellWithIdentifier:@"WQUserprofileJoinedGroupNotSelfCell"];
            
            
            cell.model = model;
            
            return cell;
            
            
        } else {
            WQUserProfileJoinedGroupCell * cell =
            [_mainTable dequeueReusableCellWithIdentifier:@"WQUserProfileJoinedGroupCell"];
            cell.model = model;
            
            cell.showSwitch.on = [[WQGroupSwitchDataEntity sharedEntity] switchStatusForGroup:model.gid];
            
//            if (!_userInfoModel.groups_show_all) {
//                cell.showSwitch.on = NO;
//            }
            __weak typeof(self)weakself = self;
            cell.makePublic = ^(BOOL public, UISwitch * aSwitch) {
                [weakself updateGroupStatus:model.gid isPublic:public withSwitch:aSwitch];
            };
            return cell;
        }
    }
    
    return  [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ProfileSectionNameUserBaseInfo) {
        return UITableViewAutomaticDimension;
    }
    
    if (indexPath.section == ProfileSectionNameFriendRequestInfo) {
        if (_fromFriendRequest) {
            
            WQUserProfileFriendRequestInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WQUserProfileFriendRequestInfoCell"];
            return [cell heightWithText:_requestInfo];
        } else {
            return 0;
        }
    }
    
    
    if (indexPath.section == ProfileSectionNameWorkExperienceInfo) {
        if (indexPath.row == 2 &&
            _showWorkExperience.count < _allWorkExperience.count) {
            return 50;
        }
        
        if ([_showWorkExperience[indexPath.row] work_position].length) {
            return 90;
        } else {
            return 65;
        }
    }
    
    if (indexPath.section == ProfileSectionNameEducationExperienceInfo) {
        
        if (indexPath.row == 2 &&
            _showEducationExperience.count < _allEducationExperience.count) {
            
            return 50;
        }
        return 90;
    }
    
    
    if (indexPath.section == ProfileSectionNameNeedsInfo) {
        
        return 70;
    }
    
    if (indexPath.section == ProfileSectionNameInvidualTrendsInfo) {
        
        if (indexPath.row == 3 &&
            _showInvidualTrends.count != _allInvidualTrends.count) {
            
            return 50;
        } else {
            WQUserProfileInvidualTrendsModel * model = _showInvidualTrends[indexPath.row];
            //              TYPE_MOMENT_STATUS=万圈状态；TYPE_CHOICEST_ARTICLE=精选文章；TYPE_MOMENT_USER=感兴趣用户
            if ([model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
                WQInvidualCircleCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQInvidualCircleCell"];
                return [cell heightWithModel:model];
                
            }
            if ([model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
                WQInvidualFavoredCell * cell = [_mainTable dequeueReusableCellWithIdentifier:@"WQInvidualFavoredCell"];
                return [cell heightWithModel:model];
            }
            
        }
    }
    
    if (indexPath.section == ProfileSectionNameJionedGroupsInfo) {
        
        if (indexPath.row == 3 &&
            _allJoinedGroups.count != _showJoinedGroups.count &&
            !_selfEditing) {
            
            return 50;
        }
        return 90;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isMyAccuont = _userInfoModel.ismyaccount;
    
    
    if (indexPath.section == ProfileSectionNameUserBaseInfo) {
        return;
    }
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == ProfileSectionNameWorkExperienceInfo) {
        if (!isMyAccuont || !self.selfEditing) {
            return;
        }
        WQmodifyWorkViewController * vc = [[WQmodifyWorkViewController alloc] initWithType:@"" modelArray:_userModel.work_experience andCurrentIndex:indexPath.row];
        
        vc.work = _userInfoModel.work_experience.mutableCopy;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == ProfileSectionNameEducationExperienceInfo) {
        if (!isMyAccuont || !self.selfEditing) {
            return;
        }
        WQmodifyEducationViewController * vc =
        [[WQmodifyEducationViewController alloc] initWithType:@""
                                                        model:_userModel.education[indexPath.row]];
        vc.modifingIndex = indexPath.row;
        vc.currentEducetionExperience = _userModel.education;
        vc.educetions = self.userInfoModel.education.mutableCopy;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == ProfileSectionNameNeedsInfo) {
        
        if ([cell isKindOfClass:[WQUserProfileNeedCell class]]) {
            WQUserProfileNeedModel * model = _showNeeds[indexPath.row];
            WQorderViewController * vc =
            [[WQorderViewController alloc]initWithNeedsId:model.id];
            vc.isHome = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    
    if (indexPath.section == ProfileSectionNameInvidualTrendsInfo) {
        if (indexPath.row < _showInvidualTrends.count) {
            WQUserProfileInvidualTrendsModel * model = _showInvidualTrends[indexPath.row];
            //             TYPE_MOMENT_STATUS=万圈状态；TYPE_CHOICEST_ARTICLE=精选文章；TYPE_MOMENT_USER=感兴趣用户
            if ([model.moment_type isEqualToString:@"TYPE_MOMENT_STATUS"]) {
                WQdynamicDetailsViewConroller * vc = [[WQdynamicDetailsViewConroller alloc] init];
                vc.mid = model.moment_status.id;
                
                // TODO: 需要传值
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([model.moment_type isEqualToString:@"TYPE_CHOICEST_ARTICLE"]) {
                WQEssenceDetailController * vc = [[WQEssenceDetailController alloc] init];
                vc.model = model.moment_choicest_article;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            
        }
    }
    
    if (indexPath.section == ProfileSectionNameJionedGroupsInfo) {
        if (indexPath.row < _showJoinedGroups.count) {
            WQUserProfileGroupModel * model = _showJoinedGroups[indexPath.row];
            if (model.isGroupUser) {
                WQGroupDynamicViewController *vc = [[WQGroupDynamicViewController alloc] init];
                vc.gid = model.gid;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                WQGroupInformationViewController * vc = [[WQGroupInformationViewController alloc] init];
                vc.gid = model.gid;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } else {
            
            WQUserProfileAllJoinedGroupsController * vc = [[WQUserProfileAllJoinedGroupsController alloc] init];
            vc.groupsInfo = _allJoinedGroups.copy;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
    
}

#pragma mark - http

- (void)loadData {
    
    NSString *urlString = @"api/user/getbasicinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * params = @{}.mutableCopy;
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"uid"] = self.userId;
    NSLog(@"%@",params);

    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"%@",error);
            [loadingView dismiss];
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        
        _userInfoModel = [WQUserInfoModel yy_modelWithJSON:response];
        
        _allWorkExperience = [NSArray yy_modelArrayWithClass:[WQUserWorkExperienceModel class] json:response[@"work_experience"]];
        

        
        if (_allWorkExperience.count > 2) {
            _showWorkExperience = [_allWorkExperience subarrayWithRange:NSMakeRange(0, 2)];
        } else {
            _showWorkExperience = _allWorkExperience;
        }
        
        _allEducationExperience =  [NSArray yy_modelArrayWithClass:[WQUserEducationExperienceModel class] json:response[@"education"]];
        if (_allEducationExperience.count > 2) {
            _showEducationExperience = [_allEducationExperience subarrayWithRange:NSMakeRange(0, 2)];
        } else {
            _showEducationExperience = _allEducationExperience;
        }
        
        _allInvidualTrends = [NSArray yy_modelArrayWithClass:[WQUserProfileInvidualTrendsModel class] json:response[@"moments"]];
        
        if (_allInvidualTrends.count > 3) {
            _showInvidualTrends = [_allInvidualTrends subarrayWithRange:NSMakeRange(0, 3)];
        } else {
            _showInvidualTrends = _allInvidualTrends;
        }
        _allNeeds = [NSArray yy_modelArrayWithClass:[WQUserProfileNeedModel class]
                                               json:response[@"needs"]];
        _showNeeds = _allNeeds;
        
        _allJoinedGroups = [NSArray yy_modelArrayWithClass:[WQUserProfileGroupModel class]
                                                      json:response[@"groups"]];
        
        [[WQGroupSwitchDataEntity sharedEntity] updateGroupSwitchStatusWith:_allJoinedGroups];
        
        //        _groups_show_all = [response[@"groups_show_all"] boolValue];;
        
        if (_allJoinedGroups.count> 3 && !self.selfEditing) {
            _showJoinedGroups = [_allJoinedGroups subarrayWithRange:NSMakeRange(0, 3)];
        } else {
            _showJoinedGroups = _allJoinedGroups;
        }
        
        
        NSLog(@"%@",response);
        _userModel = [WQUserProfileModel yy_modelWithJSON:response];
        
        //        (WQUserProfileTableHeaderView *)(_tableview.tableHeaderView))
        
        
        
        if ([response[@"idcard_status"] isEqualToString:@"STATUS_UNVERIFY"]) {
            
            NSArray  *viewArray = [[NSBundle mainBundle]loadNibNamed:@"WQUserProfileTableFooterView" owner:nil options:nil];
            UIView *footer = [viewArray firstObject];
            //加载视图
            footer.frame = CGRectMake(0, 0, kScreenWidth, 60);
            _mainTable.tableFooterView = footer;
        }
        
        [_mainTable reloadData];
        [loadingView dismiss];
    }];
}


#pragma mark - private 
- (void)addWork {
    NSString *  idcard_status = _userInfoModel.idcard_status;
    
    
    if ([idcard_status isEqualToString:@"STATUS_VERIFING"]) {
        [WQAlert showAlertWithTitle:nil message:@"您的账户正在审核中,请耐心等待" duration:1.5];
        return;
    }
    if ([_userModel.idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
        UIAlertController * alert =
         [UIAlertController alertControllerWithTitle:nil
                                            message:@"请实名认证后,填写教育经历,获得更高信用"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * confim = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WQComfimController * vc = [[WQComfimController alloc] init];
            vc.phoneNumber = _userModel.cellphone;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alert addAction:confim];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    WQaddWorkViewController * vc = [[WQaddWorkViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)addEducation {
    
    NSString *  idcard_status = _userInfoModel.idcard_status;
    
    
    if ([idcard_status isEqualToString:@"STATUS_VERIFING"]) {
        [WQAlert showAlertWithTitle:nil message:@"您的账户正在审核中,请耐心等待" duration:1.5];
        return;
    }
    if ([_userModel.idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
        UIAlertController * alert =
         [UIAlertController alertControllerWithTitle:nil
                                            message:@"请实名认证后,填写教育经历,获得更高信用"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * confim = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WQComfimController * vc = [[WQComfimController alloc] init];
            vc.phoneNumber = _userModel.cellphone;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alert addAction:confim];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    WQWQaddEducationViewController * vc = [[WQWQaddEducationViewController alloc] init];
    vc.curentEducationExperiences = _userModel.education;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)confim:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    NSString * confirmType ;
    NSString * exp ;
    NSString * type;
    
    if (indexPath.section == ProfileSectionNameWorkExperienceInfo) {

        WQTwoWorkUserProfileModel * model = _userModel.work_experience[indexPath.row];
        type = model.type;

        confirmType = @"工作";
        exp = model.work_enterprise;
    }
    if (indexPath.section == ProfileSectionNameEducationExperienceInfo){
        WQTwoUserProfileModel * model = _userModel.education[indexPath.row];
        confirmType = @"学习";
        exp = model.education_school;
        type = model.type;
    }
    
    NSString * name = _userInfoModel.true_name;
    
    
    NSString * message = [NSString stringWithFormat:@"您要用信用分担保为%@认证在%@的%@经历吗?",name,exp,confirmType];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示:" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *urlString = @"api/user/confirm";
        
        NSMutableDictionary * param = @{}.mutableCopy;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        param[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
        param[@"uid"] = self.userId;
        param[@"type"] = type;
        
        WQNetworkTools *tools = [WQNetworkTools sharedTools];
        [tools request:WQHttpMethodPost urlString:urlString parameters:param completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            NSLog(@"%@",response);
            if ([response[@"success"] boolValue]) {
                [self loadData];
                //                [_mainTable reloadData];
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"认证成功!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                [weakSelf presentViewController:alertVC
                                       animated:YES
                                     completion:^{
                                         
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                                                      (int64_t)(1 * NSEC_PER_SEC)),
                                                        dispatch_get_main_queue(), ^{
                                                            
                                                            [alertVC dismissViewControllerAnimated:YES completion:nil];
                                                        });
                                     }];
            } else {
                NSString * message = [NSString stringWithFormat:@"%@",response[@"message"]];
                UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                
                [weakSelf presentViewController:alertVC animated:YES completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                                 (int64_t)(1 * NSEC_PER_SEC)),
                                   dispatch_get_main_queue(), ^{
                                       [alertVC dismissViewControllerAnimated:YES completion:nil];
                                   });
                }];
            }
        }];
    }];
    
    [alert addAction:cancle];
    [alert addAction:confirm];
    [weakSelf presentViewController:alert animated:YES completion:nil];
}


- (void)deleteFriend {
    [SVProgressHUD showWithStatus:@"删除中…"];
    
    NSData *arrAydata = [NSJSONSerialization dataWithJSONObject:@[self.userId]
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:nil];
    NSString *labelTagString = [[NSString alloc] initWithData:arrAydata
                                                     encoding:NSUTF8StringEncoding];
    
    NSString *urlString = @"api/friend/remove";
    NSMutableDictionary * params = @{}.mutableCopy;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    params[@"friends"] = labelTagString;
    
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        
        if (error) {
            
            [WQAlert showAlertWithTitle:nil message:@"请检查网络连接后重试" duration:1];
            [SVProgressHUD dismissWithDelay:1];
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        if ([response[@"success"] boolValue]) {
            [SVProgressHUD showWithStatus:@"删除成功"];
            [SVProgressHUD dismissWithDelay:1];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)(1 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(),
                           ^{
                               [self.navigationController popViewControllerAnimated:YES];
                           });
        } else {
            [WQAlert showAlertWithTitle:nil message:@"请检查网络连接后重试" duration:1];
            [SVProgressHUD dismissWithDelay:1];
            NSLog(@"%@",error);
            return ;
        }
    }];
}


#pragma mark - navvcDelegate 


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  {
    
    if (operation == UINavigationControllerOperationPop) {
        navigationController.delegate = nil;
    }
    
    if (operation == UINavigationControllerOperationPush) {
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"]
                                                 forBarMetrics:UIBarMetricsDefault];
    }
    
    return nil;
}




- (void)wqFinishAction:(WQBottomPopupWindowView *)bottomPopupWindowView image:(UIImage *)image {
    
    [self uploadImage:image imageType:UploadImageTypeHeadImage];
}

- (void)wqDeleteBtnClick:(WQBottomPopupWindowView *)bottomPopupWindowView {
    
    [bottomPopupWindowView removeFromSuperview];
}


- (void)uploadHeadImageSucceed {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"头像上传成功.审核通过后将会显示,请您耐心等待"
                                                    delegate:nil
                                           cancelButtonTitle:@"知道了"
                                           otherButtonTitles: nil];
    [alert show];
    [_popWindow removeFromSuperview];
}

- (void)uploadBackGroundImageSucceed {
    [self loadData];
}

- (void)uploadImageFailed {
    [SVProgressHUD dismiss];
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"上传图片失败,请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVC animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

/**
 上传更换的头像 或者 个人页面的背景
 
 @param image 上传的图片
 */
- (void)uploadImage:(UIImage *)image imageType:(UploadImageType)imageType {
    NSString *urlString = @"file/upload";
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [SVProgressHUD showWithStatus:@"正在上传"];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    
    [[WQNetworkTools sharedTools] POST:urlString
                            parameters:nil
             constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                 
                 [formData appendPartWithFileData:data
                                             name:@"file"
                                         fileName:@"wanquantupian"
                                         mimeType:@"application/octet-stream"];
                 
             } progress:^(NSProgress * _Nonnull uploadProgress) {
                 
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 if ([responseObject isKindOfClass:[NSData class]]) {
                     responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                 }
                 NSLog(@"success : %@", responseObject);
                 
                 BOOL successbool = [responseObject[@"success"] boolValue];
                 if (successbool) {
                     NSString * fileID = responseObject[@"fileID"];
                     
                     NSString * strURL = @"api/user/update";
                     NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
                     if (!secreteKey.length) {
                         return;
                     }
                     NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
                     if (imageType == UploadImageTypeHeadImage) {
                         param[@"pic_truename"] = fileID;
                     } else {
                         param[@"pic_bg"] = fileID;
                     }
                     
                     
                     WQNetworkTools *tools = [WQNetworkTools sharedTools];
                     [tools request:WQHttpMethodPost
                          urlString:strURL
                         parameters:param
                         completion:^(id response, NSError *error) {
                             if (error) {
                                 [SVProgressHUD dismiss];
                                 return ;
                             }
                             if (![response[@"success"] boolValue]) {
                                 
                                 [SVProgressHUD dismiss];
                                 UIAlertController *alertVC =
                                  [UIAlertController alertControllerWithTitle:nil
                                                                     message:@"上传图片失败,请稍后重试"
                                                              preferredStyle:UIAlertControllerStyleAlert];
                                 [self presentViewController:alertVC
                                                    animated:YES
                                                  completion:^{
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                                                                   (int64_t)(1 * NSEC_PER_SEC)),
                                                                     dispatch_get_main_queue(),
                                                                     ^{
                                                                         [alertVC dismissViewControllerAnimated:YES
                                                                                                     completion:nil];
                                                                     });
                                                  }];
                             } else {
                                 [SVProgressHUD dismiss];
                                 if (imageType == UploadImageTypeHeadImage) {
                                     [self uploadHeadImageSucceed];
                                 } else {
                                     [self uploadBackGroundImageSucceed];
                                     _toReplaceImage = [UIImage imageWithData:data];
                                 }
                             }
                             
                         }];
                 } else {
                     [self uploadImageFailed];
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"error : %@", error);
                 [self uploadImageFailed];
             }];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    
    NSInteger i = _mainTable.contentOffset.y;
    if (i < 100) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}


/**
 更换个人主页背景
 */
- (void)changeTopBackGround {
    
//    if (![_userInfoModel.im_namelogin isEqualToString:[EMClient sharedClient].currentUsername]) {
//        return;
//    }
//    [[WQAuthorityManager manger] showAlertForAlbumAuthority];
//    [[WQAuthorityManager manger] showAlertForCameraAuthority];
    
    TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    picker.cropRect = CGRectMake(0, kScreenHeight / 2 - kScreenWidth / 320 * 171 / 2, kScreenWidth, kScreenWidth / 320 * 171);
    [self presentViewController:picker animated:YES completion:nil];
    
    [picker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0] size:CGSizeMake(kScreenWidth, NAV_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    picker.allowCrop = YES;
    picker.allowPreview = YES;
    [picker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage * uploadImage = photos[0];
        
        //        uploadImage =
        if (uploadImage) {
            [self uploadImage:uploadImage imageType:UploadImageTypeProfileBackGround];
        }
    }];
}


/**
 主开关的开关
 
 @param noti  noti
 */
- (void)mainSwitchChanged:(NSNotification *)noti {
    // TODO: 发送网络请求并处理开关
    UISwitch * switch1 = noti.object;
    _userInfoModel.groups_show_all = switch1.on;
    
    if ([noti.userInfo[WQ_SWITCH_FORBID_NOTI_KEY] boolValue]) {
        return;
    }
    [self updateGroupStatus:@"" isPublic:switch1.on withSwitch:switch1];
    
    NSLog(@"MAIN switch is %@",switch1.isOn ? @"on" : @"off");
    
}


/**
 使圈子公开或者不公开的请求
 
 @param groupId 群组 id 为@""则是全部圈子
 @param public 打开或者关闭
 */
- (void)updateGroupStatus:(NSString * )groupId isPublic:(BOOL)public withSwitch:(UISwitch *)aSwitch{
    
    if (!groupId.length) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WQUserProfileMainSwitchDidOffNoti
                                                            object:aSwitch
                                                          userInfo:@{WQ_SWITCH_FORBID_NOTI_KEY : @(YES)}];
        [_mainTable reloadSections:[NSIndexSet indexSetWithIndex:ProfileSectionNameJionedGroupsInfo]
                  withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    
    NSString * url =  @"api/group/setgroupuserpublicshow";
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{@"secretkey":secreteKey}.mutableCopy;
    param[@"gid"] = groupId;
    
    
    if (public) {
        param[@"public_show"] = @"true";
    } else {
        param[@"public_show"] = @"false";
    }

    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:url parameters:param completion:^(id response, NSError *error) {
        
        BOOL requestSuccess = (!error ) && ([response[@"success"] boolValue]);
        
        if (requestSuccess) {
            if ((!public) && (!groupId.length)) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WQUserProfileMainSwitchDidOffNoti
                                                                    object:aSwitch
                                                                  userInfo:@{WQ_SWITCH_FORBID_NOTI_KEY : @(YES)}];
            }
        } else {
            aSwitch.on = !public;
        }
//            [self loadData];
//        }
    }];
}

- (void)followOrUnfollowUser:(UIButton *)sender {
    
    if (!_userInfoModel) {
        return;
    }
    [SVProgressHUD show];
    BOOL isFollow = !sender.selected;
    NSString * url = isFollow ? @"api/user/follow/createfollow" : @"api/user/follow/deletefollow";
    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    if (!secreteKey.length) {
        return;
    }
    NSMutableDictionary * param = @{
                                    @"secretkey":secreteKey,
                                    @"uid":_userInfoModel.im_namelogin
                                    }.mutableCopy;
    
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost
                                urlString:url parameters:param
                               completion:^(id response, NSError *error) {
                                   
                                   BOOL requestSuccess = (!error) && ([response[@"success"] boolValue]);
                                   if (requestSuccess) {
                                       
                                       [self loadData];
                                       sender.selected = !sender.selected;
                                   } else {
                                       NSString * alertMessage ;
                                       if (sender.selected) {
                                           alertMessage = @"取消关注该用户失败了请稍后重试";
                                       } else {
                                           alertMessage = @"关注该用户失败了请稍后重试";
                                       }
                                       [WQAlert showAlertWithTitle:nil
                                                           message:alertMessage
                                                          duration:1];
                                   }
                               }];
}

@end
