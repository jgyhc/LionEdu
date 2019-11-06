//
//  BLQuestionsClassificationModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/30.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLQuestionsClassificationModel.h"
#import "BLPaperModel.h"
#import <YYModel.h>
#import <LCProgressHUD.h>

@implementation BLQuestionsClassificationModel



+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"id", @"Id"]};
}

- (void)reloadData {
    [self.getTestPaperQuestionAPI loadData];
}

+ (NSArray *)modelPropertyBlacklist {
  return @[@"getTestPaperQuestionAPI", @"delegate", @"currentRowModel", @"subCellModels", @"open"];
}

- (void)setGoodsId:(NSInteger)goodsId {
    NSLog(@"%ld", goodsId);
    _goodsId = goodsId;
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getTestPaperQuestionAPI isEqual:manager]) {
        return @{
                 @"modelId": @(_modelId),
                 @"functionTypeId": @(_Id),
                 @"pageNum":@1,
                 @"pageSize":@9000,
                 @"years": _years?_years:@"",
                 @"startYears":_startYears?_startYears:@"",
                 @"entYears": _entYears?_entYears:@"",
                 @"province": _province?_province:@"",
                 @"city": _city? _city:@"",
                 @"area": _area?_area:@"",
                 @"searchTitle":_searchTitle?_searchTitle:@""
                 };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getTestPaperQuestionAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSDictionary *dic = [data objectForKey:@"data"];
            NSArray<BLPaperModel *> *list = [NSArray yy_modelArrayWithClass:[BLPaperModel class] json:[dic objectForKey:@"list"]];
            if (list.count == 0) {
                [LCProgressHUD show:@"没找到相关数据"];
            }
            NSMutableArray *items = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(BLPaperModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.isAdvance = _isAdvance;
                obj.advanceDate = _advanceDate;
                ///  2019-10-24 这里修改了需求，本来可以单独购买，现在只能购买整套真题
                obj.goodsId = self.goodsId;
                obj.coverImg = self.img;
                obj.price = self.price;
                [items addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLQuestionBankItemTableViewCell";
                    rowModel.cellHeight = -1;
                    rowModel.data = obj;
                    rowModel;
                })];
            }];
            _subCellModels = items;
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateTableView)]) {
                [self.delegate updateTableView];
            }
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (void)BLQuestionBankHeaderTableViewCellSelect:(id)model {
    [self.delegate headerCellDidSelect:model];
}

- (BLGetTestPaperQuestionAPI *)getTestPaperQuestionAPI {
    if (!_getTestPaperQuestionAPI) {
        _getTestPaperQuestionAPI = [[BLGetTestPaperQuestionAPI alloc] init];
        _getTestPaperQuestionAPI.mj_delegate = self;
        _getTestPaperQuestionAPI.paramSource = self;
    }
    return _getTestPaperQuestionAPI;
}

- (ZLTableViewRowModel *)currentRowModel {
    if (!_currentRowModel) {
        _currentRowModel = ({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLQuestionBankHeaderTableViewCell";
            if ([_isAdvance isEqualToString:@"1"]) {
                rowModel.cellHeight = 80;
            }else {
                rowModel.cellHeight = 56;
            }
            rowModel.data = self;
            rowModel.delegate = self;
            rowModel;
        });
    }
    return _currentRowModel;
}

- (void)setImg:(NSString *)img {
    _img = [NSString stringWithFormat:@"%@%@", IMG_URL, img];
}

@end
