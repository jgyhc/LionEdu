//
//  BLQuestionScreeningViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/31.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLQuestionScreeningViewController.h"
#import "BLScreenHeaderCollectionReusableView.h"
#import "ZLCollectionViewDelegateManager.h"
#import "AdaptScreenHelp.h"
#import "BLScreeningModel.h"
#import <YYModel.h>
#import "BLAreaManager.h"
#import "BLScreeningItemModel.h"
#import "BLQuestionScreeningTimeCollectionViewCell.h"
#import "BLQuestionYearViewController.h"
#import "BLQuestionScreeningTopCollectionViewCell.h"

@interface BLQuestionScreeningViewController ()<ZLCollectionViewDelegateManagerDelegate, BLQuestionScreeningTimeCollectionViewCellDelegate, BLQuestionScreeningTopCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ZLCollectionViewDelegateManager *manager;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, copy) NSString * startTime;
@property (nonatomic, strong) NSMutableDictionary * intervalYear;

@property (nonatomic, strong) ZLCollectionViewSectionModel *areaSectionModel;

@property (nonatomic, strong) ZLCollectionViewSectionModel *yearsSectionModel;

@property (nonatomic, strong) NSMutableArray<BLScreeningItemModel *> *yearItems;

@property (nonatomic, strong) NSArray<BLAreaModel *>* provinces;

@property (nonatomic, strong) NSArray<BLAreaModel *>* citys;

@property (nonatomic, strong) NSArray<BLAreaModel *>* areas;

@property (nonatomic, strong) BLAreaModel *cityArea;

@property (nonatomic, strong) BLAreaModel *provincesArea;

@property (nonatomic, strong) BLScreeningItemModel *currentAreaItem;

@property (nonatomic, assign) NSInteger level;//当前选择的级数
@end

@implementation BLQuestionScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLQuestionScreeningAreaCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BLQuestionScreeningAreaCollectionReusableView"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLQuestionScreeningTopCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BLQuestionScreeningTopCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLQuestionScreeningItemCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BLQuestionScreeningItemCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLQuestionScreeningTimeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BLQuestionScreeningTimeCollectionViewCell"];
    
    self.leftConstraint.constant = [UIScreen mainScreen].bounds.size.width;
    [self.view layoutIfNeeded];
    self.datas = [NSMutableArray array];
    
    _provinces = [BLAreaManager sharedInstance].areaList;
    _citys = [BLAreaManager sharedInstance].provinceAreaModel.subAreas;
    _areas = [BLAreaManager sharedInstance].cityAreaModel.subAreas;
    _provincesArea = [BLAreaManager sharedInstance].provinceAreaModel;
    _cityArea = [BLAreaManager sharedInstance].cityAreaModel;
    _level = 3;
    
    [self.datas addObject:({
        ZLCollectionViewSectionModel *sectionModel = [ZLCollectionViewSectionModel new];
        sectionModel.items = @[({
            ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
            rowModel.identifier = @"BLQuestionScreeningTopCollectionViewCell";
            rowModel.cellSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - flexibleWidth(110), 70);
            rowModel.data = [BLAreaManager sharedInstance].cityAreaModel;
            rowModel.delegate = self;
            rowModel;
        })];
        sectionModel;
    })];
    
    [self.datas addObject:({
        ZLCollectionViewSectionModel *sectionModel = [ZLCollectionViewSectionModel new];
        _areaSectionModel = sectionModel;
        NSMutableArray *items = [NSMutableArray array];
        sectionModel.items = items;
        sectionModel.headerSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - flexibleWidth(110), 40);
        sectionModel.headerIdentifier = @"BLQuestionScreeningAreaCollectionReusableView";
        sectionModel.headerData = @"区县";
        sectionModel.minimumLineSpacing = flexibleWidth(9);
        sectionModel.minimumInteritemSpacing = flexibleWidth(9);
        sectionModel.insets = UIEdgeInsetsMake(0, flexibleWidth(9), 0, flexibleWidth(9));
        [_areas enumerateObjectsUsingBlock:^(BLAreaModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [items addObject:({
                BLScreeningItemModel *model = ({
                    BLScreeningItemModel *model = [BLScreeningItemModel new];
                    model.title = obj.areaName;
                    model;
                });
                CGFloat width = model.textWidth + 20;
                ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
                rowModel.identifier = @"BLQuestionScreeningItemCollectionViewCell";
                rowModel.cellSize = CGSizeMake(MAX(flexibleWidth(75), width), flexibleWidth(28));
                rowModel.data = model;
                rowModel;
            })];
        }];
        sectionModel;
    })];
    
    [self.datas addObject:({
        ZLCollectionViewSectionModel *sectionModel = [ZLCollectionViewSectionModel new];
        _yearsSectionModel = sectionModel;
        NSMutableArray *items = [NSMutableArray array];
        sectionModel.items = items;
        sectionModel.headerSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - flexibleWidth(110), 40);
        sectionModel.headerIdentifier = @"BLQuestionScreeningAreaCollectionReusableView";
        sectionModel.headerData = @"年份";
        sectionModel.minimumLineSpacing = flexibleWidth(9);
        sectionModel.minimumInteritemSpacing = flexibleWidth(9);
        sectionModel.insets = UIEdgeInsetsMake(0, flexibleWidth(9), 0, flexibleWidth(9));
        NSArray *yearList = @[@"2019", @"2018", @"2017", @"2016", @"2015", @"2014"];
        [yearList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [items addObject:({
                ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
                rowModel.identifier = @"BLQuestionScreeningItemCollectionViewCell";
                rowModel.cellSize = CGSizeMake(flexibleWidth(75), flexibleWidth(28));
                rowModel.data = ({
                    BLScreeningItemModel *model = [BLScreeningItemModel new];
                    model.title = obj;
                    model;
                });
                rowModel;
            })];
        }];
        [items addObject:({
            ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
            rowModel.identifier = @"BLQuestionScreeningTimeCollectionViewCell";
            rowModel.cellSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - flexibleWidth(128), 40);
            rowModel.data = self.intervalYear;
            rowModel.delegate = self;
            rowModel;
        })];
        
        
        sectionModel;
    })];
    [self.manager reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself show];
    });
}

- (void)didClickBackEvent {
    _currentAreaItem = nil;
    if (_level == 1) {
        return;
    }
    NSArray *list;
    if (_level == 3) {
        list = _citys;
    }
    if (_level == 2) {
        list = _provinces;
    }
    _level --;
    [self selectAreaList:list];
}

- (void)selectAreaList:(NSArray *)list {
    NSMutableArray *items = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(BLAreaModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [items addObject:({
           BLScreeningItemModel *model = ({
               BLScreeningItemModel *model = [BLScreeningItemModel new];
               model.title = obj.areaName;
               model.model = obj;
               model;
           });
           CGFloat width = model.textWidth + 20;
           ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
           rowModel.identifier = @"BLQuestionScreeningItemCollectionViewCell";
           rowModel.cellSize = CGSizeMake(MAX(flexibleWidth(75), width), flexibleWidth(28));
           rowModel.data = model;
           rowModel;
       })];
    }];
    _areaSectionModel.items = items;
    [self.manager reloadData];
}

#pragma mark -- BLQuestionScreeningTimeCollectionViewCellDelegate
- (void)startTimeEvent:(NSString *)currentYear {
    BLQuestionYearViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionYearViewController"];
    viewController.endYear = [_intervalYear objectForKey:@"endYear"];
    __weak typeof(self) wself = self;
    [viewController setBlock:^(NSString * _Nonnull year) {
        [wself.intervalYear setObject:year forKey:@"startYear"];
        [wself.collectionView reloadData];
    }];
    [self presentViewController:viewController animated:NO completion:nil];
}

- (void)endTimeEvent:(NSString *)currentYear {
    BLQuestionYearViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLQuestionYearViewController"];
    viewController.startYear = [self.intervalYear objectForKey:@"startYear"];
    __weak typeof(self) wself = self;
    [viewController setBlock:^(NSString * _Nonnull year) {
        [wself.intervalYear setObject:year forKey:@"endYear"];
        [wself.collectionView reloadData];
    }];
    [self presentViewController:viewController animated:NO completion:nil];
}

- (void)show {
    self.leftConstraint.constant = flexibleWidth(110);
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hide {
    self.leftConstraint.constant = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (NSArray<ZLCollectionViewSectionModel *> *)dataSource:(ZLCollectionViewDelegateManager *)manager {
    return self.datas;
}


- (void)didSelectRowAtModel:(ZLCollectionViewRowModel *)model manager:(ZLCollectionViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLQuestionScreeningItemCollectionViewCell"]) {
        if (indexPath.section == 1) {
            BLScreeningItemModel *item = model.data;
            BLAreaModel *area = item.model;
            if (area.subAreas && area.subAreas.count > 0) {
                _level ++;
                if (_level == 3) {
                    _citys = _provincesArea.subAreas;
                    _cityArea = area;
                }
                if (_level == 2) {
                    _provincesArea = area;
                }
                [self selectAreaList:area.subAreas];
            }else {
                _currentAreaItem.select = NO;
                item.select = YES;
                _currentAreaItem = item;
                [self.collectionView reloadData];
            }
        }
        if (indexPath.section == 2) {
            BLScreeningItemModel *info = model.data;
            info.select = !info.select;
            if (info.select == YES) {
                [self.yearItems addObject:info];
            }else {
                [self.yearItems removeObject:info];
            }
            [self.collectionView reloadData];
        }
        
    }
}


- (IBAction)sureEvent:(id)sender {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    if (_intervalYear) {
        [info setObject:_intervalYear forKey:@"intervalYear"];
    }
    
    if (_currentAreaItem) {
        [info setObject:_currentAreaItem.title forKey:@"area"];
        [info setObject:_cityArea.areaName?_cityArea.areaName:@"" forKey:@"city"];
        [info setObject:_provincesArea.areaName?_provincesArea.areaName:@"" forKey:@"province"];
    }
    if (_yearItems) {
        NSMutableArray *years = [NSMutableArray array];
        [_yearItems enumerateObjectsUsingBlock:^(BLScreeningItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [years addObject:obj.title];
        }];
        [info setObject:years forKey:@"years"];
    }
    if (self.didSelectScreenHanlder) {
        self.didSelectScreenHanlder(info);
    }
    
    [self hide];
}

- (IBAction)hideEvent:(id)sender {
    [self hide];
}

- (IBAction)reSetEvent:(id)sender {
    [_intervalYear  setObject:@"" forKey:@"startYear"];
    [_intervalYear  setObject:@"" forKey:@"endYear"];
    _currentAreaItem = nil;
    [_yearItems removeAllObjects];
    [self.datas enumerateObjectsUsingBlock:^(ZLCollectionViewSectionModel *  _Nonnull sectionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionModel.items enumerateObjectsUsingBlock:^(ZLCollectionViewRowModel * _Nonnull rowModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([rowModel.data isKindOfClass:[BLScreeningItemModel class]]) {
                BLScreeningItemModel *item = rowModel.data;
                item.select = NO;
            }
        }];
    }];
    [self.collectionView reloadData];
}


- (ZLCollectionViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLCollectionViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.collectionView = self.collectionView;
    }
    return _manager;
}

- (NSMutableDictionary *)intervalYear {
    if (!_intervalYear) {
        _intervalYear = [NSMutableDictionary dictionary];
    }
    return _intervalYear;
}

- (NSMutableArray<BLScreeningItemModel *> *)yearItems {
    if (!_yearItems) {
        _yearItems = [NSMutableArray array];
    }
    return _yearItems;
}

@end
