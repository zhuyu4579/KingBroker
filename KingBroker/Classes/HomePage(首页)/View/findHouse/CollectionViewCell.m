//
//  CollectionViewCell.m
//  Linkage
//


#import "WZScreenItem.h"
#import "CollectionViewCell.h"
#import <Masonry.h>
#import <MJExtension.h>
@interface CollectionViewCell ()

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //self.name = [[UILabel alloc] initWithFrame:CGRectMake(15,20, self.frame.size.width + 6, 25)];
        self.name = [[UILabel alloc] init];
        self.name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        self.name.layer.cornerRadius = 12.5;
        self.name.clipsToBounds = YES;
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.userInteractionEnabled = NO;
        [self.contentView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(0);
            make.top.equalTo(self.mas_top).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.height.mas_offset(25);
        }];
        
    }
    return self;
}

- (void)setModel:(SubCategoryModel *)model
{
    _model = model;
    self.name.text = model.label;
    if (model.flag) {
        self.name.textColor = [UIColor whiteColor];
        self.name.backgroundColor = UIColorRBG(3, 133, 219);
    }else{
        self.name.textColor = UIColorRBG(102, 102, 102);
        self.name.backgroundColor = UIColorRBG(242, 242, 242);
    }
    
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    CGRect frame = [self.name.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.name.frame.size.height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.name.font,NSFontAttributeName, nil] context:nil];
    
    frame.size.height = 25; 
    frame.size.width +=20;
    attributes.frame = frame;
    return attributes;
}

@end
