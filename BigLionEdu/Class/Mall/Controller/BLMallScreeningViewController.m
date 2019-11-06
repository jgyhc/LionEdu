//
//  BLMallScreeningViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/31.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMallScreeningViewController.h"
#import "BLScreenHeaderCollectionReusableView.h"
#import "ZLCollectionViewDelegateManager.h"
#import "AdaptScreenHelp.h"
#import "BLGetLabelListAPI.h"
#import "BLScreeningModel.h"
#import <YYModel.h>
#import <NSArray+BlocksKit.h>

@interface BLMallScreeningViewController ()<ZLCollectionViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ZLCollectionViewDelegateManager *manager;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) BLGetLabelListAPI *getLabelListAPI;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) BLScreeningModel *currentTypeModel;
@property (nonatomic, strong) BLScreeningModel *currentDiscountModel;

@end

@implementation BLMallScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLScreenHeaderCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BLScreenHeaderCollectionReusableView"];
    self.leftConstraint.constant = [UIScreen mainScreen].bounds.size.width;
    [self.view layoutIfNeeded];
    self.datas = [NSMutableArray array];
    [self.manager reloadData];
    [self.getLabelListAPI loadData];
    [self show];
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

- (IBAction)sureEvent:(id)sender {
    ZLCollectionViewSectionModel *disType = self.datas[0];
    NSMutableArray <NSString *> *dtypeids = [disType.items bk_map:^id(ZLCollectionViewRowModel *item) {
        BLScreeningModel *obj = item.data;
        if (obj.isSelect) {
            return obj.Id;
        }
        return @"";
    }].mutableCopy;
    [dtypeids removeObject:@""];
    
    ZLCollectionViewSectionModel *types = self.datas[1];
    NSMutableArray <NSString *> *typesids = [types.items bk_map:^id(ZLCollectionViewRowModel *item) {
        BLScreeningModel *obj = item.data;
        if (obj.isSelect) {
            return obj.Id;
        }
        return @"";
    }].mutableCopy;
    [typesids removeObject:@""];
    
    [self.delegate BLMallScreeningViewController:[dtypeids componentsJoinedByString:@","] type:[typesids componentsJoinedByString:@","]];
    [self hide];
}

- (IBAction)hideEvent:(id)sender {
    [self hide];
}

- (IBAction)reSetEvent:(id)sender {
    
    [self.manager reloadData];
}

- (void)didSelectRowAtModel:(ZLCollectionViewRowModel *)model manager:(ZLCollectionViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    BLScreeningModel *thisModel = model.data;
    thisModel.isSelect = !thisModel.isSelect;
    [manager reloadData];
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getLabelListAPI isEqual:manager]) {
        return @{@"modelId": self.modelId?:@""};
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getLabelListAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray <BLScreeningModel *>*arr = [NSArray yy_modelArrayWithClass:[BLScreeningModel class] json:data[@"data"]];
            
            ZLCollectionViewSectionModel *sectionModel = [ZLCollectionViewSectionModel new];
            NSMutableArray *array = [NSMutableArray array];
            sectionModel.insets = UIEdgeInsetsMake(0, 10, 0, 10);
            sectionModel.minimumLineSpacing = 10;
            sectionModel.minimumInteritemSpacing = 10;
            sectionModel.headerIdentifier = @"BLScreenHeaderCollectionReusableView";
            sectionModel.headerSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - flexibleWidth(110), 40);
            sectionModel.headerData = @"折扣服务";
            
            [arr enumerateObjectsUsingBlock:^(BLScreeningModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
                rowModel.identifier = @"BLMallScreenCollectionViewCell";
                rowModel.cellSize = CGSizeMake(flexibleWidth(75), 28);
                if ([self.currentDisType isEqualToString:obj.Id]) {
                    obj.isSelect = YES;
                    self.currentDiscountModel = obj;
                }
                rowModel.data = obj;
                [array addObject:rowModel];
            }];
            sectionModel.items = array.copy;
            [self.datas addObject:sectionModel];
            [self bl_initScreeningType];
        }
    }
}


- (void)bl_initScreeningType {
    ZLCollectionViewSectionModel *sectionModel = [ZLCollectionViewSectionModel new];
    NSMutableArray *array = [NSMutableArray array];
    
    sectionModel.insets = UIEdgeInsetsMake(0, 10, 0, 10);
    sectionModel.minimumLineSpacing = 10;
    sectionModel.minimumInteritemSpacing = 10;
    sectionModel.headerIdentifier = @"BLScreenHeaderCollectionReusableView";
    sectionModel.headerSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - flexibleWidth(110), 40);
    sectionModel.headerData = @"类型";
    [array addObject:({
        ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
        rowModel.identifier = @"BLMallScreenCollectionViewCell";
        rowModel.cellSize = CGSizeMake(flexibleWidth(75), 28);
        rowModel.data = [[BLScreeningModel alloc] initWithId:@"0" label:@"书籍"];
        rowModel;
    })];
    [array addObject:({
        ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
        rowModel.identifier = @"BLMallScreenCollectionViewCell";
        rowModel.cellSize = CGSizeMake(flexibleWidth(75), 28);
        rowModel.data = [[BLScreeningModel alloc] initWithId:@"1" label:@"试卷"];
        rowModel;
    })];
    [array addObject:({
        ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
        rowModel.identifier = @"BLMallScreenCollectionViewCell";
        rowModel.cellSize = CGSizeMake(flexibleWidth(75), 28);
        rowModel.data = [[BLScreeningModel alloc] initWithId:@"2" label:@"直播"];
        rowModel;
    })];
    [array addObject:({
        ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
        rowModel.identifier = @"BLMallScreenCollectionViewCell";
        rowModel.cellSize = CGSizeMake(flexibleWidth(75), 28);
        rowModel.data = [[BLScreeningModel alloc] initWithId:@"3" label:@"套卷"];
        rowModel;
    })];
    [array addObject:({
        ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
        rowModel.identifier = @"BLMallScreenCollectionViewCell";
        rowModel.cellSize = CGSizeMake(flexibleWidth(75), 28);
        rowModel.data = [[BLScreeningModel alloc] initWithId:@"4" label:@"录播"];
        rowModel;
    })];
    for (ZLCollectionViewRowModel *obj in array) {
        BLScreeningModel *model = obj.data;
        if ([self.currentType containsString:model.Id]) {
            model.isSelect = YES;
            self.currentTypeModel = model;
        }
    }
    sectionModel.items = array;
    
    [self.datas addObject:sectionModel];
    [self.manager reloadData];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (ZLCollectionViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLCollectionViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.collectionView = self.collectionView;
    }
    return _manager;
}

- (BLGetLabelListAPI *)getLabelListAPI {
    if (!_getLabelListAPI) {
        _getLabelListAPI = [BLGetLabelListAPI new];
        _getLabelListAPI.mj_delegate = self;
        _getLabelListAPI.paramSource = self;
    }
    return _getLabelListAPI;
}




@end
