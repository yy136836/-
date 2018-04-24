//
//  WQPeopleWhoAreInterestedInTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPeopleWhoAreInterestedInTableViewCell.h"
#import "WQPeopleWhoAreInterestedInCollectionViewCell.h"
#import "WQPeopleWhoAreInterestedInFlowLayout.h"
#import "WQPeopleWhoAreInterestedInModel.h"
#import "WQUserProfileController.h"

static NSString *identifiercell = @"identifiercell";

@interface WQPeopleWhoAreInterestedInTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource,WQPeopleWhoAreInterestedInCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) WQPeopleWhoAreInterestedInFlowLayout *layout;

@end

@implementation WQPeopleWhoAreInterestedInTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        // 栅格化  屏幕滚动时绘制成一张图像
        self.layer.shouldRasterize = YES;
        // 指定分辨率  默认分别率 * 1
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark -- 初始化contentView
- (void)setupContentView {
    UILabel *textLabel = [UILabel labelWithText:@"可能感兴趣的人" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    [self.contentView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ghSpacingOfshiwu);
        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
    }];
    

    WQPeopleWhoAreInterestedInFlowLayout *layOut = [[WQPeopleWhoAreInterestedInFlowLayout alloc] init];
    //UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    // 设置item的大小
    layOut.itemSize = CGSizeMake(kScaleY(270), kScaleX(120));
//    layOut.minimumInteritemSpacing = -30;
//    layOut.minimumLineSpacing = 100;
    
    
    // 设置布局方式
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layOut.minimumInteritemSpacing = 100;
    layOut.minimumLineSpacing = -15;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
    self.collectionView = collectionView;
    [collectionView registerClass:[WQPeopleWhoAreInterestedInCollectionViewCell class] forCellWithReuseIdentifier:identifiercell];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.scrollEnabled = YES;
    collectionView.pagingEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
        make.left.right.equalTo(self);
        make.center.equalTo(self);
    }];
//    _collectionView.contentInset = UIEdgeInsetsMake(30,
//                                                    1.0 * kScreenWidth / 2 -  1.0 * kScaleX(270 / 2),
//                                                    0,
//                                                    1.0 * kScreenWidth / 2 -  1.0 * kScaleX(270 / 2));
    _collectionView.contentInset = UIEdgeInsetsMake(30,
                                                    15,
                                                    15,
                                                    15);
    collectionView.clipsToBounds = NO;
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(10);
        make.left.right.bottom.equalTo(self);
    }];
}

#pragma mark -- WQPeopleWhoAreInterestedInCollectionViewCellDelegate
- (void)wqGuanzhuBtnClick:(WQPeopleWhoAreInterestedInCollectionViewCell *)cell {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        if ([self.delegate respondsToSelector:@selector(wqGuanzhuBtnTouristsClick:)]) {
            [self.delegate wqGuanzhuBtnTouristsClick:self];
        }
        return;
    }
    
    // 关注的响应事件
    // 已关注
    if (cell.model.followed) {
        // 取消关注
        NSString *urlString = @"api/user/follow/deletefollow";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"uid"] = cell.model.user_id;
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
                cell.model.followed = NO;
                cell.guanzhuBtn.backgroundColor = [UIColor whiteColor];
                [cell.guanzhuBtn setTitleColor:[UIColor colorWithHex:0x9767d0] forState:UIControlStateNormal];
                [cell.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
            }
        }];
    }else {
        NSString *urlString = @"api/user/follow/createfollow";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
        params[@"uid"] = cell.model.user_id;
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
                cell.model.followed = YES;
                cell.guanzhuBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
                [cell.guanzhuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }
        }];
    }
}

#pragma mark -- UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:@"role_id"] isEqualToString:@"200"]) {
        if ([self.delegate respondsToSelector:@selector(wqHeadPortraitClick:)]) {
            [self.delegate wqHeadPortraitClick:self];
        }
        return;
    }
    
    WQPeopleWhoAreInterestedInModel *model = self.dataArray[indexPath.row];
    // 头像的响应事件
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];

    if ([model.user_id isEqualToString:im_namelogin]) {
        // 是自己
        WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:model.user_id];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        // 不是自己
        WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:model.user_id];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQPeopleWhoAreInterestedInCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifiercell forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = _dataArray[indexPath.item];
    
    return cell;
}

@end
