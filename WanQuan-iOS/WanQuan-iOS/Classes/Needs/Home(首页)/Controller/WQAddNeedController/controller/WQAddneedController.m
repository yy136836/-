//
//  WQAddneedController.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/10.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAddneedController.h"
#import "WQdemaadnforHairViewController.h"
#import "WQAddNeedFooter.h"

#define TAG_NEED_BUTTON 1000


@interface AddNeedTitleView : UIView
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subTitle;
@end

@interface AddNeedTitleView ()
@property (nonatomic, retain, readonly) UILabel * titleLabel;
@property (nonatomic, retain, readonly) UILabel * subTitleLabel;
@end

@implementation AddNeedTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIView * leftBlock = [[UIView alloc] initWithFrame:CGRectMake(10, (frame.size.height - 15) / 2 , 2, 15)];
        leftBlock.backgroundColor = [UIColor colorWithHex:0xff8b1a];
        [self addSubview:leftBlock];
        
        _titleLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:15];
        _titleLabel.frame =  CGRectMake(15, 0, kScreenWidth / 2, frame.size.height);
        [self addSubview:_titleLabel];
        
        _subTitleLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:13];
        _subTitleLabel.frame = CGRectMake(_titleLabel.x + _titleLabel.width, 0, kScreenWidth / 3, frame.size.height);
        [self addSubview:_subTitleLabel];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    _titleLabel.frame = CGRectMake(_titleLabel.x, _titleLabel.y, rect.size.width + 6, _titleLabel.height);
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitleLabel.text = subTitle;
    _subTitleLabel.frame = CGRectMake(_titleLabel.x + _titleLabel.width , 0, kScreenWidth / 2, _subTitleLabel.height);
}


@end



@interface NeedTypeButton : UIButton
@property (nonatomic, retain) NSDictionary * needInfoDic;
@end

@implementation NeedTypeButton


@end

@interface WQAddneedController ()


/**
 用于存储希求类型的数组 数组的结构如下

[
{
    "fulltitle": "mock",
    "id": "mock",
    "title": "mock",
    "leaf": true,
    "children": [
        {
            "fulltitle": "mock",
            "id": "mock",
            "hearted": true,
             "title": "mock",
             "leaf": true
         }
    ]

},.....
]

 */
@property (nonatomic, retain) NSMutableArray * needTypeInfo;
@property (nonatomic, retain) UIScrollView * mainScroll;
@property (nonatomic, retain) NeedTypeButton * selectedButton;


/**
 我现在订阅的需求类型
 */
@property (nonatomic, retain) NSMutableArray * aHeartedSubscription;
@end

@implementation WQAddneedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:_mainScroll];
    if (@available(iOS 11, *)) {
        _mainScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.view.backgroundColor = [UIColor colorWithHex:0xededed];
    
    _needTypeInfo = @[].mutableCopy;
    _aHeartedSubscription = @[].mutableCopy;
    [self customNav];
    [self loadNeedTypes];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
//    self.navigationItem.title = @"返回";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
}


- (void)customNav {
//    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    
//    btn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [btn sizeToFit];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:nil];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(backOnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = left;

    
//    [btn addTarget:self action:@selector(backOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if (self.type == NeedControllerTypeSubScription) {
        UIButton * save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [save setTitle:@"保存" forState:UIControlStateNormal];
        save.titleLabel.font = [UIFont systemFontOfSize:17];
        [save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [save sizeToFit];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:save];
        
        [save addTarget:self action:@selector(saveOnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * titleLabel = [UILabel labelWithText:@"管理订阅" andTextColor:[UIColor blackColor] andFontSize:20];
        [titleLabel sizeToFit];
        self.navigationItem.titleView = titleLabel;
    } else {
        
        UIButton * next = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [next setTitle:@"下一页" forState:UIControlStateNormal];
        next.titleLabel.font = [UIFont systemFontOfSize:17];
        [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [next sizeToFit];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:next];
        
        [next addClickAction:^(UIButton * _Nullable sender) {
            [self nextOnClick];
        }];
        
//        UILabel * titleLabel = [UILabel labelWithText:@"发需求" andTextColor:[UIColor whiteColor] andFontSize:18];
//        [titleLabel sizeToFit];
//        self.navigationItem.titleView = titleLabel;
        self.navigationItem.title = @"发需求";
    }
}


- (void)loadNeedTypes {
    NSString *urlString = @"api/need/getcategorylist";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * params = @{}.mutableCopy;
    params[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    
    [SVProgressHUD  showWithStatus:@"加载中…"];
    
    [[WQNetworkTools sharedTools]request:WQHttpMethodPost urlString:urlString parameters:params completion:^(id response, NSError *error) {
        
        if (error) {
            
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            NSLog(@"%@",error);
            [SVProgressHUD dismissWithDelay:0.5];
            return ;
        }
        if ([response isKindOfClass:[NSData class]]) {
            
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        
        if (! [response[@"success"] boolValue]) {
            
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接后重试"];
        }
        
        [SVProgressHUD dismissWithDelay:0.5];
        _needTypeInfo = response[@"list"];
        [self setUpView];
//        处理订阅的类型
        if (self.type == NeedControllerTypeSubScription) {
            
            [self parseData:_needTypeInfo];
        }
    }];
}




- (void)setUpView {
    
    CGFloat startY = 10 ;
    for (NSInteger i = 0 ; i < _needTypeInfo.count ; ++ i) {
        
        NSDictionary * mainType = _needTypeInfo[i];
        if (i) {
            startY += 10;
        }
        startY =  [self setupOneSectionWith:mainType startY:startY];
    }
    WQAddNeedFooter * footer = [[NSBundle mainBundle] loadNibNamed:@"WQAddNeedFooter" owner:self options:nil].lastObject;
    footer.frame = CGRectMake(0, startY, kScreenWidth, 70);
    [_mainScroll addSubview:footer];
    footer.backgroundColor = _mainScroll.backgroundColor;
    startY += 70;
    _mainScroll.contentSize = CGSizeMake(kScreenWidth, startY + 30);
    
}

- (CGFloat)setupOneSectionWith:(NSDictionary *)mainType  startY:(CGFloat )startY {
    
    CGFloat endY  = startY;
    UIView * whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, startY, kScreenWidth, 0)];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:whiteBackView];
    
    
    AddNeedTitleView * titleView = [[AddNeedTitleView alloc] initWithFrame:CGRectMake(0, startY, kScreenWidth, 40)];
    [_mainScroll addSubview:titleView];
    titleView.title = mainType[@"title"];
    //titleView.subTitle = @"请自己设置!!!";
    
    endY = startY + titleView.height;
    
    CGFloat buttonWidth   = 68;
    CGFloat buttonHeight  = 26;
    CGFloat horizonSpace  = (kScreenWidth - 4 * buttonWidth) / 5;
    CGFloat verticalSpace = 12;
    

    
    for (NSInteger i = 0 ; i < [mainType[@"children"] count]; ++ i) {
        NSDictionary * leafType = mainType[@"children"][i];
        
        NeedTypeButton * button = [[NeedTypeButton alloc] initWithFrame:CGRectMake(
                                                                                   (horizonSpace + buttonWidth) * (i % 4) + horizonSpace,
                                                                                   i / 4 *(buttonHeight + verticalSpace) + endY,
                                                                                   buttonWidth,
                                                                                   buttonHeight
                                                                                   )];
        
        [_mainScroll addSubview:button];
        
        
        button.needInfoDic = leafType;
        
        [button setBackgroundImage:[UIImage imageWithColor:WQ_LIGHT_PURPLE] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xf9f9f9]] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.borderColor = [UIColor colorWithHex:0xf2f2f2].CGColor;
        
        [button setTitle:leafType[@"title"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
//        button.tag = [leafType[@"id"] integerValue] + TAG_NEED_BUTTON;//使用 button 的 tag 来传递 id
        button.layer.borderWidth = 0.5;
        
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];
        
//        当该视图为订阅视图时
        if (self.type == NeedControllerTypeSubScription) {
            
            if ([button.needInfoDic[@"hearted"] boolValue]) {
                button.selected = YES;
            }
        }
      
        if (i ==  [mainType[@"children"] count] - 1) {
            endY = button.y + button.height;
        }
    }
    
    endY += (5 + verticalSpace);
    
    whiteBackView.frame = CGRectMake(0, whiteBackView.y, whiteBackView.width, endY - whiteBackView.y);

    
    return endY;
}



/**
 点击需求类型按钮

 @param sender 被点击的按钮
 */
- (void)onClick:(NeedTypeButton *)sender {
    
    
    if (self.type == NeedControllerTypeSubScription) {
    
        sender.selected = !sender.selected;
        
        if ([_aHeartedSubscription containsObject:sender.needInfoDic]) {
            [_aHeartedSubscription removeObject:sender.needInfoDic];
        } else {
            [_aHeartedSubscription addObject:sender.needInfoDic];
        }
        
        NSLog(@"%@",_aHeartedSubscription);
        
    } else {
        
    if (_selectedButton) {
        
        _selectedButton.selected = !(_selectedButton.selected);
    }
        
        sender.selected = !(sender.selected);
        _selectedButton = sender;
    }
}


/**
 取消按钮
 */
- (void)backOnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 下一页
 */
- (void)nextOnClick {
    
    if (!_selectedButton) {
        [WQAlert showAlertWithTitle:@"" message:@"您还没有选择" duration:1];
        return;
    }

    WQdemaadnforHairViewController *vc = [[WQdemaadnforHairViewController alloc] init];
    if (self.type == NeedControllerTypeNeeds) {
        vc.releaseType = WQOrderTypeNeeds;
    }else if (self.type == NeedControllerTypeGroup) {
        vc.releaseType = WQOrderTypeGroup;
        vc.gid = self.gid;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
    NSMutableString * fatherTitle = [_selectedButton.needInfoDic[@"fulltitle"] mutableCopy];
    NSString * title = _selectedButton.needInfoDic[@"title"];
    
    fatherTitle = [[fatherTitle componentsSeparatedByString:title][0] mutableCopy];
    
    vc.titleString = fatherTitle;
    vc.needsId = _selectedButton.needInfoDic[@"id"];
    vc.childNodesString = title;
}



/**
 当处于订阅订阅页面时保存订阅
 */
- (void)saveOnClick {
    NSMutableArray * ids = @[].mutableCopy;
    for (NSDictionary * oneNeedType in _aHeartedSubscription) {
        
        [ids addObject:oneNeedType[@"id"]];
    }
    
    
    NSMutableDictionary * param = @{}.mutableCopy;
    NSString *urlString = @"api/need/setheartcategory";
    //用户密钥
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   param[@"secretkey"] = [userDefaults objectForKey:@"secretkey"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:ids options:NSJSONWritingPrettyPrinted error:nil];
    NSString *idcardStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    param[@"categoryids"] = idcardStr;
    [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:urlString parameters:param completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        if ([response isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        }
        NSLog(@"%@",response);
        BOOL successbool = [response[@"success"] boolValue];
        if (successbool) {

            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:nil message:@"请检查当前网络后重试" preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertVC animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];

    
    
    
    
}




- (void)parseData:(NSArray *)parseData {
    for (NSDictionary * oneSectionDict in parseData) {
        NSArray * oneSectionArray = oneSectionDict[@"children"];
        for (NSDictionary * oneNeed in oneSectionArray) {
            if([oneNeed[@"hearted"] boolValue]) {
                [_aHeartedSubscription addObject:oneNeed];
            }
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
