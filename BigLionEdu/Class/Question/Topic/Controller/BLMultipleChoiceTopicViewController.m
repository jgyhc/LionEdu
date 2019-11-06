//
//  BLMultipleChoiceTopicViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMultipleChoiceTopicViewController.h"

@interface BLMultipleChoiceTopicViewController ()

@end

@implementation BLMultipleChoiceTopicViewController


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
        BLTopicOptionModel *optionModel = model.data;
        optionModel.isSelect = !optionModel.isSelect;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if (optionModel.isSelect) {
            [self.model.currentTopicOptionModels addObject:optionModel];
        }else {
            [self.model.currentTopicOptionModels removeObject:optionModel];
        }
        [self sureButtonHide:self.model.currentTopicOptionModels.count == 0];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeWithModel:)]) {
            [self.delegate didChangeWithModel:self.model];
        }
    }
}


@end
