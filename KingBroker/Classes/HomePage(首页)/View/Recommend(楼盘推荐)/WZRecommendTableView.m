//
//  WZRecommendTableView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZRecommendTableView.h"
#import "WZRecommendCell.h"
#import "UIView+Frame.h"
#import "WZHouseDatisController.h"
#import "UIViewController+WZFindController.h"
#import "WZFindHouseListItem.h"
#import "NSString+LCExtension.h"
static  NSString * const IDR = @"cells";
@interface WZRecommendTableView()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation WZRecommendTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZRecommendCell" bundle:nil] forCellReuseIdentifier:IDR];
    //设置分割线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bounces = NO;
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 350;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return _listArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WZRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:IDR];
    WZFindHouseListItem *item = _listArray[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //点击跳转详情页
    UIViewController *vc = [UIViewController viewController:self];
    if (![uuid isEqual:@""]&&uuid) {
        WZRecommendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        WZHouseDatisController *houseDatis = [[WZHouseDatisController alloc] init];
        houseDatis.ID =  cell.ID;
        [vc.navigationController pushViewController:houseDatis animated:YES];
    }else{
        [NSString isCode:vc.navigationController code:@"401"];
    }
}
@end
