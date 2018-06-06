//
//  WZReportSuccessTableView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZReportSuccessTableView.h"
#import "WZReportSuccessCell.h"
#import "WZLikeProjectItem.h"
#import "WZHouseDatisController.h"
#import "UIViewController+WZFindController.h"
static  NSString * const ID = @"Scell";
@interface WZReportSuccessTableView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation WZReportSuccessTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZReportSuccessCell" bundle:nil] forCellReuseIdentifier:ID];
    self.center = CGPointMake(self.frame.size.height / 2+15, self.frame.size.width / 2);
    //设置分割线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scrollsToTop = NO;
    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _projectArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZReportSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    WZLikeProjectItem *mode = _projectArray[indexPath.row];
    cell.item = mode;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZReportSuccessCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WZHouseDatisController *datis = [[WZHouseDatisController alloc] init];
    datis.ID = cell.projectId;
    UIViewController *vc = [UIViewController viewController:self.superview];
    [vc.navigationController pushViewController:datis animated:YES];
}

@end
