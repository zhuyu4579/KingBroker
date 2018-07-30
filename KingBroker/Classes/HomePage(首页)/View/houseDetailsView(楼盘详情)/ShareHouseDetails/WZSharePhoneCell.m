//
//  WZSharePhoneCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "UIView+Frame.h"
#import "WZShareDetailsItem.h"
#import "WZSharePhoneCell.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZSharePhoneCollectionView.h"
#import "WZHouseShareDetailController.h"
#import "UIViewController+WZFindController.h"
@implementation WZSharePhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
     float n = [UIScreen mainScreen].bounds.size.width/375.0;
    [_shareButton setEnlargeEdge:44];
    _videoHeight.constant = 145*n;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(WZShareDetailsItem *)item{
    _item = item;
    [_phoneView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    _projectTaskId = item.projectTaskId;
    NSArray *urls = item.attachmentIds;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(100*n, 145*n);
    WZSharePhoneCollectionView *phoneCv = [[WZSharePhoneCollectionView alloc] initWithFrame:CGRectMake(0, 0, _phoneView.fWidth, 145*n) collectionViewLayout:layout];
    phoneCv.array = urls;
    [_phoneView addSubview:phoneCv];
    phoneCv.selectPhone = ^(NSString *url) {
        _url = url;
    };
    _title.text = item.title;
    NSString *type = item.type;
     _type = type;
    if ([type isEqual:@"1"]) {
        _taskImage.image = [UIImage imageNamed:@""];
    }else if([type isEqual:@"2"]){
        _taskImage.image = [UIImage imageNamed:@"label"];
    }
}


@end
