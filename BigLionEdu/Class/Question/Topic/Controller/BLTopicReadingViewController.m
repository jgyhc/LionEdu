//
//  BLTopicReadingViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/26.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTopicReadingViewController.h"
#import "AdaptScreenHelp.h"
#import "BLTopicTextModel.h"
#import "BLTopicImageModel.h"
#import "BLTopicMaterialImageTableViewCell.h"
#import <NSArray+BlocksKit.h>
#import "BLTopicVoiceModel.h"
#import "BLTopicVideoModel.h"

@interface BLTopicReadingViewController ()<BLTopicMaterialImageTableViewCellDelegate>

@end

@implementation BLTopicReadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.subTopicBaseViewController.materialTopicModel = self.model;
    [self addChildViewController:self.subTopicBaseViewController];
    [self.view addSubview:self.topicDragDropView];
    self.topicDragDropView.frame = CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 300);
    
}

- (void)viewDataInit:(BLTopicModel *)model {
    NSMutableArray *rowModels = [NSMutableArray array];
//    [rowModels addObject:({
//        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//        rowModel.identifier = @"BLTopicTitleTableViewCell";
//        rowModel.cellHeight = -1;
//        rowModel.data = model;
//        rowModel;
//    })];
//
//    [rowModels addObject:({
//        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//        rowModel.identifier = @"BLTopicSubjectTableViewCell";
//        rowModel.cellHeight = -1;
//        rowModel.data = model;
//        rowModel;
//    })];
//
    [model.materialArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BLTopicTextModel class]]) {
            [rowModels addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLTopicMaterialContentTableViewCell";
                rowModel.cellHeight = -1;
                rowModel.data = obj;
                rowModel;
            })];
        }
        if ([obj isKindOfClass:[BLTopicImageModel class]]) {
            [rowModels addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLTopicMaterialImageTableViewCell";
                rowModel.cellHeight = 100;
                rowModel.delegate = self;
                rowModel.data = obj;
                rowModel;
            })];
        }
        if ([obj isKindOfClass:[BLTopicVoiceModel class]]) {
            [rowModels addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLTopicAnalysisVoiceTableViewCell";
                rowModel.cellHeight = 80;
                rowModel.delegate = self;
                rowModel.data = obj;
                rowModel;
            })];
        }
        if ([obj isKindOfClass:[BLTopicVideoModel class]]) {
            [rowModels addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLTopicAnalysisVideoContentTableViewCell";
                rowModel.cellHeight = 164;
                rowModel.delegate = self;
                rowModel.data = obj;
                rowModel;
            })];
        }
    }];
    self.sectionModel.items = rowModels;
    [self.datas addObject:self.sectionModel];
}

- (void)updateCellHeightWithCell:(UITableViewCell *)tableViewCell model:(BLTopicImageModel *)model cellHeight:(CGFloat)cellHeight {
    ZLTableViewRowModel *rowModel = [self.sectionModel.items bk_match:^BOOL(ZLTableViewRowModel * obj) {
        return [obj.data isEqual:model];
    }];
    if (rowModel) {
        rowModel.cellHeight = cellHeight;
        [self.tableView reloadData];
    }
}


- (void)cellDidSelectWithModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLTopicOptionTableViewCell"]) {
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
        if ([self.model.currentTopicOptionModel.moption isEqualToString:@"A"]) {
            self.model.judgment = 1;
        }else {
            self.model.judgment = 0;
        }
        [self.tableView reloadData];
    }
}


@end
