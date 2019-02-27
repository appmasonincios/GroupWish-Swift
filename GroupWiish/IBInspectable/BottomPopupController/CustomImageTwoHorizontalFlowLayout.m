//
//  CustomImageTwoHorizontalFlowLayout.m
//  GroupWiish
//
//  Created by apple on 26/02/19.
//  Copyright © 2019 Chaitanya. All rights reserved.
//

#import "CustomImageTwoHorizontalFlowLayout.h"

@implementation CustomImageTwoHorizontalFlowLayout

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.minimumLineSpacing = 1.0;
        self.minimumInteritemSpacing = 1.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (CGSize)itemSize
{
    NSInteger numberOfColumns = 2;
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - (numberOfColumns - 1)) / numberOfColumns;
    return CGSizeMake(itemWidth,itemWidth);
}

@end
