//
//  BLTrainHotTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainHotTableViewCell.h"
#import "ZLTableViewDelegateManager.h"

@interface BLTrainHotTableViewCell ()<ZLTableViewDelegateManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@property (nonatomic, strong) ZLTableViewSectionModel *sectionModel;

@property (nonatomic, assign) NSTimeInterval interval;

@property (nonatomic, strong) NSTimer *myTimer;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, assign) NSInteger currentRowIndex;
@end

@implementation BLTrainHotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _tableView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5].CGColor;
    _tableView.layer.shadowOffset = CGSizeMake(0,2);
    _tableView.layer.shadowOpacity = 1;
    _tableView.layer.shadowRadius = 4;
    _tableView.layer.cornerRadius = 10;
    _tableView.scrollEnabled = NO;
    self.interval = 3.0;
//    [_stackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)timer {
    self.currentRowIndex = self.currentRowIndex + 2;
    if (self.currentRowIndex >= self.items.count) {
        _currentRowIndex = 0;
        [self.tableView setContentOffset:CGPointZero animated:NO];
    }else {
        [self.tableView setContentOffset:CGPointMake(0, _currentRowIndex * 30) animated:YES];
    }
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 以无动画的形式跳到第1组的第0行
//    if (_currentRowIndex == _items.count) {
//        _currentRowIndex = 0;
//        [self.tableView setContentOffset:CGPointZero animated:NO];
//    }
}


#pragma mark - priviate method
- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    
    // 定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timer) userInfo:nil repeats:YES];
    _myTimer = timer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NSArray<BLTrainCoreNewsModel *> *)model {
    _model = model;
//    if (_stackView.subviews.count > 0) {
//        return;
//    }
//    if (_model.count > 0) {
//        BLTrainCoreNewsModel *newModel = [model firstObject];
//        _titleLabel0.text = [NSString stringWithFormat:@"◆%@", newModel.title];
//        _isHotImageView0.hidden = (newModel.isHot == 0);
//    }
//    if (_model.count > 1) {
//        BLTrainCoreNewsModel *newModel = model[1];
//        _titleLabel1.text = [NSString stringWithFormat:@"◆%@", newModel.title];
//        _isHotImageView1.hidden = (newModel.isHot == 0);
//    }
    [self.items removeAllObjects];
    
    [model enumerateObjectsUsingBlock:^(BLTrainCoreNewsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.cellHeight = 30;
            rowModel.data = obj;
            rowModel.identifier = @"BLTrainHotItemTableViewCell";
            rowModel;
        })];
    }];
    [self.manager reloadData];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.sectionModel];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLTrainCoreNewsModel *data = model.data;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectHot:)]) {
        [self.delegate didSelectHot:data];
    }
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.tableView = self.tableView;
        _manager.delegate = self;
    }
    return _manager;
}

- (ZLTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = [ZLTableViewSectionModel new];
        _sectionModel.items = _items;
    }
    return _sectionModel;
}

-(NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
