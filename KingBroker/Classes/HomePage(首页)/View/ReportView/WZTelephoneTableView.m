//
//  WZTelephoneTableView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZTelephoneTableView.h"
#import "WZTelePhoneCell.h"

static  NSString * const ID = @"Tcell";
@interface WZTelephoneTableView()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation WZTelephoneTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZTelePhoneCell" bundle:nil] forCellReuseIdentifier:ID];
    //设置分割线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZTelePhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    return cell;
}

@end
