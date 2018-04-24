//
//  WQCommentDetailInfoCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQCommentDetailInfoCell.h"
#import "WQUserProfileController.h"
#import "WQPhotoBrowser.h"
#import "NSDate+Category.h"
@interface WQCommentDetailInfoCell ()<MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBottomSpace;
@property (weak, nonatomic) IBOutlet UIButton *commentDeleteBtn;

@end



@implementation WQCommentDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatar.layer.cornerRadius = 20;
    _avatar.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
    [_commentDeleteBtn addTarget:self action:@selector(commentDelete) forControlEvents:UIControlEventTouchUpInside];
}





- (IBAction)feedBackOnClick:(id)sender {
    
//    if (self.viewController.navigationController) {
//        
//        [self.viewController.navigationController popViewControllerAnimated:YES];\
    
    
    
    if (self.delegate) {
        [self.delegate WQCommentDetailInfoCellShowDetail:self.model];
    }
    
}


- (void)setModel:(WQCommentAndReplyModel *)model {
    _model = model;
    [_avatar yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] options:YYWebImageOptionProgressive];
    _commentDeleteBtn.hidden = !self.model.canDelete;
    NSString * time = [NSDate WQDescriptionBeforWithPastSecond:model.past_second];
    _postTimeLabel.text = time;
    _userNameLabel.text = model.user_name?:@"用户名";
    _commentLabel.text = model.content;

    if (!model.content.length) {
        [_commentLabel sizeToFit];
    }
    
    if (model.pic.count) {
        
        _commentImageView = [[UIImageView alloc] init];
        CGFloat picWidth = 0;
        CGFloat picHeight = 0;
        
        [self.contentView addSubview:_commentImageView];
        //        {
        //            fileID = c47573e8fc804e97a13fcf4cf9660f73;
        //            height = 1104;
        //            width = 828;
        //        }
        NSDictionary * picInfo = model.pic_widh_width_height[0];
        
        CGFloat width = [picInfo[@"width"] doubleValue];
        CGFloat height = [picInfo[@"height"] doubleValue];
        
        CGFloat factor = width / height;
        
        
        
        
        CGFloat minFactor = 0.75;
        CGFloat macFactor = 1.33;
        CGFloat maxLengthOfSide = 200;
        CGFloat minLengthOfSide = 150;
        
        if (factor < minFactor) {
            picHeight = maxLengthOfSide;
            picWidth = minLengthOfSide;
        } else if (factor > macFactor) {
            picWidth = minLengthOfSide;
            picHeight = maxLengthOfSide;
        } else {
            picHeight = maxLengthOfSide;
            picWidth = maxLengthOfSide;
        }
        
        _imageHeight = picHeight;

        
        CGSize size = [_commentLabel sizeThatFits:CGSizeMake(kScreenWidth - 60 - 10, MAXFLOAT)];

//        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_postTimeLabel.mas_bottom).offset(10);
//            make.left.equalTo(_postTimeLabel);
//            make.right.equalTo(self.contentView).offset(-15);
//        }];
        
        _commentLabel.frame = CGRectMake(_commentLabel.x, _commentLabel.y, size.width, size.height);
        
        [_commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentLabel.mas_bottom).offset(model.content.length?10:0);
            make.width.equalTo(@(picWidth));
            make.height.equalTo(@(picHeight));
            make.left.equalTo(_commentLabel);
//            make.bottom.equalTo(self.contentView).offset(-80);
        }];
        
        [_feedBackButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_commentLabel);
            make.top.equalTo(_commentImageView.mas_bottom).offset(10);
        }];
        
        [_commentImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_LARGE_URLSTRING(model.pic[0])] options:YYWebImageOptionProgressive];
        _commentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _commentImageView.userInteractionEnabled = YES;
        _commentImageView.clipsToBounds = YES;
        [_commentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPic)]];
        
    }
//    _commentDeleteBtn.hidden = model.isowner;
//    _commentLabel.frame

    
}
//- (CGFloat)heightWithModel:(WQCommentAndReplyModel *)model {
//    
//    CGFloat ret = 160;
//    
//    if (model.content.length == 0) {
//        _commentLabel.frame = CGRectMake(_commentLabel.x, _commentLabel.y, 0, 0);
//        ret -= 21 + 10;
//    }
//    
//    CGFloat imageSpace = model.content.length == 0 ? 0 : 10;
//    
//    if (model.pic.count) {
//        NSDictionary * picInfo = model.pic_widh_width_height[0];
//        
//        CGFloat width = [picInfo[@"width"] doubleValue];
//        CGFloat height = [picInfo[@"height"] doubleValue];
//        CGFloat factor = width / height;
//        CGFloat minFactor = 0.75;
//        CGFloat macFactor = 1.33;
//        CGFloat maxLengthOfSide = 200;
//        CGFloat minLengthOfSide = 150;
//        CGFloat picWidth = 0;
//        CGFloat picHeight = 0;
//        
//        if (factor < minFactor) {
//            picHeight = maxLengthOfSide;
//            picWidth = minLengthOfSide;
//        } else if (factor > macFactor) {
//            picWidth = minLengthOfSide;
//            picHeight = maxLengthOfSide;
//        } else {
//            picHeight = maxLengthOfSide;
//            picWidth = maxLengthOfSide;
//        }
//
//    }
//
//    
//    
//    
//}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)onTap {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    __weak typeof(self) weakSelf = self;
    if ([role_id isEqualToString:@"200"]) {
        //游客登录
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请注册/登录后查看更多" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return ;
    }
    

    
    if (![WQDataSource sharedTool].verified) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"实名认证后可查看用户信息"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                                                      [self.viewController.navigationController pushViewController:vc animated:YES];
                                                                  }];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    // 是当前账户
    if ([self.model.user_id isEqualToString:im_namelogin]) {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:im_namelogin];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        WQUserProfileController *vc = [[WQUserProfileController alloc]initWithUserId:self.model.user_id];
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }
}


- (void)showPic {
    WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
    browser .currentPhotoIndex = 0;
    browser.alwaysShowControls = NO;
    
    browser.displayActionButton = NO;
    
    browser.shouldTapBack = YES;
    
    browser.shouldHideNavBar = YES;
    
    [self.viewController.navigationController pushViewController:browser animated:YES];
    
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSURL * url = [NSURL URLWithString:WEB_IMAGE_URLSTRING(_model.pic[0])];
    MWPhoto * photo = [MWPhoto photoWithURL:url];
    
    return photo;
}

- (void)commentDelete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(WQCommentDetailInfoCellDeleteComment:)]) {
        [self.delegate WQCommentDetailInfoCellDeleteComment:self.model];
    }
}

@end
