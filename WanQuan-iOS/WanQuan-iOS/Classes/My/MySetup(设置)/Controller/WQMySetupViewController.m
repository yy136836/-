//
//  WQMySetupViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQMySetupViewController.h"
#import "WQMySetupTableViewCell.h"
#import "WQMySetupModel.h"
#import "WQLogInController.h"
#import "WQfeedbackViewController.h"
#import "WQforgetPasswordViewController.h"
#import "WQhelpViewController.h"
#import "WQChaViewController.h"
#import "WQLogInController.h"
#import "WQMySetupTableViewCacheCell.h"

static NSString *cellid = @"cellid";
static NSString *cacheCellid = @"WQMySetupTableViewCacheCell";

typedef void(^cleanCacheBlock)();

@interface WQMySetupViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *mineOptionData;
@property (nonatomic, strong) UIButton *exitBtn;
@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation WQMySetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.mineOptionData = [self loadMineOptionData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x000000]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wanquandingbulan"] forBarMetrics:UIBarMetricsDefault];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

    
}

#pragma make - 初始化UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.exitBtn];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
        make.height.offset(ghCellHeight * 8);
    }];
    [_exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.height.offset(ghCellHeight);
        make.right.equalTo(self.view).offset(-16);
        make.bottom.equalTo(self.view).offset(-16);
    }];
}

#pragma make - 监听事件
+ (void)exitBtnClike {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"退出中…"];
    NSString *urlString = @"api/user/logout";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * secreteKey = [userDefaults objectForKey:@"secretkey"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (secreteKey.length) {
        param[@"secretkey"] = secreteKey;
    }
    
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:param completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
//            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
//        [[EMClient sharedClient] logout:YES];
        
        [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
            
        }];
        
        WQLogInController *vc = [WQLogInController new];
        NSString* appDomain = [[NSBundle mainBundle]bundleIdentifier];
        [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
        
        NSFileManager *fileManager = [NSFileManager  defaultManager];
        if ([fileManager removeItemAtPath:[WQSingleton sharedManager].archivePath error:nil]) {
            [WQDataSource sharedTool].isHiddenVisitorsToLoginPopupWindowView = NO;
            [WQDataSource sharedTool].secretkey = nil;
            [WQDataSource sharedTool].loginStatus = nil;
            [SVProgressHUD dismissWithDelay:0.1];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        }
    }];
}

#pragma make - 解析数据
- (NSArray*)loadMineOptionData {
    return [NSArray objectListWithPlistName:@"WQMySetup.plist" clsName:@"WQMySetupModel"];
}

#pragma make - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return self.mineOptionData.count;
    } else {
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            WQfeedbackViewController *vc = [WQfeedbackViewController new];
            vc.feedbackType = TYPE_ADVICE;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 0) {
            WQforgetPasswordViewController *vc = [[WQforgetPasswordViewController alloc]initWithBarBtnhind:loginBarBtnNOhide];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2) {
            WQhelpViewController *vc = [[WQhelpViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        [sheet showInView:self.view];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WQMySetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
        cell.model = self.mineOptionData[indexPath.row];
        
        // 第一组的最后一行取消分割线
        if (indexPath.row == 1) {
            cell.bootmLineView.hidden = YES;
        }
        
        return cell;
    }else {
        WQMySetupTableViewCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:cacheCellid forIndexPath:indexPath];
        cell.contLabel.text = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath]];
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        
        return view;
    }else {
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return ghDistanceershi;
    }else {
        return 0;
    }
}

#pragma mark -- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"正在清除中..."];
        [self cleanCache:^{
            [self.tableView reloadData];
            [SVProgressHUD dismissWithDelay:0.3];
        }];
    }
}

- (void)cleanCache:(cleanCacheBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //文件路径
        NSString *directoryPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
        
        for (NSString *subPath in subpaths) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        
        // 获取缓存大小
//        cache.memoryCache.totalCost;
//        cache.memoryCache.totalCount;
//        cache.diskCache.totalCost;
//        cache.diskCache.totalCount;
        
        // 清空缓存
        [cache.memoryCache removeAllObjects];
        [cache.diskCache removeAllObjects];
        
        // 清空磁盘缓存，带进度回调
        [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
            // progress
        } endBlock:^(BOOL error) {
            // end
            //返回主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }];
        
        
        
        
        
        

    });
    
}

// 计算单个文件大小
- (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    
    return 0 ;
}

- (CGFloat)folderSizeAtPath {
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSFileManager * manager = [NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize / ( 1024.0 * 1024.0 );
}

#pragma make - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"WQMySetupTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
        [_tableView registerClass:[WQMySetupTableViewCacheCell class] forCellReuseIdentifier:cacheCellid];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc]init];
        [_exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _exitBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
        _exitBtn.layer.cornerRadius = 5;
        _exitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_exitBtn addTarget:[WQMySetupViewController class] action:@selector(exitBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
