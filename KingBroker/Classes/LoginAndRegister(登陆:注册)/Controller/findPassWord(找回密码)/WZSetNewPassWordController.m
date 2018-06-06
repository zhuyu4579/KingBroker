//
//  WZSetNewPassWordController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSetNewPassWordController.h"
#import "WZSetFindPWView.h"
@interface WZSetNewPassWordController ()

@end

@implementation WZSetNewPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle];
}
-(void)setNavTitle{
    //导航条标题
    self.navigationItem.title = @"设置密码";
    WZSetFindPWView *setNewFindPWView =  [WZSetFindPWView SetNewPW];
    setNewFindPWView.phone = _phone;
    setNewFindPWView.YZM = _YZM;
    [self.passWordTextFile addSubview:setNewFindPWView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
