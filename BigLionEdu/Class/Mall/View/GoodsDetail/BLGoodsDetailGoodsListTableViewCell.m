//
//  BLGoodsDetailGoodsListTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGoodsDetailGoodsListTableViewCell.h"
#import "ZLCollectionViewDelegateManager.h"
#import "AdaptScreenHelp.h"
#import "BLGoodsModel.h"
#import "BLMallIndexCollectionViewCell.h"
#import "BLGoodsDetailViewController.h"
#import "NTCatergory.h"

@interface BLGoodsDetailGoodsListTableViewCell ()<ZLCollectionViewDelegateManagerDelegate, BLMallIndexCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) ZLCollectionViewDelegateManager *manager;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation BLGoodsDetailGoodsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLMallIndexCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BLMallIndexCollectionViewCell"];
    [self.manager reloadData];
    self.datas = [NSMutableArray array];
    self.backgroundColor = self.contentView.backgroundColor = self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)BLMallIndexCollectionViewCellDidSelect:(BLGoodsModel *)tmodel {
    BLGoodsDetailViewController *viewControlelr = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLGoodsDetailViewController"];
    viewControlelr.goodsId = [NSString stringWithFormat:@"%ld", tmodel.Id];
    [self.viewController.navigationController  pushViewController:viewControlelr animated:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)setModel:(NSArray *)model {
    _model = model;
    [self.datas removeAllObjects];
    for (NSInteger i = 0; i < model.count; i ++) {
        ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
        rowModel.identifier = @"BLMallIndexCollectionViewCell";
        rowModel.cellSize = CGSizeMake(flexibleWidth(167), flexibleWidth(251));
        rowModel.data = model[i];
        rowModel.delegate = self;
        [self.datas addObject:rowModel];
    }
    [self.manager reloadData];
}

- (NSArray<ZLCollectionViewSectionModel *> *)dataSource:(ZLCollectionViewDelegateManager *)manager {
    return @[({
        ZLCollectionViewSectionModel *sectionModel = [ZLCollectionViewSectionModel new];
        sectionModel.items = self.datas;
        sectionModel.insets = UIEdgeInsetsMake(14, flexibleWidth(15), 14, flexibleWidth(15));
        sectionModel.minimumLineSpacing = flexibleWidth(10);
        sectionModel.minimumInteritemSpacing = flexibleWidth(10);
        sectionModel;
    })];
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
