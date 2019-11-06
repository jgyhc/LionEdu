//
//  BLTrainMenuTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainMenuTableViewCell.h"
#import "BLTrainMenuItemView.h"

@interface BLTrainMenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (nonatomic, strong) NSArray * views;
@end

@implementation BLTrainMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_stackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)handlerMenuEvent:(UITapGestureRecognizer *)sender {
    BLTrainMenuItemView *view = (BLTrainMenuItemView *)sender.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectMenuWithModel:)]) {
        [self.delegate didSelectMenuWithModel:view.model];
    }
    
}

- (void)setModel:(NSArray<BLTrainIndexFunctionsModel *> *)model {
    _model = model;
    if (_stackView.subviews.count > 0) {
        return;
    }
    [model enumerateObjectsUsingBlock:^(BLTrainIndexFunctionsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.stackView addArrangedSubview:({
            BLTrainMenuItemView *view = [BLTrainMenuItemView new];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerMenuEvent:)];
            [view addGestureRecognizer:tap];
            view.model = obj;
            view;
        })];
    }];
}

@end
