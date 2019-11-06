//
//  BLIntroductionClassTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLIntroductionClassTableViewCell.h"
#import "ZLCollectionViewDelegateManager.h"

@interface BLIntroductionClassTableViewCell ()<ZLCollectionViewDelegateManagerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *pageButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) ZLCollectionViewDelegateManager *manager;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, assign) NSInteger index;
@end

@implementation BLIntroductionClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLClassDetailTeacherCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BLClassDetailTeacherCollectionViewCell"];
    [self.manager reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    [self.pageButton setTitle:[NSString stringWithFormat:@"%ld/%ld", index, self.list.count] forState:UIControlStateNormal];
}

- (void)setModel:(BLClassDetailModel *)model {
    _model = model;
    NSMutableArray *items = [NSMutableArray array];
    [_model.tutorDTOS enumerateObjectsUsingBlock:^(BLClassDetailTeacherModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:({
            ZLCollectionViewRowModel *row = [ZLCollectionViewRowModel new];
            row.identifier = @"BLClassDetailTeacherCollectionViewCell";
            row.data = obj;
            row.cellSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 142);
            row;
        })];
    }];
    [self.pageButton setTitle:[NSString stringWithFormat:@"%@/%ld", @"1", items.count] forState:UIControlStateNormal];
    self.list = items;
    [self.manager reloadData];
}

- (NSArray<ZLCollectionViewSectionModel *> *)dataSource:(ZLCollectionViewDelegateManager *)manager {
    return @[({
        ZLCollectionViewSectionModel *sectionModel = [ZLCollectionViewSectionModel new];
        sectionModel.items = self.list;
        sectionModel;
    }) ];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView manager:(ZLCollectionViewDelegateManager *)manager {
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.index = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width + 1;
}

- (ZLCollectionViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLCollectionViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.collectionView = self.collectionView;
    }
    return _manager;
}

@end
