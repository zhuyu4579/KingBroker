//
//  WZTaskTableView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZTaskTableView.h"
#import "WZTaskTagCell.h"
@interface WZTaskTableView()<UITableViewDelegate,UITableViewDataSource>


@end

static  NSString * const ID = @"cell";
@implementation WZTaskTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZTaskTagCell" bundle:nil] forCellReuseIdentifier:ID];
    //设置分割线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bounces = NO;
    return self;
}
#pragma mark -返回多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // return self.tags.count;
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZTaskTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //获取模型
    //WZTaskTagItem *item = self.tags[indexPath.row];
    //cell.textLabel.text = @"任务描述";
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

@end
