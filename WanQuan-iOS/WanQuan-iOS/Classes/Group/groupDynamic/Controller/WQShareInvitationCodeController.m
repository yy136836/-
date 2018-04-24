//
//  WQShareInvitationCodeController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQShareInvitationCodeController.h"
#import "UMSocialUIManager.h"
@interface WQShareInvitationCodeController ()
@property (weak, nonatomic) IBOutlet UILabel *labGroupName;
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteCodeButton;

@end

@implementation WQShareInvitationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _shareButton.layer.cornerRadius = 5;
    _shareButton.layer.masksToBounds = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [_bg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgOnTouch)]];
    [_inviteCodeButton setTitle:self.baseinfo.invite_code forState:UIControlStateNormal];
    _labGroupName.text = _baseinfo.name;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
}

- (IBAction)copyCode:(id)sender {
    UIButton * btn = sender;
    
    UIPasteboard * board = [UIPasteboard generalPasteboard];
    NSString * title = btn.currentTitle;;
    if (title.length) {
        board.string = title;
    } else {
        [SVProgressHUD showErrorWithStatus:@"没有发现邀请码!!"];
        [SVProgressHUD dismissWithDelay:1.3];
        return;
    }
    
    UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"" message:@"已复制" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:vc animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc dismissViewControllerAnimated:YES completion:nil];
    });
    
}

- (IBAction)shareToThird:(id)sender {
    [self inviteCodeShareToThird];
}


- (void)inviteCodeShareToThird {
    
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
    [WQSingleton sharedManager].platname = @"NORMAL";
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
            pasteboard.string = [NSString stringWithFormat:@"http://wanquan.belightinnovation.com/front/share/groupinvite?gid=%@",_baseinfo.gid];
            [UIAlertController wqAlertWithController:self addTitle:nil andMessage:@"已复制至剪切板" andAnimated:YES andTime:1];
        }
    }];
    //    }];
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
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
// TODO: 还未实现分享的实体!!!!!!!!
//    NSString *moneySplicecontent = [NSString stringWithFormat:@"%@",self.groupIntroduce];
//创建网页内容对象
    NSString *thumbURL = WEB_IMAGE_TINY_URLSTRING(_baseinfo.pic);
    NSString *titleString = [NSString stringWithFormat:@"入圈邀请 | %@",_baseinfo.name];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString descr:@"我正在清华校友的实名认证校友圈。在这里可以与同学交流，结识更多校友，快来加入吧！" thumImage:thumbURL];
//
//    //设置网页地址
//    //    NSString *shardString = self;
    // TODO: 记得替换网址
    shareObject.webpageUrl = [NSString stringWithFormat:@"http://wanquan.belightinnovation.com/front/share/groupinvite?gid=%@",_baseinfo.gid];
    
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
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
                
                [self dismissViewControllerAnimated:YES completion:nil];
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


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 盖住点击退出的事件
 */
- (void)bgOnTouch {
    
}

@end
