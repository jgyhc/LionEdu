//
//  BLTrainSubTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/20.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainSubTableViewCell.h"
#import "ZLCollectionViewDelegateManager.h"
#import <Masonry.h>


@interface BLTrainSubTableViewCell ()<ZLCollectionViewDelegateManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) ZLCollectionViewDelegateManager *manager;

@property (nonatomic, strong) UIView *silderView;

@property (nonatomic, strong) BLTrainBaseTitleModel *currentModel;

@property (nonatomic, assign) NSInteger index;
@end

@implementation BLTrainSubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _currentIndex = 0;
    _index = 0;
//    _leftSpace.constant = 15;
    [self.collectionView addSubview:self.silderView];
//    [self.silderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.collectionView.mas_bottom);
//        make.left.mas_equalTo(self.collectionView.mas_left).mas_offset(15);
//        make.height.mas_equalTo(2);
//        make.width.mas_equalTo(78);
//    }];
    [self.collectionView insertSubview:self.silderView atIndex:1000];
//    [self.collectionView layoutIfNeeded];
}

- (IBAction)allSelectEvent:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectAllEvent:)]) {
        [self.delegate didSelectAllEvent:_index];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSArray<ZLCollectionViewSectionModel *> *)dataSource:(ZLCollectionViewDelegateManager *)manager {
    return self.list;
}

- (void)didSelectRowAtModel:(ZLCollectionViewRowModel *)model manager:(ZLCollectionViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if (_currentModel == model.data) {
        return;
    }
//    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    CGRect cellRect = cell.frame;
//    [self leftSpace:cellRect.origin.x + 15 width:cellRect.size.width-30];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateEventWithIndex:model:)]) {
        [self.delegate updateEventWithIndex:indexPath.row model:_model[indexPath.row]];
    }
    _index = indexPath.row;
    _currentModel.isSelect = NO;
    BLTrainBaseTitleModel *data = model.data;
    data.isSelect = YES;
    _currentModel = data;
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLCollectionViewSectionModel *sectionModel = self.list[indexPath.section];
    ZLCollectionViewRowModel *rowModel = sectionModel.items[indexPath.row];
    if (rowModel.data == _currentModel) {
        CGRect cellRect = cell.frame;
        [self leftSpace:cellRect.origin.x + 15 width:cellRect.size.width-30];
    }
}

- (void)setModel:(NSArray<BLTrainBaseTitleModel *> *)model {
    _model = model;
    NSMutableArray *array = [NSMutableArray array];
    [model enumerateObjectsUsingBlock:^(BLTrainBaseTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:({
            ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
            rowModel.identifier = @"BLTrainSubTitleCollectionViewCell";
            rowModel.cellSize = CGSizeMake(obj.textWidth + 30, 45);
            rowModel.data = obj;
            if (idx == 0 && !_currentModel) {
                _currentModel = obj;
                _currentModel.isSelect = YES;
            }
            rowModel;
        })];
        
    }];
    _list = @[({
        ZLCollectionViewSectionModel *sectionModel = [ZLCollectionViewSectionModel new];
        sectionModel.items = array;
        sectionModel.minimumLineSpacing = 0;
        sectionModel.minimumInteritemSpacing = 0;
        sectionModel;
    })];
    [self.manager reloadData];
}

- (ZLCollectionViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLCollectionViewDelegateManager alloc] init];
        _manager.collectionView = self.collectionView;
        _manager.delegate = self;
    }
    return _manager;
}

- (void)leftSpace:(CGFloat)leftSpcae width:(CGFloat)width {
    [UIView animateWithDuration:0.3 animations:^{
        self.silderView.frame = CGRectMake(leftSpcae, 43, width, 2);
    }];
    
}

- (UIView *)silderView {
    if (!_silderView) {
        _silderView = [[UIView alloc] initWithFrame:CGRectMake(15, 43, 78, 2)];
        _silderView.backgroundColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0];
    }
    return _silderView;
}

@end
