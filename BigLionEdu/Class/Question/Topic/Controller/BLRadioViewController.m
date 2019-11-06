//
//  BLRadioViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/20.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLRadioViewController.h"

@interface BLRadioViewController ()


@end

@implementation BLRadioViewController

- (void)viewDataInit:(BLTopicModel *)model {
    NSMutableArray *rowModels = [NSMutableArray array];
    [rowModels addObjectsFromArray:self.topicTitleArray];
    
    [model.optionList enumerateObjectsUsingBlock:^(BLTopicOptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.isDsj isEqualToString:@"1"]) {
            [rowModels addObject:({
                obj.value = @"?";
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLTopicHelpTableViewCell";
                rowModel.cellHeight = 50;
                rowModel.data = obj;
                rowModel;
            })];
        }else {
            [rowModels addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLTopicOptionTableViewCell";
                rowModel.cellHeight = -1;
                rowModel.delegate = self;
                rowModel.data = obj;
                rowModel;
            })];
        }
    }];
//    [rowModels addObject:({
//        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//        rowModel.identifier = @"BLTopicHelpTableViewCell";
//        rowModel.cellHeight = 50;
//        rowModel;
//    })];
    
    
    self.sectionModel.items = rowModels;
    [self.datas addObject:self.sectionModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)subCellDidSelectWithModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    
    if ([model.identifier isEqualToString:@"BLTopicOptionTableViewCell"] || [model.identifier isEqualToString:@"BLTopicHelpTableViewCell"]) {
        if (self.model.isParsing) {
            return;
        }
        [self sureButtonHide:NO];
        BLTopicOptionModel *optionModel = model.data;
        if ([self.model.currentTopicOptionModel isEqual:optionModel]) {
            return;
        }
        optionModel.isSelect = !optionModel.isSelect;
        if (optionModel.isSelect) {
            self.model.currentTopicOptionModel.isSelect = NO;
            self.model.currentTopicOptionModel = optionModel;
        }else {
            self.model.currentTopicOptionModel = nil;
        }
        [self.tableView reloadData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(radilDidFinishWithModel:)]) {
            [self.delegate radilDidFinishWithModel:self.model];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeWithModel:)]) {
            [self.delegate didChangeWithModel:self.model];
        }
    }
}

@end
