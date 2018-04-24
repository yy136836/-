//
//  WQAddressBookFriendsViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "WQAddressBookFriendsViewController.h"
#import "WQPhoneBookFriendsViewController.h"

@interface WQAddressBookFriendsViewController () <UIGestureRecognizerDelegate>

@end

@implementation WQAddressBookFriendsViewController {
    // 获取通讯录电话
    NSMutableArray *phoneBookArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"quxiao"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    
    phoneBookArray = [NSMutableArray array];
}

#pragma mark -- 左上角x的响应事件
- (void)cancelBtnClick {
    WQTabBarController *vc = [WQTabBarController new];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

#pragma mark -- 初始化View
- (void)setUpView {
    UILabel *textLabel = [UILabel labelWithText:@"开启通讯录:寻找好友" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:21];
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kScaleX(85));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *textTwoLabel = [UILabel labelWithText:@"看看哪些通讯录好友已加入万圈" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:16];
    [self.view addSubview:textTwoLabel];
    [textTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    // 雷达
    UIImageView *radarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leida"]];
    [self.view addSubview:radarImageView];
    [radarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(336), kScaleX(336)));
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(textTwoLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    UILabel *labela = [UILabel labelWithText:@"万圈访问通讯录仅用于为您推荐认" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:15];
    [self.view addSubview:labela];
    [labela mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(radarImageView.mas_bottom).offset(kScaleX(ghStatusCellMargin));
    }];
    
    UILabel *label = [UILabel labelWithText:@"识的好友，不会泄露您的信息" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:15];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(labela.mas_bottom).offset(kScaleX(5));
    }];
    
    // 继续的按钮
    UIButton *continueBtn = [[UIButton alloc] init];
    continueBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    continueBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    continueBtn.layer.cornerRadius = 5;
    continueBtn.layer.masksToBounds = YES;
    [continueBtn setTitle:@"继续" forState:UIControlStateNormal];
    [continueBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [continueBtn addTarget:self action:@selector(continueBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueBtn];
    [continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(240), kScaleX(45)));
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
    }];
    
    // 以后再说的按钮
    UIButton *afterBtn = [[UIButton alloc] init];
    afterBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [afterBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [afterBtn setTitle:@"以后再说" forState:UIControlStateNormal];
    [afterBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:afterBtn];
    [afterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(kScaleX(-ghSpacingOfshiwu));
    }];
}

#pragma mark -- 继续按钮的响应事件
- (void)continueBtnClick {
    [self bookAccessPermissions];
}

- (void)bookAccessPermissions {
    //获取通讯录的授权信息
    [[WQAuthorityManager manger] showAlertForAdressBookAuthority];
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
            //未授权, 请求授权
        case kABAuthorizationStatusNotDetermined: {
            
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, NULL),
                                                     ^(bool granted, CFErrorRef error) {
                                                         if (granted) {
                                                             NSLog(@"授权成功");
                                                             //获取联系人信息
                                                             [self onGetAddressBookInfo];
                                                         } else {
                                                             NSLog(@"授权失败");
                                                         }
                                                     });
            
            break;
        }
            //已授权
        case kABAuthorizationStatusAuthorized: {
            
            //获取联系人信息
            [self onGetAddressBookInfo];
            NSLog(@"已授权");
            break;
        }
            //其他情况, 给用户提示
        case kABAuthorizationStatusRestricted:
        case kABAuthorizationStatusDenied:{
            [[WQAuthorityManager manger] showAlertForAdressBookAuthority];
            break;
        }
        default:{
            break;
        }
    }
}

/**
 获取到通讯录授权后后处理获得的数据
 */
- (void)onGetAddressBookInfo {
    //获取通讯录对象
    ABAddressBookRef addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
    //获取通讯录内容
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressbook);
    //获取通讯录的个数
    CFIndex count = CFArrayGetCount(peopleArray);
    
    //遍历通讯录内容
    for (CFIndex i = 0; i < count; i++) {
        
        NSMutableDictionary *contactDict = [NSMutableDictionary dictionary];
        
        //获取单个通讯录内容 --> 获取单个联系人的信息
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        //根据Person获取姓名和电话 --> 代码可以参考有界面通讯录的写法
        //获取姓名
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        //NSLog(@"firstName: %@, lastName:%@", firstName, lastName);
        
        NSString *contactName = [lastName ?:@"" stringByAppendingString:firstName ?:@""];
        
        //获取电话
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phone);
        if (phoneCount > 0) {
            contactDict[@"name"] = contactName;
            
            NSString * num  = (NSString *) CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, 0));
            
            num = [[num componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
            
            
            contactDict[@"phone"] = num;
            
            
            
            [phoneBookArray addObject:contactDict];
        }
        //释放CF对象
        CFRelease(phone);
    }
    //释放CF对象
    CFRelease(peopleArray);
    CFRelease(addressbook);
    
    [self uploadContact];
}

#pragma mark - 上传通讯录
- (void)uploadContact {
    NSString *urlString = @"api/contact/add";
    NSMutableDictionary *uploadContactParams = [NSMutableDictionary dictionary];
    uploadContactParams[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    NSData *arrAydata = [NSJSONSerialization dataWithJSONObject:phoneBookArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:arrAydata encoding:NSUTF8StringEncoding];
    uploadContactParams[@"contacts"] = idcardStr;
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:uploadContactParams completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        if ([response[@"success"] boolValue]) {
            //获取通讯录上传服务器成功
            WQPhoneBookFriendsViewController *vc = [[WQPhoneBookFriendsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
