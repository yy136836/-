//
//  WQTheArbitrationViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/3/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTheArbitrationViewController.h"
#import "WQTheArbitrationView.h"

#define WAITING_FOR_THE_SIGNAL dispatch_semaphore_wait

@interface WQTheArbitrationViewController ()

@property (nonatomic, strong) NSMutableDictionary *applyForArbitrationParams;
@property (nonatomic, strong) WQTheArbitrationView *theArbitrationView;
@property (nonatomic, copy) NSString *nbid;

@end

@implementation WQTheArbitrationViewController

- (instancetype)initWithNbid:(NSString *)nbid {
    if (self = [super init]) {
        self.nbid = nbid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 初始化UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"提交申述";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnClike)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [rightBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    WQTheArbitrationView *theArbitrationView = [[WQTheArbitrationView alloc] init];
    self.theArbitrationView = theArbitrationView;
    [self.view addSubview:theArbitrationView];
    [theArbitrationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 提交审核
- (void)submitBtnClike {
    if (!_theArbitrationView.textView.text.length) {
        [WQAlert showAlertWithTitle:nil message:@"请输入申请仲裁的原因" duration:1.3];
        return;
    }
    NSData *data = UIImageJPEGRepresentation(self.theArbitrationView.imageView.image,0.7);
    NSMutableArray *picArray = [NSMutableArray array];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"图片上传中…"];
    dispatch_group_t group = dispatch_group_create();
    // 设置一个异步线程组
    dispatch_group_async(group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
        // 红灯
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSString *urlString = @"file/upload";
        [[WQNetworkTools sharedTools] POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:data name:@"file" fileName:@"imageView" mimeType:@"application/octet-stream"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            NSLog(@"success : %@", responseObject);
            
            BOOL successbool = [responseObject[@"success"] boolValue];
            if (successbool) {
                [picArray addObject:responseObject[@"fileID"]];
                [SVProgressHUD dismiss];
                // 绿灯
                dispatch_semaphore_signal(sema);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error : %@", error);
            [SVProgressHUD dismiss];
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"上传图片失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }];
        // 绿灯
        WAITING_FOR_THE_SIGNAL(sema, DISPATCH_TIME_FOREVER);
        
        NSString *requestUrlString = @"api/need/changebiddedneedworkstatus";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.applyForArbitrationParams[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
        _applyForArbitrationParams[@"nbid"] = self.nbid;
        _applyForArbitrationParams[@"work_status"] = @"WORK_STATUS_ARBIRATION";
        _applyForArbitrationParams[@"arbitration_pic"] = picArray.count >= 1 ? [self arrayToString:picArray] : @"[\n\n]";
        _applyForArbitrationParams[@"arbitration_text"] = self.theArbitrationView.textView.text;
        [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:requestUrlString parameters:_applyForArbitrationParams completion:^(id response, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            if ([response isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            }
            NSLog(@"%@",response);
            if ([response[@"success"] boolValue]) {
//                [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
//                [SVProgressHUD setForegroundColor:[UIColor colorWithHex:0xa550d6]];
                [SVProgressHUD showInfoWithStatus:@"已提交仲裁"];
                if ([self respondsToSelector:@selector(wqSubmittedToArbitrationForSuccess:)]) {
                    [self.delegate wqSubmittedToArbitrationForSuccess:self];
                }
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//                [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
//                [SVProgressHUD setForegroundColor:[UIColor colorWithHex:0xa550d6]];
                [SVProgressHUD showErrorWithStatus:@"已经提交给平台审核不可重复提交"];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            }
        }];
        
    });
    
}

//把NSArray转为一个json字符串
- (NSString *)arrayToString:(NSArray *)array {
    
    NSString *str = @"['";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            str = [str stringByAppendingString:@"','"];
        }
        str = [str stringByAppendingString:array[i]];
    }
    str = [str stringByAppendingString:@"']"];
    
    return str;
}

#pragma mark - 两秒后移除提示框
- (void)delayMethod {
    //两秒后移除提示框
    [SVProgressHUD dismiss];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)applyForArbitrationParams {
    if (!_applyForArbitrationParams) {
        _applyForArbitrationParams = [[NSMutableDictionary alloc] init];
    }
    return _applyForArbitrationParams;
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
