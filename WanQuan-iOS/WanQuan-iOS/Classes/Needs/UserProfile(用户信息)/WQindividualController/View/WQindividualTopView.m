//
//  WQindividualTopView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQindividualTopView.h"
#import "WQindividualTopTableViewCell.h"
#import "WQindividualTopTableViewTwoCell.h"
#import "WQUserProfileModel.h"
#import "YYWebImage.h"
#import "YYPhotoBrowseView.h"

static NSString *cellid = @"cellid";
static NSString *cellidTwo = @"cellidTwo";

@interface WQindividualTopView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *dividerView;
//@property (nonatomic, strong) NSArray *titleLabelArray;
//@property (nonatomic, strong) NSArray *titleLabelTwoArrray;

@end

@implementation WQindividualTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma make - 初始化UI
- (void)setupUI
{
//    [self addSubview:self.topView];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.userName];
    [self addSubview:self.dividerView];
//    [self addSubview:self.rightTablebView];
//    [self addSubview:self.documentsTableView];
    
//    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.top.equalTo(self);
//        make.height.offset(20);
//    }];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(75);
        make.top.left.equalTo(self).offset(15);
    }];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_top).offset(5);
        make.left.equalTo(_avatarImageView.mas_right).offset(15);
    }];
    [_dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.right.equalTo(self);
        make.top.equalTo(_avatarImageView.mas_bottom).offset(15);
    }];
//    [_rightTablebView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self);
//        make.top.equalTo(_topView.mas_bottom);
//        make.left.equalTo(_avatarImageView.mas_right).offset(16);
//        make.height.offset(ghCellHeight * 2);
//    }];
//    [_documentsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_rightTablebView.mas_bottom);
//        make.left.right.equalTo(self);
//        make.height.offset(ghCellHeight);
//    }];
}

//- (void)setModel:(WQUserProfileModel *)model
//{
//    _model = model;
//    [_rightTablebView reloadData];
//    [_documentsTableView reloadData];
//}
//
//#pragma make - TableViewDataSource
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0) {
//        if (indexPath.row == 1) {
//            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//            [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0xa550d6]];
//            [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"\n当前版本不支持更换头像\n"];
//            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
//            
//             #pragma make - 更换头像
//            //if (self.pickerClikeBlock) {
//              //  self.pickerClikeBlock();
//            //}
//        }
//    }
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView == _rightTablebView) {
//        return self.titleLabelArray.count;
//    }else{
//        return self.titleLabelTwoArrray.count;
//    }
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == _rightTablebView) {
//        WQindividualTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
//        cell.Labeltitle.text = self.titleLabelArray[indexPath.row];
//        cell.nameLabel.text = self.model.true_name;
//        if (indexPath.row == 1) {
//            cell.nameLabel.hidden = YES;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        return cell;
//    }else
//    {
//        WQindividualTopTableViewTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidTwo forIndexPath:indexPath];
//        cell.titleLabel.text = self.titleLabelTwoArrray[indexPath.row];
//        cell.documentsLabel.text = self.model.idcard;
//        if (indexPath.row == 1) {
//            cell.documentsLabel.hidden = YES;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        return cell;
//    }
//}

// 编辑图片
- (void)handleTapGes:(UITapGestureRecognizer *)tap{
    
    NSInteger selectIndex = [(UIImageView *)tap.view tag];
    
    NSLog(@"点击了%ld",selectIndex);
    NSMutableArray *items = [NSMutableArray array];
    
    YYPhotoGroupItem *item =[YYPhotoGroupItem new];
    item.thumbView = _avatarImageView;
    NSString *urlString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",self.touxiangImageUrl]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@",url);
    item.largeImageURL = url;
    [items addObject:item];
    
    YYPhotoBrowseView *groupView = [[YYPhotoBrowseView alloc]initWithGroupItems:items];
    [groupView presentFromImageView:_avatarImageView toContainer:self.viewController.navigationController.view animated:YES completion:nil];
    self.viewController.tabBarController.tabBar.hidden = YES;
}

#pragma make - 懒加载
- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushlistview_up"] highlightedImage:0];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        [_avatarImageView addGestureRecognizer:tap];
    }
    return _avatarImageView;
}
- (UILabel *)userName
{
    if (!_userName) {
        _userName = [UILabel labelWithText:@"用户名" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:18];
    }
    return _userName;
}

- (UIView *)dividerView
{
    if (!_dividerView) {
        _dividerView = [[UIView alloc] init];
        _dividerView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    }
    return _dividerView;
}
//- (UITableView *)rightTablebView
//{
//    if (!_rightTablebView) {
//        _rightTablebView = [[UITableView alloc]init];
//        [_rightTablebView registerClass:[WQindividualTopTableViewCell class] forCellReuseIdentifier:cellid];
//        _rightTablebView.dataSource = self;
//        _rightTablebView.delegate = self;
//        _rightTablebView.scrollEnabled =NO;
//    }
//    return _rightTablebView;
//}

//- (UIView *)topView
//{
//    if (!_topView) {
//        _topView = [[UIView alloc]init];
//        _topView.backgroundColor = [UIColor colorWithHex:0Xefeff4];
//    }
//    return _topView;
//}
//- (NSArray *)titleLabelArray
//{
//    if (!_titleLabelArray) {
//        _titleLabelArray = @[@"我的名字",@"设置头像"];
//    }
//    return _titleLabelArray;
//}
//- (NSArray *)titleLabelTwoArrray
//{
//    if (!_titleLabelTwoArrray) {
//        _titleLabelTwoArrray = @[@"证件号码"];
//    }
//    return _titleLabelTwoArrray;
//}
//- (UITableView *)documentsTableView
//{
//    if (!_documentsTableView) {
//        _documentsTableView = [[UITableView alloc]init];
//        _documentsTableView.dataSource = self;
//        _documentsTableView.delegate = self;
//        [_documentsTableView registerClass:[WQindividualTopTableViewTwoCell class] forCellReuseIdentifier:cellidTwo];
//        _documentsTableView.scrollEnabled =NO;
//    }
//    return _documentsTableView;
//}

#pragma mark - 两秒后移除提示框
- (void)delayMethod
{
    //两秒后移除提示框
    [SVProgressHUD dismiss];
}

@end
