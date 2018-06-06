//
//  LJCollectionViewFlowLayout.m
//  Linkage
//

#import "LJCollectionViewFlowLayout.h"

@implementation LJCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // UICollectionViewLayoutAttributes：我称它为collectionView中的item（包括cell和header、footer这些）的《结构信息》
    // 截取到父类所返回的数组（里面放的是当前屏幕所能展示的item的结构信息），并转化成不可变数组
    NSMutableArray *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
//    // 创建存索引的数组，无符号（正整数），无序（不能通过下标取值），不可重复（重复的话会自动过滤）
//    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
//    
//    // 遍历superArray，得到一个当前屏幕中所有的section数组
//    for (UICollectionViewLayoutAttributes *attributes in superArray)
//    {
//        //如果当前的元素分类是一个cell，将cell所在的分区section加入数组，重复的话会自动过滤
//        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
//        {
//            [noneHeaderSections addIndex:attributes.indexPath.section];
//        }
//    }
//    
//    // 遍历superArray，将当前屏幕中拥有的header的section从数组中移除，得到一个当前屏幕中没有header的section数组
//    // 正常情况下，随着手指往上移，header脱离屏幕会被系统回收而cell尚在，也会触发该方法
//    for (UICollectionViewLayoutAttributes *attributes in superArray)
//    {
//        // 如果当前的元素是一个header，将header所在的section从数组中移除
//        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
//        {
//            [noneHeaderSections removeIndex:attributes.indexPath.section];
//        }
//    }
//    
//    // 遍历当前屏幕中没有header的section数组
//    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *_Nonnull stop) {
//        
//        // 取到当前section中第一个item的indexPath
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
//        // 获取当前section在正常情况下已经离开屏幕的header结构信息
//        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
//        
//        // 如果当前分区确实有因为离开屏幕而被系统回收的header
//        if (attributes)
//        {
//            // 将该header结构信息重新加入到superArray中去
//            [superArray addObject:attributes];
//        }
//    }];
    
    //从第二个循环到最后一个
    for(int i = 1; i < [superArray count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = superArray[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = superArray[i - 1];
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = 15;
        //前一个cell的最右边
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    // 转换回不可变数组，并返回
    return [superArray copy];
}

//// return YES：表示一旦滑动就实时调用上面这个layoutAttributesForElementsInRect:方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    
    return NO;
}

@end
