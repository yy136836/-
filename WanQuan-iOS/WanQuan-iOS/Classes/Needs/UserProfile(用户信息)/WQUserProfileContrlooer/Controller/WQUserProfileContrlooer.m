//
//  WQUserProfileContrlooer.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQUserProfileContrlooer.h"
#import "WQUserProfileTableViewCell.h"
#import "WQUserProfileModel.h"
#import "WQaddFriendsController.h"
#import "WQTwoUserProfileModel.h"
#import "WQconfirmsModel.h"
#import "WQTwoWorkUserProfileModel.h"
#import "YYWebImage.h"
#import "YYPhotoBrowseView.h"
#import "WQChaViewController.h"
#import "WQUserProfileTableHeaderView.h"
#import "WQUserProfileAddExperienceCell.h"
#import "WQaddWorkViewController.h"
#import "WQWQaddEducationViewController.h"
#import "WQmodifyWorkViewController.h"
#import "WQmodifyEducationViewController.h"
#import "CLImageScrollDisplayView.h"
#import "WQUserProfileTableFooterView.h"
#import "WQComfimController.h"
#import <WebKit/WebKit.h>
#import "WQPrefixHeader.pch"

static NSString *cellid = @"celiid";
static NSString * addCellId = @"addcellid";


@interface WQUserProfileContrlooer ()<UITableViewDelegate,UITableViewDataSource>

/**
 使用该模型进行数据展示
 */
@property (nonatomic, strong) WQUserProfileModel *userModel;
@property (nonatomic, strong) WQUserProfileTableViewCell *cell;
@property (nonatomic, strong) NSArray *authenticateUserArray;
@property (nonatomic, strong) NSArray *userlist;
@property (nonatomic, strong) NSMutableDictionary *certificationParams;
@property (nonatomic, strong) NSMutableDictionary *listParams;
//@property (nonatomic, strong) UIButton *plusFriends;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *tableViewdetailOrderData;
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UILabel *experienceLabel;
@property (nonatomic, assign) BOOL isfriend;                  //是否是好友
@property (nonatomic, copy) NSString *plusFriendsImName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *workType;
@property (nonatomic, copy) NSString *educationType;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *im_namelogin;

@property (nonatomic, copy) NSString * myId;
@property (nonatomic, retain) UIButton * bottomButton;
@end


#define kPreviewButtonTitle         @"预览"
#define kSendMessageButtonTitle     @"临时消息"
#define kModifyButtonTitle          @"修改信息"
#define kAddFriendButtonTitle       @"加好友"

@implementation WQUserProfileContrlooer {
    //    由于工作经历和教育经历都是通过字典整体进行进行保存编辑,和上传而不是通过传统的键值,所以不容易使用模型处理数据
    //    @[
    //          @{work_start_time : "2017-4"
    //          work_position : "iOS开发工程师"
    //          confirmcount : 2
    //          work_end_time : ""
    //          work_enterprise : "清华大学社会创新和风险管理研究中心"
    //          confirms:{}
    //            },
    //          ...
    //      ]
    
    //    [
    //    {
    //    education_end_time : "2011-7"
    //    education_major : "市场营销"
    //    education_school : "中国石油大学"
    //    confirmcount : 2
    //    confirms:{}
    //    type : "ef02a956f2f5498199d3325b6908b406"
    //    can_confirm : false
    //    education_start_time : "2007-9"
    //    education_degree : "3"
    //    }........
    //     ]
    
    
    NSMutableArray * _education;
    NSMutableArray * _work;
}

- (instancetype)initWithUserId:(NSString *)UserId
{
    if (self = [super init]) {
        self.myId = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
        self.stringuserId = UserId;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"个人信息";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.translucent = YES;
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStyleDone target:self action:@selector(testNew)];;
    
    
    if (self.fromFriendList) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteFriend)];
    }
    [self loadData];
    [self getFriends];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}


#pragma mark - 初始化UI
- (void)setupUI {
    
    UITableView *tableview =  ({
        UITableView *v = [[UITableView alloc] init];
        v.backgroundColor = [UIColor whiteColor];
        [v registerNib:[UINib nibWithNibName:@"WQUserProfileTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
        //取消分割线
        
        [v registerClass:[WQUserProfileAddExperienceCell class] forCellReuseIdentifier:addCellId];
        //        v.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-65);
        }];
        v.tableFooterView = [UIView new];
        v.dataSource = self;
        v.delegate = self;
        v.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [v setSeparatorColor:[UIColor colorWithHex:0xefefef]];
        
        v;
    });
    self.tableview = tableview;
    
    //头部试图
    
    _bottomButton = ({
        UIButton * btn = [[UIButton alloc] init];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreenWidth - 30));
            make.height.equalTo(@50);
            make.top.equalTo(_tableview.mas_bottom);
            make.left.equalTo(self.view.mas_left).offset(15);
        }];
        
        [btn setBackgroundColor:[UIColor colorWithHex:0x573084]];
        
        [btn addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn;
        
    });
    
    tableview.tableHeaderView = [[WQUserProfileTableHeaderView alloc] init];
    
    
    [self loadData];
}

#pragma mark - 获取好友
- (void)getFriends {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        EMError *error = nil;
        self.userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        if (!error) {
            
        }
        for (NSInteger i = 0; i < self.userlist.count; i++) {
            if ([self.stringuserId isEqualToString:self.userlist[i]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.bottomButton setTitle:kSendMessageButtonTitle forState:UIControlStateNormal];
                });
            }
        }
    });
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    
    NSMutableArray *items = [NSMutableArray array];
    YYPhotoGroupItem *item =[YYPhotoGroupItem new];
    //    item.thumbView = self.headImage;
    NSString *urlString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",self.imageUrl]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@",url);
    item.largeImageURL = url;
    [items addObject:item];
    
//    YYPhotoBrowseView *groupView = [[YYPhotoBrowseView alloc]initWithGroupItems:items];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 请求数据
- (void)loadData {
    
    NSString *urlString = @"api/user/getbasicinfo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    self.params[@"uid"] = self.stringuserId;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        self.isfriend = [response[@"isfriend"] boolValue];
        _education = response[@"education"];
        _work = response[@"work_experience"];
        
        //        判断该页面的状态确定该页面的 UI
        if (_ismyaccount) {
            
            if (self.userProfileType == UserProfileTypeEdit) {
                
                [_bottomButton setTitle:kPreviewButtonTitle forState:UIControlStateNormal];
            } else {
                
                [_bottomButton setTitle:kModifyButtonTitle forState:UIControlStateNormal];
            }
            
        } else if (self.isfriend) {
            
            [_bottomButton setTitle:kSendMessageButtonTitle forState:UIControlStateNormal];
        } else {
            
            [_bottomButton setTitle:kAddFriendButtonTitle forState:UIControlStateNormal];
        }
        
        self.im_namelogin = response[@"im_namelogin"];
        _userModel = [WQUserProfileModel yy_modelWithJSON:response];
        ((WQUserProfileTableHeaderView *)(_tableview.tableHeaderView)).model = _userModel;
        _tableview.tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        
        if ([response[@"idcard_status"] isEqualToString:@"STATUS_UNVERIFY"]) {
            
            NSArray  *viewArray = [[NSBundle mainBundle]loadNibNamed:@"WQUserProfileTableFooterView" owner:nil options:nil];
            UIView *footer = [viewArray firstObject];
            //加载视图
            footer.frame = CGRectMake(0, 0, kScreenWidth, 60);
            _tableview.tableFooterView = footer;
        }
        
        //        (WQUserProfileTableHeaderView *)(_tableview.tableHeaderView))
        [self reloadData];
    }];
}

- (void)loadList {
    NSString *urlString = @"api/user/getconfirm";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.listParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    self.listParams[@"uid"] = self.stringuserId;
    WQNetworkTools *tools = [WQNetworkTools sharedTools];
    [tools request:WQHttpMethodPost urlString:urlString parameters:_listParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        self.authenticateUserArray = [NSArray yy_modelArrayWithClass:[WQconfirmsModel class] json:response[@"confirms"]];
        NSLog(@"%@",self.authenticateUserArray);
        
    }];
}

+ (void)getUserAccountAndPassword:(NSString *)userId userLogin:(void(^)(void))userLogin {
    WQUserProfileContrlooer *userProfileVC = [self new];
    userProfileVC.stringuserId = userId;
    [userProfileVC loadData];
    [WQDataSource sharedTool].userIsLogin = YES;
    userLogin();
}

#pragma mark - tableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0 || section == 1) {
        return 49;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    UIView * topGray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    topGray.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [view addSubview:topGray];
    
    UIView * leftPurple = [[UIView alloc] initWithFrame:CGRectMake(15, 22, 3, 15)];
    leftPurple.backgroundColor = [UIColor colorWithHex:0x4b0b7f];
    [view addSubview:leftPurple];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 11, kScreenWidth, 38)];
    [view addSubview:textLabel];
    
    textLabel.textColor = [UIColor colorWithHex:0x333333];
    textLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 48.5, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = [UIColor colorWithHex:0xededed];
    
    [view addSubview:bottomLine];
    
    
    view.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        textLabel.text = @"工作经历";
        return view;
    } else if (section == 1) {
        textLabel.text = @"学习经历";
        return view;
    }
    
    return [UIView new];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_ismyaccount) {
        return;
    }
    
    if (!indexPath.section) {
        if (indexPath.row == _userModel.work_experience.count) {
            
            if (![_userModel.idcard_status isEqualToString:@"STATUS_VERIFIED"]) {
                //                认证中
                if ([_userModel.idcard_status isEqualToString:@"STATUS_VERIFING"]) {
                    [WQAlert showAlertWithTitle:nil message:@"您的账户正在审核中,请耐心等待" duration:1.5];
                    return;
                }
                //                还未认证
                if ([_userModel.idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
                    
                    //                        TODO
                    UIAlertController * alert =
                     [UIAlertController alertControllerWithTitle:nil
                                                        message:@"请实名认证后,填写工作经历,获得更高信用"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * confim =
                    [UIAlertAction actionWithTitle:@"去认证"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * _Nonnull action) {
                                               //                        TODO
                                               WQComfimController * vc = [[WQComfimController alloc] init];
                                               vc.phoneNumber = self.userModel.cellphone;
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
            }
            
            WQaddWorkViewController * vc = [[WQaddWorkViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            WQmodifyWorkViewController * vc = [[WQmodifyWorkViewController alloc] initWithType:@"" modelArray:_userModel.work_experience andCurrentIndex:indexPath.row];
            
            vc.work = _work;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
    
    if (indexPath.section == 1) {
        if (indexPath.row == _userModel.education.count) {
            
            if (![_userModel.idcard_status isEqualToString:@"STATUS_VERIFIED"]) {
                
                
                if ([_userModel.idcard_status isEqualToString:@"STATUS_VERIFING"]) {
                    [WQAlert showAlertWithTitle:nil message:@"您的账户正在审核中,请耐心等待" duration:1.5];
                    return;
                }
                
                //                还未认证
                if ([_userModel.idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
                    UIAlertController * alert =
                     [UIAlertController alertControllerWithTitle:nil
                                                        message:@"请实名认证后,填写教育经历,获得更高信用"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * confim = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //                        TODO
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
            }
            
            WQWQaddEducationViewController * vc = [[WQWQaddEducationViewController alloc] init];
            vc.curentEducationExperiences = _userModel.education;
            
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            WQmodifyEducationViewController * vc = [[WQmodifyEducationViewController alloc] initWithType:@"" model:_userModel.education[indexPath.row]];
            vc.modifingIndex = indexPath.row;
            vc.currentEducetionExperience = _userModel.education;
            vc.educetions = _education.mutableCopy;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ((indexPath.section == 0 && indexPath.row == _userModel.work_experience.count)||
        (indexPath.section == 1 && indexPath.row == _userModel.education.count)) {
        return 40;
    }
    
    return 60;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.userProfileType == UserProfileTypeEdit) {
            //当处于编辑模式要多一个添加的 cell
            return _userModel.work_experience.count + 1;
        }
        return _userModel.work_experience.count;
    } else {
        //当处于编辑模式要多一个添加的 cell
        if (self.userProfileType == UserProfileTypeEdit) {
            //当处于编辑模式要多一个添加的 cell
            
            return _userModel.education.count + 1;
        }
        return _userModel.education.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WQUserProfileAddExperienceCell * addCell = [tableView dequeueReusableCellWithIdentifier:addCellId];
    WQUserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    addCell.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.rightArrow.hidden = !_ismyaccount;
    self.cell = cell;
    __weak typeof(self) weakSelf = self;
    //当是本人而且处于编辑模式下,则每个 section里面应在末尾加上一个添加经历的 cell 也就是说可能 cell 的数量会比数据源 model 的数量多一个
    if ((indexPath.section == 0 && indexPath.row < _userModel.work_experience.count)|| (indexPath.section == 1 && indexPath.row < _userModel.education.count)) {
        
        cell.rightArrow.hidden = !(self.userProfileType == UserProfileTypeEdit);
        
        
        [cell setCertificationBtnClikeBlock:^{
            WQUserProfileTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            
            NSString * confirmType ;
            NSString * exp ;
                        
            
            if (indexPath.section == 0) {
                

                self.workType =  cell.profileMode.type;
                confirmType = @"工作";
                exp = cell.profileMode.work_enterprise;
                

            } else {
                self.educationType = cell.userProfileModel.type;
                confirmType = @"学习";
                exp = cell.userProfileModel.education_school;
            }
            
            NSString * name = _userModel.true_name;
            
            
            NSString * message = [NSString stringWithFormat:@"您要用信用分担保为%@认证在%@的%@经历吗?",name,exp,confirmType];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示:" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *urlString = @"api/user/confirm";
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                weakSelf.certificationParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
                weakSelf.certificationParams[@"uid"] = weakSelf.stringuserId;
                if (indexPath.section == 0) {
                    weakSelf.certificationParams[@"type"] = weakSelf.workType;
                }else
                {
                    weakSelf.certificationParams[@"type"] = weakSelf.educationType;
                }
                WQNetworkTools *tools = [WQNetworkTools sharedTools];
                [tools request:WQHttpMethodPost urlString:urlString parameters:self.certificationParams completion:^(id response, NSError *error) {
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
            
            
        }];
        
        if (indexPath.section == 0) {
            
            cell.profileMode = _userModel.work_experience[indexPath.row];
        }else {
            
            cell.userProfileModel = _userModel.education[indexPath.row];
        }
        //        if (indexPath.row) {
        //
        //            cell.topLineView.hidden = YES;
        //        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        
        if (!indexPath.section) {
            
            [addCell.addButton setTitle:@"添加工作经历" forState:UIControlStateNormal];
            addCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return addCell;
        } else {
            
            [addCell.addButton setTitle:@"添加教育经历" forState:UIControlStateNormal];
            addCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return addCell;
        }
    }
}



- (void)bottomButtonClicked:(UIButton *)sender {
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    if ([role_id isEqualToString:@"200"]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请勿进行此操作"
                                                                         message:@"请登陆后重新尝试"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    NSString * title = sender.currentTitle;
    UIViewController * vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    
    if ([title isEqualToString:kPreviewButtonTitle]) {
        
        
        if ([self.userModel.idcard_status isEqualToString:@"STATUS_UNVERIFY"]) {
            UIAlertController * alert =
             [UIAlertController alertControllerWithTitle:nil
                                                message:@"实名认证后可查看预览页面"
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * confim = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                        TODO
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
        
        if ([vc isKindOfClass:[WQUserProfileContrlooer class]]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            WQUserProfileContrlooer * vc = [[WQUserProfileContrlooer alloc] initWithUserId:self.stringuserId];
            vc.ismyaccount = YES;
            vc.userProfileType = UserProfileTypePreview;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    } else if ([title isEqualToString:kModifyButtonTitle]) {
        
        if ([vc isKindOfClass:[WQUserProfileContrlooer class]]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            WQUserProfileContrlooer * vc = [[WQUserProfileContrlooer alloc] initWithUserId:self.stringuserId];
            vc.ismyaccount = YES;
            vc.userProfileType = UserProfileTypeEdit;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if([title isEqualToString:kAddFriendButtonTitle]) {
        
        self.plusFriendsImName = _stringuserId;
        WQaddFriendsController *addFriendsVc = [[WQaddFriendsController alloc]initWithIMId:self.plusFriendsImName];
        addFriendsVc.type = @"添加好友";
        [self.navigationController pushViewController:addFriendsVc animated:YES];
    } else if([title isEqualToString:kSendMessageButtonTitle]) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userName = [userDefaults objectForKey:@"true_name"];
        NSString *userPic = [userDefaults objectForKey:@"pic_truename"];
        
        WQChaViewController *chatController = [[WQChaViewController alloc]
                                               initWithConversationChatter:self.im_namelogin
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
        
    }
}

//刷新数据并为头视图的 头像增加事件

- (void)reloadData {
    [_tableview reloadData];
    WQUserProfileTableHeaderView * tableHeader = (WQUserProfileTableHeaderView *)_tableview.tableHeaderView;
    tableHeader.userHeadImageView.userInteractionEnabled = YES;
    [tableHeader.userHeadImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTaped:)]];
}

- (void)headImageTaped:(UITapGestureRecognizer *)sender {
    UIImageView * imageVIew = (UIImageView * )(sender.view);
    
    if (sender.view) {
        CGRect rect = sender.view.frame;
        CLImageScrollDisplayView *imageShowView = [[CLImageScrollDisplayView alloc] initWithConverFrame:rect index:0 willShowImages:@[imageVIew.image]];
        //        imageShowView.showPageControl = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:imageShowView];
    }
}


- (void)deleteFriend {
    [SVProgressHUD showWithStatus:@"删除中…"];
    
    NSData *arrAydata = [NSJSONSerialization dataWithJSONObject:@[self.stringuserId] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *labelTagString = [[NSString alloc] initWithData:arrAydata encoding:NSUTF8StringEncoding];
    
    NSString *urlString = @"api/friend/remove";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    self.params[@"friends"] = labelTagString;
    
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:_params completion:^(id response, NSError *error) {
        
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

- (void)testNew {
    UIAlertController * alert =
     [UIAlertController alertControllerWithTitle:nil
                                        message:@"请实名认证后,填写教育经历,获得更高信用"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confim = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //                        TODO
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
    
}

#pragma mark - 懒加载
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableArray *)tableViewdetailOrderData {
    if (!_tableViewdetailOrderData) {
        _tableViewdetailOrderData = [[NSMutableArray alloc]init];
    }
    return _tableViewdetailOrderData;
}
- (NSMutableDictionary *)certificationParams {
    if (!_certificationParams) {
        _certificationParams = [[NSMutableDictionary alloc]init];
    }
    return _certificationParams;
}
- (NSMutableDictionary *)listParams {
    if (!_listParams) {
        _listParams = [[NSMutableDictionary alloc]init];
    }
    return _listParams;
}
- (NSArray *)authenticateUserArray {
    if (!_authenticateUserArray) {
        _authenticateUserArray = [[NSArray alloc]init];
    }
    return _authenticateUserArray;
}

- (NSArray *)userlist {
    if (!_userlist) {
        _userlist = [[NSArray alloc] init];
    }
    return _userlist;
}

@end
