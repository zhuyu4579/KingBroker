//
//  WZQuestionController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZQuestionController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZNEWHTMLController.h"
@interface WZQuestionController ()

@end

@implementation WZQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"问题小秘";
    _QTitle.textColor = UIColorRBG(102, 102, 102);
    [_buttonOne setEnlargeEdge:15];
    [_buttonTwo setEnlargeEdge:15];
    [_buttonThree setEnlargeEdge:15];
    [_buttonFour setEnlargeEdge:15];
    [_buttonFive setEnlargeEdge:15];
    [_buttonSix setEnlargeEdge:15];
    _headHeight.constant = kApplicationStatusBarHeight+44+16;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (IBAction)actionButton:(UIButton *)sender {
    NSInteger tag = sender.tag;
    WZNEWHTMLController *html = [[WZNEWHTMLController alloc] init];
    NSArray *urlArray = @[[NSString stringWithFormat:@"%@/apph5/faq1.html",HTTPH5],[NSString stringWithFormat:@"%@/apph5/faq2.html",HTTPH5],[NSString stringWithFormat:@"%@/apph5/faq3.html",HTTPH5],[NSString stringWithFormat:@"%@/apph5/faq4.html",HTTPH5],[NSString stringWithFormat:@"%@/apph5/faq5.html",HTTPH5],[NSString stringWithFormat:@"%@/apph5/faq6.html",HTTPH5]];
    html.url = urlArray[tag-10];
    [self.navigationController pushViewController:html animated:YES];
}

@end
