//
//  WZGoodHouseTableView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZGoodHouseTableView.h"
#import "WZGHouseCell.h"
#import "WZHouseDatisController.h"
#import "UIViewController+WZFindController.h"
#import "WZFindHouseListItem.h"
#import "WZSupportHouseDatisController.h"
static  NSString * const ID = @"GCells";
@interface WZGoodHouseTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WZGoodHouseTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZGHouseCell" bundle:nil] forCellReuseIdentifier:ID];
    //    self.bounces = NO;
    //    self.showsVerticalScrollIndicator = NO;
    //    self.showsHorizontalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 293;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.houseItem.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZGHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZFindHouseListItem *item = [[WZFindHouseListItem alloc] init];
    item = self.houseItem[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZGHouseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //点击跳转详情页
    UIViewController *vc = [UIViewController viewController:self.superview];
    NSString *selfEmployed = cell.selfEmployed;
    if ([selfEmployed isEqual:@"2"]) {
        WZSupportHouseDatisController *houseDatis = [[WZSupportHouseDatisController alloc] init];
        houseDatis.ID =  cell.ID;
        [vc.navigationController pushViewController:houseDatis animated:YES];
    }else{
        WZHouseDatisController *houseDatis = [[WZHouseDatisController alloc] init];
        houseDatis.ID =  cell.ID;
        [vc.navigationController pushViewController:houseDatis animated:YES];
        
    }
  
}

@end
