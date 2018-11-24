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
#import "WZSupportHouseDatisController.h"
static  NSString * const ID = @"Scell";
@interface WZReportSuccessTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,assign)NSIndexPath *currentIndexPath;
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
    self.center = CGPointMake(self.frame.size.height / 2, self.frame.size.width / 2);
    //设置分割线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scrollsToTop = NO;
    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 201;
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
    UIViewController *vc = [UIViewController viewController:self.superview];
    NSString *selfEmployed = cell.selfEmployed;
    if ([selfEmployed isEqual:@"2"]) {
        WZSupportHouseDatisController *houseDatis = [[WZSupportHouseDatisController alloc] init];
        houseDatis.ID =  cell.projectId;
        [vc.navigationController pushViewController:houseDatis animated:YES];
    }else{
        WZHouseDatisController *houseDatis = [[WZHouseDatisController alloc] init];
        houseDatis.ID =  cell.projectId;
        [vc.navigationController pushViewController:houseDatis animated:YES];
        
    }
    
}
@end
