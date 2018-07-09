//
//  WZBoardingDetailsController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/30.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZBoardingDetailsController.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "GKCover.h"
#import "WZReportController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "NSString+LCExtension.h"
#import "WZHouseDatisController.h"
#import "UIBarButtonItem+Item.h"
@interface WZBoardingDetailsController ()<UIScrollViewDelegate>
@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,weak)UILabel *name;
@property (nonatomic,weak)UILabel *telephone;
@property (nonatomic,weak)UILabel *ItemName;

@property (nonatomic,weak)UIView *ineView;
@property (nonatomic,weak)UIButton *telephoneButton;
@property (nonatomic,weak)NSString *codeimage;
@property (nonatomic,weak)UIButton *codeButton;
@property (nonatomic,weak)UIButton *ItemButton;
//view2

@property (nonatomic,weak)UIView *viewTwo;
@property (nonatomic,weak)UIView *ineViewFour;
@property (nonatomic,weak)UIView *ineViewFive;
@property (nonatomic,weak)UIView *viewThree;

@property (nonatomic,weak)UILabel *stateTitle1;
@property (nonatomic,weak)UILabel *stateTitle2;
@property (nonatomic,weak)UILabel *stateTitle3;
@property (nonatomic,weak)UIImageView *imageView1;
@property (nonatomic,weak)UIImageView *imageView2;
@property (nonatomic,weak)UIImageView *imageView3;
@property (nonatomic,weak)UIView *imageIneOne;
@property (nonatomic,weak)UIView *imageIneTwo;
@property (nonatomic,weak)UILabel *recordTime;
@property (nonatomic,weak)UILabel *state;
@property (nonatomic,weak)UILabel *stateDescribe;
//viw3
@property (nonatomic,strong)NSString *boaringTimeLabel;
@property (nonatomic,strong)UILabel *ciryLabel;
@property (nonatomic,strong)UILabel *popelSumLable;
@property (nonatomic,strong)UILabel *modeLable;
@property (nonatomic,strong)UILabel *provideLunchLable;
//提交按钮
@property(nonatomic,strong)UIButton *comButton;
//订单记录
@property (nonatomic,strong)NSArray *list;
//其他数据
@property (nonatomic,strong)NSDictionary *order;
//二维码
@property (nonatomic,strong)UIImageView *codeImage;
@property (nonatomic,strong)UIView *codeView;
@property (nonatomic,weak)UILabel *names;
@property (nonatomic,weak)UILabel *telephones;
@property (nonatomic,weak)UILabel *ItemNames;
@property (nonatomic,weak)UILabel *titles;
//订单详情的条数
@property (nonatomic,assign) NSInteger n;
//预计上客时间
@property (nonatomic,weak)UILabel *label1;
//项目ID
@property(nonatomic,strong)NSString *itemId;
//项目签约状态
@property(nonatomic,strong)NSString *sginStatus;
//项目电话
@property(nonatomic,strong)NSString *proTelphone;
@end

@implementation WZBoardingDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    [self setNarItems];
    //创建模块控件
    [self setupController];
    //数据请求
    [self loadData];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
}
//请求数据
-(void)loadData{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.requestSerializer.timeoutInterval = 30;
    
        //申明返回的结果是json类型
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //申明请求的数据是json类型
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        //防止返回值为null
        ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"orderId"] = _ID;
        
        NSString *url = [NSString stringWithFormat:@"%@/order/detail",HTTPURL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            
            if ([code isEqual:@"200"]) {
                NSMutableDictionary *data = [responseObject valueForKey:@"data"];
                NSArray *list = [data valueForKey:@"list"];
                _list = list;
                NSDictionary *order = [data valueForKey:@"order"];
                _order = order;
                //二维码
                NSString *url = [data valueForKey:@"url"];
                if (url) {
                     [_codeImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"OR-code_2"]];
                }
                //设置参数
                [self setValueData];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                 [NSString isCode:self.navigationController code:code];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }];
    
}
//设置参数
-(void)setValueData{
    _sginStatus = [_order valueForKey:@"sginStatus"];
    _proTelphone = [_order valueForKey:@"proTelphone"];
    //客户姓名
    _name.text = [_order valueForKey:@"clientName"];
    _names.text = [_order valueForKey:@"clientName"];
    //客户电话
    _telephone.text = [_order valueForKey:@"missContacto"];
     _telephones.text = [_order valueForKey:@"missContacto"];
    NSString *status = [_order valueForKey:@"dealStatus"];
    //项目名
    _ItemName.text = [_order valueForKey:@"projectName"];
    _ItemNames.text = [_order valueForKey:@"projectName"];
    //项目ID
    _itemId = [_order valueForKey:@"projectId"];
    //设置按钮
    NSString *verify = [_order valueForKey:@"verify"];
  
    //订单记录
    NSInteger statu = [status integerValue];
    NSInteger ver = [verify integerValue];
    if (statu == 3 && [verify isEqual:@"2"]) {
        _comButton.enabled = NO;
        _comButton.backgroundColor = UIColorRBG(158, 158, 158);
        [_comButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comButton setTitle:@"成交审核中" forState:UIControlStateNormal];
    }
    
    if (statu == 1) {
        if (ver == 3) {
            _codeButton.enabled = YES;
            [_codeButton setHidden:NO];
            _imageView1.backgroundColor = UIColorRBG(3, 133, 219);
            _stateTitle1.textColor = UIColorRBG(3, 133, 219);
        }else{
            _imageView1.backgroundColor = UIColorRBG(221, 221, 221);
            _stateTitle1.textColor = UIColorRBG(153, 153, 153);
        }
    }
    if (statu == 2) {
        _imageIneOne.backgroundColor = UIColorRBG(3, 133, 219);
        _imageView1.backgroundColor = UIColorRBG(3, 133, 219);
        _stateTitle1.textColor = UIColorRBG(3, 133, 219);
        _comButton.backgroundColor = UIColorRBG(3, 133, 219);
        _codeButton.enabled = NO;
        [_codeButton setHidden:YES];
        [_comButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comButton setTitle:@"发起成交" forState: UIControlStateNormal];
        [_comButton removeTarget:self action:@selector(BoardingCilck) forControlEvents:UIControlEventTouchUpInside];
        [_comButton addTarget:self action:@selector(LaunchDealCilck) forControlEvents:UIControlEventTouchUpInside];
        if (ver == 3) {
            _imageView2.backgroundColor = UIColorRBG(3, 133, 219);
            _stateTitle2.textColor = UIColorRBG(3, 133, 219);
        }else{
            _imageIneOne.backgroundColor = UIColorRBG(221, 221, 221);
            _imageView2.backgroundColor = UIColorRBG(221, 221, 221);
            _stateTitle2.textColor = UIColorRBG(153, 153, 153);
        }
        
    }
    if (statu == 3) {
        _imageIneTwo.backgroundColor = UIColorRBG(3, 133, 219);
        _imageIneOne.backgroundColor = UIColorRBG(3, 133, 219);
        _imageView1.backgroundColor = UIColorRBG(3, 133, 219);
        _stateTitle1.textColor = UIColorRBG(3, 133, 219);
        _imageView2.backgroundColor = UIColorRBG(3, 133, 219);
        _stateTitle2.textColor = UIColorRBG(3, 133, 219);
        if (ver == 3) {
            _comButton.enabled = NO;
            _comButton.hidden = YES;
            _scrollView.fHeight = self.view.fHeight;
            _imageView3.backgroundColor = UIColorRBG(3, 133, 219);
            _stateTitle3.textColor = UIColorRBG(3, 133, 219);
        }
        if([verify isEqual:@"4"]){
            _comButton.backgroundColor = UIColorRBG(3, 133, 219);
            [_comButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_comButton setTitle:@"发起成交" forState: UIControlStateNormal];
            _comButton.enabled = YES;
            _imageView3.backgroundColor = UIColorRBG(221, 221, 221);
            _stateTitle3.textColor = UIColorRBG(153, 153, 153);
        }
    }
    if (statu == 4) {
        if (ver == 3) {
            [_comButton setTitle:@"重新报备" forState: UIControlStateNormal];
            [_comButton removeTarget:self action:@selector(BoardingCilck) forControlEvents:UIControlEventTouchUpInside];
            [_comButton addTarget:self action:@selector(NewReportCilck) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //设置条数
    _n = _list.count;
    //删除所有子控件
    [[_viewTwo viewWithTag:80] removeFromSuperview];
    _viewTwo.fHeight = 106;
    _ineViewFive.fHeight = 0;
    _viewTwo.fHeight += _n*79;
    _ineViewFive.fHeight += 79*(_n-1);
    _viewThree.fY = 141+_viewTwo.fHeight+10;
    _scrollView.contentSize = CGSizeMake(0, _viewThree.fY+166);
    //根据数据条数绘制记录
    UIView *view = [[UIView alloc] init];
    view.frame = _viewTwo.bounds;
    view.tag = 80;
    [_viewTwo addSubview:view];
    for (int i = 0; i < _n; i++) {
        
        //绘制记录时间
        UILabel *recordTime = [[UILabel alloc] init];
        recordTime.text = [[_list[i] valueForKey:@"time"] substringFromIndex:5];
        recordTime.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
        recordTime.textColor = UIColorRBG(153, 153, 153);
        [view addSubview:recordTime];
        self.recordTime = recordTime;
        [recordTime setNumberOfLines:0];
        [recordTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewTwo.mas_left).with.offset(15);
            make.top.equalTo(_ineViewFour.mas_bottom).with.offset(23+79*(i));
            make.width.mas_offset(37);
        }];
        UIImageView *imagePoint = [[UIImageView alloc] init];
        imagePoint.backgroundColor = UIColorRBG(221, 221, 221);
        imagePoint.layer.masksToBounds =YES;
        imagePoint.layer.cornerRadius = 10.0/2;
        [view addSubview:imagePoint];
        [imagePoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewTwo.mas_left).with.offset(76);
            make.top.equalTo(_ineViewFour.mas_bottom).with.offset(25+79*i);
            make.width.mas_offset(10);
            make.height.mas_offset(10);
        }];
        NSArray *stateArray = @[@"已报备", @"已上客", @"发起成交",@"已失效"];
        NSString *state1 = [_list[i] valueForKey:@"dealStatus"];
        NSString *verify = [_list[i] valueForKey:@"verify"];
        int states = [state1 intValue];
        
        UILabel *state = [[UILabel alloc] init];
        if ([verify isEqual:@"4"]) {
            state.text = stateArray[3];
        }else{
            state.text = stateArray[states-1];
        }
        
        state.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        state.textColor = UIColorRBG(153, 153, 153);
        [view addSubview:state];
        self.state = state;
        [state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imagePoint.mas_right).with.offset(7);
            make.top.equalTo(_ineViewFour.mas_bottom).with.offset(24+79*i);
            make.height.mas_offset(13);
        }];
        UILabel *stateDescribe = [[UILabel alloc] init];
        stateDescribe.text = [_list[i] valueForKey:@"examineLog"];
        stateDescribe.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        stateDescribe.textColor = UIColorRBG(153, 153, 153);
        [view addSubview:stateDescribe];
        self.stateDescribe = stateDescribe;
        [stateDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imagePoint.mas_right).with.offset(7);
            make.top.equalTo(state.mas_bottom).with.offset(10);
            make.height.mas_offset(13);
        }];
    
    }
    
    //预计上客时间
    _label1.text =  [NSString stringWithFormat:@"预计上客时间：%@",[_order valueForKey:@"boardingPlanes"]];
    //出发城市
     _ciryLabel.text = [NSString stringWithFormat:@"出发城市：%@",[_order valueForKey:@"departureCity"]];
     _popelSumLable.text = [NSString stringWithFormat:@"出行人数：%@",[_order valueForKey:@"partPersonNum"]];
    
    NSString *par = [_order valueForKey:@"partWay"];
    if ([par isEqual:@"1"]) {
         _modeLable.text = [NSString stringWithFormat:@"到访方式：驾车"];
    }else if([par isEqual:@"2"]){
        _modeLable.text = [NSString stringWithFormat:@"到访方式：班车"];
    }else{
        _modeLable.text = [NSString stringWithFormat:@"到访方式：其他"];
    }
   
    NSString *lunchNum = [_order valueForKey:@"lunchNum"];
   
    _provideLunchLable.text = [NSString stringWithFormat:@"用餐人数：%@",lunchNum];
    
   
}
#pragma mark -创建控件
-(void)setupController{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(self.view.fX, self.view.fY, self.view.fWidth, self.view.fHeight-49);
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = UIColorRBG(242, 242, 242);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    //创建第一个view
    UIView *viewOne = [[UIView alloc] init];
    viewOne.frame = CGRectMake(0,kApplicationStatusBarHeight+45,scrollView.fWidth,130);
    viewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewOne];
    //创建第一个view中的控件
    UILabel *name = [[UILabel alloc] init];
    name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    name.textColor = UIColorRBG(68, 68, 68);
    [viewOne addSubview:name];
    self.name = name;
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).with.offset(15);
        make.top.equalTo(viewOne.mas_top).with.offset(20);
        make.height.mas_offset(14);
    }];
    UILabel *telephone = [[UILabel alloc] init];
    telephone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    telephone.textColor = UIColorRBG(153, 153, 153);
    [viewOne addSubview:telephone];
    self.telephone = telephone;
    [telephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).with.offset(15);
        make.top.equalTo(name.mas_bottom).with.offset(15);
        make.height.mas_offset(12);
    }];

    
        UIButton *codeButton = [[UIButton alloc] init];
        [codeButton setEnlargeEdge:44];
        [codeButton setBackgroundImage:[UIImage imageNamed:@"OR-code"] forState:UIControlStateNormal];
        codeButton.enabled = NO;
        [codeButton setHidden:YES];
        [codeButton addTarget:self action:@selector(codeButtons) forControlEvents:UIControlEventTouchUpInside];
        [viewOne addSubview:codeButton];
        self.codeButton = codeButton;
        [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewOne.mas_right).with.offset(-43);
            make.top.equalTo(viewOne.mas_top).with.offset(32);
            make.height.mas_offset(23);
            make.width.mas_offset(23);
        }];
    
    //绘制线
    UIView *ineViewTwo = [[UIView alloc] initWithFrame: CGRectMake(0,79, SCREEN_WIDTH, 1)];
    ineViewTwo.backgroundColor =UIColorRBG(242, 242, 242);
    [viewOne addSubview:ineViewTwo];
    
    UILabel *ItemName = [[UILabel alloc] init];
    
    ItemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    ItemName.textColor = UIColorRBG(68, 68, 68);
    [viewOne addSubview:ItemName];
    self.ItemName = ItemName;
    if (self.ItemName.text.length>11) {
        [ItemName setNumberOfLines:0];
        [ItemName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewOne.mas_left).with.offset(15);
            make.top.equalTo(ineViewTwo.mas_bottom).with.offset(6);
            make.width.mas_offset(200);
        }];
    }else{
        [ItemName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewOne.mas_left).with.offset(15);
            make.top.equalTo(ineViewTwo.mas_bottom).with.offset(17);
            make.height.mas_offset(13);
        }];
    }
    
    UIButton *ItemButton = [[UIButton alloc] init];
    [ItemButton setEnlargeEdge:44];
    [ItemButton setBackgroundImage:[UIImage imageNamed:@"more_unfold"] forState:UIControlStateNormal];
    [ItemButton addTarget:self action:@selector(ItemButtons:) forControlEvents:UIControlEventTouchUpInside];
    [viewOne addSubview:ItemButton];
    self.ItemButton = ItemButton;
    [ItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewOne.mas_right).with.offset(-15);
        make.top.equalTo(ineViewTwo.mas_bottom).with.offset(16);
        make.height.mas_offset(17);
        make.width.mas_offset(9);
    }];
    UIView *views = [[UIView alloc] init];
    views.frame = CGRectMake(0,195,375,1);
    views.backgroundColor = UIColorRBG(242, 242, 242);
    [self.view addSubview:views];
    
    
    //创建第二个view的高由状态改变每次整加77
    UIView *viewTwo = [[UIView alloc] init];
    viewTwo.backgroundColor = [UIColor whiteColor];
    viewTwo.frame = CGRectMake(0,viewOne.fHeight+10,scrollView.fWidth,106);
    _viewTwo = viewTwo;
    UILabel *OrderLabel = [[UILabel alloc] init];
    OrderLabel.text = @"订单记录";
    OrderLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    OrderLabel.textColor = UIColorRBG(68, 68, 68);
    [viewTwo addSubview:OrderLabel];
    [OrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).with.offset(15);
        make.top.equalTo(viewTwo.mas_top).with.offset(16);
        make.height.mas_offset(15);
    }];
    //绘制线
    UIView *ineViewThree = [[UIView alloc] initWithFrame: CGRectMake(0,44, SCREEN_WIDTH, 1)];
    ineViewThree.backgroundColor =UIColorRBG(242, 242, 242);
    [viewTwo addSubview:ineViewThree];
    //圆形图片
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(32,58, 13, 13)];
    
    imageView1.backgroundColor = UIColorRBG(221, 221, 221);
    
    _imageView1 = imageView1;
    
    imageView1.layer.masksToBounds =YES;
    
    imageView1.layer.cornerRadius = 13.0/2;
    
    [viewTwo addSubview:imageView1];
    //状态文字
    UILabel *stateTitle = [[UILabel alloc] init];
    
    stateTitle.text = @"报备";
    
    stateTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    
    stateTitle.textColor = UIColorRBG(153, 153, 153);
    
    _stateTitle1 = stateTitle;
    
    [viewTwo addSubview:stateTitle];
    
    [stateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(viewTwo.mas_left).with.offset(26);
        
        make.top.equalTo(imageView1.mas_bottom).with.offset(10);
        
        make.height.mas_offset(13);
        
    }];
    
  
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((viewTwo.fWidth-13)/2.0,58, 13, 13)];
    
    imageView2.backgroundColor = UIColorRBG(221, 221, 221);
    
    imageView2.layer.masksToBounds =YES;
    
    imageView2.layer.cornerRadius = 13.0/2;
    
    self.imageView2 = imageView2;
    
    [viewTwo addSubview:imageView2];
    
    //绘制线
    UIView *imageIneOne = [[UIView alloc] initWithFrame: CGRectMake(imageView1.fX+imageView1.fWidth,64, imageView2.fX-imageView1.fX-imageView1.fWidth, 1)];
    
    imageIneOne.backgroundColor =UIColorRBG(221, 221, 221);
    
    self.imageIneOne = imageIneOne;
    
    [viewTwo addSubview:imageIneOne];
    
    
    UILabel *stateTitle2 = [[UILabel alloc] init];
    
    stateTitle2.text = @"上客";
    
    stateTitle2.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    
    stateTitle2.textColor = UIColorRBG(153, 153, 153);
    
    [viewTwo addSubview:stateTitle2];
    
    self.stateTitle2 = stateTitle2;
    
    [stateTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(imageView2.mas_centerX);
        
        make.top.equalTo(imageView2.mas_bottom).with.offset(10);
        
        make.height.mas_offset(13);
        
    }];
    
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(viewTwo.fWidth-45,58, 13, 13)];
    
    imageView3.backgroundColor = UIColorRBG(221, 221, 221);
    
    imageView3.layer.masksToBounds =YES;
    
    imageView3.layer.cornerRadius = 13.0/2;
    
    self.imageView3 = imageView3;
    
    [viewTwo addSubview:imageView3];
    
    //绘制线
    UIView *imageIneTwo = [[UIView alloc] initWithFrame: CGRectMake(imageView2.fX+imageView2.fWidth,64, imageView3.fX-(imageView2.fX+imageView2.fWidth), 1)];
    
    imageIneTwo.backgroundColor =UIColorRBG(221, 221, 221);
    
    self.imageIneTwo = imageIneTwo;
    
    [viewTwo addSubview:imageIneTwo];
    
    UILabel *stateTitle3 = [[UILabel alloc] init];
    
    stateTitle3.text = @"成交";
    
    stateTitle3.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    
    stateTitle3.textColor = UIColorRBG(153, 153, 153);
    
    [viewTwo addSubview:stateTitle3];
    
    self.stateTitle3 = stateTitle3;

    [stateTitle3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(imageView3.mas_centerX);
        
        make.top.equalTo(imageView3.mas_bottom).with.offset(10);
        
        make.height.mas_offset(13);
        
    }];
    
    //绘制线
    UIView *ineViewFour = [[UIView alloc] initWithFrame: CGRectMake(0,105, SCREEN_WIDTH, 1)];
    ineViewFour.backgroundColor =UIColorRBG(242, 242, 242);
    _ineViewFour = ineViewFour;
    [viewTwo addSubview:ineViewFour];
    
   
    //绘制线
    UIView *ineViewFive = [[UIView alloc] initWithFrame: CGRectMake(80.5,141, 1, 0)];
    ineViewFive.backgroundColor =UIColorRBG(221, 221, 221);
    [viewTwo addSubview:ineViewFive];
    _ineViewFive = ineViewFive;
    //确认按钮
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"上客" forState: UIControlStateNormal];
    _comButton = confirmButton;
    [confirmButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.backgroundColor = UIColorRBG(3, 133, 219);
    [confirmButton addTarget:self action:@selector(BoardingCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(49);
    }];

    [scrollView addSubview:viewTwo];
    //创建第三个view
    UIView *viewThree = [[UIView alloc] init];
    viewThree.backgroundColor = [UIColor whiteColor];
    viewThree.frame = CGRectMake(0,141+viewTwo.fHeight+10,scrollView.fWidth,156);
    _viewThree = viewThree;
    [scrollView addSubview:viewThree];
    
    UILabel *label1 = [[UILabel alloc] init];
    
    label1.text = [NSString stringWithFormat:@"预计上客时间：%@",_boaringTimeLabel];
    label1.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _label1 = label1;
    label1.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(viewThree.mas_top).with.offset(20);
        make.height.mas_offset(12);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    
    _ciryLabel = label2;
   
    label2.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(label1.mas_bottom).with.offset(15);
        make.height.mas_offset(12);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    _popelSumLable = label3;
   
    label3.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    label3.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(label2.mas_bottom).with.offset(15);
        make.height.mas_offset(12);
    }];
    
    UILabel *label4 = [[UILabel alloc] init];
    _modeLable = label4;
    
    label4.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    label4.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(label3.mas_bottom).with.offset(15);
        make.height.mas_offset(12);
    }];
    
    UILabel *label5 = [[UILabel alloc] init];
    _provideLunchLable = label5;
   
    label5.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    label5.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(label4.mas_bottom).with.offset(15);
        make.height.mas_offset(12);
    }];
    
    scrollView.contentSize = CGSizeMake(0, viewThree.fY+166);
    
    [self setCodeViews];
}
#pragma mark -上客按钮
-(void)BoardingCilck{
    
    if ([_sginStatus isEqual:@"1"]) {
        [_titles setHidden:YES];
    }else{
        [_titles setHidden:NO];
    }
    long orderCreateTime = [[_order valueForKey:@"orderCreateTime"] longLongValue];
    if (orderCreateTime != 0 ) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[date timeIntervalSince1970]*1000;
        long time1 = time - orderCreateTime;
        if (time1 >30*60*1000) {
            [GKCover translucentWindowCenterCoverContent:_codeView animated:YES notClick:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:@"订单创建时间小于30分钟"];
        }
    }
}
//创建二维码的view
-(void)setCodeViews{
    //创建一个view
    UIView *codeView = [[UIView alloc] init];
    codeView.fSize = CGSizeMake(330, 480);
    codeView.backgroundColor = [UIColor clearColor];
    _codeView = codeView;
    UIView *codeView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 330, 440)];
    codeView1.backgroundColor = [UIColor whiteColor];
    [codeView addSubview:codeView1];
    UILabel *name = [[UILabel alloc] init];
    _names = name;
    name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    name.textColor = UIColorRBG(68, 68, 68);
    [codeView1 addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(codeView1.mas_top).with.offset(16);
        make.height.mas_offset(17);
    }];
    UILabel *telephone = [[UILabel alloc] init];
    _telephones = telephone;
    telephone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    telephone.textColor = UIColorRBG(153, 153, 153);
    [codeView1 addSubview:telephone];
    [telephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(name.mas_bottom).with.offset(16);
        make.height.mas_offset(12);
    }];
    UILabel *ItemName = [[UILabel alloc] init];
    _ItemNames = ItemName;
    ItemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    ItemName.textColor = UIColorRBG(68, 68, 68);
    [codeView1 addSubview:ItemName];
    [ItemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(telephone.mas_bottom).with.offset(9);
        make.height.mas_offset(13);
    }];
    UIView *codeView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 99, 290, 290)];
    codeView2.backgroundColor = UIColorRBG(3, 133, 219);
    [codeView addSubview:codeView2];
    
    UIImageView *codeImage = [[UIImageView alloc] init];
    codeImage.image = [UIImage imageNamed:@"OR-code_2"];
    [codeView2 addSubview:codeImage];
    _codeImage = codeImage;
    [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView2.mas_left).with.offset(48);
        make.top.equalTo(codeView2.mas_top).with.offset(48);
        make.width.mas_offset(196);
        make.height.mas_offset(196);
    }];
    UILabel *Titles = [[UILabel alloc] init];
    Titles.text = @"你所在门店未和该项目签约，可能无法结佣";
    Titles.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [Titles setHidden:YES];
    _titles = Titles;
    Titles.textColor = [UIColor redColor];
    [codeView1 addSubview:Titles];
    [Titles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.bottom.equalTo(codeView1.mas_bottom).with.offset(-20);
        make.height.mas_offset(13);
    }];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(156, 461, 19, 19)];
    [closeButton setEnlargeEdge:44];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"icon_shut"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:closeButton];
}
#pragma mark -二维码
-(void)codeButtons{
    if ([_sginStatus isEqual:@"1"]) {
        [_titles setHidden:YES];
    }else{
        [_titles setHidden:NO];
    }
    long orderCreateTime = [[_order valueForKey:@"orderCreateTime"] longLongValue];
    if (orderCreateTime != 0 ) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[date timeIntervalSince1970]*1000;
        long time1 = time - orderCreateTime;
        if (time1 >30*60*1000) {
            [GKCover translucentWindowCenterCoverContent:_codeView animated:YES notClick:YES];
            //创造通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAlerts) name:@"BoaringVC" object:nil];
        }else{
            [SVProgressHUD showInfoWithStatus:@"订单创建时间小于30分钟"];
        }
    }
    
}
#pragma mark -关闭二维码弹窗
-(void)closeAlert{
    [self loadData];
    [GKCover hide];
}
-(void)closeAlerts{
    [SVProgressHUD showInfoWithStatus:@"您好,您报备的订单已上客成功"];
    [self loadData];
    [GKCover hide];
}
#pragma mark -项目按钮
-(void)ItemButtons:(UIButton *)button{
    WZHouseDatisController *datis = [[WZHouseDatisController alloc] init];
    datis.ID = _itemId;
    [self.navigationController pushViewController:datis animated:YES];
}
#pragma mark -发起成交
-(void)LaunchDealCilck{
    NSString *boaringId = _ID;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = boaringId;
    NSString *url = [NSString stringWithFormat:@"%@/order/dealOrder",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"发起成交成功"];
    
            [self loadData];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
#pragma mark -重新报备
-(void)NewReportCilck{
    WZReportController *report = [[WZReportController alloc] init];
    report.itemName = self.ItemName.text;
    report.itemID = _itemId;
    report.sginStatus = _sginStatus;
    report.telphone = _proTelphone;
    report.types = @"1";
    report.name = _name.text;
    report.phone = _telephone.text;
    [self.navigationController pushViewController:report animated:YES];
}
#pragma mark -设置导航条
-(void)setNarItems{
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

@end
