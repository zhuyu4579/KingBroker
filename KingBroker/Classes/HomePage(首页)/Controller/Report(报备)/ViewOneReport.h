//
//  ViewOneReport.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewOneReport : UIViewController
//客户姓名
@property (nonatomic, strong)UITextField *customerName;
//手机号前三位
@property (nonatomic, strong)UITextField *topText;
//手机号后三位
@property (nonatomic, strong)UITextField *bottomText;
//项目名
@property (nonatomic, copy)UILabel *ItemName;
//项目ID
@property(nonatomic,strong)NSString *itemId;
//数据数组
@property(nonatomic,strong)NSArray *itemNameArray;
//选择项目按钮
@property (nonatomic, strong)UIButton *titemNameButton;
//项目是否签约
@property(nonatomic,strong)NSString *sginStatu;
//项目负责人电话
@property(nonatomic,strong)NSString *telphone;
-(void)selectCustoms:(NSArray *)array;
-(void)loadTimeData;
@end
