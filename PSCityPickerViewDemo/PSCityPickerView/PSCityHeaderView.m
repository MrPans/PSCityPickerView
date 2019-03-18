//
//  PSCityHeaderView.m
//  PSCityPickerViewDemo
//
//  Created by 喻远 on 2018/11/2.
//  Copyright © 2018 Shengpan. All rights reserved.
//

#import "PSCityHeaderView.h"

@interface PSCityHeaderCell : UICollectionViewCell
@property (nonatomic, strong) NSString *title;
@end

@interface PSCityHeaderView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation PSCityHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.collectionView.collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        CGSize size = CGSizeMake(self.frame.size.width / 5, self.frame.size.height);
        if (!CGSizeEqualToSize(layout.itemSize, size)) {
            layout.itemSize = size;
        }
        self.collectionView.collectionViewLayout = layout;
        [self.collectionView reloadData];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}




- (void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = titles;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.frame.size.width / 5, self.frame.size.height);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.frame
                                                              collectionViewLayout:layout];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:PSCityHeaderCell.class
           forCellWithReuseIdentifier:PSCityHeaderCell.description];
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end

@interface PSCityHeaderCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PSCityHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.text = self.title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    }
    return _titleLabel;
}

@end
