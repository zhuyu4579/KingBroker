//
//  WZFindHouseTableView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/3.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZFindHouseTableView.h"
#import "WZFindHouseCell.h"
#import "WZHouseDatisController.h"
#import "UIViewController+WZFindController.h"
#import "WZFindHouseListItem.h"
static  NSString * const ID = @"cells";
@interface WZFindHouseTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WZFindHouseTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZFindHouseCell" bundle:nil] forCellReuseIdentifier:ID];
//    self.bounces = NO;
//    self.showsVerticalScrollIndicator = NO;
//    self.showsHorizontalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;

    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseItem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZFindHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZFindHouseListItem *item = [[WZFindHouseListItem alloc] init];
    item = self.houseItem[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZFindHouseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //点击跳转详情页
    UIViewController *vc = [UIViewController viewController:self];
    WZHouseDatisController *houseDatis = [[WZHouseDatisController alloc] init];
    houseDatis.ID =  cell.ID;
    [vc.navigationController pushViewController:houseDatis animated:YES];
}
@end
