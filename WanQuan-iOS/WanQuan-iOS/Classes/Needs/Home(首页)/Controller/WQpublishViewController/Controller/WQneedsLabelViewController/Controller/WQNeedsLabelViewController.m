//
//  WQNeedsLabelViewController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/25.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQNeedsLabelViewController.h"
#import "WQWQNeedsLabelTableViewCell.h"
#import "WQNeedsLabelModel.h"

static NSString *cellID = @"cellid";

@interface WQNeedsLabelViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)WQWQNeedsLabelTableViewCell *cell;
@property(nonatomic,strong)NSMutableArray *mineOptionData;
@end

@implementation WQNeedsLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.a
    self.mineOptionData = [NSMutableArray array];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(numberClick:)];
    WQNavBackButton * btn = [[WQNavBackButton alloc] initWithTintColor:self.navigationController.navigationBar.tintColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UITableView *tableview = [[UITableView alloc]init];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 45)];
    
    
    [tableview registerNib:[UINib nibWithNibName:@"WQWQNeedsLabelTableViewCell" bundle:nil]
    forCellReuseIdentifier:cellID];
    [self.view addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    tableview.dataSource = self;
    tableview.delegate = self;
    _index = 1;
    
    footerView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc]init];
    [footerView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHex:0Xc8c7cc];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(footerView);
        make.height.mas_offset(1);
    }];
    
    //加号btn
    UIButton *plusBnt = [UIButton new];
    [footerView addSubview:plusBnt];
    [plusBnt addTarget:self action:@selector(plusBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [plusBnt setImage:[UIImage imageNamed:@"add1"] forState:0];
    [plusBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView.mas_left).mas_offset(15);
        make.bottom.mas_equalTo(footerView.mas_bottom).mas_offset(-10);
    }];
    
    UILabel *additionLabel = [[UILabel alloc]init];
    additionLabel.text = @"添加标签";
    additionLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:additionLabel];
    [additionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(plusBnt.mas_right).mas_offset(10);
        make.bottom.mas_equalTo(footerView.mas_bottom).mas_offset(-14);
    }];
    
    tableview.tableFooterView = footerView;
    
    self.tableview = tableview;
    
    NSString* homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject;
    // file路径
    NSString* filePath = [homePath stringByAppendingPathComponent:@"_cellpropellingXml.data"];
    // 解档
    self.mineOptionData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!self.mineOptionData) {
        self.mineOptionData = [NSMutableArray array];
    }
}

- (void)numberClick:(UIBarButtonItem *)sender {
    if (self.mineOptionData.count > 0) {
        _cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.mineOptionData.count - 1 inSection:0]];
        [self.mineOptionData replaceObjectAtIndex:self.mineOptionData.count - 1 withObject:_cell.propellingXml.text];
    }

    
    NSString* homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject;
    // file路径
    NSString* filePath = [homePath stringByAppendingPathComponent:@"_cellpropellingXml.data"];
    NSMutableArray *mArray = [NSMutableArray array];
    [mArray addObject:_cell.propellingXml.text];
    //归档
    [NSKeyedArchiver archiveRootObject:self.mineOptionData toFile:filePath];
    
    [_cell.propellingXml  resignFirstResponder];
}

- (void)plusBtnClike
{
    if (self.mineOptionData.count > 0) {
        _cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.mineOptionData.count - 1 inSection:0]];
        [self.mineOptionData replaceObjectAtIndex:self.mineOptionData.count - 1 withObject:_cell.propellingXml.text];
    }
    
    if (self.mineOptionData.count >= 3) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Hello~!" message:@"只允许添加三个标签哦!" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertVC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    [self.mineOptionData addObject:@""];
    [self.tableview reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mineOptionData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WQWQNeedsLabelTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    self.cell = cell;
    WQNeedsLabelModel *needsLabelmodel = [WQNeedsLabelModel new];
    needsLabelmodel.propellingXml = self.mineOptionData[indexPath.row];
    cell.needsLabelModel = needsLabelmodel;
    cell.ClikeBlock = ^
    {
        [self.mineOptionData removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    };
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
