//
//  BLGapFillingViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLGapFillingViewController.h"
#import "BLTopicTextInputTableViewCell.h"

@interface BLGapFillingViewController ()<BLTopicTextInputTableViewCellDelegate>

@end

@implementation BLGapFillingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDataInit:(BLTopicModel *)model {
    NSMutableArray *rowModels = [NSMutableArray array];
    [rowModels addObjectsFromArray:self.topicTitleArray];
    if (model.fillNum == 0) {
        model.fillNum = 1;
    }
    
    [model.fillAnswer enumerateObjectsUsingBlock:^(BLFillTopicKeyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [rowModels addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLTopicTextInputTableViewCell";
            if (obj.value && obj.value.length > 0 && [obj.type isEqualToString:@"img"]) {
                rowModel.cellHeight = 94;
            }else {
                rowModel.cellHeight = 57;
            }
           rowModel.data = obj;
           rowModel.delegate = self;
           rowModel;
        })];
    }];
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
          }
       }];
    
    self.sectionModel.items = rowModels;
    [self.datas addObject:self.sectionModel];
}

- (void)textDidInput:(NSString *)string model:(BLFillTopicKeyModel *)model {
    if (string.length > 0) {
        [self sureButtonHide:NO];
    }else {
        [self sureButtonHide:YES];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeWithModel:)]) {
        [self.delegate didChangeWithModel:self.model];
    }
}

- (void)didImageInput:(UIImage *)image model:(BLFillTopicKeyModel *)model {
    model.image = image;
    model.type = image?@"img":@"";
    model.value = @"";
    [self.sectionModel.items enumerateObjectsUsingBlock:^(ZLTableViewRowModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:@"BLTopicTextInputTableViewCell"] && [model isEqual:obj.data]) {
            if (image) {
                obj.cellHeight = 94;
            }else {
                obj.cellHeight = 57;
            }
            *stop = YES;
        }
    }];
    [self.tableView reloadData];
    if (image) {
        [self sureButtonHide:NO];
    }else {
        [self sureButtonHide:YES];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeWithModel:)]) {
        [self.delegate didChangeWithModel:self.model];
    }
}


- (void)subCellDidSelectWithModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLTopicHelpTableViewCell"]) {
        if (self.model.isParsing) {
             return;
         }
        BLTopicOptionModel *optionModel = model.data;
        optionModel.isSelect = !optionModel.isSelect;
        self.model.isSelectHelp = optionModel.isSelect;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


@end
