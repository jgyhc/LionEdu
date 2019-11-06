//
//  BLAnswerReportListHeaderTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerReportListHeaderTableViewCell.h"
#import "JXCategoryTitleView.h"

@interface BLAnswerReportListHeaderTableViewCell ()<JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) NSArray * titles;

@end

@implementation BLAnswerReportListHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30, 30)];
    _categoryView.titleColor =  [UIColor colorWithRed:135/255.0 green:140/255.0 blue:151/255.0 alpha:1.0];
    _categoryView.titleSelectedColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:94/255.0 alpha:1.0];
    _categoryView.titleColorGradientEnabled = YES;
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.averageCellSpacingEnabled = NO;
    _categoryView.contentEdgeInsetLeft = 20;
    _categoryView.titleFont = [UIFont boldSystemFontOfSize:16];
    [_categoryView setBackgroundColor:[UIColor whiteColor]];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.delegate = self;
    [self.contentView addSubview:self.categoryView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (IBAction)topicEvent:(id)sender {
//    self.topicButton.selected = YES;
//    self.classButton.selected = NO;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTypeWithModel::)]) {
//        [self.delegate selectTypeWithModel:_model];
//    }
//}
//
//- (IBAction)classEvent:(id)sender {
//    self.topicButton.selected = NO;
//    self.classButton.selected = YES;
////    if (self.delegate && [self.delegate respondsToSelector:@selector(selectType:)]) {
////        [self.delegate selectType:1];
////    }
//}

#pragma mark -- JXCategoryViewDelegate method
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    BLAnswerReportQuestionListModel *model = _model[index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTypeWithModel:)]) {
        [self.delegate selectTypeWithModel:model];
    }
}

- (void)setModel:(NSArray<BLAnswerReportQuestionListModel *> *)model {
    _model = model;
    NSMutableArray *titles = [NSMutableArray array];
    [_model enumerateObjectsUsingBlock:^(BLAnswerReportQuestionListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.title?obj.title:@""];
    }];
    self.titles = titles;
    self.categoryView.titles = titles;
    [self.categoryView reloadData];
}



@end
