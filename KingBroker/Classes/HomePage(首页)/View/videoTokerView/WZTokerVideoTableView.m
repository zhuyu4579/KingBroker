//
//  WZTokerVideoTableView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "WZTokerVideoItem.h"
#import "WZTokerVideoCell.h"
#import "WZTokerVideoTableView.h"
static  NSString * const ID = @"Cell";
@interface WZTokerVideoTableView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation WZTokerVideoTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZTokerVideoCell" bundle:nil] forCellReuseIdentifier:ID];
    //设置分割线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 194;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZTokerVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZTokerVideoItem *item = _array[indexPath.row];
    cell.item = item;
    return cell;
}
@end
