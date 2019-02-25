//
//  WZCollectTableView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZCollectTableView.h"
#import "WZHouseDatisController.h"
#import "UIViewController+WZFindController.h"
#import "WZFindHouseListItem.h"
#import "WZCollectHouseCell.h"
#import "WZSupportHouseDatisController.h"
@interface WZCollectTableView()<UITableViewDelegate,UITableViewDataSource>

@end

static  NSString * const ID = @"cells";
@implementation WZCollectTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZCollectHouseCell" bundle:nil] forCellReuseIdentifier:ID];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 141;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseItem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZCollectHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZFindHouseListItem *item = [[WZFindHouseListItem alloc] init];
    item = self.houseItem[indexPath.row];
    cell.item = item;
    //取消收藏
    cell.deleteblock = ^(UITableViewCell *currentCell){
        
        //获取准确的indexPath
        
        NSIndexPath *currentIndexPath = [tableView indexPathForCell:currentCell];
  
        [self.houseItem removeObjectAtIndex:currentIndexPath.row];
        
        
        [tableView beginUpdates];
        
        
        [tableView deleteRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView endUpdates];
        
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZCollectHouseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //点击跳转详情页
    UIViewController *vc = [UIViewController viewController:self.superview];
    UIViewController *Vc = [UIViewController viewController:vc.view.superview];
    NSString *selfEmployed = cell.selfEmployed;
    
    if ([selfEmployed isEqual:@"2"]) {
        WZSupportHouseDatisController *houseDatis = [[WZSupportHouseDatisController alloc] init];
        houseDatis.ID =  cell.ID;
        [Vc.navigationController pushViewController:houseDatis animated:YES];
    }else{
        WZHouseDatisController *houseDatis = [[WZHouseDatisController alloc] init];
        houseDatis.ID =  cell.ID;
        [Vc.navigationController pushViewController:houseDatis animated:YES];
        
    }
}

@end
