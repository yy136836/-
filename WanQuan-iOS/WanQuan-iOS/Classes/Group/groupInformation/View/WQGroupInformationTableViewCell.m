//
//  WQGroupInformationTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupInformationTableViewCell.h"
#import "WQGroupHeadCollectionViewCell.h"
#import "WQGroupMembersController.h"
#import "WQGroupIntroduceViewController.h"
#import "WQNewMembersView.h"
#import "WQGetgroupInfoModel.h"
#import "WQGroupMemberModel.h"
#import "WQTransferGroupManager.h"
#import "WQTransferGroupManagerViewController.h"
#import "WQSetAdministratorView.h"
#import "WQSetAdministratorViewController.h"
#import "WQPrivateCircleView.h"

static NSString *identifier = @"identifier";

@interface WQGroupInformationTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource,WQSetAdministratorViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
// 创建时间
@property (nonatomic, strong) UILabel *timeLabel;
//@property (nonatomic, strong) WQNewMembersView *wqNewMembersView;
// 创建时间标签
@property (nonatomic, strong) UILabel *createTimeLabel;
// 头像下的分隔线
@property (nonatomic, strong) UIView *headBottomDividingLine;
@property (nonatomic, strong) NSArray *tableViewdetailOrderData;
// 群成员总数
@property (nonatomic, strong) UILabel *member_countLabel;
// 群介绍后的三角
@property (nonatomic, strong) UIImageView *triangleImage;
// 群人员后的三角
@property (nonatomic, strong) UIImageView *triangletwoImage;
// 点击群介绍的按钮
@property (nonatomic, strong) UIButton *introduceBtn;
// 点击头像那一行的btn
@property (nonatomic, strong) UIButton *headPortraitBtn;
// 群成员人数
@property (nonatomic, strong) UILabel *numberLabel;
// 删除并退出的按钮
//@property (nonatomic, strong) UIButton *deleteBtn;
// 底部的线
@property (nonatomic, strong) UIView *bottomLineView;
// 圈主权限转让
@property (nonatomic, strong) WQTransferGroupManager *transferGroupManagerView;
// 设置管理员的view
@property (nonatomic, strong) WQSetAdministratorView *setAdministratorView;

/**
 私密圈的view
 */
@property (nonatomic, strong) WQPrivateCircleView *privateCircleView;

@end

@implementation WQGroupInformationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.tableViewdetailOrderData = [[NSArray alloc] init];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    // 群介绍的标签
    UILabel *groupToIntroduce = [UILabel labelWithText:@"圈介绍" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    groupToIntroduce.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [self.contentView addSubview:groupToIntroduce];
    [groupToIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(ghDistanceershi);
        make.left.equalTo(self.contentView.mas_left).offset(ghSpacingOfshiwu);
    }];
    
    // 群介绍内容
    UILabel *contentLabel = [UILabel labelWithText:@"我们是一群超级帅的人我们是一群超级帅的人我们是一群超级帅的人" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:15];
    self.contentLabel = contentLabel;
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupToIntroduce.mas_bottom).offset(ghStatusCellMargin);
        make.left.equalTo(groupToIntroduce.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-ghStatusCellMargin);
    }];
    
    // 群介绍后的三角
    UIImageView *triangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
    self.triangleImage = triangleImage;
    [self.contentView addSubview:triangleImage];
    [triangleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 12));
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
        make.centerY.equalTo(groupToIntroduce.mas_centerY);
    }];
    
    // 分隔线
    UIView *dividingLine = [[UIView alloc] init];
    dividingLine.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:dividingLine];
    [dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel.mas_left);
        make.top.equalTo(contentLabel.mas_bottom).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.mas_right);
        make.height.offset(0.5);
    }];
    
    // 点击群介绍的按钮
    UIButton *introduceBtn = [[UIButton alloc] init];
    self.introduceBtn = introduceBtn;
    [introduceBtn addTarget:self action:@selector(introduceBtnCliek) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:introduceBtn];
    [introduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupToIntroduce.mas_top);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(dividingLine.mas_top);
    }];
    
    // 群成员人数
    UILabel *numberLabel = [UILabel labelWithText:@"圈成员人数" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    numberLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    self.numberLabel = numberLabel;
    [self.contentView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel. mas_left);
        make.top.equalTo(dividingLine.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // 群成员总数
    UILabel *member_countLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x9767d0] andFontSize:17];
    self.member_countLabel = member_countLabel;
    [self.contentView addSubview:member_countLabel];
    [member_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numberLabel.mas_centerY);
        make.left.equalTo(numberLabel.mas_right).offset(ghStatusCellMargin);
    }];
    
    // 群人员后的三角
    UIImageView *triangletwoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
    self.triangletwoImage = triangletwoImage;
    [self.contentView addSubview:triangletwoImage];
    
    // 群头像
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor colorWithHex:0xffffff];
    // 禁止滑动
    collectionView.scrollEnabled = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[WQGroupHeadCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.contentView addSubview:collectionView];
    
    [triangletwoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 12));
        make.right.equalTo(self.mas_right).offset(-ghStatusCellMargin);
        make.centerY.equalTo(collectionView.mas_centerY);
    }];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel.mas_left);
        make.top.equalTo(numberLabel.mas_bottom).offset(ghStatusCellMargin);
        make.right.equalTo(triangletwoImage.mas_left).offset(-25);
        make.height.offset(ghCellHeight + ghStatusCellMargin);
    }];
    
    // 头像下的分隔线
    UIView *headBottomDividingLine = [[UIView alloc] init];
    self.headBottomDividingLine = headBottomDividingLine;
    headBottomDividingLine.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:headBottomDividingLine];
    [headBottomDividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel.mas_left);
        make.top.equalTo(collectionView.mas_bottom).offset(-5);
        //.offset(5);
        make.right.equalTo(self.mas_right);
        make.height.offset(0.5);
    }];
    
    // 点击头像那一行的btn
    UIButton *headPortraitBtn = [[UIButton alloc] init];
    self.headPortraitBtn = headPortraitBtn;
    [headPortraitBtn addTarget:self action:@selector(headPortraitBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:headPortraitBtn];
    [headPortraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(numberLabel.mas_top);
        make.bottom.equalTo(headBottomDividingLine.mas_top);
    }];
    
    // 新成员
//    WQNewMembersView *newMembersView = [[WQNewMembersView alloc] init];
//    
//    // 需要刷新数据
    __weak typeof(self) weakSelf = self;
//    [newMembersView setIsLoadDataBlock:^{
//        if (weakSelf.isLoadDataBlockBlock) {
//            weakSelf.isLoadDataBlockBlock();
//        }
//    }];
//    
//    self.wqNewMembersView = newMembersView;
//    [self.contentView addSubview:newMembersView];
//    [newMembersView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headBottomDividingLine.mas_bottom);
//        make.left.right.equalTo(self.contentView);
//        make.height.offset(55);
//    }];
    
    // 创建时间标签
    UILabel *createTimeLabel = [UILabel labelWithText:@"圈创建时间" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    createTimeLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    self.createTimeLabel = createTimeLabel;
    [self.contentView addSubview:createTimeLabel];
    [createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel.mas_left);
        make.top.equalTo(headPortraitBtn.mas_bottom).offset(ghDistanceershi);
    }];
    
    // 创建时间
    UILabel *timeLabel = [UILabel labelWithText:@"2017-05-29" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:17];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(createTimeLabel.mas_centerY);
        make.left.equalTo(createTimeLabel.mas_right).offset(ghStatusCellMargin);
    }];
    
    // 创建时间底部的线
    UIView *bottomLineView = [[UIView alloc] init];
    self.bottomLineView = bottomLineView;
    bottomLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(createTimeLabel.mas_left);
        make.right.equalTo(self.contentView);
        make.top.equalTo(createTimeLabel.mas_bottom).offset(ghDistanceershi);
        make.height.offset(ghStatusCellMargin);
    }];
    
    // 设置管理员
    self.setAdministratorView = [[WQSetAdministratorView alloc] init];
    self.setAdministratorView.delegate = self;
    [self.contentView addSubview:self.setAdministratorView];
    [self.setAdministratorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.top.equalTo(bottomLineView.mas_bottom);
        make.height.offset(55);
    }];
    
    // 群主权限转让
    self.transferGroupManagerView = [[WQTransferGroupManager alloc] init];
    
    [self.transferGroupManagerView setTransferGroupManagerBlock:^{
        WQTransferGroupManagerViewController *vc = [[WQTransferGroupManagerViewController alloc] init];
        vc.type = wqTransfer;
        vc.gid = weakSelf.groupId;
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.contentView addSubview:_transferGroupManagerView];
    [_transferGroupManagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        //make.bottom.equalTo(self.contentView).offset(-5);
        make.top.equalTo(self.setAdministratorView.mas_bottom);
        make.height.offset(55);
    }];
    
    // 私密圈的view
    WQPrivateCircleView *privateCircleView = [[WQPrivateCircleView alloc] init];
    self.privateCircleView = privateCircleView;
    privateCircleView.isNewGroup = NO;
    [self.contentView addSubview:privateCircleView];
    [privateCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.top.equalTo(_transferGroupManagerView.mas_bottom);
        make.height.offset(142);
        make.bottom.equalTo(self.contentView);
    }];
}

// 点击群介绍
- (void)introduceBtnCliek {
    WQGroupIntroduceViewController *vc = [[WQGroupIntroduceViewController alloc] init];
    vc.content = self.contentLabel.text;
    vc.gid = self.groupId;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)headPortraitBtnClike {
    WQGroupMembersController * vc = [[WQGroupMembersController alloc] init];
    vc.gid = self.groupId;
    [self.viewController.navigationController pushViewController:vc
     animated:YES];
}

- (void)setMember_count:(NSString *)member_count {
    _member_count = member_count;
    self.member_countLabel.text = [[NSString stringWithFormat:@"%@",member_count] stringByAppendingString:@"人"];
}

- (void)setModel:(WQGetgroupInfoModel *)model {
    _model = model;
    self.contentLabel.attributedText = [self getAttributedStringWithString:[NSString stringWithFormat:@"%@",model.description] lineSpace:10];
    self.timeLabel.text = model.createtime;
    
    // 是否是私密圈
    if ([model.privacy boolValue]) {
        self.privateCircleView.wqSwitch.on = YES;
    }else {
        self.privateCircleView.wqSwitch.on = NO;
    }
    
    // 只要是快速注册用户不管有没有加入群都看不了已加入群成员头像
    if (![WQDataSource sharedTool].verified) {
        // 不可以编辑群资料
        self.triangleImage.hidden = YES;
        // 点击群介绍那一行的Btn
        self.introduceBtn.hidden = YES;
        // 新成员的那一栏
        //self.wqNewMembersView.hidden = YES;
        // 头像后的三角
        self.triangletwoImage.hidden = YES;
        // 群主转让权限
        self.transferGroupManagerView.hidden = YES;
        // 设置管理员
        self.setAdministratorView.hidden = YES;
        // 私密圈权限
        self.privateCircleView.hidden = YES;
        // 已经加入群的
        if (model.isMember) {
            // 点击头像那一行的btn
            self.headPortraitBtn.hidden = NO;
            // 头像
            self.collectionView.hidden = NO;
            // 已加入群成员的显示头像,头像下的分隔线view等于头像的底部
            [self.headBottomDividingLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentLabel.mas_left);
                make.top.equalTo(self.collectionView.mas_bottom).offset(ghSpacingOfshiwu);
                make.right.equalTo(self.mas_right);
                make.height.offset(0.5);
            }];
            // 请求头像数据
            [self loadList];
        }else {
            self.headPortraitBtn.hidden = YES;
            // 头像
            self.collectionView.hidden = YES;
            // 头像底下的分割线顶部等于群成员人数的底部
            [self.headBottomDividingLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentLabel.mas_left);
                make.top.equalTo(self.numberLabel.mas_bottom).offset(ghSpacingOfshiwu);
                make.right.equalTo(self.mas_right);
                make.height.offset(0.5);
            }];
        }
        // 让群创建时间的顶部等于头像下分割线的底部
        [self.createTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel.mas_left);
            make.top.equalTo(self.headBottomDividingLine.mas_bottom).offset(ghDistanceershi);
        }];
        // 不显示群主权限转让
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.createTimeLabel.mas_left);
            make.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.createTimeLabel.mas_bottom).offset(ghDistanceershi);
            make.height.offset(0.5);
        }];
        [self.setAdministratorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.transferGroupManagerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.privateCircleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        if (!model.isMember) {
            if (self.isMemberBlock) {
                self.isMemberBlock();
            }
        }
    }else {
        // 判断该成员是不是群主isOwner true: 是群主
        if (model.isOwner || model.isAdmin) {
            // 可以编辑群资料
            self.triangleImage.hidden = NO;
            // 点击群介绍那一行的Btn
            self.introduceBtn.hidden = NO;
            // 新成员的那一栏
            //self.wqNewMembersView.hidden = NO;
            // 头像
            self.collectionView.hidden = NO;
            // 头像后的三角
            self.triangletwoImage.hidden = NO;
            // 点击头像那一行的btn
            self.headPortraitBtn.hidden = NO;
            // 私密圈权限
            self.privateCircleView.hidden = NO;
            if (model.isOwner) {
                // 群主转让权限
                self.transferGroupManagerView.hidden = NO;
                // 设置管理员
                self.setAdministratorView.hidden = NO;
                
                // 头像底下的分割线顶部等于群成员头像的底部
                [self.headBottomDividingLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel.mas_left);
                    make.top.equalTo(self.collectionView.mas_bottom).offset(ghSpacingOfshiwu);
                    make.right.equalTo(self.mas_right);
                    make.height.offset(0.5);
                }];
                
                // 让群创建时间的顶部等于成头像员的底部
                [self.createTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel.mas_left);
                    make.top.equalTo(self.headPortraitBtn.mas_bottom).offset(ghDistanceershi);
                }];
                
                // 群主权限的底部等于self.contentView
                [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView.mas_left);
                    make.right.equalTo(self.contentView);
                    make.top.equalTo(self.createTimeLabel.mas_bottom).offset(ghDistanceershi);
                    make.height.offset(ghStatusCellMargin);
                }];
                [self.setAdministratorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.left.equalTo(self.contentView);
                    make.top.equalTo(self.bottomLineView.mas_bottom);
                    make.height.offset(55);
                }];
                [self.transferGroupManagerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.left.equalTo(self.contentView);
                    //make.bottom.equalTo(self.contentView).offset(-5);
                    make.top.equalTo(self.setAdministratorView.mas_bottom);
                    make.height.offset(55);
                }];
                [self.privateCircleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.left.equalTo(self.contentView);
                    make.top.equalTo(_transferGroupManagerView.mas_bottom);
                    make.height.offset(142);
                    make.bottom.equalTo(self.contentView);
                }];
            }else {
                // 群主转让权限
                self.transferGroupManagerView.hidden = YES;
                // 设置管理员
                self.setAdministratorView.hidden = YES;
                // 头像底下的分割线顶部等于群成员头像的底部
                [self.headBottomDividingLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel.mas_left);
                    make.top.equalTo(self.collectionView.mas_bottom).offset(ghSpacingOfshiwu);
                    make.right.equalTo(self.mas_right);
                    make.height.offset(0.5);
                }];
                // 让群创建时间的顶部等于头像下分割线的底部
                [self.createTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel.mas_left);
                    make.top.equalTo(self.headBottomDividingLine.mas_bottom).offset(ghDistanceershi);
                }];
                
                // 不显示群主权限转让
                [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView.mas_left);
                    //make.right.bottom.equalTo(self.contentView);
                    make.right.equalTo(self.contentView);
                    make.top.equalTo(self.createTimeLabel.mas_bottom).offset(ghDistanceershi);
                    make.height.offset(ghStatusCellMargin);
                }];
                [self.privateCircleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.left.equalTo(self.contentView);
                    make.top.equalTo(self.bottomLineView.mas_bottom);
                    make.height.offset(142);
                    make.bottom.equalTo(self.contentView);
                }];
            }
            
        }else {
            // 不是群主而且是已经加入群的
            if (model.isMember) {
                // 不可以编辑群资料
                self.triangleImage.hidden = YES;
                // 点击群介绍那一行的Btn
                self.introduceBtn.hidden = YES;
                // 新成员的那一栏
                //self.wqNewMembersView.hidden = YES;
                // 头像
                self.collectionView.hidden = NO;
                // 头像后的三角
                self.triangletwoImage.hidden = NO;
                // 点击头像那一行的btn
                self.headPortraitBtn.hidden = NO;
                // 设置管理员
                self.setAdministratorView.hidden = YES;
                // 私密圈权限
                self.privateCircleView.hidden = YES;
                // 头像底下的分割线顶部等于群成员人数的底部
                [self.headBottomDividingLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel.mas_left);
                    make.top.equalTo(self.collectionView.mas_bottom).offset(ghSpacingOfshiwu);
                    make.right.equalTo(self.mas_right);
                    make.height.offset(0.5);
                }];
                
                // 让群创建时间的顶部等于头像下分割线的底部
                [self.createTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel.mas_left);
                    make.top.equalTo(self.headBottomDividingLine.mas_bottom).offset(ghDistanceershi);
                }];
                
                // 不显示群主权限转让
                [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.createTimeLabel.mas_left);
                    make.right.bottom.equalTo(self.contentView);
                    make.top.equalTo(self.createTimeLabel.mas_bottom).offset(ghDistanceershi);
                    make.height.offset(0.5);
                }];
                [self.transferGroupManagerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
                [self.setAdministratorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
                [self.privateCircleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
            } else {
                // 没有加入群的
                // 回调事件,让底部按钮改为加入群组
                if (self.isMemberBlock) {
                    self.isMemberBlock();
                }
                // 不可以编辑群资料
                self.triangleImage.hidden = YES;
                // 点击群介绍那一行的Btn
                self.introduceBtn.hidden = YES;
                // 新成员的那一栏
                //self.wqNewMembersView.hidden = YES;
                // 头像
                self.collectionView.hidden = YES;
                // 头像后的三角
                self.triangletwoImage.hidden = YES;
                // 点击头像那一行的btn
                self.headPortraitBtn.hidden = YES;
                // 群主转让权限
                self.transferGroupManagerView.hidden = YES;
                // 设置管理员
                self.setAdministratorView.hidden = YES;
                // 私密圈权限
                self.privateCircleView.hidden = YES;
                // 头像底下的分割线顶部等于群成员人数的底部
                [self.headBottomDividingLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel.mas_left);
                    make.top.equalTo(self.numberLabel.mas_bottom).offset(ghSpacingOfshiwu);
                    make.right.equalTo(self.mas_right);
                    make.height.offset(0.5);
                }];
                // 让群创建时间的顶部等于头像下分割线的底部
                [self.createTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentLabel.mas_left);
                    make.top.equalTo(self.headBottomDividingLine.mas_bottom).offset(ghDistanceershi);
                }];
                
                // 不显示群主权限转让
                [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.createTimeLabel.mas_left);
                    make.right.bottom.equalTo(self.contentView);
                    make.top.equalTo(self.createTimeLabel.mas_bottom).offset(ghDistanceershi);
                    make.height.offset(0.5);
                }];
                [self.transferGroupManagerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
                [self.setAdministratorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
                [self.privateCircleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
            }
        }
    }
    
    [self loadList];
}

- (void)loadList {
    // 获取已加入群成员的头像
    NSString *urlString = @"api/group/groupmemberlist";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secretkey"] = [WQDataSource sharedTool].secretkey;
    params[@"gid"] = _model.gid;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        NSLog(@"%@",response);
        
        if ([response[@"success"] boolValue]) {
            self.tableViewdetailOrderData = [NSArray yy_modelArrayWithClass:[WQGroupMemberModel class] json:response[@"members"]];
            [self.collectionView reloadData];
        }
    }];
}

- (void)setGroupId:(NSString *)groupId {
    _groupId = groupId;
    
    self.privateCircleView.gid = groupId;
}

#pragma mark -- WQSetAdministratorViewDelegate
- (void)wqSetAdministratorClick:(WQSetAdministratorView *)setAdministratorView {
    // 设置管理员的控制器
    WQSetAdministratorViewController *vc = [[WQSetAdministratorViewController alloc] init];
    vc.gid = _model.gid;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tableViewdetailOrderData.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(44, 44);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQGroupHeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.tableViewdetailOrderData[indexPath.row];
    
    return cell;
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

@end
