//
//  WQMapSearchViewTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/27.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQMapSearchViewTableViewCell.h"
#import "WQMapViewSearchModel.h"

@interface WQMapSearchViewTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *mapViewStoreName;
@property (weak, nonatomic) IBOutlet UILabel *mapViewLocation;

@end

@implementation WQMapSearchViewTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setMapViewSearchModel:(WQMapViewSearchModel *)mapViewSearchModel
{
    _mapViewSearchModel = mapViewSearchModel;
    self.mapViewStoreName.text = mapViewSearchModel.mapViewStoreName;
    self.mapViewLocation.text = mapViewSearchModel.mapViewLocation;
}


@end
