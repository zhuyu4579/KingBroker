//
//  WZNewJionStoreController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//


#import <Masonry.h>
#import "GKCover.h"
#import "AppDelegate.h"
#import "WZAlertView.h"
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "HXPhotoPicker.h"
#import "WZLoadDateSeviceOne.h"
#import "ZDMapController.h"
#import "WZTabBarController.h"
#import "WZExamineController.h"
#import "WZNavigationController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZNewJionStoreController.h"
static const CGFloat kPhotoViewMargin = 15.0;
@interface WZNewJionStoreController()<UITextFieldDelegate,UIScrollViewDelegate,HXPhotoViewDelegate>
//滑动页面
@property(nonatomic,strong)UIScrollView *scrollView;
//背景图
@property(nonatomic,strong)UIImageView *imageView;
//关闭按钮
@property(nonatomic,strong)UIButton *closeButton;
//导航栏view
@property(nonatomic,strong)UIView *tabView;
@property(nonatomic,strong)UIView *ineView;
@property(nonatomic,strong)UILabel *barTitle;
//标题一
@property(nonatomic,strong)UILabel *titleOne;

//文字一
@property(nonatomic,strong)UILabel *labelOne;
//文字二
@property(nonatomic,strong)UILabel *labelTwo;
//第一个view
@property(nonatomic,strong)UIView *viewOne;
//姓名label
@property(nonatomic,strong)UILabel *nameLabel;
//姓名
@property(nonatomic,strong)UITextField *name;
//下划线
@property(nonatomic,strong)UIView *nameIne;
//第二个view
@property(nonatomic,strong)UIView *viewTwo;

//提交按钮
@property(nonatomic,strong)UIButton *button;
//有编码无编码
@property(nonatomic,strong)NSString *codeType;
//有编码无编码背景
@property(nonatomic,strong)UIImageView *codeImageView;
//下划线
@property(nonatomic,strong)UIView *codeImageViewIne;
//有编码按钮
@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,strong)UIView *ineCode;
//无编码按钮
@property(nonatomic,strong)UIButton *noCodeButton;
@property(nonatomic,strong)UIView *ineNoCode;
//有编码模块
@property(nonatomic,strong)UIView *codeViews;
//门店编码label
@property(nonatomic,strong)UILabel *codeLabel;
//有编码-编码
@property(nonatomic,strong)UITextField *code;
//下滑线
@property(nonatomic,strong)UIView *codeInes;
//名片View
@property(nonatomic,strong)UIView *cardViewOne;
//名片label
@property(nonatomic,strong)UILabel *cardLabelOne;
@property(nonatomic,strong)UILabel *cardLabelTwo;
//分割线
@property(nonatomic,strong)UIImageView *cardViewIne;

@property (strong, nonatomic) HXPhotoManager *managerOne;

@property (strong, nonatomic) HXPhotoView *photoViewOne;
//图片数组
@property (strong, nonatomic) NSMutableArray<UIImage *> *imageArrayOne;
//文字说明
@property(nonatomic,strong)UILabel *titleLabelThree;
//无编码模块
@property(nonatomic,strong)UIView *noCodeViews;

//无编码-门店名称
@property(nonatomic,strong)UITextField *storeName;
//无编码-门店位置
@property(nonatomic,strong)UILabel *storePosition;
@property(nonatomic,strong)NSString *lnglat;
@property(nonatomic,strong)NSString *adCode;
//无编码-门店地址
@property(nonatomic,strong)UITextField *storeAddress;
//名片View
@property(nonatomic,strong)UIView *noCardView;

@property (strong, nonatomic) HXPhotoManager *managerTwo;

@property (strong, nonatomic) HXPhotoView *photoViewTwo;
//图片数组
@property (strong, nonatomic) NSMutableArray<UIImage *> *imageArrayTwo;
//红包提示
@property(nonatomic,strong)UIView *warnView;
@end

@implementation WZNewJionStoreController
#pragma mark -lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = [UIColor whiteColor];
    _codeType = @"0";
    //创建控件
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.titleOne];
    [self.scrollView addSubview:self.labelOne];
    [self.scrollView addSubview:self.labelTwo];
    //导航栏
    [self.view addSubview:self.tabView];
    [self.tabView addSubview:self.closeButton];
    [self.tabView addSubview:self.ineView];
    [self.tabView addSubview:self.barTitle];
    [self.view addSubview:self.button];
    //姓名view
    [self.scrollView addSubview:self.viewOne];
    [self.viewOne addSubview:self.nameLabel];
    [self.viewOne addSubview:self.name];
    [self.viewOne addSubview:self.nameIne];
    //第二个View
    [self.scrollView addSubview:self.viewTwo];
    [self.viewTwo addSubview:self.codeImageView];
    [self.viewTwo addSubview:self.codeImageViewIne];
    [self.viewTwo addSubview:self.codeButton];
    [self.viewTwo addSubview:self.ineCode];
    [self.viewTwo addSubview:self.noCodeButton];
    [self.viewTwo addSubview:self.ineNoCode];
    //有编码
    [self.viewTwo addSubview:self.codeViews];
    [self.codeViews addSubview:self.codeLabel];
    [self.codeViews addSubview:self.code];
    [self.codeViews addSubview:self.codeInes];
    [self.codeViews addSubview:self.cardViewOne];
    [self.cardViewOne addSubview:self.cardLabelOne];
    [self.cardViewOne addSubview:self.cardLabelTwo];
    [self.cardViewOne addSubview:self.cardViewIne];
    [self.codeViews addSubview:self.titleLabelThree];
    [self loadPhotoView];
    [self noCodeView];
    [self setManoys];
    _scrollView.contentSize = CGSizeMake(0, _viewTwo.fHeight+kApplicationStatusBarHeight+_viewTwo.fY-76);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //红包提示
    if ([_warnFlag isEqual:@"1"]) {
        [self tipsView:_rewardPrice];
        dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC);
        dispatch_after(timer, dispatch_get_main_queue(), ^(void){
            //关闭弹框
            [GKCover hide];
        });
    }
}

-(void)setManoys{
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-JF_BOTTOM_SPACE-49);
    self.tabView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kApplicationStatusBarHeight+44);
    self.closeButton.frame = CGRectMake(15,kApplicationStatusBarHeight+14, 15, 15);
    self.ineView.frame = CGRectMake(0, self.tabView.fHeight, self.tabView.fWidth, 1);
    self.titleOne.frame = CGRectMake(15, kApplicationStatusBarHeight+30,200, 18);
    self.viewOne.frame = CGRectMake(15, kApplicationStatusBarHeight+160, self.view.fWidth-30, 88);
    self.viewTwo.frame = CGRectMake(15, self.viewOne.fY+self.viewOne.fHeight+10, self.view.fWidth-30, 587);
    self.codeImageView.frame = CGRectMake(-3, 0, self.view.fWidth-24, 139);
    
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.scrollView.mas_top).offset(-kApplicationStatusBarHeight);
        make.width.offset(self.view.fWidth);
        make.height.offset(304*n);
    }];
    [self.barTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tabView.mas_centerX);
        make.top.equalTo(self.tabView.mas_top).mas_offset(kApplicationStatusBarHeight+14);
        make.height.offset(17);
    }];
    [self.labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(self.titleOne.mas_bottom).offset(13);
        make.width.offset(210*n);
    }];
    [self.labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(15);
        make.top.equalTo(self.labelOne.mas_bottom).offset(9);
        make.width.offset(210*n);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.offset(JF_BOTTOM_SPACE+49);
        make.width.offset(self.view.fWidth);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewOne.mas_left).offset(15);
        make.top.equalTo(self.viewOne.mas_top).offset(15);
        make.height.offset(13);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewOne.mas_left).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-60);
    }];
    [self.nameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewOne.mas_left).offset(15);
        make.top.equalTo(self.name.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-60);
    }];
    [self.codeImageViewIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTwo.mas_left).offset(5);
        make.top.equalTo(self.viewTwo.mas_top).offset(48);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-40);
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTwo.mas_left).offset(15);
        make.top.equalTo(self.viewTwo.mas_top).mas_offset(8);
        make.height.offset(35);
        make.width.offset(50);
    }];
    [self.ineCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTwo.mas_left).offset(15);
        make.top.equalTo(self.codeButton.mas_bottom).offset(4);
        make.height.offset(2);
        make.width.offset(50);
    }];
    [self.noCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeButton.mas_right).offset(40);
        make.top.equalTo(self.viewTwo.mas_top).mas_offset(8);
        make.height.offset(35);
        make.width.offset(50);
    }];
    [self.ineNoCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeButton.mas_right).offset(40);
        make.top.equalTo(self.noCodeButton.mas_bottom).offset(4);
        make.height.offset(2);
        make.width.offset(50);
    }];
    //有编码
    [self.codeViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTwo.mas_left);
        make.top.equalTo(self.ineCode.mas_bottom);
        make.height.offset(438);
        make.width.offset(self.view.fWidth-30);
    }];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeViews.mas_left).offset(15);
        make.top.equalTo(self.codeViews.mas_top).offset(15);
        make.height.offset(13);
    }];
    [self.code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeViews.mas_left).offset(15);
        make.top.equalTo(self.codeLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-60);
    }];
    [self.codeInes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeViews.mas_left).offset(15);
        make.top.equalTo(self.code.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-60);
    }];
    [self.cardViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeViews.mas_left);
        make.top.equalTo(self.codeImageView.mas_bottom).offset(10);
        make.width.offset(self.view.fWidth-30);
    }];
    [self.cardLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardViewOne.mas_left).offset(15);
        make.top.equalTo(self.cardViewOne.mas_top).offset(15);
        make.height.offset(16);
    }];
    [self.cardLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardLabelOne.mas_right).offset(7);
        make.top.equalTo(self.cardViewOne.mas_top).offset(20);
        make.height.offset(11);
    }];
    [self.cardViewIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardViewOne.mas_left).offset(5);
        make.top.equalTo(self.cardViewOne.mas_top).offset(46);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-40);
    }];
    [self.titleLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeViews.mas_left).offset(2);
        make.top.equalTo(self.cardViewOne.mas_bottom).offset(10);
        make.width.offset(self.view.fWidth-30);
    }];
    
}

#pragma mark - scrollViewDelegate
//滑动触发事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y - 5;
    
    [self setNeedsStatusBarAppearanceUpdate];
    if(self.scrollView.contentOffset.y >= 5){
        self.tabView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        self.ineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        self.barTitle.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        
    }else{
        self.tabView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
        self.ineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0];
        self.barTitle.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha: 0];
        
    }
}
#pragma mark -HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    if (photoView.tag == 10) {
        [self.cardViewOne mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(CGRectGetMaxY(frame)+23);
        }];
        
    }
    if(photoView.tag == 20){
        [self.noCardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(CGRectGetMaxY(frame)+23);
        }];
    }
   
}
//获取图片数组
-(void)photoListViewControllerDidDone:(HXPhotoView *)photoView allList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    self.imageArrayOne = [NSMutableArray array];
    self.imageArrayTwo = [NSMutableArray array];
    if (photoView.tag == 10) {
        for (HXPhotoModel *modelOne in allList) {
            [self.imageArrayOne addObject:modelOne.thumbPhoto];
        }
        
    }
    if(photoView.tag == 20){
        for (HXPhotoModel *modelOne in allList) {
            [self.imageArrayTwo addObject:modelOne.thumbPhoto];
        }
        
    }
    
    
}
#pragma mark -UITextFieldDelegate
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    
    _scrollView.contentSize = CGSizeMake(0, _scrollView.contentSize.height+200);
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    _scrollView.contentSize = CGSizeMake(0, _scrollView.contentSize.height-200);
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_name == textField) {
        if (toBeString.length>16) {
            return NO;
        }
    }
    if (_code == textField) {
        if (toBeString.length>15) {
            return NO;
        }
    }
    if (toBeString.length>20) {
        return NO;
    }
    return YES;
}

#pragma mark -touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_name resignFirstResponder];
    [_code resignFirstResponder];
    [_storeName resignFirstResponder];
    [_storeAddress resignFirstResponder];
    
    
}
-(void)touches{
    [_name resignFirstResponder];
    [_code resignFirstResponder];
    [_storeName resignFirstResponder];
    [_storeAddress resignFirstResponder];
}
#pragma mark -点击事件
//关闭页面
-(void)closeButtons{
    if([_types isEqual:@"1"]){
        //跳转至我的页面
        WZTabBarController *tar = [[WZTabBarController alloc] init];
        tar.selectedViewController = [tar.viewControllers objectAtIndex:2];
        [self.navigationController presentViewController:tar animated:YES completion:nil];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
//有编码按钮
-(void)codeButton:(UIButton *)button{
    [self touches];
    [_noCodeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineNoCode.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineCode.backgroundColor = UIColorRBG(255, 204, 0);
    _codeImageView.frame = CGRectMake(-3, 0, self.view.fWidth-26, 139);
    _codeImageView.image = [UIImage imageNamed:@"rz_background_3"];
    _codeType = @"0";
    [_codeViews setHidden:NO];
    [_noCodeViews setHidden:YES];
    //设置文字
    _labelOne.attributedText = [[NSAttributedString alloc] initWithString:@"1.门店编码是经喜APP合作门店的唯一标识，你可咨询你的店长或者同事"];
    _labelTwo.text = @"2.门店认证成功后报备客户，成交后可赚取佣金；APP内做悬赏赚取现金奖励";
    [_button setTitle:@"加入门店" forState:UIControlStateNormal];
    [_button removeTarget:self action:@selector(jionStoreNoCode:) forControlEvents:UIControlEventTouchUpInside];
    [_button addTarget:self action:@selector(jionStore:) forControlEvents:UIControlEventTouchUpInside];
    _scrollView.contentSize = CGSizeMake(0, _viewTwo.fHeight+kApplicationStatusBarHeight+_viewTwo.fY-76);
}
//无编码按钮
-(void)noCodeButton:(UIButton *)button{
    [self touches];
    [_codeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineCode.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineNoCode.backgroundColor = UIColorRBG(255, 204, 0);
    _codeImageView.frame = CGRectMake(-3, 0, self.view.fWidth-26, 286);
    _codeImageView.image = [UIImage imageNamed:@"rz_wbm_pic_2"];
    _codeType = @"1";
    [_codeViews setHidden:YES];
    [_noCodeViews setHidden:NO];
    //设置文字
    NSString *strs = @"1.上传名片正反面照片，拍摄时确保名片边缘完整，字体清晰，亮度均匀";
    NSMutableAttributedString *attributedString =  [self changeSomeText:@"边缘完整，字体清晰，亮度均匀" inText:strs withColor:UIColorRBG(255, 168, 66)];
    _labelOne.text = @"";
    _labelOne.attributedText = attributedString;
    _labelTwo.text = @"2.照片必须真实拍摄，不得使用复印件和扫描件";
    
    [_button setTitle:@"提交审核" forState:UIControlStateNormal];
    [_button removeTarget:self action:@selector(jionStore:) forControlEvents:UIControlEventTouchUpInside];
    [_button addTarget:self action:@selector(jionStoreNoCode:) forControlEvents:UIControlEventTouchUpInside];
    _scrollView.contentSize = CGSizeMake(0, _viewTwo.fHeight+kApplicationStatusBarHeight+_viewTwo.fY);
    
}
//无编码-选择位置
-(void)positionButton:(UIButton *)button{
    [self touches];
    ZDMapController *map = [[ZDMapController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
    map.addrBlock = ^(NSMutableDictionary *address) {
        _storePosition.textColor = UIColorRBG(51, 51, 51);
        _storePosition.text = [address valueForKey:@"address"];
        _lnglat = [address valueForKey:@"lnglat"];
        _adCode = [address valueForKey:@"adcode"];
    };
}
//加入门店-有编码提交
-(void)jionStore:(UIButton *)button{
    NSString *name = _name.text;
    if ([name isEqual:@""]||!name) {
        [SVProgressHUD showInfoWithStatus:@"名字不能为空"];
        return;
    }
    NSString *code = _code.text;
    if ([code isEqual:@""]||!code) {
        [SVProgressHUD showInfoWithStatus:@"门店编码不能为空"];
        return;
    }
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"realname"] = name;
    paraments[@"storeCode"] = code;
    paraments[@"type"] = @"1";
    button.enabled = NO;
    [WZLoadDateSeviceOne postUpdatePhotoSuccess:^(NSDictionary *dic) {

        NSString *code = [dic valueForKey:@"code"];
        button.enabled = YES;
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"你已加入门店，请在系统消息里领取你的新人专属现金红包"];
            NSDictionary *data = [dic valueForKey:@"data"];
            //保存数据
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //认证状态
            [defaults setObject:[data valueForKey:@"status"] forKey:@"realtorStatus"];
            //门店名称
            [defaults setObject:[data valueForKey:@"storeName"] forKey:@"storeName"];
            //门店编码
            [defaults setObject:[data valueForKey:@"storeCode"] forKey:@"storeCode"];
            //门店位置
            [defaults setObject:[data valueForKey:@"cityName"] forKey:@"cityName"];
            //门店地址
            [defaults setObject:[data valueForKey:@"addr"] forKey:@"addr"];
            [defaults synchronize];
            
            if ([_types isEqual:@"1"]) {
                //跳转至我的页面
                //跳转至我的页面
                WZTabBarController *tar = [[WZTabBarController alloc] init];
                
                AppDelegate *appdelegateE = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appdelegateE.window.rootViewController = tar;
                tar.selectedIndex = 2;
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            }else{
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            
            
        }else{
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } andFail:^(NSString *str) {
        
        button.enabled = YES;
    } parament:paraments URL:@"/sysUser/companyAuthentication" imageArray:_imageArrayOne];
    
}
//加入门店-无编码提交
-(void)jionStoreNoCode:(UIButton *)button{
    NSString *name = _name.text;
    if ([name isEqual:@""]||!name) {
        [SVProgressHUD showInfoWithStatus:@"名字不能为空"];
        return;
    }
    NSString *storeName = _storeName.text;
    if ([storeName isEqual:@""]||!storeName) {
        [SVProgressHUD showInfoWithStatus:@"门店名称不能为空"];
        return;
    }
    if ([_adCode isEqual:@""]||!_adCode) {
        [SVProgressHUD showInfoWithStatus:@"门店位置不能为空"];
        return;
    }
    if ([_lnglat isEqual:@""]||!_lnglat) {
        [SVProgressHUD showInfoWithStatus:@"门店位置不能为空"];
        return;
    }
    NSString *address = _storeAddress.text;
    if ([address isEqual:@""]||!address) {
        [SVProgressHUD showInfoWithStatus:@"门店地址不能为空"];
        return;
    }
    if (_imageArrayTwo.count<=0) {
        [SVProgressHUD showInfoWithStatus:@"名片不能为空"];
        return;
    }
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"提交中"];
    button.enabled = NO;
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    parament[@"realname"] = name;
    parament[@"address"] = address;
    parament[@"storeName"] = storeName;
    parament[@"lnglat"] = _lnglat;
    parament[@"adCode"] = _adCode;
    parament[@"type"] = @"1";
    [WZLoadDateSeviceOne postUpdatePhotoSuccess:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        button.enabled = YES;
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            //保存审核状态
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"1" forKey:@"realtorStatus"];
            [defaults synchronize];
            //审核页面
            WZExamineController *exVc = [[WZExamineController alloc] init];
            exVc.titleLabel = @"资料上传成功，审核通过后，你可在系统\n消息里领取你的新人专属现金红包，耐心等待审核...";
            WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:exVc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
        }else{
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } andFail:^(NSString *str) {
        [SVProgressHUD dismiss];
        button.enabled = YES;
    } parament:parament URL:@"/sysAuthenticationInfo/cardAuthentication" imageArray:_imageArrayTwo];
    
}
#pragma mark -getter
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
-(UIView *)tabView{
    if (!_tabView) {
        _tabView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kApplicationStatusBarHeight+44)];
        _tabView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
        
    }
    return _tabView;
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"rz_background"];
        [_imageView sizeToFit];
    }
    return _imageView;
}
-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtons) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setEnlargeEdge:44];
    }
    return _closeButton;
}
-(UIView *)ineView{
    if (!_ineView) {
        _ineView = [[UIView alloc] init];
        _ineView.backgroundColor =[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0];
    }
    return _ineView;
}
-(UILabel *)barTitle{
    if (!_barTitle) {
        _barTitle= [[UILabel alloc] init];
        _barTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
        _barTitle.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:0];
        _barTitle.text = @"加入门店";
    }
    return _barTitle;
}
-(UILabel *)titleOne{
    if (!_titleOne) {
        _titleOne = [[UILabel alloc] init];
        _titleOne.text = @"加入门店";
        _titleOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
        _titleOne.textColor = UIColorRBG(255, 168, 66);
    }
    return _titleOne;
}
-(UILabel *)labelOne{
    if (!_labelOne) {
        _labelOne = [[UILabel alloc] init];
        _labelOne.text = @"1.门店编码是经喜APP合作门店的唯一标识，你可咨询你的店长或者同事";
        _labelOne.numberOfLines = 2;
        _labelOne.textColor = UIColorRBG(159, 129, 79);
        _labelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    }
    return _labelOne;
}
-(UILabel *)labelTwo{
    if (!_labelTwo) {
        _labelTwo = [[UILabel alloc] init];
        _labelTwo.text = @"2.门店认证成功后报备客户，成交后可赚取佣金；APP内做悬赏赚取现金奖励";
        _labelTwo.numberOfLines = 2;
        _labelTwo.textColor = UIColorRBG(159, 129, 79);
        _labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    }
    return _labelTwo;
}
-(UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button.backgroundColor = UIColorRBG(255, 204, 0);
        [_button setTitle:@"加入门店" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(jionStore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
//姓名view
-(UIView *)viewOne{
    if (!_viewOne) {
        _viewOne = [[UIView alloc] init];
        _viewOne.backgroundColor = [UIColor whiteColor];
        _viewOne.layer.shadowColor = UIColorRBG(60, 48, 0).CGColor;
        _viewOne.layer.shadowRadius = 3.0;
        _viewOne.layer.shadowOpacity = 0.12;
        _viewOne.layer.cornerRadius = 5.0;
    }
    return _viewOne;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"名字";
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        _nameLabel.textColor = UIColorRBG(51, 51, 51);
    }
    return _nameLabel;
}
-(UITextField *)name{
    if (!_name) {
        _name = [[UITextField alloc] init];
        _name.placeholder = @"填写个人姓名";
        _name.textColor = UIColorRBG(68, 68, 68);
        _name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        _name.delegate = self;
        _name.keyboardType = UIKeyboardTypeDefault;
        _name.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _name;
}
-(UIView *)nameIne{
    if (!_nameIne) {
        _nameIne = [[UIView alloc] init];
        _nameIne.backgroundColor = UIColorRBG(255, 236, 134);
    }
    return _nameIne;
}
//第二个View
-(UIView *)viewTwo{
    if (!_viewTwo) {
        _viewTwo = [[UIView alloc] init];
    }
    return _viewTwo;
}
-(UIImageView *)codeImageView{
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] init];
        _codeImageView.image = [UIImage imageNamed:@"rz_background_3"];
    }
    return _codeImageView;
}
-(UIView *)codeImageViewIne{
    if (!_codeImageViewIne) {
        _codeImageViewIne = [[UIView alloc] init];
        _codeImageViewIne.backgroundColor = UIColorRBG(238, 238, 238);
    }
    return _codeImageViewIne;
}
-(UIButton *)codeButton{
    if (!_codeButton) {
        _codeButton = [[UIButton alloc] init];
        [_codeButton setTitle:@"有编码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        _codeButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [_codeButton addTarget:self action:@selector(codeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}
-(UIView *)ineCode{
    if (!_ineCode) {
        _ineCode = [[UIView alloc] init];
        _ineCode.backgroundColor = UIColorRBG(255, 204, 0);
    }
    return _ineCode;
}
-(UIButton *)noCodeButton{
    if (!_noCodeButton) {
        _noCodeButton = [[UIButton alloc] init];
        [_noCodeButton setTitle:@"无编码" forState:UIControlStateNormal];
        [_noCodeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
        _noCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        [_noCodeButton addTarget:self action:@selector(noCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noCodeButton;
}
-(UIView *)ineNoCode{
    if (!_ineNoCode) {
        _ineNoCode = [[UIView alloc] init];
        _ineNoCode.backgroundColor = [UIColor clearColor];
    }
    return _ineNoCode;
}
//有编码
-(UIView *)codeViews{
    if (!_codeViews) {
        _codeViews = [[UIView alloc] init];
    }
    return _codeViews;
}
-(UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.text = @"门店编码";
        _codeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        _codeLabel.textColor = UIColorRBG(51, 51, 51);
    }
    return _codeLabel;
}
-(UITextField *)code{
    if (!_code) {
        _code = [[UITextField alloc] init];
        _code.placeholder = @"填写门店编码";
        _code.textColor = UIColorRBG(68, 68, 68);
        _code.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        _code.delegate = self;
        _code.keyboardType = UIKeyboardTypeNumberPad;
        _code.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _code;
}
-(UIView *)codeInes{
    if (!_codeInes) {
        _codeInes = [[UIView alloc] init];
        _codeInes.backgroundColor = UIColorRBG(255, 236, 134);
    }
    return _codeInes;
}
-(UIView *)cardViewOne{
    if (!_cardViewOne) {
        _cardViewOne = [[UIView alloc] init];
        _cardViewOne.backgroundColor = [UIColor whiteColor];
        _cardViewOne.layer.shadowColor = UIColorRBG(60, 48, 0).CGColor;
        _cardViewOne.layer.shadowRadius = 3.0;
        _cardViewOne.layer.shadowOpacity = 0.12;
        _cardViewOne.layer.cornerRadius = 5.0;
        _cardViewOne.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _cardViewOne;
}
-(UILabel *)cardLabelOne{
    if (!_cardLabelOne) {
        _cardLabelOne = [[UILabel alloc] init];
        _cardLabelOne.text = @"上传名片";
        _cardLabelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _cardLabelOne.textColor = UIColorRBG(51, 51, 51);
    }
    return _cardLabelOne;
}
-(UILabel *)cardLabelTwo{
    if (!_cardLabelTwo) {
        _cardLabelTwo = [[UILabel alloc] init];
        _cardLabelTwo.text = @"（名片、工牌、门店门头等）";
        _cardLabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        _cardLabelTwo.textColor = UIColorRBG(204, 204, 204);
    }
    return _cardLabelTwo;
}
-(UIImageView *)cardViewIne{
    if (!_cardViewIne) {
        _cardViewIne = [[UIImageView alloc] init];
        _cardViewIne.image = [UIImage imageNamed:@"rz_ine"];
    }
    return _cardViewIne;
}
- (HXPhotoManager *)managerOne {
    if (!_managerOne) {
        _managerOne = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.configuration.openCamera = NO;
        _managerOne.configuration.saveSystemAblum = YES;
        _managerOne.configuration.photoMaxNum = 6; //
        _managerOne.configuration.videoMaxNum = 0;  //
        _managerOne.configuration.maxNum = 6;
        _managerOne.configuration.reverseDate = YES;
        //        _manager.configuration.selectTogether = NO;
    }
    return _managerOne;
}

-(void)loadPhotoView{
    _photoViewOne = [HXPhotoView photoManager:self.managerOne];
    _photoViewOne.frame = CGRectMake(kPhotoViewMargin, 62, self.view.fWidth - 30 - kPhotoViewMargin * 2, 0);
    _photoViewOne.lineCount = 3;
    _photoViewOne.spacing = 24;
    _photoViewOne.previewStyle = HXPhotoViewPreViewShowStyleDark;
    _photoViewOne.outerCamera = YES;
    _photoViewOne.delegate = self;
    _photoViewOne.deleteImageName = @"delete";
    _photoViewOne.addImageName = @"zd_camera";
    _photoViewOne.backgroundColor = [UIColor whiteColor];
    _photoViewOne.tag = 10;
    [_cardViewOne addSubview:_photoViewOne];
    [_photoViewOne refreshView];
}
-(UILabel *)titleLabelThree{
    if (!_titleLabelThree) {
        _titleLabelThree = [[UILabel alloc] init];
        _titleLabelThree.text = @"";
        _titleLabelThree.textColor = UIColorRBG(153, 153, 153);
        _titleLabelThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        NSString *strs = @"3.请上传名片正反面照片，拍摄时确保各项信息清晰可见，亮度均匀，易于识别\n4.照片必须真实拍摄，不得使用复印件和扫描件";
        NSMutableAttributedString *attributedString =  [self changeSomeText:@"清晰可见，亮度均匀，易于识别" inText:strs withColor:UIColorRBG(255, 108, 0)];
        _titleLabelThree.attributedText = attributedString;
        _titleLabelThree.numberOfLines = 0;
    }
    return _titleLabelThree;
}
- (HXPhotoManager *)managerTwo {
    if (!_managerTwo) {
        _managerTwo = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.configuration.openCamera = NO;
        _managerTwo.configuration.saveSystemAblum = YES;
        _managerTwo.configuration.photoMaxNum = 6; //
        _managerTwo.configuration.videoMaxNum = 0;  //
        _managerTwo.configuration.maxNum = 6;
        _managerTwo.configuration.reverseDate = YES;
        //        _manager.configuration.selectTogether = NO;
    }
    return _managerTwo;
}
//红包提示
-(void)tipsView:(NSString *)rewardPrice{
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(183, 105);
    _warnView = view;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 183, 105)];
    if ([rewardPrice isEqual:@"9.99"]) {
        imageView.image = [UIImage imageNamed:@"zc_hbts_2"];
    }else if([rewardPrice isEqual:@"8.88"]){
        imageView.image = [UIImage imageNamed:@"zc_hbts"];
    }
    [view addSubview:imageView];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
}
#pragma mark -无编码模块
-(void)noCodeView{
    UIView *view = [[UIView alloc] init];
    _noCodeViews = view;
    [view setHidden:YES];
    [_viewTwo addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewTwo.mas_left);
        make.top.equalTo(_ineCode.mas_bottom);
        make.height.offset(430);
        make.width.offset(self.view.fWidth-26);
    }];
    //门店名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"门店名称";
    nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    nameLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(view.mas_top).offset(15);
        make.height.offset(13);
    }];
    UITextField *storeName = [[UITextField alloc] init];
    storeName.placeholder = @"必填";
    storeName.textColor = UIColorRBG(68, 68, 68);
    storeName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storeName.delegate = self;
    storeName.keyboardType = UIKeyboardTypeDefault;
    storeName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _storeName = storeName;
    [view addSubview:storeName];
    [storeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *nameIne = [[UIView alloc] init];
    nameIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:nameIne];
    [nameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(storeName.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    //门店位置
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.text = @"门店位置";
    positionLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    positionLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:positionLabel];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameIne.mas_top).offset(15);
        make.height.offset(13);
    }];
    UILabel *storePosition = [[UILabel alloc] init];
    storePosition.text = @"点击选择";
    storePosition.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storePosition.textColor = UIColorRBG(204, 204, 204);
    _storePosition = storePosition;
    [view addSubview:storePosition];
    [storePosition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionLabel.mas_bottom).offset(18);
        make.height.offset(13);
        make.width.offset(273);
    }];
    //下划线
    UIView  *positionIne = [[UIView alloc] init];
    positionIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:positionIne];
    [positionIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(storePosition.mas_bottom).offset(15);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-97);
    }];
    UIImageView *poImage = [[UIImageView alloc] init];
    poImage.image = [UIImage imageNamed:@"zc_map"];
    [view addSubview:poImage];
    [poImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storePosition.mas_right).offset(14);
        make.top.equalTo(positionLabel.mas_bottom).offset(11);
        make.height.offset(26);
        make.width.offset(20);
    }];
    UIButton *position = [[UIButton alloc] init];
    [position addTarget:self action:@selector(positionButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:position];
    [position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *positionInes = [[UIView alloc] init];
    positionInes.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:positionInes];
    [positionInes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storePosition.mas_right).offset(14);
        make.top.equalTo(poImage.mas_bottom).offset(9);
        make.height.offset(1);
        make.width.offset(21);
    }];
    //门店地址
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"门店地址";
    addressLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    addressLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionIne.mas_bottom).offset(15);
        make.height.offset(13);
    }];
    UITextField *storeAddress = [[UITextField alloc] init];
    storeAddress.placeholder = @"必填";
    storeAddress.textColor = UIColorRBG(68, 68, 68);
    storeAddress.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storeAddress.delegate = self;
    storeAddress.keyboardType = UIKeyboardTypeDefault;
    storeAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
    _storeAddress = storeAddress;
    [view addSubview:storeAddress];
    [storeAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(addressLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *addressIne = [[UIView alloc] init];
    addressIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:addressIne];
    [addressIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(storeAddress.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    
    UIView *noCardView = [[UIView alloc] init];
    noCardView.backgroundColor = [UIColor whiteColor];
    noCardView.layer.shadowColor = UIColorRBG(60, 48, 0).CGColor;
    noCardView.layer.shadowRadius = 3.0;
    noCardView.layer.shadowOpacity = 0.12;
    noCardView.layer.cornerRadius = 5.0;
    noCardView.layer.shadowOffset = CGSizeMake(0, 0);
    _noCardView = noCardView;
    [view addSubview:noCardView];
    [noCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(_codeImageView.mas_bottom).offset(10);
        make.height.offset(174);
        make.width.offset(self.view.fWidth-30);
    }];
    //名片
    UILabel *cardLabel = [[UILabel alloc] init];
    cardLabel.text = @"上传名片";
    cardLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    cardLabel.textColor = UIColorRBG(51, 51, 51);
    [noCardView addSubview:cardLabel];
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noCardView.mas_left).offset(15);
        make.top.equalTo(noCardView.mas_top).offset(15);
        make.height.offset(16);
    }];
    
    UILabel *cardLabelTwo = [[UILabel alloc] init];
    cardLabelTwo.text = @"（名片、工牌、门店门头等）";
    cardLabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    cardLabelTwo.textColor = UIColorRBG(102, 102, 102);
    [noCardView addSubview:cardLabelTwo];
    [cardLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardLabel.mas_right).offset(7);
        make.top.equalTo(noCardView.mas_top).offset(20);
        make.height.offset(11);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"rz_ine"];
    [noCardView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noCardView.mas_left).offset(5);
        make.top.equalTo(noCardView.mas_top).offset(46);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-40);
    }];
    
    _photoViewTwo = [HXPhotoView photoManager:self.managerTwo];
    _photoViewTwo.frame = CGRectMake(kPhotoViewMargin, 62, self.view.fWidth - 30 - kPhotoViewMargin * 2, 0);
    _photoViewTwo.lineCount = 3;
    _photoViewTwo.spacing = 24;
    _photoViewTwo.previewStyle = HXPhotoViewPreViewShowStyleDark;
    _photoViewTwo.outerCamera = YES;
    _photoViewTwo.delegate = self;
    _photoViewTwo.deleteImageName = @"delete";
    _photoViewTwo.addImageName = @"zd_camera";
    _photoViewTwo.backgroundColor = [UIColor whiteColor];
    _photoViewTwo.tag = 20;
    [noCardView addSubview:_photoViewTwo];
    [_photoViewTwo refreshView];
    
}

- (NSMutableAttributedString *)changeSomeText:(NSString *)str inText:(NSString *)result withColor:(UIColor *)color {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:result];
    NSRange colorRange = NSMakeRange([[attributeStr string] rangeOfString:str].location,[[attributeStr string] rangeOfString:str].length);
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    
    return attributeStr;
}

@end

