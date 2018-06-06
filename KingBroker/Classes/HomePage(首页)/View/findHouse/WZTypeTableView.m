//
//  WZTypeTableView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZTypeTableView.h"
#import "WZTypeViewCell.h"
#import "NSString+LCExtension.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WZTypeItem.h"
#import "WZHouseController.h"
static  NSString * const ID = @"Tcell";
@interface WZTypeTableView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation WZTypeTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZTypeViewCell" bundle:nil] forCellReuseIdentifier:ID];
    //设置分割线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bounces = YES;
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZTypeItem *item = _array[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZTypeViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.typeHouse.textColor = UIColorRBG(3, 133, 219);
    UIView *view =  [[tableView  superview] superview];
    [view setHidden:YES];
    if (_typeBlock) {
        NSMutableDictionary *typedic = [NSMutableDictionary dictionary];
        typedic[@"labels"] = cell.typeHouse.text;
        typedic[@"value"] = cell.value;
        _typeBlock(typedic);
    }
}

@end
