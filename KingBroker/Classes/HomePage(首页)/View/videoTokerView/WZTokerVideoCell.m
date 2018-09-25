//
//  WZTokerVideoCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "UIView+Frame.h"
#import "WZTokerVideoCell.h"
#import "WZTokerVideoItem.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WZTokerVItem.h"
#import "WZSharePhoneCollectionView.h"
#import "WZVideoListLabelController.h"
#import "UIViewController+WZFindController.h"
@interface WZTokerVideoCell()
@end
@implementation WZTokerVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = UIColorRBG(255, 204, 0);
    _title.textColor = UIColorRBG(51, 51, 51);
    
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(WZTokerVideoItem *)item{
    _item = item;
     [_videoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _name = item.name;
    _id = item.id;
    _title.text = _name;
    if (![item.name isEqual:@""]) {
        _titleLabel.text = [_name substringToIndex:1];
    }
    _vclist = item.vclist;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(12, 0, 15, 15);
    layout.minimumInteritemSpacing = 6;
    layout.itemSize = CGSizeMake(100, 130);
    WZSharePhoneCollectionView *phoneCv = [[WZSharePhoneCollectionView alloc] initWithFrame:CGRectMake(0, 0, _videoView.fWidth, _videoView.fHeight) collectionViewLayout:layout];
    phoneCv.array = _vclist;
    [phoneCv reloadData];
    [_videoView addSubview:phoneCv];
 
}

- (IBAction)findMore:(UIButton *)sender {
    WZVideoListLabelController *videoView = [[WZVideoListLabelController alloc] init];
    videoView.classfiyId = _id;
    videoView.type = @"1";
    videoView.navigationItem.title = _name;
    UIViewController *Vc = [UIViewController viewController:self.superview.superview];
    [Vc.navigationController pushViewController:videoView animated:YES];
}
@end
